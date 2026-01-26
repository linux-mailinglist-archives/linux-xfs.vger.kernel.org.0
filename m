Return-Path: <linux-xfs+bounces-30311-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8DsgLCcWd2k1cAEAu9opvQ
	(envelope-from <linux-xfs+bounces-30311-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jan 2026 08:22:15 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A2BC84CE6
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jan 2026 08:22:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C54433002B52
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jan 2026 07:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FAF2BEC2E;
	Mon, 26 Jan 2026 07:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMvmbk9P"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F292BE04C
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 07:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769412133; cv=none; b=hHoF3Q46JBoPbSgveDcy362+HEs03bqC0u69oET9ksSxz5hK6vlyQjGWQmpJKMQDi3KB4zoMCttpAc6wuGI0y0AE/ALNSdO0Mf0OUcDhQOfVYupim/9VhoBWDKguJQuY/8GxKHZ0M7jwAL/KbwsFncdCReBjRmsPCZxVDIxoPsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769412133; c=relaxed/simple;
	bh=pEu5RnZQTTLIJYXzyTpoHboPnK8wvxZ4wCrgSEm1Ufs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=u39hQvfocJC/lwr254DsBWGeO2Lezf7VJI44R9or0NObta2iwSzlE8zkrU5rARm+GJRPW/qV3bgvvJ7JKrExfv0xnR7hWrWutNwQABmwJWWcD/oya+jlIVzgULJeNMM0/fzn3i0j24ZSpXMLZeYDlY6UG1858RmX4qLjmVGkT0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMvmbk9P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3A1C19421;
	Mon, 26 Jan 2026 07:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769412132;
	bh=pEu5RnZQTTLIJYXzyTpoHboPnK8wvxZ4wCrgSEm1Ufs=;
	h=Date:Subject:From:To:Cc:From;
	b=mMvmbk9PfB09MkduiFZpaSqgUrgaT4CSn+DQN2K7EUq9A9hy0yyqoqPP7zS3RR9Mm
	 IB4akw5r+n/vRtH/pzVvxOyf4dAPNPYnQWZ5MBGMwvlY12Mr4ukHHK5/MRv6Z0iEsE
	 eBaixcffk1oc4lxh0ps0ExHqkhIrhXERHgzFCN36f84Rn3QzbIvIY1pHa27LQvmdYK
	 cOIgocUV/Zb+G03qv4uffmdiwCHSvIm2jj04Qw51tpZEY5pGswIBtyq08BXO3p86TB
	 B09f5thxewWbeSyffsL7ftiFC2NMYCYUXX1rrAUgm13NEaP9DDufpnZERs8PQuguKS
	 3MutxlwvQFkSw==
Date: Sun, 25 Jan 2026 23:22:12 -0800
Subject: [GIT PULL 3/4] xfs: improve shortform attr performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176939848221.2856414.2186658227930504931.stg-ugh@frogsfrogsfrogs>
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
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30311-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1A2BC84CE6
X-Rspamd-Action: no action

Hi Carlos,

Please pull this branch with changes for xfs for 7.0-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit bd3138e8912c9db182eac5fed1337645a98b7a4f:

xfs: fix remote xattr valuelblk check (2026-01-23 09:27:33 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/attr-pptr-speedup-7.0_2026-01-25

for you to fetch changes up to eaec8aeff31d0679eadb27a13a62942ddbfd7b87:

xfs: add a method to replace shortform attrs (2026-01-23 09:27:36 -0800)

----------------------------------------------------------------
xfs: improve shortform attr performance [2/3]

Improve performance of the xattr (and parent pointer) code when the
attr structure is in short format and we can therefore perform all
updates in a single transaction.  Avoiding the attr intent code brings
a very nice speedup in those operations.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: reduce xfs_attr_try_sf_addname parameters
xfs: speed up parent pointer operations when possible
xfs: add a method to replace shortform attrs

fs/xfs/libxfs/xfs_attr.h      |   6 ++-
fs/xfs/libxfs/xfs_attr_leaf.h |   1 +
fs/xfs/xfs_trace.h            |   1 +
fs/xfs/libxfs/xfs_attr.c      | 114 ++++++++++++++++++++++++++++++++++++++----
fs/xfs/libxfs/xfs_attr_leaf.c |  38 ++++++++++++++
fs/xfs/libxfs/xfs_parent.c    |  14 +++---
6 files changed, 157 insertions(+), 17 deletions(-)


