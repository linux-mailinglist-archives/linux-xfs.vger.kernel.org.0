Return-Path: <linux-xfs+bounces-1217-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE4E2820D36
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF3D51C217CB
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED62BA37;
	Sun, 31 Dec 2023 20:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pJimyTD0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CD2BA22;
	Sun, 31 Dec 2023 20:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B8FC433C8;
	Sun, 31 Dec 2023 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052895;
	bh=nNqJP0gjtDLiJkw9N38yp4Jnkg/8OtT77XaabfaUPg0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pJimyTD0WUXcza3EcyLXD7Z+niMHA1prabmd8Y12x0oPr0IjVIAmajgHWnqBRFwLd
	 DpYAwQVc7fykPKPSEHBk4FLx+QusBGHDcTyRPJCM5owAkt6KBaABkzJ7Px1dzTO5Km
	 pygbFrgy5KVUh4wYoPdPQqRt35en6S/66MBGvYLGCddvqRVwFplLb7HFnq8s5d+mgF
	 +txege1G9lCTy/T9/yw4sHPB3Ms+YSOtyY1WD5DmELUkSDAEAEz6zsYrYFoKa8+CtJ
	 uDkFW49OZQMZJaVwTc5PwAQdvhX9WR2LL1qlexpt9QF7UxfWHrwUIMbj432K2Z9JcW
	 M9dMJhDAM8mdA==
Date: Sun, 31 Dec 2023 12:01:35 -0800
Subject: [PATCHSET v2.0 7/9] fstests: establish baseline for realtime reflink
 fuzz tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032407.1827628.11076526403575631339.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Establish a baseline golden output for the realtime reflink fuzz tests.
This shouldn't be merged upstream because the output is very dependent
on the geometry of the filesystem that is created.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink-baseline
---
 tests/xfs/1539.out |    6 ++++++
 tests/xfs/1540.out |    6 ++++++
 tests/xfs/1541.out |    6 ++++++
 tests/xfs/1542.out |   10 ++++++++++
 tests/xfs/1543.out |    2 ++
 tests/xfs/1544.out |   12 ++++++++++++
 tests/xfs/1545.out |   12 ++++++++++++
 7 files changed, 54 insertions(+)


