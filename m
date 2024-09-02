Return-Path: <linux-xfs+bounces-12568-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A00FC968D59
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Sep 2024 20:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D1D12827A3
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Sep 2024 18:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36F95680;
	Mon,  2 Sep 2024 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeQwatmM"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BDB19CC0D
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301513; cv=none; b=koileYt6XHR/UHBkB2u9wlTQW5TzGEpbQpw6HwT/XuthwpeHJ5KqpnYPeGfO97+c+QypiHGApW1EV/LPGfHTBE6nBIlN2xq1aqlupATiSm6ZICcF7dQmBLvsrRJ/ROSyGTJQhplyAy3pK08bRH9XFWhbRsiBPWpl7pNO9Xr+txA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301513; c=relaxed/simple;
	bh=cUbGGxmKXf2I5Bw3QtVnXAU3/G5jMcQr4/6Vb4vRsjk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nju3N/GzRJP+eNHjk3o1OR+5RIupbyZSWrAy4aKY2z6yFcWeMxjaEqqLWJpQDvDGLaYW5XcOP/Hsv08opkbYUvV+bufg2KP+979BtL0S+OwASMgbe0QRlml18yb8iD14/anw/cORpcz6GgLKbte+cyk7mCwDwy7bBnrRicm8nlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeQwatmM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAF2C4CEC2;
	Mon,  2 Sep 2024 18:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301513;
	bh=cUbGGxmKXf2I5Bw3QtVnXAU3/G5jMcQr4/6Vb4vRsjk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eeQwatmMJQTJrYHk8VlVcQ8isP3A9gDMMlb9eWB++xTJwkSQ86gUW6eoyf0Q1xFOC
	 yASOvMo3GLO6ReN+v6QMj37vPFrAp/a3YbESqnGuoWrsuCkZbN3rphprjJpMLpZh7T
	 AAwAj5Spnoiq8E4exUzJ7m6aaBgFbWDIb0a79cmMTNNm30rzMwSJqx4a7TAM+t+3TR
	 DkbaYYf76ICeC8vn3MDBEsEC1MI6zE7y8zSoJReAPEl1Uwe2FUqlUDcEtNwQ2Rk/9D
	 eFaovPeoSEBla62zrER55+n9yBZFqJvJw1KbOCBlkt8Tu3EOvi4ZEuGmJtbp1MTWVN
	 TYuBVK3Ar0ZyA==
Date: Mon, 02 Sep 2024 11:25:12 -0700
Subject: [PATCH 05/12] xfs: assert a valid limit in xfs_rtfind_forw
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105798.3325146.17687169972955086973.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
References: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Protect against developers passing stupid limits when refactoring the
RT code once again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9feeefe53948..4de97c4e8ebd 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -315,6 +315,8 @@ xfs_rtfind_forw(
 	xfs_rtword_t		incore;
 	unsigned int		word;	/* word number in the buffer */
 
+	ASSERT(start <= limit);
+
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */


