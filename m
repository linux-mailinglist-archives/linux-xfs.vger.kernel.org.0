Return-Path: <linux-xfs+bounces-30574-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eNchLzpUgGkd6gIAu9opvQ
	(envelope-from <linux-xfs+bounces-30574-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 02 Feb 2026 08:37:30 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7DAC93D6
	for <lists+linux-xfs@lfdr.de>; Mon, 02 Feb 2026 08:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C17683004D25
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Feb 2026 07:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A879121FF5F;
	Mon,  2 Feb 2026 07:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="30ojlHdX"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CBB7261C
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 07:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770017848; cv=none; b=PCvg2nqJvO80vUHj4t5yJKhNjs9rQwf7IQJ7O226k5CPkgWr+9QXR1Z7ObxapsZLQvuPZ42jyJNZwoJ5dxBn38+Dsf7GQtTj7e8wgj1VXP1Mf1lxVhQrbANzl2z+uCH5QAZgwUXb0BfASDDJ4bhYb5oY2tzRbp30YkslvjVx7F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770017848; c=relaxed/simple;
	bh=aw8KbP8bd+yKu55sZX+L/CsAfpOxawjRLfnvoXvygfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwW6qI0PdJRKif16krSah+IAmojOivjb/YiX2nAYatuZv3QyRep4emwY5wygLvKIzdydfb5IAfkf4AIEN9k9vW4yW4a/S1fU7zPNsRs2TmZ9hk8SICiSG5MfpCzXFhY4baSy05fNBsKAJFBXQXNsdMOmQ9hwsBDJDe2HV2CmdgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=30ojlHdX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mXWh3/a2KnpVb1OgYueC4MErVeh29968wJlgbK6AMqI=; b=30ojlHdX66l2pu0oalyXj08qXD
	AhX3b1lZAN7eEr23i0LBVvmGbV/MUdAacuCdyzv4k3bi1DTnUhGe5zZsYCcxoAzhFqJyOJKQiTKa8
	5ghaKP7LDI0briUyzLIIYJUJiT2B/4Nn/jV04lKMZQJUTumTZpNPkPJbOyXVxmVhNg8m7gkGYcPHt
	J0gyEdANIafaizwYoKGGXc+DB5BuZ/651kFDwIrMHbBQ29JS/eygdy7CZsWXkowbNSCXeFVSWvhcE
	SrmQnX22Zdp0538MDshv6A4lqN2Kyzj3B4Bo4KTfIn9OEODBfarkdN0Om49U34mbjzn5yBTl67NTa
	IQSkNalA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmoUu-00000004bR9-40Vw;
	Mon, 02 Feb 2026 07:37:25 +0000
Date: Sun, 1 Feb 2026 23:37:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs: Use xarray to track SB UUIDs instead of plain array.
Message-ID: <aYBUNFoHNo58kgjO@infradead.org>
References: <20260130154206.1368034-2-lukas@herbolt.com>
 <20260130154206.1368034-4-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130154206.1368034-4-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	TAGGED_FROM(0.00)[bounces-30574-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5D7DAC93D6
X-Rspamd-Action: no action

> +STATIC int

We're phasing out the magic STATIC, so pleae just use plain static
here.

> +xfs_uuid_insert(uuid_t *uuid)

The somewhat unique XFS coding style uses separate lines for each
argument:

static int
xfs_uuid_insert(
	uuid_t			*uuid)

> +{
> +	uint32_t index = 0;

.. and aligns the variables the same way:

{
	uint32_t		index = 0;

Although this one will go away with Darrick's suggestion anyway.

> +
> +	return xa_alloc(&xfs_uuid_table, &index, uuid,
> +			xa_limit_32b, GFP_KERNEL);
> +}
> +
> +STATIC uuid_t
> +*xfs_uuid_search(uuid_t *new_uuid)

The * for pointers goes with the type:

static uuid_t *
xfs_uuid_search(
	uuid_t			*new_uuid)

> +	uuid_t *uuid = NULL;

no need to initialize the iterator to NULL before xa_for_each.

> +STATIC void
> +xfs_uuid_delete(uuid_t *uuid)
> +{
> +	unsigned long index = 0;
> +
> +	xa_for_each(&xfs_uuid_table, index, uuid) {
> +		xa_erase(&xfs_uuid_table, index);
> +	}

I don't think this works as expected, as it just erases all uuids in the
table.

> +}
>  
>  void
> -xfs_uuid_table_free(void)
> +xfs_uuid_table_destroy(void)

I'd drop this rename.  Free works just fine here as a name.

> +	if (!xfs_uuid_search(uuid))
> +		return xfs_uuid_insert(uuid);
>  
>  	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
>  	return -EINVAL;

Just return an error here if xfs_uuid_search finds something, and then
open code the insert in the straight line path.

> @@ -110,22 +119,12 @@ xfs_uuid_unmount(
>  	struct xfs_mount	*mp)
>  {
>  	uuid_t			*uuid = &mp->m_sb.sb_uuid;
>  
>  	if (xfs_has_nouuid(mp))
>  		return;
> +	xfs_uuid_delete(uuid);
> +	return;

No need for the last return.  Also I think you can just open code
xfs_uuid_delete here.


