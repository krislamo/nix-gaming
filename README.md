<!--
SPDX-FileCopyrightText: 2026 Kris Lamoureux <kris@lamoureux.io>
SPDX-License-Identifier: 0BSD
-->

# nix-gaming

NixOS gaming VM, running under Proxmox with GPU passthrough.

This is **not a generic template**; it's the actual config for my specific
gaming-focused VM. The goal is to keep as much of this machine's setup as
possible here.

### Features

- **Desktop** — KDE Plasma on Wayland
- **GPU** — NVIDIA GPU drivers
- **Kernel** — Linux 7.x
- **Boot** — EFI boot via systemd-boot
