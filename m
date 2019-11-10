Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692FDF67C3
	for <lists+linux-xfs@lfdr.de>; Sun, 10 Nov 2019 07:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfKJGYX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 Nov 2019 01:24:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23449 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726612AbfKJGYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 01:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573367060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtKxNtIlHB3FOPlHcouish3yhP03u75QcpqU6UDRQtg=;
        b=Ye2sqcwGkLKaEwbGk1Wmp958S02k05MYM9UsrxL4fO1NWZGbo1z6ruct36ofRvMRxdb+e4
        p9PhY8XGesTHV7pG7NIaYD9bctjB5AsoiXVDS8/Qm240v0rZwjxqVeVIR+8oXhL0363/QY
        RxQqJ2LIivqvLpRkHIO/7pEuaqND51E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-biPyBUZ-OvOrkFB07obKPg-1; Sun, 10 Nov 2019 01:24:19 -0500
Received: by mail-wr1-f69.google.com with SMTP id l3so7251347wrx.21
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 22:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2pU3LokNQUVZlenU43REAB/raosA3JG7ggOBcQVWo0=;
        b=IdzIAtKwXEdHC5pLLlekaq8/hsf1vlL8CVtVfdRumZnO1aSuofgW6isYPRG8eWL2zn
         QVCokqcA2UmceswdDuc0GLCMxc20eNQI0huLPwk2LjLTOe6w5q4/zX8JumOuSsOSMfM/
         j3YUPS2yY8vUKNgZfCWfVWw0gantlfFouO3QoG4SxgWEOO9h4XwGgQvRSL6bflRVrici
         9rzSKYHK06qJ5NXfUb8XdvmxdWIJgmMK1hm2uujqhRuEz8H2Yd6xTauqmCIdcbH/xNgY
         c6U/cg9llsBvN8Z+3A4WjMwxvVpIAt8q3jC6HXSjjy0P6aEapK+BaI1JME913x0uTuhx
         ViFw==
X-Gm-Message-State: APjAAAVfljvimf3/6kxQhG6RzHUxAQZSnIJGfn/TEcsEBCpxlXVW5xg0
        2hCuHVnBKNXNjoHny1Jr2/aKIbWsHAe1nUJINVDncLjuhQcdEOY+45HvIlKQpjRYl+Ym7wGBMCi
        eSCpt/OVB9Ezv4JcFgXah
X-Received: by 2002:a7b:cf36:: with SMTP id m22mr15709038wmg.96.1573367058006;
        Sat, 09 Nov 2019 22:24:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqx9MtyIVWzL9yLh26VW54vkcA8VxYN+sc+AwoOoXLiUMUZncY63xWjtnbBhzt0YauWvM+yrBw==
X-Received: by 2002:a7b:cf36:: with SMTP id m22mr15709012wmg.96.1573367057495;
        Sat, 09 Nov 2019 22:24:17 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id b196sm16261618wmd.24.2019.11.09.22.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 22:24:16 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v3 1/4] xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
