Return-Path: <linux-xfs+bounces-29975-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLXENbtzcGktYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-29975-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:35:39 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9275A521B8
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4CC654A3330
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA493DA7C8;
	Wed, 21 Jan 2026 06:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5eRAO8Z"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA283F075E
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977301; cv=none; b=it5UF0QXGI/idTHzHaDAMaanIEQcd5wK2PX5N5YTHLc2mmwDZoztshjn6iu6SxOqxFIHoQsp+56jKClpXvsrl3UsFlL+uoy/GfD51dNNofS2Vx0ALzYn6LIlQrfUhqKFfP0P5k1aPwddC6akTxboed+YwbS0wuA7xnIDc8R7jnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977301; c=relaxed/simple;
	bh=0oMUTUooxMylvgIZKXH+DorwpFeDAU4Q4/0HyDsGIlQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=u8pNuObeJCXNPXIZJB5SuHxsXm/o5V9C06eiCDd897CC111BzVuKx0qBcX9dHVF9fYW7WunKgV4ibkjRb5TUhh7NcVC4mxRESc9kX549usYGfrWXJmEVMosC+Nn6Zb096aTcT8y8tzESwr7T9D5e6+OuhkecdXkWqKqFqrOkRXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5eRAO8Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75F7C116D0;
	Wed, 21 Jan 2026 06:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977299;
	bh=0oMUTUooxMylvgIZKXH+DorwpFeDAU4Q4/0HyDsGIlQ=;
	h=Date:Subject:From:To:Cc:From;
	b=G5eRAO8ZiThfaYk0iLUhKyucBcbxzx7GMFKMzK9BmlCJh7YmrRZvJZQju/u1dxMVr
	 rnV0O2gX/Z5nsKalwH/VuV+wjHj2cfCh0s663neJgMCYn6Jn0XGaxXaB/WOtuXWoTM
	 ssQyrxeQ/uQ1uYjPNJp8nJ2ByT4Bbc2CNK448annQYb76/jWJXPhaTLy83PNLnpXZI
	 lilX403PXaf0sCP7QwJqnVCe/2Ajp5ML6Yi3UD94T56cfJVkW9YSJlXzpgzWA3y8IK
	 r8tdVQE6D9Ie3Ykf72ThxtCeI9soMhiLsjJfkhBcoF+63d5JDJIXsHtuUeYshXV9nm
	 2I6Mv06zYxDTw==
Date: Tue, 20 Jan 2026 22:34:59 -0800
Subject: [PATCHSET 3/3] xfs: improve shortform attr performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
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
	TAGGED_FROM(0.00)[bounces-29975-lists,linux-xfs=lfdr.de];
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
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 9275A521B8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
 fs/xfs/libxfs/xfs_attr.c      |  110 +++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.c |   38 ++++++++++++++
 fs/xfs/libxfs/xfs_parent.c    |   14 +++--
 6 files changed, 153 insertions(+), 17 deletions(-)


