---
title: JavaCard 上手
date: 2026/3/1 12:00:00
updated: 2026/4/1 12:00:00
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
如果jc304也装不上，那剩下的教程就不用看了，这说明你买到的卡芯片大概率不是J3R180，且 JavaCard support version 低于 3.0.4  

运行`AlgTestJClient`
{% codeblock lang:powershell %}
java -jar AlgTestJClient.jar
{% endcodeblock %}
选择 `1 -> SUPPORTED ALGORITHMS` 测试支持的算法  
测试需要跑5分钟左右，最后会生成一个csv文件  
打开csv文件，记下 `CPLC.ICSerialNumber` 最好写在卡上方便区分  
搜索 `TYPE_RSA_PRIVATE LENGTH_RSA_3072` 如果后面显示的是no，则在安装OpenPGP Applet或IsoApplet时只能使用文件名含2048的。  

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
建议使用RSA 2048或3072的Applet，更推荐用NIST P-384，因为卡上跑RSA的速度还是太慢了  

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
java -jar gp.jar --install SmartPGPApplet-rsa_up_to_3072.cap  `
    --create **************************  `
    --key-enc new-key  `
    --key-mac new-key  `
    --key-dek new-key  `
{% endcodeblock %}

OpenPGP的使用可以参照：[Canokey Canary上手#OpenPGP](https://thinkalone.win/canokey-canary.html#OpenPGP)

### NDEF
从[openjavacard-ndef](https://github.com/OpenJavaCard/openjavacard-ndef/tree/master/prebuilt)下载预编译的Applet  

安装Applet   
{% codeblock lang:powershell %}
java -jar gp.jar --install openjavacard-ndef-full.cap  `
    --params 8102000082020800  `
    --create D2760000850101  `
    --key-enc new-key  `
    --key-mac new-key  `
    --key-dek new-key  `
{% endcodeblock %}

这会创建一个有2K存储空间可重复擦写的tag，详细的参数设置[参考这里](https://github.com/OpenJavaCard/openjavacard-ndef/blob/master/doc/install.md)。

### PKCS11/15
这个Applet需要自己编译[IsoApplet](https://github.com/philipWendland/IsoApplet)  
{% codeblock lang:bash %}
# 为了方便配置环境，换到Debian下操作
git clone https://github.com/philipWendland/IsoApplet
cd IsoApplet
git submodule init
git submodule update
{% endcodeblock %}

修改 `IsoApplet.java` 允许导入私钥  
{% codeblock IsoApplet.java lang:java %}
public static final boolean DEF_PRIVATE_KEY_IMPORT_ALLOWED = true;
{% endcodeblock %}

如果你的卡不支持RSA4096，则需要注释掉 `IsoApplet.java` 中测试RSA4096的部分  
{% codeblock IsoApplet.java lang:java %}
        // API features: probe card support for 4096 bit RSA keys
		api_features &= ~API_FEATURE_RSA_4096;
		/*
        try {
            RSAPrivateCrtKey testKey = (RSAPrivateCrtKey)KeyBuilder.buildKey(KeyBuilder.TYPE_RSA_CRT_PRIVATE, KeyBuilder.LENGTH_RSA_4096, false);
            api_features |= API_FEATURE_RSA_4096;
        } catch (CryptoException e) {
            if(e.getReason() == CryptoException.NO_SUCH_ALGORITHM) {
                api_features &= ~API_FEATURE_RSA_4096;
            } else {
                throw e;
            }
        }
		*/
{% endcodeblock %}

注意：当前（2026/4/1），IsoApplet导入RSA4096密钥会出错，我分别向OpenSC和IsoApplet提交了pr，但是IsoApplet的作者似乎有重构的打算所以并没有直接采用，目前还在等待修复  
[Fix RSA4096 import](https://github.com/philipWendland/IsoApplet/pull/46)  
[Fix IsoApplet hard coded algorithm_ref](https://github.com/OpenSC/OpenSC/pull/3632)  
如果需要使用RSA4096密钥，要么卡上生成，要么按照pr手动修改代码。  


我们启一个Docker防止配置的环境与主机的冲突：  
{% codeblock lang:bash %}
sudo docker run -it -v ./IsoApplet:/workdir --name jc_build ubuntu:22.04
sudo apt update
sudo apt install openjdk-8-jdk ant
sudo update-java-alternatives -s java-1.8.0-openjdk-amd64
cd /workdir
ant
{% endcodeblock %}

编译后得到 `IsoApplet.cap`  
当然，你也可以[直接使用我编译好的cap](/attachments/Play-with-JavaCard/IsoApplet.7z)  

安装Applet   
{% codeblock lang:powershell %}
java -jar gp.jar --install IsoApplet.cap  `
    --key-enc new-key  `
    --key-mac new-key  `
    --key-dek new-key  `
{% endcodeblock %}

初始化  
{% codeblock lang:powershell %}
# 生成一个32位的随机序列号
openssl rand -hex 16
pkcs15-init --create-pkcs15 --serial 48c32f6a878b839a
{% endcodeblock %}

使用案例参考：[Using-the-IsoApplet-with-OpenSSH](https://github.com/philipWendland/IsoApplet/wiki/Using-the-IsoApplet-with-OpenSSH)  

### VeraCrypt
VeraCrypt可以直接使用存储在符合PKCS #11（2.0或更高版本）标准且允许用户在令牌/卡上存储文件（数据对象）的安全令牌或智能卡上的密钥文件。[操作步骤见VeraCrypt文档](https://veracrypt.jp/zh-cn/Keyfiles%20in%20VeraCrypt.html)

有两种方式：
1.存到 OpenPGP Applet 的 PrivDO3(Private Data Object 3) 中
2.存到 IsoApplet 的 PKCS #15 中

#### PrivDO3
默认情况下直接按VeraCrypt的文档操作，密钥文件会被存入PrivDO1，直接运行 `gpg --card-edit` 不需要验证PIN就可以直接读取到：  

{% codeblock lang:powershell %}
PS C:\Temp> gpg --card-edit

Manufacturer .....: unmanaged S/N range
......
Private DO 1 .....: DO1XXXXXXXXXXXXXXXXX    <<<<<<<<<<<<<<
Signature PIN ....: forced
{% endcodeblock %}

所以更推荐使用这个库：[openpgp-privdo3-pkcs11](https://github.com/czietz/openpgp-privdo3-pkcs11)，把密钥文件存进 DO 3。  
从Releases下载对应的 dll/so 文件后按工程 README 操作。  

#### PKCS
1.点击 VeraCrypt 菜单栏的 工具 > 密钥文件生成器  
2.密钥文件大小设置在 64-256 字节之间，生成后保存  
3.点击 VeraCrypt 菜单栏的 工具 > 管理安全口令牌密钥文件  
4.输入设置的PIN码验证  
5.点击 “导入密钥文件到令牌”，然后选择刚刚生成的文件  

### GIDS
注意：GidsApplet和IsoApplet只能二选一  

从[GidsApplet](https://github.com/vletoux/GidsApplet/releases)下载预编译的Applet  

安装Applet   
{% codeblock lang:powershell %}
java -jar gp.jar --install GidsApplet.cap  `
    --key-enc new-key  `
    --key-mac new-key  `
    --key-dek new-key  `
{% endcodeblock %}

初始化   
{% codeblock lang:powershell %}
# 生成一个48位的随机序列号
openssl rand -hex 24
# 初始化
gids-tool -X
# 导入证书（RSA2048）
certutil -csp "Microsoft Base Smart Card Crypto Provider" -importpfx -p <passphrase> <file.p12>
或
pkcs15-init --auth-id 80 --pin <pin> --verify-pin -f PKCS12 --passphrase "<passphrase>" -S <file.p12>
{% endcodeblock %}
