#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$SCRIPT_DIR/files"

cat >~/.tar-exclude <<'EOF'
./.tar-exclude
./.cache
./.local/bin/
./.local/lib/
./.local/state/
./.bash_logout
./.bash_profile
./.bashrc
./thinclient_drives
./.bashrc.d
./.config/nvim
EOF

if test -n "$DISPLAY"; then
	cat >>~/.tar-exclude <<'EOF'
./.config/parcellite/parcelliterc
./.config/i3
./.Xresources
./.xsession
EOF
fi

rsync -avc $1 "$FILES_DIR/_bashrc.d/" ~/.bashrc.d/
rsync -avc $1 "$FILES_DIR/_config/git/" ~/.config/git/
rsync -avc $1 "$FILES_DIR/_config/gh/" ~/.config/gh/
rsync -avc $1 --delete "$FILES_DIR/_config/opencode/skills/" ~/.config/opencode/skills/
rsync -avc $1 "$FILES_DIR/_config/opencode/opencode.jsonc" ~/.config/opencode/opencode.jsonc
rsync -avc $1 "$FILES_DIR/_config/pandoc/" ~/.local/share/pandoc/

mkdir -p ~/.config/nvim/autoload
curl -fSL -o ~/.config/nvim/autoload/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
rsync -avc $1 "$FILES_DIR/_config/nvim/init.vim" ~/.config/nvim/init.vim

mkdir -p ~/.local/share/java
PLANTUML_TAG=$(curl -s https://api.github.com/repos/plantuml/plantuml/releases/latest | jq -r .tag_name)
curl -fSL -o ~/.local/share/java/plantuml.jar \
	"https://github.com/plantuml/plantuml/releases/download/${PLANTUML_TAG}/plantuml.jar"

if test -n "$DISPLAY"; then
	rsync -avc $1 "$FILES_DIR/parcelliterc" ~/.config/parcellite/parcelliterc
	rsync -avc $1 "$FILES_DIR/_Xresources" ~/.Xresources
	rsync -avc $1 "$FILES_DIR/_xsession" ~/.xsession

	mkdir -p ~/.config/i3
	patch --verbose -fr- $1 -p0 --directory "$HOME" <"$FILES_DIR/_config/i3/config.patch" || true
fi
