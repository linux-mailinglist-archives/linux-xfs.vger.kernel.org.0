Return-Path: <linux-xfs+bounces-31967-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNTgGv6Sqml0TQEAu9opvQ
	(envelope-from <linux-xfs+bounces-31967-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Mar 2026 09:40:30 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8CA21D354
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Mar 2026 09:40:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5B1DD301673F
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Mar 2026 08:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5770E378D99;
	Fri,  6 Mar 2026 08:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDWRVOUV"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FB3375F93
	for <linux-xfs@vger.kernel.org>; Fri,  6 Mar 2026 08:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772786428; cv=none; b=Hm7zBdElr5j/tG/CyZHnoGZDXuJhP2xL2IIL0O0cne1O1VNcuy38YlFAf3Jx6qRaqZsSHZiiH/HPpbuhnLQ/hUemaK9ih9VIbBona6MLeJLbxX561Abf6WJ31kESbHakNyvdhr6hxoOKj+dOCMLjz2LMKHjyD0qQNJ/Y3XPwkVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772786428; c=relaxed/simple;
	bh=TRayLG2bwV5gdK/mDASfian6+htgQOcxEv1t9JawhaM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rmWaOclxBb3lhmykZyhU8vO602ZbTMd/AKdSOE6c06hyja0v527rhXqIfa02n6CsMtbEVwqJs1DjWFc/E9/kWuIdBJHG0hz46u8R1ENVs5BXwY804kXBhIWXpZGTBbjL+5B47VTzOnZ0wwNFMn2D4yk7PvQH6feOVCmL8o0cSrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDWRVOUV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313C2C4CEF7
	for <linux-xfs@vger.kernel.org>; Fri,  6 Mar 2026 08:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772786427;
	bh=TRayLG2bwV5gdK/mDASfian6+htgQOcxEv1t9JawhaM=;
	h=Date:From:To:Subject:From;
	b=VDWRVOUV/WlJSNTu9h1YxMzMz/fQT7tj+znsu09/2EfnWRQX8jtdp2i9F6B53dHuZ
	 aaXZTf0Lc7RtRRZ4/LjlT7GGsCOX3Zs0lUDQEU22q4QkDt07TR/3FNdH4zm0Wk0nEF
	 UPyH//amdUfE6iGQaC71MRwaSXiXTvYed76Hgld3w1S5v7NqjaNEkhV2U7tmcxgG8c
	 4VzVMoAH0rl4jJ/YIK9JXodQKh7R8R7Tw8yrydmxb2rzqjkdcS0lc8fldqHYMZJ34m
	 lGIyx5lU/CdBPb6to2G/dkTbsdkAp9uArz+0JkSZIDdVN9VQw6ktuscZ96m9OKCB/A
	 O4HFtZrbSRl0w==
Date: Fri, 6 Mar 2026 09:40:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 54fcd2f95f8d
Message-ID: <aaqSFIIiqxKkLa7k@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 0E8CA21D354
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31967-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.993];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

A patch previously added started a discussion upstream, so it needed
to be removed from the current.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

54fcd2f95f8d xfs: fix returned valued from xfs_defer_can_append

4 new commits:

Carlos Maiolino (1):
      [54fcd2f95f8d] xfs: fix returned valued from xfs_defer_can_append

Damien Le Moal (1):
      [6270b8ac2f41] xfs: remove scratch field from struct xfs_gc_bio

Darrick J. Wong (1):
      [0ca1a8331c0f] xfs: fix race between healthmon unmount and read_iter

hongao (1):
      [281cb17787d4] xfs: Remove redundant NULL check after __GFP_NOFAIL

Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c |  8 ++------
 fs/xfs/libxfs/xfs_defer.c    |  2 +-
 fs/xfs/xfs_healthmon.c       | 17 ++++++++++-------
 fs/xfs/xfs_zone_gc.c         |  2 --
 4 files changed, 13 insertions(+), 16 deletions(-)

