Function Get-PortCheck ($srv,$port,$ms=500) {
<#
.SYNOPSIS
Module for port check
Using Class .NET: System.Net.Sockets.TcpClient
Method: BeginConnect
.DESCRIPTION
Example:
Get-PortCheck 192.168.1.10 443
Get-PortCheck 192.168.1.10 22,3389
Get-PortCheck 192.168.1.10 20-70
Get-PortCheck 192.168.1.0 80 # check to network
Get-PortCheck 192.168.1.0 80 100 # fast mode
.LINK
https://github.com/Lifailon/Get-PortCheck
#>
if (!$port) {
Write-Host (Get-Help Get-PortCheck).DESCRIPTION.Text -ForegroundColor Cyan
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
$Socket = New-Object System.Net.Sockets.TcpClient
$Connect = $Socket.BeginConnect($s,$p,$null,$null)
sleep -Milliseconds $ms
if ($Socket.Connected -like "True") {
Write-Host "$s | $p | Opened"
} elseif ($Socket.Connected -like "False") {
Write-Host "$s | $p | Closed"
}
$socket.Close()
}
}
$end_time = Get-Date
$run_time = $end_time - $start_time
$run_min = $run_time.Minutes
$run_sec = $run_time.Seconds
Write-Host "Run time: $run_min min $run_sec sec"
}