Function cport ($srv,$port,$ms=500) {
<#
.SYNOPSIS
Connection Check Port 1.3
Import-Module CPort
Using Class .NET: System.Net.Sockets.TcpClient
Method: BeginConnect
Using ThreadJob (Get-Module ThreadJob)
.DESCRIPTION
Example:
cport 192.168.1.10 443
cport 192.168.1.10 22,3389
cport 192.168.1.10 20-70
cport 192.168.1.0 80
cport 192.168.1.0 80 100
.LINK
https://github.com/Lifailon/CPort
#>
if (!$port) {
Write-Host (Get-Help cport).DESCRIPTION.Text -ForegroundColor Cyan
return
}
if ($srv -match "\.0$") {
$replace = $srv -replace "0$"
$srv = 1..254 | foreach {$replace+$_}
}
if ($port -match "-") {
$port = $port -split "-"
$start = $port[0]
$end = $port[1]
$port = $start..$end
}
$start_time = Get-Date
foreach($s in [array]$srv) {
foreach($p in [array]$port) {
(Start-ThreadJob {
$Socket = New-Object System.Net.Sockets.TcpClient
$Connect = $Socket.BeginConnect($using:s,$using:p,$null,$null)
sleep -Milliseconds $using:ms
if ($Socket.Connected -like "True") {
Write-Host "$using:s | $using:p | Opened"
} elseif ($Socket.Connected -like "False") {
Write-Host "$using:s | $using:p | Closed"
}
$socket.Close()
}) | Out-Null
}
}
while ($True){
$status = @((Get-Job).State)[-1]
if ($status -like "Completed"){
Get-Job | Receive-Job
Get-Job | Remove-Job -Force
break
}}
$end_time = Get-Date
$run_time = $end_time - $start_time
$run_min = $run_time.Minutes
$run_sec = $run_time.Seconds
Write-Host "Run time: $run_min min $run_sec sec"
}