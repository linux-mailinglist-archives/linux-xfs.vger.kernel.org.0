Return-Path: <linux-xfs+bounces-1173-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 780D9820D06
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9B4D1C21670
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 19:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5935CB667;
	Sun, 31 Dec 2023 19:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h8SKbTZw"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AB6B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A270AC433C8;
	Sun, 31 Dec 2023 19:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052207;
	bh=lUyeh0N5qrImH2sFqlQx1rVz9WNCO58oPgauDB+fMtM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h8SKbTZw2gtgzLJdZdjD00UaP7qnV7FSzyqt+VaUns7nOliXx/ZigkTZ8dM45Sw1w
	 opDxLVTZc+KnAroTqULrky5q7tF8NgCZGlg55KBDGqD26LH+HPX+7wOt18ljTdzoTJ
	 QLLd3tZ9c9nuLrAA4JX9L0RVpiSRdT9akDl6nFoU2HfUUhiEkeeN/gMOnccSRCxaI6
	 nXGaN+iUtrfw1BUs1dzqz9D/FkpDZp2tVrrKYvZD3CnRBhCUdVy4COhbvd/1iMxJOi
	 yoANufU4KWAOtdFkUX4lVg2kxcpW6ay5UjmdPD2u7n7NHjG/mZiMTH5S5TnzdEgjEz
	 4Cb1Bzs4wj7dw==
Date: Sun, 31 Dec 2023 11:50:07 -0800
Subject: [PATCHSET 40/40] xfs_repair: add other v5 features to filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Chandan Babu R <chandan.babu@oracle.com>,
 Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Message-ID: <170405004048.1801995.14994710798555736563.stgit@frogsfrogsfrogs>
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

This series enables xfs_repair to add select features to existing V5
filesystems.  Specifically, one can add free inode btrees, reflink
support, and reverse mapping.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=upgrade-older-features

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=upgrade-older-features
---
 include/libxfs.h     |    1 
 man/man8/xfs_admin.8 |   21 +++++
 repair/globals.c     |    3 +
 repair/globals.h     |    3 +
 repair/phase2.c      |  229 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.c        |    8 +-
 repair/xfs_repair.c  |   33 +++++++
 7 files changed, 294 insertions(+), 4 deletions(-)


