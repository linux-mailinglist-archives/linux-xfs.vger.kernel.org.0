Return-Path: <linux-xfs+bounces-3801-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 729C0853EA9
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Feb 2024 23:30:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9763E1C22AD7
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Feb 2024 22:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19739627E1;
	Tue, 13 Feb 2024 22:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EnxUA+i/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA75627E9
	for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2024 22:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707863382; cv=none; b=HGtrIFf8RmkROdNddG2nfZCWL3bB8C4T4gUUViTPrF+8GyPWsZnYQB+MHFP/2+s6Co4rBlHEY+4yvhn93ZPOWfpKsT6Cpp70s7lOgNHhezCzzt9cs4oZjiAb9zSrdAbaVypDtokps/B+Tzge4tVoUhiYuISvdbjftErz4oIYAfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707863382; c=relaxed/simple;
	bh=plPgDVCs3ncoYYDkHaVCanRJ2fiPA9gJh32izYMOpbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EfFJBmFHBcGz6eq7tra2L1zjR6z6p7xv1pOBNBg4fXwUXUgaeAvoLd4dMv550iXHTGlC8S+98XowinnJfr//eAkiX8wa3vTbh4O0gP7L7ysDD5dXahfKzAyPbnBpqCm2wwPMDZYWKTgZkYT/yRWcxk5RHjj7yvfOtOlKJ2wLs5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EnxUA+i/; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6da9c834646so4000856b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2024 14:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707863379; x=1708468179; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1tsGlujf3U5wgIjzjj3ZkynAP7g286QKuhgEsG9eCxo=;
        b=EnxUA+i/v+41PVqCYgYKpd4E+T/MasJuDjnclungdnkfZzf1FvOvA0BV4noWfBV5D3
         Th4po+yZkE+aQdk4ch01r4JhrzXBZy5ot9KgMPhWGWYxd4GvTgPzmIDBC/5rycbwE9Kp
         2iyNJwQxOgc5aZ9a7ORiKNjmv0wzCvCyw8XR5w4lBEAvjlnI7KLEHxgm3NgcWLU9dceR
         HEts8oIgu/kS0ou1rv4bUhBNAPAeObnDRww2F26VletOgM0/uZfh3nXuqhz4DnSkJ1uT
         Ba15wvYpuTV14Rfpamjx4NKZSg6IYO9xIKa4Oc52HsqW4lgEwVGA+0DuxtzUfCp3ppl2
         Ot4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707863379; x=1708468179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tsGlujf3U5wgIjzjj3ZkynAP7g286QKuhgEsG9eCxo=;
        b=Hi+2ArAYm+7NPTbdo4Zr4haQq2jA6aO75di0gOyoyDejbf6zDylJfdqRmd0ZQr6/qu
         lacTLpai97GbglcVbOxauoS7hmoK8D2sdFs/eqQOefTWfD08SnHsYWnJoD4uVSRrwc9v
         sjKSa4d4gVWxFVuCWVSmQT34vO1U1yML0/BLGRO8IE/AqoOQcbZHcFodCKs0AAX0KoAH
         NQG4gW2JYfNHrXf0YwBHlRQdD1zG2/06tpLHoIe4RnHIwbuv0Xl4mAuVe6H6If8INZVR
         sosk+66qQRC9tTuiQWYBPHsJ76HG1MmzsncuUE9mnUAwl/9Bji1CFJ9SoBl4Sv31mpma
         /f3w==
X-Gm-Message-State: AOJu0Yy+VzoB2l7l5HYcKX7lIennyZ2ZCU6c+pFBu3Os+tyNgToeADb4
	o2QZc7Z/GSNFdvDYEyUKzTtYG/BCpwJt+j1KOt4Wmq1vIE5RYIit8y6ort5VSBw=
