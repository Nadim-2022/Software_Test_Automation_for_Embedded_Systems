# Define the target USB device's PNPDeviceID pattern
$targetPNPDeviceID = "USB\VID_2E8A&PID_000A&MI_00"

# Find the COM port with the specified PNPDeviceID
$comPort = Get-CimInstance -Class Win32_SerialPort |
           Where-Object { $_.PNPDeviceID -like "$targetPNPDeviceID*" } |
           Select-Object -ExpandProperty DeviceID -First 1

# Check if a matching COM port was found
if ($comPort) {
    # Set the COM_PORT environment variable
    [System.Environment]::SetEnvironmentVariable("COM_PORT", $comPort, "User")
    Write-Output "COM_PORT set to $comPort"
} else {
    Write-Output "No COM port found with PNPDeviceID $targetPNPDeviceID"
}
