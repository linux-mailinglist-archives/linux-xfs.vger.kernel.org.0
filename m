Return-Path: <linux-xfs+bounces-30497-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AFK2ECw9emlB4wEAu9opvQ
	(envelope-from <linux-xfs+bounces-30497-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 17:45:32 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D723FA611A
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 17:45:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 881B23018429
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 16:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A520C30FC35;
	Wed, 28 Jan 2026 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8s71D0J"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43C0309EE7;
	Wed, 28 Jan 2026 16:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769618540; cv=none; b=u2HpQP7Wk89a29z6YQ+X5Mw2eHkMqyKnvtsX9Cr5TAcKj6vQo1J63Tv0vpJQX9WWUb2MfZyKYk/eyQiAXthYa6yXpnTmpZ5mlY3E+SNErJoF4S1YSWlFMQzXulpdrbwUAVLndP0saMJRRYrK9YWhgolHeVvYOtJVGPIcpv6yMdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769618540; c=relaxed/simple;
	bh=SNJXD35eVCt4afuRJtKKodF8fq4jg6LQVumkPLANIVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ic26fKsGJq8/zmsZlScZpp1kALvCf1U3MArA4RWcop2q1/RD1Arev9+pIAt3m8/UclJ+jJq+/M6JO7gZd+mJlVQCKMGHmOg03bOHE0d9WToRqZsUZ1tp9JKUH8KuKFfvTWi/IT8bwjDp9RoygPPkjS8MvNBIwSaXDxx6kne6/ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8s71D0J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EDBC4CEF1;
	Wed, 28 Jan 2026 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769618539;
	bh=SNJXD35eVCt4afuRJtKKodF8fq4jg6LQVumkPLANIVk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=d8s71D0Jiri/HzOzxDfm7w2z1jRumfFJ14bBvzYde9c8zJqiAb5LTj+XghLRAS7HH
	 YHCkFc5yG0DHf6DTYgSsqqFz9ZZOCMjzUhKZmiHnKOSESzxQJ+3qsH8wdfweznxUWZ
	 ncgJIYjJ+1aObUj9/4ickMscagxE60xYCRYV1DMJLjbhpnbNqOfbJ1RaDB4z/Gp+N3
	 N+B11xlar6E4awd1JoyOjYfXzcqJ38Kma4bnSU+63CdfeTeo6hLTQyzcXAkNWjJS55
	 6fsVmCLNMmZAEi64md7uSARpC1eh2nwbn/LhUhJ4VXVx2h+lKP/rzw1raptZ7WnQY/
	 0WDZqAv4ZB8cA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id DF7C4CE1980; Wed, 28 Jan 2026 08:42:18 -0800 (PST)
Date: Wed, 28 Jan 2026 08:42:18 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Kunwu Chan <kunwu.chan@hotmail.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"rcu@vger.kernel.org" <rcu@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: rcu stalls during fstests runs for xfs
Message-ID: <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <aXdO52wh2rqTUi1E@shinmob>
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30497-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FREEMAIL_TO(0.00)[hotmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[paulmck@kernel.org,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_REPLYTO(0.00)[paulmck@kernel.org]
X-Rspamd-Queue-Id: D723FA611A
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:55:01PM +0800, Kunwu Chan wrote:
> On 1/26/26 19:30, Shinichiro Kawasaki wrote:
> >  kernel: xfs/for-next, 51aba4ca399, v6.19-rc5+
> >      block device: dm-linear on HDD (non-zoned)
> >      xfs: zoned
> 
> I had a quick look at the attached logs. Across the different runs, the
> stall traces consistently show CPUs spending extended time in
> |mm_get_cid()|along the mm/sched context switch path.
> 
> This doesn’t seem to indicate an immediate RCU issue by itself, but it
> raises the question of whether context switch completion can be delayed
> for unusually long periods under these test configurations.

Thank you all!

Us RCU guys looked at this and it also looks to us that at least one
part of this issue is that mm_get_cid() is spinning.  This is being
investigated over here:

https://lore.kernel.org/all/877bt29cgv.ffs@tglx/
https://lore.kernel.org/all/bdfea828-4585-40e8-8835-247c6a8a76b0@linux.ibm.com/
https://lore.kernel.org/all/87y0lh96xo.ffs@tglx/

I have seen the static-key pattern called out by Dave Chinner when running
KASAN on large systems.  We worked around this by disabling KASAN's use
of static keys.  In case you were running KASAN in these tests.

							Thanx, Paul

