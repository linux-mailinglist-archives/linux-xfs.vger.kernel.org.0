Return-Path: <linux-xfs+bounces-20473-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E74A4EF2F
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Mar 2025 22:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C63D03A37DF
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Mar 2025 21:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8464E264FBD;
	Tue,  4 Mar 2025 21:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="dZSR7gXk"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BFA1F76A8
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 21:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122693; cv=none; b=aHWjp2zC4qsNNtojd5oRfqPzjhlHOCv7N8k24bCsKH32gJsnrhBcWqrXBuQYA4mos/Iuh6nb1ogTcjpqEH6sAdtTjm98RfGm0pl7v7xlUEqpvG3yHvrm325okmxWr3xsc2yBs8rlm43N9VGMcber/lKXhc5BHeTtaUVxfKPb/Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122693; c=relaxed/simple;
	bh=0E3T5Hp+sMKQhmdLWvSGxflpCJKf0yCp4IKXvTlchuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wrd3AVkca5gI6PdaTmOuMcve5A6vRA7HLhNWmV/OfwUzuv9/ohLi6GGuh94Mg6rv00k0JhL6XJ2zEpXLnQbOQrngWSGuafSG6gYDqzVnVixNJoTqeGw4u0WYoBoU8ZpO1oYR6Db+OG60BZN63bAdNtrLg7nQ8jPFehw6co6xbAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=dZSR7gXk; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2234bec7192so105799065ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Mar 2025 13:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741122691; x=1741727491; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5u9T8buzgB1g+ZB8WQvIpl66rBv5TutDiyFxRCUgI8=;
        b=dZSR7gXk6u+cXjL/+VDSQJ/3d3D1YhruJ+MjOdxLCY78uREgwD8ftmVXg4RZOAn9j1
         E22X97OiO5WPFTvxDqkTh29FipsFoiYyu+s7YivY7bXKM6ghRfqCbD2piUW7oLW2Y58O
         H7XHYX4L0LSoF2Vdx0s9cZzO6Dsy0zeg80gi777L1pmhgmgylxzl4dA54oS0AobCW8re
         sU74TNbJd3suUFhvURlpjCqgt+Hy5Mefo8lK4r8pG4iftRfXtqz+VbDhJGMzUqY6Rj1H
         FUMAkGulpM1bHHuUA8Fai4twX6zWmx4+jOSCsr/LrS4J4oMEYo+WhpK0JaRcCx+Czw1D
         zqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741122691; x=1741727491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z5u9T8buzgB1g+ZB8WQvIpl66rBv5TutDiyFxRCUgI8=;
        b=l9IfkX1mWWH0Epm9+DoqE6cg3XeuIzoHbr4x7+stFdnC+R4Bv9YZcP6G3ZHuLGMQCZ
         FHVdFNYO1eWbH23s8EV7nSfBpZVmLDhwmnK8L3mvzOvtmV++xAdrooR219HQ/dnSqp5a
         0MtXlezqhWdkzly6jpEAFnKqz8DgOOkT9xSFJdDZlOyBsl3F4N8ycgAC3rOY4rsBkqne
         JjyYI56ZrPUMv29y6U8gIV9AbmRAmN9yckwQGmfiFADldeXUF+bzZGf0F97385GnFsmp
         qt09fuCKvfbrwkZ0LrvrfjEsdFJqi8rmj5Ou4XKTKX6oUJ1oseSppvxKa9Gfd7GTOdY0
         Zq5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5wsCDTZ15dhaf3JW6v39I2TZExjv446LLnFIN0YOWCE6r4z0UkowE9RwXTA3NBPQ39U2N8HxGOa0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrf4QijF7OVoyugRdZ0NiIaLKZfWJwORTQCinCwTbGGj/Wi/p3
	bfMyeL/1uwlF4HAfpB2bECy0cCPmLE4ZUTCIqSKr5kM2pETb6Vzm43WnvAOZE2o=
X-Gm-Gg: ASbGncvCC4Gk7PfjESTq1MOzGZvrM0qCzLRHxBgEDTtYn2+TrrIJpAAJZBm95Azcd2R
	9ueQT3zQCMxsWB/Di9vgEUGTyE8BxCAQDmhmg6bdSd42Q0axG8U9lR+5+4BX/UlcRJgGsIjSFwN
	lh/FYuorHMg+WjrRdnyAnD334jH3QF/e+tWw2KLFnfsye4B0ahnOT6J0he5vAi125bveKJ2h6Lx
	oM4xL9fxwCbAvNUVaPVHvR3+GtL2Ae5THdyPW+kv0dRsZwl6zFxdGDkTY2rBkBpuTae1lAjDUXp
	s1sCWPSuQHvo1l/xGJv0bXCzAwrSI8tba+yWdKf32QH3jmTLODt5M7tV44rQsB/yRBEzwrWdHzn
	WPjRUrT1KlmIPukPQ6zUw
