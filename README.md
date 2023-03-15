# Get-PortCheck

### Модуль для проверки доступности TCP-портов.

Используется класс .NET: **System.Net.Sockets.TcpClient** с выводом в **PSCustomObject**.

![Image alt](https://github.com/Lifailon/Get-PortCheck/blob/rsa/Screen/1.3-PSCustomObject.jpg)

## Установка

* Установите модуль **[ThreadJob](https://github.com/PaulHigin/PSThreadJob)**: ` Install-Module -Name ThreadJob  -Source PSGallery ` \
Запустите powershell, и проверьте, что модуль установлен: ` Get-Module ThreadJob -List `

* **Скопируйте директорию `Get-PortCheck` с модулем в один из каталогов:** \
` C:\Users\%username%\Documents\WindowsPowerShell\Modules ` \
` C:\Program Files\WindowsPowerShell\Modules ` \

## Синтаксис

` Get-Help Get-PortCheck `

Проверка нескольких портов на одном хосте: \
` Get-PortCheck 192.168.1.10 443 ` \
` Get-PortCheck 192.168.1.10 22,3389 ` \
` Get-PortCheck 192.168.1.10 20-70 `

Проверка хостов всей подсети: \
` Get-PortCheck 192.168.1.0 80 `

Быстрый режим (Fast Mode): \
` Get-PortCheck 192.168.1.0 80 100 `

Вывести только открытые порты: \
` Get-PortCheck 192.168.1.0 80 100 -open`

## Метод ConnectAsync (1.0)

**Медленный метод**, т.к. не имеет возможности на уровне клиента (за исключением метода Wait) сократить время ожидания ответа от хоста. Данный способ собирает информацию о подключении, и возвращает ErrorCode, из которого можно инициализировать причину недоступности порта. \
**10061** - порт закрыт/фильтруется \
**10060** - хост недоступен \
**Преимущество:** удобно использовать в случае, **если закрыт icmp, с помощью проверки одного TCP-порта, можно выявить доступность хоста**. \
**Недостаток:** на проверку одного выключенного хоста уходит 20 секунд, а на доступном хосте 2 секунды.

![Image alt](https://github.com/Lifailon/Get-PortCheck/blob/rsa/Screen/1.0-Method-ConnectAsync.jpg)

## Метод BeginConnect (1.1)

**Быстрый метод**, где мы пытаемся установить соединение, без последующего подключения. Тем самым можно задать **timeout (третий параметр)**, и сократить время сканирования портов, разрывая попытку соединения.

![Image alt](https://github.com/Lifailon/Get-PortCheck/blob/rsa/Screen/1.1-%20Method-BeginConnect-500ms-vs-100ms.jpg)

## С применение ThreadJob (1.2)

**Сравнение данного метода с и без использования ThreadJob (Timeout 100 milliseconds)**.

![Image alt](https://github.com/Lifailon/Get-PortCheck/blob/rsa/Screen/1.1-vs-1.2-ThreadJob.jpg)

**Исходя из полученных результатов, создание задания (Jobs) занимае в среднем на 30-40% меньше времени, чем sleep 100 Milliseconds**.
