Return-Path: <linux-xfs+bounces-31819-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OUGLgMMp2kDcgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31819-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:27:47 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 351E51F3C5B
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 86A0230ACBE7
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 16:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98DEB4D2EF8;
	Tue,  3 Mar 2026 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FrovazhC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762844D2EEC
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772554769; cv=none; b=Q8T936Vlk2tToCBl9Z60iiFRYr4enSRLXsbmZIAY+JFuUHApqjCpbbU/OyJoN26cJkMW3WcDUmvD27mHstOWpwsUG/9wg2wDZIay/FAFiMmYpQkM1gBqbcnVzL6HEOEMQBfii/UOG+IKM+wyxqMYckf5e6hugFr5xLpUQzrdY1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772554769; c=relaxed/simple;
	bh=NLq3y5n2MoId37xIuOeF9nw7E8aL8RLZxvfm17WWIlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIgJ2JJHLrmVQwhWibTycd9VZa4ci7cfaA/VIAKmDdnUtdbTkts+NaoLFLZNeuVlxVhbb7FQBvMjdrU8UE/orQBbdjSeuwoA9yPDhVS9yUoGAQIQjAiQjOonJbf4PBn6GBn3ZjjfU3f4XYFNcQlQPqm+EYDgKlYDgTuM/r4e7EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FrovazhC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2357FC116C6;
	Tue,  3 Mar 2026 16:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772554769;
	bh=NLq3y5n2MoId37xIuOeF9nw7E8aL8RLZxvfm17WWIlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FrovazhCabPTLu22yVqlijRBIy9wlMNcE6lQyAOuWBWz+y1k2ZWRJD/lOmrYWNskZ
	 K5V15uXiLdhPd0xR0gqaPH5nXwgY0JSacKsxgizD4sgIMvr/1iH08ED2ZRAvglTxBW
	 l7hXEgB+zjXZeM/e2E26at7MAn2R7BxLtO1uisFindKCJMY9+cQMA71Yu8eUu3WyF+
	 zLgCS4xM7SYu/KjX7e1Eec2TqztZ+dkjKMnz2C5bjaIqfZEAnKiBMZpbpNy2S9Tc9m
	 VMJS64EnApL7pHZEbXuKGavZO45eDNc4B69R5mfSefP8JsSon9lwxWzhXw2L9VIzxs
	 63ytXo/pheQog==
Date: Tue, 3 Mar 2026 08:19:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/36] xfs: move struct xfs_log_iovec to xfs_log_priv.h
Message-ID: <20260303161928.GE57948@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249637996.457970.5988457332713577268.stgit@frogsfrogsfrogs>
 <aabzvfIxUWD2jK_e@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabzvfIxUWD2jK_e@infradead.org>
X-Rspamd-Queue-Id: 351E51F3C5B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31819-lists,linux-xfs=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 06:44:13AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 04:15:16PM -0800, Darrick J. Wong wrote:
> > +++ b/include/kmem.h
> > @@ -60,6 +60,8 @@ static inline void *kmalloc(size_t size, gfp_t flags)
> >  
> >  #define kzalloc(size, gfp)	kvmalloc((size), (gfp) | __GFP_ZERO)
> >  #define kvzalloc(size, gfp)	kzalloc((size), (gfp))
> > +#define kmalloc_array(n, size, gfp)	kvmalloc((n) * (size), (gfp))
> > +#define kcalloc(n, size, gfp)	kmalloc_array((n), (size), (gfp) | __GFP_ZERO)
> 
> Maybe use check_mul_overflow like the kernel version?

Oh, yeah, I forgot that someone ported that to userspace.

> And avoid the overly long line and maybe even turn it into an inline?
> 
> I think it would also be cleared to split adding new core helpers into
> a separate commit vs tagging it onto porting kernel code that's using
> them.

<nod> Will do.

--D

