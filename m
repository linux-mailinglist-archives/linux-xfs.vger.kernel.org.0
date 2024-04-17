Return-Path: <linux-xfs+bounces-7087-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB19C8A8DC4
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 23:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9709F281820
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 21:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3044AEE1;
	Wed, 17 Apr 2024 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zh2hFI+0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE39D38382
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389000; cv=none; b=Do8YCSwot+HSiWMmJ14mLeJfpU8BQ0wy3RbNjdJkkAERLdWBioQSo4O4Ix4LY3QB23RdY6xFL6M5iUndmFWr0HpXOoBmDRnE8RZVJOtG+7ZiS6zhYBIcfFrsuWMBlxXKcXaWlTfN6zxmWwrSPK1Ey5JVztRXgDXiPK1qWNOSGh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389000; c=relaxed/simple;
	bh=k4Ps62yyjxAGf65Wno/Y8MfKXCKMj/TyAtgByv7Wh2Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MSbDOgjPsW0w/AEKxEnokRji7V5OIX//ffC/PxbaI9rK9BUA8uWjhJasdIWaQNPQUabLHU1IYveiqHu5ToDeL8+aRZtzbYfmERUnMfn49pdJF0n6WbXWRbhlAYFvWE0TUjniyppRZVx0yFJRDpWlNdlWa1ZPyPFArF4qg8ply3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zh2hFI+0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA066C072AA;
	Wed, 17 Apr 2024 21:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389000;
	bh=k4Ps62yyjxAGf65Wno/Y8MfKXCKMj/TyAtgByv7Wh2Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zh2hFI+0G65LHA3kpxwsTyfF0yK4G30DGy714RU3Bqu/ct43WzRJLRu5fW6g7McNo
	 sscZGjC7kYzQe5LEQi3Oe4H+OIXygcvHiD10p2Pd7P2R9ENhpu0JAIQCXh/bU+v2Y6
	 AUiNyroad0Tvm0uQCfHZxsAZ7XaSMAOn2b3NvHU/jyi6CSUXXScg77E0Vsd4rcA6nu
	 AiygAT/lWOttLZgJHJmgi5tP4mZPtEIj6is9RLHzdqceHuS12qM9Lwfqc1h+175bC5
	 sds0SpWcp6DqRdRrwPE1A609vyv35mqT7rJ8uljqoZSpf6hhoCuKfje5BkJrTh5Y+g
	 ora/GrJCIESsg==
Date: Wed, 17 Apr 2024 14:23:20 -0700
Subject: [PATCH 06/67] xfs: hoist ->create_intent boilerplate to its callsite
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842430.1853449.7067969541733192719.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: f3fd7f6fce1cc9b8eb59705b27f823330207b7c9

Hoist the dirty flag setting code out of each ->create_intent
implementation up to the callsite to reduce boilerplate further.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 6a9ce9241..1be9554e1 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -235,6 +235,8 @@ xfs_defer_create_intent(
 	if (IS_ERR(lip))
 		return PTR_ERR(lip);
 
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_intent = lip;
 	return 1;
 }


