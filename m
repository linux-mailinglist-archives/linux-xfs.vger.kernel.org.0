Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3262C1CA1BE
	for <lists+linux-xfs@lfdr.de>; Fri,  8 May 2020 06:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725287AbgEHEAm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 May 2020 00:00:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47014 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725271AbgEHEAl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 00:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588910439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=YzcWrhRRPmD966PmEUFUF1WbbNr4V8A69/gu4cBZbvc=;
        b=HxrvvbFm5zoixj8ULKFcAYXbD+XU9pXFs71HTBvxEMzwwMLp3+iBI6wAVuZ1Je+++LLhVl
        vyrHof5oFhHX3MLxSdAmHwia0D45rlSXAQaiGD0wTTCefeiZPIs9RtCKfo2+Tipdmr7/oE
        nsah3SQF9xEw+bAhMT0nfTa81avqP+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-B7SOIO6zMAW6WvqIXqGQ8w-1; Fri, 08 May 2020 00:00:36 -0400
X-MC-Unique: B7SOIO6zMAW6WvqIXqGQ8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3B5F80B725
        for <linux-xfs@vger.kernel.org>; Fri,  8 May 2020 04:00:35 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2696019167
        for <linux-xfs@vger.kernel.org>; Fri,  8 May 2020 04:00:35 +0000 (UTC)
Subject: [PATCH 2/2] xfs: remove XFS_QMOPT_ENOSPC flag
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
Date:   Thu, 7 May 2020 23:00:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The only place we return -EDQUOT, and therefore need to make a decision
about returning -ENOSPC for project quota instead, is in xfs_trans_dqresv().

So there's no reason to be setting and clearing XFS_QMOPT_ENOSPC at higher
levels; if xfs_trans_dqresv has failed, test if the dqp we were were handed
is a project quota and if so, return -ENOSPC instead of EDQUOT.  The
complexity is just a leftover from when project & group quota were mutually
exclusive and shared some codepaths.

The prior patch was the trivial bugfix, this is the slightly more involved
cleanup.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Patch 1 was the trivial bugfix, this is the slightly more involved cleanup.

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index b2113b17e53c..56d9dd787e7b 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -100,7 +100,6 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
 #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
 #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
-#define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
 
 /*
  * flags to xfs_trans_mod_dquot to indicate which field needs to be
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c225691fad15..591779aa2fd0 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1808,7 +1808,7 @@ xfs_qm_vop_chown_reserve(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint64_t		delblks;
-	unsigned int		blkflags, prjflags = 0;
+	unsigned int		blkflags;
 	struct xfs_dquot	*udq_unres = NULL;
 	struct xfs_dquot	*gdq_unres = NULL;
 	struct xfs_dquot	*pdq_unres = NULL;
@@ -1849,7 +1849,6 @@ xfs_qm_vop_chown_reserve(
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
 	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
-		prjflags = XFS_QMOPT_ENOSPC;
 		pdq_delblks = pdqp;
 		if (delblks) {
 			ASSERT(ip->i_pdquot);
@@ -1859,8 +1858,7 @@ xfs_qm_vop_chown_reserve(
 
 	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
 				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1,
-				flags | blkflags | prjflags);
+				ip->i_d.di_nblocks, 1, flags | blkflags);
 	if (error)
 		return error;
 
@@ -1878,8 +1876,7 @@ xfs_qm_vop_chown_reserve(
 		ASSERT(udq_unres || gdq_unres || pdq_unres);
 		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
 			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0,
-			    flags | blkflags | prjflags);
+			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
 		if (error)
 			return error;
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2c3557a80e69..2c07897a3c37 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -711,7 +711,7 @@ xfs_trans_dqresv(
 
 error_return:
 	xfs_dqunlock(dqp);
-	if (flags & XFS_QMOPT_ENOSPC)
+	if (XFS_QM_ISPDQ(dqp))
 		return -ENOSPC;
 	return -EDQUOT;
 }
@@ -751,15 +751,13 @@ xfs_trans_reserve_quota_bydquots(
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
 	if (udqp) {
-		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos,
-					(flags & ~XFS_QMOPT_ENOSPC));
+		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos, flags);
 		if (error)
 			return error;
 	}
 
 	if (gdqp) {
-		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
-					(flags & ~XFS_QMOPT_ENOSPC));
+		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
 		if (error)
 			goto unwind_usr;
 	}
@@ -804,16 +802,12 @@ xfs_trans_reserve_quota_nblks(
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
-	if (XFS_IS_PQUOTA_ON(mp))
-		flags |= XFS_QMOPT_ENOSPC;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
-				XFS_TRANS_DQ_RES_RTBLKS ||
-	       (flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
-				XFS_TRANS_DQ_RES_BLKS);
+	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_RTBLKS ||
+	       (flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_BLKS);
 
 	/*
 	 * Reserve nblks against these dquots, with trans as the mediator.


