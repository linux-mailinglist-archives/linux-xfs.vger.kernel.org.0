Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774C080FC4
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 02:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfHEAgH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 4 Aug 2019 20:36:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfHEAgG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:36:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750OY0V098687
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=oMSrwzOza5Zkofy5wLu2qGHmVHIO+41I42mPEAs4DG0=;
 b=bbeu6EgoLOOdmvB0QYVyPf+hO7q4Zrgpw01RS72afqOd3Y7l/hff1AhRQmbJlrjVrPB1
 ENMcpDAusYQgNXyKXdxRbi2OkoIv7sgtOEVDGWH9cGUprYcfDDWafT0nS7V0wslFUf9k
 T+WFvx8Nb4oh9LC7JemZMUvEuPYthkZ8IEdM0lLgx7MzFVE8NuWp2/0l3zjblZDMKLeA
 mxuDfhRTNWrteNnTt1kNCgqi23BX+H9fxGqgL2zHhyBTYkN2XNui9VTPYBeLLzWkMSWJ
 AKQ+kEYATcFjFiLxjqmN3a9J4WDU3WHDn/iePsL/WioEtD5rOyV1TgnQjmSu/TKrBQtw PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u527pc79b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750N0s4125808
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u5232sbps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750a46v017468
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Aug 2019 17:36:04 -0700
Subject: [PATCH 12/18] xfs: convert xfs_itruncate_extents_flags to use
 __xfs_bunmapi
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 04 Aug 2019 17:36:03 -0700
Message-ID: <156496536359.804304.13703165772584535140.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's no reason why we can't consume unmap_len, just use the raw
version.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6467d5e1df2d..5fa9e49ccb87 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1516,7 +1516,6 @@ xfs_itruncate_extents_flags(
 	xfs_fileoff_t		last_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
-	int			done = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
@@ -1547,10 +1546,10 @@ xfs_itruncate_extents_flags(
 
 	ASSERT(first_unmap_block < last_block);
 	unmap_len = last_block - first_unmap_block + 1;
-	while (!done) {
+	while (unmap_len > 0) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
-				    XFS_ITRUNC_MAX_EXTENTS, &done);
+		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
+				flags, XFS_ITRUNC_MAX_EXTENTS);
 		if (error)
 			goto out;
 

