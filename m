Return-Path: <linux-xfs+bounces-30202-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDOILkQec2ngsQAAu9opvQ
	(envelope-from <linux-xfs+bounces-30202-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 08:07:48 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 37AAB716D4
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 08:07:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C96C3013AAB
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 07:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861A018787A;
	Fri, 23 Jan 2026 07:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sO7k+tYC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152134405F;
	Fri, 23 Jan 2026 07:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151819; cv=none; b=jzLozXBguqjdetmiRdn9v5BWNdz61yOre4+0vvteZVSMYNvxX0c2vR2mTNgUnF5PBGQTsk9JmKTv1xJ+XcF4jbXFS/U4OpLICo1nke4tHex6xA+mY/vDDZ699hz/sHgsvV7bRhhuVG1zT+ehBtKIHIpIZ6qp1i4kqNdAlFvAXEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151819; c=relaxed/simple;
	bh=LmlUfOAWqCsqpMhezQnsHTzqPGnwN+sYDt2Pg7+tzNg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AHERnDdZmNF3DsRrWzN0iDbhgApwvhyk9jcd4o9MdBO/OYb953gWV+CmTmL5oJkwd24nW5/uKnV3jAfNpYwdAo57Nq7AZPc3gU81+CxAKx+aWuciV75HgFOjLToLvY5lRO2lx7sZGk8v0KtEx/mjQZS7up+COHKbWXSZ1GUtsK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sO7k+tYC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AD7C4CEF1;
	Fri, 23 Jan 2026 07:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151818;
	bh=LmlUfOAWqCsqpMhezQnsHTzqPGnwN+sYDt2Pg7+tzNg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sO7k+tYCWoyeVbv4hBTyogFUXi+yN3Q/NXIaXiRyhDsMJ3fuRnFgmQ2E4cPkHFB+Z
	 v4m2kxMwik5byphynYiDFhUCC1yZV3XFm8wAAJ+BMK28StLoMf5G/3tmxceB9HKMwR
	 g+heyV7s3c58KWK+ZH0NA+SlMWD5AdIVoDCe1WONhJZVdwqd4auY978TaFCMS/ADdq
	 sRqQ0BoQITzZmnxg1BHnj8+ZEmaAqIh9QcSE1Q0Rd3C7wX6yhABcnMFC3J0XZQH/H3
	 CyuqiiLMb7F40hVJz14SuZWd5GCGMTCeXY58pEQgbSVWYHvY+B0dddLdU9Vs1ACTdg
	 lXXBGg6EJcN6w==
Date: Thu, 22 Jan 2026 23:03:37 -0800
Subject: [PATCH 2/5] xfs: only call xf{array,blob}_destroy if we have a valid
 pointer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: r772577952@gmail.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
 r772577952@gmail.com, hch@lst.de
Message-ID: <176915153740.1677852.8895419964139371863.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,lst.de];
	TAGGED_FROM(0.00)[bounces-30202-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.947];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 37AAB716D4
X-Rspamd-Action: no action

From: Darrick J. Wong <djwong@kernel.org>

Only call the xfarray and xfblob destructor if we have a valid pointer,
and be sure to null out that pointer afterwards.  Note that this patch
fixes a large number of commits, most of which were merged between 6.9
and 6.10.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    8 ++++++--
 fs/xfs/scrub/attr_repair.c     |    6 ++++--
 fs/xfs/scrub/dir_repair.c      |    8 ++++++--
 fs/xfs/scrub/dirtree.c         |    8 ++++++--
 fs/xfs/scrub/nlinks.c          |    3 ++-
 5 files changed, 24 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index a2f6a7f71d8396..6e3fef36d6614a 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -837,8 +837,12 @@ xrep_agi_buf_cleanup(
 {
 	struct xrep_agi	*ragi = buf;
 
-	xfarray_destroy(ragi->iunlink_prev);
-	xfarray_destroy(ragi->iunlink_next);
+	if (ragi->iunlink_prev)
+		xfarray_destroy(ragi->iunlink_prev);
+	ragi->iunlink_prev = NULL;
+	if (ragi->iunlink_next)
+		xfarray_destroy(ragi->iunlink_next);
+	ragi->iunlink_next = NULL;
 	xagino_bitmap_destroy(&ragi->iunlink_bmp);
 }
 
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index eded354dec11ee..dd24044c44efd3 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1516,8 +1516,10 @@ xrep_xattr_teardown(
 		xfblob_destroy(rx->pptr_names);
 	if (rx->pptr_recs)
 		xfarray_destroy(rx->pptr_recs);
-	xfblob_destroy(rx->xattr_blobs);
-	xfarray_destroy(rx->xattr_records);
+	if (rx->xattr_blobs)
+		xfblob_destroy(rx->xattr_blobs);
+	if (rx->xattr_records)
+		xfarray_destroy(rx->xattr_records);
 	mutex_destroy(&rx->lock);
 	kfree(rx);
 }
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 7a21b688a47158..d5a55eabf68012 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -172,8 +172,12 @@ xrep_dir_teardown(
 	struct xrep_dir		*rd = sc->buf;
 
 	xrep_findparent_scan_teardown(&rd->pscan);
-	xfblob_destroy(rd->dir_names);
-	xfarray_destroy(rd->dir_entries);
+	if (rd->dir_names)
+		xfblob_destroy(rd->dir_names);
+	rd->dir_names = NULL;
+	if (rd->dir_entries)
+		xfarray_destroy(rd->dir_entries);
+	rd->dir_names = NULL;
 }
 
 /* Set up for a directory repair. */
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index f9c85b8b194fa4..3e0bbe75c44cff 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -81,8 +81,12 @@ xchk_dirtree_buf_cleanup(
 		kfree(path);
 	}
 
-	xfblob_destroy(dl->path_names);
-	xfarray_destroy(dl->path_steps);
+	if (dl->path_names)
+		xfblob_destroy(dl->path_names);
+	dl->path_names = NULL;
+	if (dl->path_steps)
+		xfarray_destroy(dl->path_steps);
+	dl->path_steps = NULL;
 	mutex_destroy(&dl->lock);
 }
 
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 2ba686e4de8bc5..dec3b9b47453ea 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -971,7 +971,8 @@ xchk_nlinks_teardown_scan(
 
 	xfs_dir_hook_del(xnc->sc->mp, &xnc->dhook);
 
-	xfarray_destroy(xnc->nlinks);
+	if (xnc->nlinks)
+		xfarray_destroy(xnc->nlinks);
 	xnc->nlinks = NULL;
 
 	xchk_iscan_teardown(&xnc->collect_iscan);


