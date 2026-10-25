Set-PSReadLineOption -EditMode Vi
Set-PSReadlineKeyHandler -Key Tab -Function Complete
function prompt { 
    $host.ui.RawUI.WindowTitle = "$(Split-Path -Leaf (Get-Location))"
    "> " 
}
$env:EDITOR = 'nvim'
