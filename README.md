# PortCheck

[Description in Russian](https://github.com/Lifailon/PortCheck/blob/rsa/README_ru.md)

Module for quick check of open ports on the network

Used class **.NET**: `System.Net.Sockets.TcpClient` and method `BeginConnect`

Install: `Install-Module PortCheck`

Dependencies: `Install-Module ThreadJob`

Format: `Get-PortCheck <IP-Address/Subnet> <Port> <Timeout>`

Works in PowerShell versions 5.1 and 7.3

## Examples:

```PowerShell
PS C:\Users\lifailon> Get-PortCheck 192.168.3.102 3000

IP            Port Status
--            ---- ------
192.168.3.102 3000 Opened

PS C:\Users\lifailon> Get-PortCheck 192.168.3.102 22,80,443,3000,3389,8085,8086

IP            Port Status
--            ---- ------
192.168.3.102 22   Closed
192.168.3.102 80   Closed
192.168.3.102 443  Closed
192.168.3.102 3000 Opened
192.168.3.102 3389 Closed
192.168.3.102 8085 Closed
192.168.3.102 8086 Opened

PS C:\Users\lifailon> Get-PortCheck 192.168.3.102 8080-8090

IP            Port Status
--            ---- ------
192.168.3.102 8080 Closed
192.168.3.102 8081 Closed
192.168.3.102 8082 Closed
192.168.3.102 8083 Closed
192.168.3.102 8084 Closed
192.168.3.102 8085 Closed
192.168.3.102 8086 Opened
192.168.3.102 8087 Closed
192.168.3.102 8088 Closed
192.168.3.102 8089 Closed
192.168.3.102 8090 Closed

PS C:\Users\lifailon> Get-PortCheck 192.168.3.0 8085 100 -Open

IP            Port Status
--            ---- ------
192.168.3.99  8085 Opened
192.168.3.100 8085 Opened
```