Return-Path: <linux-xfs+bounces-25264-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78685B43237
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Sep 2025 08:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 392443AC99C
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Sep 2025 06:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EA825A65B;
	Thu,  4 Sep 2025 06:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yvYvAKEC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8669425A33A;
	Thu,  4 Sep 2025 06:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756966871; cv=none; b=bp4tEmMR48OcChc/lh02J+Nmq5W8ru4tGoC3AzLyOxaryROST6vxKMvFADQJ6G2kI+vDtmr1r7IKrZSSmZQjCeik8Wuf4Sg+SUcqB6wbl0U4hAyt+8Mr/Y7fL1PXPjpICxx8JXfAaQhdTWmewer2KU7PakoN/tpXFdnYoJjPl48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756966871; c=relaxed/simple;
	bh=4t+iU1LHlHqctcAH2DAYCIvA8U4WkdpWIV+q2wFrAlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjFZ6v967HcenrrLxQPul0RcOIZvhWxXqVZ0jQafIo5YoDDfYCQbQAJv8YFFHrQRKgdJCqmLJWWkMmhTya86TUKIAHX5gaEHWQYxs0ukhPfw9Wc6ffbZ1M5ZSrmQ9/dZvYWUAPqZ4wRgTAg0k/alpNaaaGMsoQrb2gKyo28s7d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yvYvAKEC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ROSGqH0M91384oeBa0AW0ZFuSxwkabcmaXmlvpcC8M4=; b=yvYvAKECyjiNoumKWD4cn1zQeo
	lOWDRbBKrZIiWUHq7hpZIr1WgMj57wHdWnLAb6iRP6QwnfFagpJOQPd/CkgwwZHIqCYG6sUo8iSW3
	XqTGDbNX/S3SiMYQT7zAsAklc36qgUFG4gd/qkP2nWjdeD+GQR+nuiVBGwCWmpO+1HcFmw6begBGP
	DBQm6DniIKMRoE2D/DDsW8BBM/GsxM07Od8Ba14B76UdDM9aUZMupC9bFBjDVYcsfi8+VPF2VEE7o
	A8SbVqGSUG0reliliHqSEXXrm3BuNmvqT+iePHR6kT2dpbrQfJf6SPr3TDKtwObu9HIAQKZwBIiTe
	9K7CZukw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uu3LK-00000009UQr-0Wli;
	Thu, 04 Sep 2025 06:21:10 +0000
Date: Wed, 3 Sep 2025 23:21:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, miklos@szeredi.hu, hch@infradead.org,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com, linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v1 12/16] iomap: add iomap_read_ops for read and readahead
Message-ID: <aLkv1ueEE8-ULH6V@infradead.org>
References: <20250829235627.4053234-1-joannelkoong@gmail.com>
 <20250829235627.4053234-13-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829235627.4053234-13-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 29, 2025 at 04:56:23PM -0700, Joanne Koong wrote:
> Add a "struct iomap_read_ops" that contains a read_folio_range()
> callback that callers can provide as a custom handler for reading in a
> folio range, if the caller does not wish to issue bio read requests
> (which otherwise is the default behavior). read_folio_range() may read
> the request asynchronously or synchronously. The caller is responsible
> for calling iomap_start_folio_read()/iomap_finish_folio_read() when
> reading the folio range.
> 
> This makes it so that non-block based filesystems may use iomap for
> reads.

Also for things like checksumming in block based file systems.  I've
carried this patch originally from Goldwyn around for a while with
my PI support patches:

https://git.infradead.org/?p=users/hch/misc.git;a=commitdiff;h=54ad84fded1d954cb9ebf483008cb57421efc959

I'll see if we'll still need submit_bio with your version or if
that can be reworked on top of your callout.

> @@ -356,6 +356,12 @@ void iomap_finish_folio_read(struct folio *folio, size_t off, size_t len,
>  	if (finished)
>  		folio_end_read(folio, uptodate);
>  }
> +
> +void iomap_finish_folio_read(struct folio *folio, size_t off, size_t len,
> +		int error)
> +{
> +	return __iomap_finish_folio_read(folio, off, len, error, true);
> +}
>  EXPORT_SYMBOL_GPL(iomap_finish_folio_read);

..

> +	if (ifs)
> +		iomap_start_folio_read(folio, 1);

I don't fully understand these changes.  Any chance they could be split
into a prep patch with a detailed commit message so that the method
addition itself is mostly mechanical?

> +			if (read_ops && read_ops->read_folio_range) {
> +				ret = read_ops->read_folio_range(iter, folio, pos, plen);
> +				if (ret)
> +					break;
> +			} else {
> +				iomap_read_folio_range_async(iter, ctx, pos, plen);
> +			}

Overly long lines.


