Return-Path: <linux-xfs+bounces-26009-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B18BA11A6
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Sep 2025 20:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4548E6C1F67
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Sep 2025 18:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47CD231B123;
	Thu, 25 Sep 2025 18:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JxuP2M9R"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBE831B12D
	for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758826656; cv=none; b=IxWh9qbLJevmGiqRDS4TDSi/WCJphtZTmTvX3unH0V4Y6zzMg+ML2VU3bv8+bHhDVrX6k826k6pdmORtg+IBh9cmWHCchhNXk6DsgSroF+IozKhHARmKw54VkozolJ0cPvh2NwBwdGyhLXxI8cC2hGxwiGhf7lYLoHjDq0bDVOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758826656; c=relaxed/simple;
	bh=j5gkSv/3UaxKbaNRZmLoYcyk0+yVwcOA5OeU8sjTjKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVFlRcCw15ZuGbOsWJMJil/lLzuRVp5+9UBXNvxAsAlIrM29caDLgevN/t5XLPKFKS2QwkW4kSnIjv6xsY4/C0l7+Tc9N3Mh1H7fR8IowV/0ye5COcX5XTLBe1wKczFrJsRx/EfsoL3U9W38hEV2xtWvmdEtTEkF4+WO04rYxz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JxuP2M9R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758826652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xDIYoUk2aYSVEyb/ZokojK1Od3xlyMIfNybo+1mukeM=;
	b=JxuP2M9RfnytWQRl7ZoxnfPoM0/t8RmZ84zThO5p0UxZywYpcyCTlFxDVIOGnG7wYRP4ZM
	vJ4OVn3Ra7wYd/v1ZbZTbOJhRtfGCdN5hlPvLqR0ynzjnt5sYKPTpfiLp3eTfP3efuYk+x
	A2m9Pw8C9Ef9kfF08oqaKzma25P+qLk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-Jl37rhTYO5y7Vs-CMSSc-A-1; Thu,
 25 Sep 2025 14:57:26 -0400
X-MC-Unique: Jl37rhTYO5y7Vs-CMSSc-A-1
X-Mimecast-MFC-AGG-ID: Jl37rhTYO5y7Vs-CMSSc-A_1758826645
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CA5C19560B5;
	Thu, 25 Sep 2025 18:57:25 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.134])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61553300021A;
	Thu, 25 Sep 2025 18:57:23 +0000 (UTC)
Date: Thu, 25 Sep 2025 15:01:33 -0400
From: Brian Foster <bfoster@redhat.com>
To: alexjlzheng@gmail.com
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	kernel@pankajraghav.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH v5 4/4] iomap: don't abandon the whole copy when we have
 iomap_folio_state
Message-ID: <aNWRjekDBHRelmbS@bfoster>
References: <20250923042158.1196568-1-alexjlzheng@tencent.com>
 <20250923042158.1196568-5-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923042158.1196568-5-alexjlzheng@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Sep 23, 2025 at 12:21:58PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> Currently, if a partial write occurs in a buffer write, the entire write will
> be discarded. While this is an uncommon case, it's still a bit wasteful and
> we can do better.
> 
> With iomap_folio_state, we can identify uptodate states at the block
> level, and a read_folio reading can correctly handle partially
> uptodate folios.
> 
> Therefore, when a partial write occurs, accept the block-aligned
> partial write instead of rejecting the entire write.
> 
> For example, suppose a folio is 2MB, blocksize is 4kB, and the copied
> bytes are 2MB-3kB.
> 
> Without this patchset, we'd need to recopy from the beginning of the
> folio in the next iteration, which means 2MB-3kB of bytes is copy
> duplicately.
> 
>  |<-------------------- 2MB -------------------->|
>  +-------+-------+-------+-------+-------+-------+
>  | block |  ...  | block | block |  ...  | block | folio
>  +-------+-------+-------+-------+-------+-------+
>  |<-4kB->|
> 
>  |<--------------- copied 2MB-3kB --------->|       first time copied
>  |<-------- 1MB -------->|                          next time we need copy (chunk /= 2)
>                          |<-------- 1MB -------->|  next next time we need copy.
> 
>  |<------ 2MB-3kB bytes duplicate copy ---->|
> 
> With this patchset, we can accept 2MB-4kB of bytes, which is block-aligned.
> This means we only need to process the remaining 4kB in the next iteration,
> which means there's only 1kB we need to copy duplicately.
> 
>  |<-------------------- 2MB -------------------->|
>  +-------+-------+-------+-------+-------+-------+
>  | block |  ...  | block | block |  ...  | block | folio
>  +-------+-------+-------+-------+-------+-------+
>  |<-4kB->|
> 
>  |<--------------- copied 2MB-3kB --------->|       first time copied
>                                          |<-4kB->|  next time we need copy
> 
>                                          |<>|
>                               only 1kB bytes duplicate copy
> 
> Although partial writes are inherently a relatively unusual situation and do
> not account for a large proportion of performance testing, the optimization
> here still makes sense in large-scale data centers.
> 

