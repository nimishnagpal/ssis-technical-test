
$start_at = "2011-01-01" #$args[0]
$end_at = "2015-01-01" #$args[1]
$base = "USD"
$symbols = "NZD"
$fxrate =  (Invoke-RestMethod -Method GET -Uri "https://api.exchangeratesapi.io/history?start_at=$start_at&end_at=$end_at&base=$base&&symbols=$symbols").rates;
# $fxrate |Select-Object -First 1

$Properties = $fxrate.PSObject.Properties
        $Row = ($Properties | Select-Object -First 1).Value
$fxrates = $Properties | Select-Object -Skip 1 | ForEach-Object {
           [PSCustomObject]@{date = $_.Name -replace "-",""; FromCurrency = $base; ToCurrency = $symbols; fxRate = $_.Value.NZD} } | Sort-Object -Property date

#$start = (Get-Date $start_at).AddDays(1).ToShortDateString()
#$dates = While ($start -lt $end_at) {   [PSCustomObject]@{date = $start }
#                                        $start = (Get-Date $start).AddDays(1).ToShortDateString()  } 

$filePath = Split-Path $MyInvocation.MyCommand.Path -Parent
$filePath = "$filePath\fxrate.csv"

$fxrates | Export-Csv -Path $filePath  -Force -NoTypeInformation

$filePath

