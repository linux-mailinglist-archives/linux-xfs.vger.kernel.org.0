Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301E521227
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 04:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfEQCnf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 May 2019 22:43:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8202 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbfEQCnf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 22:43:35 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 29472C5C1F9814967D7E;
        Fri, 17 May 2019 10:43:33 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.14) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 May 2019
 10:43:28 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     <linux-xfs@vger.kernel.org>, <david@fromorbit.com>
CC:     "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Question about commit b450672fb66b ("iomap: sub-block dio needs to
 zeroout beyond EOF")
Message-ID: <8b1ba3a1-7ecc-6e1f-c944-26a51baa9747@huawei.com>
Date:   Fri, 17 May 2019 10:41:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.14]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I don't understand why the commit b450672fb66b ("iomap: sub-block dio needs to zeroout beyond EOF") is needed here:

diff --git a/fs/iomap.c b/fs/iomap.c
index 72f3864a2e6b..77c214194edf 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1677,7 +1677,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
                dio->submit.cookie = submit_bio(bio);
        } while (nr_pages);

-       if (need_zeroout) {
+       /*
+        * We need to zeroout the tail of a sub-block write if the extent type
+        * requires zeroing or the write extends beyond EOF. If we don't zero
+        * the block tail in the latter case, we can expose stale data via mmap
+        * reads of the EOF block.
+        */
+       if (need_zeroout ||
+           ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
                /* zero out from the end of the write to the end of the block */
                pad = pos & (fs_block_size - 1);
                if (pad)

If need_zeroout is false, it means the block neither is a unwritten block nor
a newly-mapped block, but that also means the block must had been a unwritten block
or a newly-mapped block before this write, so the block must have been zeroed, correct ?

It also introduces unnecessary sub-block zeroing if we repeat the same sub-block write.

I also have tried to reproduce the problem by using fsx as noted in the commit message,
but cann't reproduce it. Maybe I do it in the wrong way:

$ ./ltp/fsx -d -g H -H -z -C -I -w 1024 -F -r 1024 -t 4096 -Z /tmp/xfs/fsx

The XFS related with /tmp/xfs is formatted with "-b size=4096". I also try "-b size=1024",
but still no luck.

Could someone explain the scenario in which the extra block zeroing is needed ? Thanks.

Regards,
Tao





