# CPort

### Модуль для проверки доступности портов

Для проверки используется два метода из **класса .NET: System.Net.Sockets.TcpClient**. В версии 1.3 (Release) с применением **ThreadJob**.

- [Установка](#Установка)
- [Синтаксис](#Синтаксис)
- [Метод ConnectAsync](#Метод-ConnectAsync)
- [Метод BeginConnect](#Метод-BeginConnect)

## Установка

* Установить модуль **[ThreadJob](https://www.powershellgallery.com/packages/ThreadJob/2.0.3)**: ` Install-Module -Name ThreadJob ` \
Запустите powershell, и проверьте, что модуль установлен: ` Get-Module ThreadJob -List `

* **Создайте директорию `cport` в одном из каталогов:** \
` C:\Users\%username%\Documents\WindowsPowerShell\Modules ` \
` C:\Program Files\WindowsPowerShell\Modules ` \
И скопируйте туда модуль: **[cport.psm1](https://github.com/Lifailon/CPort/releases)** \
` Get-Module cport -list `

## Синтаксис

**Справка:** ` Get-Help cport `

Проверка нескольких портов на одном хосте: \
` cport 192.168.1.10 443 ` \
` cport 192.168.1.10 22,3389 ` \
` cport 192.168.1.10 20-70 ` \
Проверка хостов всей подсети: \
` cport 192.168.1.0 80 ` \
Быстрый режим (fast mode): \
` cport 192.168.1.0 80 100 `

![Image alt](https://github.com/Lifailon/CPort/blob/rsa/Screen/cport-1.3.jpg)

## Метод ConnectAsync

## Метод BeginConnect
