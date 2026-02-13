Return-Path: <linux-xfs+bounces-30807-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMKuN96Zj2lQRwEAu9opvQ
	(envelope-from <linux-xfs+bounces-30807-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Feb 2026 22:38:38 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E6CE139A48
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Feb 2026 22:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7873D300750E
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Feb 2026 21:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4715D2D592E;
	Fri, 13 Feb 2026 21:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5A+uff/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F775285CA7;
	Fri, 13 Feb 2026 21:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771018715; cv=none; b=Ujc7WPNle3zVzO78/PHwvfk58vLuxiJaYHtHnI9oVfPcNtcIoQHl939mrmPmAtdSQXiXuFfFLY0dsZb2lh8HnVvnleOwq+Ojn54oNRI5PRiPxPZWU3tS3zy8VWmaiV42iFRm5tq20/oD1S4zIDfYnJyQz5An+VCk5ULg+J4IY8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771018715; c=relaxed/simple;
	bh=nDgLJgyH5fLAzAaIfpNTcwoxzuyLVGAY+RQpeOl08XE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hyfLWCpVs5obIvJ28KgCxYq+yF/ynW9yUc0fNH5mVorAc4djBiu7giOcghrXtWsN6/waRs0X40UyGmMcsA4xkmNAtaP9Js9mLPNCUDK8X6uR4gA1zCm30I+fEBS4gfou2mzEL/d41Pk7/lv4JXJZib5mD1U0sMmrK3CY5Z38H84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5A+uff/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B73FC116C6;
	Fri, 13 Feb 2026 21:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771018714;
	bh=nDgLJgyH5fLAzAaIfpNTcwoxzuyLVGAY+RQpeOl08XE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S5A+uff/9InguEAzYh4iOQy+LXE7MjTdiH4qG9RowisFpTuDT4oZemDGIy22o5fUQ
	 FAz9q7QXTVtbppDw352cTue4etIpcBv7SI39fMZRkyVI2Znoj1OJrIBZxJcGaL7VY8
	 /pl4EQI7K64bBWoASmTJSii4AdXtNOMznmoasxAl4p/rjrFLINnh0lUeEV+8oap3N0
	 ROX/p48Y9CnejvxJ+dRLPXBPImXolUmDlXXpJ12c0aDzp0nS1mSJe+dp4PQ7FRQRVY
	 vl1e4XHfmTB9Xz0rkZF3MXtgwAE8KPJqxw0bx2fOYv05XWz51N9WDySZswC4u/g0HR
	 PfSKrO4PKGd+g==
Date: Sat, 14 Feb 2026 08:38:27 +1100
From: Dave Chinner <dgc@kernel.org>
To: alexjlzheng@gmail.com
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH 0/2] Add cond_resched() in some place to avoid softlockup
Message-ID: <aY-Z06HJnnB_Kdx3@dread>
References: <20260205082621.2259895-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205082621.2259895-1-alexjlzheng@tencent.com>
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
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-30807-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dgc@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6E6CE139A48
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 04:26:19PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> We recently observed several XFS-related softlockups in non-preempt
> kernels during stability testing, and we believe adding a few
> cond_resched()calls would be beneficial.
> 
> Jinliang Zheng (2):
>   xfs: take a breath in xlog_ioend_work()
>   xfs: take a breath in xfsaild()
> 
>  fs/xfs/xfs_buf.c     | 2 ++
>  fs/xfs/xfs_log_cil.c | 3 +++
>  2 files changed, 5 insertions(+)

To follow up on my comments about cond_resched(), commit
7dadeaa6e851 ("sched: Further restrict the preemption modes") was
just merged into 7.0. This means the only two supported preempt
modes for all the main architectures are PREEMPT_FULL and
PREEMPT_LAZY.

i.e. PREEMPT_NONE and PREEMPT_VOLUNTARY are essentially gone and
only remain on fringe architectures that do not support preemption
or have not yet been fully ported to support preemption.

Hence we should be starting to consider the removal all the
cond_resched() points we have in the code, not adding more...

-Dave.
-- 
Dave Chinner
dgc@kernel.org

