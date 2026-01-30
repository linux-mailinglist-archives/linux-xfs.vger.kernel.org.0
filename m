Return-Path: <linux-xfs+bounces-30552-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6BKbBaQ/fGlOLgIAu9opvQ
	(envelope-from <linux-xfs+bounces-30552-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 06:20:36 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81849B7462
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 06:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5255E300FEFC
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 05:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA7633FE05;
	Fri, 30 Jan 2026 05:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XMKa4icJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CAA347BDB
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750432; cv=none; b=F5YBNo+595HyA/aPDt+eFaV7tJEbjTXMFMp9xTg8KQ7qlQVk9aI4F0OzaOurdGqErWuFoVo3cQmrpkHrDRK/PG/Re0n5SERel9mJBk0AaCCRM/PrpzAJKff7vzCX8iO/B3jhpZvs+gpflhc416ZpbRMCY1LvU2RC2XTjxHiM4Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750432; c=relaxed/simple;
	bh=/s8uHr0lcABlGGDoQ9hufdqJi2H459Gfgr4tiMGdDm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOK9vYzOfUJMIubB5FQa123bBqN0FJmuJJyQiW99iHUw+jkvovlpH0BJD0Ti8jTQaUsIBX5lV7NYx+eG5RGtCgHFEZo9RDKUI7NM8l21KK9FS08F99ZPQVAwC+e0+9lGVr2Qd+CDKXAzhH0y4ErKvA2NRlgKrXl3aWYckr7VyVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XMKa4icJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QGjOUe81+F7zs9a8Rj4MtZv/xmFGtIlZvTgF+7UiCVo=; b=XMKa4icJvfgV2J2et4ZrIs5UGk
	VkoUbFYVsnZVUrxIQNYh0YR9Zxp0W64P2UKAvF1lbzMBWakwWJ7VkpXKKZ7xxe5RICDKbW7zS+waq
	dB47zSBQ41+rDpB4y9oW0d0ie8uHXJknQ9P6BMmlPTWXW4ERCB0/f5LqqefqZrWNJ7SPqpOOf1snN
	Q5OTStL4Qm1t5K+1a34fdAN9IebsdcN7wxO+ykAQwLLEzYba7JT4X1hun8zJ82omGuGJbPSONgoTG
	hC/XD2Xb8BoqsdCrJhlnH0FOythmBdUs43q0fHuHdMQDn7s2X3va1D2T9R0GcNIkH8pfy7PX1YDvv
	hm4SDc1A==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgvm-000000013I9-1CnJ;
	Fri, 30 Jan 2026 05:20:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 04/11] xfs: move the guts of XFS_ERRORTAG_DELAY out of line
Date: Fri, 30 Jan 2026 06:19:19 +0100
Message-ID: <20260130052012.171568-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-30552-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:dkim,lst.de:mid,lst.de:email]
X-Rspamd-Queue-Id: 81849B7462
X-Rspamd-Action: no action

Mirror what is done for the more common XFS_ERRORTAG_TEST version,
and also only look at the error tag value once now that we can
easily have a local variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_error.c | 21 +++++++++++++++++++++
 fs/xfs/xfs_error.h | 15 +++------------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 52a1d51126e3..a6f160a4d0e9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -144,6 +144,27 @@ xfs_errortag_test(
 	return true;
 }
 
+void
+xfs_errortag_delay(
+	struct xfs_mount	*mp,
+	const char		*file,
+	int			line,
+	unsigned int		error_tag)
+{
+	unsigned int		delay = mp->m_errortag[error_tag];
+
+	might_sleep();
+
+	if (!delay)
+		return;
+
+	xfs_warn_ratelimited(mp,
+"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"",
+		delay, file, line,
+		mp->m_super->s_id);
+	mdelay(delay);
+}
+
 int
 xfs_errortag_add(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index ec22546a8ca8..b40e7c671d2a 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -40,19 +40,10 @@ bool xfs_errortag_test(struct xfs_mount *mp, const char *file, int line,
 		unsigned int error_tag);
 #define XFS_TEST_ERROR(mp, tag)		\
 	xfs_errortag_test((mp), __FILE__, __LINE__, (tag))
-bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
+void xfs_errortag_delay(struct xfs_mount *mp, const char *file, int line,
+		unsigned int error_tag);
 #define XFS_ERRORTAG_DELAY(mp, tag)		\
-	do { \
-		might_sleep(); \
-		if (!mp->m_errortag[tag]) \
-			break; \
-		xfs_warn_ratelimited((mp), \
-"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"", \
-				(mp)->m_errortag[(tag)], __FILE__, __LINE__, \
-				(mp)->m_super->s_id); \
-		mdelay((mp)->m_errortag[(tag)]); \
-	} while (0)
-
+	xfs_errortag_delay((mp), __FILE__, __LINE__, (tag))
 int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
 int xfs_errortag_clearall(struct xfs_mount *mp);
 #else
-- 
2.47.3


