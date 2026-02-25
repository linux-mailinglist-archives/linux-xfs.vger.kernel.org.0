Return-Path: <linux-xfs+bounces-31294-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6B1UFE8Jn2neYgQAu9opvQ
	(envelope-from <linux-xfs+bounces-31294-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 15:38:07 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C0CBD198D27
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 15:38:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6EC70301F4BA
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 14:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E328D28640C;
	Wed, 25 Feb 2026 14:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QnlNpTy9"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D8E285CA4
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772030025; cv=none; b=NKBCMwjuTGfiq2dqno8642sqXKQhajcmRnY6MG982IkFN9qr5sMaOwYkB2cJfZMAFaVyLN6ZOYblJQ08wEqcu/r+XJpFk7SxRGGQTORUy1s6vx3Ov7voD9VTwcrWxcO13PJtGF77qs+Kom/wJbYyU6GwvSFOyGhSQ8ekOJr1eXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772030025; c=relaxed/simple;
	bh=tsCFDBvgb60h+kwN5ws0Fm4mg5FNDsK5nqQOjwO1xtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWqOhc3DmGVzAW9BH8G9WevfQ3nows/62/KIfca5uKsKRzePZA7uy8DZHqQc/RAC4V86k+IEN1PCZXliObC54TDPzWtObsnGYNnzN8MxHYav6n433U0Dsq3AHZcbda1dTvwmAsUR3lMhvylAWoiRms2aw3iBhYOhv+VIB6Gtb1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QnlNpTy9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tbBDUquhbbrqkAOhnIBy6F1v/PrWe1aJyrfE33ZvfNA=; b=QnlNpTy9cEDa4iI1Jn7Dl8LDX9
	43stRDdUwoAKk7aVE294qCPnX0HCMPal3jFQIBrJzVAwlJ7ZFtEODbmUMW3SNEqJGhFjv9S5hk13x
	uDYbkgK1cyIEDygUDfr9vfizSi0+lxwwN8os/5Z+l/NK7s+XwjnxacC7H2+6O1LF0Em4VU1QeoEER
	IdirrjjCoUSJOuiDoTV3Z3xysoDnx/UqKUq7kMQGZD1w9l2GVNEAoo3asl7X0FfU5OEY+pkhIRYX4
	i4B+9QZ8MshA7c2MIlF1eC6DQZDJ3yq8b5TGTwoz7CzuDr2ErbVEbzrwd23sVRyr1gAHlUgJRDuiE
	U3LAwiOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvFxQ-00000004DXW-03O6;
	Wed, 25 Feb 2026 14:33:44 +0000
Date: Wed, 25 Feb 2026 06:33:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, cem@kernel.org, hch@infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: Use xarray to track SB UUIDs instead of plain
 array.
Message-ID: <aZ8IR37gQkhomIWq@infradead.org>
References: <20260225123322.631159-3-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225123322.631159-3-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31294-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C0CBD198D27
X-Rspamd-Action: no action

This doens't apply to current mainline or the XFS tree, as it
doesn't have the healthmon pointer in the mount structure yet.

> +/*
> + * Helper fucntions to store UUID in xarray.

s/fucntions/functions/

But I'd just drop the comment.

> + */
> +static int
> +xfs_uuid_insert(
> +	uuid_t		*uuid,
> +	unsigned int	*index)
> +{
> +	return xa_alloc(&xfs_uuid_table, index, uuid,
> +			xa_limit_32b, GFP_KERNEL);
> +}

... and open code this in the only caller.

> +static void
> +xfs_uuid_delete(
> +	uuid_t		*uuid,
> +	unsigned int	index)
> +{
> +	ASSERT(uuid_equal(xa_load(&xfs_uuid_table, index), uuid));
> +	xa_erase(&xfs_uuid_table, index);
> +}

>  	mutex_unlock(&xfs_uuid_table_mutex);

This looks like it should be a lock and not unlock?

> +	if (unlikely(xfs_uuid_search(uuid))) {
> +		xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount",
> +				uuid);
> +		return -EINVAL;

And this is missing an unlock?

Just curious how this was tested?  xfs/045 should cover mounting with
duplicate uuids.


