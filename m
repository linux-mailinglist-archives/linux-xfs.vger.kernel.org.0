Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925214EFB5
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 21:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfFUT5b (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 15:57:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43482 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfFUT5b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJs6Zh093957;
        Fri, 21 Jun 2019 19:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=5DGpfYEiDueJJNTDXethZFbd5ZEyMsd3fyfvKc3WnLc=;
 b=gG3X3e80WkVlYG8kTeiLHFQAMsZrtgefWwcM9BuICsCDAagRAnuJRW/hZ3HY+i6kdzZY
 oKDcV+JNrLwIxSdbDu4Ed5FHz4OXThwANEmrL1FAZF9HKKDZdCxeesHTkS9MutvbVjq/
 fHQVCexnCx36HSB9qaU+47fXYC1AX7WHoND1nk/rCFf0PYq9IATEdYw6gHg6CJOS9J5k
 Vdo1DaY4CKMU/K97a6CGqtigQRckqDQPBSLN2N6Iw8zF7KjlbQ6MoJ+B0p92nP34iP/+
 tRNhfhG9l3oXEvpISKWkxrW2+YXIuWZhfSa3aTRFnIfMIXLHsa+ZP5pPBakm+75FFnv/ 3g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t7809r8gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJvJHg049682;
        Fri, 21 Jun 2019 19:57:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t77ypcetv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:28 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5LJvRjh007310;
        Fri, 21 Jun 2019 19:57:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 12:57:27 -0700
Subject: [PATCH 4/6] libxfs: fix buffer refcounting in delwri_queue
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 21 Jun 2019 12:57:24 -0700
Message-ID: <156114704472.1643538.14565976860288969023.stgit@magnolia>
In-Reply-To: <156114701371.1643538.316410894576032261.stgit@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the kernel, xfs_buf_delwri_queue increments the buffer reference
count before putting the buffer on the buffer list, and the refcount is
decremented after the io completes for a net refcount change of zero.

In userspace, delwri_queue calls libxfs_writebuf, which puts the buffer.
delwri_queue is a no-op, for a net refcount change of -1.  This creates
problems for any callers that expect a net change of zero, so increment
the buffer refcount before calling writebuf.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h   |    7 +++++++
 libxfs/libxfs_priv.h |    1 -
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index b6f8756a..c47a435d 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -243,4 +243,11 @@ xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
 	return bp;
 }
 
+static inline void
+xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
+{
+	bp->b_node.cn_count++;
+	libxfs_writebuf(bp, 0);
+}
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index eb92942a..fd420f4f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -381,7 +381,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
-#define xfs_buf_delwri_queue(bp, bl)	libxfs_writebuf((bp), 0)
 #define xfs_buf_delwri_submit(bl)	(0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 