X-Google-Smtp-Source: AGHT+IEyaWb1NzllIEt0at5U+E7258Vf7P56wt9349tb0T7YpOyIYiSsnC+HuSOyBQ/Of0B8ji1y9A==
X-Received: by 2002:a05:6a00:2d0d:b0:6e0:f2a6:abde with SMTP id fa13-20020a056a002d0d00b006e0f2a6abdemr845966pfb.5.1707863379463;
        Tue, 13 Feb 2024 14:29:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVGBAOI42Qf39cV7pTd7API1uDQ3e1AxePniZJsj3B6uhT0nwuRLh8I5gLz1dnxk/7lJ+QwPOs/cJAiCXhPwRh6v4eXRFRqkps8PEyVpta9zgy7T+Pw2nb34xBI8Bs7z5BmKaeHJpFcMAxDgaGoc2aEPpEiXuZHRzQJ/PqzIPZhkAmesxB8p+0i5BwgWVgG5jCKMqAQMKu7lY11o7rJMxaro64t7+t/SWVNfoLOgZJVxf7JPZ7Rh/7YwJxzp+FTpLGY83me1rZ8FVCoddoMer/CKcKFZzDQ3mmTmpm9r/W+gjl8oBvjeZVHmqQfUb7vzPWZoyRctYepplqNR5W7Orn1gSXGGSaopCLks+/MLg3M2b4mclSqQyopeBENQ0Y588UZwf10BiWLwVXY9Hs7ULICuXo4yR8NRghA/CI=
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id z1-20020a056a00240100b006e1078461casm323798pfh.183.2024.02.13.14.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 14:29:38 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1ra1HU-0068Aq-1v;
	Wed, 14 Feb 2024 09:29:36 +1100
Date: Wed, 14 Feb 2024 09:29:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	mcgrof@kernel.org, gost.dev@samsung.com, akpm@linux-foundation.org,
	kbusch@kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
	p.raghav@samsung.com, linux-kernel@vger.kernel.org, hare@suse.de,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [RFC v2 05/14] readahead: align index to mapping_min_order in
 ondemand_ra and force_ra
Message-ID: <ZcvtUOecezQD7Mm6@dread.disaster.area>
References: <20240213093713.1753368-1-kernel@pankajraghav.com>
 <20240213093713.1753368-6-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213093713.1753368-6-kernel@pankajraghav.com>

