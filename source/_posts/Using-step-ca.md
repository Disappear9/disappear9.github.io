---
title: 灵车！开创！ Step-CA 日常使用教程
date: 2026/01/09 12:00:00
updated: 2026/04/01 12:00:00
toc: true
categories:
- 教程
tags:
- 教程
- 折腾那些事
---

前几天总算抽空把咕了快一年的自建灵车CA的教程写完了：[使用 Pico HSM 和 step-ca 自建一个CA](https://thinkalone.win/build-ca-with-picohsm.html)  
建完以后总是要拿来用一用玩一玩的，那么这一篇幅就写一些 Step-CA 的使用教程吧，顺便也给自己留个参考。  

-------

<!--more--> 

### ACME
#### 修改默认配置
为了安全 Step-CA 默认签出的证书只有24小时的有效期，这对于我们来说是完全没有必要的，先来把它修改到7天  

编辑`step-ca/config/ca.json`  

{% codeblock ca.json lang:json %}
{
	"type": "ACME",
	"name": "acme",
	"claims": {
		"maxTLSCertDuration": "336h",
		"minTLSCertDuration": "24h",
		"defaultTLSCertDuration": "168h"
	}
}
{% endcodeblock %}

开启CRL功能  

编辑 `step-ca/config/ca.json`  

{% codeblock ca.json lang:json %}
"insecureAddress": ":9001",
"crl": {
  "enabled": true,
  "idpURL": "http://ca.lab.d9lab.eu.org/1.0/crl"
},
{% endcodeblock %}

创建模板 `/etc/step-ca/templates/x509/leaf.tpl`  

{% codeblock leaf.tpl lang:json %}
{
  "subject": { { toJson .Subject } },
  "sans": { { toJson .SANs } },
  { {- if typeIs "*rsa.PublicKey" .Insecure.CR.PublicKey } }
  "keyUsage": ["keyEncipherment", "digitalSignature"],
  { {- else } }
  "keyUsage": ["digitalSignature"],
  { {- end } }
  "extKeyUsage": ["serverAuth", "clientAuth"],
  "crlDistributionPoints": ["http://ca.lab.d9lab.eu.org/1.0/crl"]
}
{% endcodeblock %}

编辑 `step-ca/config/ca.json`  
设置acme和JWK provisioner使用模板  

{% codeblock ca.json lang:json %}
								......
                                "claims": {
                                    "maxTLSCertDuration": "336h",
                                    "minTLSCertDuration": "24h",
                                    "defaultTLSCertDuration": "168h"
                                },
                                "options": {
                                        "x509": {
                                                "templateFile": "/etc/step-ca/templates/x509/leaf.tpl"
                                        },
                                        "ssh": {}
                                }
								......
                                "claims": {
                                        "enableSSHCA": true,
                                        "disableRenewal": false,
                                        "allowRenewalAfterExpiry": false,
                                        "disableSmallstepExtensions": false
                                },
                                "options": {
                                        "x509": {
                                                "templateFile": "/etc/step-ca/templates/x509/leaf.tpl"
                                        },
                                        "ssh": {}
                                }

{% endcodeblock %}

#### 给设备发SSL证书
其他ACME客户端可以参考：[Popular ACME Clients](https://smallstep.com/docs/tutorials/acme-protocol-acme-clients/#popular-acme-clients)  
这里我们使用[acme.sh](https://github.com/acmesh-official/acme.sh)，主打一个小而美。  

假设我要给我内网的旁路由（OpenWRT）签一个证书  

由于我们的自建CA不在系统的信任根证书列表里，所以如果直接运行acme.sh，curl会报错，我们需要把root_ca.crt复制一份到设备上。  

{% codeblock lang:bash %}
# 将root_ca.crt复制到/root/certs/root_ca.crt
# 安装acme.sh
$ curl https://get.acme.sh | sh -s email=my@example.com

$ ~/.acme.sh/acme.sh --issue -d router2.d9lab.eu.org \
--server https://ca.lab.thinkalone.win:4443/acme/acme/directory \
--ca-bundle /root/certs/root_ca.crt \
--webroot /www --days 6 --reloadcmd "service uhttpd reload"
{% endcodeblock %}

然后编辑`/etc/config/uhttpd`

{% codeblock lang:bash %}
...
#让uhttpd监听443端口
        list listen_https '0.0.0.0:443'
        list listen_https '[::]:443'
...
#将cert和key的路径改到上面acme.sh脚本输出的
        option cert '/root/.acme.sh/router2.d9lab.eu.org_ecc/router2.d9lab.eu.org.cer'
        option key '/root/.acme.sh/router2.d9lab.eu.org_ecc/router2.d9lab.eu.org.key'
...
{% endcodeblock %}

### SSH

参考：  
[SSH Certificates with step-ca](https://www.whatsdoom.com/posts/2020/02/29/ssh-certificates-with-step-ca/)  
[step-ca で ssh証明書を扱う](https://zenn.dev/mnod/articles/15d4e93a9d44fc)  

#### Server

重启 `step-ca` ，查看日志找到 `SSH Host CA Key` 和 `SSH User CA Key`  

{% codeblock lang:bash %}
$ sudo service step-ca stop
$ sudo service step-ca start
$ sudo service step-ca status
● step-ca.service - step-ca
     Loaded: loaded (/etc/systemd/system/step-ca.service; enabled; preset: enabled)
     Active: active (running) since 
   Main PID: 156738 (sh)
      Tasks: 11 (limit: 4529)
     Memory: 14.4M
        CPU: 305ms
     CGroup: /system.slice/step-ca.service
             ├─156738 /bin/sh -c "/usr/local/bin/step-ca /etc/step-ca/config/ca.json"
             └─156739 /usr/local/bin/step-ca /etc/step-ca/config/ca.json

......
SSH Host CA Key: ecdsa-sha2-nistp256 AAA=
SSH User CA Key: ecdsa-sha2-nistp256 AAB=
......
{% endcodeblock %}

将 `SSH User CA Key` 写入到 `/etc/ssh/ssh_user_ca_key.pub`  

{% codeblock lang:bash %}
$ sudo echo "ecdsa-sha2-nistp256 AAB=" > /etc/ssh/ssh_user_ca_key.pub
$ sudo chown root:root /etc/ssh/ssh_user_ca_key.pub
$ sudo chmod 644 /etc/ssh/ssh_user_ca_key.pub
{% endcodeblock %}

签名主机公钥  
{% codeblock lang:bash %}
$ sudo cp /etc/ssh/ssh_host_ecdsa_key.pub ssh_host_ecdsa_key.pub
$ sudo step ssh certificate $HOSTNAME ssh_host_ecdsa_key.pub --host --sign
$ sudo cp ssh_host_ecdsa_key-cert.pub /etc/ssh/ssh_host_ecdsa_key-cert.pub
{% endcodeblock %}

创建 `/etc/ssh/sshd_config.d/ca.conf` 

{% codeblock ca.conf lang:conf %}
TrustedUserCAKeys /etc/ssh/ssh_user_ca_key.pub
HostCertificate /etc/ssh/ssh_host_ecdsa_key-cert.pub
{% endcodeblock %}

测试 `sshd` 配置并重启 `sshd`  

{% codeblock lang:bash %}
$ sudo sshd -t
$ sudo service ssh restart
{% endcodeblock %}


将  `SSH Host CA Key` 写入到 `~/.ssh/authorized_keys`  

{% codeblock authorized_keys lang:conf %}
ecdsa-sha2-nistp256 AAA=
{% endcodeblock %}

#### Client

生成用于连接的证书  

{% codeblock lang:bash %}
$ step ssh certificate disappear9@192.168.1.100 id_ecdsa
......
Please enter the password to encrypt the private key:
   Private Key: id_ecdsa
   Public Key: id_ecdsa.pub
   Certificate: id_ecdsa-cert.pub
{% endcodeblock %}

将 `SSH Host CA Key` 写入到 `~/.ssh/known_hosts`  

{% codeblock authorized_keys lang:conf %}
echo "@cert-authority 192.168.1.100 ecdsa-sha2-nistp256 AAA=" >> ~/.ssh/authorized_keys
{% endcodeblock %}

然后就可以直接 `ssh disappear9@192.168.1.100` 连接了  

（完）