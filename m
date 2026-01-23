Return-Path: <linux-xfs+bounces-30188-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDAGBqUcc2mwsAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30188-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 08:00:53 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E11F71531
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 08:00:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 59BB63014846
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 07:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7285C32C31D;
	Fri, 23 Jan 2026 07:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSImyq00"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E018318EDE;
	Fri, 23 Jan 2026 07:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151645; cv=none; b=YbKKoeP/pLDI5yf37WZPPygtSw6oXePZ9M3/XQghEJHYjFDgt+F63drdKWy8i9Xa3Ga0HILyn+b+sSKtlc3lZHAJTbvqWuzDMPlgMfbNn+szpKlfQNkj1xlmNsB2B/Wvh8shUfd+gjX4G09bwxUkUrEhpZzisIB7ZaB0BT2h74E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151645; c=relaxed/simple;
	bh=KQjAYbXC+JrVV4sPRWLsWYskPn/EuEQytpgssjMmGWw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ZCS9ZaykTvDITQqy1X3KvtVxdve357ulrnuFa2y8My6rWv3wqKe0y4Sm0s6kvvuMDFLdluGFfjjvXtzcmEBEJvR7PLFHhNIy3wIc/71DevftUdz8dylOlncpBgkrIC87lAiBeJez71GnhCa/TY5gKh+G0mU0GKr667XB8JDqxJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSImyq00; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E07C4CEF1;
	Fri, 23 Jan 2026 07:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151644;
	bh=KQjAYbXC+JrVV4sPRWLsWYskPn/EuEQytpgssjMmGWw=;
	h=Date:Subject:From:To:Cc:From;
	b=WSImyq00vsiUs7jTm3hl28TkMmgSGoAlSUqMMssrkUSFuq3fWyScyhgF5TX5gsfC3
	 fjj1q9n+NrwXmiWfNQHjAt1sK3dXYf1WvAc+KXh+ic27n3P7ZgFYof2KGfyvnDpCMq
	 s6ikfoZgIAqt1re3JKGbxC7y7DWsI4VlH2JKRK0VaOEIaXvsG/88hnVFJ43BiuQx7n
	 5Cogxu21WhOZqSvTZFwrfYFoqIy2p48S58Qyy4D9phYtT5SD+TLZGkY45La4LntH+x
	 YnGIJTkYWLCT+VoMH0Pf3hSBPJj/Q8CODYb/SF+yxw+lHDe7LqyqyBQc1kRYfuPv/O
	 /DAlYrcxlHGzQ==
Date: Thu, 22 Jan 2026 23:00:44 -0800
Subject: [PATCHSET 1/3] xfs: fix problems in the attr leaf freemap code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176915152981.1677392.17448598289298023614.stgit@frogsfrogsfrogs>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30188-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6E11F71531
X-Rspamd-Action: no action

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


