<#
.SYNOPSIS
    Start-XboxOne.ps1 - A PowerShell Script to turn on your Xbox One.
.DESCRIPTION
    Sends a magic packet to the Xbox One turning it on.
.Credits
    xbox-remote-power - https://github.com/Schamper/xbox-remote-power
    Send-Datagram - https://gist.github.com/hotstone/fdff6a808d1e03010d29
.PARAMETER liveID
    Defines the LIVEID of the Xbox One, this is not your gamer tag. Must be in caps.
    Mandatory parameter
    No default value.
.PARAMETER ip
    Defines the IP Address of the Xbox One.
    Mandatory Parameter
    No default value.
.PARAMETER port
    Defines the port to send the magic packet to.
    Default Value: 5050
.NOTES
    File Name   : Start-XboxOne.ps1
    Author      : Henry Robalino - henry.robalino@outlook.com - https://anmtrn.com
    Version     : 1.0 - Jan 18, 2017
.EXAMPLE
    PS C:\> .\Start-XboxOne.ps1 -liveID  -ip XXX.XXX.XXX.XXX 
#>

param(
    [parameter(Mandatory=$true)][ValidatePattern('^[A-Z0-9]+$')][string] $liveID,
    [parameter(Mandatory=$true)][ValidatePattern('^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$')][string] $ip,  
    [parameter(Mandatory=$false)][int] $port=5050
    )

function Ping-Xbox($address){
    $ping = New-Object system.net.networkinformation.ping
    $pingStatus = $ping.send($address).Status
    return $pingStatus
}

function Send-XboxPowerPacket(){
    
    $ipAddress = $null
    $parseResult = [System.Net.IPAddress]::TryParse($ip, [ref] $ipAddress)

    if ( $parseResult -eq $false ) 
    {
        $addresses = [System.Net.Dns]::GetHostAddresses($ip)
        
        if ( $addresses -eq $null ) 
        {
            throw "Unable to resolve address: $ip"
        }

        $ipAddress = $addresses[0]
    }    

    $endpoint = New-Object System.Net.IPEndPoint($ipAddress, $port)
    $udpClient = New-Object System.Net.Sockets.UdpClient

    $encodedLiveID = [System.Text.Encoding]::ASCII.GetBytes($liveID)
    
    #Converts the length of the live id  to a string representive of that unicode value
    $liveIDLenChar = [char][byte]($liveId.Length)

    $encodedLiveIDLen = [System.Text.Encoding]::ASCII.GetBytes($liveIDLenChar)
    $payload = [byte[]](,0x00 + $encodedLiveIDLen + $encodedLiveID + 0x00)

    $payloadLenChar = [char][byte]($payload.Length)
    $payloadLen = [System.Text.Encoding]::ASCII.GetBytes($payloadLenChar)
    $header = [byte[]](,0xdd + 0x02 + 0x00 + $payloadLen + 0x00 + 0x00)
    $packet = $header +  $payload

    $bytesSent = $udpClient.Send($packet,$packet.length,$endpoint)

    $udpClient.Close()

    sleep -Seconds 5

    Write-Host "`nXbox should turn on now, pinging to make sure..." -ForegroundColor Green
    $pingStatus = Ping-Xbox -address $ip

    if($pingStatus -ne "Success"){
        $retry = Read-Host "Failed to ping Xbox, want to retry? y\n"
        if($retry -eq "y"){
            Send-XboxPowerPacket -liveID $liveID -ip $ip -port $port
        }
        else{
            Write-Output "Okay, thanks bye..."
            Exit
        }
    }
    else{
        Write-Host "Xbox is on!" -ForegroundColor Green
    }

}

Send-XboxPowerPacket
