Return-Path: <linux-xfs+bounces-31458-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yGqJNOLGoWkVwQQAu9opvQ
	(envelope-from <linux-xfs+bounces-31458-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Feb 2026 17:31:30 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 604681BAD18
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Feb 2026 17:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3FC9730036E4
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Feb 2026 16:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4808D413253;
	Fri, 27 Feb 2026 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEYtocnD"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16ED44B666
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209811; cv=none; b=nc3KZuUMocEnnoFUsxXKUYVpTd7WyhbZDSlHQCCL4WxpcTH4aAhgzuIp/gtE+MqSTs2ZKc8y46UZbeJtcqXVyumioGW/L62nY3a0d2DjcOhiJsFg2E+Au/Wm7k4pWS+PItWDBfapkJUxP9/8Uudwp6HsbesxC1rz81BFspkAnwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209811; c=relaxed/simple;
	bh=aLjrICa0fzTaclh+oi21X8zSh/NeaGji+W1cxURrtII=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=r5J+U+Fkkoxu73wsa20DTgVBYAp1AH23/N4CC8YK7mcDAwszm4m/VBKYZYHH28LioKXkdb+K+l7oMN17/i4AjNMLa19vWVHbqTz0TlugzcaLWIkIRJWTR5yZX+yFeYg2UvfmEeunKyH9ARev1B7jv36fS7UJjxFXHR2xypv5BNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEYtocnD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982BBC116C6;
	Fri, 27 Feb 2026 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772209811;
	bh=aLjrICa0fzTaclh+oi21X8zSh/NeaGji+W1cxURrtII=;
	h=Date:From:To:Cc:Subject:From;
	b=MEYtocnDO/pCo7NsxGwkGQVoTPOz6F3/Nrm103pJ8ISMoaE1Goe7Z3rjpCAvqDAJ7
	 kiH9ODfpFq1uPSBEXcetP7bP75e95oRoVUaEkToYjp/cL/EzE/Da/jAv31UywJaDeY
	 mMSGdMHxaMnP4+szrTm0H6emDFmo19YcG+hRHDzOaNNa9g9iNLTuLsaEGnGA3VAm+y
	 gw7SZgW3kej450J04lRvbr5n81O2q4KF76RU1yobFMrivGvzXuheapfgdwdc5xVvAd
	 w1YwQnqZg6r3L94m8akGBcX8gGS2nN9xc2qW6PD/LdQTUVmOLlOrnXquGPiPCJHMg/
	 P1g+Y1aMuevcA==
Date: Fri, 27 Feb 2026 17:30:07 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.0-rc2
Message-ID: <aaG7BJKexHHjD-0h@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31458-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 604681BAD18
X-Rspamd-Action: no action

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.
No conflicts.

Nothing reeeally stands out here, but a few bug fixes, some refactoring
to easily fit the bug fixes, and a couple cosmetic changes.

Thanks,
Carlos

"The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.0-rc2

for you to fetch changes up to 650b774cf94495465d6a38c31bb1a6ce697b6b37:

  xfs: add static size checks for ioctl UABI (2026-02-25 13:58:50 +0100)

----------------------------------------------------------------
xfs: fixes for v7.0-rc2

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (2):
      xfs: cleanup inode counter stats
      xfs: remove metafile inodes from the active inode stat

Darrick J. Wong (6):
      xfs: fix copy-paste error in previous fix
      xfs: fix xfs_group release bug in xfs_verify_report_losses
      xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure
      xfs: fix potential pointer access race in xfs_healthmon_get
      xfs: don't report metadata inodes to fserror
      xfs: don't report half-built inodes to fserror

Ethan Tidmore (1):
      xfs: Fix error pointer dereference

Nirjhar Roy (IBM) (7):
      xfs: Replace ASSERT with XFS_IS_CORRUPT in xfs_rtcopy_summary()
      xfs: Refactoring the nagcount and delta calculation
      xfs: Replace &rtg->rtg_group with rtg_group()
      xfs: Fix xfs_last_rt_bmblock()
      xfs: Add a comment in xfs_log_sb()
      xfs: Update lazy counters in xfs_growfs_rt_bmblock()
      xfs: Add comments for usages of some macros.

Wilfred Mallawa (3):
      xfs: fix code alignment issues in xfs_ondisk.c
      xfs: remove duplicate static size checks
      xfs: add static size checks for ioctl UABI

 fs/xfs/libxfs/xfs_ag.c        | 28 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h        |  3 +++
 fs/xfs/libxfs/xfs_inode_buf.c |  4 ++++
 fs/xfs/libxfs/xfs_metafile.c  |  5 +++++
 fs/xfs/libxfs/xfs_ondisk.h    | 52 ++++++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_sb.c        |  3 +++
 fs/xfs/scrub/dir_repair.c     |  2 +-
 fs/xfs/scrub/orphanage.c      |  7 +++++-
 fs/xfs/xfs_fsops.c            | 17 ++------------
 fs/xfs/xfs_health.c           | 20 +++++++++++++++--
 fs/xfs/xfs_healthmon.c        | 11 +++++----
 fs/xfs/xfs_icache.c           | 18 +++++++++++----
 fs/xfs/xfs_mount.h            |  2 +-
 fs/xfs/xfs_notify_failure.c   |  4 ++--
 fs/xfs/xfs_platform.h         |  9 ++++++++
 fs/xfs/xfs_rtalloc.c          | 44 ++++++++++++++++++++++++++++++------
 fs/xfs/xfs_stats.c            | 17 +++++++++-----
 fs/xfs/xfs_stats.h            | 19 ++++++++--------
 fs/xfs/xfs_super.c            |  4 ++--
 fs/xfs/xfs_verify_media.c     |  4 ++--
 fs/xfs/xfs_zone_alloc.c       |  6 ++---
 fs/xfs/xfs_zone_gc.c          | 10 ++++-----
 22 files changed, 209 insertions(+), 80 deletions(-)"

