Return-Path: <linux-xfs+bounces-31009-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4IPRAROnlmmTiQIAu9opvQ
	(envelope-from <linux-xfs+bounces-31009-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:00:51 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F49B15C43D
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B9E93020A50
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FEC92BEFFB;
	Thu, 19 Feb 2026 06:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4mfvqpQ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8EA21FF33;
	Thu, 19 Feb 2026 06:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480848; cv=none; b=N01F1tCvp+mI7/CgFoheaeHvY3Jr0Hg7WCUyh/4K3OxJzp3phrbecRIH4QGbzBA+H6uGAgXxoqvy43e/+JdvZmeuq2fLDZI421B3gyGC5phmiVyHpraOfq/aUiHlM3A0A4e4j7wLftNHs6aHYtyIFrs2f7JWajILPjE0Nt7SSkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480848; c=relaxed/simple;
	bh=ycByYo3VrFargZA4slJ9PqgwcdopS0X5eJ6NupY0x1Q=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=H31/pKRXrGu0VXhTebAhm2YcY9O+9euo2ndZ1Gl/QrQVR1FW27qigxdjseOrDkuIFBNXHmxhEwhHtgFNp35fTIEk71dSZxQsmH6l6G3hmWv6/hgyQ/NEoZbrI5jZWpBIaADcUQRVAFRCE12imbRs8Dxy3Zfgs8hJjiHpBWz4oYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4mfvqpQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB320C4CEF7;
	Thu, 19 Feb 2026 06:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480848;
	bh=ycByYo3VrFargZA4slJ9PqgwcdopS0X5eJ6NupY0x1Q=;
	h=Date:Subject:From:To:Cc:From;
	b=p4mfvqpQwbBd1nP5zFbJJ7dKcy5rbshxB2p3b6ARIsw+2v7GZtHeZUECzEbh+/s8w
	 NvnuhOthLWQBPbvXHWP3b+6mGYHnMl65+4s6Fzz7/HUg9n6dqgbzzkrnJnXNgleNTF
	 P76QhoJ5VycQXP2l2wPAhQlek9ZQIxnWq8l2iqyfGMXQpdTzZW3435jhzPBfy++UU6
	 so4dC5HHaUluXMqW7KZ763fSFZRyUtTI4+cK8Oagz8wNNsUllc6akofKVoZ+8gGARz
	 5jhUzsoo2Z67SfLGbagFWwZ3KKoLmVyTttFAvYHEo/yyY0s6nXqez0jrgXK2Z3Bjz2
	 WNmFI1CWxRIeg==
Date: Wed, 18 Feb 2026 22:00:47 -0800
Subject: [PATCHSET 1/2] xfs: bug fixes for 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: clm@meta.com, stable@vger.kernel.org, samsun1006219@gmail.com,
 pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org
Message-ID: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[meta.com,vger.kernel.org,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-31009-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5F49B15C43D
X-Rspamd-Action: no action

Hi all,

Bug fixes for 7.0.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-7.0
---
Commits in this patchset:
 * xfs: fix copy-paste error in previous fix
 * xfs: fix xfs_group release bug in xfs_verify_report_losses
 * xfs: fix xfs_group release bug in xfs_verify_report_losses
 * xfs: fix potential pointer access race in xfs_healthmon_get
 * xfs: don't report metadata inodes to fserror
 * xfs: don't report half-built inodes to fserror
---
 fs/xfs/xfs_mount.h          |    2 +-
 fs/xfs/scrub/dir_repair.c   |    2 +-
 fs/xfs/xfs_health.c         |   20 ++++++++++++++++++--
 fs/xfs/xfs_healthmon.c      |   10 ++++++----
 fs/xfs/xfs_icache.c         |    9 ++++++++-
 fs/xfs/xfs_notify_failure.c |    4 ++--
 fs/xfs/xfs_verify_media.c   |    4 ++--
 7 files changed, 38 insertions(+), 13 deletions(-)


