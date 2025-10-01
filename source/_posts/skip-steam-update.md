---
title: 如何优雅的跳过/禁止Steam更新你的游戏
date: 2021/1/22 21:00:00
updated: 2021/1/22 21:00:00
toc: true
categories:
- 教程
tags:
- 教程
---

![head](/pictures/skip-steam-update/head.png)

买了个Beatsaber， 每次Steam更新游戏都会让自己装的插件失效，而不更新又没法启动游戏......
<!--more-->

## 1.关闭自动更新 ##
这个应该不用说了，防止被Steam抢先更掉。

    在Steam中 游戏 -》 右键属性 -》 更新 -》 自动更新 -》 只在我启动时更新此游戏

## 2.找到游戏对应的acf文件 ##
在Steam商店找到你的游戏，复制URL`/app/`后的一串数字，这是游戏的`appid`。

![findfile](/pictures/skip-steam-update/findfile.png)

直接用文件管理器搜索`appid`，找到扩展名为acf的文件，以我要修改的Beatsaber为例：

然后用你喜欢的文本编辑器打开acf文件

## 3.在Steamdb找数据 ##
打开 [Steamdb](https://steamdb.info/) ，把`appid`粘贴进去。

![search](/pictures/skip-steam-update/search.png)

打开`History`标签

![history](/pictures/skip-steam-update/history.png)

找到`timeupdated` `buildid` `maxsize` `manifests`，并记下绿色高亮的数值。

![changelist](/pictures/skip-steam-update/changelist.png)

## 4.修改acf文件 ##
### 修改前要先完全关闭steam ###

![modify](/pictures/skip-steam-update/modify.png)

将`StateFlags`改为`4`，然后将上面复制的值一一对应覆盖原来的值。

    timeupdated -> LastUpdated
    buildid -> buildid
    manifests -> manifest
    maxsize -> size

保存后再启动steam，完成