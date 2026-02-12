Return-Path: <linux-xfs+bounces-30773-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Ez7JFw1jWl70AAAu9opvQ
	(envelope-from <linux-xfs+bounces-30773-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Feb 2026 03:05:16 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE86129185
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Feb 2026 03:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2E08F30095F8
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Feb 2026 02:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B255477E;
	Thu, 12 Feb 2026 02:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0MP0rK4"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D8A2940D
	for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770861911; cv=none; b=AQXwdDB2Jb7OdFjp2HPMFZgL61KCblh1ONne5z9v8bIdEOPI47/tjEnNTxP+/yoziSNoi4RwOICjNUrfLND0ZBMrUBGblMkxZxOiPUU83lN43WS79LQt61KRQhUsM1ERNG+4f/2Gmnt2tBhYVIaagDOFAEDKmQrsq4pRSewbhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770861911; c=relaxed/simple;
	bh=jpVPdnWuUdS3PCp+Vp10/G0tEas5V1WiaOQjAw8j6no=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mz7QZ4+vf+XuNjNFsO/eFj+kOkAksBk8t4ey6H/J5LnJgcRTmbqmDsbngRBEuVces0clqsOYUQrwItux3kiKKlRQgs4fVcGAPkBidlpiIz2LkHn2s6N0uGzYxXEq/DRC/aybX0Xlyn/P2OjRinrETUacNH/mr/eNZ9ulVFn8p6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0MP0rK4; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82491fbf02cso1027025b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Feb 2026 18:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770861910; x=1771466710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/UVrQCpIRB5YURUMvNqU0aA8/1FRTlrucWPzojwonag=;
        b=G0MP0rK4YLM7I7So5FgNwne7niI1HjrMlJK3LKRfKQ4X3FF2AJdW60pXug8WtMySCI
         aux4qxik/1yh0mD450BwK1tNsdwetFQ5dT3em81JNq8lzBMBN7RIV6spO9OS9/G3FmqM
         atffinASLC4U0zyDeV8WZg51c12fL78DnWBet+2QZew90GFMyr315UxwBMATdRdy3isH
         lFi8VYuHd/qZoD1O0NN8pymBnMZd35h77EkxuzLI6bOqZi0pRc5pX04vt4cgNEoo4Avc
         AT64rPp4/BTlAmAlpuCbyLA/+AmmyTuYooliE673uXxwI4nP+/QXO79xQfWNhaPzisr/
         JS8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770861910; x=1771466710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UVrQCpIRB5YURUMvNqU0aA8/1FRTlrucWPzojwonag=;
        b=Ecjnl0OXIIDpBAVtZR+qF+OUw6sO9fPrJWcq/onXwgmT/dU1xBCJs+UpGeW6ZrAlX1
         13H5gLjn/nnT9Xc1zOsppk0GpoeTAuOLSpGms4jv0rpTHv+lQO1/pzHs6k5n58SaOh9+
         bNzIxppD+7MG4WNI+yVh9jHTD0eLMGJboTcFerl8+Gnk6NgwgNa2o/qeYiltCNRASnEN
         h1j/R5MaZeiZRfmf0Q/GwWl77lp3QGhm4OWCGob7RloITEYAQhr4SMbteKQQ7ZstVJfa
         qDCnNqbf9c6+b7R2x6EfJp3nM0JM48/m7mO4eMC4wN0RbIb67W4ycFP9RuCNMxfxsZOT
         8gSw==
X-Gm-Message-State: AOJu0Yx7MBNHnnvLbdDz7QD5644x6sDpNLF8KRnGLbnWUnbxtNoTroPP
	IXfNQm3PClmoc+ELFoeap5fx4PPKh9bgyE1pSWPjbLUSwhrbhuq8mHS2
X-Gm-Gg: AZuq6aIcyQOltVmpKN+eBgHzrHzvIc67zpIjKADQVwM6hughGzlkiuQ2L+xjRQU6h2W
	8aMniYeys/77/rH0v3FRSZXGNkchghD6oQrlcQiMb8VMS9TPGPiPZRt50Wk5nm3yJU0nqxiFxcr
	AoDWI0MAIx+XHLXBQpcA1xoriFukwvdLBsNErOYINdj9QpE7HJywxgFmdwLSj6LPgStQbuVkzjI
	9Vci9RkuNxkO/qslgauiHPmD3TzH7rQuGVwXyZXiUkmwYwFzxXcwT8epKu0Bm+hhfCVKCLUDNFe
	CJlozHgKz3ZFiyJYFIhj7JdzA43br0a0/Ldh1b+3DxlqBVbM4HHcGXvHDbhvpG1uNV5zrryz33w
	MlunKbr62RKsLXq/fw0ZYtsn/lLQ6bAbKnIjkjd0OAY2RGHZPMOkK2brSwIvIZwvBYRBuTex0dO
	fKy1dJkj0LMWLBA/0ry/t2Onad2Mc3WI186pNBKTt0ih5pF3DfOrgg0Naj0b7H
X-Received: by 2002:a05:6a00:ab0a:b0:81f:48d4:a979 with SMTP id d2e1a72fcca58-824b050de1cmr1053222b3a.49.1770861909936;
        Wed, 11 Feb 2026 18:05:09 -0800 (PST)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e7d64d4sm4287754b3a.37.2026.02.11.18.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 18:05:08 -0800 (PST)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH] xfs: fixup some alignment issues in xfs_ondisk.c
Date: Thu, 12 Feb 2026 12:04:38 +1000
Message-ID: <20260212020437.259170-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30773-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wilfredopensource@gmail.com,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: BEE86129185
X-Rspamd-Action: no action

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Fixup some code alignment issues in xfs_ondisk.c

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
 fs/xfs/libxfs/xfs_ondisk.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 1914ffe59202..23cde1248f01 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -73,7 +73,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,	8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,	4);
@@ -116,7 +116,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_intnode,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,	4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, freetag,	0);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, length,	2);
-- 
2.53.0


