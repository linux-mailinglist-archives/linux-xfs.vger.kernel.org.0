Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD06196AA6
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Aug 2019 22:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730866AbfHTUc2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Aug 2019 16:32:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730863AbfHTUc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:32:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKT3na166002;
        Tue, 20 Aug 2019 20:32:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SHEoy7oPgn6ddDFcx8nhGHAFDMTQratD9PLk8yIwi2U=;
 b=TmYjBxuGVSfZVClnuqN3erkb5+YnWsZhxjEBLSkViNrt7awwudLL09gj0/11wkB9pRG+
 On95avMaK3czHvHh2QyV1eiNCm3gyp097T1piT2wbptAd99Tcw7xD7aGMomPCRhK9sLj
 O2OJpsZPIQ4+e77WCS8m/akoGFjSIBCFGZAQIPTNQ45xU433R32DOa+/vtfY9OTAHNHS
 krDXdCu7fjdqCUpmbqP5mbVnDn+ALSGzoIPPd2XKA/qIOcat05y5in97TqjSXNg/s2Zi
 nEBfivRim5UIZ/XlgwnPVOQ0p5jRmL4xwh4wQelqhkxHKCeYoFmEUfsMQ0YiMQA2s6lM 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uea7qs0qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:32:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTBBU071245;
        Tue, 20 Aug 2019 20:32:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ugj7pnfgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:32:25 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKWOaT021984;
        Tue, 20 Aug 2019 20:32:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:32:23 -0700
