---
title: 树莓派5 Raspberry Pi 5 CPU跑分测试 CPU Benchmark
date: 2025/03/01 12:00:00
categories:
- 测试结果
tags:
- 测试结果
- 杂项
---

CPU:BCM2835  
RAM:4G  

disappear9@Pi5:creenfetchetch  
```
                          ./+o+-       disappear9@Pi5
                  yyyyy- -yyyyyy+      OS: Ubuntu 24.04 noble
               ://+//////-yyyyyyo      Kernel: aarch64 Linux 6.8.0-1020-raspi
           .++ .:/++++++/-.+sss/`      Uptime: 32m
         .:++o:  /++++++++/:--:/-      Packages: 2548
        o:+o+:++.`..```.-/oo+++++/     Shell: bash 5.2.21
       .:+o:+o/.          `+sssoo+/    Resolution: 4480x1440
  .++/+:+oo+o:`             /sssooo.   WM: Not Found
 /+++//+:`oo+o               /::--:.   GTK Theme: Adwaita [GTK3]
 \+/+o+++`o++o               ++////.   Disk: 7.9G / 57G (15%)
  .++.o+++oo+:`             /dddhhh.   CPU: ARM Cortex-A76 @ 4x 2.4GHz
       .+.o+oo:.          `oddhhhh+    RAM: 470MiB / 3984MiB
        \+.++o+o``-````.:ohdhhhhh+
         `:o+++ `ohhhhhhhhyo++os:
           .o:`.syhhhhhhh/.oo++o`
               /osyyyyyyo++ooo+++/
                   ````` +oo+++o\:
                          `oo++.

```

<!--more-->

7-zip 23.01:
```
disappear9@Pi5:~$ 7z b -mmt4

7-Zip 23.01 (arm64) : Copyright (c) 1999-2023 Igor Pavlov : 2023-06-20
 64-bit arm_v:8 locale=C.UTF-8 Threads:4 OPEN_MAX:1024

 mt4
Compiler: 13.2.0 GCC 13.2.0
Linux : 6.8.0-1020-raspi : #24-Ubuntu SMP PREEMPT_DYNAMIC Sun Feb 23 08:39:32 UTC 2025 : aarch64
PageSize:4KB THP:madvise hwcap:119FFF:CRC32:SHA1:SHA2:AES:ASIMD
LE

1T CPU Freq (MHz):  2130  2394  2394  2394  2394  2394  2394
2T CPU Freq (MHz): 200% 2382   200% 2394

RAM size:    3984 MB,  # CPU hardware threads:   4
RAM usage:    889 MB,  # Benchmark threads:      4

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:      10993   374   2857  10695  |     160334   396   3455  13679
23:      10165   380   2727  10358  |     157739   399   3422  13649
24:       9693   382   2727  10422  |     154513   399   3402  13560
25:       9088   381   2725  10377  |     150242   399   3349  13371
----------------------------------  | ------------------------------
Avr:      9985   379   2759  10463  |     155707   398   3407  13565
Tot:             389   3083  12014
disappear9@Pi5:~$ 7z b -mmt1

7-Zip 23.01 (arm64) : Copyright (c) 1999-2023 Igor Pavlov : 2023-06-20
 64-bit arm_v:8 locale=C.UTF-8 Threads:4 OPEN_MAX:1024

 mt1
Compiler: 13.2.0 GCC 13.2.0
Linux : 6.8.0-1020-raspi : #24-Ubuntu SMP PREEMPT_DYNAMIC Sun Feb 23 08:39:32 UTC 2025 : aarch64
PageSize:4KB THP:madvise hwcap:119FFF:CRC32:SHA1:SHA2:AES:ASIMD
LE

1T CPU Freq (MHz):  1490  1495  2134  2394  2394  2394  2394

RAM size:    3984 MB,  # CPU hardware threads:   4
RAM usage:    437 MB,  # Benchmark threads:      1

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:       3509   100   3420   3414  |      42244   100   3604   3607
23:       3261   100   3325   3323  |      41559   100   3603   3597
24:       3136   100   3381   3373  |      40745   100   3577   3577
25:       3010   100   3442   3437  |      39720   100   3529   3535
----------------------------------  | ------------------------------
Avr:      3229   100   3392   3387  |      41067   100   3579   3579
Tot:             100   3485   3483

```

