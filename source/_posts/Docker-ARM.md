---
title: 使DockerHub的Autobuild自动构建ARM/其他 架构的镜像
date: 2018-12-12 13:37:46
updated: 2018-12-12 13:37:46
toc: true
categories:
- 教程
tags:
- 教程
- 折腾那些事
---
## 起因：
最近在使用 [bilive_client](https://github.com/Vector000/bilive_client)挂B站的直播和主站日常任务，由于每次更新都需要重新编译+管理node环境太麻烦，所以开始使用Docker
## 遇到的坑：
首先，Google一下找到了这个https://github.com/docker/hub-feedback/issues/1261 和 https://github.com/davidecavestro/mariadb-docker-armhf 这个示例，按照里面说的在Dockerfile同级目录下建立hooks文件夹，并放入`post_checkout`和`pre_build`

```
hooks
|——pre_build
|——post_checkout
Dockerfile
```

{% codeblock pre_build lang:bash %}
#!/bin/bash
docker run --rm --privileged multiarch/qemu-user-static:register --reset
{% endcodeblock %}

{% codeblock post_checkout lang:bash %}
#!/bin/bash
curl -L https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz | tar zxvf - -C . && mv qemu-3.0.0+resin-arm/qemu-arm-static .
{% endcodeblock %}

然后在Dockerfile里加入一行
```
COPY qemu-arm-static /usr/bin
```

**然而并没有卵用**
<!--more-->
检查日志，发现Autobuild提示`no such a file or dictionary`（黑人问号.jpg）这就让人头疼了
继续Google，发现有人已经反馈过这个情况 https://forums.docker.com/t/resolved-automated-docker-build-fails/22831 官方确认是Bug而且被标记为已解决（再次黑人问号.jpg）
**解决了个卵啊？**

没办法了，直接上二段构建
先把`qemu-***-static`放到项目里，如果是（ARMv8 64）使用`qemu-aarch64-static`

{% codeblock Dockerfile lang:dockerfile %}
# 这里用什么镜像都可以，反正不会影响到最终输出的镜像，我使用的是alpine，如果用debian-stretch需要自己更改下面的内容
FROM alpine AS builder

MAINTAINER Disappear9
# 使用wget而不是git下载qemu，加速构建
RUN apk --no-cache add unzip \
    && wget https://github.com/Disappear9/bilive_client_docker/archive/master.zip \
    && unzip master.zip \
    && mkdir /qemu \
    && cp bilive_client_docker-master/qemu/* /qemu \
    && rm master.zip \
# 下载需要编译的代码
    && wget https://github.com/lzghzr/bilive_client/archive/master.zip \
    && unzip master.zip \
    && mkdir /app \
    && mv bilive_client-master/* /app


FROM arm32v6/node:alpine AS release
# 从builder把qemu复制到/usr/bin，这里建议把需要编译的代码也直接复制进来，这样会让layer更美观一些。
COPY --from=builder /qemu/qemu-arm-static /usr/bin
COPY --from=builder /app /app

{% endcodeblock %}

最后，附上Github地址 https://github.com/Disappear9/bilive_client_docker 欢迎参考
DockerHub地址 https://hub.docker.com/r/disappear9/bilive_client

## 还有一些问题
Autobuild只有在Github有push时才会触发，这就很尴尬，在源码更新时需要手动触发......
