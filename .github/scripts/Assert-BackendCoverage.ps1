param(
    [Parameter(Mandatory)]
    [string] $ResultsDirectory
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$reports = @(Get-ChildItem -LiteralPath $ResultsDirectory -Filter 'coverage.cobertura.xml' -Recurse)
if ($reports.Count -eq 0) {
    throw 'No unit coverage report was produced.'
}

$measured = @{}
foreach ($report in $reports) {
    [xml] $document = Get-Content -LiteralPath $report.FullName -Raw
    $packages = @($document.SelectNodes('/coverage/packages/package'))
    if ($packages.Count -eq 0) {
        throw 'Coverage report contains no measured packages.'
    }
    foreach ($package in $packages) {
        $name = $package.GetAttribute('name')
        $rate = [decimal]::Parse($package.GetAttribute('line-rate'), [Globalization.CultureInfo]::InvariantCulture)
        if ($rate -lt 0.80 -or $rate -gt 1) {
            throw "Unit line coverage for $name is $rate; required range is 0.80 to 1.00."
        }
        $measured[$name] = $true
    }
}

foreach ($required in @('VacationManagement.Domain', 'VacationManagement.Application', 'VacationManagement.Infrastructure')) {
    if (-not $measured.ContainsKey($required)) {
        throw "Missing unit coverage for $required."
    }
}
Write-Output 'PASS: all measured unit packages have at least 80 percent line coverage.'