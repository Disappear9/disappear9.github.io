---
title: 使用 GitHub Actions 自动部署Hexo
date: 2020/12/26 21:00:00
updated: 2020/12/26 21:00:00
toc: true
categories:
- 教程
tags:
- 教程
- 折腾那些事
---

![](/pictures/hexo-on-action/head.png)

2019年时给博客配置了Travis CI 自动构建，然后前几天准备发个文章，写完反手一个`git push`博客就崩了。

<!--more-->

## Hexo ##

首先你的Hexo必须是已经在本地环境下配置好的，能正常运行`hexo g`。

## 生成&配置秘钥 ##

使用`ssh-keygen`生成一对秘钥
```
ssh-keygen -t ed25519 -C "Hexo Deploy Key" -f github-deploy-key
```
直接回车，不要设置密码

在 GitHub 上打开`仓库-> Settings -> Secrets`添加一个Secrets，`Name`填`HEXO_DEPLOY_KEY`，`Value`把上面生成的**私钥**粘贴进去

![](/pictures/hexo-on-action/new.png)

![](/pictures/hexo-on-action/new-ok.png)

打开`仓库-> Settings -> Deploy keys`添加一个Key，`Title`填`HEXO_DEPLOY_PUB`，`Key`把上面生成的**公钥**粘贴进去，勾选下面的`Allow write access`

![](/pictures/hexo-on-action/new-key.png)

## 准备文件 ##
创建一个空的分支，从原有的hexo源文件目录下拷贝这些文件&文件夹：

- [x] scaffolds
- [x] source
- [x] themes
- [x] _config.yml（hexo的）
- [x] package.json

## 修改配置文件 ##
为了防止以后由于长时间未维护，主题或hexo更新导致的博客炸掉，所以配置主题为submodule。
```
git submodule add https://github.com/JoeyBling/hexo-theme-yilia-plus themes/yilia
```
在_config.yml的最后添加一项`theme_config:`

参考：https://blog.xxwhite.com/2020/blog-ci.html#%E4%B8%BB%E9%A2%98%E5%AD%90%E6%A8%A1%E5%9D%97%E5%8C%96

![](/pictures/hexo-on-action/config.png)

## 配置Workflow ##
创建一个新文件：`.github/workflows/deploy.yml`
{% codeblock .github/workflows/deploy.yml lang:yaml %}
name: Hexo Deploy

on:
  push:
    branches:
      - source                          #被监控的分支，当这个分支有改动时触发

jobs:
  build:
    runs-on: ubuntu-18.04
    if: github.event.repository.owner.id == github.event.sender.id

    steps:
      - name: Checkout source
        uses: actions/checkout@v2
        with:
          ref: source                   #hexo源文件所在的分支

      - name: Setup Node.js
        uses: actions/setup-node@v1
        with:
          node-version: '12'

      - name: Setup Hexo
        env:
          ACTION_DEPLOY_KEY: ${{ secrets.HEXO_DEPLOY_KEY }}
        run: |
          mkdir -p ~/.ssh/
          echo "$ACTION_DEPLOY_KEY" > ~/.ssh/id_ed25519
          chmod 700 ~/.ssh
          chmod 600 ~/.ssh/id_ed25519
          ssh-keyscan github.com >> ~/.ssh/known_hosts
          git config --global user.email "disappear9@outlook.com"   #设置git提交时的Email
          git config --global user.name "Disappear9"                #设置git提交时的用户名
          npm install hexo-cli -g
          npm install
          git submodule update --init --recursive                   #拉取submodule
          rm themes/yilia/_config.yml                               #删除主题自带的配置文件
          chmod +x deploy.sh

      - name: Deploy
        run: |
          hexo g
          ./deploy.sh
{% endcodeblock %}

由于使用`hexo d`部署会让git的commit看起来很丑，所以把部署写进脚本`deploy.sh`（放在新建分支的根目录下）
{% codeblock deploy.sh lang:bash %}
#!/bin/bash
set -ev
export TZ='Asia/Shanghai'

git clone --depth=1 -b master git@github.com:{用户名}/{仓库}.git .deploy_git    #自己替换

cd .deploy_git
git checkout master
mv .git/ ../public/
cd ../public

git add .
git commit -m "Site updated: `date +"%Y-%m-%d %H:%M:%S"`"
git push origin master:master --force 
{% endcodeblock %}

## 加个Badge ##
[![Build Status](https://github.com/Disappear9/disappear9.github.io/workflows/Hexo%20Deploy/badge.svg)](https://github.com/Disappear9/disappear9.github.io/tree/source)

参考：https://docs.github.com/cn/actions/managing-workflow-runs/adding-a-workflow-status-badge
```
https://github.com/<OWNER>/<REPOSITORY>/workflows/Hexo%20Deploy/badge.svg
```
## 完 ##
https://github.com/Disappear9/disappear9.github.io/tree/source
欢迎参考