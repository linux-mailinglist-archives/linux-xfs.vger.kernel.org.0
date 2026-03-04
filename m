Return-Path: <linux-xfs+bounces-31905-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yMDzGaKCqGmYvAAAu9opvQ
	(envelope-from <linux-xfs+bounces-31905-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 20:06:10 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D13F4206E0E
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 20:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 153C8309C018
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2026 18:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064613D75C3;
	Wed,  4 Mar 2026 18:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1bz9Nd4"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6B93CD8C2
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 18:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772650774; cv=none; b=ko8EBZP/ZCT/xqkz8AATYneG9FrWvobu+EUTnWgmP3LWH4zPw9GLbGj8c/ro45seJB8ougUQwV9h+eJcmaT9l7fXmXwdBlBbYYsiBI7DlU4wV5OrjpLo5ED//nUst2XoJtjRUnpEZ2SiqVdGfZ0w2VSUM16AZJMBXUkr10LY8sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772650774; c=relaxed/simple;
	bh=BrsnKsrMSUteCRkCN6uadYfkUhhtrI2ADmNHHN8cdWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LsnBSYf6P7LpoT5w5jAQUW9NApZ/KRjMshXRAkGqrU7Xdj+5vdrgfFN+ABoeHPwaC2/8vZPBugvTEGU0gC0BY1DWcJ4PU6C+qQE5otTkcUtL8lCeK2CbYpr+p04yxoRleK+HzNobkvtyDUylkHZPDY4ovLJq4MN3Oi6J0MC4wz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e1bz9Nd4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772650772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gYPZkt1gtq6YQ3HwfOWxO1iWQMk8wymejJEcZKscvSY=;
	b=e1bz9Nd4Mo2nKC6ojBgKVodOQ9l7TQ0PC7Uh6bqxTubvTGlfhOgnjWfARVGJ7sIr/tTyTg
	11jsTwqtB5IVcufM6hISGhzx2C7iCC69hBWuKQIBY26nxZOvInjt4d449xz3m7W2ouim0/
	br/xBuY3SskYQVpzPlpra1RLNYrXoCg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-Q8jqWcpoPFSzweBnkTIkTw-1; Wed,
 04 Mar 2026 13:59:27 -0500
X-MC-Unique: Q8jqWcpoPFSzweBnkTIkTw-1
X-Mimecast-MFC-AGG-ID: Q8jqWcpoPFSzweBnkTIkTw_1772650766
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99D2A1800359;
	Wed,  4 Mar 2026 18:59:26 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.32.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2808230001A1;
	Wed,  4 Mar 2026 18:59:24 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
Date: Wed,  4 Mar 2026 19:59:20 +0100
Message-ID: <20260304185923.291592-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: D13F4206E0E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31905-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[agruenba@redhat.com,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
calls bio_io_error() which overwrites that value again.  Fix that by
completing the bio separately after setting bio->bi_status.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_zone_alloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index e3d19b6dc64a..c3328b9dda37 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -862,7 +862,7 @@ xfs_zone_alloc_and_submit(
 	bool			is_seq;
 
 	if (xfs_is_shutdown(mp))
-		goto out_error;
+		goto out_io_error;
 
 	/*
 	 * If we don't have a locally cached zone in this write context, see if
@@ -875,7 +875,7 @@ xfs_zone_alloc_and_submit(
 select_zone:
 		*oz = xfs_select_zone(mp, write_hint, pack_tight);
 		if (!*oz)
-			goto out_error;
+			goto out_io_error;
 		xfs_set_cached_zone(ip, *oz);
 	}
 
@@ -902,7 +902,10 @@ xfs_zone_alloc_and_submit(
 
 out_split_error:
 	ioend->io_bio.bi_status = errno_to_blk_status(PTR_ERR(split));
-out_error:
+	bio_endio(&ioend->io_bio);
+	return;
+
+out_io_error:
 	bio_io_error(&ioend->io_bio);
 }
 
-- 
2.52.0


