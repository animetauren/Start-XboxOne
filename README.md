# Start-XboxOne
PowerShell Script to Remotely turn on your Xbox One, to help your automating needs using the magic of PowerShell.

This works for both LAN and WAN, for WAN you need to have port 5050 on your wireless router forwarded to your Xbox One.

## How to use

You need three things for this to work:
- PowerShell v3.0+
- IP address of your Xbox One
- Live device ID of your Xbox One

To find the IP of your Xbox, go to Settings -> Network -> Advanced settings.  
To find your Live device ID, go to Settings -> System -> Console info. (DO NOT SHARE)  

If you want to use this over the internet, you'll also need port 5050 forwarded to your Xbox One.

Run the script as follows, replacing <ip address> with the IP of your Xbox and <live id> with your Live device ID.

```Powershell
.\start-xboxone.ps1 -liveID <XBOX LIVE ID> -ip <ip address>
```

#Credits

Credit to @Schamper for his original Python Script: [xbox-remote-power](https://github.com/Schamper/xbox-remote-power)

Credit to @hotstone for his gist on sending UDP Datagrams using Powershell: [Send-Datagram](https://gist.github.com/hotstone/fdff6a808d1e03010d29)
