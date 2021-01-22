---
title: 炫酷的渗透系统Parrot Security OS
date: 2015/5/1 13:46:25
categories:
- 工具
tags:
- 工具
- 网络安全
---
Parrot Security OS是一款基于Debian渗透测试系统，集成了诸多流行渗透测试工具，并以其漂亮的UI而出名。

![](/pictures/Parrot-Security-OS/14300153781409.jpeg)

# 部分内置工具

>aircrack-ng
airmode
apache2
apache-users
apktool
arping
asleap
autopsy
bbqsql
bed
binwalk
bluelog
bluemaho
bluepot
blueranger
bokken
bully
bulk-extractor
burpsuite
......
<!--more-->
[查看全部点我][2]

**安装过程**

首先我们要去官网下载ISO镜像。网址：[http://www.parrotsec.org/][3]

在download菜单下，我选择了I386,因为我不知道我的X64的CPU选那个最好，AMD64是应用于64位的系统的，但是不知道inter的CPU会如何。下载说明里没有详细说明。因为我是虚拟机安装，所以就使用了i386,肯定是OK的 不满各位说其实我是都下载了下来一个个试的才成功的……其它的都是安装到一半就卡死了……
由于parrot这个系统是基于debian的，所以如果大家使用的低版本的VM虚拟机，记得选择debian，由于我使用的是VM11，所以不需要这么选择。最后20G空间足以。

 进入选择界面，选择第一个。这类的安装器都一样。


 然后有一个登陆界面，这里输入了root、密码toor进入。

![](/Parrot-Security-OS/14300153479571.jpeg)
 然后就是一个系统桌面了，这里就可以使用这个系统了，不过目前还没有安装在硬盘上，所以做配置更改应该是不能保存的。
 
![](/pictures/Parrot-Security-OS/14300153781409.jpeg)
 _作者：MonkeyKing，转载请注明来自Freebuf黑客与极客（FreeBuf.COM）_


  [2]: http://www.parrotsec.org/tools
  [3]: http://www.parrotsec.org/
