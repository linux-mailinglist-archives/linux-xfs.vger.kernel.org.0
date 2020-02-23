Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDB5169689
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Feb 2020 08:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBWH2H (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Feb 2020 02:28:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725980AbgBWH2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 02:28:07 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01N7NvwJ126335;
        Sun, 23 Feb 2020 02:28:04 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yayaxn4j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 02:28:04 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01N7Q6ng129703;
        Sun, 23 Feb 2020 02:28:03 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yayaxn4hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 02:28:03 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01N7P33r003892;
        Sun, 23 Feb 2020 07:28:02 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 2yaux5smpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 07:28:02 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01N7S2HY49480146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 07:28:02 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E781112062;
        Sun, 23 Feb 2020 07:28:02 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6F8F112061;
        Sun, 23 Feb 2020 07:27:59 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.102.2.13])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 23 Feb 2020 07:27:59 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH V4 1/7] xfs: Pass xattr name and value length explicitly to xfs_attr_leaf_newentsize
Date:   Sun, 23 Feb 2020 13:00:38 +0530
Message-Id: <20200223073044.14215-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-22_08:2020-02-21,2020-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1034 suspectscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230063
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit changes xfs_attr_leaf_newentsize() to explicitly accept name and
value length instead of a pointer to struct xfs_da_args. A future commit will
need to invoke xfs_attr_leaf_newentsize() from functions that do not have
a struct xfs_da_args to pass in.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---

Changelog:
V1 -> V2:
1. Use convenience variables to reduce indentation of code.

V2 -> V3:
1. Introduce 'struct xfs_attr_set_resv' to collect various block size
   reservations when inserting an xattr.
2. Add xfs_calc_attr_res() to calculate the total log reservation to
   required when inserting an xattr.

V3 -> V4:
1. Rebase the patchset on top of Christoph's "Clean attr interface"
   patchset. The patchset can be obtained from
   https://github.com/chandanr/linux/tree/xfs-fix-attr-resv-calc-v4.
2. Split the patchset into
   - Patches which refactor the existing calculation in
     xfs_attr_calc_size().
   - One patch which fixes the calculation inside
     xfs_attr_calc_size().
3. Fix indentation issues.
4. Pass attribute geometry pointer to xfs_attr_leaf_newentsize()
   instead of a pointer to xfs_mount.

 fs/xfs/libxfs/xfs_attr.c      |  3 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c | 39 +++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23e0d8ce39f8c..1875210cc8e40 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -149,7 +149,8 @@ xfs_attr_calc_size(
 	 * Determine space new attribute will use, and if it would be
 	 * "local" or "remote" (note: local != inline).
 	 */
-	size = xfs_attr_leaf_newentsize(args, local);
+	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+			args->valuelen, local);
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	if (*local) {
 		if (size > (args->geo->blksize / 2)) {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index fae322105457a..65a3bf40c4f9d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1330,7 +1330,8 @@ xfs_attr3_leaf_add(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	ASSERT(args->index >= 0 && args->index <= ichdr.count);
-	entsize = xfs_attr_leaf_newentsize(args, NULL);
+	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+			args->valuelen, NULL);
 
 	/*
 	 * Search through freemap for first-fit on new name length.
@@ -1403,6 +1404,7 @@ xfs_attr3_leaf_add_work(
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
 	struct xfs_mount	*mp;
+	int			entsize;
 	int			tmp;
 	int			i;
 
@@ -1432,11 +1434,14 @@ xfs_attr3_leaf_add_work(
 	ASSERT(ichdr->freemap[mapindex].base < args->geo->blksize);
 	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
 	ASSERT(ichdr->freemap[mapindex].size >=
-		xfs_attr_leaf_newentsize(args, NULL));
+		xfs_attr_leaf_newentsize(args->geo, args->namelen,
+				args->valuelen, NULL));
 	ASSERT(ichdr->freemap[mapindex].size < args->geo->blksize);
 	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
 
-	ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);
+	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+			args->valuelen, &tmp);
+	ichdr->freemap[mapindex].size -= entsize;
 
 	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
 				     ichdr->freemap[mapindex].size);
@@ -1824,6 +1829,8 @@ xfs_attr3_leaf_figure_balance(
 	struct xfs_attr_leafblock	*leaf1 = blk1->bp->b_addr;
 	struct xfs_attr_leafblock	*leaf2 = blk2->bp->b_addr;
 	struct xfs_attr_leaf_entry	*entry;
+	struct xfs_da_args		*args;
+	int				entsize;
 	int				count;
 	int				max;
 	int				index;
@@ -1833,14 +1840,16 @@ xfs_attr3_leaf_figure_balance(
 	int				foundit = 0;
 	int				tmp;
 
+	args = state->args;
 	/*
 	 * Examine entries until we reduce the absolute difference in
 	 * byte usage between the two blocks to a minimum.
 	 */
 	max = ichdr1->count + ichdr2->count;
 	half = (max + 1) * sizeof(*entry);
-	half += ichdr1->usedbytes + ichdr2->usedbytes +
-			xfs_attr_leaf_newentsize(state->args, NULL);
+	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+			args->valuelen, NULL);
+	half += ichdr1->usedbytes + ichdr2->usedbytes + entsize;
 	half /= 2;
 	lastdelta = state->args->geo->blksize;
 	entry = xfs_attr3_leaf_entryp(leaf1);
@@ -1851,8 +1860,9 @@ xfs_attr3_leaf_figure_balance(
 		 * The new entry is in the first block, account for it.
 		 */
 		if (count == blk1->index) {
-			tmp = totallen + sizeof(*entry) +
-				xfs_attr_leaf_newentsize(state->args, NULL);
+			entsize = xfs_attr_leaf_newentsize(args->geo,
+					args->namelen, args->valuelen, NULL);
+			tmp = totallen + sizeof(*entry) + entsize;
 			if (XFS_ATTR_ABS(half - tmp) > lastdelta)
 				break;
 			lastdelta = XFS_ATTR_ABS(half - tmp);
@@ -1887,8 +1897,9 @@ xfs_attr3_leaf_figure_balance(
 	 */
 	totallen -= count * sizeof(*entry);
 	if (foundit) {
-		totallen -= sizeof(*entry) +
-				xfs_attr_leaf_newentsize(state->args, NULL);
+		entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+				args->valuelen, NULL);
+		totallen -= sizeof(*entry) + entsize;
 	}
 
 	*countarg = count;
@@ -2664,20 +2675,22 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
  */
 int
 xfs_attr_leaf_newentsize(
-	struct xfs_da_args	*args,
+	struct xfs_da_geometry	*geo,
+	int			namelen,
+	int			valuelen,
 	int			*local)
 {
 	int			size;
 
-	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
-	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
+	size = xfs_attr_leaf_entsize_local(namelen, valuelen);
+	if (size < xfs_attr_leaf_entsize_local_max(geo->blksize)) {
 		if (local)
 			*local = 1;
 		return size;
 	}
 	if (local)
 		*local = 0;
-	return xfs_attr_leaf_entsize_remote(args->namelen);
+	return xfs_attr_leaf_entsize_remote(namelen);
 }
 
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 6dd2d937a42a3..7bc5dd6c4d66a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -96,7 +96,8 @@ void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
 xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_buf *bp, int *count);
 int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
 				   struct xfs_buf *leaf2_bp);
-int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
+int	xfs_attr_leaf_newentsize(struct xfs_da_geometry	*geo, int namelen,
+			int valuelen, int *local);
 int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			xfs_dablk_t bno, struct xfs_buf **bpp);
 void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
-- 
2.19.1

