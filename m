Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5705B572E4
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFZUpO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:45:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50424 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:45:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhs1m018287;
        Wed, 26 Jun 2019 20:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=sbiqdrdkrpvrv5nsJeJ1anMvrBeXWPSuOeD/LdQLXEY=;
 b=1mSwDNXndI/MSh5G7Kt/P/N3dNjFoNx8TqZhcY2BRvLLwnx5oObcYmPN1OFDMIrOFGW6
 Be6R77/VwqkxYJOeXimKvtx9c4QJsTx0oyuKD+G8Ys18QgWDO9n5dWahNyqrsJzu7Vsj
 WuyoLqe3tWXVVxYYGjh098gb3gvMwrTPDtEBemUvE/I3C3BAHkqddpX5FciSzy/CzfKQ
 FGcPtenyImaiEzDopJjD8FvMMR8xzC+3Lgi3uqeO48ofLR8qvacRJ1KGGjxuQ1/ch7lB
 RVwlkyGFdGdsSMW9yBV7ODAKtBWiOV8Ym6bW6Htl4IHiAVJNMBP8X/DATTEaDmRMKaig RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqmgwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:45:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhVK2063871;
        Wed, 26 Jun 2019 20:45:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tat7d1g7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:45:01 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QKj0pu016607;
        Wed, 26 Jun 2019 20:45:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:45:00 -0700
Subject: [PATCH 10/15] xfs: clean up long conditionals in xfs_iwalk_ichunk_ra
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 26 Jun 2019 13:44:59 -0700
Message-ID: <156158189928.495087.16212084141786646726.stgit@magnolia>
In-Reply-To: <156158183697.495087.5371839759804528321.stgit@magnolia>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=948
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=994 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_iwalk_ichunk_ra to avoid long conditionals.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iwalk.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 16744fa556c6..e0d13f5c9cf9 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -83,16 +83,16 @@ xfs_iwalk_ichunk_ra(
 	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
 
 	blk_start_plug(&plug);
-	for (i = 0;
-	     i < XFS_INODES_PER_CHUNK;
-	     i += igeo->inodes_per_cluster,
-			agbno += igeo->blocks_per_cluster) {
-		if (xfs_inobt_maskn(i, igeo->inodes_per_cluster) &
-		    ~irec->ir_free) {
+	for (i = 0; i < XFS_INODES_PER_CHUNK; i += igeo->inodes_per_cluster) {
+		xfs_inofree_t	imask;
+
+		imask = xfs_inobt_maskn(i, igeo->inodes_per_cluster);
+		if (imask & ~irec->ir_free) {
 			xfs_btree_reada_bufs(mp, agno, agbno,
 					igeo->blocks_per_cluster,
 					&xfs_inode_buf_ops);
 		}
+		agbno += igeo->blocks_per_cluster;
 	}
 	blk_finish_plug(&plug);
 }

