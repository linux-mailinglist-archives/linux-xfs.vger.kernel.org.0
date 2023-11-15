Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1BE7E60D4
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Nov 2023 00:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjKHXGK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Nov 2023 18:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjKHXGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 18:06:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFB52599;
        Wed,  8 Nov 2023 15:06:07 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE81C433C8;
        Wed,  8 Nov 2023 23:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699484767;
        bh=t8pBQSNPVR9LioM+HcvTKgJwQbCrujWjNwfm0VTaR5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kb4LDRBsnf32K7Vz06ikeb1CPOiJ1H15eXMnH9kxTJtY+bF3pXhcR2BSF6zYwQ9fK
         mgsr+P98qJyhfHSMhotMocwnZnya8dqNepcltfzM8d5SSPm+BeIy3OSTsEhS64I852
         xWfR27VQoZFdkB/pFGkyj8cEyQwskDqZcuVcGtAc=
Date:   Wed, 8 Nov 2023 15:06:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-ext4@vger.kernel.org, gfs2@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-erofs@lists.ozlabs.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 1/3] mm: Add folio_zero_tail() and use it in ext4
Message-Id: <20231108150606.2ec3cafb290f757f0e4c92d8@linux-foundation.org>
In-Reply-To: <20231107212643.3490372-2-willy@infradead.org>
References: <20231107212643.3490372-1-willy@infradead.org>
        <20231107212643.3490372-2-willy@infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue,  7 Nov 2023 21:26:40 +0000 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> Instead of unmapping the folio after copying the data to it, then mapping
> it again to zero the tail, provide folio_zero_tail() to zero the tail
> of an already-mapped folio.
> 
> ...
>
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -483,6 +483,44 @@ static inline void memcpy_to_folio(struct folio *folio, size_t offset,
>  	flush_dcache_folio(folio);
>  }
>  
> +/**
> + * folio_zero_tail - Zero the tail of a folio.
> + * @folio: The folio to zero.
> + * @kaddr: The address the folio is currently mapped to.
> + * @offset: The byte offset in the folio to start zeroing at.

That's the argument ordering I would expect.

> + * If you have already used kmap_local_folio() to map a folio, written
> + * some data to it and now need to zero the end of the folio (and flush
> + * the dcache), you can use this function.  If you do not have the
> + * folio kmapped (eg the folio has been partially populated by DMA),
> + * use folio_zero_range() or folio_zero_segment() instead.
> + *
> + * Return: An address which can be passed to kunmap_local().
> + */
> +static inline __must_check void *folio_zero_tail(struct folio *folio,
> +		size_t offset, void *kaddr)

While that is not.  addr,len is far more common that len,addr?

> +{
> +	size_t len = folio_size(folio) - offset;

Calling it `remaining' would be more clear.

> +
> +	if (folio_test_highmem(folio)) {
> +		size_t max = PAGE_SIZE - offset_in_page(offset);
> +
> +		while (len > max) {

Shouldn't this be `while (len)'?  AFAICT this code can fail to clear
the final page.

> +			memset(kaddr, 0, max);
> +			kunmap_local(kaddr);
> +			len -= max;
> +			offset += max;
> +			max = PAGE_SIZE;
> +			kaddr = kmap_local_folio(folio, offset);
> +		}
> +	}
> +
> +	memset(kaddr, 0, len);
> +	flush_dcache_folio(folio);
> +
> +	return kaddr;
> +}
> +

