Return-Path: <linux-xfs+bounces-256-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F5297FD039
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 08:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40DF31C209F6
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 07:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFD1111B8;
	Wed, 29 Nov 2023 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Oz13soOz"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A061BC1
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 23:59:40 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1cfc1512df1so26892345ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 23:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701244779; x=1701849579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78NIK428pGiojxSDNWuMJ5fRqtEcCx+gV7bFdG2Ovq8=;
        b=Oz13soOzsu6BHrc4+0u8Jjs6cj1lFEupiVtcNlaEuJxlneeI3NdrWvXA5QCOo5TIVp
         Tv46PBCTX/i+zGfYsUSfGZ547snaTTtMr3RnNSKfo6hqERJkZYW0Zgt4dFeo9qBGVeym
         fQha9NE/YyGLCCQnfeaD5jb6/RX6pkOKQRyXRCwSW41EFMJlbSOtw/oPNuBJbP67hAij
         q3WhTBERAmWxrb4Bgq8klNw+XQb3UgUnxiFyAidLqR9xLMTaZ4hmenOBMxdUIUT+3e0y
         /Ny11Talta+e6fQPtZZIyyYQAUyw+drRi7UgRtIzYcp46TEI5sLE7tMAH/C7AHFLdUG7
         LTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701244779; x=1701849579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=78NIK428pGiojxSDNWuMJ5fRqtEcCx+gV7bFdG2Ovq8=;
        b=pV3GOwxqufyhEr1uEs7TW4DL2ETLDCKhMI3Sj0r0W4JIS8y+qFc8MfV1X7TL/cH/0b
         8euQq4sl4TKHJRsVhM0xIsllnMU6vHPFgg+TgR8wad3YDvNgYpGLeGVR8SHcoxG1JJeF
         E6N+f0ROKulw1r7Qg1G6NnPyzidicd4sh1rqVOCppd7vwLCC6pasa2wBs4HfkQqhrn1b
         135iGBYGX4pcS/Hd4V6x0v8Kxoxp0PtyBEKs0y+37th9eJ4crHs3B4JOIOS+MdTVm25x
         +JfyiEeZ8fvlIT8UMatjQU6EO0djO5sQ9sd/TX2aj5x4QOXVHI33FuuK9Bc7sarEpTeq
         qZzw==
X-Gm-Message-State: AOJu0YyMPQ8jI3eLCZiGI/blpgPkplYNIdtZUOpF6eVthT3/b9kUW60s
	lh7AWDrB36S0odXGwirJ0TLrVg==
X-Google-Smtp-Source: AGHT+IEAGtGte403VceLMAhkoD5W57e2RDirElbea/DiY0S0ovB97/9LItu+U0AO+5U1dkuRbbSEhA==
X-Received: by 2002:a17:903:48c:b0:1cf:b3ed:817 with SMTP id jj12-20020a170903048c00b001cfb3ed0817mr13667907plb.20.1701244779597;
        Tue, 28 Nov 2023 23:59:39 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id s17-20020a170902989100b001cfd0ddc5d3sm4979419plp.277.2023.11.28.23.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 23:59:39 -0800 (PST)
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>,
	Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com,
	me@jcix.top,
	Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 1/2] xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real
Date: Wed, 29 Nov 2023 15:58:31 +0800
Message-Id: <20231129075832.73600-2-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20231129075832.73600-1-zhangjiachen.jaycee@bytedance.com>
References: <20231129075832.73600-1-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the case of returning -ENOSPC, ensure logflagsp is initialized by 0.
Otherwise the caller __xfs_bunmapi will set uninitialized illegal
tmp_logflags value into xfs log, which might cause unpredictable error
in the log recovery procedure.

Also, remove the flags variable and set the *logflagsp directly, so that
the code should be more robust in the long run.

Fixes: 1b24b633aafe ("xfs: move some more code into xfs_bmap_del_extent_real")
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index be62acffad6c..9435bd6c950b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5010,7 +5010,6 @@ xfs_bmap_del_extent_real(
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
 	int			do_fx;	/* free extent at end of routine */
 	int			error;	/* error return value */
-	int			flags = 0;/* inode logging flags */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -5023,6 +5022,8 @@ xfs_bmap_del_extent_real(
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
 
+	*logflagsp = 0;
+
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
 
@@ -5048,10 +5049,12 @@ xfs_bmap_del_extent_real(
 	if (tp->t_blk_res == 0 &&
 	    ifp->if_format == XFS_DINODE_FMT_EXTENTS &&
 	    ifp->if_nextents >= XFS_IFORK_MAXEXT(ip, whichfork) &&
-	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
-		return -ENOSPC;
+	    del->br_startoff > got.br_startoff && del_endoff < got_endoff) {
+		error = -ENOSPC;
+		goto done;
+	}
 
-	flags = XFS_ILOG_CORE;
+	*logflagsp = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
@@ -5093,9 +5096,9 @@ xfs_bmap_del_extent_real(
 		xfs_iext_prev(ifp, icur);
 		ifp->if_nextents--;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
@@ -5114,7 +5117,7 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
@@ -5128,7 +5131,7 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
@@ -5150,7 +5153,7 @@ xfs_bmap_del_extent_real(
 		new.br_state = got.br_state;
 		new.br_startblock = del_endblock;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_update(cur, &got);
 			if (error)
@@ -5191,7 +5194,7 @@ xfs_bmap_del_extent_real(
 				 * to the original value.
 				 */
 				xfs_iext_update_extent(ip, state, icur, &old);
-				flags = 0;
+				*logflagsp = 0;
 				error = -ENOSPC;
 				goto done;
 			}
@@ -5200,7 +5203,7 @@ xfs_bmap_del_extent_real(
 				goto done;
 			}
 		} else
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 
 		ifp->if_nextents++;
 		xfs_iext_next(ifp, icur);
@@ -5240,7 +5243,6 @@ xfs_bmap_del_extent_real(
 		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
 
 done:
-	*logflagsp = flags;
 	return error;
 }
 
-- 
2.20.1


