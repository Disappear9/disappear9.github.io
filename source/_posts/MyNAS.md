---
title: 以NAS为中心的全平台娱乐方案
date: 2017/1/31 18:40:36
categories:
- 教程
tags:
- 折腾那些事
- 教程
---

目标：
---

1）所有文件均储存在NAS上，且由NAS完全承担下载任务。  
2）在所有终端都可直接使用NAS内文件。  
3）维护NAS时不需要物理接触。  

----------
<!--more-->

需求：
---

1）千兆口的路由。笔者使用的是Netgear的WNDR3800（因为便宜啊╮(╯_╰)╭）  
2）一台自建的，运行Windows系统的NAS。（正在使用商业NAS的请忽略，因为笔者没用过╮(╯ ╰)╭）  

笔者的NAS配置：
---------

	操作系统：Microsoft Windows 7 旗舰版 (BUILD:7601) (64-bit) （因为显卡驱动不支持32位的系统） 
	CPU信息：Intel(R) Celeron(R) CPU N3150 @ 1.60GHz 
	主板信息：Colorful (七彩虹) C.N3150M-K PRO 内存信息：4.0 GB
	显卡信息：Intel(R) HD Graphics 
	硬盘信息：ST1000DM003-9YN162 ATA Device (1.0 TB) ST3160815AS ATA Device (160.0 GB)
	网卡信息：Realtek PCIe GBE Family Controller (本地连接)

3）各种各样的软件。。。。

----------

具体方案：
-----

NAS部分：

1）安装&配置VNC  
用到的软件：RealVNC Enterprise（为了能远程控制NAS，可以再装一个TeamViewer）    
一路（Next），最后会出现要求输入注册码的界面（HA7MG开头的注册码还能用）注册成功。  
在通知栏的VNC图标上右键--Options：  
![](/pictures/MyNAS/MyNAS2017-01-31_14-45-35.png) 
单击下面的Users & Permissions page  
![](/pictures/MyNAS/MyNAS2017-01-31_14-49-55.png)
单击Standard User （user），配置密码  
![](/pictures/MyNAS/MyNAS2017-01-31_14-56-30.png)
最后点击右下角的Apply应用设置  
VNC配置部分（完）  
  
2）配置文件共享  
  点击通知栏上的网络图标，打开网络和共享中心，将网络类型改为家庭网络。  
![](/pictures/MyNAS/MyNAS2017-01-31_15-35-01.png)
![](/pictures/MyNAS/MyNAS2017-01-31_15-22-27.png)

更改高级共享设置（设置如图）  
![](/pictures/MyNAS/MyNAS2017-01-31_15-38-14.png)
![](/pictures/MyNAS/MyNAS2017-01-31_15-38-32.png)
回到桌面，右键“计算机”--选择“管理”  
在“管理”界面，依次展开--“本地用户和组”--“用户”  
![](/pictures/MyNAS/MyNAS2017-01-31_15-44-31.png)
新建一个用户  
![](/pictures/MyNAS/MyNAS2017-01-31_15-45-30.png)  
然后把新建的账户隐藏：  
>教程链接：http://jingyan.baidu.com/article/f96699bb81ace6894f3c1b7b.html
  
  
选择需要共享的文件夹/硬盘（笔者是将整个硬盘都共享，这样会方便很多）  
打开磁盘的属性--共享--高级共享，勾选（共享此文件夹），单击（权限）按钮。  
![](/pictures/MyNAS/MyNAS2017-01-31_16-06-22.png) 
点击（添加）,在文本框中输入刚才新建的用户名，点击检查名称，确定。  
![](/pictures/MyNAS/MyNAS2017-01-31_16-08-20.png)
**删除Everyone**，勾选（完全控制）。一路确定。    
![](/pictures/MyNAS/MyNAS2017-01-31_16-11-38.png)
**配置文件共享（完） **   

    
4)**安装各种软件**   
utorrent，百度云管家......      

