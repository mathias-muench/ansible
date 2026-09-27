#!/bin/bash

set -eo pipefail

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

rsync -vc --mkpath $1 ./files/_bashrc.d/* ~/.bashrc.d/
rsync -vc --mkpath $1 ./files/_Xresources ~/.Xresources
rsync -vc --mkpath $1 --executability ./files/_xsession ~/.xsession
rsync -rvc --mkpath $1 ./files/_config/ ~/.config/
rsync -rvc --mkpath $1 ./files/_local/ ~/.local/


mkdir -p ~/.config/nvim/autoload
curl -fSL -o ~/.config/nvim/autoload/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.local/share/java
PLANTUML_TAG=$(curl -s https://api.github.com/repos/plantuml/plantuml/releases/latest | jq -r .tag_name)
curl -fSL -o ~/.local/share/java/plantuml.jar \
	"https://github.com/plantuml/plantuml/releases/download/${PLANTUML_TAG}/plantuml.jar"

bun add --global --dev --exact prettier@latest
bun add --global --exact @fission-ai/openspec@latest
$HOME/.bun/bin/openspec completion install bash

patch --verbose -fr- $1 -p0 --directory $HOME <./patches/_config/i3/config.patch || true
