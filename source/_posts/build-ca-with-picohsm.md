---
title: 灵上加灵：使用 Pico HSM 和 step-ca 自建一个CA
date: 2025/12/10 12:00:00
updated: 2026/01/15 12:00:00
toc: true
categories:
- 教程
tags:
- 教程
- 折腾那些事
---

### 引言
前几天在Canokey群看到一个软件：[step-ca](https://github.com/smallstep/certificates)  
简单说就是用这个软件可以自建一个CA来玩，而且软件支持HSM设备

-------

### 环境确认

硬件信息：  
&emsp;&emsp;OrangePi Zero3  
&emsp;&emsp;Raspberry Pi Pico2  
操作系统：  
&emsp;&emsp;Armbian v25.11.2 6.12.58-current-sunxi64  
软件版本：  
&emsp;&emsp;go1.25.5  
&emsp;&emsp;step-ca 0.29.0  
&emsp;&emsp;OpenSC 0.26.1  

<!--more--> 


### 准备

#### 安装Go

https://go.dev/doc/install

{% codeblock lang:bash %}
$ wget https://go.dev/dl/go1.25.5.linux-arm64.tar.gz
$ sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.25.5.linux-amd64.tar.gz
$ export PATH=$PATH:/usr/local/go/bin
$ go version
go version go1.25.5 linux/arm64
{% endcodeblock %}

#### 编译 step-ca
由于官方编译的软件包没有HSM支持，所以我们需要手动编译  

https://github.com/smallstep/certificates/blob/master/CONTRIBUTING.md#build-step-ca-using-cgo  

{% codeblock lang:bash %}
$ wget https://github.com/smallstep/certificates/archive/refs/tags/v0.29.0.tar.gz
$ tar -xvzf v0.29.0.tar.gz
$ cd certificates-0.29.0
$ sudo apt install libpcsclite-dev gcc make pkg-config
$ make bootstrap
$ make build GO_ENVS="CGO_ENABLED=1"
$ sudo cp bin/step-ca /usr/local/bin
$ sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/step-ca
$ step-ca version
Smallstep CA/ (linux/arm64)
Release Date: 2025-12-03 14:16 UTC
{% endcodeblock %}

#### 安装 step-cli 和 step-kms-plugin
{% codeblock lang:bash %}
$ wget https://dl.smallstep.com/gh-release/cli/gh-release-header/v0.29.0/step-cli_0.29.0-1_arm64.deb
$ sudo dpkg -i step-cli_0.29.0-1_arm64.deb
$ step version
Smallstep CLI/0.29.0 (linux/arm64)
Release Date: 2025-12-03T04:11:27Z
$ wget https://github.com/smallstep/step-kms-plugin/releases/download/v0.16.0/step-kms-plugin_0.16.0-1_arm64.deb
$ sudo dpkg -i step-kms-plugin_0.16.0-1_arm64.deb
$ step kms version
🔐 step-kms-plugin/0.16.0 (linux/arm64)
   Release Date: 2025-12-04T22:35:43Z
{% endcodeblock %}

#### 编译 OpenSC

https://github.com/OpenSC/OpenSC/wiki/Compiling-and-Installing-on-Unix-flavors  

{% codeblock lang:bash %}
$ wget https://github.com/OpenSC/OpenSC/releases/download/0.26.1/opensc-0.26.1.tar.gz
$ sudo apt install pcscd libccid libpcsclite-dev libssl-dev libreadline-dev autoconf automake build-essential docbook-xsl xsltproc libtool pkg-config zlib1g-dev 
$ tar xfvz opensc-0.26.1.tar.gz
$ cd opensc-0.26.1
$ ./bootstrap
$ ./configure --prefix=/usr --sysconfdir=/etc/opensc
$ make
$ sudo make install
{% endcodeblock %}

#### 配置 TRNG （可选）

这里使用的是 [Infinite Noise TRNG](https://github.com/leetronics/infnoise) 全开源的硬件TRNG

{% codeblock lang:bash %}
$ curl -LO https://github.com/leetronics/infnoise/archive/refs/tags/0.3.3.tar.gz
$ tar xvzf 0.3.3.tar.gz
$ cd infnoise-0.3.3/software
$ sudo apt install libftdi-dev libusb-dev
$ make -f Makefile.linux
$ sudo make -f Makefile.linux install
$ infnoise --version
GIT VERSION -
GIT COMMIT  -
GIT DATE    -

$ sudo init 6
$ infnoise --debug --no-output
Generated 1048576 bits.  OK to use data.  Estimated entropy per bit: 0.875965, estimated K: 1.835235
num1s:50.019069%, even misfires:0.183222%, odd misfires:0.123520%
Generated 2097152 bits.  OK to use data.  Estimated entropy per bit: 0.873196, estimated K: 1.831716
num1s:49.909786%, even misfires:0.202971%, odd misfires:0.124232%
......
{% endcodeblock %}

#### 烧录 pico-hsm 到 Pico2

https://github.com/polhenarejos/pico-hsm  
https://github.com/Gadgetoid/pico-universal-flash-nuke  

{% codeblock lang:bash %}
$ wget https://github.com/polhenarejos/pico-hsm/releases/download/v6.0/pico_hsm_pico2-6.0.uf2
$ wget https://github.com/Gadgetoid/pico-universal-flash-nuke/releases/download/v1.0.1/universal_flash_nuke.uf2
{% endcodeblock %}

按住 Pico2 开发板上的 BOOT 按钮，连上 USB 线，先刷入`universal_flash_nuke.uf2`清空Flash，再刷入`pico_hsm_pico2-6.0.uf2`

#### 初始化 pico-hsm

~~更新：目前如果要使用SCS3 tool导入证书，只能使用Pico Commissioner初始化，否则会导致SCS3一直报认证错误。~~  
更新2：这B作者把Pico Commissioner的页面和pypicohsm等工具全删了，现有的网页存档也被作者下了，然后强制用户使用一个新的需要付费30欧元每个Key的应用来初始化。  
更新3：有个印度老哥做了分叉[Libre Keys](https://github.com/librekeys)，大部分工具如pypicohsm等都可以在这里下载了。  
更新4：写了一个[自己生成cvc证书的教程](https://github.com/Disappear9/pico-hsm-cvcgen/blob/main/research/README_ZH.MD)，按教程操作后就可以用SCS3管理pico-hsm了，直接使用原`2.0.2`版本的`pypicohsm`会从原作者的服务器上请求cvc证书，也能用，但是鉴于这B目前的吃相这个API还能活多久我不好说。  

{% tabs style:fullwidth toggle %}
<!-- tab id:init-pico-hsm-py title:pico-hsm-tool.py active -->
{% codeblock lang:bash %}
$ sudo apt install python3-dev
$ wget https://github.com/librekeys/pico-hsm/raw/refs/heads/master/tools/pico-hsm-tool.py
$ python3 -m venv venv
$ source venv/bin/activate
$ pip install pycvc cryptography pypicohsm
$ python3 pico-hsm-tool.py
$ deactivate
{% endcodeblock %}

更改pico-hsm的vid和pid  

{% codeblock lang:bash %}
$ sudo -i
$ source venv/bin/activate
$ python pico-hsm-tool.py phy vidpid 20A0:4230
$ exit
$ lsusb
Bus 006 Device 003: ID 20a0:4230 Clay Logic Nitrokey HSM
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
...
{% endcodeblock %}

初始化 pico-hsm  

{% codeblock lang:bash %}
$ python3 pico-hsm-tool.py --pin 648219 initialize --so-pin 57621880
{% endcodeblock %}

<!-- endtab -->
<!-- tab id:init-pico-hsm-commissioner title:PicoCommissioner（已失效） -->
https://www.picokeys.com/pico-commissioner/  
![pico-commissioner](/pictures/pico-hsm/pico-commissioner.png)  

<!-- endtab -->
{% endtabs %}

### 创建RootCA和中间CA

这里我们使用的是创建后导入的方式，虽然在使用正规HSM产品的时候都是建议仅在设备上生成密钥且不要导入导出，但是我们这个10块钱的开发板指不定什么时候就会坏，所以多一份备份是必须的。  

生成RootCA私钥  

{% codeblock lang:bash %}
$ mkdir -p certificate-authority/newcerts
$ touch certificate-authority/index.txt
$ openssl ecparam -genkey -name secp384r1 -noout -out root-ca-key.pem
{% endcodeblock %}

{% codeblock create_root_cert.ini lang:ini %}
[ ca ]
# `man ca`
default_ca = CA_default

[ CA_default ]
# Directory and file locations.
dir               = certificate-authority
certs             = $dir/certs
crl_dir           = $dir/crl
new_certs_dir     = $dir/newcerts
database          = $dir/index.txt
serial            = $dir/serial

# SHA-1 is deprecated, so use SHA-2 instead.
default_md        = sha512

name_opt          = ca_default
cert_opt          = ca_default
default_days      = 375
preserve          = no
policy            = policy_strict

[ policy_strict ]
# The root CA should only sign intermediate certificates that match.
# See the POLICY FORMAT section of `man ca`.
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
# Options for the `req` tool (`man req`).
default_bits        = 4096
distinguished_name  = req_distinguished_name
string_mask         = utf8only
prompt              = no

# SHA-1 is deprecated, so use SHA-2 instead.
default_md          = sha512

[ req_distinguished_name ]
C                   = CN
O                   = D9Lab
OU                  = D9Lab Zero Certificate Authority
CN                  = D9Lab Zero Root CA

[ v3_ca ]
# Extensions for a typical CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

{% endcodeblock %}

生成RootCA证书  

{% codeblock lang:bash %}
$ openssl req -config create_root_cert.ini -new -key root-ca-key.pem -x509 -days 3650 -sha512 -extensions v3_ca -out root-ca.crt
{% endcodeblock %}

RootCA的密钥和证书如果有条件的话建议导入到不那么灵车的设备里，[如Canokey中。](https://thinkalone.win/canokey-canary.html#PIV)  

生成中间CA私钥  
{% tabs style:fullwidth toggle %}
<!-- tab id:intermediate-ca-hsm title:使用HSM设备 active -->
首先暂时拔掉Pico HSM，插上Canokey/YubiKey之类的设备  
将证书和私钥打包成`p12`格式  
{% codeblock lang:bash %}
# 注意必须要设定密码，不然导入的时候会报错！  
$ openssl pkcs12 -export -out root-ca.p12 -inkey root-ca-key.pem -in root-ca.crt
{% endcodeblock %}

将`p12`格式的RootCA证书导入到HSM设备中 以Canokey为例  
{% codeblock lang:bash %}
$ yubico-piv-tool -r canokeys -s 9a -i root-ca.p12 -KPKCS12 -a import-key -a import-cert
{% endcodeblock %}

找到导入进Canokey的证书id  
{% codeblock lang:bash %}
$ pkcs11-tool --module /usr/lib/opensc-pkcs11.so -O
{% endcodeblock %}

正常的话应该会有类似这样的输出：  
```
...
Certificate Object; type = X.509 cert
  label:      Certificate for Key Management
  subject:    DN: C=CN, O=D9Lab, OU=D9Lab Zero Certificate Authority, CN=D9Lab Zero Root CA
  serial:     ************
  ID:         03
  uri:        pkcs11:model=PKCS%2315%20emulated;manufacturer=piv_II;serial=************;token=Disappear9%20%27s%20CanoKey;id=%03;object=Certificate%20for%20Key%20Management;type=cert
...
```
记下这个`ID 03`，接下来会用到  

创建中间CA模板  
{% codeblock intermediate.tpl lang:json %}
{
        "subject": { { toJson .Subject } },
        "keyUsage": ["certSign", "crlSign"],
        "basicConstraints": {
                "isCA": true,
                "maxPathLen": 0
        },
        "crlDistributionPoints": ["http://ca.lab.d9lab.eu.org/1.0/crl"]
}
{% endcodeblock %}

生成中间CA私钥  

{% codeblock lang:bash %}
$ step certificate create \
  "D9Lab Zero Intermediate CA" \
  intermediate-ca.crt \
  intermediate_ca_key_enc \
  --template intermediate.tpl \
  --ca root-ca.crt \
  --ca-kms 'pkcs11:module-path=/usr/lib/opensc-pkcs11.so;serial=************?pin-value=648219' \
  --ca-key 'pkcs11:id=03' \
  --not-before '2025-01-10T00:00:00+08:00' \
  --not-after '2030-01-10T00:00:00+08:00' \
  --kty=EC --curve=P-384
{% endcodeblock %}

拔下Canokey/YubiKey，换回Pico HSM  

<!-- endtab -->
<!-- tab id:intermediate-ca-file title:不使用HSM设备 -->
创建中间CA模板  
{% codeblock intermediate.tpl lang:json %}
{
        "subject": { { toJson .Subject } },
        "keyUsage": ["certSign", "crlSign"],
        "basicConstraints": {
                "isCA": true,
                "maxPathLen": 0
        },
        "crlDistributionPoints": ["http://ca.lab.d9lab.eu.org/1.0/crl"]
}
{% endcodeblock %}

生成中间CA私钥  

{% codeblock lang:bash %}
$ step certificate create \
  "D9Lab Zero Intermediate CA" \
  intermediate-ca.crt \
  intermediate_ca_key_enc \
  --template intermediate.tpl \
  --ca root-ca.crt \
  --ca-key root-ca-key.pem \
  --not-before '2025-01-10T00:00:00+08:00' \
  --not-after '2030-01-10T00:00:00+08:00' \
  --kty=EC --curve=P-384
{% endcodeblock %}

<!-- endtab -->
{% endtabs %}

将证书和私钥打包成`p12`格式  
{% codeblock lang:bash %}
$ openssl ec -in intermediate_ca_key_enc -out intermediate-ca-key.pem
# 注意必须要设定密码，不然导入的时候会报错！  
$ openssl pkcs12 -export -out intermediate-ca.p12 -inkey intermediate-ca-key.pem -in intermediate-ca.crt -certfile root-ca.crt
{% endcodeblock %}


### 将中间CA证书和密钥导入 pico-hsm

首先参考 pico-hsm 作者的说明，下载并修改SCS3 tool：  
https://github.com/polhenarejos/pico-hsm/blob/master/doc/scs3.md  

然后参考 [docs.nitrokey.com](https://docs.nitrokey.com/nitrokeys/features/hsm/import-keys-certs#importing-via-the-scsh3-gui) 导入`intermediate-ca.p12`  
```
Inside the unpacked directory you will find scsh3gui, which can be started using bash scsh3gui (for windows double-click on: scsh3gui.cmd).

Start key-manager (File -> Keymanager)
Right-click “Smartcard-HSM” -> create DKEK share
Choose file location
Choose DKEK share password
Right-click “Smartcard-HSM” -> Initialize device
Enter SO-PIN
(optional) Enter label and enter URL/Host
Select authentication method: “User PIN”
Allow RESET RETRY COUNTER: “Resetting and unblocking PIN with SO-PIN not allowed”
Enter and confirm User PIN
“Select Device Key Encryption scheme” -> “DKEK shares”
Enter number of DKEK shares: 1
Right-click DKEK set-up in progress -> “Import DKEK share”
Choose DKEK share file location
Password for DKEK share
Right-click “SmartCard-HSM” -> “Import from PKCS#12(Old)”
Enter number of shares -> 1
Enter file location of DKEK share
Enter Password for DKEK share
Select PKCS#12 container for import (Enter password)
Select Key
Select Name to be used (intermediate-ca)
Import more keys, if needed
```

导入完成后运行`pkcs11-tool -O`应该就可以看到导入的证书了
{% codeblock lang:bash %}
$ pkcs11-tool -O
  Using slot 0 with a present token (0x0)
  Certificate Object; type = X.509 cert
    label:      intermediate-ca
    subject:    DN: C=CN, O=D9Lab, OU=D9Lab Zero Certificate Authority, CN=D9Lab Zero Intermediate CA
    ID:         01
...
{% endcodeblock %}

记下`ID`和`label`，后面要用到。  

把这些文件拿7z打个加密压缩包，密码用KeePass生成一个够长的保存，然后找个你喜欢的网盘存好或者刻张光盘放衣柜里。  

```
intermediate-ca-key.pem
intermediate-ca.crt
intermediate-ca.p12
pde文件（DKEK）
root-ca-key.pem
root-ca.crt
root-ca.p12
```

之后只保留`intermediate-ca.crt`和`root-ca.crt`，其余文件全部删除  

### 配置step-ca

https://smallstep.com/docs/step-ca/cryptographic-protection/#pkcs-11  

初始化  

{% codeblock lang:bash %}
$ sudo systemctl enable pcscd
$ sudo systemctl start pcscd
$ sudo useradd step
$ sudo passwd -l step
$ sudo mkdir /etc/step-ca
$ export STEPPATH=/etc/step-ca
$ sudo --preserve-env step ca init --name="D9Lab Zero CA" \
    --dns="ca.lab.d9lab.eu.org" --address=":4443" \
    --provisioner="disappear9@outlook.com" \
    --deployment-type standalone \
    --remote-management
# 记好自己设置的 provisioner key

$ sudo rm /etc/step-ca/certs/*
# 将保存的 intermediate-ca.crt 和 root-ca.crt 复制到/etc/step-ca/certs/
$ sudo rm -rf /etc/step-ca/secrets
$ sudo chown -R step:step /etc/step-ca
$ step kms create --json --kms "pkcs11:module-path=/usr/lib/opensc-pkcs11.so;serial=ESPICOHSMTR?pin-value=648219" "pkcs11:id=2000;object=ssh-host-ca"
$ step kms create --json --kms "pkcs11:module-path=/usr/lib/opensc-pkcs11.so;serial=ESPICOHSMTR?pin-value=648219" "pkcs11:id=2001;object=ssh-user-ca"

{% endcodeblock %}

编辑`/etc/step-ca/config/ca.json`  

{% codeblock ca.json lang:json %}
{
    "root": "/etc/step-ca/certs/root-ca.crt",
    "crt": "/etc/step-ca/certs/intermediate-ca.crt",
    "key": "pkcs11:id=01;object=intermediate-ca",
    "kms": {
        "type": "pkcs11",
        "uri": "pkcs11:module-path=/usr/lib/opensc-pkcs11.so;serial=ESPICOHSMTR?pin-value=648219"
    },
	"ssh": {
        "hostKey": "pkcs11:id=2000;object=ssh-host-ca",
        "userKey": "pkcs11:id=2001;object=ssh-user-ca"
    }
}

{% endcodeblock %}

尝试运行  

{% codeblock lang:bash %}
# 新开一个窗口
$ screen
$ sudo -u step step-ca /etc/step-ca/config/ca.json
# 记下fingerprint值，下面会用到
{% endcodeblock %}

新开一个窗口
{% codeblock lang:bash %}
$ unset STEPPATH
$ step ca bootstrap --ca-url "https://ca.lab.d9lab.eu.org:4443" --fingerprint d6b3b9ef79a42aeeabcd5580b2b516458ddb25d1af4ea7ff0845e624ec1bb609
The root certificate has been saved in /home/disappear9/.step/certs/root_ca.crt.
The authority configuration has been saved in /home/disappear9/.step/config/defaults.json.

# 来测试一下能不能正常签出证书
$ step ca certificate "localhost" localhost.crt localhost.key
$ step ca provisioner add acme --type acme --admin-name step
{% endcodeblock %}

### 配置服务

{% codeblock lang:bash %}
$ sudo tee /etc/udev/rules.d/75-picohsm.rules > /dev/null << EOF
ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="20a0/4230/*", TAG+="systemd", SYMLINK+="picohsm"
ACTION=="remove", SUBSYSTEM=="usb", ENV{PRODUCT}=="20a0/4230/*", TAG+="systemd"
EOF
$ sudo udevadm control --reload-rules
$ sudo tee /etc/systemd/system/step-ca.service > /dev/null << EOF
[Unit]
Description=step-ca
BindsTo=dev-picohsm.device
After=dev-picohsm.device
[Service]
User=step
Group=step
ExecStart=/bin/sh -c '/usr/local/bin/step-ca /etc/step-ca/config/ca.json'
Type=simple
Restart=on-failure
RestartSec=10
[Install]
WantedBy=multi-user.target
EOF
$ sudo mkdir /etc/systemd/system/dev-picohsm.device.wants
$ sudo ln -s /etc/systemd/system/step-ca.service /etc/systemd/system/dev-picohsm.device.wants/
$ sudo systemctl daemon-reload
$ sudo systemctl enable step-ca
$ sudo init 6

# 查看服务运行状态
$ systemctl status step-ca

{% endcodeblock %}

（完）
