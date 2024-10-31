Return-Path: <linux-xfs+bounces-14852-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 874609B86A4
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Nov 2024 00:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 433F028541E
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Oct 2024 23:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233291D0E0D;
	Thu, 31 Oct 2024 23:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StD4R8Lt"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D251CF280
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416106; cv=none; b=APG11b7eeErti/2yv1mh3jYsW1sQsZ2lmK252/Si4XsLp1v4I7jYXKyAmViOu8rnbKpyNF9L+cOE2Lc4A9L8q81Zh2ei3bKEQFWLxQ+zJBlJ+xoeoj2NjtSq0tCxxiwZv8zxtC67zbIFPKwu2jRaugNoca8/mOgdYMIGFZOnlBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416106; c=relaxed/simple;
	bh=/C5oJOe0qaEB8wnJsCun3Kr7BbmGvZ8465Vdte6LeSk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYFW0Xrw8e2LSbp2IlMqAEmdBSrH0A3YiZ/iTy9hqQrKhBwM82Re+NEsm6wx6W3ow4PxzWl1QpvF1m9kYSHMrm/vL8AeAg9Q+pyjxBQ96F1LsZnnsKTqgt2xR7mdCmvHRuf1BD56zQD+IeeXxGZ0wyOXeDD7dbxkmAJouKSWzgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StD4R8Lt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA93C4CECF;
	Thu, 31 Oct 2024 23:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416106;
	bh=/C5oJOe0qaEB8wnJsCun3Kr7BbmGvZ8465Vdte6LeSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=StD4R8LtC6ZNrWmYAgj4o/ZeHgallLnW23y7SIVM7ANjzfazym0EMhB0tjsBXNIqj
	 veZisWr5lxHAcfTT8a/LGYi02U5R0hD82u1bohS1c802rQrEOKLJSIkgx0cr16eJXf
	 EpNKeICjE6WSwdGYzDFfgMuTEipho5AdP6mhqjHB6TgHJ57KlPCu1IpbdAiD7xUQQ2
	 l5h5WnxVgEW1F0VvE4CNVkbCDXZr47NzM7EJLJaBjsOKamettNU5egya88XJK6Z6sC
	 kjEBHkwED8xCGzmPkogV73d0qKyd29Pwt3+WoG7XAoJ3z4svxw3BDPUuImpWKxW9Xs
	 bO1IhyS45nXTg==
Date: Thu, 31 Oct 2024 16:08:26 -0700
Subject: [PATCHSET v31.3 6/7] xfs_scrub_all: bug fix for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173041568502.964875.8254188626760061825.stgit@frogsfrogsfrogs>
In-Reply-To: <20241031225721.GC2386201@frogsfrogsfrogs>
References: <20241031225721.GC2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix a problem with xfs_scrub_all mistakenly thinking that a service finished
before it really did.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fixes-6.12
---
Commits in this patchset:
 * xfs_scrub_all: wait for services to start activating
---
 scrub/xfs_scrub_all.in |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)


