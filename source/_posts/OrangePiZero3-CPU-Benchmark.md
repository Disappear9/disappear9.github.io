---
title: OrangePi Zero3 CPU跑分测试 CPU Benchmark
date: 2025/02/01 12:00:00
updated: 2025/02/01 12:00:00
toc: true
categories:
- 测试结果
tags:
- 测试结果
- 杂项
---

CPU:H618  
RAM:2G  

screenfetch  
```
         _,met$$$$$gg.           disappear9@Zero3
      ,g$$$$$$$$$$$$$$$P.        OS: Debian 12 bookworm
    ,g$$P""       """Y$$.".      Kernel: aarch64 Linux 6.6.75-current-sunxi64
   ,$$P'              `$$$.      Uptime: 11d 6h 33m
  ',$$P       ,ggs.     `$$b:    Packages: 442
  `d$$'     ,$P"'   .    $$$     Shell: bash
   $$P      d$'     ,    $$P     Disk: 2.0G / 58G (4%)
   $$:      $$.   -    ,d$$'     CPU: ARM Cortex-A53 @ 4x 1.512GHz
   $$\;      Y$b._   _,d$P'      RAM: -
   Y$$.    `.`"Y$$$$P"'
   `$$b      "-.__
    `Y$$
     `Y$$.
       `$$b.
         `Y$$b.
            `"Y$b._
                `""""

```

<!--more-->

7-zip 16.02:
```
disappear9@Zero3:~$ 7z b -mmt4

7-Zip [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=zh_CN.UTF-8,Utf16=on,HugeFiles=on,64 bits,4 CPUs LE)

LE
CPU Freq: - - - - - 256000000 - 1024000000 -

RAM size:    1918 MB,  # CPU hardware threads:   4
RAM usage:    882 MB,  # Benchmark threads:      4

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:       2339   340    669   2276  |      52855   398   1132   4509
23:       2201   347    647   2243  |      51734   398   1124   4476
24:       2097   355    636   2256  |      49812   398   1099   4373
25:       2014   364    631   2300  |      48705   398   1088   4335
----------------------------------  | ------------------------------
Avr:             351    646   2269  |              398   1111   4423
Tot:             375    878   3346
disappear9@Zero3:~$ 7z b -mmt1

7-Zip [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=zh_CN.UTF-8,Utf16=on,HugeFiles=on,64 bits,4 CPUs LE)

LE
CPU Freq: 64000000 64000000 - - - 256000000 - 1024000000 -

RAM size:    1918 MB,  # CPU hardware threads:   4
RAM usage:    435 MB,  # Benchmark threads:      1

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:        914   100    890    890  |      16813   100   1436   1436
23:        868   100    885    884  |      16460   100   1425   1425
24:        831   100    894    894  |      16095   100   1413   1413
25:        790   100    902    902  |      15692   100   1397   1397
----------------------------------  | ------------------------------
Avr:             100    893    893  |              100   1418   1418
Tot:             100   1155   1155
```

phoronix-test-suite benchmark compress-7zip
```
disappear9@Zero3:~/phoronix-test-suite$ ./phoronix-test-suite benchmark compress-7zip

Phoronix Test Suite v10.8.4

    To Install:    pts/compress-7zip-1.11.0

System Information

  PROCESSOR:              ARMv8 Cortex-A53 @ 1.51GHz
    Core Count:           4
    Scaling Driver:       cpufreq-dt ondemand

  GRAPHICS:

  MOTHERBOARD:            OrangePi Zero3

  MEMORY:                 2048MB

  DISK:                   62GB SE064
    File-System:          ext4
    Mount Options:        commit=120 errors=remount-ro noatime rw
    Disk Details:         Block Size: 4096

  OPERATING SYSTEM:       Debian 12
    Kernel:               6.6.75-current-sunxi64 (aarch64)
    Compiler:             GCC 12.2.0
    Security:             gather_data_sampling: Not affected
                          + itlb_multihit: Not affected
                          + l1tf: Not affected
                          + mds: Not affected
                          + meltdown: Not affected
                          + mmio_stale_data: Not affected
                          + reg_file_data_sampling: Not affected
                          + retbleed: Not affected
                          + spec_rstack_overflow: Not affected
                          + spec_store_bypass: Not affected
                          + spectre_v1: Mitigation of __user pointer sanitization
                          + spectre_v2: Not affected
                          + srbds: Not affected
                          + tsx_async_abort: Not affected

Current Description: ARMv8 Cortex-A53 testing on Debian 12 via the Phoronix Test Suite.

7-Zip Compression 24.05:
    pts/compress-7zip-1.11.0
    Test 1 of 1
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 17 Minutes
        Started Run 1
        Started Run 2
        Started Run 3

    Test: Compression Rating:
        2688
        2667
        2656

    Average: 2670 MIPS
    Deviation: 0.61%

    Test: Decompression Rating:
        4757
        4737
        4741

    Average: 4745 MIPS
    Deviation: 0.22%


ARMv8 Cortex-A53 testing on Debian 12 via the Phoronix Test Suite.

        Processor: ARMv8 Cortex-A53 @ 1.51GHz (4 Cores), Motherboard: OrangePi Zero3, Memory: 2048MB, Disk: 62GB SE064

        OS: Debian 12, Kernel: 6.6.75-current-sunxi64 (aarch64), Compiler: GCC 12.2.0, File-System: ext4


    7-Zip Compression 24.05
    Test: Compression Rating
    MIPS > Higher Is Better
    Zero3 . 2670


    7-Zip Compression 24.05
    Test: Decompression Rating
    MIPS > Higher Is Better
    Zero3 . 4745

```

sysbench  
```
disappear9@Zero3:~$ sysbench cpu --cpu-max-prime=20000 --threads=4 run
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 4
Initializing random number generator from current time


Prime numbers limit: 20000

Initializing worker threads...

Threads started!

CPU speed:
    events per second:  1124.46

General statistics:
    total time:                          10.0030s
    total number of events:              11254

Latency (ms):
         min:                                    3.35
         avg:                                    3.55
         max:                                   10.86
         95th percentile:                        4.25
         sum:                                40002.45

Threads fairness:
    events (avg/stddev):           2813.5000/0.50
    execution time (avg/stddev):   10.0006/0.00

disappear9@Zero3:~$ sysbench cpu --cpu-max-prime=20000 --threads=1 run
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 1
Initializing random number generator from current time


Prime numbers limit: 20000

Initializing worker threads...

Threads started!

CPU speed:
    events per second:   294.62

General statistics:
    total time:                          10.0007s
    total number of events:              2948

Latency (ms):
         min:                                    3.35
         avg:                                    3.39
         max:                                   10.65
         95th percentile:                        3.36
         sum:                                 9998.34

Threads fairness:
    events (avg/stddev):           2948.0000/0.00
    execution time (avg/stddev):   9.9983/0.00

```
