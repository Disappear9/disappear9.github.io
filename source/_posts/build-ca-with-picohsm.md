---
title: 灵上加灵：使用 Pico HSM 和 step-ca 自建一个CA
date: 2025/1/20 12:00:00
categories:
- 教程
tags:
- 教程
- 折腾那些事
---

### 引言
前几天在Canokey群看到一个软件：[step-ca](https://github.com/smallstep/certificates)  
简单说就是用这个软件可以自建一个CA来玩，而且软件支持HSM设备

那这不再折腾一下似乎就有点不合适了。  

-------

### 环境确认

硬件信息：  
&emsp;&emsp;CanoKey Canary（3.0.0-rc2-0 dirty build）  
操作系统：  
&emsp;&emsp;Windows 10 LTSB 21H2  
软件版本：  
&emsp;&emsp;gpg4win 4.4 (gpg 2.4.7)  
&emsp;&emsp;OpenSC 0.26.0  

<!--more--> 




![1.png](/pictures/canokey-canary/1.png)   