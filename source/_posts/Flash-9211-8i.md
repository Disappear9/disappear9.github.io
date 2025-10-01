---
title: LSi 9211-8i刷IT模式/升级
date: 2017/9/26 12:25:20
updated: 2017/9/26 12:25:20
toc: true
categories:
- 教程
tags:
- 教程
---

## 有些坑，我觉得必须写出来了: ##

**我屮艸芔茻！！！！！！！！！！！**
国内的某网站（ http://www.7po.com/thread-456043-1-1.html ）上的教程完全就是错的啊！
而且这东西百度出来第二个就是啊！
这是要坑多少人啊？！
好了，如果有人已经按照某网站的教程做了，那么请从本文的这一段开始看。  

<!--more-->

1）在windows下的操作  

**1.下载固件和BIOS**

https://docs.broadcom.com/docs/9211_8i_Package_P20_IR_IT_FW_BIOS_for_MSDOS_Windows.zip

**2.准备文件**
在下载来的压缩包里找到这些文件，并将它们都放到同一个英文目录下

>Firmware\HBA_9211_8i_IT\2118it.bin
sasbios_rel\mptsas2.rom
sas2flash_win_x64_rel\sas2flash.exe （如果你的系统是32位的就用sas2flash_win_x32_rel\sas2flash.exe）

**3.开始**

**1）先备份序列号**
运行命令

```
sas2flash -list
```

显示：

```
LSI Corporation SAS2 Flash Utility
Version 20.00.00.00 (2014.09.18)
Copyright (c) 2008-2014 LSI Corporation. All rights reserved

        Adapter Selected is a LSI SAS: SAS2008(B2)

        Controller Number              : 0
        Controller                     : SAS2008(B2)
        PCI Address                    : 00:01:00:00
        SAS Address                    : SSSSSSSSSSSSSSSSSSSSSSSS<<<<<这里
        NVDATA Version (Default)       : 11.00.00.08
        NVDATA Version (Persistent)    : 11.00.00.08
        Firmware Product ID            : 0x2213 (IR)
        Firmware Version               : 19.00.00.00
        NVDATA Vendor                  : LSI
        NVDATA Product ID              : SAS9211-8i
        BIOS Version                   : 07.37.00.00
        UEFI BSD Version               : N/A
        FCODE Version                  : N/A
        Board Name                     : SAS9211-8i
        Board Assembly                 : AAAAAAAAAAAAAAAAAAAAAAA<<<<<这里
        Board Tracer Number            : TTTTTTTTTTTTTTTTTTTTTTT<<<<<还有这里

        Finished Processing Commands Successfully.
        Exiting SAS2Flash.
```

**把上面标记部分抄下来，或者截个屏也行。**

**2）依次运行以下命令**

```
sas2flsh -o -e 6
sas2flsh -o -b mptsas2.rom
sas2flsh -o -f 2118it.bin
```

**3）把备份的各种序列号写回去**

```
sas2flash -o -sasadd SSSSSSSSSSSSSSSSSSSSSSSS
sas2flash -o -assem AAAAAAAAAAAAAAAAAAAAAAA
sas2flash -o -tracer TTTTTTTTTTTTTTTTTTTTTTT
```

**4）检查**
运行命令

```
sas2flash -list
```

显示：

```
LSI Corporation SAS2 Flash Utility
Version 20.00.00.00 (2014.09.18)
Copyright (c) 2008-2014 LSI Corporation. All rights reserved

        Adapter Selected is a LSI SAS: SAS2008(B2)

        Controller Number              : 0
        Controller                     : SAS2008(B2)
        PCI Address                    : 00:01:00:00
        SAS Address                    : SSSSSSSSSSSSSSSSSSSSSSSS
        NVDATA Version (Default)       : 11.00.00.08
        NVDATA Version (Persistent)    : 11.00.00.08
        Firmware Product ID            : 0x2213 (IT)
        Firmware Version               : 20.00.00.00
        NVDATA Vendor                  : LSI
        NVDATA Product ID              : SAS9211-8i
        BIOS Version                   : 07.37.00.00
        UEFI BSD Version               : N/A
        FCODE Version                  : N/A
        Board Name                     : SAS9211-8i
        Board Assembly                 : AAAAAAAAAAAAAAAAAAAAAAA
        Board Tracer Number            : TTTTTTTTTTTTTTTTTTTTTTT

        Finished Processing Commands Successfully.
        Exiting SAS2Flash.
```

OK，完美

**2）使用EFI-SHELL**

这一部分适用于不用windows系统的 和 按照某网站的坑人教程把卡刷坏了的

**1）确认你的主板支持UEFI**

**2）下载Installer P20 for UEFI**（https://docs.broadcom.com/docs/Installer_P20_for_UEFI.zip)
**下载固件和BIOS **(https://docs.broadcom.com/docs/9211_8i_Package_P20_IR_IT_FW_BIOS_for_MSDOS_Windows.zip)

**3)把以下文件放到硬盘的根目录下**

>Installer_P20_for_UEFI.zip > sas2flash.efi
9211_8i_Package_P20_IR_IT_FW_BIOS_for_MSDOS_Windows.zip > Firmware\HBA_9211_8i_IT\2118it.bin
9211_8i_Package_P20_IR_IT_FW_BIOS_for_MSDOS_Windows.zip > sasbios_rel\mptsas2.rom

**4）启动EFI SHELL（从主板启动EFI SHELL，不支持的自己搜用U盘启动SHELL的教程）**

**5）备份序列号**

运行命令：

```
fsX: （X是一位数字，取决于上面那几个文件的位置，可以从0开始试，用ls命令列出当前目录下文件，找到sas2flash.efi）
sas2flash.efi -list
```

**然后参照上面windows部分的教程把各种序列号抄下来**

6）刷入固件

```
sas2flash.efi -o -e 6
sas2flash.efi -o -f 2118it.bin
sas2flash.efi -o -b mptsas2.rom
```

**6）参照上面windows部分的教程把各种序列号写回去**

**（如果你是来恢复被刷坏的卡的，那么在这一步完成后记得把备份的SBR刷回去）**

OK，完美，教程结束