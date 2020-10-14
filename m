Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E44E28D95A
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Oct 2020 06:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgJNElj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Oct 2020 00:41:39 -0400
Received: from out20-25.mail.aliyun.com ([115.124.20.25]:34912 "EHLO
        out20-25.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgJNElj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 00:41:39 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.05316433|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0487988-0.00611436-0.945087;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.IiyQ687_1602650495;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.IiyQ687_1602650495)
          by smtp.aliyun-inc.com(10.147.40.233);
          Wed, 14 Oct 2020 12:41:36 +0800
Date:   Wed, 14 Oct 2020 12:41:39 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: dbench throughput(sync, reflink=0|1) on xfs over hardware throughput
Cc:     wangyugui@e16-tech.com
In-Reply-To: <20201013235609.EFC0.409509F4@e16-tech.com>
References: <20201013235609.EFC0.409509F4@e16-tech.com>
Message-Id: <20201014124138.7A0E.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.01 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

For xfs sync performance optimization, there is an option 'osyncisdsync'
which is removed in 4.0(man xfs)

the xfs sync performance optimization in linux 5.4.70/5.9.0 is beyond
'osyncisdsync'? When multiple write(sync) at the same time, just some of
them are guaranteed?

Or deduplication(based on reflink=1) help the sync write?
and 'mkfs.xfs -m reflink=0' failed to disable it?

iotop show that 'Actual DISK WRITE:' is NOT over hardware throughput.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2020/10/14

> Hi,
> 
> #any reply, please Cc: wangyugui@e16-tech.com
> 
> dbench throughput(sync, reflink=0|1) on xfs over hardware
> throughput(6Gb/s=750MB/s).
> 
> Is this a bug of xfs sync?  or some feature of performance optimization?
> 
> we test mkfs.xfs -m reflink=0|1, crc=0|1, still over hardware
> throughput(6Gb/s=750MB/s).
> 
> Disk: TOSHIBA  PX05SMQ040
> This is a 12Gb/s SAS SSD disk, but connect to 6Gb/s SAS HBA,
> so it works with 6Gb/s.
> 
> dbench -s -t 60 -D /xfs 32
> #Throughput 884.406 MB/sec (sync open)
> 
> 
> dbench -s -t 60 -D /xfs 1
> #Throughput 149.172 MB/sec (sync open)
> 
> we test the same disk with ext4 filesystem, 
> the throughput is very close to, but less than the hardware limit.
> 
> dbench -s -t 60 -D /ext4 32
> #Throughput 740.95 MB/sec (sync open)
> 
> dbench -s -t 60 -D /ext4 1
> #Throughput 124.67 MB/sec (sync open)
> 
> linux kernel: 5.4.70, 5.9.0
> 
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2020/10/13
> 


