Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$directory = Join-Path ([IO.Path]::GetTempPath()) ('coverage-gate-' + [guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $directory | Out-Null
$reportPath = Join-Path $directory 'coverage.cobertura.xml'
$gate = Join-Path $PSScriptRoot 'Assert-BackendCoverage.ps1'

try {
    foreach ($case in @(
        @{ Rate = '1'; MissingLayer = $false; Accept = $true },
        @{ Rate = '0.80'; MissingLayer = $false; Accept = $true },
        @{ Rate = '0.79'; MissingLayer = $false; Accept = $false },
        @{ Rate = 'NaN'; MissingLayer = $false; Accept = $false },
        @{ Rate = '1'; MissingLayer = $true; Accept = $false }
    )) {
        $document = [xml] '<coverage><packages /></coverage>'
        foreach ($layer in @('Domain', 'Application', 'Infrastructure')) {
            if ($case.MissingLayer -and $layer -eq 'Infrastructure') {
                continue
            }
            $package = $document.CreateElement('package')
            $package.SetAttribute('name', "VacationManagement.$layer")
            $package.SetAttribute('line-rate', $case.Rate)
            $document.DocumentElement.FirstChild.AppendChild($package) | Out-Null
        }
        $document.Save($reportPath)
        $accepted = $true
        try { & $gate -ResultsDirectory $directory | Out-Null } catch { $accepted = $false }
        if ($accepted -ne $case.Accept) {
            throw "Unexpected coverage gate result: $($case.Rate), missing=$($case.MissingLayer)."
        }
    }
    Remove-Item -LiteralPath $reportPath
    $accepted = $true
    try { & $gate -ResultsDirectory $directory | Out-Null } catch { $accepted = $false }
    if ($accepted) { throw 'Coverage gate accepted a missing report.' }
    Write-Output 'PASS: six coverage gate cases, including below threshold and missing evidence.'
}
finally {
    Remove-Item -LiteralPath $directory -Recurse -Force
}