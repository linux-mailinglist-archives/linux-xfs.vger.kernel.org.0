Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6FD41B87
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 07:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfFLFUv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 01:20:51 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:59829 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfFLFUv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 01:20:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=alvin@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TTyaQEf_1560316846;
Received: from 30.1.89.131(mailfrom:Alvin@linux.alibaba.com fp:SMTPD_---0TTyaQEf_1560316846)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 12 Jun 2019 13:20:47 +0800
From:   Alvin Zheng <Alvin@linux.alibaba.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        "darrick.wong" <darrick.wong@oracle.com>
Cc:     caspar <caspar@linux.alibaba.com>
Subject: [PATCH xfsprogs manual] Inconsistency between the code and the manual
 page
Message-ID: <a8dbaa7f-f89c-8a78-1fc6-3626f6b3f873@linux.alibaba.com>
Date:   Wed, 12 Jun 2019 13:20:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

     The manual page of mkfs.xfs (xfsprogs-5.0.0) says "When specifying  
parameters in units of sectors or filesystem blocks, the -s option or 
the -b option first needs to be added to the command line.  Failure to 
specify the size of the units will result in illegal value errors when 
parameters are quantified in those units". However, I read the code and 
found that if the size of the block and sector is not specified, the 
default size (block: 4k, sector: 512B) will be used. Therefore, the 
following commands can work normally in xfsprogs-5.0.0.

      mkfs.xfs -n size=2b /dev/vdc
      mkfs.xfs -d agsize=8192b /dev/vdc

     So I think the manual of mkfs.xfs should be updated as follows. Any 
ideas?

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 4b8c78c..45d7a84 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -115,9 +115,7 @@ When specifying parameters in units of sectors or 
filesystem blocks, the
  .B \-s
  option or the
  .B \-b
-option first needs to be added to the command line.
-Failure to specify the size of the units will result in illegal value 
errors
-when parameters are quantified in those units.
+option can be used to specify the size of the sector or block. If the 
size of the block or sector is not specified, the default size (block: 
4KiB, sector: 512B) will be used.
  .PP
  Many feature options allow an optional argument of 0 or 1, to explicitly
  disable or enable the functionality.
@@ -136,10 +134,6 @@ The filesystem block size is specified with a
  in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, 
and the
  maximum is 65536 (64 KiB).
  .IP
-To specify any options on the command line in units of filesystem 
blocks, this
-option must be specified first so that the filesystem block size is
-applied consistently to all options.
-.IP
  Although
  .B mkfs.xfs
  will accept any of these values and create a valid filesystem,
@@ -894,10 +888,6 @@ is 512 bytes. The minimum value for sector size is
  .I sector_size
  must be a power of 2 size and cannot be made larger than the
  filesystem block size.
-.IP
-To specify any options on the command line in units of sectors, this
-option must be specified first so that the sector size is
-applied consistently to all options.
  .RE
  .TP
  .BI \-L " label"


     Best regards,

     Alvin

