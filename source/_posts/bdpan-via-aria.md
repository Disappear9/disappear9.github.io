---
title: 使用Aria2满速下载百度网盘资源
date: 2017/3/3 20:45:15
categories:
- 教程
tags:
- 折腾那些事
- 教程
---

**首先，感谢网盘插件的作者acgotaku**

安装Aria2
-------
官方的aria2[限制了同服务器连接数][1]为最大16个。。。。表示不能理解（MDZZ）
所以我直接编译了一个去掉了限制的版本 [百度盘][2]（密码：3qim）（我也不知道有什么副作用）

<!--more-->

配置Aria2
-------
Aria2有两种下载模式,一种是命令行下载模式,一种是RPC Server模式.前者不建议使用,后者的使用方式很方便. RPC模式就是启动之后什么也不做,等着通过RPC接口接受下载请求.下载完也不会退出,一直等待. 使用命令行加参数的方式配置Aria2非常不推荐,建议使用配置文件的方式,下面贴出我的配置文件.

将下面的内容保存为aria2.conf，和上面的aria2.exe放在同一目录下。
***将第一行的内容修改为你的密码。***
===========================================================================

	rpc-secret=你的密码
	#设置连接密码
	#允许所有来源, web界面跨域权限需要
	rpc-allow-origin-all=true
	#允许外部访问，false的话只监听本地端口
	rpc-listen-all=true
	#最大同时下载数(任务数), 路由建议值: 3
	max-concurrent-downloads=8
	#断点续传
	continue=true
	#同服务器连接数
	max-connection-per-server=32
	#最小文件分片大小, 下载线程数上限取决于能分出多少片, 对于小文件重要
	min-split-size=6M
	#单文件最大线程数, 路由建议值: 5
	split=32
	#下载速度限制
	max-overall-download-limit=0
	#单文件速度限制
	max-download-limit=0
	#上传速度限制
	max-overall-upload-limit=0
	#单文件速度限制
	max-upload-limit=0
	#文件保存路径, 默认为当前启动位置
	dir=D:\Downloads
	#文件缓存, 使用内置的文件缓存, 如果你不相信Linux内核文件缓存和磁盘内置缓存时使用, 需要1.16及以上版本
	#disk-cache=0
	#另一种Linux文件缓存方式, 使用前确保您使用的内核支持此选项, 需要1.15及以上版本(?)
	#enable-mmap=true
	#文件预分配, 能有效降低文件碎片, 提高磁盘性能. 缺点是预分配时间较长
	#所需时间 none < falloc ? trunc << prealloc, falloc和trunc需要文件系统和内核支持
	file-allocation=falloc

开启cmd，cd到aria2c的目录下，运行命令：

	aria2c.exe --conf-path=aria2.conf

或者把上面这行存为start.bat，放到aria2c的目录下，双击运行

管理Aria2的下载任务
------------

[YAAW在线版][3]
点击右上角的扳手，将RPC PATH修改为http://token:你的密码@127.0.0.1:6800/jsonrpc
其他的不需要设置

安装百度网盘插件
--------
链接: [https://pan.baidu.com/s/1skWqWjz][4] 密码: m9xj

**下载后解压到一个你不会随便删掉的地方**

你需要Chrome或Firefox

Chrome : 设置 -> 扩展程序 -> 勾选 开发者模式-> 加载已解压的扩展程序
Firefox : 在地址栏输入 **about:debugging** , 勾选 启用附加组件调试，点击临时加载附加组件，选择文件夹内的manifest.json

然后，打开[pan.baidu.com][5]，你会看到这样一个东西
![](/pictures/bdpan-via-aria/2017-03-03_20-18-05.png)
点击设置
![](/pictures/bdpan-via-aria/2017-03-03_20-18-51.png)
RPC地址请参照上面的 **管理Aria2的下载任务**
选中你想要下载的文件，导出下载 => aria2rpc

效果

![](/pictures/bdpan-via-aria/example.PNG)

解决每次开启Chrome都提示禁用
-----------------
打开 **chrome://extensions**
记下扩展 网盘助手的 ID，像这样：

	ID： eppgadbgkjo63216967523eiabpgjfph

下载这个文件：[https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip][9]（可能需要挂代理）
解压里面的 Windows/adm/zh-CN/chrome.adm
按下WIN+R键，运行gpedit.msc
打开 计算机配置 => 管理模板 右键单击管理模板 => 添加/删除模板 => 选择chrome.adm
打开 经典管理模板 / Google / Google Chrome / 扩展程序

![](/pictures/bdpan-via-aria/2017-03-03_20-44-25.png)

双击打开 **配置扩展程序安装白名单** 选择 **已启用**
点击下面的 显示 然后把ID复制进去

![](/pictures/bdpan-via-aria/jZUn0Xb.png)

重启Chrome




  [1]: https://github.com/aria2/aria2/issues/580
  [2]: https://pan.baidu.com/s/1ctMdhO
  [3]: http://binux.github.io/yaaw/demo/
  [4]: https://pan.baidu.com/s/1skWqWjz
  [5]: http://pan.baidu.com
  [9]: https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip
