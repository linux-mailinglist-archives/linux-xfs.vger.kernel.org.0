Return-Path: <linux-xfs+bounces-24951-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 059B0B36E10
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Aug 2025 17:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3CB21BA86C3
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Aug 2025 15:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF0A34F463;
	Tue, 26 Aug 2025 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="O7oFfK1P"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B590350825
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222860; cv=none; b=TTiRPLzBXzw/g6Hye7bs6ES0Dxkhx9tJIsvhjYlLmbxihU00LbRf6HCTlvW1ghYQcMk0yRy7ovanQWLW2FPcPQLxn8BC4WW0nWP93kfBRJzRyTPi5lB0hL1+qH2yV3MpWgXKS/g6VeAinkCjXTSGWUyCGTSGBXjggrkz+bQac5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222860; c=relaxed/simple;
	bh=3eV0qbbQBj1MUi/XR5O70JAOPoK+SfAUiI8+4Y3kFfA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMLVHf7SZ9Q1qbowYxTt6w0JprdTkadLg7QWykjtUE8GZXJYCd+5PhwuwQeGMy6pCe52+x0V+rCdUT3ByvKtehQkSzyEJaeGxRO/ZCMC1nZJC9a/sTAI7yzSzpEfpbKpTDGElrcxVrwFgGZsDoGQlYg4kKZrW8XrtyGdwiz2koY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=O7oFfK1P; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e96d65194c1so1437113276.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222857; x=1756827657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9TIN+NpxPBD59M3BXgkQWvxyL3wlhhluVN4EhWLiaxc=;
        b=O7oFfK1P6D64tt8FdyMds2+0BEvclyyxjHQl4ffde1OjX1ElQifzITOPFnUhSohZ/4
         p6tWk+BKKx49/j9xHAikRt97S2C7b0d7ONxTkqlMFCVK7vn/bKoo77E2F4nB1pEqDVV6
         5627Tpgy4HICnriAiuEX7HD/JJgn4L+qwSnynlAWDbudM2SqfK3mjvYGoVX182uhzAge
         Af4nMFXBoXI4z4KVrntJ9a27+xLsDsWPMWyGf2e4+MHRAZwzoe20JiZW5l5m/OVx1ZH9
         KsGLq7svw3KhXvyRiXLpeqdtZR86BXzT0g8RKV5junCeBMrkjgz0/KK4nQYY0tu0rgpp
         4/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222857; x=1756827657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9TIN+NpxPBD59M3BXgkQWvxyL3wlhhluVN4EhWLiaxc=;
        b=p2E4r6zLtZwBc7ceraV0IOIYo07oj+lkKoUeylP1bbFMTsXRKEkYw2zGvWp6xsI1AF
         T/A5GtlPepbPSFDcMzKpUCVfjWpaEu8G57Nhk7TWBnaGL0weqNWjI5ZJ27Krszexm0wP
         wVnl/aKgaDU0X+Y6lIfna5c0OF7cAN+4mKvHi4Q3+wwUbUo/t1SwAztsEdIDr88KNdei
         yBhZ4BohoRtZQs4IRw0N5QFCRtJpVXiOcNmYp++ZlAf8vnJB8jaC/hx4HurPKALqMfZ7
         KcAXvZLg1G9ThdcOyXJE5tOA9BhY9VM20WC1WXPd0NjLsjehUHGlsTJlkodX65gRXuH7
         RLzg==
X-Forwarded-Encrypted: i=1; AJvYcCVl+jieecasrZwNp9A87Hls7WsqPhKQVY8baCPAWL+Ri/7oLSVd24iKbHXeMudqOdQsjDbsgxWdqXg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd6XF1IqyOqlYY6wpg02NOSj5b6d9U5Y2ii8MeLSI4+Se/kObP
	cTtKd0CxN6a/vmkYmaOLMBwgxu50yd3TkpnXRk3K1glc7zt4CvdFnPo733Dn53eJi6U=
