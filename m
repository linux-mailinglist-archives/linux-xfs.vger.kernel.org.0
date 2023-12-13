Return-Path: <linux-xfs+bounces-708-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E1281220F
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Dec 2023 23:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC6DC1C20FEF
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Dec 2023 22:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A438185A;
	Wed, 13 Dec 2023 22:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8L90V4s"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4DD8184F
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62710C433C7;
	Wed, 13 Dec 2023 22:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702507912;
	bh=ygboQEPOL0ZcvnQpYlbMblDKu+qCke/OnHlEp+Rrp5k=;
	h=Date:Subject:From:To:Cc:From;
	b=J8L90V4s7bqzROL0tcUP8BhLXMwz8WVNXDXJH4QTCl8bVYjHPkz0MiHzGLljj9ZMt
	 4JMNT2oh+RQV/U/zJSk69BdGkxcLJ/Xwv+fJNgSCORy2b2xamytVCDMCdl8jz8RHPe
	 BMvWlW8XFzDBx2QHKJXbRBUgFQQ8PKsQVPnceyfnDu80viquYRj/Ua8Myt2PJiHaFw
	 9WoI7ukPsnnd+iQTRbPRAvIsHkRa0UOtF2j54COHkj1d/C2UaBWmLyr7GpTkL8l8em
	 LH2q6oE7gg2PD+OtMAywL5/P9uZWJo+eIDheaW+kb5qUcnSheWjG+7mkCN9ogdDaST
	 HDRzU8WGYIhYg==
Date: Wed, 13 Dec 2023 14:51:51 -0800
Subject: [PATCHSET v28.2 0/4] xfs: online repair of quota and rt metadata
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250784331.1399626.6539338084714476832.stgit@frogsfrogsfrogs>
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

XFS stores quota records and free space bitmap information in files.
Add the necessary infrastructure to enable repairing metadata inodes and
their forks, and then make it so that we can repair the file metadata
for the rtbitmap.  Repairing the bitmap contents (and the summary file)
is left for subsequent patchsets.

We also add the ability to repair file metadata the quota files.  As
part of these repairs, we also reinitialize the ondisk dquot records as
necessary to get the incore dquots working.  We can also correct
obviously bad dquot record attributes, but we leave checking the
resource usage counts for the next patchsets.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quota-6.8
---
 fs/xfs/Makefile             |    9 +
 fs/xfs/libxfs/xfs_format.h  |    3 
 fs/xfs/scrub/dqiterate.c    |  211 ++++++++++++++++
 fs/xfs/scrub/quota.c        |  107 +++++++-
 fs/xfs/scrub/quota.h        |   36 +++
 fs/xfs/scrub/quota_repair.c |  575 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h       |    7 +
 fs/xfs/scrub/scrub.c        |    6 
 fs/xfs/scrub/trace.c        |    3 
 fs/xfs/scrub/trace.h        |   78 ++++++
 fs/xfs/xfs_dquot.c          |   37 ---
 fs/xfs/xfs_dquot.h          |    8 -
 12 files changed, 1026 insertions(+), 54 deletions(-)
 create mode 100644 fs/xfs/scrub/dqiterate.c
 create mode 100644 fs/xfs/scrub/quota.h
 create mode 100644 fs/xfs/scrub/quota_repair.c


