Return-Path: <linux-xfs+bounces-31157-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kEpUEmGyl2mb6QIAu9opvQ
	(envelope-from <linux-xfs+bounces-31157-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 02:01:21 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE121640D9
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 02:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2105C300398F
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 01:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C8D2AD3D;
	Fri, 20 Feb 2026 01:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDigQCNa"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EDA2AD2C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 01:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771549279; cv=none; b=DRTDM6GiqZq2yegnwdNPQOp1gMoxjBc8XwFETgJkWK9YRi7oDI5PkVJCLktdCAZiIozWNvUJcFTi7L7lI7POa0tTrJv9T3c529yXoU6C4dCEWqMufkrnYMNA30G7mAgg8eVXRd5MjJ1iwYH6idKo5wMkx9yq882WtUuhB3R8/jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771549279; c=relaxed/simple;
	bh=XhZujguExUNM9gAqHLz5xzLODwj2T+3Ysh/caoqXsuU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uRdBap0YquKlmXXtV3Cac0cH/PGxyejEtCvN8urr2h6J7lrPPMhRr58XBw10DkrQCHg7/+qPk/Pnge0GOrOklJkGA4LBbRj37opVvdNN/frSj3bLnKQl7cmZvGeyLbG/g2cp6jNu+XlANpzR+w5JRKpf4zvGiJtA3Gc7m2Hf6fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDigQCNa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A755C4CEF7;
	Fri, 20 Feb 2026 01:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771549278;
	bh=XhZujguExUNM9gAqHLz5xzLODwj2T+3Ysh/caoqXsuU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lDigQCNanGOm6JBkAVcaPlAgVkaOTliohorNv+cN4e/GHvTrLLaCmnwZ4F88+UJ+g
	 csAv6XlzZgylX01Zw6sBk99bWruhOeaoSp7WnCwSGk6qqOfiHi93jryPOTweyaPHqI
	 kwB3p0pQLQ9dthCTBV970f6QXAoIKRLNKsW0sag7AvnlnLGm/TWjLfR0xzo8U+ZwhO
	 KXiaUIuz/xNLUPNwS9s9roD6akh727/N2zZ8A22pDzyvt7T6VBXGUzfy36FIM0i9oh
	 YrafBMw9B1+H6KOFd36twn7Wlpk459197evxvfYj+yG1t9BoulQGgf/X4xjvhu1seT
	 X4uewVVgA3Q9g==
Date: Thu, 19 Feb 2026 17:01:18 -0800
Subject: [PATCH 5/6] xfs: don't report metadata inodes to fserror
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154903770.1351708.580642367097924245.stgit@frogsfrogsfrogs>
In-Reply-To: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
References: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31157-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DDE121640D9
X-Rspamd-Action: no action

From: Darrick J. Wong <djwong@kernel.org>

Internal metadata inodes are not exposed to userspace programs, so it
makes no sense to pass them to the fserror functions (aka fsnotify).
Instead, report metadata file problems as general filesystem corruption.

Fixes: 5eb4cb18e445d0 ("xfs: convey metadata health events to the health monitor")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_health.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 169123772cb39b..6475159eb9302c 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -314,6 +314,18 @@ xfs_rgno_mark_sick(
 	xfs_rtgroup_put(rtg);
 }
 
+static inline void xfs_inode_report_fserror(struct xfs_inode *ip)
+{
+	/* Report metadata inodes as general filesystem corruption */
+	if (xfs_is_internal_inode(ip)) {
+		fserror_report_metadata(ip->i_mount->m_super, -EFSCORRUPTED,
+				GFP_NOFS);
+		return;
+	}
+
+	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
+}
+
 /* Mark the unhealthy parts of an inode. */
 void
 xfs_inode_mark_sick(
@@ -339,7 +351,7 @@ xfs_inode_mark_sick(
 	inode_state_clear(VFS_I(ip), I_DONTCACHE);
 	spin_unlock(&VFS_I(ip)->i_lock);
 
-	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
+	xfs_inode_report_fserror(ip);
 	if (mask)
 		xfs_healthmon_report_inode(ip, XFS_HEALTHMON_SICK, old_mask,
 				mask);
@@ -371,7 +383,7 @@ xfs_inode_mark_corrupt(
 	inode_state_clear(VFS_I(ip), I_DONTCACHE);
 	spin_unlock(&VFS_I(ip)->i_lock);
 
-	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
+	xfs_inode_report_fserror(ip);
 	if (mask)
 		xfs_healthmon_report_inode(ip, XFS_HEALTHMON_CORRUPT, old_mask,
 				mask);


