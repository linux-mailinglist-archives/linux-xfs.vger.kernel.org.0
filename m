Return-Path: <linux-xfs+bounces-16556-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D189EE7A3
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2024 14:28:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D6041888716
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2024 13:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133B321421C;
	Thu, 12 Dec 2024 13:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TX+F/+iv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D242135BE
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 13:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734010077; cv=none; b=bsnCUNx5sYR3WpcmKa1QBtUn8rnfvH48Pjo5P+9xO9daNZt509r6v7Fkwui6PQExshHnaan+EduNj4+4fwfmpxSRC1tX8JGzYZnvaJI0KNq3cxGBON2GxIqSDh+XLIL3E22LRcbX4aJiH67w9zqsYi6gKq4ov5qoDhlk7rJIFJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734010077; c=relaxed/simple;
	bh=OGKoL81eSH9XXXoc+yTb9xGw9ItLXgoWxbtUCL3/rHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sppkdr3OEIEGdhvNJU/LLp9dxsLgK0WlABNpY41OtAwfseL6QXLi/kJ90DZi69+ZpgpnU4/y+8SJ3n6XQbk6NuHLGq5AXQidkNRPv7OyIzK3xs4JAiadMakuEqQZ3VFiLVbq3Im3xhtFQi7jHLec4lQ4eobwkDuS6thLIq9LpcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TX+F/+iv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734010074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T4XRJC9PASaM2gGNhxY8Ao+azk+Wj5WID2tbew1FdGE=;
	b=TX+F/+ivcLiYmtvl1MbANXdFDo0szwtGZFHj1cY19o8246p9qCG4acaIk2q+U8c29GlLoT
	es0Yh8Aed0guwyEbSIFByTGG9DARHKhH4hCtuFu0Uz3thnW2635C/ALExTk9BNV0s/hDCz
	TowYnYrScir5++AmR8UfVZOMetw5wwE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-163-oJUWQYoaNSGPiJWlgXA6eQ-1; Thu,
 12 Dec 2024 08:27:52 -0500
X-MC-Unique: oJUWQYoaNSGPiJWlgXA6eQ-1
X-Mimecast-MFC-AGG-ID: oJUWQYoaNSGPiJWlgXA6eQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6297F1955F57;
	Thu, 12 Dec 2024 13:27:51 +0000 (UTC)
Received: from bfoster (unknown [10.22.90.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5818A1956052;
	Thu, 12 Dec 2024 13:27:50 +0000 (UTC)
Date: Thu, 12 Dec 2024 08:29:36 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/8] iomap: optionally use ioends for direct I/O
Message-ID: <Z1rlQA6N8tCfRlLi@bfoster>
References: <20241211085420.1380396-1-hch@lst.de>
 <20241211085420.1380396-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085420.1380396-6-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Dec 11, 2024 at 09:53:45AM +0100, Christoph Hellwig wrote:
> struct iomap_ioend currently tracks outstanding buffered writes and has
> some really nice code in core iomap and XFS to merge contiguous I/Os
> an defer them to userspace for completion in a very efficient way.
> 
> For zoned writes we'll also need a per-bio user context completion to
> record the written blocks, and the infrastructure for that would look
> basically like the ioend handling for buffered I/O.
> 
> So instead of reinventing the wheel, reuse the existing infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/buffered-io.c |  3 +++
>  fs/iomap/direct-io.c   | 50 +++++++++++++++++++++++++++++++++++++++++-
>  fs/iomap/internal.h    |  7 ++++++
>  include/linux/iomap.h  |  4 +++-
>  4 files changed, 62 insertions(+), 2 deletions(-)
>  create mode 100644 fs/iomap/internal.h
> 
...
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index b521eb15759e..b5466361cafe 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
...
> @@ -163,6 +166,51 @@ static inline void iomap_dio_set_error(struct iomap_dio *dio, int ret)
>  	cmpxchg(&dio->error, 0, ret);
>  }
>  
> +u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend)
> +{
> +	struct iomap_dio *dio = ioend->io_bio.bi_private;
> +	bool should_dirty = (dio->flags & IOMAP_DIO_DIRTY);
> +	struct kiocb *iocb = dio->iocb;
> +	u32 vec_count = ioend->io_bio.bi_vcnt;
> +
> +	if (ioend->io_error)
> +		iomap_dio_set_error(dio, ioend->io_error);
> +
> +	if (atomic_dec_and_test(&dio->ref)) {
> +		struct inode *inode = file_inode(iocb->ki_filp);
> +
> +		if (dio->wait_for_completion) {
> +			struct task_struct *waiter = dio->submit.waiter;
> +
> +			WRITE_ONCE(dio->submit.waiter, NULL);
> +			blk_wake_io_task(waiter);
> +		} else if (!inode->i_mapping->nrpages) {
> +			WRITE_ONCE(iocb->private, NULL);
> +
> +			/*
> +			 * We must never invalidate pages from this thread to
> +			 * avoid deadlocks with buffered I/O completions.
> +			 * Tough luck if you hit the tiny race with someone
> +			 * dirtying the range now.
> +			 */
> +			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
> +			iomap_dio_complete_work(&dio->aio.work);
> +		} else {
> +			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
> +			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> +		}
> +	}
> +
> +	if (should_dirty) {
> +		bio_check_pages_dirty(&ioend->io_bio);
> +	} else {
> +		bio_release_pages(&ioend->io_bio, false);
> +		bio_put(&ioend->io_bio);
> +	}
> +

Not that it matters all that much, but I'm a little curious about the
reasoning for using vec_count here. AFAICS this correlates to per-folio
writeback completions for buffered I/O, but that doesn't seem to apply
to direct I/O. Is there a reason to have the caller throttle based on
vec_counts, or are we just pulling some non-zero value for consistency
sake?

Brian

> +	return vec_count;
> +}
> +
>  void iomap_dio_bio_end_io(struct bio *bio)
>  {
>  	struct iomap_dio *dio = bio->bi_private;
> diff --git a/fs/iomap/internal.h b/fs/iomap/internal.h
> new file mode 100644
> index 000000000000..20cccfc3bb13
> --- /dev/null
> +++ b/fs/iomap/internal.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _IOMAP_INTERNAL_H
> +#define _IOMAP_INTERNAL_H 1
> +
> +u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend);
> +
> +#endif /* _IOMAP_INTERNAL_H */
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index eaa8cb9083eb..f6943c80e5fd 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -343,9 +343,11 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
>  #define IOMAP_IOEND_UNWRITTEN		(1U << 1)
>  /* don't merge into previous ioend */
>  #define IOMAP_IOEND_BOUNDARY		(1U << 2)
> +/* is direct I/O */
> +#define IOMAP_IOEND_DIRECT		(1U << 3)
>  
>  #define IOMAP_IOEND_NOMERGE_FLAGS \
> -	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN)
> +	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
>  
>  /*
>   * Structure for writeback I/O completions.
> -- 
> 2.45.2
> 
> 


