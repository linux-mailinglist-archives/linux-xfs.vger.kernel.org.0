Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7979572E0
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFZUo7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:44:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40630 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:44:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKi7m0126263;
        Wed, 26 Jun 2019 20:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=SqxUNZmfEFBK9gYJVGbVJoHcqiXGxNJIOYIvV/UPH6E=;
 b=PpRI8Mvd19kFpD77nvPq9LEdMNgZWiyB0d4czrEGB3IdcJHTRFUXdY//sCWN3zGHRg2n
 4z52DNndUekI22YsTtGx7vEymGmLunBxg9OHp6j/0TMEit2f5pn2z3Vglhy9r45p75iA
 LEBfBCBLnDVg/0LBk1zBaZYd1fBj7Bn8FWDEFT99MAfrzYjd+63nRd9q7bGfK9CNRX6k
 xGi3JOqoZJN7irOJoCHEYSzL5G9UoIo1YnBWcGhkGwqpWdIJO6/13SgLFXtmXJMHIdoe
 BTJMJQ8w+66uEDdhE9iHNmeLC5iq0tr9ZVRB5QLsYa0ULoVUbV8s2y0V6/8/BkzW9D91 vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t9c9pvk3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:44:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhVJ4063909;
        Wed, 26 Jun 2019 20:44:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tat7d1g3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:44:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKigft006737;
        Wed, 26 Jun 2019 20:44:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:44:41 -0700
Subject: [PATCH 07/15] xfs: calculate inode walk prefetch more carefully
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 26 Jun 2019 13:44:40 -0700
Message-ID: <156158188075.495087.14228436478786857410.stgit@magnolia>
In-Reply-To: <156158183697.495087.5371839759804528321.stgit@magnolia>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The existing inode walk prefetch is based on the old bulkstat code,
which simply allocated 4 pages worth of memory and prefetched that many
inobt records, regardless of however many inodes the caller requested.
65536 inodes is a lot to prefetch (~32M on x64, ~512M on arm64) so let's
scale things down a little more intelligently based on the number of
inodes requested, etc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 304c41e6ed1d..3e67d7702e16 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -333,16 +333,58 @@ xfs_iwalk_ag(
 	return error;
 }
 
+/*
+ * We experimentally determined that the reduction in ioctl call overhead
+ * diminishes when userspace asks for more than 2048 inodes, so we'll cap
+ * prefetch at this point.
+ */
+#define MAX_IWALK_PREFETCH	(2048U)
+
 /*
  * Given the number of inodes to prefetch, set the number of inobt records that
  * we cache in memory, which controls the number of inodes we try to read
- * ahead.
+ * ahead.  Set the maximum if @inode_records == 0.
  */
 static inline unsigned int
 xfs_iwalk_prefetch(
 	unsigned int		inode_records)
 {
-	return PAGE_SIZE * 4 / sizeof(struct xfs_inobt_rec_incore);
+	unsigned int		inobt_records;
+
+	/*
+	 * If the caller didn't tell us the number of inodes they wanted,
+	 * assume the maximum prefetch possible for best performance.
+	 * Otherwise, cap prefetch at that maximum so that we don't start an
+	 * absurd amount of prefetch.
+	 */
+	if (inode_records == 0)
+		inode_records = MAX_IWALK_PREFETCH;
+	inode_records = min(inode_records, MAX_IWALK_PREFETCH);
+
+	/* Round the inode count up to a full chunk. */
+	inode_records = round_up(inode_records, XFS_INODES_PER_CHUNK);
+
+	/*
+	 * In order to convert the number of inodes to prefetch into an
+	 * estimate of the number of inobt records to cache, we require a
+	 * conversion factor that reflects our expectations of the average
+	 * loading factor of an inode chunk.  Based on data gathered, most
+	 * (but not all) filesystems manage to keep the inode chunks totally
+	 * full, so we'll underestimate slightly so that our readahead will
+	 * still deliver the performance we want on aging filesystems:
+	 *
+	 * inobt = inodes / (INODES_PER_CHUNK * (4 / 5));
+	 *
+	 * The funny math is to avoid division.
+	 */
+	inobt_records = (inode_records * 5) / (4 * XFS_INODES_PER_CHUNK);
+
+	/*
+	 * Allocate enough space to prefetch at least two inobt records so that
+	 * we can cache both the record where the iwalk started and the next
+	 * record.  This simplifies the AG inode walk loop setup code.
+	 */
+	return max(inobt_records, 2U);
 }
 
 /*

