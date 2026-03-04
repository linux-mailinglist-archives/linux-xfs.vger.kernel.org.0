Return-Path: <linux-xfs+bounces-31875-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0A0+NG80qGm+pQAAu9opvQ
	(envelope-from <linux-xfs+bounces-31875-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 14:32:31 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F1D1200763
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 14:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C3D16302B1B5
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2026 13:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08130286D5D;
	Wed,  4 Mar 2026 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j709Uv+W"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D9B282F11;
	Wed,  4 Mar 2026 13:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631137; cv=none; b=V9+NITXg9TH59lLRoMzZguWAkhNHDAcRI+Rq94MKX5H8ZRXm49c7HMELlmV4/gKL1d2xEXZuFqEylrjtnYw+nJ68AuVGOPlzbM1O4WVIN7GqwuRItu9vAQKBxGQOIO4Wkvj0j/tD3tkp+XQyirjyUNYXbrYAPbl5gfbW5kpQbyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631137; c=relaxed/simple;
	bh=vtPXm1/SQmtjVv56wH2xXhtJbMUeRM7jylkwF9nkOyY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bXFtemQ3swKv078BOF5lxr7FjsAzuIo5LDkL9W9pD8jBgFIFWYSKQoUiqcQ7yp1v+6tZ9smFlUcvM/aKp4s51QDfk+ZReGKQyuoRyVsJ4ZgAEwjLzsSEQiG2AD9S4pEGYSx6Nz6qEyNaUf6xNnpyOKA9SmanGsOGcoUoWR6yh64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j709Uv+W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6DFC19423;
	Wed,  4 Mar 2026 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772631137;
	bh=vtPXm1/SQmtjVv56wH2xXhtJbMUeRM7jylkwF9nkOyY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=j709Uv+WE1YqEkDO44/yB965delVMWfNxWACE4BpYlnSSGvTbYBBPQd3AX5q0c+52
	 /OVJd7zGqfSmJIV+VFK9zKiqCOZGkup3ITTrVRllgWXgSc3ilyBIHX7HA2x79l8VSH
	 RybKTD84xQ+l2LIeRzm1TODiR/uEsLAZVD3P1x0ySI3Duankgxwkt91ggfdQt0ZxrE
	 2lNFcVOUoNfn4JN2KImNKofMuuUfPodY5uhAW3pkd98XKpJIVMji8R3g3+AXkHsL05
	 v/xXUBufm7Qz3ZYtpXfRu2RKFi54y5k03UFp0LAD/SwIcckR9iRHptms6K3l6n2BqR
	 TecdEycTvCvBQ==
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
 xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, 
 Carlos Maiolino <cmaiolino@redhat.com>
In-Reply-To: <20260302173002.GL13829@frogsfrogsfrogs>
References: <20260302173002.GL13829@frogsfrogsfrogs>
Subject: Re: [PATCH v3] iomap: reject delalloc mappings during writeback
Message-Id: <177263113605.1044679.13007828862296316195.b4-ty@kernel.org>
Date: Wed, 04 Mar 2026 14:32:16 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773
X-Rspamd-Queue-Id: 7F1D1200763
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-31875-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 02 Mar 2026 09:30:02 -0800, Darrick J. Wong wrote:
> Filesystems should never provide a delayed allocation mapping to
> writeback; they're supposed to allocate the space before replying.
> This can lead to weird IO errors and crashes in the block layer if the
> filesystem is being malicious, or if it hadn't set iomap->dev because
> it's a delalloc mapping.
> 
> Fix this by failing writeback on delalloc mappings.  Currently no
> filesystems actually misbehave in this manner, but we ought to be
> stricter about things like that.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] iomap: reject delalloc mappings during writeback
      https://git.kernel.org/vfs/vfs/c/d320f160aa5f


