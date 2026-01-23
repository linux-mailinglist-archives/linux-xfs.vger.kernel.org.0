Return-Path: <linux-xfs+bounces-30189-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QO3tNCkdc2ngsQAAu9opvQ
	(envelope-from <linux-xfs+bounces-30189-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 08:03:05 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71F2F7158C
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 08:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ACDAA300A315
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 07:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B6C33DEE9;
	Fri, 23 Jan 2026 07:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7ZmGOrI"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFCC33BBB4
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 07:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151651; cv=none; b=ZAaSpHNMsPUNw4k1IJ6bpLfKXb/EbYMKXIWf74beYdXcZL3oMd6rT3Iny/N0BgPjVDY2aZhVVG/wdV92qhi8mYKKNTjvJsMO44xICnC9GZJqPUjYBH00uAfNdHMEHCiJadmIjYhiVnhtESUZVmsYan4tSq/dhBVq5G39Sd5K4hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151651; c=relaxed/simple;
	bh=Q/ozlOkyunBqYdHH/BEg19oxDS6JpJ1wCiQn42KkWtQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=PetzXTNa78AVCmJQX7BBXD2uD5b+SCe1YTjCnlidvknaqa5RWpwOzo3wOM+JEO4rQdLEAWQz/3vp+voxb8xwf3dgeGuYH8EG2D9HXgk/Jvv2zERJ0gJXoo5GaS0nLHBZDz0TqvNe4tUxwbw2urN3sYFmGlyHvDoJGcuCUIq4G8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7ZmGOrI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C99AC4CEF1;
	Fri, 23 Jan 2026 07:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151650;
	bh=Q/ozlOkyunBqYdHH/BEg19oxDS6JpJ1wCiQn42KkWtQ=;
	h=Date:Subject:From:To:Cc:From;
	b=T7ZmGOrIoxIsngOY4Cb2sQkDcxnV+Ev3iONeHHYB82cR/wJJsjZmpme5aH7YLqgga
	 2BI4GuCwH+GI+Cgqv5FTDirpyMSWA8a0jQ8aeQWl2NkrtAZrJMv52ZoPiKG4+iONd5
	 16ad9OC1Lu0PPUgguCzm1TgZrfTqa6ACjgrdjwSuRoM6G+wOMogx2H7Mljjr1R4BiL
	 lONmGX0ec7FiVJ+eqXWMjoVYcgD6Vju08rIJmm1sXj6nkEj0Q123k+LJxwBvE6Du8b
	 vwhAbh170W+P4pFQIMFVSNmH5exiSbu0IrpCvoulYV0KCX2CxVRQUMNzuMrGlJ74OI
	 6IR3W1BbJDUkA==
Date: Thu, 22 Jan 2026 23:00:50 -0800
Subject: [PATCHSET 2/3] xfs: improve shortform attr performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176915153369.1677678.8151270167939415602.stgit@frogsfrogsfrogs>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30189-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 71F2F7158C
X-Rspamd-Action: no action

Hi all,

Improve performance of the xattr (and parent pointer) code when the
attr structure is in short format and we can therefore perform all
updates in a single transaction.  Avoiding the attr intent code brings
a very nice speedup in those operations.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=attr-pptr-speedup

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=attr-pptr-speedup
---
Commits in this patchset:
 * xfs: reduce xfs_attr_try_sf_addname parameters
 * xfs: speed up parent pointer operations when possible
 * xfs: add a method to replace shortform attrs
---
 fs/xfs/libxfs/xfs_attr.h      |    6 ++
 fs/xfs/libxfs/xfs_attr_leaf.h |    1 
 fs/xfs/xfs_trace.h            |    1 
 fs/xfs/libxfs/xfs_attr.c      |  114 +++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.c |   38 ++++++++++++++
 fs/xfs/libxfs/xfs_parent.c    |   14 +++--
 6 files changed, 157 insertions(+), 17 deletions(-)


