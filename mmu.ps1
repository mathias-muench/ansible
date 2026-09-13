param(
    [switch]$DryRun
)

$L = if ($DryRun) { "/L" } else { $null }

& robocopy "$PSScriptRoot\files\_config\opencode\skills" "$env:USERPROFILE\.config\opencode\skills" /NJH /NJS $L
& robocopy "$PSScriptRoot\files\_config\opencode" "$env:USERPROFILE\.config\opencode" opencode.jsonc /NJH /NJS $L
