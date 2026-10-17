$completionScript = Join-Path (Split-Path $PROFILE) OpenSpecCompletion.ps1
if (Test-Path $completionScript) { . $completionScript }