Date:   Sun, 10 Nov 2019 07:24:01 +0100
Message-Id: <20191110062404.948433-2-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191110062404.948433-1-preichl@redhat.com>
References: <20191110062404.948433-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: biPyBUZ-OvOrkFB07obKPg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |   8 +--
 fs/xfs/libxfs/xfs_format.h     |  10 +--
 fs/xfs/libxfs/xfs_trans_resv.c |   1 -
 fs/xfs/xfs_dquot.c             |  18 +++---
 fs/xfs/xfs_dquot.h             | 111 +++++++++++++++++++--------------
 fs/xfs/xfs_log_recover.c       |   5 +-
 fs/xfs/xfs_qm.c                |  30 ++++-----
 fs/xfs/xfs_qm_bhv.c            |   6 +-
 fs/xfs/xfs_trans_dquot.c       |  42 ++++++-------
 9 files changed, 124 insertions(+), 107 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index e8bd688a4073..bedc1e752b60 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -35,10 +35,10 @@ xfs_calc_dquots_per_chunk(
=20
 xfs_failaddr_t
 xfs_dquot_verify(
-=09struct xfs_mount *mp,
-=09xfs_disk_dquot_t *ddq,
-=09xfs_dqid_t=09 id,
-=09uint=09=09 type)=09  /* used only during quotacheck */
+=09struct xfs_mount=09*mp,
+=09struct xfs_disk_dquot=09*ddq,
+=09xfs_dqid_t=09=09id,
+=09uint=09=09=09type)=09/* used only during quotacheck */
 {
 =09/*
 =09 * We can encounter an uninitialized dquot buffer for 2 reasons:
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c968b60cee15..4cae17f35e94 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1144,11 +1144,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_d=
inode *dip, xfs_dev_t rdev)
=20
 /*
  * This is the main portion of the on-disk representation of quota
- * information for a user. This is the q_core of the xfs_dquot_t that
+ * information for a user. This is the q_core of the struct xfs_dquot that
  * is kept in kernel memory. We pad this with some more expansion room
  * to construct the on disk structure.
  */
-typedef struct=09xfs_disk_dquot {
+struct xfs_disk_dquot {
 =09__be16=09=09d_magic;=09/* dquot magic =3D XFS_DQUOT_MAGIC */
 =09__u8=09=09d_version;=09/* dquot version */
 =09__u8=09=09d_flags;=09/* XFS_DQ_USER/PROJ/GROUP */
@@ -1171,15 +1171,15 @@ typedef struct=09xfs_disk_dquot {
 =09__be32=09=09d_rtbtimer;=09/* similar to above; for RT disk blocks */
 =09__be16=09=09d_rtbwarns;=09/* warnings issued wrt RT disk blocks */
 =09__be16=09=09d_pad;
-} xfs_disk_dquot_t;
+};
=20
 /*
  * This is what goes on disk. This is separated from the xfs_disk_dquot be=
cause
  * carrying the unnecessary padding would be a waste of memory.
  */
 typedef struct xfs_dqblk {
-=09xfs_disk_dquot_t  dd_diskdq;=09/* portion that lives incore as well */
-=09char=09=09  dd_fill[4];=09/* filling for posterity */
+=09struct xfs_disk_dquot=09dd_diskdq; /* portion living incore as well */
+=09char=09=09=09dd_fill[4];/* filling for posterity */
=20
 =09/*
 =09 * These two are only present on filesystems with the CRC bits set.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.=
c
index d12bbd526e7c..271cca13565b 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -718,7 +718,6 @@ xfs_calc_clear_agi_bucket_reservation(
=20
 /*
  * Adjusting quota limits.
- *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
  */
 STATIC uint
 xfs_calc_qm_setqlim_reservation(void)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bcd4247b5014..5b089afd7087 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -48,7 +48,7 @@ static struct lock_class_key xfs_dquot_project_class;
  */
 void
 xfs_qm_dqdestroy(
-=09xfs_dquot_t=09*dqp)
+=09struct xfs_dquot=09*dqp)
 {
 =09ASSERT(list_empty(&dqp->q_lru));
=20
@@ -113,8 +113,8 @@ xfs_qm_adjust_dqlimits(
  */
 void
 xfs_qm_adjust_dqtimers(
-=09xfs_mount_t=09=09*mp,
-=09xfs_disk_dquot_t=09*d)
+=09struct xfs_mount=09*mp,
+=09struct xfs_disk_dquot=09*d)
 {
 =09ASSERT(d->d_id);
=20
@@ -497,7 +497,7 @@ xfs_dquot_from_disk(
 =09struct xfs_disk_dquot=09*ddqp =3D bp->b_addr + dqp->q_bufoffset;
=20
 =09/* copy everything from disk dquot to the incore dquot */
-=09memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
+=09memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
=20
 =09/*
 =09 * Reservation counters are defined as reservation plus current usage
@@ -989,7 +989,7 @@ xfs_qm_dqput(
  */
 void
 xfs_qm_dqrele(
-=09xfs_dquot_t=09*dqp)
+=09struct xfs_dquot=09*dqp)
 {
 =09if (!dqp)
 =09=09return;
@@ -1019,7 +1019,7 @@ xfs_qm_dqflush_done(
 =09struct xfs_log_item=09*lip)
 {
 =09xfs_dq_logitem_t=09*qip =3D (struct xfs_dq_logitem *)lip;
-=09xfs_dquot_t=09=09*dqp =3D qip->qli_dquot;
+=09struct xfs_dquot=09*dqp =3D qip->qli_dquot;
 =09struct xfs_ail=09=09*ailp =3D lip->li_ailp;
=20
 =09/*
@@ -1130,7 +1130,7 @@ xfs_qm_dqflush(
 =09}
=20
 =09/* This is the only portion of data that needs to persist */
-=09memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
+=09memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
=20
 =09/*
 =09 * Clear the dirty field and remember the flush lsn for later use.
@@ -1188,8 +1188,8 @@ xfs_qm_dqflush(
  */
 void
 xfs_dqlock2(
-=09xfs_dquot_t=09*d1,
-=09xfs_dquot_t=09*d2)
+=09struct xfs_dquot=09*d1,
+=09struct xfs_dquot=09*d2)
 {
 =09if (d1 && d2) {
 =09=09ASSERT(d1 !=3D d2);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 4fe85709d55d..f1614d7c72f8 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -30,33 +30,51 @@ enum {
 /*
  * The incore dquot structure
  */
-typedef struct xfs_dquot {
-=09uint=09=09 dq_flags;=09/* various flags (XFS_DQ_*) */
-=09struct list_head q_lru;=09=09/* global free list of dquots */
-=09struct xfs_mount*q_mount;=09/* filesystem this relates to */
-=09uint=09=09 q_nrefs;=09/* # active refs from inodes */
-=09xfs_daddr_t=09 q_blkno;=09/* blkno of dquot buffer */
-=09int=09=09 q_bufoffset;=09/* off of dq in buffer (# dquots) */
-=09xfs_fileoff_t=09 q_fileoffset;=09/* offset in quotas file */
-
-=09xfs_disk_dquot_t q_core;=09/* actual usage & quotas */
-=09xfs_dq_logitem_t q_logitem;=09/* dquot log item */
-=09xfs_qcnt_t=09 q_res_bcount;=09/* total regular nblks used+reserved */
-=09xfs_qcnt_t=09 q_res_icount;=09/* total inos allocd+reserved */
-=09xfs_qcnt_t=09 q_res_rtbcount;/* total realtime blks used+reserved */
-=09xfs_qcnt_t=09 q_prealloc_lo_wmark;/* prealloc throttle wmark */
-=09xfs_qcnt_t=09 q_prealloc_hi_wmark;/* prealloc disabled wmark */
-=09int64_t=09=09 q_low_space[XFS_QLOWSP_MAX];
-=09struct mutex=09 q_qlock;=09/* quota lock */
-=09struct completion q_flush;=09/* flush completion queue */
-=09atomic_t          q_pincount;=09/* dquot pin count */
-=09wait_queue_head_t q_pinwait;=09/* dquot pinning wait queue */
-} xfs_dquot_t;
+struct xfs_dquot {
+=09/* various flags (XFS_DQ_*) */
+=09uint=09=09=09dq_flags;
+=09/* global free list of dquots */
+=09struct list_head=09q_lru;
+=09/* filesystem this relates to */
+=09struct xfs_mount=09*q_mount;
+=09/* # active refs from inodes */
+=09uint=09=09=09q_nrefs;
+=09/* blkno of dquot buffer */
+=09xfs_daddr_t=09=09q_blkno;
+=09/* off of dq in buffer (# dquots) */
+=09int=09=09=09q_bufoffset;
+=09/* offset in quotas file */
+=09xfs_fileoff_t=09=09q_fileoffset;
+
+=09/* actual usage & quotas */
+=09struct xfs_disk_dquot=09q_core;
+=09/* dquot log item */
+=09xfs_dq_logitem_t=09q_logitem;
+=09/* total regular nblks used+reserved */
+=09xfs_qcnt_t=09=09q_res_bcount;
+=09/* total inos allocd+reserved */
+=09xfs_qcnt_t=09=09q_res_icount;
+=09/* total realtime blks used+reserved */
+=09xfs_qcnt_t=09=09q_res_rtbcount;
+=09/* prealloc throttle wmark */
+=09xfs_qcnt_t=09=09q_prealloc_lo_wmark;
+=09/* prealloc disabled wmark */
+=09xfs_qcnt_t=09=09q_prealloc_hi_wmark;
+=09int64_t=09=09=09q_low_space[XFS_QLOWSP_MAX];
+=09/* quota lock */
+=09struct mutex=09=09q_qlock;
+=09/* flush completion queue */
+=09struct completion=09q_flush;
+=09/* dquot pin count */
+=09atomic_t=09=09q_pincount;
+=09/* dquot pinning wait queue */
+=09struct wait_queue_head=09q_pinwait;
+};
=20
 /*
  * Lock hierarchy for q_qlock:
  *=09XFS_QLOCK_NORMAL is the implicit default,
- * =09XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
+ *=09XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
  */
 enum {
 =09XFS_QLOCK_NORMAL =3D 0,
@@ -68,17 +86,17 @@ enum {
  * queue synchronizes processes attempting to flush the in-core dquot back=
 to
  * disk.
  */
-static inline void xfs_dqflock(xfs_dquot_t *dqp)
+static inline void xfs_dqflock(struct xfs_dquot *dqp)
 {
 =09wait_for_completion(&dqp->q_flush);
 }
=20
-static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
+static inline bool xfs_dqflock_nowait(struct xfs_dquot *dqp)
 {
 =09return try_wait_for_completion(&dqp->q_flush);
 }
=20
-static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
+static inline void xfs_dqfunlock(struct xfs_dquot *dqp)
 {
 =09complete(&dqp->q_flush);
 }
@@ -112,7 +130,7 @@ static inline int xfs_this_quota_on(struct xfs_mount *m=
p, int type)
 =09}
 }
=20
-static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
+static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int =
type)
 {
 =09switch (type & XFS_DQ_ALLTYPES) {
 =09case XFS_DQ_USER:
@@ -147,31 +165,30 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *=
dqp)
 #define XFS_QM_ISPDQ(dqp)=09((dqp)->dq_flags & XFS_DQ_PROJ)
 #define XFS_QM_ISGDQ(dqp)=09((dqp)->dq_flags & XFS_DQ_GROUP)
=20
-extern void=09=09xfs_qm_dqdestroy(xfs_dquot_t *);
-extern int=09=09xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
-extern void=09=09xfs_qm_dqunpin_wait(xfs_dquot_t *);
-extern void=09=09xfs_qm_adjust_dqtimers(xfs_mount_t *,
-=09=09=09=09=09xfs_disk_dquot_t *);
-extern void=09=09xfs_qm_adjust_dqlimits(struct xfs_mount *,
-=09=09=09=09=09       struct xfs_dquot *);
-extern xfs_dqid_t=09xfs_qm_id_for_quotatype(struct xfs_inode *ip,
-=09=09=09=09=09uint type);
-extern int=09=09xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
+void=09=09xfs_qm_dqdestroy(struct xfs_dquot *dqp);
+int=09=09xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
+void=09=09xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
+void=09=09xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
+=09=09=09=09=09=09struct xfs_disk_dquot *d);
+void=09=09xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
+=09=09=09=09=09=09struct xfs_dquot *d);
+xfs_dqid_t=09xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
+int=09=09xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
 =09=09=09=09=09uint type, bool can_alloc,
 =09=09=09=09=09struct xfs_dquot **dqpp);
-extern int=09=09xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
-=09=09=09=09=09bool can_alloc,
-=09=09=09=09=09struct xfs_dquot **dqpp);
-extern int=09=09xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
+int=09=09xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
+=09=09=09=09=09=09bool can_alloc,
+=09=09=09=09=09=09struct xfs_dquot **dqpp);
+int=09=09xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 =09=09=09=09=09uint type, struct xfs_dquot **dqpp);
-extern int=09=09xfs_qm_dqget_uncached(struct xfs_mount *mp,
-=09=09=09=09=09xfs_dqid_t id, uint type,
-=09=09=09=09=09struct xfs_dquot **dqpp);
-extern void=09=09xfs_qm_dqput(xfs_dquot_t *);
+int=09=09xfs_qm_dqget_uncached(struct xfs_mount *mp,
+=09=09=09=09=09=09xfs_dqid_t id, uint type,
+=09=09=09=09=09=09struct xfs_dquot **dqpp);
+void=09=09xfs_qm_dqput(struct xfs_dquot *dqp);
=20
-extern void=09=09xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void=09=09xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
=20
-extern void=09=09xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
+void=09=09xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
=20
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 648d5ecafd91..16a44e821b71 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2576,6 +2576,7 @@ xlog_recover_do_reg_buffer(
 =09int=09=09=09bit;
 =09int=09=09=09nbits;
 =09xfs_failaddr_t=09=09fa;
+=09const size_t=09=09size_disk_dquot =3D sizeof(struct xfs_disk_dquot);
=20
 =09trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
=20
@@ -2618,7 +2619,7 @@ xlog_recover_do_reg_buffer(
 =09=09=09=09=09"XFS: NULL dquot in %s.", __func__);
 =09=09=09=09goto next;
 =09=09=09}
-=09=09=09if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
+=09=09=09if (item->ri_buf[i].i_len < size_disk_dquot) {
 =09=09=09=09xfs_alert(mp,
 =09=09=09=09=09"XFS: dquot too small (%d) in %s.",
 =09=09=09=09=09item->ri_buf[i].i_len, __func__);
@@ -3249,7 +3250,7 @@ xlog_recover_dquot_pass2(
 =09=09xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 =09=09return -EIO;
 =09}
-=09if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
+=09if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
 =09=09xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 =09=09=09item->ri_buf[1].i_len, __func__);
 =09=09return -EIO;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 66ea8e4fca86..035930a4f0dd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -244,14 +244,14 @@ xfs_qm_unmount_quotas(
=20
 STATIC int
 xfs_qm_dqattach_one(
-=09xfs_inode_t=09*ip,
-=09xfs_dqid_t=09id,
-=09uint=09=09type,
-=09bool=09=09doalloc,
-=09xfs_dquot_t=09**IO_idqpp)
+=09struct xfs_inode=09*ip,
+=09xfs_dqid_t=09=09id,
+=09uint=09=09=09type,
+=09bool=09=09=09doalloc,
+=09struct xfs_dquot=09**IO_idqpp)
 {
-=09xfs_dquot_t=09*dqp;
-=09int=09=09error;
+=09struct xfs_dquot=09*dqp;
+=09int=09=09=09error;
=20
 =09ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 =09error =3D 0;
@@ -544,8 +544,8 @@ xfs_qm_set_defquota(
 =09uint=09=09type,
 =09xfs_quotainfo_t=09*qinf)
 {
-=09xfs_dquot_t=09=09*dqp;
-=09struct xfs_def_quota    *defq;
+=09struct xfs_dquot=09*dqp;
+=09struct xfs_def_quota=09*defq;
 =09struct xfs_disk_dquot=09*ddqp;
 =09int=09=09=09error;
=20
@@ -1746,14 +1746,14 @@ xfs_qm_vop_dqalloc(
  * Actually transfer ownership, and do dquot modifications.
  * These were already reserved.
  */
-xfs_dquot_t *
+struct xfs_dquot *
 xfs_qm_vop_chown(
-=09xfs_trans_t=09*tp,
-=09xfs_inode_t=09*ip,
-=09xfs_dquot_t=09**IO_olddq,
-=09xfs_dquot_t=09*newdq)
+=09struct xfs_trans=09*tp,
+=09struct xfs_inode=09*ip,
+=09struct xfs_dquot=09**IO_olddq,
+=09struct xfs_dquot=09*newdq)
 {
-=09xfs_dquot_t=09*prevdq;
+=09struct xfs_dquot=09*prevdq;
 =09uint=09=09bfield =3D XFS_IS_REALTIME_INODE(ip) ?
 =09=09=09=09 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
=20
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 5d72e88598b4..b784a3751fe2 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -54,11 +54,11 @@ xfs_fill_statvfs_from_dquot(
  */
 void
 xfs_qm_statvfs(
-=09xfs_inode_t=09=09*ip,
+=09struct xfs_inode=09*ip,
 =09struct kstatfs=09=09*statp)
 {
-=09xfs_mount_t=09=09*mp =3D ip->i_mount;
-=09xfs_dquot_t=09=09*dqp;
+=09struct xfs_mount=09*mp =3D ip->i_mount;
+=09struct xfs_dquot=09*dqp;
=20
 =09if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
 =09=09xfs_fill_statvfs_from_dquot(statp, dqp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 16457465833b..0b7f6f228662 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -25,8 +25,8 @@ STATIC void=09xfs_trans_alloc_dqinfo(xfs_trans_t *);
  */
 void
 xfs_trans_dqjoin(
-=09xfs_trans_t=09*tp,
-=09xfs_dquot_t=09*dqp)
+=09struct xfs_trans=09*tp,
+=09struct xfs_dquot=09*dqp)
 {
 =09ASSERT(XFS_DQ_IS_LOCKED(dqp));
 =09ASSERT(dqp->q_logitem.qli_dquot =3D=3D dqp);
@@ -49,8 +49,8 @@ xfs_trans_dqjoin(
  */
 void
 xfs_trans_log_dquot(
-=09xfs_trans_t=09*tp,
-=09xfs_dquot_t=09*dqp)
+=09struct xfs_trans=09*tp,
+=09struct xfs_dquot=09*dqp)
 {
 =09ASSERT(XFS_DQ_IS_LOCKED(dqp));
=20
@@ -486,12 +486,12 @@ xfs_trans_apply_dquot_deltas(
  */
 void
 xfs_trans_unreserve_and_mod_dquots(
-=09xfs_trans_t=09=09*tp)
+=09struct xfs_trans=09*tp)
 {
 =09int=09=09=09i, j;
-=09xfs_dquot_t=09=09*dqp;
+=09struct xfs_dquot=09*dqp;
 =09struct xfs_dqtrx=09*qtrx, *qa;
-=09bool                    locked;
+=09bool=09=09=09locked;
=20
 =09if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
 =09=09return;
@@ -571,21 +571,21 @@ xfs_quota_warn(
  */
 STATIC int
 xfs_trans_dqresv(
-=09xfs_trans_t=09*tp,
-=09xfs_mount_t=09*mp,
-=09xfs_dquot_t=09*dqp,
-=09int64_t=09=09nblks,
-=09long=09=09ninos,
-=09uint=09=09flags)
+=09struct xfs_trans=09*tp,
+=09struct xfs_mount=09*mp,
+=09struct xfs_dquot=09*dqp,
+=09int64_t=09=09=09nblks,
+=09long=09=09=09ninos,
+=09uint=09=09=09flags)
 {
-=09xfs_qcnt_t=09hardlimit;
-=09xfs_qcnt_t=09softlimit;
-=09time_t=09=09timer;
-=09xfs_qwarncnt_t=09warns;
-=09xfs_qwarncnt_t=09warnlimit;
-=09xfs_qcnt_t=09total_count;
-=09xfs_qcnt_t=09*resbcountp;
-=09xfs_quotainfo_t=09*q =3D mp->m_quotainfo;
+=09xfs_qcnt_t=09=09hardlimit;
+=09xfs_qcnt_t=09=09softlimit;
+=09time_t=09=09=09timer;
+=09xfs_qwarncnt_t=09=09warns;
+=09xfs_qwarncnt_t=09=09warnlimit;
+=09xfs_qcnt_t=09=09total_count;
+=09xfs_qcnt_t=09=09*resbcountp;
+=09xfs_quotainfo_t=09=09*q =3D mp->m_quotainfo;
 =09struct xfs_def_quota=09*defq;
=20
=20
--=20
2.23.0

