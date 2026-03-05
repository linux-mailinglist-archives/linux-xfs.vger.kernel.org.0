Return-Path: <linux-xfs+bounces-31915-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHslMWUFqWlW0QAAu9opvQ
	(envelope-from <linux-xfs+bounces-31915-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 05:24:05 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 375A320AC22
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 05:24:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF9403019834
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2026 04:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7153D1E3DCD;
	Thu,  5 Mar 2026 04:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkUK5Ku7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA732AD16
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 04:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684643; cv=none; b=C8gfzaTOjb3hav5D5EpnFuAuAHL8Dd3GWUaJhstmWFbTKFsbHW8n4pJae2LSyiYPdeoDRoUbTRiDfKmLz3hE4Celg+SCnIipQj6Y9Kiw5LhqT9VjELOOsM1WHmoAthUU3rWpQ7d1Qs77ppL2tfGQLEdhOmoGaZK6QiDm4nKFwPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684643; c=relaxed/simple;
	bh=fbF8W7qTO6R0iDMoErLesrqFuU+gGa65GYWyDAdFTag=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=r9i4ODccGvDrzymTgrXwYMGdZ6g/yc4O5hHx+pT9lBaBdjCZYrfxwfj05twWo1PkxtzAq4N3FxE1l8OSw+9QgAUbMqJ3JovcrwBzaAsFWzic3xSIDKK/6knqETdwPj/nQsGnyn1ajjcvxU3sFTejSXKK5TfenY7c8m34/G2Iz7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkUK5Ku7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ED5C116C6;
	Thu,  5 Mar 2026 04:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772684642;
	bh=fbF8W7qTO6R0iDMoErLesrqFuU+gGa65GYWyDAdFTag=;
	h=Date:Subject:From:To:Cc:From;
	b=BkUK5Ku7nJLMFnaGZFu3a20AyYA0Uy8HK2057pbnIsXhosbWw8UR0TYiZDOePa+ou
	 Jr+uG0DCQDRDuyD8HvBJ8BOEX3c8KpdggsYZ/QJvrkC8R5ZgXshgjT0hgFbOnmS2bk
	 z4zO1v5DHO8N7aVQdIzRX3fLdyDGcoBAQ/J5l6ObH7QBu4gTAuoOXfTuRmz60Bs62q
	 hZLhF/kD87WJycvYUxLBAqkfJUIGOVWoU9iu+l2P+2e42RIyLBzkKNnK3jd1Y6iiA3
	 7Gu/N/rig8liLM8tZTvjjrHBa9anYwrBJ6kxWUQovNrAcpIHvtnMYR3sXag2XiNKn0
	 ey8cMToJ4MI/A==
Date: Wed, 04 Mar 2026 20:24:02 -0800
Subject: [PATCHSET] xfsprogs: various bug fixes for 6.19
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 375A320AC22
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-31915-lists,linux-xfs=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Action: no action

Hi all,

This is miscellaneous last minute bugfixes for the protofile corruption
problems I was whining about yesterday, and the mkfs lsunit screwup that I was
whining about this morning.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * misc: fix a few memory leaks
 * libxfs: fix data corruption bug in libxfs_file_write
 * mkfs: fix protofile data corruption when in/out file block sizes don't match
 * mkfs: fix log sunit automatic configuration
---
 libxfs/util.c   |    5 +++--
 mkfs/proto.c    |   29 +++++++++++++++++++----------
 mkfs/xfs_mkfs.c |   17 ++++++++++-------
 3 files changed, 32 insertions(+), 19 deletions(-)


