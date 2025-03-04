---
title: 鼎阳 SDS804X HD 示波器带宽与选件升级
date: 2025/3/1 12:00:00
categories:
- 教程
tags:
- 教程
- 折腾那些事
---

## 完成效果

脚本来源： https://www.eevblog.com/forum/testgear/siglent-sds-sdg-hack-script/  
升级完成后型号会显示为SDS824X HD：  

![1.png](/pictures/SDS804X-HD-Upgrade/1.png)  

-------

<!--more--> 

## 操作步骤

### 1.示波器连好网线，配置网络：  

![2.png](/pictures/SDS804X-HD-Upgrade/2.png)  
![3.png](/pictures/SDS804X-HD-Upgrade/3.png)  
![4.png](/pictures/SDS804X-HD-Upgrade/4.png)  

配网后的操作就可以不用在示波器的小屏幕上进行了。  

### 2.打开SCPI页面
![5.png](/pictures/SDS804X-HD-Upgrade/5.png)  

### 3.修改并运行脚本

```
import hashlib

# SCPI页面运行命令 MD5_SRLN? 获得SCOPEID
SCOPEID = '0000000000000000'

# 在 Home 页面找到SN进行替换
SN = 'SDS00000000000'
Model = 'SDS800X-HD'

bwopt = ('70M', '100M', '200M')
otheropt = ('PWA',)

hashkey = '5zao9lyua01pp7hjzm3orcq90mds63z6zi5kv7vmv3ih981vlwn06txnjdtas3u2wa8msx61i12ueh14t7kqwsfskg032nhyuy1d9vv2wm925rd18kih9xhkyilobbgy'

def gen(x):
    h = hashlib.md5((
        hashkey +
        (Model+'\n').ljust(32, '\x00') +
        opt.ljust(5, '\x00') +
        2*(((SCOPEID if opt in bwopt else SN) + '\n').ljust(32, '\x00')) + '\x00'*16).encode('ascii')
    ).digest()
    key = ''
    for b in h:
        if (b <= 0x2F or b > 0x39) and (b <= 0x60 or b > 0x7A):
            m = b % 0x24
            b = m + (0x57 if m > 9 else 0x30)
        if b == 0x30:
            b = 0x32
        if b == 0x31:
            b = 0x33
        if b == 0x6c:
            b = 0x6d
        if b == 0x6f:
            b = 0x70
        key += chr(b)
    return key.upper()

print('--------------------------------')
print('\n')
for opt in bwopt:
    print('{:5} {}'.format(opt, gen(SCOPEID)))

print('\n')
print('--------------------------------')
print('\n')
for opt in otheropt:
    print('{:5} {}'.format(opt, gen(SN)))

```

### 4.升级带宽
注：在向SCPI页面输入任何脚本生成的激活码前，先运行命令`MCBD?`查询当先带宽的激活码（一般为70M的），核对与脚本生成的70M的激活码是否一致，不一致就先检查脚本中的`SCOPEID`，`SN`输入是否正确。  

SCPI页面运行命令 `MCBD 带宽激活码` 例如：`MCBD 6M5VE9723IR5RACG`

### 5.解锁选件
注：示波器固件升级到 1.1.3.8 版本后，FG（USB波形发生器）和16LA（16通逻辑分析仪）这两个需要买额外硬件的选件成标配了，不需要手动激活。  
![6.png](/pictures/SDS804X-HD-Upgrade/6.png)  

全部操作完成后重启。