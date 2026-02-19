Return-Path: <linux-xfs+bounces-31093-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kHyBFy0Sl2n7uAIAu9opvQ
	(envelope-from <linux-xfs+bounces-31093-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 14:37:49 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB95315F240
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 14:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 664DC3004225
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 13:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF522EB87E;
	Thu, 19 Feb 2026 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UR4OqCJZ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC07A253340
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771508266; cv=none; b=NDjeu0JSMeg9OFENhp+Nw4Bg2tUoQgsnuKtBUfQHImwYd4kqlU6/XG99Zlp/Fezl7Mg4BT4Uif61jbUZvFjNmo46aRILeavOTPJcwKIVmA3nBdDNzQsjEvApAcJ8VitDqfKOJXPJgRq5yGjnMMQ5ak282YroEz/uFhMGutGqX5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771508266; c=relaxed/simple;
	bh=EwndtX1dUGz5/kNjPSv++2ZuMcdPVuyCJYOqR5wsCE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C/Kq/2IFV8Ybp6iBQc3b4n54p4iQ7lZVu2yZLjG6cmElgRzbY563V5abR5fEi1okrcDBzfY9GwDWTtHaMJQM0ckB4msuwWfrU3jMEIk2/2Avw9vfAso/kjGAEDa3nDPy19fv7LUuiS/0hxI2jsUk8ljoGdYJlrtOZKtK/hBj0bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UR4OqCJZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC383C4CEF7;
	Thu, 19 Feb 2026 13:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771508266;
	bh=EwndtX1dUGz5/kNjPSv++2ZuMcdPVuyCJYOqR5wsCE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UR4OqCJZnDRUCl8r+RLXfi9lxV+7GhxGLihfjvxzigoChYLxbtMHgFiHCi6vYxPC1
	 kzkqDpU4fPhxpsTVaQN8B58SVEbiyZQ63YtTa5ExQXF3ob4Pxixr3ncSQJEiPJY9uE
	 A1B4QgjSm4eOJ4gfUXLIwRyL/QH5FlenF0Tj3A3IPPLlf0diCPcAuESLOQceX3e1My
	 PssoxP5rOqewB+b2+Da5T7NOYSDNfxJgI9gh/bkjGahv6rlXvMjTeDGkEWJ73c9qnB
	 yfmi4f0EE6SJiShi3BwGdj+0gYB+JBbz3nx3OhmghiLg/R/FmhSAh26mWEUV2cmFkm
	 aDfbHbeuj059Q==
Date: Thu, 19 Feb 2026 14:37:41 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org, 
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, nirjhar.roy.lists@gmail.com
Subject: Re: [PATCH v2 0/4] xfs: Misc changes to XFS realtime
Message-ID: <aZcRxYYpo-DvGxrr@nidhogg.toxiclabs.cc>
References: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31093-lists,linux-xfs=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,infradead.org,vger.kernel.org,gmail.com,linux.ibm.com];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BB95315F240
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 01:08:48PM +0530, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> This series has a bug fix and adds some missing operations to
> growfs code in the realtime code. Details are in the commit messages.
> 
> [v1] -> v2
> 1. Added RB from Christoph in patch 1 and 4.
> 2. Updated the commit message in patch 4 ("xfs: Add comments for usages of some macros.")
> 3. Updated the commit message and added some comments in the code explaining
>    the change in patch 3("xfs: Update lazy counters in xfs_growfs_rt_bmblock()")
> 4. Removed patch 2 of [v1] - instead added a comment in xfs_log_sb()
>    explaining why we are not checking the lazy counter enablement while
>    updating the free rtextent count (sb_frextents).
> 
> [v1]- https://lore.kernel.org/all/cover.1770904484.git.nirjhar.roy.lists@gmail.com/
> 
> Nirjhar Roy (IBM) (4):
>   xfs: Fix xfs_last_rt_bmblock()
>   xfs: Add a comment in xfs_log_sb()
>   xfs: Update lazy counters in xfs_growfs_rt_bmblock()
>   xfs: Add comments for usages of some macros.
> 
>  fs/xfs/libxfs/xfs_sb.c |  3 +++
>  fs/xfs/xfs_linux.h     |  6 ++++++

Please rebase it on top of current xfs code (preferentially for-next
branch). xfs_linux.h has been renamed during the merge window.

Thanks!

>  fs/xfs/xfs_rtalloc.c   | 39 +++++++++++++++++++++++++++++++++------
>  3 files changed, 42 insertions(+), 6 deletions(-)
> 
> -- 
> 2.43.5
> 
> 

