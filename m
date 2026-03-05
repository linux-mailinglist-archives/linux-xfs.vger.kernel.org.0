Return-Path: <linux-xfs+bounces-31925-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOMZFPRGqWm33gAAu9opvQ
	(envelope-from <linux-xfs+bounces-31925-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 10:03:48 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B87120DE43
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 10:03:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7E0630763E7
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2026 08:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7F3376468;
	Thu,  5 Mar 2026 08:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="nuIivRX/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5851F36654F
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 08:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772701167; cv=none; b=YgAD46+cz3ozSQcyHCCFLdL0JnZ0LTjBMZzE4jMaGCoztw+T09Xk8xLMMgYpap+Rh744xnXTbx3YZ3YZjdymUH/YaxPlCKOgIzLy7sc7hIQQmVVkS4BTQuEEbz4dxi7mAieOc72pvI8p1L8zLiN+fkUxZy+mKstDYWO4Pet9yl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772701167; c=relaxed/simple;
	bh=xu0pS1tfomBzq9HPD/bhW7eZFMtFwAogJa8BfnZi+Oo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9GE4diR6el2Rn+a3Cbo91chYSur8VSW6wXrwYN5guOSBno5JsJIKN8B6Wp5MZD3eanR7QqhswYtTNG1WwbigCSWdmIzZtOCBHq2dyQ8fBKgQWe7JdtEJ+IchCZXyRXlQhGZUFPUqNlxWP6L7Tc/HipCPeG0CpYLWI1zJ3UJEuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=nuIivRX/; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EWkjQKGle+VFfgxYgPYTkB3/FYnIsLFjYnRJTdJTkK8=;
	b=nuIivRX/ESjzzEU97IEWpqXUZeeqL0gmYzlc+8VEavKcH4Jq1xR0TEWLbvrcJsRaxK/8/i9A1
	hubfw5k8apnHZGHdPsJA5BYEe5G9RvBIYKjSZPVWLxq8/sLy4NI1ArUwrYYz4WOz9hG3aWvI5He
	KqeLHXyzZ2zdWE/fxhudGCs=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fRNdg119xznTVw;
	Thu,  5 Mar 2026 16:54:47 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E01640561;
	Thu,  5 Mar 2026 16:59:23 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Mar 2026 16:59:23 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 5 Mar
 2026 16:59:22 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 1/2] xfs: remove redundant set null for ip->i_itemp
Date: Thu, 5 Mar 2026 16:49:21 +0800
Message-ID: <20260305084922.800699-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260305084922.800699-1-leo.lilong@huawei.com>
References: <20260305084922.800699-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)
X-Rspamd-Queue-Id: 0B87120DE43
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[huawei.com : SPF not aligned (relaxed), DKIM not aligned (relaxed),quarantine];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[h-partners.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,fromorbit.com,huawei.com,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leo.lilong@huawei.com,linux-xfs@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-31925-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[h-partners.com:+];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:mid,huawei.com:email,h-partners.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

ip->i_itemp has been set null in xfs_inode_item_destroy(), so there is
no need set it null again in xfs_inode_free_callback().

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_icache.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a7a09e7eec81..2040a9292ee6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -159,7 +159,6 @@ xfs_inode_free_callback(
 		ASSERT(!test_bit(XFS_LI_IN_AIL,
 				 &ip->i_itemp->ili_item.li_flags));
 		xfs_inode_item_destroy(ip);
-		ip->i_itemp = NULL;
 	}
 
 	kmem_cache_free(xfs_inode_cache, ip);
-- 
2.39.2


