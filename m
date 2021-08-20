Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB413F2E3B
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Aug 2021 16:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbhHTOjv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Aug 2021 10:39:51 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44589 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231706AbhHTOju (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Aug 2021 10:39:50 -0400
Received: from [192.168.0.7] (ip5f5aeb6c.dynamic.kabel-deutschland.de [95.90.235.108])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3DF5E61E5FE02;
        Fri, 20 Aug 2021 16:39:12 +0200 (CEST)
Subject: Re: Slow file operations on file server with 10 TB hardware RAID and
 100 TB software RAID
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     linux-xfs@vger.kernel.org
Cc:     it+linux-xfs@molgen.mpg.de
References: <dcc07afa-08c3-d2d3-7900-75adb290a1bc@molgen.mpg.de>
Message-ID: <3e380495-5f85-3226-f0cf-4452e2b77ccb@molgen.mpg.de>
Date:   Fri, 20 Aug 2021 16:39:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <dcc07afa-08c3-d2d3-7900-75adb290a1bc@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dear Linux folks,


Am 20.08.21 um 16:31 schrieb Paul Menzel:

> Short problem statement: Sometimes changing into a directory on a file 
> server wit 30 TB hardware RAID and 100 TB software RAID both formatted 
> with XFS takes several seconds.
> 
> 
> On a Dell PowerEdge T630 with two Xeon CPU E5-2603 v4 @ 1.70GHz and 96 
> GB RAM a 30 TB hardware RAID is served by the hardware RAID controller 
> and a 100 TB MDRAID software RAID connected to a Microchip 1100-8e both 
> formatted using XFS. Currently, Linux 5.4.39 runs on it.
> 
> ```
> $ more /proc/version
> Linux version 5.4.39.mx64.334 (root@lol.molgen.mpg.de) (gcc version 7.5.0 (GCC)) #1 SMP Thu May 7 14:27:50 CEST 2020
> $ dmesg | grep megar
> [   10.322823] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> [   10.331910] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> [   10.345055] megaraid_sas 0000:03:00.0: BAR:0x1  BAR's base_addr(phys):0x0000000092100000  mapped virt_addr:0x0000000059ea5995
> [   10.345057] megaraid_sas 0000:03:00.0: FW now in Ready state
> [   10.351868] megaraid_sas 0000:03:00.0: 63 bit DMA mask and 32 bit consistent mask
> [   10.361655] megaraid_sas 0000:03:00.0: firmware supports msix    : (96)
> [   10.369433] megaraid_sas 0000:03:00.0: requested/available msix 13/13
> [   10.377113] megaraid_sas 0000:03:00.0: current msix/online cpus    : (13/12)
> [   10.385190] megaraid_sas 0000:03:00.0: RDPQ mode    : (disabled)
> [   10.392092] megaraid_sas 0000:03:00.0: Current firmware supports maximum commands: 928     LDIO threshold: 0
> [   10.403895] megaraid_sas 0000:03:00.0: Configured max firmware commands: 927
> [   10.416840] megaraid_sas 0000:03:00.0: Performance mode :Latency
> [   10.424029] megaraid_sas 0000:03:00.0: FW supports sync cache    : No
> [   10.431417] megaraid_sas 0000:03:00.0: megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
> [   10.486158] megaraid_sas 0000:03:00.0: FW provided supportMaxExtLDs: 1    max_lds: 64
> [   10.495502] megaraid_sas 0000:03:00.0: controller type    : MR(2048MB)
> [   10.502988] megaraid_sas 0000:03:00.0: Online Controller Reset(OCR)    : Enabled
> [   10.511445] megaraid_sas 0000:03:00.0: Secure JBOD support    : No
> [   10.518543] megaraid_sas 0000:03:00.0: NVMe passthru support    : No
> [   10.525834] megaraid_sas 0000:03:00.0: FW provided TM TaskAbort/Reset timeout: 0 secs/0 secs
> [   10.536251] megaraid_sas 0000:03:00.0: JBOD sequence map support    : No
> [   10.543931] megaraid_sas 0000:03:00.0: PCI Lane Margining support    : No
> [   10.574406] megaraid_sas 0000:03:00.0: megasas_enable_intr_fusion is called outbound_intr_mask:0x40000000
> [   10.585995] megaraid_sas 0000:03:00.0: INIT adapter done
> [   10.592409] megaraid_sas 0000:03:00.0: JBOD sequence map is disabled megasas_setup_jbod_map 5660
> [   10.603273] megaraid_sas 0000:03:00.0: pci id        : (0x1000)/(0x005d)/(0x1028)/(0x1f42)
> [   10.612815] megaraid_sas 0000:03:00.0: unevenspan support    : yes
> [   10.619919] megaraid_sas 0000:03:00.0: firmware crash dump    : no
> [   10.627013] megaraid_sas 0000:03:00.0: JBOD sequence map    : disabled
> $ dmesg | grep 1100-8e
> [   25.853170] smartpqi 0000:84:00.0: added 11:2:0:0 0000000000000000 RAID              Adaptec  1100-8e
> [   25.867069] scsi 11:2:0:0: RAID              Adaptec  1100-8e  2.93 PQ: 0 ANSI: 5
> $ xfs_info /dev/sdc
> meta-data=/dev/sdc               isize=512    agcount=28, agsize=268435455 blks
>           =                       sectsz=512   attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=0, rmapbt=0
>           =                       reflink=0
> data     =                       bsize=4096   blocks=7323648000, imaxpct=5
>           =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>           =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> $ xfs_info /dev/md0
> meta-data=/dev/md0               isize=512    agcount=102, agsize=268435328 blks
>           =                       sectsz=4096  attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=0, rmapbt=0
>           =                       reflink=0
> data     =                       bsize=4096   blocks=27348633088, imaxpct=1
>           =                       sunit=128    swidth=1792 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> $ df -i /dev/sdc
> Filesystem         Inodes   IUsed      IFree IUse% Mounted on
> /dev/sdc       2929459200 4985849 2924473351    1% /home/pmenzel
> $ df -i /dev/md0
> Filesystem         Inodes   IUsed      IFree IUse% Mounted on
> /dev/md0       2187890624 5331603 2182559021    1% /jbod/M8015
> ```
> 
> After not using a directory for a while (over 24 hours), changing into 
> it (locally) takes over five seconds or doing some git operations. For 
> example the Linux kernel source git tree located in my home directory. 
> (My shell has some git integration showing the branch name in the prompt 
> (`/usr/share/git-contrib/completion/git-prompt.sh`.) Once in that 
> directory, everything reacts instantly again. When waiting the Linux 
> pressure stall information (PSI) shows IO resource contention.
> 
> Before:
> 
>      $ grep -R . /proc/pressure/
>      /proc/pressure/io:some avg10=0.40 avg60=0.10 avg300=0.10 total=48330841502
>      /proc/pressure/io:full avg10=0.40 avg60=0.10 avg300=0.10 total=48067233340
>      /proc/pressure/cpu:some avg10=0.00 avg60=0.00 avg300=0.00 total=755842910
>      /proc/pressure/memory:some avg10=0.00 avg60=0.00 avg300=0.00 total=2530206336
>      /proc/pressure/memory:full avg10=0.00 avg60=0.00 avg300=0.00 total=2318140732
> 
> During `git log stable/linux-5.10.y`:
> 
>      $ grep -R . /proc/pressure/
>      /proc/pressure/io:some avg10=26.20 avg60=9.72 avg300=2.37 total=48337351849
>      /proc/pressure/io:full avg10=26.20 avg60=9.72 avg300=2.37 total=48073742033
>      /proc/pressure/cpu:some avg10=0.00 avg60=0.00 avg300=0.00 total=755843898
>      /proc/pressure/memory:some avg10=0.00 avg60=0.00 avg300=0.00 total=2530209046
>      /proc/pressure/memory:full avg10=0.00 avg60=0.00 avg300=0.00 total=2318143440
> 
> The current explanation is, that over night several maintenance scripts 
> like backup/mirroring and accounting scripts are run, which touch all 
> files on the devices. Additionally sometimes other users run cluster 
> jobs with millions of files on the software RAID. Such things invalidate 
> the inode cache, and “my” are thrown out. When I use it afterward it’s 
> slow in the beginning. There is still free memory during these times 
> according to `top`.

     $ free -h
                   total        used        free      shared  buff/cache 
   available
     Mem:            94G        8.3G        5.3G        2.3M         80G 
         83G
     Swap:            0B          0B          0B

> Does that sound reasonable with ten million inodes? Is that easily 
> verifiable?

If an inode consume 512 bytes with ten million inodes, that would be 
around 500 MB, which should easily fit into the cache, so it does not 
need to be invalidated?


Kind regards,

Paul