Thanks for the nice writeup and diagrams.

> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
>  fs/iomap/buffered-io.c | 44 +++++++++++++++++++++++++++++++++---------
>  1 file changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 6e516c7d9f04..3304028ce64f 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -873,6 +873,25 @@ static int iomap_write_begin(struct iomap_iter *iter,
>  	return status;
>  }
>  
> +static int iomap_trim_tail_partial(struct inode *inode, loff_t pos,
> +		size_t copied, struct folio *folio)
> +{
> +	struct iomap_folio_state *ifs = folio->private;
> +	unsigned block_size, last_blk, last_blk_bytes;
> +
> +	if (!ifs || !copied)
> +		return 0;
> +
> +	block_size = 1 << inode->i_blkbits;

I'd move this assignment to declaration time.

> +	last_blk = offset_in_folio(folio, pos + copied - 1) >> inode->i_blkbits;
> +	last_blk_bytes = (pos + copied) & (block_size - 1);
> +
> +	if (!ifs_block_is_uptodate(ifs, last_blk))
> +		copied -= min(copied, last_blk_bytes);

So I think I follow the idea here and it seems reasonable at first
glance. IIUC, the high level issue is that for certain writes we don't
read blocks up front if the write is expected to fully overwrite
blocks/folios, as we can just mark things uptodate on write completion.
If the write is short however, we now have a partial write to a
!uptodate block, so have to toss the write.

A few initial thoughts..

1. I don't really love the function name here. Maybe something like
iomap_write_end_short() or something would be more clear, but maybe
there are other opinions.

2. It might be helpful to move some of the comment below up to around
here where we actually trim the copied value.

3. I see that in __iomap_write_begin() we don't necessarily always
attach ifs if a write is expected to fully overwrite the entire folio.
It looks like that is handled with the !ifs check above, but it also
makes me wonder how effective this change is.

For example, the example in the commit log description appears to be a
short write of an attempted overwrite of a 2MB folio, right? Would we
expect to have ifs in that situation?

I don't really object to having the logic even if it is a real corner
case, but it would be good to have some test coverage to verify
behavior. Do you have a test case or anything (even if contrived) along
those lines? Perhaps we could play some games with badly formed
syscalls. A quick test to call pwritev() with a bad iov_base pointer
seems to produce a short write, but I haven't confirmed that's
sufficient for testing here..

Brian

> +
> +	return copied;
> +}
> +
>  static int __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
>  		size_t copied, struct folio *folio)
>  {
> @@ -881,17 +900,24 @@ static int __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
>  	/*
>  	 * The blocks that were entirely written will now be uptodate, so we
>  	 * don't have to worry about a read_folio reading them and overwriting a
> -	 * partial write.  However, if we've encountered a short write and only
> -	 * partially written into a block, it will not be marked uptodate, so a
> -	 * read_folio might come in and destroy our partial write.
> +	 * partial write.
>  	 *
> -	 * Do the simplest thing and just treat any short write to a
> -	 * non-uptodate page as a zero-length write, and force the caller to
> -	 * redo the whole thing.
> +	 * However, if we've encountered a short write and only partially
> +	 * written into a block, we must discard the short-written _tail_ block
> +	 * and not mark it uptodate in the ifs, to ensure a read_folio reading
> +	 * can handle it correctly via iomap_adjust_read_range(). It's safe to
> +	 * keep the non-tail block writes because we know that for a non-tail
> +	 * block:
> +	 * - is either fully written, since copy_from_user() is sequential
> +	 * - or is a partially written head block that has already been read in
> +	 *   and marked uptodate in the ifs by iomap_write_begin().
>  	 */
> -	if (unlikely(copied < len && !folio_test_uptodate(folio)))
> -		return 0;
> -	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
> +	if (unlikely(copied < len && !folio_test_uptodate(folio))) {
> +		copied = iomap_trim_tail_partial(inode, pos, copied, folio);
> +		if (!copied)
> +			return 0;
> +	}
> +	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), copied);
>  	iomap_set_range_dirty(folio, offset_in_folio(folio, pos), copied);
>  	filemap_dirty_folio(inode->i_mapping, folio);
>  	return copied;
> -- 
> 2.49.0
> 
> 


