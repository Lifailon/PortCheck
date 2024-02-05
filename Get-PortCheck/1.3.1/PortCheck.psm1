Function Get-PortCheck {
    <#
    .SYNOPSIS
    Module for quick check of open ports on the network
    Dependencies: Install-Module ThreadJob
    Used class .NET: System.Net.Sockets.TcpClient and method: BeginConnect
    .DESCRIPTION
    Example:
    Get-PortCheck 192.168.3.102 3000
    Get-PortCheck 192.168.3.102 22,80,443,3000,3389,8085,8086
    Get-PortCheck 192.168.3.102 8080-8090
    Get-PortCheck 192.168.3.0 3000 # check one port to all network
    Get-PortCheck 192.168.3.0 8085 100 # fast mode
    Get-PortCheck 192.168.3.0 8085 100 -Open # show only open ports
    .LINK
    https://github.com/Lifailon/PortCheck
    #>
    Param (
        $Address,
        $Port,
        $Timeout=500,
        [switch]$Open
    )
    if (!$port) {
        Write-Host (Get-Help Get-PortCheck).DESCRIPTION.Text -ForegroundColor Cyan
        return
    }
    if ($Address -match "\.0$") {
        $replace = $Address -replace "0$"
        $Address = 1..254 | ForEach-Object {
            $replace+$_
        }
    }
    if ($port -match "-") {
        $port = $port -split "-"
        $start = $port[0]
        $end = $port[1]
        $port = $start..$end
    }
    foreach($s in [array]$Address) {
        foreach($p in [array]$port) {
            (
                Start-ThreadJob {
                    $Socket = New-Object System.Net.Sockets.TcpClient
                    $Socket.BeginConnect($using:s,$using:p,$null,$null)
                    Start-Sleep -Milliseconds $using:Timeout
                    if ($Socket.Connected -like "True") {
                        Write-Host "$using:s $using:p Opened"
                    } elseif ($Socket.Connected -like "False") {
                        Write-Host "$using:s $using:p Closed"
                    }
                    $socket.Close()
                }
            ) | Out-Null
        }
    }
    while ($True) {
        $status = @((Get-Job).State)[-1]
        if ($status -like "Completed"){
            $arr = (Get-Job).Information
            Get-Job | Remove-Job -Force
            break
        }}
        $Collections = New-Object System.Collections.Generic.List[System.Object]
        foreach ($a in $arr) {
            $sa = $a -split " "
            $Collections.Add([PSCustomObject]@{
            IP = $sa[0];
            Port = $sa[1];
            Status = $sa[2]
        })
    }
    if ($open) {
        $Collections | Where-Object status -match "Opened"
    }
    else {
        $Collections
    }
}