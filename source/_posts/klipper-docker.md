---
title: 在Docker中运行Klipper
date: 2022-01-25 12:00:00
categories:
- 教程
tags:
- 教程
- 折腾那些事
---

# 安装Portainer
https://docs.portainer.io/v/ce-2.11/start/install

    docker volume create portainer_data

    docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce

# 建立Stacks（docker-compose）

https://github.com/dimalo/klipper-web-control-docker

打开Stacks，Add stack 粘贴以下代码

    version: '3.4'

    services:
      klipper:
        image: dimalo/klipper-moonraker
        container_name: klipper
        ports:
          - 7125:7125
        restart: unless-stopped
        volumes:
          - gcode_files:/home/klippy/gcode_files
          - klipper_data:/home/klippy/.config
          - moonraker_data:/home/klippy/.moonraker
        devices:
          - /dev/serial/by-id/usb-1a86_USB_Serial-if00-port0:/dev/ttyUSB0 #根据实际情况更改

      fluidd:
        image: dimalo/fluidd
        restart: unless-stopped
        container_name: fluidd
        ports:
          - 8010:80
        depends_on: 
          - klipper
        links:
          - klipper:klipper

    volumes: 
      gcode_files:
      moonraker_data:
      klipper_data:

访问 `http://{IP}:8010` 即可看到fluidd

# 常见问题

`1.fluidd显示无法连接...`

该镜像自带了启动时检查更新，查看Container `klipper` 的日志可以看到启动卡在了git pull上，等一段时间或者自行解决。

`2.无法在网页重启klipper`

应直接重启对应Container

`3.上传文件名可以为中文，但是打印时必须换成英文`
