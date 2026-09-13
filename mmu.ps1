param(
    [switch]$DryRun
)

$L = if ($DryRun) { "/L" } else { $null }

& robocopy "$PSScriptRoot\files\_config\opencode\skills" "$env:USERPROFILE\.config\opencode\skills" /NJH /NJS $L
& robocopy "$PSScriptRoot\files\_config\opencode" "$env:USERPROFILE\.config\opencode" opencode.jsonc /NJH /NJS $L

New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\nvim\autoload"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -OutFile "$env:LOCALAPPDATA\nvim\autoload\plug.vim"
& robocopy "$PSScriptRoot\files\_config\nvim" "$env:LOCALAPPDATA\nvim" init.vim /NJH /NJS $L
