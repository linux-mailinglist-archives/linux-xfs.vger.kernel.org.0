Return-Path: <linux-xfs+bounces-15840-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 190349D84CA
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Nov 2024 12:50:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D290228B8B2
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Nov 2024 11:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EE61A01C3;
	Mon, 25 Nov 2024 11:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ERefo9b7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D961A01BE
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 11:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535217; cv=none; b=kJUWDyH6VMjvYs9RiF98Rel8fuYPuzYf3hUNZac4Qe62KAP78dfFtVubBUzQlNhQht1LM3kY0rklc6yVc9uGnIGxUHcQKq9Pz0QjY7EBHhtAWcbKtl9rQlXXKK6L/wi4KggSF1Z1/TfM/aFxKpQZZQRccSeYmjRpvdbOkVLh+jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535217; c=relaxed/simple;
	bh=Kcr1FsBWESgHtClUN59yVKGGBUO05yTyoIQEbswZnGE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=r2ppGxKjPnHQWBlcOmO0mR/NygyOMcSDmU+azuXh8a4TfpAEp/IaMCi3ztavNksXa2wzX1+vNg7U8+i17dInSdqWQqr3LmtSc5+RNYEtAzYlKyHYebFS/hdXThkpkM43mYFV3/2QSfcavlClEP14ssigI4xQO059C5RCk/TtNj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ERefo9b7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056A2C4CECE
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732535216;
	bh=Kcr1FsBWESgHtClUN59yVKGGBUO05yTyoIQEbswZnGE=;
	h=Date:From:To:Subject:From;
	b=ERefo9b7PW7+TrqD41FfkhzwNReUlmLAxk51n5Qo8ZppknWJcMSwULmPzQPDNqNfo
	 Ivoyqzv8hbQ/2piSZSIxIlN1TBszCkqxpiZg4p2dSXNx9YXNItCh97rtK5clwOrYuQ
	 x2rkQ2hAoiaOLW8SwL2U+B3Am4V11xlj03hY3zSQYBYs11i97V0sNfT3bBEXhgUZ4d
	 iX9/t072lmNBS08OUDML7Ye6L4AhXhgjloS+YUoiKmffcPzJ3ZWZfjMRoUCG9dmz3N
	 sMNRfkHVqmBnLkFMMmU5L1SFgcbAVBQxNuY2QjAn1F7OrW2h0B7S62mvfWfXInzhBn
	 osvUROV14KzPg==
Date: Mon, 25 Nov 2024 12:46:52 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to a8581099604d
Message-ID: <medvw2k7ii2gwyk3urggz4aq7l7yutpdc7m672dwwjf2ddjf3m@wazf2t46tgby>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

Beyond xfs patches, this also update for-next to be closer to Linus's ToT.

The relevant XFS patches are follows...


The new head of the for-next branch is commit:

a8581099604d xfs: prevent mount and log shutdown race

5 new commits:

Dave Chinner (3):
      [13325333582d] xfs: fix sparse inode limits on runt AG
      [c9c293240e43] xfs: delalloc and quota softlimit timers are incoherent
      [a8581099604d] xfs: prevent mount and log shutdown race

Long Li (2):
      [45f69d091bab] xfs: eliminate lockdep false positives in xfs_attr_shortform_list
      [652f03db897b] xfs: remove unknown compat feature check in superblock write validation

Code Diffstat:

 fs/xfs/libxfs/xfs_ialloc.c | 16 +++++++++-------
 fs/xfs/libxfs/xfs_sb.c     |  7 -------
 fs/xfs/xfs_attr_list.c     |  3 ++-
 fs/xfs/xfs_log.c           | 11 +++++++++++
 fs/xfs/xfs_log_priv.h      |  1 +
 fs/xfs/xfs_qm_syscalls.c   | 13 -------------
 6 files changed, 23 insertions(+), 28 deletions(-)

