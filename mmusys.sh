#!/usr/bin/env sh

set -e

dnf copr enable -y mmu/mmu-dist-rpms

dnf upgrade -y \
  git ansible make patch python3-github3py \
  buildah gh git git-subtree glab graphviz java jq neovim \
  okular openssl pandoc-cli parallel podman pre-commit \
  python3-pip rcs sshuttle tig uv weasyprint yq

test -n "$DISPLAY" && dnf install -y \
  fira-code-fonts firefox parcellite xsel xset

dnf remove -y nano-default-editor