phoronix-test-suite benchmark compress-7zip
```
disappear9@Pi5:~/phoronix-test-suite$ ./phoronix-test-suite benchmark compress-7zip

Phoronix Test Suite v10.8.4

    To Install:    pts/compress-7zip-1.11.0

    pts/compress-7zip-1.11.0:
        Test Installation 1 of 1
        1 File Needed [1.42 MB]
        Downloading: 7z2405-src.tar.xz                                                                                                                                                                                                                                         [1.42MB]

System Information

  PROCESSOR:              ARMv8 Cortex-A76 @ 2.40GHz
    Core Count:           4
    Scaling Driver:       cpufreq-dt ondemand

  GRAPHICS:
    Screen:               4480x1440

  MOTHERBOARD:            Raspberry Pi 5 Model B Rev 1.0
    Chipset:              Broadcom BCM2712
    Network:              Raspberry Pi RP1 PCIe 2.0 South Bridge

  MEMORY:                 4096MB

  DISK:                   62GB SA64G
    File-System:          ext4
    Mount Options:        relatime rw
    Disk Details:         Block Size: 4096

  OPERATING SYSTEM:       Ubuntu 24.04
    Kernel:               6.8.0-1020-raspi (aarch64)
    Display Server:       X Server
    Compiler:             GCC 13.3.0
    Security:             gather_data_sampling: Not affected
                          + itlb_multihit: Not affected
                          + l1tf: Not affected
                          + mds: Not affected
                          + meltdown: Not affected
                          + mmio_stale_data: Not affected
                          + reg_file_data_sampling: Not affected
                          + retbleed: Not affected
                          + spec_rstack_overflow: Not affected
                          + spec_store_bypass: Mitigation of SSB disabled via prctl
                          + spectre_v1: Mitigation of __user pointer sanitization
                          + spectre_v2: Mitigation of CSV2 BHB
                          + srbds: Not affected
                          + tsx_async_abort: Not affected

7-Zip Compression 24.05:
    pts/compress-7zip-1.11.0
    Test 1 of 1
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 17 Minutes [07:36 UTC]
        Started Run 1 @ 07:20:28
        Started Run 2 @ 07:21:09
        Started Run 3 @ 07:21:50

    Test: Compression Rating:
        10584
        10772
        10731

    Average: 10696 MIPS
    Deviation: 0.92%

    Test: Decompression Rating:
        13478
        13524
        13528

    Average: 13510 MIPS
    Deviation: 0.21%

```

sysbench  
```
disappear9@Pi5:~$ sysbench cpu --cpu-max-prime=20000 --threads=4 run
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 4
Initializing random number generator from current time


Prime numbers limit: 20000

Initializing worker threads...

Threads started!

CPU speed:
    events per second:  4128.44

General statistics:
    total time:                          10.0010s
    total number of events:              41295

Latency (ms):
         min:                                    0.96
         avg:                                    0.97
         max:                                   10.02
         95th percentile:                        0.97
         sum:                                39994.74

Threads fairness:
    events (avg/stddev):           10323.7500/20.90
    execution time (avg/stddev):   9.9987/0.00

disappear9@Pi5:~$ sysbench cpu --cpu-max-prime=20000 --threads=1 run
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 1
Initializing random number generator from current time


Prime numbers limit: 20000

Initializing worker threads...

Threads started!

CPU speed:
    events per second:  1033.96

General statistics:
    total time:                          10.0007s
    total number of events:              10342

Latency (ms):
         min:                                    0.96
         avg:                                    0.97
         max:                                    1.51
         95th percentile:                        0.97
         sum:                                 9998.56

Threads fairness:
    events (avg/stddev):           10342.0000/0.00
    execution time (avg/stddev):   9.9986/0.00

```
