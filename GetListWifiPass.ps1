$wifiProfiles = netsh wlan show profiles | Select-String -Pattern "All User Profile" | ForEach-Object { $_.ToString().Split(":")[1].Trim() }
$scriptDirectory = $PSScriptRoot
$fileName = "listWifiPasswords.txt"
$passwordList = @()
Write-Host "Getting list Wifi Passwords..."
foreach ($profile in $wifiProfiles) {
    $profileInfo = netsh wlan show profile name="$profile" key=clear
    $password = $profileInfo | Select-String -Pattern "Key Content" | ForEach-Object { $_.ToString().Split(":")[1].Trim() }
    $passwordList += "${profile}:${password}"
}
if ($passwordList) {
    $passwordList | Out-File -FilePath "$scriptDirectory\$fileName"
    Invoke-Item "$scriptDirectory\listWifiPassword.txt"
}