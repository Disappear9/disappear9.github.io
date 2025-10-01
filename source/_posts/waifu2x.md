---
title: waifu2x的实践[视频处理(UPSCALE)]
date: 2016/6/9 17:31:27
updated: 2016/6/9 17:31:27
toc: true
categories:
- 教程
tags:
- 教程
- 压制
- 折腾那些事
- 番剧
---

**注：此教程取自作者的[GitHub页面][1]，仅为效果展示，实际压制时请使用VS滤镜“waifu2x-caffe或opt等”。**

**什么是waifu2x：**
作者的DEMO主页上对它的介绍是这样的
>本程序使用卷积神经网络对动漫风格的图片进行放大操作。

这个名字来源于海外的动画粉丝们将喜欢的角色称作"waifu（我老婆）" [=_=]......
演示：
![](/pictures/waifu2x/slide.png)

*作者的DEMO页面：[http://waifu2x.udp.jp/][3]你可以上传一张图片，然后选择降噪或放大进行体验。*
<!--more-->
**准备**
由于在线版的一次只能处理一张图片，根本无法进行视频处理，所以我们需要使用本地编译版的。
**思路：我们使用ffmpeg把视频帧拆成png，声音分离出来，png用waifu2x处理后再封装回去。**
你需要准备这些软件：
```
waifu2x-caffe  https://github.com/lltcggie/waifu2x-caffe/releases
ffmpeg  https://ffmpeg.org/download.html
```
**waifu2x的实践**
下载ffmpeg，解压ffmpeg.exe到C:\Windows\System32文件夹，然后开启一个命令行窗口，输入ffmpeg回车，检查ffmpeg运行是否正常。
![](/pictures/waifu2x/2.PNG)

*正常运行的ffmpeg*
下载waifu2x-caffe后解压，双击waifu2x-caffe.exe
![](/pictures/waifu2x/wc1.PNG)

*正常运行的waifu2x-caffe*
回到命令行，执行以下命令：
```
ffmpeg -i 输入视频文件名 -ss 开始时间 -t 持续时间 -r 输出帧数 -f image2 frames/%06d.png
ffmpeg -i 输入视频文件名 -ss 开始时间 -t 持续时间 输出.mp3
```
ffmpeg用法：[http://blog.csdn.net/hemingwang0902/article/details/4382429][6]

**命令需根据实际情况修改**
```
ffmpeg -i test.mp4 -ss 01:50 -t 00:01 -r 24 -f image2 frames/%06d.png
ffmpeg -i test.mp4 -ss 01:50 -t 00:01 audio.mp3
```
回到waifu2x-caffe，选择png所在文件夹，设置如图  
![](/pictures/waifu2x/3.PNG)
![](/pictures/waifu2x/as.PNG)
*设置*
如果你使用的是N卡，将右上角改为CUDA会快很多。

这一步需要很长时间，笔者的E-350 CPU笔记本处理一张png的时间是1:39，所以暂时只实验1S。 [=_=|||]

处理前：
![](/pictures/waifu2x/000015.png)
处理后：
![](/pictures/waifu2x/000015a.png)
（不要问我用的啥片源，手里实在没有别的了。。。。）
**再封装**
命令
```
ffmpeg -f image2 -framerate 输入帧数 -i frames/%d.png -i audio.mp3 -r 帧数 -vcodec libx264 -crf 16 video.mp4
ffmpeg -f image2 -framerate 24 -i frames/%d.png -i audio.mp3 -r 24 -vcodec libx264 -crf 16 video.mp4
```
最终效果：  
![](/pictures/waifu2x/e.PNG)


  [1]: https://github.com/nagadomi/waifu2x
  [3]: http://waifu2x.udp.jp/
  [6]: http://blog.csdn.net/hemingwang0902/article/details/4382429
