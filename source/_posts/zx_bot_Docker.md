---
title: 使用 Docker 部署 zhenxun_bot（绪山真寻Bot）
date: 2022-09-15 12:00:00
categories:
- 折腾那些事
tags:
- 折腾那些事
- 教程
---

# 指路
[![Github](https://shields.io/badge/GITHUB-D9Lab/zhenxun_bot_docker-4476AF?logo=github&style=for-the-badge)](https://github.com/D9Lab/zhenxun_bot_docker)
[![DOCKER](https://shields.io/badge/docker-disappear9/zhenxun_bot-4476AF?logo=docker&style=for-the-badge)](https://hub.docker.com/r/disappear9/zhenxun_bot)
[![Github](https://shields.io/badge/GITHUB-HibiKier/zhenxun_bot-4476AF?logo=github&style=for-the-badge)](https://github.com/HibiKier/zhenxun_bot)

# 使用Portainer建立Stacks
打开Stacks，Add stack 粘贴以下代码  
```
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

  bot:
    image: disappear9/zhenxun_bot:latest
    container_name: zxbot_zhenxun_bot
    depends_on: 
      - postgres
    restart: unless-stopped
    environment:
      - SU=114514 #管理员QQ
      - DB=postgresql://zxbot:zxbot@postgres:5432/zxbot_database
    volumes:
      - bot_data:/bot
    links:
      - postgres:postgres

volumes: 
  bot_data:
  go-cqhttp_data:
  postgres_data:

```

镜像有问题了开issue，看见了就回。