5）**配置远程下载 **   
**这里的远程下载是给手机端用的**

百度云管家的远程下载不用介绍了吧。。。。

需要uTorrent3.3以上版本    
打开 设置--远程控制    
![](/pictures/MyNAS/MyNAS2017-01-31_19-28-41.png)
设置好 **计算机名** 和 **密码**。    

PC部分：   
1）使用共享的文件    
打开控制面板--凭据管理器    
![](/pictures/MyNAS/MyNAS2017-01-31_16-50-42.png)
点击（添加Windows凭据）    
![](/pictures/MyNAS/MyNAS2017-01-31_16-55-34.png)
计算机名在 （计算机--属性） 里    
![](/pictures/MyNAS/MyNAS2017-01-31_17-00-28.png)
然后就可以打开 （网络） 直接使用NAS里的文件辣。ヾ(*´▽‘*)    
![](/pictures/MyNAS/MyNAS2017-01-31_17-10-26.png)
![](/pictures/MyNAS/MyNAS2017-01-31_17-07-58.png)
  
  
  
**Ext**：如何优雅的看漫（ben）画（zi）（PC篇）    
听说你还在手动解压？    
软件：Honeyview（直接读取压缩包内图片，无需解压，支持加密的压缩包）    
![](/pictures/MyNAS/MyNAS2017-01-31_17-25-28.png)
**注：中文密码可能需要先打出来再粘贴到密码输入框里**。（效果图）    
![](/pictures/MyNAS/MyNAS2017-01-31_17-17-08.png)
2）**使用网络唤醒**    
教程链接：http://www.iplaysoft.com/wol.html    

3）**连接远程桌面**    
软件：VNC Viewer https://www.realvnc.com/download/viewer/    
    
**手机部分： **  

1）浏览NAS上的视频    
需要的软件：ES文件浏览器（[去广告版](http://www.zdfans.com/6011.html)），MX Player pro（[去广告版](http://www.zdfans.com/1300.html)）    
打开 ES文件浏览器--我的网络--新建--局域网    
![](/pictures/MyNAS/MyNASScreenshot_2017-01-31-18-12-32.png)
**Done！**  
![](/pictures/MyNAS/MyNASScreenshot_2017-01-31-18-13-44.png)
![](/pictures/MyNAS/MyNASScreenshot_2017-01-31-18-14-13.png)

**2）漫画**    
需要的软件：Perfect Viewer  
![](/pictures/MyNAS/MyNASScreenshot_2017-01-31-18-10-07.png)
![](/pictures/MyNAS/MyNASScreenshot_2017-01-31-18-11-47.png)


>**这个APP的功能和PC上的HoneyView差不多，就是广告有点烦人，在存储卡/Andriod/data/com.rookiestudio.perfectviewer/下新建一个cache文件可以防止百毒推广下载文件**。    

如果你的手机是Root过的，最好把/data/data/com.rookiestudio.perfectviewer/cache目录下的百毒推广文件夹的权限设置为000。    
3）远程桌面    
软件：VNC Viewer [https://www.realvnc.com/download/viewer/android/](https://www.realvnc.com/download/viewer/android/)    
4）远程下载    
软件：µTorrent Remote [http://www.coolapk.com/apk/com.utorrent.web](http://www.coolapk.com/apk/com.utorrent.web)    

iPad/iPhone部分(iOS)：
--------------

以下软件都可以从appstore直接下载。
（用国产的各种助手可以免越狱安装）
(nPlayer是收费的，有能力的尽量去支持一下作者)
1）远程桌面
**VNCViewer**
![](/pictures/MyNAS/MyNASIMG_0017.PNG)

2）浏览NAS上的视频
**nPlayer**
![](/pictures/MyNAS/MyNASIMG_0018.PNG)
![](/pictures/MyNAS/MyNASIMG_0020.PNG)
  
