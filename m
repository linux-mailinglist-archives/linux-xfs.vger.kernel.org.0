Return-Path: <linux-xfs+bounces-5547-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98F4E88B802
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 04:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52F022C1CF3
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 03:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B5412839D;
	Tue, 26 Mar 2024 03:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUcv7LJf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC99F28EA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422562; cv=none; b=NP2mMXb1q+ZW/JS8hx4PQEyDMsMo0+mJjvSz3NJOOUrZCEV9AXlMmPKFMFtK+9b5RtvUMdYjbgRCU1V3QsclaN71yZZXqTkxS6PhdJ7V6px+38Fc2O8ZYfoyH4hqu9crv3+EeZoY4rweMcZPr9e7jcojgJCX1UljUU5edYU4yas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422562; c=relaxed/simple;
	bh=MfeNGpswCwdnXiD4Yb8dUpTEq6RKRr7ZzO/Up5ubbAU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRnaDzEY3hIEDT5yH+NZE2XBauRCFsYnLyjiJYyPQScZgyMPoXYvMTpKAv2lL8w54CZMk2dP8SwGseDeNpabCwjwPmd/8yE7ihYjBe31RZWK5kji06I8yTzER4TagXmXaLxJX/UMpM7NtphGTKiI39c+lpRRACwZfSm4AlTm//w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUcv7LJf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B996AC433F1;
	Tue, 26 Mar 2024 03:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422561;
	bh=MfeNGpswCwdnXiD4Yb8dUpTEq6RKRr7ZzO/Up5ubbAU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BUcv7LJfyU/3kdY55mP6g5I1xzL09DnkrotE96e/ZXOA8UKfpP4GAWmzGPZAyOFP+
	 SUwUpVOgj8tdhul37ZogrgnXVkC42YXmHEWrmH6WIErPrx77Te2W1+2UMwQ4HNn8KT
	 sjxBFNxYmIQL+7hnOOKCZz15XIXXMkl3lOC41767OFmesjai195CkjmdE5YoSkGl8d
	 3SCJ58i+GQxc4Jxc+mQn8VvlzK5TWwwQCE/jZPeDivW5VkIH8StwLu0pmbMkW6WC6N
	 tWPU4TRB4+E90vo0AVX1K2APMC8Zn0XEDfgmiqapjub90cNOudjPbk7UW2/q6OWrwy
	 34eLmx1DZo1Ig==
Date: Mon, 25 Mar 2024 20:09:21 -0700
Subject: [PATCH 25/67] xfs: consolidate the xfs_attr_defer_* helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127322.2212320.6393901595609673930.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: c00eebd09e95757c9c1d08f0a6bbc32c543daf90

Consolidate the xfs_attr_defer_* helpers into a single xfs_attr_defer_add
one that picks the right dela_state based on the passed in operation.
Also move to a single trace point as the actual operation is visible
through the flags in the delta_state passed to the trace point.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr.c |   90 ++++++++++++-----------------------------------------
 1 file changed, 21 insertions(+), 69 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2103a06b9ee3..550ca6b2e263 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -878,11 +878,10 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
-xfs_attr_intent_init(
+static void
+xfs_attr_defer_add(
 	struct xfs_da_args	*args,
-	unsigned int		op_flags,	/* op flag (set or remove) */
-	struct xfs_attr_intent	**attr)		/* new xfs_attr_intent */
+	unsigned int		op_flags)
 {
 
 	struct xfs_attr_intent	*new;
@@ -891,66 +890,22 @@ xfs_attr_intent_init(
 	new->xattri_op_flags = op_flags;
 	new->xattri_da_args = args;
 
-	*attr = new;
-	return 0;
-}
+	switch (op_flags) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+		new->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		new->xattri_dela_state = xfs_attr_init_remove_state(args);
+		break;
+	default:
+		ASSERT(0);
+	}
 
-/* Sets an attribute for an inode as a deferred operation */
-static int
-xfs_attr_defer_add(
-	struct xfs_da_args	*args)
-{
-	struct xfs_attr_intent	*new;
-	int			error = 0;
-
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
-	if (error)
-		return error;
-
-	new->xattri_dela_state = xfs_attr_init_add_state(args);
 	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
-
-	return 0;
-}
-
-/* Sets an attribute for an inode as a deferred operation */
-static int
-xfs_attr_defer_replace(
-	struct xfs_da_args	*args)
-{
-	struct xfs_attr_intent	*new;
-	int			error = 0;
-
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
-	if (error)
-		return error;
-
-	new->xattri_dela_state = xfs_attr_init_replace_state(args);
-	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
-	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
-
-	return 0;
-}
-
-/* Removes an attribute for an inode as a deferred operation */
-static int
-xfs_attr_defer_remove(
-	struct xfs_da_args	*args)
-{
-
-	struct xfs_attr_intent	*new;
-	int			error;
-
-	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
-	if (error)
-		return error;
-
-	new->xattri_dela_state = xfs_attr_init_remove_state(args);
-	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
-	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
-
-	return 0;
 }
 
 /*
@@ -1036,16 +991,16 @@ xfs_attr_set(
 	error = xfs_attr_lookup(args);
 	switch (error) {
 	case -EEXIST:
-		/* if no value, we are performing a remove operation */
 		if (!args->value) {
-			error = xfs_attr_defer_remove(args);
+			/* if no value, we are performing a remove operation */
+			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
 			break;
 		}
+
 		/* Pure create fails if the attr already exists */
 		if (args->attr_flags & XATTR_CREATE)
 			goto out_trans_cancel;
-
-		error = xfs_attr_defer_replace(args);
+		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
@@ -1055,14 +1010,11 @@ xfs_attr_set(
 		/* Pure replace fails if no existing attr to replace. */
 		if (args->attr_flags & XATTR_REPLACE)
 			goto out_trans_cancel;
-
-		error = xfs_attr_defer_add(args);
+		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
 		break;
 	default:
 		goto out_trans_cancel;
 	}
-	if (error)
-		goto out_trans_cancel;
 
 	/*
 	 * If this is a synchronous mount, make sure that the


