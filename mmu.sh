#!/bin/bash

set -euo pipefail

dry_run=${1:-}

cd $(dirname "${BASH_SOURCE[0]}")

cat >$HOME/.tar-exclude <<'EOF'
./thinclient_drives
EOF

cachedir_tag="Signature: 8a477f597d8806b69e8bc95c1d6bf384"

test -d $HOME/.cache && echo "$cachedir_tag" >$HOME/.cache/CACHEDIR.TAG

rsync -rvc $dry_run /etc/skel/ $HOME/
rsync -rvc --mkpath $dry_run ./files/_bashrc.d/ $HOME/.bashrc.d/
test -d $HOME/.bashrc.d && echo "$cachedir_tag" >$HOME/.bashrc.d/CACHEDIR.TAG
rsync -vc --mkpath $dry_run ./files/_Xresources $HOME/.Xresources
rsync -vc --mkpath $dry_run --executability ./files/_xsession $HOME/.xsession

rsync -rvc --mkpath $dry_run ./files/_config/ $HOME/.config/
test -d $HOME/.config/opencode && echo "$cachedir_tag" >$HOME/.config/opencode/CACHEDIR.TAG
rsync -rvc --mkpath $dry_run ./files/_local/ $HOME/.local/
test -d $HOME/.local/share/pandoc && echo "$cachedir_tag" >$HOME/.local/share/pandoc/CACHEDIR.TAG

mkdir -p $HOME/.config/nvim/autoload
curl -fSL -o $HOME/.config/nvim/autoload/plug.vim \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p $HOME/.local/share/java
set -- $(curl -s https://api.github.com/repos/plantuml/plantuml/releases/latest | jq -r '.tag_name, .published_at')
if [[ ! -f $HOME/.local/share/java/plantuml.jar ]] || (($(date -ud "$2" +%s) > $(date -r $HOME/.local/share/java/plantuml.jar +%s))); then
	curl -fSL -o $HOME/.local/share/java/plantuml.jar "https://github.com/plantuml/plantuml/releases/download/$1/plantuml.jar"
fi

bun add --global --dev --exact prettier@latest
bun add --global --exact @fission-ai/openspec@latest
$HOME/.bun/bin/openspec completion install bash

patch --verbose -fr- $dry_run -p0 --directory $HOME <./patches/_config/i3/config.patch || true
