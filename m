Return-Path: <linux-xfs+bounces-31998-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wNANDJOLrmnlFwIAu9opvQ
	(envelope-from <linux-xfs+bounces-31998-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Mar 2026 09:57:55 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BBA3235BE8
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Mar 2026 09:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B223F300AB1C
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Mar 2026 08:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A272336EA88;
	Mon,  9 Mar 2026 08:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="FtJfNNfy";
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="FtJfNNfy"
X-Original-To: linux-xfs@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C913236E498
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773046670; cv=none; b=m1JRJGSoc2Sx1DAphTBNHxA2tQ2bYV16jZUFRNSW0t0/bApkZaCZHA28L98dLQAcCpk7ww4UIo1BkLY1e5s8mFhst5/EJmycTeWTRFE/DoyStiDN9MtjdzVPAy4nCCunX1UgPB+Zx/9IzoSuYz9EROD64YMpOmO4Pur8U2DRO/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773046670; c=relaxed/simple;
	bh=mOMwVT99X82IJcbvcE+LlJSUswBAtNIfdeqN5KvIphQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cjxEOiq3gQONFsJOE4MIxoJNGjFFGnxvThw9WRGBKzMm6Iu8NlUe4ql5T0SY4GMwrvNLd6vYFZvaUrXew9xy/pTUVARoefm2+E/MehGChrGFlDtv01p0kKPPaKJV4X1G8xvLXu/LW3dc5S9ZiRsHd1oGc4KrLG1sYhYGquGTw8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=FtJfNNfy; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=FtJfNNfy; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1dx7gfONTQAeZ2feRvHjxX/Emicbaw45Ovg2Mh+cD6U=;
	b=FtJfNNfyLQEFqwyqW2wvcOGflzO1Ezn3MvrjbCgMNj/Iyx331h09gn9gkAv69nH65sVLjKWk8
	mqvwT/DfAqPeLmH6GpiLQeXkOfijROQ58bdIkKiXR+UeOQNVXX2Fxki4wVWBZavfJBTRIIv5pCG
	bgLhsWmW4KXCReb+R5ugPb8=
Received: from canpmsgout12.his.huawei.com (unknown [172.19.92.144])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4fTr4B18dSz1BGDC
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 16:37:46 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1dx7gfONTQAeZ2feRvHjxX/Emicbaw45Ovg2Mh+cD6U=;
	b=FtJfNNfyLQEFqwyqW2wvcOGflzO1Ezn3MvrjbCgMNj/Iyx331h09gn9gkAv69nH65sVLjKWk8
	mqvwT/DfAqPeLmH6GpiLQeXkOfijROQ58bdIkKiXR+UeOQNVXX2Fxki4wVWBZavfJBTRIIv5pCG
	bgLhsWmW4KXCReb+R5ugPb8=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fTqyK70CPznTVX;
	Mon,  9 Mar 2026 16:32:41 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id EACBC40565;
	Mon,  9 Mar 2026 16:38:18 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 9 Mar 2026 16:38:18 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 9 Mar
 2026 16:38:18 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 3/4] xfs: factor out xfs_attr3_leaf_init
Date: Mon, 9 Mar 2026 16:27:51 +0800
Message-ID: <20260309082752.2039861-4-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260309082752.2039861-1-leo.lilong@huawei.com>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemn100013.china.huawei.com (7.202.194.116)
X-Rspamd-Queue-Id: 0BBA3235BE8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[huawei.com : SPF not aligned (relaxed), DKIM not aligned (relaxed),quarantine];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[h-partners.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,fromorbit.com,huawei.com,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leo.lilong@huawei.com,linux-xfs@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-31998-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[h-partners.com:+];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	DBL_BLOCKED_OPENRESOLVER(0.00)[h-partners.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,huawei.com:mid,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action

Factor out wrapper xfs_attr3_leaf_init function, which exported for
external use.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 20 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 47f48ae555c0..6599b53f4822 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1415,6 +1415,26 @@ xfs_attr3_leaf_create(
 	return 0;
 }
 
+/*
+ * Wrapper function of initializing contents of a leaf, export for external use.
+ */
+int
+xfs_attr3_leaf_init(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		blkno)
+{
+	struct xfs_buf		*bp = NULL;
+	struct xfs_da_args	args;
+
+	memset(&args, 0, sizeof(args));
+	args.trans = tp;
+	args.dp = dp;
+	args.owner = dp->i_ino;
+	args.geo = dp->i_mount->m_attr_geo;
+
+	return xfs_attr3_leaf_create(&args, blkno, &bp);
+}
 /*
  * Split the leaf node, rebalance, then add the new entry.
  *
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index aca46da2bc50..72639efe6ac3 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -87,6 +87,9 @@ int	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
 /*
  * Routines used for shrinking the Btree.
  */
+
+int	xfs_attr3_leaf_init(struct xfs_trans *tp, struct xfs_inode *dp,
+				xfs_dablk_t blkno);
 int	xfs_attr3_leaf_toosmall(struct xfs_da_state *state, int *retval);
 void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
 				       struct xfs_da_state_blk *drop_blk,
-- 
2.39.2


