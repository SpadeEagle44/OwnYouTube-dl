# OwnYouTube-dl
> Tool which uses the powerful yt-dlp and ffmpeg to simplify and allow mass download scripting of YouTube videos at the quality you need.

## Setup

1. Create a folder and put OwnYouTube-dl.exe [or OwnYouTube-dl.ps1] in this folder
2. Get yt-dlp (yt-dlp.exe) from the official Github repository (https://github.com/yt-dlp/yt-dlp/releases) and put it the same folder
3. Get ffmpeg (ffmpeg-master-latest-win64-gpl.zip) from BtbN affiliated Github repository (https://github.com/BtbN/FFmpeg-Builds/releases) open the zip and extract the content of the folder ffmpeg-master-latest-win64-gpl in the same folder than OwnYouTube-dl and yt-dlp.

That's all!
> Important: ffmpeg and yt-dlp are not provided in the repositories or releases! Be sure to download them from links provided before.

## Usage

You have two ways to use OwnYouTube-dl: Interactive mode or in command line.

### Interactive mode

Just launch OwnYouTube-dl.exe and follow the instructions will download the video from the URL you gave, get video and audio quality formats selected and merge these in a full video file in the working folder like this "yyyyMMDD-hh.mm.ss_output_C0DPdy98e4c.<format>".

### Command line

Typical usage:
```PowerShell
.\OwnYouTube-dl.exe -silent (suppress MsgBox) -url <youtube_video_url, e.g: https://www.youtube.com/watch?v=C0DPdy98e4c> -videoFormat '<format, e.g: 251 for webm>' -audioFormat '<format, e.g: 248 for webm>'
```
This command will download the video from the URL you gave, get video and audio quality formats selected and merge this to a full video file in the working folder like this "yyyyMMDD-hh.mm.ss_output_C0DPdy98e4c.<format>".

## Thanks

I just want to thanks yt-dlp and ffmpeg developers and Github releases mainteners of these two wonderful software. As always, feel free to get, use and modify the OwnYouTube-dl code for your own needs.
