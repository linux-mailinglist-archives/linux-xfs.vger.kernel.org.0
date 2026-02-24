Return-Path: <linux-xfs+bounces-31264-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EFctDLUAnmkfTAQAu9opvQ
	(envelope-from <linux-xfs+bounces-31264-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 20:49:09 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 981B318C34B
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 20:49:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 83B40303B5FF
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 19:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D3742C11F3;
	Tue, 24 Feb 2026 19:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhVWTTVu"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF26B26B756
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 19:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771962546; cv=none; b=Ei/d7VHBtj5kFz1zTizstCF0XwqVQKj61VtzN1QefdKVyLkBUXx1Xp8Gty2nK4EDO8kawFGw8IYIzNLKr8QnGJemypCCt5PQOZQ5SjWAXPJkqROQgyKUhnvKkuGmRV/elYPGyvO8dyOCdsvsw1pQYvAiXgA40uLHlchXT0Tds0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771962546; c=relaxed/simple;
	bh=n8M5ovPfpFr9S+m3QbUJtSr+02MlJwH0vSi6qXdmuV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jnr7AaZMpaO9umgtPTN5pFEnxJ0pUe91KE5muhukKxj2oyX/Xnb3rJO/3Bs5wAKu34f/t6aedhCl3Mv+gnMxS9Oj8VmslIopCPUXNSq1LpFrykawIjRxeoWn9IdVH+ra43+ZM6zch0kB2BJtWpaCaQBhAFnjZ5yGeSULQpVJJWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhVWTTVu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EF1C116D0;
	Tue, 24 Feb 2026 19:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771962545;
	bh=n8M5ovPfpFr9S+m3QbUJtSr+02MlJwH0vSi6qXdmuV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HhVWTTVu8IgJIPp5RkO8v2epVKcoXWmhZIYCS/xyGnJ8slEFe6fNAWfZwfTT5ZmkU
	 REPUbsrTCU0wXZB7OKzXxIV2LvWYwYFGQPj9sHA9wqb97rrtUYQ9G/iPvP+9xGhbyN
	 pTuu4MDIuYgiWX/uFBwb7pnrICIEumgNEJkGjadWfKVS5or5WErCWEGVWD376mgXi8
	 9raPn+6+lpmD0tHTEG7op5pL8aB8V2nn5Hq4uCXxw4Um/JvVGw9t53pe7+j0zMsyCn
	 c1TU/kK2tr3EaMJdg0hTSvXwJdGeTK4xNGqPR3axP9QAz9sKF8H3GTPhApcU91pwZ9
	 7MN/3B76Lg6DQ==
Date: Tue, 24 Feb 2026 11:49:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
Message-ID: <20260224194904.GC13843@frogsfrogsfrogs>
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
 <aZ29iJJF9sGfya1k@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ29iJJF9sGfya1k@infradead.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31264-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 981B318C34B
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 07:02:32AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 23, 2026 at 02:48:48PM +0500, Марк Коренберг wrote:
> > This feels like something xfsprogs could support directly. My proposals:
> 
> I like your proposal.  This is actually a relatively east project,
> and I've happy to mentor whomever wants to take it up.  Although
> I think json output while generally useful is probably a separate
> issue and should be addressed separately and in a more general
> fashion.

I've long thought it might be useful to have an xfs_db command that
could spit out a mkfs config file for a given filesystem, so you could
just do:

# xfs_db -c 'mkfs_config' /dev/sda1 > /tmp/foo.cfg
# mkfs.xfs -c /tmp/foo.cfg -f /dev/sdb1

and then sdb1 gets whatever featureset sda1 had.  The reason I never
pursued this is that I don't know how much we'd really want to preserve.
User-visible features, yes.  But what about geometry things like group
size, volume size, or RAID stripe parameters?

--D

