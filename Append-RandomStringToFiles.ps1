Clear-Host

# User Inputs
$FileExt = "*.txt"
$UserPath = "C:\Users\nries\Desktop\txt"
$Encoding = [System.Text.Encoding]::UNICODE
# End user inputs

# default variables
$X = 1

# Sanity check
Write-Warning "If the settings below are incorrect, irreperable damage to the source data can occur.`r`nAre you sure you want to modify all files with the following settings?: "
Write-Host ""
Write-Host ('$FileExt = "'+$FileExt+'"')
Write-Host ('$UserPath = "'+$UserPath+'"')
Write-Host ('$Encoding = '+$Encoding)
Write-Host ""
Write-Warning "The user ($env:USERNAME) running this script accepts full responsibility for the actions taken by the script.`r`nThe author accepts no responsibility for the actions of this script."
$agree = read-host "type 'I AGREE' in all caps to continue"
if ($agree -cne "I AGREE"){write-warning ("$env:USERNAME did not agree. Exiting script."); pause; break}

# Get a list of all files in the directory based on user inputs
[System.Collections.ArrayList]$list = (([System.IO.Directory]::EnumerateFiles("$UserPath",$FileExt,[System.IO.SearchOption]::AllDirectories)) -split "`r`n")

# Run for each file found
Foreach ($file in $list){
    
    # Empty the encoded random string
    $EncRandSTR = $null
    
    # Generate random string of 3 characters using lowercase, uppercase, numbers, and special, characters
    $RandSTR = ([System.Environment]::NewLine) + (-join (([char[]]((48..57)+(65..93)+(97..122)+(35,36,42,43,44,45,46,47,58,59,61,63,64,95,123,125,126))*100) | Get-Random -Count 3))
    
    # Convert the ASCII text in $RandSTR to the desired encoding and store to $EncRandSTR
    [System.Text.Encoding]::Convert(([System.Text.Encoding]::ASCII), $Encoding, ([System.Text.Encoding]::ASCII.GetBytes($RandSTR))) | % {$EncRandSTR += [char]$_}
    
    # Append text to $file
    [System.IO.File]::AppendAllText($file,$EncRandSTR)
    
    # Progress Bar
    Write-Progress -Activity ("Appending text to file number $X out of "+ $list.Count + " total") -Status ((($X / $list.Count) * 100).ToString("0.00")+' Percent') -PercentComplete (($X++ / $list.Count) * 100)
}
