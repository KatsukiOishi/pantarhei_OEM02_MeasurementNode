param(
    [string]$HtmlPath = "docs/Deliverables/customer-proposal.html",
    [string]$PdfPath = "docs/Deliverables/customer-proposal.pdf"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$html = [System.IO.Path]::GetFullPath((Join-Path $root $HtmlPath))
$pdf = [System.IO.Path]::GetFullPath((Join-Path $root $PdfPath))
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$chromeProfile = Join-Path $env:TEMP "pantarhei-proposal-chrome"

if (-not (Test-Path -LiteralPath $html)) {
    throw "HTML source not found: $html"
}

if (-not (Test-Path -LiteralPath $chrome)) {
    throw "Google Chrome not found: $chrome"
}

$htmlUri = [System.Uri]::new($html).AbsoluteUri
if (Test-Path -LiteralPath $pdf) {
    Remove-Item -LiteralPath $pdf -Force
}

$arguments = @(
    "--headless=new",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--no-pdf-header-footer",
    "--user-data-dir=$chromeProfile",
    "--print-to-pdf=$pdf",
    $htmlUri
)

$process = Start-Process `
    -FilePath $chrome `
    -ArgumentList $arguments `
    -WindowStyle Hidden `
    -Wait `
    -PassThru

if ($process.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $pdf)) {
    throw "PDF generation failed"
}

Get-Item -LiteralPath $pdf | Select-Object FullName, Length, LastWriteTime
