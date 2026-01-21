Return-Path: <linux-xfs+bounces-30081-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WOUYJ98tcWmcfAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30081-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 20:49:51 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9E55C883
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 20:49:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 25270A04382
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 18:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A46834D90E;
	Wed, 21 Jan 2026 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yy4ZhbuR"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6974734C81E
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769018807; cv=none; b=D/+L2iCAAFdMtVQG3+FA+4k97A7p5eVlsd67+SC+2VlS/Lo29JMTqYwVsa5YeGDmErQOen7CZbERR9LCsbu9YSZb4L+Srg7VsCX5e7DZDEWl7qr3hJwNZMaCNpCeZ52Bx+lQBagZEJ8dr3Ht4ELAu1IdmGcXLliGhv06I4HWWi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769018807; c=relaxed/simple;
	bh=xvFq1S8ANOFPZF/O3qhfdo1vRtFvR/M+wCNWYaer6GE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LleVsCbANkVIUayZwKJtDScI9NLSGXbr/lK305YlRo6QRS++baUd6MlZZKT66+A5Ux22P5YDr2QDXs5fqI9kE306sJHjcsIT548o+fJR8RmPPvvZDJz+BxI8wxraZjyfPAqxhaZRMRaNBGh+PXezqKRl7dXjh1oqoNS6z7mSU7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yy4ZhbuR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B48C4CEF1;
	Wed, 21 Jan 2026 18:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769018806;
	bh=xvFq1S8ANOFPZF/O3qhfdo1vRtFvR/M+wCNWYaer6GE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yy4ZhbuRMwyHx0BF1OkCjlAEbNMqi9tIEF3uMHNwpd8781daGCTxu9LovKXz+XTsO
	 QBhVj1OyNyFau5oC/G+17xCyb4wMiKfxfKeiWsMs3BCZncFWOkDjb5obnhPtx4qAb7
	 4wPOwHUFY9q4zEyJ1nGbjauY2wk4XLCdJ7ArVidP1CeDbZCRz4ew8biRSzPuukrd3W
	 TC5pMlK9/BH0wMP8+qN4Y8QghlQ9tHlwcmwR+ZUNnlzO+clyH5DQSa8yogFhZB5xtv
	 lpbG1QezC7iT80TFrTJ/jyrbRBzTbQwdnU64uyqK2hdAQj/w2HDV7tlEJDkMAIHZv0
	 /j21BSssO0UMQ==
Date: Wed, 21 Jan 2026 10:06:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: speed up parent pointer operations when possible
Message-ID: <20260121180646.GG5945@frogsfrogsfrogs>
References: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
 <176897695972.202851.10720887475428645960.stgit@frogsfrogsfrogs>
 <aXDvLIufYilqY-Ab@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXDvLIufYilqY-Ab@infradead.org>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30081-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 2E9E55C883
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 07:22:20AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 20, 2026 at 10:39:46PM -0800, Darrick J. Wong wrote:
> > and fall back to the attr intent machinery if that doesn't work.  We can
> > use the same helpers for regular xattrs and parent pointers.
> 
> Not just can, but do :)  This should really help with ACL inheritance
> as well.
> 
> > +/* Can we bypass the attr intent mechanism for better performance? */
> > +static inline bool
> > +xfs_attr_can_shortcut(
> 
> This is really a could and not a can, it might still not be possible
> and we bail out.  Maybe reflect that in at least the comment, if not
> also the name?

How about:

/*
 * Decide if it is theoretically possible to try to bypass the attr
 * intent mechanism for better performance.  Other constraints (e.g.
 * available space in the existing structure) are not considered
 * here.
 */
static inline bool
xfs_attr_can_shortcut(

> > +	if (rmt_blks || !xfs_attr_can_shortcut(args->dp)) {
> > +		xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
> > +		return 0;
> > +	}
> > +
> > +	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
> > +
> > +	error = xfs_attr_sf_removename(args);
> > +	if (error)
> > +		return error;
> > +	if (args->attr_filter & XFS_ATTR_PARENT) {
> > +		/*
> > +		 * Move the new name/value to the regular name/value slots and
> > +		 * zero out the new name/value slots because we don't need to
> > +		 * log them for a PPTR_SET operation.
> > +		 */
> > +		xfs_attr_update_pptr_replace_args(args);
> > +		args->new_name = NULL;
> > +		args->new_namelen = 0;
> > +		args->new_value = NULL;
> > +		args->new_valuelen = 0;
> > +	}
> > +	args->op_flags &= ~XFS_DA_OP_REPLACE;
> > +
> > +	error = xfs_attr_try_sf_addname(args);
> 
> This mirrors what the state machine would do.  Although I wonder if
> we should simply try to do the replace in one go.  But I guess I can
> look into that as an incremental optimization later.

<nod> I *think* that there might be some benign clumsiness going on with
the actual attr intent machinery -- when we create a pptr replace
operation, we log five things (attri header, old name, new name, old
value, new value).  The attr op remains XFS_ATTRI_OP_FLAGS_PPTR_REPLACE
throughout the intent item's processing, which means that the log
recovery code expects the intent item to have all four buffers even if
the log already recorded removing the old pptr.

Where the weirdness comes is if we relog the intent item after calling
xfs_attr_update_pptr_replace_args.  I think that can cause a shift in
the logged items from (attri header, "foo", "bar", XXX, YYY) to (attri
header, "bar", "bar", YYY, YYY).  It'd look weird in logprint, but the
recovery machinery will do the right thing whether or not it finds
bar/YYY.

For this edge case of replacing a pptr where we deleted the old pptr but
failed to add the new one, we're using PPTR_SET to set the new pptr, so
we only want to log (attri header, new name, new value).

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for reading through all these patches!

--D

