---
title: 友善 FriendlyELEC NanoPC-T4 CPU跑分测试 CPU Benchmark
date: 2025/09/30 12:00:00
categories:
- 测试结果
tags:
- 测试结果
- 杂项
---

CPU:Rockchip RK3399  
RAM:4G  

screenfetch  
```
         _,met$$$$$gg.           disappear9@nanopct4
      ,g$$$$$$$$$$$$$$$P.        OS: Debian 12 bookworm
    ,g$$P""       """Y$$.".      Kernel: aarch64 Linux 6.12.44-current-rockchip64
   ,$$P'              `$$$.      Uptime: 15m
  ',$$P       ,ggs.     `$$b:    Packages: 366
  `d$$'     ,$P"'   .    $$$     Shell: bash
   $$P      d$'     ,    $$P     Disk: 4.8G / 485G (2%)
   $$:      $$.   -    ,d$$'     CPU: ARM Cortex-A53 Cortex-A72 @ 6x 1.416GHz
   $$\;      Y$b._   _,d$P'      RAM: 4G
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
disappear9@nanopct4:~$ 7z b -mmt6

7-Zip [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=zh_CN.UTF-8,Utf16=on,HugeFiles=on,64 bits,6 CPUs LE)

LE
CPU Freq: 64000000 64000000 - - - - - - -

RAM size:    3852 MB,  # CPU hardware threads:   6
RAM usage:   1323 MB,  # Benchmark threads:      6

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:       4995   493    986   4860  |      93784   520   1538   7998
23:       4735   503    960   4825  |      91755   520   1527   7940
24:       4721   542    937   5077  |      89873   520   1517   7888
25:       4656   574    926   5316  |      87341   519   1497   7773
----------------------------------  | ------------------------------
Avr:             528    952   5019  |              520   1520   7900
Tot:             524   1236   6460
disappear9@nanopct4:~$ 7z b -mmt1

7-Zip [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=zh_CN.UTF-8,Utf16=on,HugeFiles=on,64 bits,6 CPUs LE)

LE
CPU Freq: - - - - - - 512000000 1024000000 -

RAM size:    3852 MB,  # CPU hardware threads:   6
RAM usage:    435 MB,  # Benchmark threads:      1

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:       1629    99   1598   1585  |      22693   100   1943   1938
23:       1535    99   1579   1565  |      22323   100   1938   1932
24:       1466    99   1590   1576  |      21931   100   1931   1925
25:       1355    99   1562   1548  |      21440   100   1915   1908
----------------------------------  | ------------------------------
Avr:              99   1582   1568  |              100   1932   1926
Tot:              99   1757   1747

```

phoronix-test-suite benchmark compress-7zip
```
disappear9@nanopct4:~$ ./phoronix-test-suite benchmark compress-7zip

    pts/compress-7zip-1.12.0:

System Information


  PROCESSOR:              ARMv8 Cortex-A72 @ 1.42GHz
    Core Count:           4
    Thread Count:         6
    Scaling Driver:       cpufreq-dt ondemand

  GRAPHICS:

  MOTHERBOARD:            FriendlyElec NanoPC-T4
    Chipset:              Rockchip RK3399

  MEMORY:                 4096MB

  DISK:                   512GB SK hynix HFS512GDE9X084N + 16GB AJTD4R
    File-System:          ext4
    Mount Options:        commit=120 errors=remount-ro noatime rw
    Disk Scheduler:       NONE
    Disk Details:         Block Size: 4096

  OPERATING SYSTEM:       Debian 12
    Kernel:               6.12.44-current-rockchip64 (aarch64)
    Compiler:             GCC 12.2.0
    Security:             gather_data_sampling: Not affected
                          + indirect_target_selection: Not affected
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
                          + spectre_v2: Vulnerable: Unprivileged eBPF enabled
                          + srbds: Not affected
                          + tsa: Not affected
                          + tsx_async_abort: Not affected

7-Zip Compression 25.00:
    pts/compress-7zip-1.12.0
    Test 1 of 1
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 4 Minutes [10:29 UTC]
        Started Run 1 @ 10:25:56
        Started Run 2 @ 10:27:30
        Started Run 3 @ 10:29:03

    Test: Compression Rating:
        6156
        6193
        6134

    Average: 6161 MIPS
    Deviation: 0.48%

```

sysbench  
```
disappear9@nanopct4:~$ sysbench cpu --cpu-max-prime=20000 --threads=6 run
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 6
Initializing random number generator from current time


Prime numbers limit: 20000

Initializing worker threads...

Threads started!

CPU speed:
    events per second:  2498.63

General statistics:
    total time:                          10.0029s
    total number of events:              25002

Latency (ms):
         min:                                    1.42
         avg:                                    2.40
         max:                                   16.88
         95th percentile:                        3.62
         sum:                                59998.36

Threads fairness:
    events (avg/stddev):           4167.0000/1956.22
    execution time (avg/stddev):   9.9997/0.00


disappear9@nanopct4:~$ sysbench cpu --cpu-max-prime=20000 --threads=1 run
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 1
Initializing random number generator from current time


Prime numbers limit: 20000

Initializing worker threads...

Threads started!

CPU speed:
    events per second:   692.27

General statistics:
    total time:                          10.0012s
    total number of events:              6926

Latency (ms):
         min:                                    1.42
         avg:                                    1.44
         max:                                   12.87
         95th percentile:                        1.44
         sum:                                 9997.66

Threads fairness:
    events (avg/stddev):           6926.0000/0.00
    execution time (avg/stddev):   9.9977/0.00

```
