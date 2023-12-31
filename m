Return-Path: <linux-xfs+bounces-1222-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA46820D3B
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2C171F21B8F
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046BFBA2E;
	Sun, 31 Dec 2023 20:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDgACdqy"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3784BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9012BC433C8;
	Sun, 31 Dec 2023 20:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052973;
	bh=tNhmUr7KCbahgy7zQ9xjCjwt6Q6Y0TH3wT9qvssWxps=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CDgACdqypn5Q/dCq+vPJzidbO7mzmzvjCu8rJlNWM/kWA7aLvxJQteRPsw1uiqFuQ
	 caGeMVbfL2V3c4tsipgIjKQk+9IFqyYirWJf1mMux6vtGW8B8hy1jIUj9ZGdxsIwKe
	 isTolp5Rd2r75TG+/fs7E5EPe24YbJkYeQduLkvpdX8ap/avQ7omE2LPW7C+h3rSOn
	 YnzzWcWD6sAlBlX7mypQCoVt7vxhTRVfyNdorYJ62a4YlSse75wLIFwnAmOZJFLcUn
	 sYBa7G3LWJmDbr+cbCNQcteXimdUgyRBeCqr5L9A6bnugpK6xZSWzLd6veOEawvFwJ
	 fY5sfDIXy0kcw==
Date: Sun, 31 Dec 2023 12:02:53 -0800
Subject: [PATCHSET v29.0] xfs-documentation: atomic file updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405035784.1829110.16772887829212783961.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

This patch documents the new log incompat feature and log intent items to
track high level progress of swapping ranges of two files and finish
interrupted work if the system goes down.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-file-updates

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-file-updates

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=atomic-file-updates

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=atomic-file-updates
---
 .../allocation_groups.asciidoc                     |    7 +
 .../journaling_log.asciidoc                        |  111 ++++++++++++++++++++
 design/XFS_Filesystem_Structure/magic.asciidoc     |    2 
 3 files changed, 120 insertions(+)


