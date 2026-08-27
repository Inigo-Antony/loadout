---
name: infra-containers
description: Operating instructions for containerisation, dev environments, and basic networking. Covers Docker and Podman, rootless and rootful, dev and prod. Apply for any project involving containers, multi-service orchestration, or system-level work.
---

# Networking & Infrastructure

## Engines

- **Docker** — most ubiquitous; Docker Desktop on macOS/Windows, Docker Engine on Linux.
- **Podman** — daemonless, rootless by default, drop-in CLI compatibility with Docker (`alias docker=podman` works for most flows). Strong choice on Fedora / RHEL-family.
- **Containerd / nerdctl** — when you need Kubernetes-shaped runtime semantics locally.

When generating commands, use `docker` syntax unless the user is explicitly on Podman; Podman aliases the same verbs. Note divergences explicitly when they exist (notably the socket path: `/var/run/docker.sock` vs `/run/user/$UID/podman/podman.sock`).

## Container hygiene

- **One process per container.** A web app and its database go in *separate* containers, joined by a network. Don't run init systems inside containers unless you have a real reason.
- **Pin tags.** `python:3.12-slim`, never `python:latest`. Floating tags break builds silently.
- **Non-root user inside the container.** `USER 1000` after installing dependencies. Especially important on rootless engines where this aligns with rootless host execution.
- **Multi-stage builds** for any compiled language, and for Node apps where dev dependencies bloat the final image.
- **`.dockerignore`** present and accurate. `node_modules`, `.git`, `*.pyc`, `.env` excluded at minimum.

## Compose files

- `docker-compose.yml` (works with `podman-compose` or `podman compose`).
- One per environment: `compose.dev.yml`, `compose.prod.yml`. Don't conditionally branch a single file.
- Named volumes for data; bind mounts only for source code in dev.
- Networks named explicitly (`backend`, `frontend`); avoid relying on the default network.
- Health checks on every service — `compose` won't restart unhealthy services without them.

## Rootless containers (Podman, rootless Docker)

- UID/GID mapping: container UID 1000 maps to your host UID by default; container UID 0 maps to a sub-UID. Files written by container root won't be owned by host root — they'll be owned by an unprivileged sub-UID.
- Port binding below 1024 needs `sysctl net.ipv4.ip_unprivileged_port_start=80` or use ports ≥ 1024.
- SELinux (Fedora / RHEL / Rocky): bind mounts may need `:Z` (private relabel) or `:z` (shared relabel) suffixes. `-v ./src:/app/src:Z`
- `podman generate systemd` to convert running containers into user systemd units for boot-time start. For rootless Docker, use systemd user units directly.

## Dev environment patterns

- **devcontainer.json** when collaborating across OSes — VS Code / Cursor / Claude Code pick it up automatically.
- **Make** or **just** as a task runner: `just up`, `just test`, `just deploy`. One file documents how to do everything.
- **Direnv + .envrc** for per-project environment activation; commit `.envrc` (not `.env`) with non-secret defaults.

## Networking basics (when you need them)

- `curl -v` is the first debug tool, before any logging
- `dig`, `nslookup` for DNS — assume DNS is the problem until proven otherwise
- `ss -tlnp` (Linux) / `lsof -i -P` (macOS) for what's listening on which port
- `tcpdump` / `wireshark` only when you've exhausted application-layer logs
- Firewalls: `firewalld` (Fedora/RHEL), `ufw` (Debian/Ubuntu), `pf` (macOS), Windows Firewall. Default-deny, allow-list services.

## Reverse proxies

- **Caddy** for almost everything. Auto-TLS, simple config, hard to misconfigure.
- **nginx** when Caddy isn't an option — but write configs from scratch; copy-pasted configs from Stack Overflow accumulate cruft.
- **Traefik** when running container-orchestration with auto-discovery (Docker Swarm, k8s).

## Monitoring (lightweight)

For self-hosted single-server setups:
- **Loki + Grafana + Promtail** for logs
- **Prometheus + Grafana + node-exporter** for metrics
- Alert on disk full, certificate expiry, service down — these three catch 80% of self-host disasters

Don't deploy monitoring stacks before the workload exists.

## Backup discipline

- Back up *data*, not containers. Volumes get backed up; images can be rebuilt.
- 3-2-1: three copies, two media, one offsite.
- Test restore at least once. An untested backup is a hope.

## Anti-patterns

- Running containers as root without a reason
- `latest` tags in production
- Bind-mounting the Docker / Podman socket into a container that doesn't need it (security hole — equivalent to giving that container root on the host)
- Storing secrets in image layers
- Ignoring SELinux warnings — relabel or set context, don't disable
- Building on one OS and deploying on another without testing the image on the deploy target

## See also

- `domains/backend-saas.md` — for the application running in the containers
