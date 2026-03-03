---
title: JavaCard 上手
date: 2026/3/1 12:00:00
updated: 2026/3/1 12:00:00
toc: true
categories:
- 折腾那些事
tags:
- 教程
- 折腾那些事
---

### 材料准备
Javacard (TB搜 J3R180 ￥20-30 要SECID版，记得问卖家密钥)  
智能卡读卡器 (TB搜 pcsc读卡器/ccid读卡器 ￥30-50，更建议加钱上双界面的，或者买一个便宜的接触式的再买一个好一些的非接触式的日常用)  

-------

### 环境确认

操作系统：  
&emsp;&emsp;Windows 10 LTSB 21H2  
软件版本：  
&emsp;&emsp;gpg4win 5.0.1 (gpg 2.5.17)  
&emsp;&emsp;OpenSC 0.26.1  
&emsp;&emsp;Global Platform Pro v20.08.12  
&emsp;&emsp;Temurin JDK 21.0.10+7-LTS  
&emsp;&emsp;Python 3.13  

<!--more--> 

### 准备卡片

卡片到手后第一件事先改掉默认的密钥  

{% codeblock lang:powershell %}
openssl rand -hex 16 #运行3次，生成三组密钥，分别对应enc,mac,dek
！！！千万要保存好，丢失了卡就可以扔了！！！
{% endcodeblock %}

修改密钥：

{% codeblock lang:powershell %}
java -jar gp.jar  `
  --key-enc old-key  ` 
  --key-mac ole-key  ` 
  --key-dek old-key  ` 
  --lock-enc new-key  --lock-mac new-key  --lock-dek new-key
{% endcodeblock %}

### JCAlgTest
先来跑个测试看看到手的卡正不正常、支持哪些算法
从[JCAlgTest](https://github.com/crocs-muni/JCAlgTest)最新版本(当前最新版是AlgTest_dist_1.8.3.zip)
安装Applet  
{% codeblock lang:powershell %}
java -jar gp.jar --install AlgTest_v1.8.2_jc305.cap  `
    --key-enc new-key  `
    --key-mac new-key  `
    --key-dek new-key  `
{% endcodeblock %}
如果jc305的Applet装不进去，依次尝试jc304 -> jc222  
如果jc304也装不上，那剩下的教程就不用看了，这说明你买到的卡芯片不是J3R180/不支持JavaCard 3.0.4  

### FIDO2
从[FIDO2Applet](https://github.com/BryanJacobs/FIDO2Applet)下载工程ZIP包，在从Releases下载Applet(FIDO2.cap)  
解压工程ZIP包备用，后面要用到工程里的脚本  

注意：当前（2026/3/1）GPP必须使用v20.08.12，在这之后的版本处理TLV有问题会导致后面注入证书的操作报错。  

安装Applet  
{% codeblock lang:powershell %}
java -jar gp.jar --install FIDO2.cap  `
    --params a800f50505061820071904000818200918fe0a1904000b190400  `
    --key-enc new-key  `
    --key-mac new-key  `
    --key-dek new-key  `
{% endcodeblock %}

注入证书  
注意：当前（2026/3/1）Python必须使用3.12，不然pyscard装不上（或者自己手动改下代码）。  
{% codeblock lang:powershell %}
python -m venv venv
venv\Scripts\Activate.ps1
pip install -r FIDO2Applet-main/requirements.txt
python FIDO2Applet-main/install_attestation_cert.py
{% endcodeblock %}

### OpenPGP
从[SmartPGP](https://github.com/github-af/SmartPGP)下载Applet  
建议使用RSA 2048的Applet就够了，最多3072，更推荐用NIST P-384，因为卡上跑RSA的速度实在太慢了  

使用以下脚本生成序列号：

{% codeblock gen_sn.py lang:python %}
import secrets
import subprocess

# anything in fff0 to fffe is for unmanaged random assignment of serial numbers
_MANUFACTURER = "fff5"

def _make_card():
    # SN is 8 digits, so 4 bytes shown as hex
    sn = secrets.token_hex(4)
    aid = f"d276000124010304{_MANUFACTURER}{sn}0000"
    print(f"Assigning serial number {sn} for manufacturer {_MANUFACTURER}")
    print("--create " + aid)


if __name__ == "__main__":
    _make_card()
{% endcodeblock %}

安装Applet，将`--create`后的内容替换为上面脚本生成的   
{% codeblock lang:powershell %}
java -jar gp.jar --install FIDO2.cap  `
    --create **************************  `
    --key-enc new-key  `
    --key-mac new-key  `
    --key-dek new-key  `
{% endcodeblock %}

OpenPGP的使用可以参照：[Canokey Canary上手#OpenPGP](https://thinkalone.win/canokey-canary.html#OpenPGP)
