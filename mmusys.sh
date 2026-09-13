#!/usr/bin/env sh

set -e

dnf copr enable -y mmu/mmu-dist-rpms

dnf install -y \
  git ansible make patch \
  gh git git-subtree graphviz java jq neovim \
  okular openssl pandoc-cli parallel podman pre-commit \
  python3-pip sshuttle tig uv weasyprint yq \
  shfmt

test -n "$DISPLAY" && dnf install -y \
  fira-code-fonts firefox parcellite xsel xset

dnf remove -y nano-default-editor