Subject: [PATCH 11/12] xfs_repair: use precomputed inode geometry values
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:32:23 -0700
Message-ID: <156633314305.1215978.18190917724979571824.stgit@magnolia>
In-Reply-To: <156633307176.1215978.17394956977918540525.stgit@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the precomputed inode geometry values instead of open-coding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dino_chunks.c |   22 +++++++++++-----------
 repair/dinode.c      |   13 ++++---------
 repair/globals.c     |    1 -
 repair/globals.h     |    1 -
 repair/prefetch.c    |   21 ++++++++-------------
 repair/xfs_repair.c  |    2 --
 6 files changed, 23 insertions(+), 37 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 323a355e..00b67468 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -608,7 +608,6 @@ process_inode_chunk(
 	xfs_ino_t		ino;
 	int			dirty = 0;
 	int			isa_dir = 0;
-	int			blks_per_cluster;
 	int			cluster_count;
 	int			bp_index;
 	int			cluster_offset;
@@ -620,10 +619,7 @@ process_inode_chunk(
 	*bogus = 0;
 	ASSERT(igeo->ialloc_blks > 0);
 
-	blks_per_cluster = M_IGEO(mp)->inode_cluster_size >> mp->m_sb.sb_blocklog;
-	if (blks_per_cluster == 0)
-		blks_per_cluster = 1;
-	cluster_count = XFS_INODES_PER_CHUNK / inodes_per_cluster;
+	cluster_count = XFS_INODES_PER_CHUNK / M_IGEO(mp)->inodes_per_cluster;
 	if (cluster_count == 0)
 		cluster_count = 1;
 
@@ -662,13 +658,16 @@ process_inode_chunk(
 
 		bplist[bp_index] = libxfs_readbuf(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, blks_per_cluster), 0,
+					XFS_FSB_TO_BB(mp,
+						M_IGEO(mp)->blocks_per_cluster),
+					0,
 					&xfs_inode_buf_ops);
 		if (!bplist[bp_index]) {
 			do_warn(_("cannot read inode %" PRIu64 ", disk block %" PRId64 ", cnt %d\n"),
 				XFS_AGINO_TO_INO(mp, agno, first_irec->ino_startnum),
 				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				XFS_FSB_TO_BB(mp, blks_per_cluster));
+				XFS_FSB_TO_BB(mp,
+					M_IGEO(mp)->blocks_per_cluster));
 			while (bp_index > 0) {
 				bp_index--;
 				libxfs_putbuf(bplist[bp_index]);
@@ -684,8 +683,9 @@ process_inode_chunk(
 		bplist[bp_index]->b_ops = &xfs_inode_buf_ops;
 
 next_readbuf:
-		irec_offset += mp->m_sb.sb_inopblock * blks_per_cluster;
-		agbno += blks_per_cluster;
+		irec_offset += mp->m_sb.sb_inopblock *
+				M_IGEO(mp)->blocks_per_cluster;
+		agbno += M_IGEO(mp)->blocks_per_cluster;
 	}
 	agbno = XFS_AGINO_TO_AGBNO(mp, first_irec->ino_startnum);
 
@@ -745,7 +745,7 @@ process_inode_chunk(
 				ASSERT(ino_rec->ino_startnum == agino + 1);
 				irec_offset = 0;
 			}
-			if (cluster_offset == inodes_per_cluster) {
+			if (cluster_offset == M_IGEO(mp)->inodes_per_cluster) {
 				bp_index++;
 				cluster_offset = 0;
 			}
@@ -964,7 +964,7 @@ process_inode_chunk(
 			ASSERT(ino_rec->ino_startnum == agino + 1);
 			irec_offset = 0;
 		}
-		if (cluster_offset == inodes_per_cluster) {
+		if (cluster_offset == M_IGEO(mp)->inodes_per_cluster) {
 			bp_index++;
 			cluster_offset = 0;
 		}
diff --git a/repair/dinode.c b/repair/dinode.c
index f5e88cc3..8af2cb25 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -755,8 +755,6 @@ get_agino_buf(
 	struct xfs_dinode	**dipp)
 {
 	struct xfs_buf		*bp;
-	int			cluster_size;
-	int			ino_per_cluster;
 	xfs_agino_t		cluster_agino;
 	xfs_daddr_t		cluster_daddr;
 	xfs_daddr_t		cluster_blks;
@@ -768,18 +766,15 @@ get_agino_buf(
 	 * we must find the buffer for its cluster, add the appropriate
 	 * offset, and return that.
 	 */
-	cluster_size = igeo->inode_cluster_size;
-	ino_per_cluster = cluster_size / mp->m_sb.sb_inodesize;
-	cluster_agino = agino & ~(ino_per_cluster - 1);
-	cluster_blks = XFS_FSB_TO_DADDR(mp, max(1,
-			igeo->inode_cluster_size >> mp->m_sb.sb_blocklog));
+	cluster_agino = agino & ~(igeo->inodes_per_cluster - 1);
+	cluster_blks = XFS_FSB_TO_DADDR(mp, igeo->blocks_per_cluster);
 	cluster_daddr = XFS_AGB_TO_DADDR(mp, agno,
 			XFS_AGINO_TO_AGBNO(mp, cluster_agino));
 
 #ifdef XR_INODE_TRACE
 	printf("cluster_size %d ipc %d clusagino %d daddr %lld sectors %lld\n",
-		cluster_size, ino_per_cluster, cluster_agino, cluster_daddr,
-		cluster_blks);
+		M_IGEO(mp)->inode_cluster_size, M_IGEO(mp)->inodes_per_cluster,
+		cluster_agino, cluster_daddr, cluster_blks);
 #endif
 
 	bp = libxfs_readbuf(mp->m_dev, cluster_daddr, cluster_blks,
diff --git a/repair/globals.c b/repair/globals.c
index ae9d55b4..dcd79ea4 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -81,7 +81,6 @@ xfs_agblock_t	inobt_root;
 /* configuration vars -- fs geometry dependent */
 
 int		inodes_per_block;
-int		inodes_per_cluster;
 unsigned int	glob_agcount;
 int		chunks_pblock;	/* # of 64-ino chunks per allocation */
 int		max_symlink_blocks;
diff --git a/repair/globals.h b/repair/globals.h
index 05121d4f..008bdd90 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -122,7 +122,6 @@ extern xfs_agblock_t	inobt_root;
 /* configuration vars -- fs geometry dependent */
 
 extern int		inodes_per_block;
-extern int		inodes_per_cluster;
 extern unsigned int	glob_agcount;
 extern int		chunks_pblock;	/* # of 64-ino chunks per allocation */
 extern int		max_symlink_blocks;
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 2fecfd68..5a725a51 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -710,17 +710,12 @@ pf_queuing_worker(
 	int			num_inos;
 	ino_tree_node_t		*irec;
 	ino_tree_node_t		*cur_irec;
-	int			blks_per_cluster;
 	xfs_agblock_t		bno;
 	int			i;
 	int			err;
 	uint64_t		sparse;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 
-	blks_per_cluster = igeo->inode_cluster_size >> mp->m_sb.sb_blocklog;
-	if (blks_per_cluster == 0)
-		blks_per_cluster = 1;
-
 	for (i = 0; i < PF_THREAD_COUNT; i++) {
 		err = pthread_create(&args->io_threads[i], NULL,
 				pf_io_worker, args);
@@ -786,21 +781,22 @@ pf_queuing_worker(
 			struct xfs_buf_map	map;
 
 			map.bm_bn = XFS_AGB_TO_DADDR(mp, args->agno, bno);
-			map.bm_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+			map.bm_len = XFS_FSB_TO_BB(mp,
+					M_IGEO(mp)->blocks_per_cluster);
 
 			/*
 			 * Queue I/O for each non-sparse cluster. We can check
 			 * sparse state in cluster sized chunks as cluster size
 			 * is the min. granularity of sparse irec regions.
 			 */
-			if ((sparse & ((1ULL << inodes_per_cluster) - 1)) == 0)
+			if ((sparse & ((1ULL << M_IGEO(mp)->inodes_per_cluster) - 1)) == 0)
 				pf_queue_io(args, &map, 1,
 					    (cur_irec->ino_isa_dir != 0) ?
 					     B_DIR_INODE : B_INODE);
 
-			bno += blks_per_cluster;
-			num_inos += inodes_per_cluster;
-			sparse >>= inodes_per_cluster;
+			bno += igeo->blocks_per_cluster;
+			num_inos += igeo->inodes_per_cluster;
+			sparse >>= igeo->inodes_per_cluster;
 		} while (num_inos < igeo->ialloc_inos);
 	}
 
@@ -903,9 +899,8 @@ start_inode_prefetch(
 
 	max_queue = libxfs_bcache->c_maxcount / thread_count / 8;
 	if (igeo->inode_cluster_size > mp->m_sb.sb_blocksize)
-		max_queue = max_queue *
-			(igeo->inode_cluster_size >> mp->m_sb.sb_blocklog) /
-			igeo->ialloc_blks;
+		max_queue = max_queue * igeo->blocks_per_cluster /
+				igeo->ialloc_blks;
 
 	sem_init(&args->ra_count, 0, max_queue);
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9f4f2611..c7f3bfbc 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -762,8 +762,6 @@ main(int argc, char **argv)
 
 	chunks_pblock = mp->m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
 	max_symlink_blocks = libxfs_symlink_blocks(mp, XFS_SYMLINK_MAXLEN);
-	inodes_per_cluster = max(mp->m_sb.sb_inopblock,
-			igeo->inode_cluster_size >> mp->m_sb.sb_inodelog);
 
 	/*
 	 * Automatic striding for high agcount filesystems.

