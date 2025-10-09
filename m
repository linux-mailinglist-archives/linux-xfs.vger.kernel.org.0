Return-Path: <linux-xfs+bounces-26195-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C142BC7EE4
	for <lists+linux-xfs@lfdr.de>; Thu, 09 Oct 2025 10:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0CEE44FB002
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Oct 2025 08:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0B12E1C7A;
	Thu,  9 Oct 2025 08:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnp/ZE+S"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950022D248F
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 08:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996809; cv=none; b=J6janbym7RaZqoVNd/7nPC3FRQudRzaTGuL3rJhkprxQwA6gNIVLDH86wAjGU7RYJ2r7GJ5huUmFYI88tpvAWm4RGDwy0C0CBJMbEbJehymvq2U1J+UJWHiSijbU34642xZAf1n8NiSwo6r6IUpve+aS/emHWNSxk2ZcwjXovnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996809; c=relaxed/simple;
	bh=+RBRF6meQwn3q9nzPryP2p+8250ep4XlqqidEyLjj2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHU6R4VB3o5ehyMTL2S2ujvIT3AIrpvmXT/6LvrP6nMkii9pyNujoUEw/6sGRai3rH+rAoy0n24fuDCJz8fZcXQ+edMohjZuXWmD9Y9UrMGSkFvp4CXex3otOZMFteL6rEalv3lfSZp3ZxaSOy2onvFW++PoNmJazmJBF6CoeNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fnp/ZE+S; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b48d8deafaeso139714066b.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 01:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996804; x=1760601604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtNZzXzCxxpF7eJNzzGGCepg+EzDGtZJGp4a5sIIOtw=;
        b=fnp/ZE+SnFGGqdYjPEXfYpM67VICjbU02VFp7wjSOOatBehRt/dBhsNMOHO/6nwVB3
         jnkwlcziHlgHkK+PG9v4A7K6/v71B1HLzZsRdjyCgik+sJjW2Z4oXjgZnzu2mSWH649Z
         ok9IUTJdev1mL0m0ApggQrjrtN9Q+Ovi1n6hlLE6mzYX6MbK+6jmx84UkuJKT/vIT7iv
         nRVPcGAX2ADZuFB3rYRyQwdEw+ZkvvPLvd3/n7bH/wM6y39oc7ln4cYHS3Tx1kaSYZbS
         cO2kIpTowdX+8+e5lqNGIu/Y75FfzPi8hqZ/Wj+ImxxFdrf/Vg9xCWOEs2BjNuvIHvp/
         wh6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996804; x=1760601604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtNZzXzCxxpF7eJNzzGGCepg+EzDGtZJGp4a5sIIOtw=;
        b=P7P/9/tulbJz3zNIm2A/NDSWL8kXMvatclxaP8jaVPOxUktULVfhOMickq0n0i+2Yp
         EdCoLtLiEzWCUs9w41UgxSl7boHlgR/OEAJ9d12SksrYllWEv/pDA8UHj8TDYDoSreaV
         RroBw06/7x5qvnYQ+jHHk1886zinAIp8zWL3fGr/9Qg0ekLlUGdyhf9Ffc2FYcKFuoOT
         dKYwyYrsypofsB2HgGV+K20hUVS33xE1KVogjsfoRhG/eRD1lxEsMLBoQkB0DyW9prns
         Q3KJ5kTWdrPhlgKnYEs83eAHDrzXhgn409HnbopNpULSXHmu8ZHRKFMjHyJr5m2sknkb
         xIHw==
X-Forwarded-Encrypted: i=1; AJvYcCWk5gcfyRUEqaIcbvRFdTksSkfQ4ZBAlXblvVSbUC+RTgT5FRAn4cwnBa3EF1AKrEgL68i0V7RqCWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPeQcArPW58GsG8EnahniH/u0fOgKGriiSkngbXpUrZ3OqOrAf
	+GnJSTMsRk+cbAC2cOM8cSgE/Zp+fQQwV0ceF0L+kzewQH18QC9V71Eb
