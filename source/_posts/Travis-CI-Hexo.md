---
title: 使用 Travis CI 自动构建 Hexo 博客
date: 2019-02-06 12:44:30
categories:
- 折腾那些事
tags:
- 折腾那些事
- 教程
---

## 配置 GitHub 仓库
**注意：以下全部操作尽量不要在Windows系统下操作**
建立一个source分支，放入`scaffolds` `source` `themes`文件夹和`_config.yml` `package.json`文件
```
mkdir source
cd source
git init
git remote add origin git@github.com:Disappear9/disappear9.github.io.git
git checkout --orphan source
git add .
git commit -m "Initial commit"
git push origin source:source
```
创建 `.travis.yml`
```
language: node_js
node_js: stable
```
## 配置 Travis CI
用Github登录并且关联项目

### 配置Deploy keys
让Travis CI可以push到你的仓库
<!--more-->
生成一个 ssh 密钥对：
```
$ ssh-keygen -t ed25519 -f travis.key
```
把travis.key.pub中的内容粘贴到Deploy keys
![](/pictures/Travis-CI-HEXO/Deploykeys.png)

### 加密私匙
总不能把私匙直接放项目里把？
**下面第一个坑来了：**
我们需要安装 Travis 的命令行工具
```
$ sudo apt install ruby
$ sudo gem install travis
```

**瞬间报错**
```
ERROR:  Error installing ffi:
    ERROR: Failed to build gem native extension.
```
Google了一圈，缺依赖，安上：
```
apt install ruby-dev curl
```
好了，能正常运行了
登录 Travis 并加密文件
```
# 如果是私有项目要加 --pro 参数
$ travis login --auto
# 加密完成后会在当前目录下生成 travis.key.enc 文件
$ travis encrypt-file travis.key -add
```
如果使用Windows系统，到这一步就会各种报错，官方甚至直接把这条[写进了文档](https://docs.travis-ci.com/user/encrypting-files/#caveat)，说明不要在Windows系统下操作
```
Caveat #
There is a report of this function not working on a local Windows machine. Please use the WSL (Windows Subsystem for Linux) or a Linux or macOS machine
```
加密完成后把travis.key.enc放进travis文件夹，查看.travis.yml会发现多了这样一行
```
openssl aes-256-cbc -K $encrypted_************_key -iv $encrypted_************_iv 
 -in .travis/travis.key.enc -out ~/.ssh/id_rsa -d
```
其中的`$encrypted_************_key`和`iv`应该会被自动添加到Travis的环境变量
然而在我这里并没有

**然后就是第二个坑**
你需要在运行`$ travis encrypt-file travis.key -add`时加上 --debug参数，这样工具就会打印出API日志，其中value长度为32位的是iv，更长的是key,然后手动把他们加入到Travis的环境变量（添加的时候不要把前面的$符号打进去，不然又是报错）（手贱这一下我调了半天没找到错误在那......）

## 编写 .travis.yml
.travis.yml
```
language: node_js
node_js: stable
branches:
  only:
  - source

cache:
  yarn: true
  directories:
  - node_modules
  - themes
# 添加github.com为信任主机，不然git push会失败
addons:
  ssh_known_hosts:
  - github.com

before_install:
- openssl aes-256-cbc -K $encrypted_************_key -iv $encrypted_************_iv -in travis/travis.key.enc -out ~/.ssh/id_ed25519 -d
- chmod 600 ~/.ssh/id_ed25519
- git config --global user.name "Disappear9"
- git config --global user.email "disappear9@outlook.com"
- chmod +x travis/deploy.sh

install:
- yarn

script:
- hexo clean
- hexo generate
# 用deploy.sh来git commit + git push
after_success:
- travis/deploy.sh
```
deploy.sh（放进travis文件夹）
```
#!/bin/bash
set -ev
export TZ='Asia/Shanghai'

git clone --depth=1 -b master git@github.com:Disappear9/disappear9.github.io.git .deploy_git

cd .deploy_git
git checkout master
mv .git/ ../public/
cd ../public

git add .
git commit -m "Site updated: `date +"%Y-%m-%d %H:%M:%S"`"
git push origin master:master --force
```
上面这些步骤做完后你的目录看起来应该是这样的
![](/pictures/Travis-CI-HEXO/finish.png)

https://github.com/Disappear9/disappear9.github.io/tree/source
欢迎参考

完成后`git push origin source:source` 这样Travis ci就会开始构建了


## 参考链接：
https://blessing.studio/deploy-hexo-blog-automatically-with-travis-ci/
https://segmentfault.com/a/1190000013286548
