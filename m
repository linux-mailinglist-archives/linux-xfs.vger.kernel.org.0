Return-Path: <linux-xfs+bounces-9821-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA0C913A99
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Jun 2024 14:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E8B81C20BDC
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Jun 2024 12:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF1C54757;
	Sun, 23 Jun 2024 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NmoG7G9O"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA03D1E4BF;
	Sun, 23 Jun 2024 12:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719145887; cv=none; b=RusUxGfHUpmojRyXpAPw0gZeqb8HhQ+u+oc8fvIpqrPEww/n4m00nyzT1RUhb7CuVeRZ8ASrKYMfpuuAc3lPUPWoY6Ys915U5MTqHscg12VLLJMoJ+MdOnV9rxvXs6c4PdoDvc9fzYyYQA4Ds/YY7bgRa7teBzwJ99unl0y5sWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719145887; c=relaxed/simple;
	bh=r0wkyzTZhpIMU+cglNg0/ZQeLa0CuP58FC96ddTI5VE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qrbs6qGGHppyubcI1PIPSIfkUdpwrntiFOex9JTeiwAdeEaYJNynw+IxtQt/j2ZvlAGU3iPvwdJhGUH1673oEsk1ENfkPHb81d+y1Qh9tw067dwghDVwUUvzvbLf1cvxYbAdyql35VlkXNDjlKTJwv9PZoK9DHyhlvptuqdybH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NmoG7G9O; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2c7da220252so2777813a91.1;
        Sun, 23 Jun 2024 05:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719145885; x=1719750685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F5zHneiz9eEyXhA8mfGurOU9goOl3x4DytZed2dlBl0=;
        b=NmoG7G9OVhjKG92AvrDwwMm/4h1j96h2UQONqsXdIthE4fTEeVxGg+6gCOfyaXcuDN
         WjOwVWFB5oTciwfP9JqeBUMpl7WMDwEhst0hBkvtLswX20VtQTEYtJzT4gvD0SZ+pPRE
         93F4KQFno8nujuCrs7nudG6zJ4dfpl1Y4oAfD0M1O/jkuLfw4iF2HHX1uCnXp8BcpddQ
         4KpEqAEfyd2h9a/wmBkVFHBOfDEskMa/qAMUZcQllccqV+nmYF0ijlNe+HPTJVW6u2E2
         EKCDO0ovWngATOYIxbtGQsWehLZeSvNeN8v0w6rKFt5/VAwr8yAECtSDCu4o9afXJ3kI
         eA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719145885; x=1719750685;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F5zHneiz9eEyXhA8mfGurOU9goOl3x4DytZed2dlBl0=;
        b=OrktvsjLXq0M6Zmmno3pcnNbC5245i6AFossGPZdBGJc4DxWVMK1mgu6kvScMAuQeG
         SwRbMKBJcpZSKfJ7uT87gSBAzL/3DZVnXEO1WGU40MkVex98fIrfQh8TRtGuSkG7PTOU
         Vrh8EyDESEZyzDLJxkn6I9ZlMEOSrp3/R2HUVIjwd7ymnNJBJ00mRqwKXvSM2H3AGiT7
         6KHExcrdE6qkr0StzDdWRYxQ2jqzChLWVaObxHp76CH8JJy2yeHdNx6Zt4BGmw0YLP/w
         IAZlr83rGWGo5SBAU0uNLcdkRKeb93Aq93pmhNEdwt+JAmqe7u+0bgZPsB9oYSw+uIk5
         hyQg==
X-Forwarded-Encrypted: i=1; AJvYcCXL0USMRpMyecNQE4nAJAG9EOnRL4IvN1TZtZJIRlxqkRHLPrylIgpUNl738iM0TKDffhhbSXXP3rGwPf/QourjxUz7iDwGvRLvnQlg
X-Gm-Message-State: AOJu0YznwYwSrJWBelQiO9OPQaBx8f58zffJFu/QWex/YPWmNA0dvOaY
	Wf0iK76IbjfbSx4vP5jmO597EpjStgsYz4wQfJV3nsXOqaBOYcUDA+v7Gw==
X-Google-Smtp-Source: AGHT+IHoz/XfolL6UXgrTRUwi3dVi3PAjlSweTLO1Z9JpHgxTAwlWAarX6Rj9iUV2DVlf9aB/bmE8Q==
X-Received: by 2002:a17:90b:1884:b0:2c2:f6a2:a5f7 with SMTP id 98e67ed59e1d1-2c86124708amr1326219a91.13.1719145884924;
        Sun, 23 Jun 2024 05:31:24 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c7e4ff9846sm6907108a91.5.2024.06.23.05.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jun 2024 05:31:24 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and release it early
Date: Sun, 23 Jun 2024 20:31:19 +0800
Message-Id: <20240623123119.3562031-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

In the current implementation, in most cases, the memory of xfs_log_vec
and xfs_log_iovec is allocated together. Therefore the life cycle of
xfs_log_iovec has to remain the same as xfs_log_vec.

But this is not necessary. When the content in xfs_log_iovec is written
to iclog by xlog_write(), it no longer needs to exist in the memory. But
xfs_log_vec is still useful, because after we flush the iclog into the
disk log space, we need to find the corresponding xfs_log_item through
the xfs_log_vec->lv_item field and add it to AIL.

