---
layout: post
title: "Download youtube ongoing stream"
comments: true
date: "2021-05-02 16:27:43.528000+00:00"
---



https://stackoverflow.com/questions/37040798/how-do-you-use-youtube-dl-to-download-live-streams-that-are-live


Youtube-dl
```
youtube-dl -f 95 <video link>
youtube-dl -f 95 <url>
ffmpeg -i $(youtube-dl -f <fmt> -g <url>) -copy <filename>.ts
```


Streamlink
```
pip3 install streamlink
streamlink --hls-live-restart -o test.mp4 URL_VIDEO best
```



https://www.reddit.com/r/DataHoarder/comments/g2xmgg/download_ongoing_youtube_live_stream_from_the/

https://github.com/rytsikau/ee.Yrewind#-durationminutes

```
.\yrewind.exe -url="<url video>" -start=beginning -duration=300
```

