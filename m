Return-Path: <linux-xfs+bounces-8590-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EEEC8CB994
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 05:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37E91282871
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 03:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F2937144;
	Wed, 22 May 2024 03:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHpiENvC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E3B33F9
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347739; cv=none; b=kXt09Zqy+jAQjw7YJaM6ro3VjnfsZHkrMJ/Fx5ByHeOA5vRh65lcVk38npdRpD4PR+/Gns1u+AoHX3cGKQT4OrQiCYCEaYiT/PhbqKUv3e80mM01L50KKocixkgJfpDs1s+r12GSROqQkRHOlYIafOuQOxBiq14cbfEVQqXZpfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347739; c=relaxed/simple;
	bh=UTrK1yYFlObUL54gnPHieNxsIRPm98uilZV68QyqFys=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKSyOoYoHuLMRiFuCC9VH/ZvXMQWoYqpChTXCMoUoUqRTGoIwrAjQbNwbYTYUHMaJsDxG/k06gSKCGrWsFLqAjWOAixcWeifX6CfIWt/v564PTKCayC6bMseN4kJhXXNNaCvJLWVKvi7bEdwlGRqFdlEypNXvKLplrOv465Tqt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHpiENvC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0F8C32786;
	Wed, 22 May 2024 03:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347738;
	bh=UTrK1yYFlObUL54gnPHieNxsIRPm98uilZV68QyqFys=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iHpiENvC+p3jPQvPvPU6lFighZQAhL6W4mX8Bqa/1srCw46wF9XSfsZyYVoPEn0oX
	 MKliaeq+vWM4xjYYWAeBt3TfXC9OtxMKerP8yrAhkfpuKF+sotycYMVggp3qGm+4WI
	 DkS8Ng7pUchZW8CD5IADOXonWsCDK6DkBlhmU8D5b+Luk+5MTVt8Mq7N2tk7a5EXUV
	 zf/V2qHVzjXeXZvD6wt+FWVmcX+TzvTJHMt+L0KAuCDxnqSitZ5HmWIkwjUOITu1fU
	 P4TX4kDLxO9GEnENwieViHR2qYDFJIkIC6d5e4+piU79vHYFzigJKVlvLoQ4Idyone
	 vwy8m/LUQuj/g==
Date: Tue, 21 May 2024 20:15:38 -0700
Subject: [PATCH 103/111] xfs: add a realtime flag to the bmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533248.2478931.2994984543256310019.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 7302cda7f8b08062b11d2ba9ae0b4f3871fe3d46

Extend the bmap update (BUI) log items with a new realtime flag that
indicates that the updates apply against a realtime file's data fork.
We'll wire up the actual code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_log_format.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 269573c82..16872972e 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -838,10 +838,12 @@ struct xfs_cud_log_format {
 
 #define XFS_BMAP_EXTENT_ATTR_FORK	(1U << 31)
 #define XFS_BMAP_EXTENT_UNWRITTEN	(1U << 30)
+#define XFS_BMAP_EXTENT_REALTIME	(1U << 29)
 
 #define XFS_BMAP_EXTENT_FLAGS		(XFS_BMAP_EXTENT_TYPE_MASK | \
 					 XFS_BMAP_EXTENT_ATTR_FORK | \
-					 XFS_BMAP_EXTENT_UNWRITTEN)
+					 XFS_BMAP_EXTENT_UNWRITTEN | \
+					 XFS_BMAP_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out an bui log item in the


