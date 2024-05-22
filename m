Return-Path: <linux-xfs+bounces-8504-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A848CB930
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 04:53:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 320CF1F21721
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 02:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D448F1E4A2;
	Wed, 22 May 2024 02:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkgXkwpt"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943905234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346408; cv=none; b=p4rZVuYM8ACBWvGB4yLRQfNVYj0tzn3Z3YAvHHhYV3Ix6RZmMXTjZXS45k1mWl9Yt+Sv+CZqklLGNxabe6JS2/IwjPN8zOJjZdiAtNRCexKBcOjAUTNXlzrkgXzr58jm79tF659vo7CrJGC+TZLcAWcfN32P/3HfMJ/GlZzJnUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346408; c=relaxed/simple;
	bh=RknefPysbQXFaoesZf8r31JOoCoYIl4z2/ohzOavTjA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JhztDK9DiCcOiBOxvRcX4IQtEy0GWLQkUmiqkoJcVlJObuj3nRwqn5xN9/8gTx+sTZMmEbWnG8/7Yk9aDBaT4KxbY+ObOQnuxAuwxiFbL+oFfu4aZ+l3gY8lYb99uwIxeTodbuBm0DwKmWaNZeVcUrBd5qHgLY1IFpVz55DcnX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkgXkwpt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDFFC2BD11;
	Wed, 22 May 2024 02:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346408;
	bh=RknefPysbQXFaoesZf8r31JOoCoYIl4z2/ohzOavTjA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rkgXkwptFiMhd0zshicUasrgq0p6nw4My119RMnA0Cusyx1prcg1I5oNURwLvC3iB
	 eaz82+W67TAS9E6cMS/TTu7UJtwPk94oRFkQfMMN7PTzEDxlhoXq9rwnP2MkNDmbqK
	 0Z/hVL30fJqnyv9Ax8PjptWrLUsVdZc9waqAmlI1qEbsGuj6K8rZYFFPa1+LjPCWVX
	 tf1NnUNZBRDFn9ZRqSjrH0xTEnoBOHUrtvfrOZJVhGCMhcuoau0dG0mLL8OVLg6cmj
	 2+2iPF/b0CBPW82VdAZqy4GI7D22n+gPpfQBVaR0tfgf0+ATmHRmEhhlD1iOqHQYLh
	 sNVrjpibL/8Zw==
Date: Tue, 21 May 2024 19:53:27 -0700
Subject: [PATCH 018/111] xfs: report ag header corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531981.2478931.2943394711951132028.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: de6077ec4198b9313c6e09e4c6acbe9179d057c1

Whenever we encounter a corrupt AG header, we should report that to the
health monitoring system for later reporting.  Buffer readers that don't
respond to corruption events with a _mark_sick call can be detected with
the following script:

#!/bin/bash

# Detect missing calls to xfs_*_mark_sick

filter=cat
tty -s && filter=less

git grep -A10  -E '( = xfs_trans_read_buf| = xfs_buf_read\()' fs/xfs/*.[ch] fs/xfs/libxfs/*.[ch] | awk '
BEGIN {
ignore = 0;
lineno = 0;
delete lines;
}
{
if ($0 == "--") {
if (!ignore) {
for (i = 0; i < lineno; i++) {
print(lines[i]);
}
printf("--\n");
}
delete lines;
lineno = 0;
ignore = 0;
} else if ($0 ~ /mark_sick/) {
ignore = 1;
} else {
lines[lineno++] = $0;
}
}
' | $filter

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c       |    3 +++
 libxfs/xfs_alloc.c  |    6 ++++++
 libxfs/xfs_health.h |   13 ++++++++++---
 libxfs/xfs_ialloc.c |    3 +++
 libxfs/xfs_sb.c     |    2 ++
 5 files changed, 24 insertions(+), 3 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 26339171f..c30d83a8d 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -729,3 +729,6 @@ xfs_fs_mark_healthy(
 
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask) { }
+void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask) { }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 352efbeca..1894a0913 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -22,6 +22,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -751,6 +752,8 @@ xfs_alloc_read_agfl(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_AGFL_REF);
@@ -772,6 +775,7 @@ xfs_alloc_update_counters(
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
 		xfs_buf_mark_corrupt(agbp);
+		xfs_ag_mark_sick(agbp->b_pag, XFS_SICK_AG_AGF);
 		return -EFSCORRUPTED;
 	}
 
@@ -3264,6 +3268,8 @@ xfs_read_agf(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, agfbpp, &xfs_agf_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index bec7adf9f..fb3f2b490 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -26,9 +26,11 @@
  * and the "sick" field tells us if that piece was found to need repairs.
  * Therefore we can conclude that for a given sick flag value:
  *
- *  - checked && sick  => metadata needs repair
- *  - checked && !sick => metadata is ok
- *  - !checked         => has not been examined since mount
+ *  - checked && sick   => metadata needs repair
+ *  - checked && !sick  => metadata is ok
+ *  - !checked && sick  => errors have been observed during normal operation,
+ *                         but the metadata has not been checked thoroughly
+ *  - !checked && !sick => has not been examined since mount
  */
 
 struct xfs_mount;
@@ -142,6 +144,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_corrupt(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
@@ -222,4 +226,7 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
+#define xfs_metadata_is_sick(error) \
+	(unlikely((error) == -EFSCORRUPTED || (error) == -EFSBADCRC))
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 5ff09c8c9..c801250a3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2599,6 +2600,8 @@ xfs_read_agi(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, agibpp, &xfs_agi_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 	if (error)
 		return error;
 	if (tp)
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 402f03a55..00b0a937d 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1288,6 +1288,8 @@ xfs_sb_read_secondary(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_SSB_REF);


