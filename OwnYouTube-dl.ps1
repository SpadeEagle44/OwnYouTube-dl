param (
    [string]$silent,
    [string]$url,
    [string]$videoFormat,
    [string]$audioFormat,
    [switch]$help,
    [switch]$version
)

function Show-Help {
    "Command usage: .\OwnYouTube-dl.exe [or .\OwnYouTube-dl.ps1] [-silent (if you don't want MsgBox at the end)] -url 'URL' -videoFormat 'format' -audioFormat 'format'
    -silent        Call this switch if you want no MsgBox at the end (useful for automation)
    -url           YouTube video URL
    -videoFormat   Chosen YouTube video format (e.g. 248)
    -audioFormat   Chosen YouTube audio format (e.g. 251)
    -help          Show this help
    -version       Show version
    Interactive usage: Just launch OwnYouTube-dl.exe and follow the instructions
    Important: Please put yt-dlp and ffmpeg (bin/ffmpeg) in the same folder than OwnYouTube-dl. Otherwise, nothing will works :)"
}

function Show-Version {
    "OwnYouTube-dl - John Gonzalez - Version: 1.0.0"
}

if ($help) {
    Show-Help
    return
}

if ($version) {
    Show-Version
    return
}

Add-Type -AssemblyName System.Windows.Forms

function Update-YTDLP {
    & .\yt-dlp.exe --update 2>&1 | ForEach-Object {
        if ($_ -match "WARNING") {
            Write-Warning $_
        } elseif ($_ -match "ERROR") {
            Write-Error $_
        } else {
            Write-Host $_
        }
    }
}

function Get-Formats {
    param([string]$url)
    & .\yt-dlp.exe -F $url 2>&1 | ForEach-Object {
        if ($_ -match "WARNING") {
            Write-Warning $_
        } elseif ($_ -match "ERROR") {
            Write-Error $_
        } else {
            Write-Host $_
        }
    }
}

function Download-Video {
    param([string]$url, [string]$format)
    $output = ".\video.$format.%(ext)s"
    $outputPath = & .\yt-dlp.exe -f $format $url -o $output 2>&1
    $outputPath.Split("`n") | ForEach-Object {
        if ($_ -match "WARNING") {
            Write-Warning $_
        } elseif ($_ -match "ERROR") {
            Write-Error $_
        } else {
            Write-Host $_
        }
    }
    return $outputPath | Where-Object { $_ -like "*Destination:*" } | ForEach-Object { $_.Split(":")[1].Trim() }
}

function Download-Audio {
    param([string]$url, [string]$format)
    $output = ".\audio.$format.%(ext)s"
    $outputPath = & .\yt-dlp.exe -f $format $url -o $output 2>&1
    $outputPath.Split("`n") | ForEach-Object {
        if ($_ -match "WARNING") {
            Write-Warning $_
        } elseif ($_ -match "ERROR") {
            Write-Error $_
        } else {
            Write-Host $_
        }
    }
    return $outputPath | Where-Object { $_ -like "*Destination:*" } | ForEach-Object { $_.Split(":")[1].Trim() }
}

function Merge-AudioVideo {
    param([string]$videoFile, [string]$audioFile, [string]$videoId)
    if (-Not (Test-Path $videoFile) -or -Not (Test-Path $audioFile)) {
        Write-Host "One of the file does not exist: $videoFile or $audioFile"
        return
    }
    $timestamp = Get-Date -Format "yyyyMMdd-HH.mm.ss"
    $outputFile = ".\${timestamp}_output_${videoId}$([IO.Path]::GetExtension($videoFile))"
    $processOutput = & .\bin\ffmpeg.exe -i $videoFile -i $audioFile -c:v copy -c:a copy -strict experimental $outputFile 2>&1
    if (Test-Path $outputFile) {
        Remove-Item $videoFile, $audioFile
        if (-not $silent) {
            [System.Windows.Forms.MessageBox]::Show("Video ready: $outputFile", "Confirmation")
        } else {
            Write-Host "Video ready: $outputFile"
        }
    }
    return $outputFile
}

if (-not $url) { $url = Read-Host "Enter YouTube video URL" }
Update-YTDLP
Get-Formats -url $url

if (-not $videoFormat) { $videoFormat = Read-Host "Enter chosen video format (e.g. 248)" }
if (-not $audioFormat) { $audioFormat = Read-Host "Enter chosen audio format (e.g. 251)" }

if ($url -and $videoFormat -and $audioFormat) {
    $videoId = $url -replace '.*v=([^&]+).*', '$1'
    
    $videoFile = Download-Video -url $url -format $videoFormat
    $audioFile = Download-Audio -url $url -format $audioFormat
    
    Merge-AudioVideo -videoFile $videoFile -audioFile $audioFile -videoId $videoId
}