Function Get-PortCheck ($srv,$port) {
<#
.SYNOPSIS
Module for port check
Using Class .NET: System.Net.Sockets.TcpClient
Method: ConnectAsync
.DESCRIPTION
Example:
Get-PortCheck 192.168.1.10 443
Get-PortCheck 192.168.1.10 22,3389
Get-PortCheck 192.168.1.10 20-70
Get-PortCheck 192.168.1.0 80 # check to network
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
foreach($p in [array]$port) {
foreach($s in [array]$srv) {
$Socket = New-Object system.Net.Sockets.TcpClient
#$Socket.ReceiveBufferSize = 100
#$Socket.SendBufferSize = 100
#$Socket.ReceiveTimeout = 100
#$Socket.SendTimeout = 100
#$Socket.Client.ttl = 100
$Connect = $Socket.ConnectAsync($s,$p)
$remote_ip = $Socket.Client.RemoteEndPoint.Address.IPAddressToString
$remote_port = $Socket.Client.RemoteEndPoint.Port
[string]$ip = $remote_ip+":"+$remote_port
while ($True) {
if ($Connect.isCompleted -like "True") {break}
}
$socket.Close()
if ($Connect.Status -like "RanToCompletion") {
Write-Host "$ip | Opened"
} elseif ($Connect.Exception.InnerException.ErrorCode -like "10061") {
Write-Host "$ip | Closed"
} elseif ($Connect.Exception.InnerException.ErrorCode -like "10060") {
Write-Host "$remote_ip not available"
}
}
}
$end_time = Get-Date
$run_time = $end_time - $start_time
$run_min = $run_time.Minutes
$run_sec = $run_time.Seconds
Write-Host "Run time: $run_min min $run_sec sec"
}