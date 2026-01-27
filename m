Return-Path: <linux-xfs+bounces-30380-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KKemNNfieGkztwEAu9opvQ
	(envelope-from <linux-xfs+bounces-30380-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 17:07:51 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF199769B
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 17:07:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 71D2C3020EE6
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 16:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE5424E016;
	Tue, 27 Jan 2026 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fNlmvRYA"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6E4307AE3
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769529999; cv=none; b=C85aFLxF+wVYy05+0OCz4eAQNBFJybiZCgdwyDxVUNcvvEtkLVg4TKO6nsHRNHAkfwfY0ai+gkiW8tCKpPFGMl9A0XnElfzMd62y5WF8TVZMZ1O4bBejjUoiTyCiUcu0CAO6921JIXWgAx8qArAkD4pJOTM8q9fFrXdldB4lnSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769529999; c=relaxed/simple;
	bh=tc1GYzpjAh9chNPS8n0BM1b50N/KniRG0cxvPqILY54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/D5rrA/QWevoTx5Pv+V3fFsIIWo0xpXiV0ekBgAB0CM3Nr5Ncrku70Qgt6bV/PhTqtKs93EV6NOvTWy5XzshTNp4dnJf610f3tqX7iPOlgZYtrQ3fsppAXxyBcTmhekUxyKa8DFhATzHAA1+du//NT1NQMNxLc2p78h2RdhwK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fNlmvRYA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=84gn/J5BZCYWKwYMFmU1pt81fdTEiBwjnChKq4k6s1Y=; b=fNlmvRYAmmFkmLI1xIu0gC2rIJ
	uQ5b8nZ7BYA2DSZW4KH9CTMyCc1K6A7qNFM3ZcMpxFopSQlc/s0aJLsvu+O/C7yAt7+v+mjhbJXi+
	sGkxCDnf1bf/lMibLuqYjx0QlmCdPKTUsv+sPiV1mMBoxyPY2q0YG3BxPWjIeKMOsYoaowyl8eFLZ
	7yVo1wQl+ofsFDWl4qZHwgi8WMGvbeNuIwSFK1l8Qj28u5HOZWz5ecQay+BCCYDojTqOXFisWL3D4
	EJGWU4NKj8b5rvHc8DO9puy67OrsDukA3qMp36w6rom4pJsMnLXIF60PhZUKA15jYGgMgq8Pidk4V
	zLJH8KuA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklaP-0000000Ebkr-0PXV;
	Tue, 27 Jan 2026 16:06:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/10] xfs: don't validate error tags in the I/O path
Date: Tue, 27 Jan 2026 17:05:43 +0100
Message-ID: <20260127160619.330250-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127160619.330250-1-hch@lst.de>
References: <20260127160619.330250-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30380-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lst.de:mid,lst.de:email]
X-Rspamd-Queue-Id: 8CF199769B
X-Rspamd-Action: no action

We can trust XFS developers enough to not pass random stuff to
XFS_ERROR_TEST/DELAY.  Open code the validity check in xfs_errortag_add,
which is the only place that receives unvalidated error tag values from
user space, and drop the now pointless xfs_errortag_enabled helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_errortag.h |  2 +-
 fs/xfs/xfs_error.c           | 38 ++++++++++--------------------------
 fs/xfs/xfs_error.h           |  2 +-
 3 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 57e47077c75a..b7d98471684b 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -53,7 +53,7 @@
  * Drop-writes support removed because write error handling cannot trash
  * pre-existing delalloc extents in any useful way anymore. We retain the
  * definition so that we can reject it as an invalid value in
- * xfs_errortag_valid().
+ * xfs_errortag_add().
  */
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index dfa4abf9fd1a..52a1d51126e3 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -125,30 +125,6 @@ xfs_errortag_del(
 	xfs_sysfs_del(&mp->m_errortag_kobj);
 }
 
-static bool
-xfs_errortag_valid(
-	unsigned int		error_tag)
-{
-	if (error_tag >= XFS_ERRTAG_MAX)
-		return false;
-
-	/* Error out removed injection types */
-	if (error_tag == XFS_ERRTAG_DROP_WRITES)
-		return false;
-	return true;
-}
-
-bool
-xfs_errortag_enabled(
-	struct xfs_mount	*mp,
-	unsigned int		tag)
-{
-	if (!xfs_errortag_valid(tag))
-		return false;
-
-	return mp->m_errortag[tag] != 0;
-}
-
 bool
 xfs_errortag_test(
 	struct xfs_mount	*mp,
@@ -158,9 +134,6 @@ xfs_errortag_test(
 {
 	unsigned int		randfactor;
 
-	if (!xfs_errortag_valid(error_tag))
-		return false;
-
 	randfactor = mp->m_errortag[error_tag];
 	if (!randfactor || get_random_u32_below(randfactor))
 		return false;
@@ -178,8 +151,17 @@ xfs_errortag_add(
 {
 	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
 
-	if (!xfs_errortag_valid(error_tag))
+	if (error_tag >= XFS_ERRTAG_MAX)
+		return -EINVAL;
+
+	/* Error out removed injection types */
+	switch (error_tag) {
+	case XFS_ERRTAG_DROP_WRITES:
 		return -EINVAL;
+	default:
+		break;
+	}
+
 	mp->m_errortag[error_tag] = xfs_errortag_random_default[error_tag];
 	return 0;
 }
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 3a78c8dfaec8..ec22546a8ca8 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -44,7 +44,7 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
 #define XFS_ERRORTAG_DELAY(mp, tag)		\
 	do { \
 		might_sleep(); \
-		if (!xfs_errortag_enabled((mp), (tag))) \
+		if (!mp->m_errortag[tag]) \
 			break; \
 		xfs_warn_ratelimited((mp), \
 "Injecting %ums delay at file %s, line %d, on filesystem \"%s\"", \
-- 
2.47.3


