Return-Path: <linux-xfs+bounces-31233-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBDiCGzrnGnlMAQAu9opvQ
	(envelope-from <linux-xfs+bounces-31233-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 01:06:04 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9551801FD
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 01:06:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB9DF304C4B5
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 00:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A86E171CD;
	Tue, 24 Feb 2026 00:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXTPVKrP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A711548C;
	Tue, 24 Feb 2026 00:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771891561; cv=none; b=oQVViaAyTTatDys5EpqfEmdp5sAdngBXYkchUWhU10tgBPDoH5ocYCf3GvlrFdAMHq62h9MCLVBX3h9HQBy7EdjZnTFH22tvTWUUYnd8K7Xqpv2pJeSg1ALrM48bSNF140dBzbvaiVc+wdqkD0ac6Lu7hu9kAw49WhVY8H/U20I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771891561; c=relaxed/simple;
	bh=vbtJlevPu/mxmmVLr9WGyz7+zRTlLOTF04Qgffk3L+Q=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=kpR6wKREvtHpH5SNzSoB5catJTplAfsQ8dvCYE7PWcVmiA3s/IOKZXdgeAgqrUNtjR569QUJ7gJSLv2ZtxwKGyBrSyCkWSyjJzWovJtQRnDDfHmfZnZp5HYEO4BpKI/yjro764nAfDLic6Q20+h+HdGCEMNAT3sKHVkN+6ObGTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXTPVKrP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E73C116C6;
	Tue, 24 Feb 2026 00:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771891561;
	bh=vbtJlevPu/mxmmVLr9WGyz7+zRTlLOTF04Qgffk3L+Q=;
	h=Date:Subject:From:To:Cc:From;
	b=eXTPVKrPopkG0oG9jCUnWzkKWwuslMXku9M8GHj72pQoa4+OHOd1NCwvbonfA8cEL
	 D1S4qw5Sfa7WEArL8YNMH2f/RwsmKE4cOzUYGCHyns8WDk+dUm9xdBLiHDdAwhywwd
	 ZqFjPNG8Ez9Z6z86mloHpayDBSClxzmyzj79BSGP9W2UTu0NDZ4CvmhCvJIij2G9bR
	 g5vZfYkMHSAuui7RcMsF70Wq8OH3vqVxj5P7XAFWm7ekA7QKnbZYO1QFL9v2NwbTOW
	 6AaY9bn07k3tkotnZT8c4nyETscIc9t/Wo6UA3CvOL9QnD5NmY++lk9o9gLuoXKOAD
	 XFNnPIvVBv1Aw==
Date: Mon, 23 Feb 2026 16:06:00 -0800
Subject: [GIT PULL] xfs: bug fixes for 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: clm@meta.com, cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org, p.raghav@samsung.com, pankaj.raghav@linux.dev, samsun1006219@gmail.com, stable@vger.kernel.org
Message-ID: <177189148163.4009522.17296873599093337410.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[meta.com,redhat.com,lst.de,vger.kernel.org,samsung.com,linux.dev,gmail.com];
	TAGGED_FROM(0.00)[bounces-31233-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4E9551801FD
X-Rspamd-Action: no action

Hi Carlos,

Please pull this branch with changes for xfs for 7.0-rc2.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/xfs-fixes-7.0_2026-02-23

for you to fetch changes up to 0e9b4455c7a3765cb16f6ab6dc6f75fd1b71f24f:

xfs: don't report half-built inodes to fserror (2026-02-23 16:03:41 -0800)

----------------------------------------------------------------
xfs: bug fixes for 7.0 [1/2]

Bug fixes for 7.0.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: fix copy-paste error in previous fix
xfs: fix xfs_group release bug in xfs_verify_report_losses
xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure
xfs: fix potential pointer access race in xfs_healthmon_get
xfs: don't report metadata inodes to fserror
xfs: don't report half-built inodes to fserror

fs/xfs/xfs_mount.h          |  2 +-
fs/xfs/scrub/dir_repair.c   |  2 +-
fs/xfs/xfs_health.c         | 20 ++++++++++++++++++--
fs/xfs/xfs_healthmon.c      | 11 +++++++----
fs/xfs/xfs_icache.c         |  9 ++++++++-
fs/xfs/xfs_notify_failure.c |  4 ++--
fs/xfs/xfs_verify_media.c   |  4 ++--
7 files changed, 39 insertions(+), 13 deletions(-)


