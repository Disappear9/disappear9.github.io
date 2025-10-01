---
title: 博客程序更换至HEXO
date: 2017/12/21 21:11:12
updated: 2017/12/21 21:11:12
toc: true
categories:
- 折腾那些事
tags:
- 折腾那些事
---
## <del>美国 罗利 美国 罗利 Openshift倒闭了</del>  

我在8月份的时候收到了来自Openshift的这样一封邮件：  
```
Valued OpenShift Online user,
Today, we announce the sunset of the previous generation OpenShift Online 2 platform. After September 30th, 2017, Red Hat OpenShift Online 2 (our Free, Bronze, and Silver offerings in v2) will no longer be available. 
............
If you’re still using the previous generation OpenShift Online 2 platform, you can find step-by-step instructions in our Migration Center to help you easily migrate your applications.
Migrate by September 30th, 2017
............
```

大意就是老的空间准备关了，请换到新的。
而时并没有在意，因为我知道从截至日期到完全关停还是有很长时间可以苟的，然而，我错了......
到截至日期一个星期后，我的Blog炸了......
而且一炸就是一个多月........
不过还好，我有备份，但是找个新的空间就成了问题。
查了半天，国内的空间要各种认证，国外的即使加上CDN访问速度也很慢。
然后，我偶然间得知Github提供了一个叫Git pages的服务，可以拿来托管一些静态页面
好了我的Blog有救了！
<!--more-->
## 配置环境
**安装Node**
作用：用来生成静态页面的 到Node.js官网（https://nodejs.org/ ）下载相应平台的最新版本，安装即可。
**安装Git&申请Github帐号**
直接apt install就行

## 安装&配置HEXO
```
sudo npm install -g hexo
mkdir blog
cd blog
hexo init
```
这会在当前目录建立HEXO的主目录blog  

安装一些组件，然后测试能不能正常运行：  
```
sudo npm install hexo-server
npm install hexo-server --save
npm install hexo-renderer-ejs --save
npm install hexo-renderer-stylus --save
npm install hexo-renderer-marked --save
npm install hexo-deployer-git --save
hexo g
hexo s
```
这时打开浏览器访问http://localhost:4000 应该能看到示例页面  
## 配置Github
**建立Repository**
建立与你用户名对应的仓库，仓库名必须为 (你的用户名.github.io)
导入好SSH密钥
然后暂时不需要管他了
## 配置Blog
编辑 **_config.yml**
```
nano _config.yml
```
具体内容请看官方文档（修改网站标题，语言，时区之类的）： https://hexo.io/docs/configuration.html
主要还需要更改这些：
```
deploy:
  type: git
  repository: https://github.com/用户名/用户名.github.io.git
  branch: master
```
配置好Git以后，直接运行：
```
hexo d
```
这样就完成了初步部署，浏览器中打开https://用户名.github.io 就可以看到初步成型的博客了。
## 绑定域名
在blog目录下的source文件夹中新建一个名为CNAME的文件，文件里写上你的域名**（不带http:// ）**
然后在你的域名控制面板里建立一个到 用户名.github.io 的CNAME记录

**如果你对目前的博客感到满意，那么看到这里就可以关掉这个页面了，然后去看看官方文档就可以开始正常写作了**
## 换个主题
我使用的主题是yilia
https://github.com/litten/hexo-theme-yilia

在Blog/theme下运行git clone https://github.com/litten/hexo-theme-yilia.git
然后把hexo-theme-yilia更名为yilia
编辑blog目录下的 **_config.yml**
```
theme: yilia
```
然后似乎也没什么需要我写的了，主题作者的说明写的很详细

## 加个Live2d
就是现在你屏幕右下角的这个，眼睛还会随着你的鼠标运动。
https://github.com/EYHN/hexo-helper-live2d/blob/master/README.zh-CN.md
老版本还需要改layout.ejs来着，现在不需要了，原作者的文档写的很清楚。
喜欢哪个模型就直接 **npm install 模型的包名**，然后把_config.yml 中use:字段改一下

我的配置：
{% codeblock lang:yaml %}
live2d:
  enable: true
  scriptFrom: local
  model:
    use: live2d-widget-model-koharu
  display:
    position: right
    width: 75
    height: 150
    hOffset: 50
    vOffset: -15
  mobile:
    show: true
    scale: 0.5
  react:
    opacityDefault: 0.7
    opacityOnHover: 0.2
{% endcodeblock %}
## 配置评论
多说，畅言，网易之类的不是被墙就是要求备案，所以我用了Gitment
yilia主题自带Gitment，直接修改主题文件夹的_config.yml就好
{% codeblock lang:yaml %}
gitment_owner: disappear9
gitment_repo: 'disappear9.github.io'
gitment_oauth:
  client_id: 'id'
  client_secret: 'secret key'
{% endcodeblock %}
然后在https://github.com/settings/developers 中新建一个OAuth App

![](/pictures/Move-to-HEXO/1.png)
**Authorization callback URL要填你的最终的博客地址**
然后访问任意一篇文章，登录创建Github仓库的账号
授权完成后会看到一个初始化的按钮，按下它，就会在 用户名.github.io 仓库创建一个用于存储评论的issues（**这一步不要在本地调试的时候做，不然100%报错**）
![](/pictures/Move-to-HEXO/2.png)

**然后紧跟着还有一个坑**

因为Github对label的字数限制，所以会出现 **Error：validation failed**
你需要更改blog目录下的_config.yml：
{% codeblock lang:yaml %}
#URL
##If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: https://thinkalone.ga/ #<<<<<<<<<<<<<这里，改成你的域名
root: /
permalink: :title.html
......
# Writing
new_post_name: :title.md #<<<<<<<<<<<<<这里，只保留标题
default_layout: post
{% endcodeblock %}

或更改主题 **/layout/_partial/post** 目录下的 **gitment.ejs** 文件 如果你使用的也是yilia主题

{% codeblock lang:javascript %}
<div id="gitment-ctn"></div> 
<link rel="stylesheet" href="//imsun.github.io/gitment/style/default.css">
<script src="//imsun.github.io/gitment/dist/gitment.browser.js"></script>
<script>
var gitment = new Gitment({
  id: "<%= page.title %>",
  owner: '<%=theme.gitment_owner%>',
  repo: '<%=theme.gitment_repo%>',
  oauth: {
    client_id: '<%=theme.gitment_oauth.client_id%>',
    client_secret: '<%=theme.gitment_oauth.client_secret%>',
  },
})
gitment.render('gitment-ctn')
</script>
{% endcodeblock %}

## 参考
http://baixin.io/2015/08/HEXO%E6%90%AD%E5%BB%BA%E4%B8%AA%E4%BA%BA%E5%8D%9A%E5%AE%A2/
http://xichen.pub/2018/01/31/2018-01-31-gitment/






