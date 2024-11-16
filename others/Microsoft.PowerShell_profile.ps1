Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

Set-PSReadlineKeyHandler -Key ctrl+d -Function ViExit

Set-Alias sudo gsudo
Set-Alias vi nvim

function which ($cmd) {
    Get-Command $cmd | Format-List
}

# SHA1
function sha1sum { $args | ForEach-Object { Get-FileHash -Path $_ -Algorithm SHA1 | Format-List } }

# SHA256
function sha256sum { $args | ForEach-Object { Get-FileHash -Path $_ -Algorithm SHA256 | Format-List } }

# SHA384
function sha384sum { $args | ForEach-Object { Get-FileHash -Path $_ -Algorithm SHA384 | Format-List } }

# SHA512
function sha512sum { $args | ForEach-Object { Get-FileHash -Path $_ -Algorithm SHA512 | Format-List } }

# MD5
function md5sum { $args | ForEach-Object { Get-FileHash -Path $_ -Algorithm MD5 | Format-List } }


function ln ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

function touch ([string] $filename) {
    if (Test-Path $filename) {
        echo $null >> $filename
    } else {
        New-Item -ItemType File $filename
    }
}

# Set-Proxy command
if ($env:HTTP_PROXY -ne $null) {
    Write-Output "Proxy Enabled as $env:HTTP_PROXY";
}
Function SetProxy() {
    Param(
        # 改成自己的代理地址
        $Addr = 'http://127.0.0.1:7890',
        [switch]$ApplyToSystem
    )

    $env:HTTP_PROXY = $Addr;
    $env:HTTPS_PROXY = $Addr;
    $env:http_proxy = $Addr;
    $env:https_proxy = $Addr;

    [Net.WebRequest]::DefaultWebProxy = New-Object Net.WebProxy $Addr;
    if ($ApplyToSystem) {
        $matchedResult = ValidHttpProxyFormat $Addr;
        # Matched result: [URL Without Protocol][Input String]
        if (-not ($matchedResult -eq $null)) {
            SetSystemProxy $matchedResult.1;
        }
    }
    Write-Output "Successful set proxy as $Addr";
}
Function ClearProxy() {
    Param(
        $Addr = $null,
        [switch]$ApplyToSystem
    )

    $env:HTTP_PROXY = $Addr;
    $env:HTTPS_PROXY = $Addr;
    $env:http_proxy = $Addr;
    $env:https_proxy = $Addr;

    [Net.WebRequest]::DefaultWebProxy = New-Object Net.WebProxy;
    if ($ApplyToSystem) { SetSystemProxy $null; }
    Write-Output "Successful unset all proxy variable";

}
Function SetSystemProxy($Addr = $null) {
    Write-Output $Addr
    $proxyReg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings";

    if ($Addr -eq $null) {
        Set-ItemProperty -Path $proxyReg -Name ProxyEnable -Value 0;
        return;
    }
    Set-ItemProperty -Path $proxyReg -Name ProxyServer -Value $Addr;
    Set-ItemProperty -Path $proxyReg -Name ProxyEnable -Value 1;
}
Function ValidHttpProxyFormat ($Addr) {
    $regex = "(?:https?:\/\/)(\w+(?:.\w+)*(?::\d+)?)";
    $result = $Addr -match $regex;
    if ($result -eq $false) {
        throw [System.ArgumentException]"The input $Addr is not a valid HTTP proxy URI.";
    }

    return $Matches;
}
Set-Alias proxy SetProxy
Set-Alias unproxy ClearProxy

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
