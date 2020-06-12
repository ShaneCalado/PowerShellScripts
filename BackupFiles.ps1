# Backup files that have been changed in the past day 

$BackupPath =  (Get-Location).tostring() + "\Backup\"
$ValidPath = Test-Path $BackupPath

If ($ValidPath -eq $false) {
    New-Item -ItemType Directory -Path $BackupPath
    }

Write-Host "Saving the following files to the ""Backup"" folder:"

$BackupCount = 0
$BackupSize = 0

Get-ChildItem -File | Where-Object {
    $_.LastWriteTime -ge (Get-Date).AddDays(-1) } |
    ForEach-Object {
        Write-Host "$_"
        $BackupCount ++
        $BackupSize += $_.Length

        $FileName = [IO.Path]::GetFileNameWithoutExtension($_.Name) # Get the file name without extention
        $FileType = [IO.Path]::GetExtension($_.Name) # Get file extension

        $NewFileName = $FileName + (Get-Date).Date.ToString("MM/dd/yy") + $FileType

        Copy-Item $_ -Destination ("$BackupPath$NewFileName")
        }


Write-Host $BackupCount "file backed up." $BackupSize "bytes."


