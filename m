Return-Path: <linux-xfs+bounces-4253-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E91D58686AE
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Feb 2024 03:18:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25E931C22FBC
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Feb 2024 02:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504EC1EB24;
	Tue, 27 Feb 2024 02:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CXr4MDjT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1212E1EA6E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000270; cv=none; b=WdYj2HYNMVWlIA4lr8PcV4yL927ZSQYf4X8VsrkrtKXyn8W+ALOl2Q+nNDu/fdLF/0dp6jzP9v540+Zc4IrMOzDIoAJg65fJOMd7YMV5x6CoWGpiFp5bjBYQehWKarsns2nEkpgkuSHo2vqZuEKAQjZlXpSUFuJIxyX/jGx/PU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000270; c=relaxed/simple;
	bh=mDcJO+A8XvmfHARYxayx3sYhkqDA7kD0dij/v6eR25M=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=LEaZYvAj+8qEwYy/nWAkKqHIuDxTuVU42nFU/zcRVmFbvm15Jq0+GhEgd+28DCT4BWdEgZSD7ayS3+/3xhfPsLbxXmk2OUwAAxmSotjmjYKKhr9hdwGOnqMlDemoSZwfWRJt+tShbY/X65U0eRadXsbji+xsIKy2T9ZuUAU3sZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CXr4MDjT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AE2C433C7;
	Tue, 27 Feb 2024 02:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000269;
	bh=mDcJO+A8XvmfHARYxayx3sYhkqDA7kD0dij/v6eR25M=;
	h=Date:Subject:From:To:Cc:From;
	b=CXr4MDjTRZItS/mJ09qEOXedPoPEVvmARK9JSoj2aN/VAKKLeOQOWpWvhiBQHh4eg
	 oC7ankYiSm6iOw4V4SfblqQcWD7UmAreP/LbekR6gPB28QtSUW9cses7ZkpmLb7Bv1
	 vQ2TifXd2Rod5HXLHSV61iPWXYRhDIjxgt8R2ZkHMTGtVGZtfAyB0pvPC2C7SYHs2W
	 owMJ2lbN//zYEEhR6PJ0/JJ09EtSVvdjN1Adp/a+oPt93wBUvV3f+iS8e04D2WLizy
	 fgJ/tFGgj26scaIJfNX20bEX/MlS+XjsZv85/NuNCwH4JmzKnVKK3Z9EP2zofbEOAU
	 mLtN0KOwtKDvA==
Date: Mon, 26 Feb 2024 18:17:48 -0800
Subject: [PATCHSET v29.4 01/13] xfs: improve log incompat feature handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900010739.937966.5871198955451070108.stgit@frogsfrogsfrogs>
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

This patchset improves the performance of log incompat feature bit
handling by making a few changes to how the filesystem handles them.
First, we now only clear the bits during a clean unmount to reduce calls
to the (expensive) upgrade function to once per bit per mount.  Second,
we now only allow incompat feature upgrades for sysadmins or if the
sysadmin explicitly allows it via mount option.  Currently the only log
incompat user is logged xattrs, which requires CONFIG_XFS_DEBUG=y, so
there should be no user visible impact to this change.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=log-incompat-permissions
---
Commits in this patchset:
 * xfs: only clear log incompat flags at clean unmount
 * xfs: only add log incompat features with explicit permission
---
 Documentation/admin-guide/xfs.rst                  |    7 +++
 .../filesystems/xfs/xfs-online-fsck-design.rst     |    3 -
 fs/xfs/xfs_log.c                                   |   28 -------------
 fs/xfs/xfs_log.h                                   |    2 -
 fs/xfs/xfs_log_priv.h                              |    3 -
 fs/xfs/xfs_log_recover.c                           |   15 -------
 fs/xfs/xfs_mount.c                                 |   34 ++++++++++++++++
 fs/xfs/xfs_mount.h                                 |    9 ++++
 fs/xfs/xfs_super.c                                 |   12 +++++-
 fs/xfs/xfs_xattr.c                                 |   42 +++-----------------
 10 files changed, 66 insertions(+), 89 deletions(-)


