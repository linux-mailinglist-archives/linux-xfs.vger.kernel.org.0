Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D851DBD27
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETSnX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 May 2020 14:43:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45738 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726754AbgETSnW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 14:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590000200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=FDqEkuLYMtpk3kSq+jX0KuUHAEmTnC/mIAgs7u19lHQ=;
        b=iVGGZIUY7l0nE8mF4M6frRAExGgEyaNge9CiEBgfLqwaTSDbKheVSk6mXTyixKIA7kcA7m
        PvwLipZFsXhemxBPTtrpUjn1Lpq9wGIPmlVRjQ9K0XP+wVds1jaLCl2ncxQhrvDEGnQLTZ
        ujMEjhxdSlVrdqFwB9ao4B6im9LFdyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-eCm7nx7SNIuTd5YgR7gQdg-1; Wed, 20 May 2020 14:43:17 -0400
X-MC-Unique: eCm7nx7SNIuTd5YgR7gQdg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3DA8872FF0
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 18:43:16 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97C27579A3
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 18:43:16 +0000 (UTC)
Subject: [PATCH 5/6 V2] xfs: per-type quota timers and warn limits
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
 <e27a2dff-f728-f69e-32b6-a83eee7effef@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <95743095-0be7-a137-44f9-8a225b15d5db@redhat.com>
Date:   Wed, 20 May 2020 13:43:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e27a2dff-f728-f69e-32b6-a83eee7effef@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Move timers and warnings out of xfs_quotainfo and into xfs_def_quota
so that we can utilize them on a per-type basis, rather than enforcing
them based on the values found in the first enabled quota type.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
[zlang: new way to get defquota in xfs_qm_init_timelimits]
[zlang: remove redundant defq assign]
Signed-off-by: Zorro Lang <zlang@redhat.com>
---

V2: Use the by-type defquota-getter

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index fdeaccc67d91..49c235c5d42c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -116,8 +116,12 @@ xfs_qm_adjust_dqtimers(
 	struct xfs_mount	*mp,
 	struct xfs_dquot	*dq)
 {
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	struct xfs_disk_dquot	*d = &dq->q_core;
+	struct xfs_def_quota	*defq;
+
 	ASSERT(d->d_id);
+	*defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
 
 #ifdef DEBUG
 	if (d->d_blk_hardlimit)
@@ -139,7 +143,7 @@ xfs_qm_adjust_dqtimers(
 		     (be64_to_cpu(d->d_bcount) >
 		      be64_to_cpu(d->d_blk_hardlimit)))) {
 			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
-					mp->m_quotainfo->qi_btimelimit);
+					defq->btimelimit);
 		} else {
 			d->d_bwarns = 0;
 		}
@@ -162,7 +166,7 @@ xfs_qm_adjust_dqtimers(
 		     (be64_to_cpu(d->d_icount) >
 		      be64_to_cpu(d->d_ino_hardlimit)))) {
 			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
-					mp->m_quotainfo->qi_itimelimit);
+					defq->itimelimit);
 		} else {
 			d->d_iwarns = 0;
 		}
@@ -185,7 +189,7 @@ xfs_qm_adjust_dqtimers(
 		     (be64_to_cpu(d->d_rtbcount) >
 		      be64_to_cpu(d->d_rtb_hardlimit)))) {
 			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
-					mp->m_quotainfo->qi_rtbtimelimit);
+					defq->rtbtimelimit);
 		} else {
 			d->d_rtbwarns = 0;
 		}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 64ba943e0675..dd38c73ce36e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -577,19 +577,22 @@ xfs_qm_set_defquota(
 static void
 xfs_qm_init_timelimits(
 	struct xfs_mount	*mp,
-	struct xfs_quotainfo	*qinf)
+	uint			type)
 {
+	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
+	struct xfs_def_quota	*defq;
 	struct xfs_disk_dquot	*ddqp;
 	struct xfs_dquot	*dqp;
-	uint			type;
 	int			error;
 
-	qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
-	qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
-	qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
-	qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
-	qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
-	qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
+	defq = xfs_get_defquota(qinf, type);
+
+	defq->btimelimit = XFS_QM_BTIMELIMIT;
+	defq->itimelimit = XFS_QM_ITIMELIMIT;
+	defq->rtbtimelimit = XFS_QM_RTBTIMELIMIT;
+	defq->bwarnlimit = XFS_QM_BWARNLIMIT;
+	defq->iwarnlimit = XFS_QM_IWARNLIMIT;
+	defq->rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
 
 	/*
 	 * We try to get the limits from the superuser's limits fields.
@@ -597,39 +600,30 @@ xfs_qm_init_timelimits(
 	 *
 	 * Since we may not have done a quotacheck by this point, just read
 	 * the dquot without attaching it to any hashtables or lists.
-	 *
-	 * Timers and warnings are globally set by the first timer found in
-	 * user/group/proj quota types, otherwise a default value is used.
-	 * This should be split into different fields per quota type.
 	 */
-	if (XFS_IS_UQUOTA_RUNNING(mp))
-		type = XFS_DQ_USER;
-	else if (XFS_IS_GQUOTA_RUNNING(mp))
-		type = XFS_DQ_GROUP;
-	else
-		type = XFS_DQ_PROJ;
 	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
 	if (error)
 		return;
 
 	ddqp = &dqp->q_core;
+
 	/*
 	 * The warnings and timers set the grace period given to
 	 * a user or group before he or she can not perform any
 	 * more writing. If it is zero, a default is used.
 	 */
 	if (ddqp->d_btimer)
-		qinf->qi_btimelimit = be32_to_cpu(ddqp->d_btimer);
+		defq->btimelimit = be32_to_cpu(ddqp->d_btimer);
 	if (ddqp->d_itimer)
-		qinf->qi_itimelimit = be32_to_cpu(ddqp->d_itimer);
+		defq->itimelimit = be32_to_cpu(ddqp->d_itimer);
 	if (ddqp->d_rtbtimer)
-		qinf->qi_rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
+		defq->rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
 	if (ddqp->d_bwarns)
-		qinf->qi_bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
+		defq->bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
 	if (ddqp->d_iwarns)
-		qinf->qi_iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
+		defq->iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
 	if (ddqp->d_rtbwarns)
-		qinf->qi_rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
+		defq->rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
 
 	xfs_qm_dqdestroy(dqp);
 }
@@ -675,7 +669,9 @@ xfs_qm_init_quotainfo(
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
-	xfs_qm_init_timelimits(mp, qinf);
+	xfs_qm_init_timelimits(mp, XFS_DQ_USER);
+	xfs_qm_init_timelimits(mp, XFS_DQ_GROUP);
+	xfs_qm_init_timelimits(mp, XFS_DQ_PROJ);
 
 	if (XFS_IS_UQUOTA_RUNNING(mp))
 		xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 06df406fdf72..c2d141715e91 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -41,7 +41,14 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
  */
 #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
 
+/* Defaults for each quota type: time limits, warn limits, usage limits */
 struct xfs_def_quota {
+	time64_t	btimelimit;	/* limit for blks timer */
+	time64_t	itimelimit;	/* limit for inodes timer */
+	time64_t	rtbtimelimit;	/* limit for rt blks timer */
+	xfs_qwarncnt_t	bwarnlimit;	/* limit for blks warnings */
+	xfs_qwarncnt_t	iwarnlimit;	/* limit for inodes warnings */
+	xfs_qwarncnt_t	rtbwarnlimit;	/* limit for rt blks warnings */
 	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
 	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
 	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
@@ -64,12 +71,6 @@ struct xfs_quotainfo {
 	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
 	struct list_lru		qi_lru;
 	int			qi_dquots;
-	time64_t		qi_btimelimit;	/* limit for blks timer */
-	time64_t		qi_itimelimit;	/* limit for inodes timer */
-	time64_t		qi_rtbtimelimit;/* limit for rt blks timer */
-	xfs_qwarncnt_t		qi_bwarnlimit;	/* limit for blks warnings */
-	xfs_qwarncnt_t		qi_iwarnlimit;	/* limit for inodes warnings */
-	xfs_qwarncnt_t		qi_rtbwarnlimit;/* limit for rt blks warnings */
 	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
 	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
 	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 13196d07c84e..4dbcc27eba23 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -563,23 +563,23 @@ xfs_qm_scall_setqlim(
 		 * for warnings.
 		 */
 		if (newlim->d_fieldmask & QC_SPC_TIMER) {
-			q->qi_btimelimit = newlim->d_spc_timer;
+			defq->btimelimit = newlim->d_spc_timer;
 			ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
 		}
 		if (newlim->d_fieldmask & QC_INO_TIMER) {
-			q->qi_itimelimit = newlim->d_ino_timer;
+			defq->itimelimit = newlim->d_ino_timer;
 			ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
 		}
 		if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
-			q->qi_rtbtimelimit = newlim->d_rt_spc_timer;
+			defq->rtbtimelimit = newlim->d_rt_spc_timer;
 			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
 		}
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
-			q->qi_bwarnlimit = newlim->d_spc_warns;
+			defq->bwarnlimit = newlim->d_spc_warns;
 		if (newlim->d_fieldmask & QC_INO_WARNS)
-			q->qi_iwarnlimit = newlim->d_ino_warns;
+			defq->iwarnlimit = newlim->d_ino_warns;
 		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-			q->qi_rtbwarnlimit = newlim->d_rt_spc_warns;
+			defq->rtbwarnlimit = newlim->d_rt_spc_warns;
 	} else {
 		/*
 		 * If the user is now over quota, start the timelimit.
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index cb16a91dd1d4..51be282d28b3 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -21,9 +21,9 @@ xfs_qm_fill_state(
 	struct qc_type_state	*tstate,
 	struct xfs_mount	*mp,
 	struct xfs_inode	*ip,
-	xfs_ino_t		ino)
+	xfs_ino_t		ino,
+	struct xfs_def_quota	*defq)
 {
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	bool			tempqip = false;
 
 	tstate->ino = ino;
@@ -37,12 +37,12 @@ xfs_qm_fill_state(
 	tstate->flags |= QCI_SYSFILE;
 	tstate->blocks = ip->i_d.di_nblocks;
 	tstate->nextents = ip->i_d.di_nextents;
-	tstate->spc_timelimit = (u32)q->qi_btimelimit;
-	tstate->ino_timelimit = (u32)q->qi_itimelimit;
-	tstate->rt_spc_timelimit = (u32)q->qi_rtbtimelimit;
-	tstate->spc_warnlimit = q->qi_bwarnlimit;
-	tstate->ino_warnlimit = q->qi_iwarnlimit;
-	tstate->rt_spc_warnlimit = q->qi_rtbwarnlimit;
+	tstate->spc_timelimit = (u32)defq->btimelimit;
+	tstate->ino_timelimit = (u32)defq->itimelimit;
+	tstate->rt_spc_timelimit = (u32)defq->rtbtimelimit;
+	tstate->spc_warnlimit = defq->bwarnlimit;
+	tstate->ino_warnlimit = defq->iwarnlimit;
+	tstate->rt_spc_warnlimit = defq->rtbwarnlimit;
 	if (tempqip)
 		xfs_irele(ip);
 }
@@ -77,11 +77,11 @@ xfs_fs_get_quota_state(
 		state->s_state[PRJQUOTA].flags |= QCI_LIMITS_ENFORCED;
 
 	xfs_qm_fill_state(&state->s_state[USRQUOTA], mp, q->qi_uquotaip,
-			  mp->m_sb.sb_uquotino);
+			  mp->m_sb.sb_uquotino, &q->qi_usr_default);
 	xfs_qm_fill_state(&state->s_state[GRPQUOTA], mp, q->qi_gquotaip,
-			  mp->m_sb.sb_gquotino);
+			  mp->m_sb.sb_gquotino, &q->qi_grp_default);
 	xfs_qm_fill_state(&state->s_state[PRJQUOTA], mp, q->qi_pquotaip,
-			  mp->m_sb.sb_pquotino);
+			  mp->m_sb.sb_pquotino, &q->qi_prj_default);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index edde366ca8e9..c0f73b82c055 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -602,7 +602,7 @@ xfs_trans_dqresv(
 			softlimit = defq->bsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_btimer);
 		warns = be16_to_cpu(dqp->q_core.d_bwarns);
-		warnlimit = dqp->q_mount->m_quotainfo->qi_bwarnlimit;
+		warnlimit = defq->bwarnlimit;
 		resbcountp = &dqp->q_res_bcount;
 	} else {
 		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
@@ -614,7 +614,7 @@ xfs_trans_dqresv(
 			softlimit = defq->rtbsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
 		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
-		warnlimit = dqp->q_mount->m_quotainfo->qi_rtbwarnlimit;
+		warnlimit = defq->rtbwarnlimit;
 		resbcountp = &dqp->q_res_rtbcount;
 	}
 
@@ -650,7 +650,7 @@ xfs_trans_dqresv(
 			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
-			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
+			warnlimit = defq->iwarnlimit;
 			hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
 			if (!hardlimit)
 				hardlimit = defq->ihardlimit;


