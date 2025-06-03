Add-Type -AssemblyName System.Windows.Forms

# Create the GUI Form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Antivirus Scanner"
$Form.Size = New-Object System.Drawing.Size(400,300)
$Form.StartPosition = "CenterScreen"

# Create Scan Button
$ScanButton = New-Object System.Windows.Forms.Button
$ScanButton.Text = "Start Scan"
$ScanButton.Location = New-Object System.Drawing.Point(150,50)
$ScanButton.Size = New-Object System.Drawing.Size(100,30)

# Create Output Log Box
$OutputBox = New-Object System.Windows.Forms.TextBox
$OutputBox.Location = New-Object System.Drawing.Point(50,100)
$OutputBox.Size = New-Object System.Drawing.Size(300,100)
$OutputBox.Multiline = $true
$OutputBox.ScrollBars = "Vertical"

# Create Progress Bar
$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Location = New-Object System.Drawing.Point(50,220)
$ProgressBar.Size = New-Object System.Drawing.Size(300,20)
$ProgressBar.Minimum = 0
$ProgressBar.Maximum = 100

# Define Suspicious Files
$suspiciousFiles = @("*.exe", "*.bat", "*.ps1", "*.dll")
$scanPath = "C:\Users"
$quarantineFolder = "C:\Quarantine"

# Ensure Quarantine Folder Exists
if (!(Test-Path $quarantineFolder)) {
    New-Item -ItemType Directory -Path $quarantineFolder
}

# Scan Function
$ScanButton.Add_Click({
    $OutputBox.Text = "Scanning..."
    $ProgressBar.Value = 0

    $files = Get-ChildItem -Path $scanPath -Filter "*.exe" -Recurse -ErrorAction SilentlyContinue
    $totalFiles = $files.Count
    $processed = 0

    foreach ($file in $files) {
        $processed++
        $ProgressBar.Value = [math]::Round(($processed/$totalFiles)*100)

        $OutputBox.Text += "`r`n⚠️ Found: $file"
        
        # Quarantine suspicious file
        try {
            Move-Item -Path $file.FullName -Destination $quarantineFolder -ErrorAction Stop
            $OutputBox.Text += "`r`n🛑 Quarantined: $file"
        } catch {
            $OutputBox.Text += "`r`n❌ Failed to move: $file"
        }
    }

    $OutputBox.Text += "`r`n✅ Scan Complete! You can now close this GUI"
    $ProgressBar.Value = 100
    $wshell = New-Object -ComObject WScript.Shell
    $wshell.Popup("Avio AntiVirus scan Complete.", 5, "AVIO AntiVirus", 64)
})

# Add Components to the Form
$Form.Controls.Add($ScanButton)
$Form.Controls.Add($OutputBox)
$Form.Controls.Add($ProgressBar)

# Show GUI
$Form.ShowDialog()
