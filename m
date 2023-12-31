Return-Path: <linux-xfs+bounces-1175-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFDB820D08
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39E901C2179A
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 19:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF33B66B;
	Sun, 31 Dec 2023 19:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghXRSHev"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675BFB65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF98DC433C7;
	Sun, 31 Dec 2023 19:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052239;
	bh=GQsJ+G1CSQivd4Z6ka7VogJznKk05qaClk1+s4gUyXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ghXRSHevr6Eoudsri+UNfU0ES0R51kkoRLNgazs7SHJ5T8bwLmqCxgt2xNdvP448b
	 V3jTXFq3s/2G20k+Gt4IM3TIK995MscY+aOrsEHyjx4ts6DP2L9csf5qdJM0MAQMj3
	 STzu+16Jt3+6gKqmxAwxWX9RY4WfYAXyL/oyerOA6k+8ICwstzoFqbxOxUXauka44n
	 20k8f2shTh2zBFKG6Re9KUiW8TZAg9EFTJJnjf1vn8LDrgj2aZJGENJZBVA8sbrejE
	 MT98aiqRzf0b6iobPB+VMr1Wtj9c5+nIzdd0nVlDRiKe8f9zqzLrkLiyddZMS53gAo
	 kuOCCZ2nOApsQ==
Date: Sun, 31 Dec 2023 11:50:38 -0800
Subject: [PATCHSET v13.0 2/6] xfsprogs: name-value xattr lookups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

Directory parent pointers are stored as namespaced extended attributes
of a file.  Because parent pointers can consume up to 267 bytes of
space and xattr names are 255 bytes at most, we cannot use the usual
attr name lookup functions to find a parent pointer.  This is solvable
by introducing a new lookup mode that checks both the name and the
value of the xattr.

Therefore, introduce this new lookup mode.  Because all parent pointer
updates are logged, we must extend the xattr logging code to capture the
VLOOKUP variants, and restore them when recovering logged operations.
These new log formats are protected by the sb_incompat PARENT flag, so
they do not need a separate log_incompat feature flag.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-attr-nvlookups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-attr-nvlookups

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=pptrs-attr-nvlookups
---
 db/attrset.c            |    4 +
 libxfs/xfs_attr.c       |   52 +++++++++++++-----
 libxfs/xfs_attr.h       |   32 ++++++++++-
 libxfs/xfs_attr_leaf.c  |   45 +++++++++++++--
 libxfs/xfs_da_btree.h   |   10 +++
 libxfs/xfs_format.h     |    6 ++
 libxfs/xfs_log_format.h |   29 +++++++++-
 logprint/log_redo.c     |  138 ++++++++++++++++++++++++++++++++++++++---------
 logprint/logprint.h     |    6 +-
 9 files changed, 263 insertions(+), 59 deletions(-)