X-Gm-Gg: ASbGncvjxVJ2rb+vD4A5Xfp3yBW+v4bTQEkFEP/09VNNtzj4+fjkuTs8rwg6iQox/Iv
	Y4vn7FUcfosoTBfr989fBU+fddC1HW8s5/JKZziF5KrkaGHPHYq7WRlDjsu7418l8pW6NCbteWN
	puucMShP6Yt1C9nflKTvm+pUknGnpY8DX/A5k283fOBD4WsI5nU3kHRd200quouk7iegmsNumzR
	t/ktcRgd0cR/1j2zIjloYUBa83VMi/OmZ9WU8IHY+jpzHXnHx8lJAGyy3hWCSJ0Wg5tYTOR5hY9
	60igcEEjgv6EY1sc73s19sKQFUrpBs1cdrFtnxSCzExJKk3LvWC8RQSshYoG2gC/rSH5QkL9+1e
	o2wF/IUBYExC6o5QozClBy3ug0HAPr13NX5gxY98apTAwq+3Qx6Xw5hpSjcM=
X-Google-Smtp-Source: AGHT+IGjVsfarYu+snEUeNFin3tD/xnE4eG8D6mg1L3D/GhHe+mc76Bk21c4LHeD44Ug/c5MM06NyA==
X-Received: by 2002:a05:6902:33c5:b0:e93:43f9:5545 with SMTP id 3f1490d57ef6-e951c3c5a15mr17865473276.37.1756222857186;
        Tue, 26 Aug 2025 08:40:57 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96dbdb8453sm849823276.20.2025.08.26.08.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:40:56 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 06/54] fs: hold an i_obj_count reference for the i_wb_list
Date: Tue, 26 Aug 2025 11:39:06 -0400
Message-ID: <0794a0dbb7885bc905320868297a5c3666fffc5c.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we're holding the inode on one of the writeback lists we need to have
a reference on that inode. Grab a reference when we add i_wb_list to
something, drop it when it's removed.

This is potentially dangerous, because we remove the inode from the
i_wb_list potentially under IRQ via folio_end_writeback(). This will be
mitigated by making sure all writeback is completed on the final iput,
before the final iobj_put, preventing a potential free under IRQ.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fs-writeback.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index acb229c194ac..cb5e22169808 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1332,6 +1332,7 @@ void sb_mark_inode_writeback(struct inode *inode)
 	if (list_empty(&inode->i_wb_list)) {
 		spin_lock_irqsave(&sb->s_inode_wblist_lock, flags);
 		if (list_empty(&inode->i_wb_list)) {
+			iobj_get(inode);
 			list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
 			trace_sb_mark_inode_writeback(inode);
 		}
@@ -1345,16 +1346,27 @@ void sb_mark_inode_writeback(struct inode *inode)
 void sb_clear_inode_writeback(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
+	struct inode *drop = NULL;
 	unsigned long flags;
 
 	if (!list_empty(&inode->i_wb_list)) {
 		spin_lock_irqsave(&sb->s_inode_wblist_lock, flags);
 		if (!list_empty(&inode->i_wb_list)) {
+			drop = inode;
 			list_del_init(&inode->i_wb_list);
 			trace_sb_clear_inode_writeback(inode);
 		}
 		spin_unlock_irqrestore(&sb->s_inode_wblist_lock, flags);
 	}
+
+	/*
+	 * This can be called in IRQ context when we're clearing writeback on
+	 * the folio. This should not be the last iobj_put() on the inode, we
+	 * run all of the writeback before we free the inode in order to avoid
+	 * this possibility.
+	 */
+	VFS_WARN_ON_ONCE(drop && iobj_count_read(drop) < 2);
+	iobj_put(drop);
 }
 
 /*
@@ -2683,6 +2695,8 @@ static void wait_sb_inodes(struct super_block *sb)
 		 * to preserve consistency between i_wb_list and the mapping
 		 * writeback tag. Writeback completion is responsible to remove
 		 * the inode from either list once the writeback tag is cleared.
+		 * At that point the i_obj_count reference will be dropped for
+		 * the i_wb_list reference.
 		 */
 		list_move_tail(&inode->i_wb_list, &sb->s_inodes_wb);
 
-- 
2.49.0


