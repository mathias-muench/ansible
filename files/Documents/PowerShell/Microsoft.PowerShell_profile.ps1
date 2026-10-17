Get-ChildItem (Join-Path (Split-Path $PROFILE) profile.d) -Filter *.ps1 | Sort-Object Name | ForEach-Object { . $_.FullName }