X-Google-Smtp-Source: AGHT+IFYVR//RHCOvcKfA/QF6rtFm/idAwEGSxepnoQAdAXiRGfBac/SE2HTdXKT4z1YO6U91gNlbA==
X-Received: by 2002:a17:902:ec92:b0:220:d272:534d with SMTP id d9443c01a7336-223f1c81ee0mr11592985ad.22.1741122691015;
        Tue, 04 Mar 2025 13:11:31 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2235053e41asm99610285ad.255.2025.03.04.13.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 13:11:30 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpZXz-00000008ttX-3vyR;
	Wed, 05 Mar 2025 08:11:27 +1100
Date: Wed, 5 Mar 2025 08:11:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8dsfxVqpv-kqeZy@dread.disaster.area>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>

On Tue, Mar 04, 2025 at 12:18:07PM +0000, Pavel Begunkov wrote:
> There are reports of high io_uring submission latency for ext4 and xfs,
> which is due to iomap not propagating nowait flag to the block layer
> resulting in waiting for IO during tag allocation.
> 
> Because of how errors are propagated back, we can't set REQ_NOWAIT
> for multi bio IO, in this case return -EAGAIN and let the caller to
> handle it, for example, it can reissue it from a blocking context.
> It's aligned with how raw bdev direct IO handles it.
> 
> Cc: stable@vger.kernel.org
> Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
> Reported-by: wu lei <uwydoc@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> v2:
> 	Fail multi-bio nowait submissions
> 
>  fs/iomap/direct-io.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index b521eb15759e..07c336fdf4f0 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -363,9 +363,14 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  	 */
>  	if (need_zeroout ||
>  	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
> -	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
> +	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
>  		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
>  
> +		if (!is_sync_kiocb(dio->iocb) &&
> +		    (dio->iocb->ki_flags & IOCB_NOWAIT))
> +			return -EAGAIN;
> +	}

How are we getting here with IOCB_NOWAIT IO? This is either
sub-block unaligned write IO, it is a write IO that requires
allocation (i.e. write beyond EOF), or we are doing a O_DSYNC write
on hardware that doesn't support REQ_FUA. 

The first 2 cases should have already been filtered out by the
filesystem before we ever get here. The latter doesn't require
multiple IOs in IO submission - the O_DSYNC IO submission (if any is
required) occurs from data IO completion context, and so it will not
block IO submission at all.

So what type of IO in what mapping condition is triggering the need
to return EAGAIN here?

> +
>  	/*
>  	 * The rules for polled IO completions follow the guidelines as the
>  	 * ones we set for inline and deferred completions. If none of those
> @@ -374,6 +379,23 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  	if (!(dio->flags & (IOMAP_DIO_INLINE_COMP|IOMAP_DIO_CALLER_COMP)))
>  		dio->iocb->ki_flags &= ~IOCB_HIPRI;
>  
> +	bio_opf = iomap_dio_bio_opflags(dio, iomap, use_fua, atomic);
> +
> +	if (!is_sync_kiocb(dio->iocb) && (dio->iocb->ki_flags & IOCB_NOWAIT)) {
> +		/*
> +		 * This is nonblocking IO, and we might need to allocate
> +		 * multiple bios. In this case, as we cannot guarantee that
> +		 * one of the sub bios will not fail getting issued FOR NOWAIT
> +		 * and as error results are coalesced across all of them, ask
> +		 * for a retry of this from blocking context.
> +		 */
> +		if (bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS + 1) >
> +					  BIO_MAX_VECS)
> +			return -EAGAIN;
> +
> +		bio_opf |= REQ_NOWAIT;
> +	}

Ok, so this allows a max sized bio to be used. So, what, 1MB on 4kB
page size is the maximum IO size for IOCB_NOWAIT now? I bet that's
not documented anywhere....

Ah. This doesn't fix the problem at all.

Say, for exmaple, I have a hardware storage device with a max
hardware IO size of 128kB. This is from the workstation I'm typing
this email on:

$ cat /sys/block/nvme0n1/queue/max_hw_sectors_kb
128
$  cat /sys/block/nvme0n1/queue/max_segments
33
$

We build a 1MB bio above, set REQ_NOWAIT, then:

submit_bio
  ....
  blk_mq_submit_bio
    __bio_split_to_limits(bio, &q->limits, &nr_segs);
      bio_split_rw()
        .....
        split:
	.....
        /*                                                                       
         * We can't sanely support splitting for a REQ_NOWAIT bio. End it        
         * with EAGAIN if splitting is required and return an error pointer.     
         */                                                                      
        if (bio->bi_opf & REQ_NOWAIT)                                            
                return -EAGAIN;                                                  


So, REQ_NOWAIT effectively limits bio submission to the maximum
single IO size of the underlying storage. So, we can't use
REQ_NOWAIT without actually looking at request queue limits before
we start building the IO - yuk.

REQ_NOWAIT still feels completely unusable to me....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

