Function Invoke-WakeOnLan{

    Process { 

        # The following table contains aliases for commonly used MAC addresses; modify as required

        $StaticLookupTable=@(
        ("*", "MPR-SALLE" ),
        ("*", "PC-CHARIDE1" ),
        ("*", "PC-CHARIDE2" ),
        ("*", "PC-CHARIDE3" ),
        ("*", "PC-USLDINF" ),
        ("*", "PC-CCIDE01" ),
        ("*", "PO-PATTEST" )
        )

        $UdpClient = New-Object System.Net.Sockets.UdpClient

            
        Foreach ($MacString in $StaticLookupTable) {
                Write-Host "Mac Adresse : " $MacString[0] ","  $MacString[1] "`r" 
                # Validate the MAC address, 6 hex bytes separated by : or -

                If ($MacString[0] -NotMatch '^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$') {
                    Write-Warning "Mac address '$MacString[0]' is invalid; must be 6 hex bytes separated by : or -" 
                    Continue      
                }

                # Split and convert the MAC address to an array of bytes

                $MacApple = $MacString[0].Split('-:') | Foreach {[Byte]"0x$_"}

                # WOL Packet is a byte array with the first six bytes 0xFF, followed by 16 copies of the MAC address

                $Packet = [Byte[]](,0xFF * 6) + ($MacApple * 16)
                # Write-Verbose "Broadcast packet: $([BitConverter]::ToString($Packet))" # Un-comment this line to display packet

                $UdpClient.Connect(([System.Net.IPAddress]::Broadcast),4000)  # Send packets to the Broadcast address
                [Void]$UdpClient.Send($Packet, $Packet.Length)

                Write-Verbose "Wake-on-Lan Packet sent to $MacString" 
            }
    }



    End {
        $UdpClient.Close()
        $UdpClient.Dispose()
    }
}

Invoke-WakeOnLan