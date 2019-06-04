Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EAF35233
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 23:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFDVto (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 17:49:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58314 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVto (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:49:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LnSvs052690;
        Tue, 4 Jun 2019 21:49:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=1a53vR3CJMG5/zamat2PM+WUzsLKqpG4xTV6XvNEpn8=;
 b=x8KVuWeTVViCJgbtVwWG68x0W7g+BTHUDAerLGRkQkuJPuyrNCTksuFifB8cM7CnSklv
 FA1C6l9pUd4NKf6quUOpIl7jUAM0u1knpCpN+/8vElNbHEQ/ww3MVdC+wHnscCSVKkmT
 EpvW6B15cFqSd1mkifRr9p739W9sqCw59GupyOyr3W4/2BDEObpzrnL8Ao6vwsIDPv6h
 TJgD8XKEaN/bQw5TOleOW0LO7/8yoiXAdjU6RRJ5DjBesAxvIKV/UsIa94SvNGN8rc/P
 3qH85ma0Mv1bLozvgYBoURfC8x6x3pdrel0Moe2aegg9W/Lc7yCXdLoH9CiJ9XTNMIPc DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sugstfp6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:49:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LmjfG171859;
        Tue, 4 Jun 2019 21:49:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2swngkkht0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:49:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54LnROK024711;
        Tue, 4 Jun 2019 21:49:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 14:49:26 -0700
Subject: [PATCH 4/4] xfs: finish converting to inodes_per_cluster
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Tue, 04 Jun 2019 14:49:25 -0700
Message-ID: <155968496587.1657505.9506367289794220766.stgit@magnolia>
In-Reply-To: <155968493259.1657505.18397791996876650910.stgit@magnolia>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Finish converting all the old inode_cluster_size >> inopblog users to
inodes_per_cluster.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    5 +----
 fs/xfs/xfs_inode.c            |    8 +++-----
 2 files changed, 4 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c1293d170d98..fd7c02ee744b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -33,12 +33,9 @@ xfs_inobp_check(
 	xfs_buf_t	*bp)
 {
 	int		i;
-	int		j;
 	xfs_dinode_t	*dip;
 
-	j = M_IGEO(mp)->inode_cluster_size >> mp->m_sb.sb_inodelog;
-
-	for (i = 0; i < j; i++) {
+	for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
 		dip = xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize);
 		if (!dip->di_next_unlinked)  {
 			xfs_alert(mp,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 65eace4b8723..48756e0219fa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3473,7 +3473,6 @@ xfs_iflush_cluster(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
 	unsigned long		first_index, mask;
-	unsigned long		inodes_per_cluster;
 	int			cilist_size;
 	struct xfs_inode	**cilist;
 	struct xfs_inode	*cip;
@@ -3484,18 +3483,17 @@ xfs_iflush_cluster(
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
-	inodes_per_cluster = igeo->inode_cluster_size >> mp->m_sb.sb_inodelog;
-	cilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
+	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
 	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
 	if (!cilist)
 		goto out_put;
 
-	mask = ~(((igeo->inode_cluster_size >> mp->m_sb.sb_inodelog)) - 1);
+	mask = ~(igeo->inodes_per_cluster - 1);
 	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
 	rcu_read_lock();
 	/* really need a gang lookup range call here */
 	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
-					first_index, inodes_per_cluster);
+					first_index, igeo->inodes_per_cluster);
 	if (nr_found == 0)
 		goto out_free;
 

