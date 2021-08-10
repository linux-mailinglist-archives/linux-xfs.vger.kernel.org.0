Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3103E0C42
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Aug 2021 04:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbhHECGs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Aug 2021 22:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238097AbhHECGr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:06:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D0CD61073;
        Thu,  5 Aug 2021 02:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129194;
        bh=3KlRktiOybyv+uk44kMCaAj4HwjgITM+GcNxBFdi7Jw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DQJ2c8oAwxgYi0FqE4moCaZhjLo3gYyLhXres5b7X8rZrU/iKZhV8DQEm2Yt2yZFR
         SiIvyaGhwg7f7kszccwwYxttevgk6MH7mE3EMpSCven9Zd1LeMCO4Cg8fsw++mNnDA
         Rd7kunG9ihUJLuePhRphOE5Hbh/pjaLG3Y/1vRbOpGmf6rmm0LvamT5oJ2Vu/Z32OT
         P0SWrPF3CSykGQKAkidF5doXgd/lE0f0+L0uYxnl2WJeCESYrlfNVnGZmsBKwngupO
         yDesJ1z8XkMQIE6YTAyhQqULktqLlxx2l0ut+gYZQvT3lfb/kJAMZuMEFf2aSiPGK0
         /aFVCRNZY3S7A==
Subject: [PATCH 02/14] xfs: introduce all-mounts list for cpu hotplug
 notifications
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:06:33 -0700
Message-ID: <162812919395.2589546.4025110356054038957.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The inode inactivation and CIL tracking percpu structures are
per-xfs_mount structures. That means when we get a CPU dead
notification, we need to then iterate all the per-cpu structure
instances to process them. Rather than keeping linked lists of
per-cpu structures in each subsystem, add a list of all xfs_mounts
that the generic xfs_cpu_dead() function will iterate and call into
each subsystem appropriately.

This allows us to handle both per-mount and global XFS percpu state
from xfs_cpu_dead(), and avoids the need to link subsystem
structures that can be easily found from the xfs_mount into their
own global lists.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[djwong: expand some comments about mount list setup ordering rules]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c78b63fe779a..ed7064596f94 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -82,6 +82,7 @@ typedef struct xfs_mount {
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
 	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
+	struct list_head	m_mount_list;	/* global mount list */
 	/*
 	 * Optional cache of rt summary level per bitmap block with the
 	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d47fac7c8afd..c2c9c02b9d62 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -49,6 +49,28 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
 static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #endif
 
+#ifdef CONFIG_HOTPLUG_CPU
+static LIST_HEAD(xfs_mount_list);
+static DEFINE_SPINLOCK(xfs_mount_list_lock);
+
+static inline void xfs_mount_list_add(struct xfs_mount *mp)
+{
+	spin_lock(&xfs_mount_list_lock);
+	list_add(&mp->m_mount_list, &xfs_mount_list);
+	spin_unlock(&xfs_mount_list_lock);
+}
+
+static inline void xfs_mount_list_del(struct xfs_mount *mp)
+{
+	spin_lock(&xfs_mount_list_lock);
+	list_del(&mp->m_mount_list);
+	spin_unlock(&xfs_mount_list_lock);
+}
+#else /* !CONFIG_HOTPLUG_CPU */
+static inline void xfs_mount_list_add(struct xfs_mount *mp) {}
+static inline void xfs_mount_list_del(struct xfs_mount *mp) {}
+#endif
+
 enum xfs_dax_mode {
 	XFS_DAX_INODE = 0,
 	XFS_DAX_ALWAYS = 1,
@@ -1038,6 +1060,7 @@ xfs_fs_put_super(
 
 	xfs_freesb(mp);
 	free_percpu(mp->m_stats.xs_stats);
+	xfs_mount_list_del(mp);
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
@@ -1409,6 +1432,13 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_destroy_workqueues;
 
+	/*
+	 * All percpu data structures requiring cleanup when a cpu goes offline
+	 * must be allocated before adding this @mp to the cpu-dead handler's
+	 * mount list.
+	 */
+	xfs_mount_list_add(mp);
+
 	/* Allocate stats memory before we do operations that might use it */
 	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
 	if (!mp->m_stats.xs_stats) {
@@ -1617,6 +1647,7 @@ xfs_fs_fill_super(
  out_free_stats:
 	free_percpu(mp->m_stats.xs_stats);
  out_destroy_counters:
+	xfs_mount_list_del(mp);
 	xfs_destroy_percpu_counters(mp);
  out_destroy_workqueues:
 	xfs_destroy_mount_workqueues(mp);
@@ -2116,6 +2147,15 @@ static int
 xfs_cpu_dead(
 	unsigned int		cpu)
 {
+	struct xfs_mount	*mp, *n;
+
+	spin_lock(&xfs_mount_list_lock);
+	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
+		spin_unlock(&xfs_mount_list_lock);
+		/* xfs_subsys_dead(mp, cpu); */
+		spin_lock(&xfs_mount_list_lock);
+	}
+	spin_unlock(&xfs_mount_list_lock);
 	return 0;
 }
 