This patch separates the memory allocation of xfs_log_iovec from
xfs_log_vec, and releases the memory of xfs_log_iovec in advance after
the content in xfs_log_iovec is written to iclog.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/xfs_log.c     |  2 ++
 fs/xfs/xfs_log.h     |  8 ++++++--
 fs/xfs/xfs_log_cil.c | 26 ++++++++++++++++----------
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 416c15494983..f7af9550c17b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2526,6 +2526,8 @@ xlog_write(
 			xlog_write_full(lv, ticket, iclog, &log_offset,
 					 &len, &record_cnt, &data_cnt);
 		}
+		if (lv->lv_flags & XFS_LOG_VEC_DYNAMIC)
+			kvfree(lv->lv_iovecp);
 	}
 	ASSERT(len == 0);
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index d69acf881153..f052c7fdb3e9 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_LOG_H__
 #define __XFS_LOG_H__
 
+#define XFS_LOG_VEC_DYNAMIC	(1 << 0)
+
 struct xfs_cil_ctx;
 
 struct xfs_log_vec {
@@ -17,7 +19,8 @@ struct xfs_log_vec {
 	char			*lv_buf;	/* formatted buffer */
 	int			lv_bytes;	/* accounted space in buffer */
 	int			lv_buf_len;	/* aligned size of buffer */
-	int			lv_size;	/* size of allocated lv */
+	int			lv_size;	/* size of allocated iovec + buffer */
+	int			lv_flags;	/* lv flags */
 };
 
 #define XFS_LOG_VEC_ORDERED	(-1)
@@ -40,6 +43,7 @@ static inline void
 xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
 		int data_len)
 {
+	struct xfs_log_iovec	*lvec = lv->lv_iovecp;
 	struct xlog_op_header	*oph = vec->i_addr;
 	int			len;
 
@@ -69,7 +73,7 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
 	vec->i_len = len;
 
 	/* Catch buffer overruns */
-	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv->lv_size);
+	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lvec + lv->lv_size);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f51cbc6405c1..3be9f86ce655 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -219,8 +219,7 @@ static inline int
 xlog_cil_iovec_space(
 	uint	niovecs)
 {
-	return round_up((sizeof(struct xfs_log_vec) +
-					niovecs * sizeof(struct xfs_log_iovec)),
+	return round_up(niovecs * sizeof(struct xfs_log_iovec),
 			sizeof(uint64_t));
 }
 
@@ -279,6 +278,7 @@ xlog_cil_alloc_shadow_bufs(
 
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		struct xfs_log_vec *lv;
+		struct xfs_log_iovec *lvec;
 		int	niovecs = 0;
 		int	nbytes = 0;
 		int	buf_size;
@@ -339,18 +339,23 @@ xlog_cil_alloc_shadow_bufs(
 			 * the buffer, only the log vector header and the iovec
 			 * storage.
 			 */
-			kvfree(lip->li_lv_shadow);
-			lv = xlog_kvmalloc(buf_size);
-
-			memset(lv, 0, xlog_cil_iovec_space(niovecs));
+			if (lip->li_lv_shadow) {
+				kvfree(lip->li_lv_shadow->lv_iovecp);
+				kvfree(lip->li_lv_shadow);
+			}
+			lv = xlog_kvmalloc(sizeof(struct xfs_log_vec));
+			memset(lv, 0, sizeof(struct xfs_log_vec));
+			lvec = xlog_kvmalloc(buf_size);
+			memset(lvec, 0, xlog_cil_iovec_space(niovecs));
 
+			lv->lv_flags |= XFS_LOG_VEC_DYNAMIC;
 			INIT_LIST_HEAD(&lv->lv_list);
 			lv->lv_item = lip;
 			lv->lv_size = buf_size;
 			if (ordered)
 				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
 			else
-				lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
+				lv->lv_iovecp = lvec;
 			lip->li_lv_shadow = lv;
 		} else {
 			/* same or smaller, optimise common overwrite case */
@@ -366,9 +371,9 @@ xlog_cil_alloc_shadow_bufs(
 		lv->lv_niovecs = niovecs;
 
 		/* The allocated data region lies beyond the iovec region */
-		lv->lv_buf = (char *)lv + xlog_cil_iovec_space(niovecs);
+		lv->lv_buf = (char *)lv->lv_iovecp +
+				xlog_cil_iovec_space(niovecs);
 	}
-
 }
 
 /*
@@ -502,7 +507,7 @@ xlog_cil_insert_format_items(
 			/* reset the lv buffer information for new formatting */
 			lv->lv_buf_len = 0;
 			lv->lv_bytes = 0;
-			lv->lv_buf = (char *)lv +
+			lv->lv_buf = (char *)lv->lv_iovecp +
 					xlog_cil_iovec_space(lv->lv_niovecs);
 		} else {
 			/* switch to shadow buffer! */
@@ -1544,6 +1549,7 @@ xlog_cil_process_intents(
 		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
 		trace_xfs_cil_whiteout_mark(ilip);
 		len += ilip->li_lv->lv_bytes;
+		kvfree(ilip->li_lv->lv_iovecp);
 		kvfree(ilip->li_lv);
 		ilip->li_lv = NULL;
 
-- 
2.39.3


