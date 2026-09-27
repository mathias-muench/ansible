#!/bin/bash

set -euo pipefail

dry_run=${1:-}

cd $(dirname "${BASH_SOURCE[0]}")

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
./.config/parcellite/parcelliterc
./.config/i3
./.Xresources
./.xsession
EOF

rsync -vc --mkpath $dry_run ./files/_bashrc.d/* ~/.bashrc.d/
rsync -vc --mkpath $dry_run ./files/_Xresources ~/.Xresources
rsync -vc --mkpath $dry_run --executability ./files/_xsession ~/.xsession
rsync -rvc --mkpath $dry_run ./files/_config/ ~/.config/
rsync -rvc --mkpath $dry_run ./files/_local/ ~/.local/

mkdir -p ~/.config/nvim/autoload
curl -fSL -o ~/.config/nvim/autoload/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.local/share/java
set -- $(curl -s https://api.github.com/repos/plantuml/plantuml/releases/latest | jq -r '.tag_name, .published_at')
if [[ ! -f ~/.local/share/java/plantuml.jar ]] || (($(date -ud "$2" +%s) > $(date -r ~/.local/share/java/plantuml.jar +%s))); then
	curl -fSL -o ~/.local/share/java/plantuml.jar "https://github.com/plantuml/plantuml/releases/download/$1/plantuml.jar"
fi

bun add --global --dev --exact prettier@latest
bun add --global --exact @fission-ai/openspec@latest
$HOME/.bun/bin/openspec completion install bash

patch --verbose -fr- $dry_run -p0 --directory $HOME <./patches/_config/i3/config.patch || true