On Tue, Feb 13, 2024 at 10:37:04AM +0100, Pankaj Raghav (Samsung) wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> Align the ra->start and ra->size to mapping_min_order in
> ondemand_readahead(), and align the index to mapping_min_order in
> force_page_cache_ra(). This will ensure that the folios allocated for
> readahead that are added to the page cache are aligned to
> mapping_min_order.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  mm/readahead.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 40 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 4fa7d0e65706..5e1ec7705c78 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -315,6 +315,7 @@ void force_page_cache_ra(struct readahead_control *ractl,
>  	struct file_ra_state *ra = ractl->ra;
>  	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
>  	unsigned long max_pages, index;
> +	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
>  
>  	if (unlikely(!mapping->a_ops->read_folio && !mapping->a_ops->readahead))
>  		return;
> @@ -324,6 +325,13 @@ void force_page_cache_ra(struct readahead_control *ractl,
>  	 * be up to the optimal hardware IO size
>  	 */
>  	index = readahead_index(ractl);
> +	if (!IS_ALIGNED(index, min_nrpages)) {
> +		unsigned long old_index = index;
> +
> +		index = round_down(index, min_nrpages);
> +		nr_to_read += (old_index - index);
> +	}

	new_index = mapping_align_start_index(mapping, index);
	if (new_index != index) {
		nr_to_read += index - new_index;
		index = new_index
	}

> +
>  	max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
>  	nr_to_read = min_t(unsigned long, nr_to_read, max_pages);

This needs to have a size of at least the minimum folio order size
so readahead can fill entire folios, not get neutered to the maximum
IO size the underlying storage supports.

>  	while (nr_to_read) {
> @@ -332,6 +340,7 @@ void force_page_cache_ra(struct readahead_control *ractl,
>  		if (this_chunk > nr_to_read)
>  			this_chunk = nr_to_read;
>  		ractl->_index = index;
> +		VM_BUG_ON(!IS_ALIGNED(index, min_nrpages));
>  		do_page_cache_ra(ractl, this_chunk, 0);
>  
>  		index += this_chunk;
> @@ -344,11 +353,20 @@ void force_page_cache_ra(struct readahead_control *ractl,
>   * for small size, x 4 for medium, and x 2 for large
>   * for 128k (32 page) max ra
>   * 1-2 page = 16k, 3-4 page 32k, 5-8 page = 64k, > 8 page = 128k initial
> + *
> + * For higher order address space requirements we ensure no initial reads
> + * are ever less than the min number of pages required.
> + *
> + * We *always* cap the max io size allowed by the device.
>   */
> -static unsigned long get_init_ra_size(unsigned long size, unsigned long max)
> +static unsigned long get_init_ra_size(unsigned long size,
> +				      unsigned int min_nrpages,
> +				      unsigned long max)
>  {
>  	unsigned long newsize = roundup_pow_of_two(size);
>  
> +	newsize = max_t(unsigned long, newsize, min_nrpages);

This really doesn't need to care about min_nrpages. That rounding
can be done in the caller when the new size is returned.

>  	if (newsize <= max / 32)
>  		newsize = newsize * 4;
>  	else if (newsize <= max / 4)
> @@ -356,6 +374,8 @@ static unsigned long get_init_ra_size(unsigned long size, unsigned long max)
>  	else
>  		newsize = max;
>  
> +	VM_BUG_ON(newsize & (min_nrpages - 1));
> +
>  	return newsize;
>  }
>  
> @@ -364,14 +384,16 @@ static unsigned long get_init_ra_size(unsigned long size, unsigned long max)
>   *  return it as the new window size.
>   */
>  static unsigned long get_next_ra_size(struct file_ra_state *ra,
> +				      unsigned int min_nrpages,
>  				      unsigned long max)
>  {
> -	unsigned long cur = ra->size;
> +	unsigned long cur = max(ra->size, min_nrpages);
>  
>  	if (cur < max / 16)
>  		return 4 * cur;
>  	if (cur <= max / 2)
>  		return 2 * cur;
> +
>  	return max;

Ditto.

>  }
>  
> @@ -561,7 +583,11 @@ static void ondemand_readahead(struct readahead_control *ractl,
>  	unsigned long add_pages;
>  	pgoff_t index = readahead_index(ractl);
>  	pgoff_t expected, prev_index;
> -	unsigned int order = folio ? folio_order(folio) : 0;
> +	unsigned int min_order = mapping_min_folio_order(ractl->mapping);
> +	unsigned int min_nrpages = mapping_min_folio_nrpages(ractl->mapping);
> +	unsigned int order = folio ? folio_order(folio) : min_order;

Huh? If we have a folio, then the order is whatever that folio is,
otherwise we use min_order. What if the folio is larger than
min_order? Doesn't that mean that this:

> @@ -583,8 +609,8 @@ static void ondemand_readahead(struct readahead_control *ractl,
>  	expected = round_down(ra->start + ra->size - ra->async_size,
>  			1UL << order);
>  	if (index == expected || index == (ra->start + ra->size)) {
> -		ra->start += ra->size;
> -		ra->size = get_next_ra_size(ra, max_pages);
> +		ra->start += round_down(ra->size, min_nrpages);
> +		ra->size = get_next_ra_size(ra, min_nrpages, max_pages);

may set up the incorrect readahead range because the folio order is
larger than min_nrpages?

>  		ra->async_size = ra->size;
>  		goto readit;
>  	}
> @@ -603,13 +629,18 @@ static void ondemand_readahead(struct readahead_control *ractl,
>  				max_pages);
>  		rcu_read_unlock();
>  
> +		start = round_down(start, min_nrpages);

		start = mapping_align_start_index(mapping, start);
> +
> +		VM_BUG_ON(folio->index & (folio_nr_pages(folio) - 1));
> +
>  		if (!start || start - index > max_pages)
>  			return;
>  
>  		ra->start = start;
>  		ra->size = start - index;	/* old async_size */
> +
>  		ra->size += req_size;
> -		ra->size = get_next_ra_size(ra, max_pages);
> +		ra->size = get_next_ra_size(ra, min_nrpages, max_pages);

		ra->size = max(min_nrpages, get_next_ra_size(ra, max_pages));

>  		ra->async_size = ra->size;
>  		goto readit;
>  	}
> @@ -646,7 +677,7 @@ static void ondemand_readahead(struct readahead_control *ractl,
>  
>  initial_readahead:
>  	ra->start = index;
> -	ra->size = get_init_ra_size(req_size, max_pages);
> +	ra->size = get_init_ra_size(req_size, min_nrpages, max_pages);

	ra->size = max(min_nrpages, get_init_ra_size(req_size, max_pages));

-Dave.
-- 
Dave Chinner
david@fromorbit.com

