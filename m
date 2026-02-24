Return-Path: <linux-xfs+bounces-31244-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPesFVmhnWlrQwQAu9opvQ
	(envelope-from <linux-xfs+bounces-31244-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 14:02:17 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E74431875BA
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 14:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 53620300DCCF
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 13:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4101236A01F;
	Tue, 24 Feb 2026 13:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXPNwVSO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9CF396B8A;
	Tue, 24 Feb 2026 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771938135; cv=none; b=OXjaw7UvTL2GWB5qJuPyGdrchjk+ic70prv+EEnA1XCIKUE543u8TmmfU+F2deRt0T3z4aC1oy6YWoRNveNZ9zLbZwGW70u82husZnVodJYK6EkXNCcfIy4Z5Mb7CV3njC9GjBEcFcYCwDY0Sh5B21sYqCBET4yy11CCk3audh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771938135; c=relaxed/simple;
	bh=1Ql8rnYxs0AZwY1xsuA3tLeHX002TuDerKaEfA3gVxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWS8acmZ/t0OwJzg3Du+t3/KaANKzJtN+q51FrFsLs6PPH4m/fnEljTjVdR9q9NnCXMnrix4xQ2O5z/eC5rlZRdHdGAnxkFf9RxkG1beSKtM5GtPMrr2xYy7/zlfVsoWT007uDlv7uQBm0U8EQGXOUKF7GGlAnsYCeRfBYkoqDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXPNwVSO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE80C116D0;
	Tue, 24 Feb 2026 13:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771938134;
	bh=1Ql8rnYxs0AZwY1xsuA3tLeHX002TuDerKaEfA3gVxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iXPNwVSOJgkG3t3G1hyVUSDfhhVoqYcVxwdfpPerX9RHz5uolZTamiBBTOKwHjpU4
	 +hWh71GNc6rEVGdXPmDU9+jO2+rInKjcAHPSG2MDMhEWl5H83vom357divHGYqvYXQ
	 bwAvKZlPCQhNonFzy7LjahTkTp0S3HzPXuOLsrfXPkvhlOtsOTtZWQYkp+drNcV8Y4
	 zx28pIfYcM7HHS24bDHUjsULq3OPL7fyMkkSEKrjBU8xYBZmV76XErqshNJotcnHOw
	 ns5aNwzFzrkjJljkdBrVSkP7Qmzeht8i3Y+NNv4FbMsZ403y9JGwQkOluuCZdGXiqz
	 L77Ma8YI0hWxA==
Date: Tue, 24 Feb 2026 14:02:08 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>, djwong@kernel.org, 
	hch@infradead.org, david@fromorbit.com, zlang@kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com, 
	nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <aZ2gZ9XSQKYQfslN@nidhogg.toxiclabs.cc>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
 <20260220-perky-stork-of-glee-e8e4f9@lemur>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-perky-stork-of-glee-e8e4f9@lemur>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31244-lists,linux-xfs=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux.ibm.com,kernel.org,infradead.org,fromorbit.com,vger.kernel.org,gmail.com,linux.alibaba.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,nidhogg.toxiclabs.cc:mid]
X-Rspamd-Queue-Id: E74431875BA
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 09:07:06AM -0500, Konstantin Ryabitsev wrote:
> On Thu, Feb 19, 2026 at 01:55:51PM +0100, Carlos Maiolino wrote:
> > > This series adds several tests to validate the XFS realtime fs growth and
> > > shrink functionality.
> > > It begins with the introduction of some preconditions and helper
> > > functions, then some tests that validate realtime group growth, followed
> > > by realtime group shrink/removal tests and ends with a test that
> > > validates both growth and shrink functionality together.
> > > Individual patches have the details.
> > 
> > Please don't send new versions in reply to the old one, it just make
> > hard to pull patches from the list. b4 usually doesn't handle it
> > gracefully.
> 
> I'd like to hear more of this or see some examples. The workflow of replying
> as follow-ups is adopted in many other projects (e.g. git) and they haven't
> reported any difficulties. The only time I'm aware of complications is when
> follow-up series are not properly versioned.

That might be indeed the case then. I just don't have any specific case
to point you now, as this is not something that we see too often on
linux-xfs. But a few times I tried to pull series that were in-reply-to
their old versions, I ended up with the original version, or, IIRC,
once, I kind of ended up with a mixed of patches from both versions.

When there are two versions of the same series in the list, b4 can
easily find out the latest one, but seemed to have trouble (at least in
the past) when they were in-reply-to.

