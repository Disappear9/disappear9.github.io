---
title: 使用脚本在E站下载本子（E-Hentai Downloader）
date: 2017/7/29 23:27:22
categories:
- 教程
tags:
- 教程
---

## 注意 ##
**我个人并不推荐使用这种方法来下载E站的本子，因为这样会给服务器造成很大压力，而且配额限制是根据ip来的，如果你的ip是共用的，你把配额用完别人也跟着受限。所以除了画廊无种或死种，画廊有种子就尽量用Torrent Download，并且下载完多挂会，毕竟E站也会计算分享率的。**

<!--more-->

## 要求 ##
1. 有耐心
2. 正在使用以下任意一种浏览器：  

>Firefox  
Chrome  
Opera 15以上版本  
Maxthon  
Microsoft Edge（**Windows 10 14393 以上版本的Edge才能安装扩展**）  
Safari 10.1以上版本  
Yandex Browser for Android（**如果你对你手机的内存有信心的话**）  


## 安装 ##

**Step.1** 安装Tampermonkey扩展

Firefox > [Tampermonkey](https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/)  
Chrome > [Tampermonkey](http://tampermonkey.net/)（请使用Stable版本）  
Opera > [Tampermonkey](https://addons.opera.com/extensions/details/tampermonkey-beta/)  
Maxthon > [Violentmonkey](http://extension.maxthon.cn/detail/index.php?view_id=1680)（傲游只有这个，不过也是一样的）  
Microsoft Edge > [Tampermonkey](https://www.microsoft.com/store/p/tampermonkey/9nblggh5162s)  
Safari > [Tampermonkey](https://tampermonkey.net/?browser=safari)  
Yandex Browser for Android > [Tampermonkey](https://addons.opera.com/zh-cn/extensions/details/tampermonkey-beta/)  

**Step.2** 安装脚本  
[GitHub链接](https://github.com/ccloli/E-Hentai-Downloader/raw/master/e-hentai-downloader.user.js)  
[GreasyFork链接](https://sleazyfork.org/scripts/10379-e-hentai-downloader)  
点击上面**任意一个**链接，如果你的Tampermonkey安装正确的话会直接跳出脚本的安装界面（P.S. GreasyFork需要手动点击安装）（P.P.S 至少在Firefox和Chrome上是这样的......）
![](/pictures/E-Hentai-Download/install.jpg)

（由于我已经安装过了，所以这里显示为重新安装）  


## 使用 ##

1. 打开[g.e-hentai.org](g.e-hentai.org)或[exhentai.org](exhentai.org)，随意打开一个画廊，如果画廊详情的下面出现这样一个东西，说明脚本生效了
![](/pictures/E-Hentai-Download/ok.jpg)

	从左到右分别是：**下载，在图片的前面加上编号，设定下载范围，设置，反馈**  
2. 点击**Settings**，按图设置
![](/pictures/E-Hentai-Download/set1.jpg)
![](/pictures/E-Hentai-Download/set2.jpg)

3. 点击**Download Archive**，浏览器窗口的右下角会出现下载进度和画廊信息
![](/pictures/E-Hentai-Download/downloading.jpg)

	**需要注意的是，这个脚本会在图片下载完成后才合成Zip压缩包，在这之前所有图片会缓存到内存里，这也就是为什么我前面说用Yandex Browser for Android需要对自己的内存有信心，所以如果你关闭了这个标签页或者手贱关闭了浏览器。。。。。嗯（标签）**  

## 需要注意的一些事情 ##

1. 下载的配额限制（这里我直接引用作者Wiki的文章）：

>English Version: https://github.com/ccloli/E-Hentai-Downloader/wiki/E%E2%88%92Hentai-Image-Viewing-Limits

你的浏览限额可以在 [http://g.e-hentai.org/home.php](http://g.e-hentai.org/home.php) 看见

**你可以花费 GP 或 Credits 来重置浏览限额**

以下数据均为个人测试，所以可能并不准确。

**对于登录用户，你每天拥有 5000 点浏览限额（通常情况下）**
请注意，**浏览限额的使用是根据你的 IP 地址计算的**，如果你正在使用一个公共的 IP 地址，那么你的限额的使用量是所有使用该 IP 地址的所有 E-Hentai 用户。

**如果你拥有 Bronze Donation （捐赠额度达到 $20），浏览限额将按照你的账户进行计算，而不是 IP。**此外你还可以通过捐赠和购买 Hath Perk 来提升你的浏览限额。
所有的 E-Hentai 网站使用相同的浏览限额系统
E-Hentai、Lofi@E-Hentai 以及 ExHentai 使用同一套系统计算你的限额使用量，所以你的限额使用量是以上所有网站使用量的总和。
访问图片浏览页（获取图片地址）消耗 1 点限额
访问图片浏览页（URL 类似于 g.e-hentai.org/s/[图片 ID]/[图册 ID]-[页码]）将消耗 1 点限额。无论浏览器是否成功下载用于浏览的压缩图片，或者无论这张图片被访问多少次，都不会对你的限额造成任何影响。

在 2016 年 3 月 3 日和 3 月 13 日的更新中，E-Hentai 分别支持了移动版图像（Lofi images，低分辨率图像）和高分辨率图像，所以限额消耗也会依据图片尺寸进行计算。

**Auto (1280x)：1 点  
980x：1 点  
780x：1 点  
1600x：3 点（或许是，在更新本文时作者发现自己似乎没有权限了，所以这是凭记忆的）  
2400x：5 点  
访问带有 nl 参数的图片浏览页消耗 6 点限额**  

**访问带有 nl 参数的图片浏览页**（即点击浏览页下方的“Click here if the image fails loading”后的地址，URL 类似于 g.e-hentai.org/s/[图片 ID]/[图册 ID]-[页码]?nl=[NL 参数]）将消耗 6 点限额。这个有点卧槽，只是切换个节点而已就**要 6 点** = = （实际上，带有 nl 参数的地址代表不要从 H@H 加载图片，而是从原始服务器加载）  
下载压缩的图片将不会消耗限额  

**无论浏览器是否成功下载用于浏览的压缩图片，或者无论这张图片被访问多少次，都不会对你的限额造成任何影响。**  
**下载原始图片 每 0.2 MB 消耗 1 点限额**
当访问原始图片的 302 跳转页（URL 类似于 g.e-hentai.org/fullimg.php?gid=[GID]&page=[页码]&key=[奇怪的 token]，这个链接就是浏览页下方的“Download original [X] x [Y] [文件大小] source”这串文字的链接），文件大小每达到 0.2 MB 将消耗 1 点限额（从 2016 年 10 月或稍早些开始使用该标准，之前是固定 6 点限额）。举个例子，2 MB 的图片将消耗 10 点，2.1 MB 的图片也将消耗 10 点，而 2.2 MB 的图片将消耗 11 点。您可以查看这里来了解我们的测试详情。

但是只有访问这个跳转页会消耗限额，这意味着，访问最终的图片地址（URL 类似于 [服务器 IP]/ehg/image.php?... 或者 [服务器 IP]/im/...）将不会消耗限额。所以在 E-Hentai Downloader 1.12 1.14 中（由于逻辑错误而最终在 1.14 实现），当原始图片下载失败后，脚本将访问最终的图片地址进行下载（在旧版本中，脚本将访问之前的跳转页）
**限额的已使用量每分钟减少 3 点**


## 常见错误和高级用法 ##
作者的Wiki上还有一些文章，我就不搬运了：  
[Can't make Zip file successfully](https://github.com/ccloli/E-Hentai-Downloader/wiki/Can't-make-Zip-file-successfully)（提示不能创建Zip文件）  
[Cross origin request warning from Tampermonkey](https://github.com/ccloli/E-Hentai-Downloader/wiki/Cross-origin-request-warning-from-Tampermonkey)（Tampermonkey经常出警告）  
[Tagging gallery archives and saving then by types in respective folders (Chrome and Firefox)](https://github.com/ccloli/E-Hentai-Downloader/wiki/Tagging-gallery-archives-and-saving-then-by-types-in-respective-folders-(Chrome-and-Firefox))（已Tag对本子进行分类）



（完） 
 
