---
layout: post
title: "FFMPEG Cheat Sheet"
comments: true
date: "2021-06-30 01:30:32.642000+00:00"
---


```python
import os
import datetime
import random
import toil
import json
import youtube_dl


def get_vid_duration(rootdir, vidname):
    print("gen_vid_duration", rootdir, vidname)
    #cmd = f"docker run -i --rm -v {rootdir}:/local linuxserver/ffmpeg -i /local/{vidname} -f null - | grep Duration"
    cmd = f"docker run -i --rm  -v {rootdir}:/local sjourdan/ffprobe /local/{vidname} -v quiet -show_streams -select_streams v:0 -of json"


    output = json.loads(os.popen(cmd).read().strip())

    dur = int(float(output['streams'][0]['duration']))

    return dur

    #old
    #output = output.split("Duration: ")[1].split(",")[0]
    #output = [int(float(i)) for i in output.split(":")]
    #t = datetime.timedelta(**dict(zip(["hours",  "minutes", "seconds"], output)))
    #return t.seconds

def gen_vid_thumbnail(rootdir, vidname, jpgname):

    tseconds = get_vid_duration(rootdir, vidname)

    # get random ss
    ss = random.randint(2,tseconds-1)

    cmd = f"docker run -i --rm -v {rootdir}:/local linuxserver/ffmpeg -i /local/{vidname} -vframes 1 -an -ss {ss} -vf scale='min(200\,iw)':-1 /local/{jpgname} -y"

    return os.system(cmd)

def split_vid(rootfolder, inputfile, outputfile, ss, tt):

    cmd = f"docker run -i --rm -v {rootfolder}:/local linuxserver/ffmpeg -ss {ss} -i '/local/{inputfile}' -t {tt} -async 1 -y '/local/{outputfile}'"
        
    return os.system(cmd)


def gen_split_chunks(rootfolder, filename):
    import math

    dur = get_vid_duration(rootfolder, filename)
    
    if dur < 50:
        return 

    step = 50
    iters = 10
    if dur < 500:
        iters = math.ceil(dur/50)
        step = math.ceil(dur/iters)
    
    ret = []
    for i in range(iters): 
        ss = i*step
        tt = step
        if ss+tt > dur:
            dur = tt-ss
        ret.append([ss, tt])
        ss += tt
    
    return ret


def gen_thumbs():
    vault = toil.load_json("./vault.json")

    for fileuse in vault:
        print(fileuse)
        vidname = fileuse
        jpgname = ".".join(vidname.split(".")[:-1])+".jpg"
        print(vidname, jpgname)
        if os.path.exists(f"/root/insta/thumb/{jpgname}"): continue
        gen_vid_thumbnail("/root/insta/", "/files/"+vidname, "/thumb/"+jpgname)

if __name__ == '__main__':
    gen_thumbs()


def download_yt(link, fileto, it=0):
    mapit = [
        "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4",
        "bestvideo+bestaudio/mp4",
        "bestvideo+bestaudio",
        "bestvideo",
    ]
    print(">>it", it, fileto)

    fmt = mapit[it]

    #ret = os.system(f"docker run -i --rm -v /tmp:/workdir mikenye/youtube-dl -f '{fmt}' -o {fileto} --merge-output-format mp4 {link}")
    ret = os.system(f"youtube-dl -f '{fmt}' -o /tmp/{fileto} --merge-output-format mp4 \"{link}\"")

    if ret != 0:
        return download_yt(link, fileto, it+1)
    return ret

def fetch_yt_meta(link):
    with youtube_dl.YoutubeDL() as ydl:
        meta = ydl.extract_info(link, download=False)

    return meta

def insta_optimize(filefrom, newfile, rootfolder):
    cmd = f"docker run --rm -v {rootfolder}:/local linuxserver/ffmpeg -i /local/{filefrom} -vf \"pad=w=max(ih*4/5\,iw):h=ih:x=(iw-ow)/2:y=(ih-oh/2):color=black,pad=w=iw:h=max(iw*9/16\,ih):x=(iw-ow)/2:y=(ih-oh/2):color=black\" /local/{newfile}"
    ret = os.system(cmd)

    return ret
```