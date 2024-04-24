Return-Path: <linux-xfs+bounces-7430-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E8F8AFF34
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Apr 2024 05:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 982B5285975
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Apr 2024 03:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCECF85C59;
	Wed, 24 Apr 2024 03:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qb6YEhuP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA0A85925
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928308; cv=none; b=QqU3CFq8cpFKfmnFLkbe6BCEsZVdw047U3Trmwwo7c+3PFRoMt6xFxuGUqR/j27nxzpytE9I8/jxn1AxRppgbsUISG81ROqeEgJHcepmvZmlqVdZHAJOKUTsJsl3S2fmVG3ILwQOh3ujuiabH7deLD6lGjD3RHAIq3Vxpy8jo30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928308; c=relaxed/simple;
	bh=hg81GAHKMLjk31tTyOQR7lFZlAWT0coYEdkkR8hryLI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bo85J7IIgHoYyzylgqgst1fTCcbiCDhAQxVbMeDJjhO+kJkOAA2tvVc1UHAFBcfgR/5lK0yu3HYJZ47GuNZZfXBk5Skho9beuZKgOI1uCatwQ8xr2Zfk7lK6ezmac68oBzcH4bWzpVk3BoCLuCh4u3x2TbUEdukZsYB5A/aaIms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qb6YEhuP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62213C2BD10;
	Wed, 24 Apr 2024 03:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928308;
	bh=hg81GAHKMLjk31tTyOQR7lFZlAWT0coYEdkkR8hryLI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qb6YEhuPTTHm6GvpneB1ECbXYnSDvu8vFeez2+oH60LnNWlpCZrkYTglCI5B5UcFi
	 CfQU83ez+S29JH/Kdnoeqj9AFBHNgMyM+rC6V8794LC+FZq+4V6+zYRqvV5YW0oIT9
	 2kvAexM2gSGiHBkL3AbUzUhV9isAw1NPQmtUyPU04t1mtvRnbmA6JXWeH4Aa1quLyr
	 IigoUKwOgFlCTGlV/evXwHfrBAMOXWvDXiuGaBz9m/XJNpz/FP082JGKp/jpcyaSYP
	 Vv7N/a7aGQgMIFl6ABacSiW8YYlaqJCKyQg14RP0b9MTOK2ndJ3Nf4bTScG/lHrM6c
	 kgeBkQl4prJaA==
Date: Tue, 23 Apr 2024 20:11:47 -0700
Subject: [PATCH 11/14] xfs: use local variables for name and value length in
 _attri_commit_pass2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782758.1904599.15252200321854261490.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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

We're about to start using tagged unions in the xattr log format, so
create a bunch of local variables in the recovery function so we only
have to decode the log item fields once.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 8a13e2840692..59723e5f483e 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -738,9 +738,11 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_item       *attrip;
 	struct xfs_attri_log_format     *attri_formatp;
 	struct xfs_attri_log_nameval	*nv;
-	const void			*attr_value = NULL;
 	const void			*attr_name;
+	const void			*attr_value = NULL;
 	size_t				len;
+	unsigned int			name_len = 0;
+	unsigned int			value_len = 0;
 	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -769,6 +771,8 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Log item, attr name */
@@ -777,6 +781,7 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
 		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -786,15 +791,14 @@ xlog_recover_attri_commit_pass2(
 	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[i].i_len !=
-			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
+	if (item->ri_buf[i].i_len != xlog_calc_iovec_len(name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(attr_name, name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
@@ -802,8 +806,8 @@ xlog_recover_attri_commit_pass2(
 	i++;
 
 	/* Validate the attr value, if present */
-	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+	if (value_len != 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
@@ -827,7 +831,7 @@ xlog_recover_attri_commit_pass2(
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Regular remove operations operate only on names. */
-		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+		if (attr_value != NULL || value_len != 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -840,7 +844,7 @@ xlog_recover_attri_commit_pass2(
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
 		 */
-		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -853,9 +857,8 @@ xlog_recover_attri_commit_pass2(
 	 * name/value buffer to the recovered incore log item and drop our
 	 * reference.
 	 */
-	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
-			attri_formatp->alfi_value_len);
+	nv = xfs_attri_log_nameval_alloc(attr_name, name_len,
+			attr_value, value_len);
 
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);


