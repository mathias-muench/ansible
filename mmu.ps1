param(
    [switch]$DryRun
)

$L = if ($DryRun) { "/L" } else { $null }

& robocopy "$PSScriptRoot\files\_config\opencode" "$env:USERPROFILE\.config\opencode" /E /NJH /NJS $L
& robocopy "$PSScriptRoot\files\_config\git" "$env:APPDATA\Git" /E /NJH /NJS $L
& robocopy "$PSScriptRoot\files\+APPDATA\Thunderbird" "$env:APPDATA\Thunderbird" /E /NJH /NJS $L
& robocopy "$PSScriptRoot\files\Documents\PowerShell" "$(Split-Path $PROFILE)" /E /NJH /NJS $L
& robocopy "$PSScriptRoot\files\Documents\Condor3\Pilots" "$env:USERPROFILE\Documents\Condor3\Pilots" /E /NJH /NJS $L

New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\nvim\autoload"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -OutFile "$env:LOCALAPPDATA\nvim\autoload\plug.vim"
& robocopy "$PSScriptRoot\files\_config\nvim" "$env:LOCALAPPDATA\nvim" init.vim /NJH /NJS $L
& robocopy "$PSScriptRoot\files\+APPDATA\jupyter" "$env:APPDATA\jupyter" /E /NJH /NJS $L

bun add --global --dev --exact prettier@latest
bun add --global --exact @fission-ai/openspec@latest
$env:PROFILE = $PROFILE
openspec completion install powershell

Get-Command scoop -ErrorAction Ignore || Invoke-RestMethod get.scoop.sh | Invoke-Expression -Verbose
scoop bucket add main
scoop bucket add extras
scoop bucket add mmu https://github.com/mathias-muench/scoop-mmu.git
scoop update
scoop update *
