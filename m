Return-Path: <linux-xfs+bounces-3466-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6892849556
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Feb 2024 09:26:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D92551C2172D
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Feb 2024 08:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A184111AE;
	Mon,  5 Feb 2024 08:26:32 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF47011197;
	Mon,  5 Feb 2024 08:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707121592; cv=none; b=RhNVTYr/F4DcpIaGXi7mMfI6SVTC8pgbGFd369ktJ34ymstVM9qGMaU61TlLmsonaE3yeyolkVw17thpLT+QGET1OHQlluWVpFg/+pmOFHbYOFsaysqmCxciiOZ0QvjgDPEGq4wUWzOScLn0ULuhwRbfwc72shYHX2rTjCUQxE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707121592; c=relaxed/simple;
	bh=LbuJw2xD8l9tYjGEUkeiPhK3rPmUvUClZqAADKdQjCA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kaWnAZCKzLSVG97U22ozGrcn+EqfjrmRp9Ruk6lM+65TpwupKEUmSc4F2xtqGxkqZxqT361XYWnJbnR3Rdkm3tO6qf9cFSBpSryGUDp8Fxakqphf3ofMoOnwzVr++6m8XR3/rRivrMmpoGnFAAlSis9s7L8WTpE/DULiDG6ZxAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8b8e8b0dbbc142ecb32e9686707e00ca-20240205
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:d0471828-7056-4f39-9f3a-ae59c357938f,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:20
X-CID-INFO: VERSION:1.1.35,REQID:d0471828-7056-4f39-9f3a-ae59c357938f,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:5d391d7,CLOUDID:0ea92180-4f93-4875-95e7-8c66ea833d57,B
	ulkID:240205162625SWQ3TOL0,BulkQuantity:0,Recheck:0,SF:17|19|44|66|38|24|1
	02,TC:nil,Content:0,EDM:5,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 8b8e8b0dbbc142ecb32e9686707e00ca-20240205
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1928903605; Mon, 05 Feb 2024 16:26:22 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 3472DE000EBC;
	Mon,  5 Feb 2024 16:26:22 +0800 (CST)
X-ns-mid: postfix-65C09BAE-2003869
Received: from kernel.. (unknown [172.20.15.254])
	by mail.kylinos.cn (NSMail) with ESMTPA id B7F44E000EBC;
	Mon,  5 Feb 2024 16:26:21 +0800 (CST)
From: Kunwu Chan <chentao@kylinos.cn>
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH] xfs: Simplify the allocation of slab caches in xfs_bmap_intent_init_cache
Date: Mon,  5 Feb 2024 16:26:20 +0800
Message-Id: <20240205082620.435721-1-chentao@kylinos.cn>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f362345467fa..e46d0e21aeb6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6211,9 +6211,7 @@ xfs_bmap_validate_extent_raw(
 int __init
 xfs_bmap_intent_init_cache(void)
 {
-	xfs_bmap_intent_cache =3D kmem_cache_create("xfs_bmap_intent",
-			sizeof(struct xfs_bmap_intent),
-			0, 0, NULL);
+	xfs_bmap_intent_cache =3D KMEM_CACHE(xfs_bmap_intent, 0);
=20
 	return xfs_bmap_intent_cache !=3D NULL ? 0 : -ENOMEM;
 }
--=20
2.39.2


