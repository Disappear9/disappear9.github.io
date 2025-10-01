---
title: 使用 Docker 部署 zhenxun_bot（绪山真寻Bot）
date: 2023-01-10 12:00:00
updated: 2023-01-10 12:00:00
toc: true
categories:
- 教程
tags:
- 教程
- 折腾那些事
---

# 指路
[![Github](https://shields.io/badge/GITHUB-D9Lab/zhenxun_bot_docker-4476AF?logo=github&style=for-the-badge)](https://github.com/D9Lab/zhenxun_bot_docker)

[![Github](https://shields.io/badge/GITHUB-HibiKier/zhenxun_bot-4476AF?logo=github&style=for-the-badge)](https://github.com/HibiKier/zhenxun_bot)

# 使用Portainer建立Stacks
打开Stacks，Add stack 粘贴以下代码  
{% codeblock lang:yaml %}

version: '3.4'

services:
  go-cqhttp:
    image: silicer/go-cqhttp:latest
    container_name: zxbot_go-cqhttp
    restart: unless-stopped
    volumes:
      - go-cqhttp_data:/data
      - bot_data:/bot
    links:
      - bot:bot  #配置为ws reverse，地址 ws://bot:8080/onebot/v11/ws

  postgres:
    image: postgres:14
    container_name: zxbot_postgres
    restart: unless-stopped
    environment:
      - POSTGRES_USER=zxbot
      - POSTGRES_PASSWORD=zxbot
      - POSTGRES_DB=zxbot_database
    volumes:
      - postgres_data:/var/lib/postgresql/data

  bot: #需要将 .env.dev 中的监听地址改为0.0.0.0
    image: ghcr.io/d9lab/zhenxun_bot:latest #ghcr.io
    #image: d9lab01/zhenxun_bot #DockerHub
    container_name: zxbot_zhenxun_bot
    depends_on: 
      - postgres
    restart: unless-stopped
    environment:
      - SU=114514 #管理员QQ
      - DB=postgres://zxbot:zxbot@postgres:5432/zxbot_database
    volumes:
      - bot_data:/bot
    links:
      - postgres:postgres

volumes: 
  bot_data:
  go-cqhttp_data:
  postgres_data:

{% endcodeblock %}

镜像有问题了开issue，看见了就回。