X-Gm-Gg: ASbGnctipMVT2CcD85wotofLYnvSXZ8D/pARwxKOXXVR2IqpplM+BEnv2rOAM3IOinT
	+XwXeK90gM2/CNqzDIU+uPUvm3y3aWBsBkFLgIvZvVPWch0p2b+slY6HQ+Z+Eq9x/rmgCY7rd2U
	kvSNYWCvnGeHkGgU4TuPskHQCxR3ck+tveyX7yss4ZBZNAE45cNe7mTKsNrc2vwYSosSNaNV1ok
	VYnkwRN2ntdn2Z7scErFYrUpw9G11g7WIYSUxu/NcnGFWUTubxIXyUqWK4zIZX67kBgVNJRdZjo
	4rdAi+OC2r3S2pWdy/5Q02WFCz7fkaX9evObADLkEN7igFQhXMRhcutZg4qS8VfTCYQAox/Xthy
	cMODuwg7xwyOrhT8D4QceAxX/E8ht2z/ULH62iAB0lwv1hhA7XqyUCgK681wAV1EL2o1xW51cLA
	jRomdewhccj+4JnKkqRUwMTP3zklQQYj6zahs11yU4ogQ=
X-Google-Smtp-Source: AGHT+IEouxbTI3/2qFJGFL8V5mVY3HAotK98uqu1QC3hyrh6oGwfceS36G8V1F2YUkpXySTgyqtUfg==
X-Received: by 2002:a17:907:2d8a:b0:b3e:e16a:8cf2 with SMTP id a640c23a62f3a-b50aca0b087mr678905866b.56.1759996803728;
        Thu, 09 Oct 2025 01:00:03 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.01.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 01:00:03 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v7 13/14] xfs: use the new ->i_state accessors
Date: Thu,  9 Oct 2025 09:59:27 +0200
Message-ID: <20251009075929.1203950-14-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009075929.1203950-1-mjguzik@gmail.com>
References: <20251009075929.1203950-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change generated with coccinelle and fixed up by hand as appropriate.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

cheat sheet:

If ->i_lock is held, then:

state = inode->i_state          => state = inode_state_read(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally:

state = inode->i_state          => state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign_raw(inode, I_A | I_B)

 fs/xfs/scrub/common.c       | 2 +-
 fs/xfs/scrub/inode_repair.c | 2 +-
 fs/xfs/scrub/parent.c       | 2 +-
 fs/xfs/xfs_bmap_util.c      | 2 +-
 fs/xfs/xfs_health.c         | 4 ++--
 fs/xfs/xfs_icache.c         | 6 +++---
 fs/xfs/xfs_inode.c          | 6 +++---
 fs/xfs/xfs_inode_item.c     | 4 ++--
 fs/xfs/xfs_iops.c           | 2 +-
 fs/xfs/xfs_reflink.h        | 2 +-
 10 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 2ef7742be7d3..7bfa37c99480 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1249,7 +1249,7 @@ xchk_irele(
 		 * hits do not clear DONTCACHE, so we must do it here.
 		 */
 		spin_lock(&VFS_I(ip)->i_lock);
-		VFS_I(ip)->i_state &= ~I_DONTCACHE;
+		inode_state_clear(VFS_I(ip), I_DONTCACHE);
 		spin_unlock(&VFS_I(ip)->i_lock);
 	}
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a90a011c7e5f..4f7040c9ddf0 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1933,7 +1933,7 @@ xrep_inode_pptr(
 	 * Unlinked inodes that cannot be added to the directory tree will not
 	 * have a parent pointer.
 	 */
-	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
+	if (inode->i_nlink == 0 && !(inode_state_read_once(inode) & I_LINKABLE))
 		return 0;
 
 	/* Children of the superblock do not have parent pointers. */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 3b692c4acc1e..11d5de10fd56 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -915,7 +915,7 @@ xchk_pptr_looks_zapped(
 	 * Temporary files that cannot be linked into the directory tree do not
 	 * have attr forks because they cannot ever have parents.
 	 */
-	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
+	if (inode->i_nlink == 0 && !(inode_state_read_once(inode) & I_LINKABLE))
 		return false;
 
 	/*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e43..2208a720ec3f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -514,7 +514,7 @@ xfs_can_free_eofblocks(
 	 * Caller must either hold the exclusive io lock; or be inactivating
 	 * the inode, which guarantees there are no other users of the inode.
 	 */
-	if (!(VFS_I(ip)->i_state & I_FREEING))
+	if (!(inode_state_read_once(VFS_I(ip)) & I_FREEING))
 		xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
 
 	/* prealloc/delalloc exists only on regular files */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 7c541fb373d5..3c1557fb1cf0 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -285,7 +285,7 @@ xfs_inode_mark_sick(
 	 * is not the case here.
 	 */
 	spin_lock(&VFS_I(ip)->i_lock);
-	VFS_I(ip)->i_state &= ~I_DONTCACHE;
+	inode_state_clear(VFS_I(ip), I_DONTCACHE);
 	spin_unlock(&VFS_I(ip)->i_lock);
 }
 
@@ -309,7 +309,7 @@ xfs_inode_mark_corrupt(
 	 * is not the case here.
 	 */
 	spin_lock(&VFS_I(ip)->i_lock);
-	VFS_I(ip)->i_state &= ~I_DONTCACHE;
+	inode_state_clear(VFS_I(ip), I_DONTCACHE);
 	spin_unlock(&VFS_I(ip)->i_lock);
 }
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e44040206851..f3fc4d21bfe1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -334,7 +334,7 @@ xfs_reinit_inode(
 	dev_t			dev = inode->i_rdev;
 	kuid_t			uid = inode->i_uid;
 	kgid_t			gid = inode->i_gid;
-	unsigned long		state = inode->i_state;
+	unsigned long		state = inode_state_read_once(inode);
 
 	error = inode_init_always(mp->m_super, inode);
 
@@ -345,7 +345,7 @@ xfs_reinit_inode(
 	inode->i_rdev = dev;
 	inode->i_uid = uid;
 	inode->i_gid = gid;
-	inode->i_state = state;
+	inode_state_assign_raw(inode, state);
 	mapping_set_folio_min_order(inode->i_mapping,
 				    M_IGEO(mp)->min_folio_order);
 	return error;
@@ -411,7 +411,7 @@ xfs_iget_recycle(
 	ip->i_flags |= XFS_INEW;
 	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
 			XFS_ICI_RECLAIM_TAG);
-	inode->i_state = I_NEW;
+	inode_state_assign_raw(inode, I_NEW);
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 36b39539e561..f1f88e48fe22 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1580,7 +1580,7 @@ xfs_iunlink_reload_next(
 	next_ip->i_prev_unlinked = prev_agino;
 	trace_xfs_iunlink_reload_next(next_ip);
 rele:
-	ASSERT(!(VFS_I(next_ip)->i_state & I_DONTCACHE));
+	ASSERT(!(inode_state_read_once(VFS_I(next_ip)) & I_DONTCACHE));
 	if (xfs_is_quotacheck_running(mp) && next_ip)
 		xfs_iflags_set(next_ip, XFS_IQUOTAUNCHECKED);
 	xfs_irele(next_ip);
@@ -2111,7 +2111,7 @@ xfs_rename_alloc_whiteout(
 	 */
 	xfs_setup_iops(tmpfile);
 	xfs_finish_inode_setup(tmpfile);
-	VFS_I(tmpfile)->i_state |= I_LINKABLE;
+	inode_state_set_raw(VFS_I(tmpfile), I_LINKABLE);
 
 	*wip = tmpfile;
 	return 0;
@@ -2330,7 +2330,7 @@ xfs_rename(
 		 * flag from the inode so it doesn't accidentally get misused in
 		 * future.
 		 */
-		VFS_I(du_wip.ip)->i_state &= ~I_LINKABLE;
+		inode_state_clear_raw(VFS_I(du_wip.ip), I_LINKABLE);
 	}
 
 out_commit:
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 1bd411a1114c..2eb0c6011a2e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -113,9 +113,9 @@ xfs_inode_item_precommit(
 	 * to log the timestamps, or will clear already cleared fields in the
 	 * worst case.
 	 */
-	if (inode->i_state & I_DIRTY_TIME) {
+	if (inode_state_read_once(inode) & I_DIRTY_TIME) {
 		spin_lock(&inode->i_lock);
-		inode->i_state &= ~I_DIRTY_TIME;
+		inode_state_clear(inode, I_DIRTY_TIME);
 		spin_unlock(&inode->i_lock);
 	}
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index caff0125faea..ad94fbf55014 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1420,7 +1420,7 @@ xfs_setup_inode(
 	bool			is_meta = xfs_is_internal_inode(ip);
 
 	inode->i_ino = ip->i_ino;
-	inode->i_state |= I_NEW;
+	inode_state_set_raw(inode, I_NEW);
 
 	inode_sb_list_add(inode);
 	/* make the inode look hashed for the writeback code */
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 36cda724da89..9d1ed9bb0bee 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -17,7 +17,7 @@ xfs_can_free_cowblocks(struct xfs_inode *ip)
 {
 	struct inode *inode = VFS_I(ip);
 
-	if ((inode->i_state & I_DIRTY_PAGES) ||
+	if ((inode_state_read_once(inode) & I_DIRTY_PAGES) ||
 	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
 	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
 	    atomic_read(&inode->i_dio_count))
-- 
2.34.1


