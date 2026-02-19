Return-Path: <linux-xfs+bounces-31010-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHJxLxenlmmTiQIAu9opvQ
	(envelope-from <linux-xfs+bounces-31010-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:00:55 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BA215C44E
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2BF1D3007B86
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37542DD5E2;
	Thu, 19 Feb 2026 06:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sOZehDVE"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C172521FF33
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480853; cv=none; b=AnafeFZVJZfU4nzH4EfXt9vEkC/cuXluYTX7Cx+0RNpQbN0VnKaL1N85bALf2gDlUGp8X06AnKwuSa1dwvfE2nGy20k5TcCYn4FWPUnEvh3p+Pm26g1QhNCTj06SFojZyb22s49Akro7Va6o/5SV9cV0DdW+vwy/4YUUx3LA5wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480853; c=relaxed/simple;
	bh=nE5aXNzRUS3BruGnYSE/bvVT1StFUOHL+l6VB/rRyBo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Z5l2FaJH7gFCT7YMggN8sptXzf+sNircm8VmtKuKCujKdwFG+T/36K5tMwbWsUIbnoqyWVupvafBTqNmsSPXCeZ6ddAEx/voc5L/wEoIPvDeN8pP5z96z0IVbkIkS9rsmrb8zFFL3+VVduPk47aWmYb7H763NIz7mpvu8sU8onc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sOZehDVE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7DAC4CEF7;
	Thu, 19 Feb 2026 06:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480853;
	bh=nE5aXNzRUS3BruGnYSE/bvVT1StFUOHL+l6VB/rRyBo=;
	h=Date:Subject:From:To:Cc:From;
	b=sOZehDVETmzOFkq2vv+sWznlPwd0C2T823A/m9yxoAH5juieINKE0yhMAHy6fbfwT
	 UVPJtbEfPuedrIhHJePVEs4/sOle0/+fo0On4jVPAdFHqQGOTBahmTtt091AjNsTdf
	 yi1thUC3l4nUQAjYV53KyU7gd75fn80irBjDPtyTi6ALclY732IXcl44qkGPLp6gua
	 O0by5ICuH7tGTkCuPxu0nz7aKL5zCOdvFwDRgOSqOpnmkXASBMxrb7SVt3mj8RdGoh
	 guUJxvTlveO0tmIk/kojHeBpI+pznLeOo8BVFoIW+xyWEav//qV3UR3RsnlXpGC5sq
	 I7JUGrkBbWgaQ==
Date: Wed, 18 Feb 2026 22:00:53 -0800
Subject: [PATCHSET 2/2] fs: bug fixes for 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@infradead.org, jack@suse.cz, amir73il@gmail.com,
 linux-xfs@vger.kernel.org, brauner@kernel.org
Message-ID: <177145925746.402132.684963065354931952.stgit@frogsfrogsfrogs>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[infradead.org,suse.cz,gmail.com,vger.kernel.org,kernel.org];
	TAGGED_FROM(0.00)[bounces-31010-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 99BA215C44E
X-Rspamd-Action: no action

Hi all,

Bug fixes for 7.0.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vfs-fixes-7.0
---
Commits in this patchset:
 * fsnotify: drop unused helper
 * fserror: fix lockdep complaint when igrabbing inode
---
 include/linux/fsnotify.h |   13 -------------
 fs/iomap/ioend.c         |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 13 deletions(-)


