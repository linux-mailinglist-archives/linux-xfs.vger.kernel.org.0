Return-Path: <linux-xfs+bounces-29974-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKdnF6FzcGlSYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-29974-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:35:13 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 06694521AA
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6A2986890BB
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC614418E7;
	Wed, 21 Jan 2026 06:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6k40hss"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DFD44A702;
	Wed, 21 Jan 2026 06:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977295; cv=none; b=KRgISyH4tjMvwh+fjuomvaVy/8dcLQiwGacournrO9jBCW3Gg3uitB7YZ++wk6DE5YY6Pm2rH8YVMjXMXs9AcRDihwDHu1cPVW+v0fEKqywCmHtZqNG0RtAOTNAufSW3Yx4H0s8uPwVTg4g4CvYyMs7L7oh8uUm8FS5LKGe4Ayg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977295; c=relaxed/simple;
	bh=KQjAYbXC+JrVV4sPRWLsWYskPn/EuEQytpgssjMmGWw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=jGBEmyLIsBvK4OpeG1ahTgDKT2//Cj0J/oyN+vhnqUqBA80PyDHouEulBZsHemwQctaOrZNtqEg7KNRwzkrpAE0y0YjlrnMgUXUYctJD66S6KzqN9ZcQ0QE8H7By+tLvxQuRBT+t4i0LYgY2M5a/3zObJKsVj2JfPakf16E+hPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6k40hss; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D3EC116D0;
	Wed, 21 Jan 2026 06:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977294;
	bh=KQjAYbXC+JrVV4sPRWLsWYskPn/EuEQytpgssjMmGWw=;
	h=Date:Subject:From:To:Cc:From;
	b=C6k40hssj2z83uVmZYgA8hMyWeUjcigmsW9QnBSep5XPG4C9asYw6KN2FXzkC9DXc
	 BgNRqpjIZ6Ypd3a7ikV+UvsMaWX1Aryt2tBZxPoRNI92LG4rspcXTq3KLgv2iS2WW+
	 3pgD+BdllB9oZUcPHJmavhqnLG9JmZbC+qpmISQw8W8exh16YV2iIEe+mKrdRRTqft
	 y2XDUYHo7Y4aa5ImkVlcYsSUJT9NJWdZf6cOt/KCqPDRk6UfUxF714bH9JjvSs1hAF
	 +LV9hmikx4iI9M/O11Tu2W8087zAKdr88AuIuMi8xMuJWIV5pLiTIHrX9+FguREJmt
	 J8OeeCcXgjh9Q==
Date: Tue, 20 Jan 2026 22:34:53 -0800
Subject: [PATCHSET 2/3] xfs: fix problems in the attr leaf freemap code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	TAGGED_FROM(0.00)[bounces-29974-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 06694521AA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi all,

Running generic/753 for hours revealed data corruption problems in the
attr leaf block space management code.  Under certain circumstances,
freemap entries are left with zero size but a nonzero offset.  If that
offset happens to be the same offset as the end of the entries array
during an attr set operation, the leaf entry table expansion will push
the freemap record offset upwards without checking for overlap with any
other freemap entries.  If there happened to be a second freemap entry
overlapping with the newly allocated leaf entry space, then the next
attr set operation might find that space and overwrite the leaf entry,
thereby corrupting the leaf block.

Fix this by zeroing the freemap offset any time we set the size to zero.
If a subsequent attr set operation finds no space in the freemap, it
will compact the block and regenerate the freemaps.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=attr-leaf-freemap-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=attr-leaf-freemap-fixes
---
Commits in this patchset:
 * xfs: delete attr leaf freemap entries when empty
 * xfs: fix freemap adjustments when adding xattrs to leaf blocks
 * xfs: refactor attr3 leaf table size computation
 * xfs: strengthen attr leaf block freemap checking
 * xfs: fix the xattr scrub to detect freemap/entries array collisions
 * xfs: fix remote xattr valuelblk check
---
 fs/xfs/libxfs/xfs_da_format.h |    2 -
 fs/xfs/libxfs/xfs_attr_leaf.c |  157 ++++++++++++++++++++++++++++++++---------
 fs/xfs/scrub/attr.c           |   59 ++++++++-------
 3 files changed, 155 insertions(+), 63 deletions(-)


