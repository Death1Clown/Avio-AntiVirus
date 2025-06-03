Add-Type -AssemblyName System.Windows.Forms

# Create the Form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Malware Scanner & Remover"
$Form.Size = New-Object System.Drawing.Size(400, 300)
$Form.StartPosition = "CenterScreen"

# Create Status Label
$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Text = "Status: Ready"
$StatusLabel.AutoSize = $true
$StatusLabel.Location = New-Object System.Drawing.Point(20, 200)
$Form.Controls.Add($StatusLabel)

# Function to Run Full System Scan
Function RunFullScan {
    $StatusLabel.Text = "Running full scan..."
    Start-MpScan -ScanType FullScan
    $StatusLabel.Text = "Full scan completed!"
}

# Function to Check for Threats
Function CheckThreats {
    $StatusLabel.Text = "Checking for threats..."
    $threats = Get-MpThreatDetection
    if ($threats) {
        $StatusLabel.Text = "Threats found: $($threats.ThreatName)"
    } else {
        $StatusLabel.Text = "No threats found!"
    }
}

# Function to Remove Threats
Function RemoveThreats {
    $StatusLabel.Text = "Removing threats..."
    Remove-MpThreat
    $StatusLabel.Text = "Threats removed!"
}

# Create Buttons
$ScanButton = New-Object System.Windows.Forms.Button
$ScanButton.Text = "Run Full Scan"
$ScanButton.Size = New-Object System.Drawing.Size(120, 30)
$ScanButton.Location = New-Object System.Drawing.Point(20, 50)
$ScanButton.Add_Click({ RunFullScan })
$Form.Controls.Add($ScanButton)

#
#
#
#
#
Function OpenAvio {
    $appPath = "C:\Users\Gover\Documents/avio.exe"  # Change this to the correct path
    if (Test-Path $appPath) {
        Start-Process $appPath
        $StatusLabel.Text = "avio.exe opened!"
    } else {
        $StatusLabel.Text = "avio.exe not found! Move the .exe file to documents!"
    }
}

# Create Button
$OpenButton = New-Object System.Windows.Forms.Button
$OpenButton.Text = "Open Avio"
$OpenButton.Size = New-Object System.Drawing.Size(120, 30)
$OpenButton.Location = New-Object System.Drawing.Point(200, 50)
$OpenButton.Add_Click({ OpenAvio })
$Form.Controls.Add($OpenButton)
#
#
#
#
#
#
#

$ThreatButton = New-Object System.Windows.Forms.Button
$ThreatButton.Text = "Check for Threats"
$ThreatButton.Size = New-Object System.Drawing.Size(120, 30)
$ThreatButton.Location = New-Object System.Drawing.Point(20, 100)
$ThreatButton.Add_Click({ CheckThreats })
$Form.Controls.Add($ThreatButton)

$RemoveButton = New-Object System.Windows.Forms.Button
$RemoveButton.Text = "Remove Threats"
$RemoveButton.Size = New-Object System.Drawing.Size(120, 30)
$RemoveButton.Location = New-Object System.Drawing.Point(20, 150)
$RemoveButton.Add_Click({ RemoveThreats })
$Form.Controls.Add($RemoveButton)

# Run the Form
$Form.ShowDialog()
