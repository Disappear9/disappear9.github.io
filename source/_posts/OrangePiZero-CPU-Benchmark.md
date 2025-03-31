---
title: OrangePi Zero CPU跑分测试 CPU Benchmark
date: 2023/12/01 12:00:00
categories:
- 测试结果
tags:
- 测试结果
- 杂项
---

CPU:H2+  
RAM:512M  

(于2025/03重测)  

screenfetch  
```
         _,met$$$$$gg.           disappear9@OPi-Zero
      ,g$$$$$$$$$$$$$$$P.        OS: Debian 12 bookworm
    ,g$$P""       """Y$$.".      Kernel: armv7l Linux 6.6.75-current-sunxi
   ,$$P'              `$$$.      Uptime: 1h 41m
  ',$$P       ,ggs.     `$$b:    Packages: 437
  `d$$'     ,$P"'   .    $$$     Shell: bash
   $$P      d$'     ,    $$P     Disk: 3.8G / 30G (14%)
   $$:      $$.   -    ,d$$'     CPU: ARMv7 rev 5 (v7l) @ 4x 1.296GHz
   $$\;      Y$b._   _,d$P'      GPU:
   Y$$.    `.`"Y$$$$P"'          RAM: -
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
disappear9@OPi-Zero:~$ 7z b -mmt4

7-Zip [32] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=zh_CN.UTF-8,Utf16=on,HugeFiles=on,32 bits,4 CPUs LE)

LE
CPU Freq: 32000000 - - - - - - - -

RAM size:     489 MB,  # CPU hardware threads:   4
RAM usage:    450 MB,  # Benchmark threads:      4

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:       1513   347    424   1472  |      44851   396    966   3827
23:       1431   356    410   1459  |      41115   396    899   3557
24:       1305   355    396   1403  |      37626   396    834   3303
----------------------------------  | ------------------------------
Avr:             353    410   1445  |              396    900   3562
Tot:             374    655   2504
disappear9@OPi-Zero:~$ 7z b -mmt1

7-Zip [32] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=zh_CN.UTF-8,Utf16=on,HugeFiles=on,32 bits,4 CPUs LE)

LE
CPU Freq: 64000000 64000000 64000000 - - - - - -

RAM size:     489 MB,  # CPU hardware threads:   4
RAM usage:    435 MB,  # Benchmark threads:      1

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:        573   100    558    558  |      11927   100   1019   1018
23:        539   100    550    550  |      11765   100   1019   1018
24:        518   100    557    557  |      11506   100   1010   1010
25:        491   100    562    561  |      11200   100    997    997
----------------------------------  | ------------------------------
Avr:             100    557    557  |              100   1011   1011
Tot:             100    784    784

```

sysbench  
```
disappear9@OPi-Zero:~$ sysbench cpu --cpu-max-prime=20000 --threads=4 run
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 4
Initializing random number generator from current time


Prime numbers limit: 20000

Initializing worker threads...

Threads started!

CPU speed:
    events per second:    74.41

General statistics:
    total time:                          10.0407s
    total number of events:              748

Latency (ms):
         min:                                   53.14
         avg:                                   53.62
         max:                                  107.58
         95th percentile:                       52.89
         sum:                                40104.21

Threads fairness:
    events (avg/stddev):           187.0000/0.00
    execution time (avg/stddev):   10.0261/0.01

disappear9@OPi-Zero:~$ sysbench cpu --cpu-max-prime=20000 --threads=1 run
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 1
Initializing random number generator from current time


Prime numbers limit: 20000

Initializing worker threads...

Threads started!

CPU speed:
    events per second:    18.59

General statistics:
    total time:                          10.0466s
    total number of events:              187

Latency (ms):
         min:                                   53.17
         avg:                                   53.71
         max:                                  106.98
         95th percentile:                       52.89
         sum:                                10044.25

Threads fairness:
    events (avg/stddev):           187.0000/0.00
    execution time (avg/stddev):   10.0442/0.00

```
