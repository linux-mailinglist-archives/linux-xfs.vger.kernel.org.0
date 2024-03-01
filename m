Return-Path: <linux-xfs+bounces-4520-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC9E86D86A
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Mar 2024 01:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FE1E1C2115B
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Mar 2024 00:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE11525B;
	Fri,  1 Mar 2024 00:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="RUc4p1qK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097CD4C73
	for <linux-xfs@vger.kernel.org>; Fri,  1 Mar 2024 00:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709253658; cv=none; b=eb1KO5PsMt+YwQTu1sENbX+djAjnblDA0LUEuI1+vZaHL6zl9S/aicQ8N12BqdOZWrWBMg5i7IHnFSp8ScYEzTxYDIlN5gfpcakkF0e9B8zxS0RS6OLRatz/VyQ+KWhdr5jTu3NE3mjkPHfncm0klMtaKqF+p2HZHR8YcjB+0iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709253658; c=relaxed/simple;
	bh=Jd55ktx7sIvEBT3eIFkfgxP4nZ+VdQo972+ClU6asOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RYK9IlskpVcvXWLN7mc8GXtTwjiiZp8EmdHBRyt3ngotr+SRvZVVnpilJH/sKQRnwxdf9RNB8Zz2SOHlD8LsqgqE8bL3qDdm9RSBrF77vzrvAsz2+kr/gMS0PXJEtZGKtN+dr7c7KC+3Wr+RMjsT4SjhwBOhK8NwYuXkN1fGZOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=RUc4p1qK; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e59bbdd8c7so1030478b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 16:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709253656; x=1709858456; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kfSdJtng8toNd1HcgJhNo8INQxZO5f83GRD0aHxNifg=;
        b=RUc4p1qKmj962PYnox1SZNSUSj04bVdEguBT5lWMAAeHx7mLna89MVimkGihnnwevq
         jbX0lNdIilTcfxbkGrnwUGGMbrKNrz7T/UGyNt3/Sm4Ee1l6CizK9IDuPIcvyt+58wVK
         ecR7/VbKL4IaHEg7JgxjdpKTusOHtwMN9xINjoRaWz0o6EiwExSnNE/nRloezuzi8auo
         PG4K+EGGnbSgq74Y9/g6wTxCBfTpbIxS3zGEDpCh1S19Z0cpyoeXSw66XSD4iy3XN8DL
         F0bSZPdDQzC6aXIoJOyTD043jONo9zWrVsdRdPRnCNvPnAPpPmhLOClXbYCF9HWrmVp5
         sNLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709253656; x=1709858456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfSdJtng8toNd1HcgJhNo8INQxZO5f83GRD0aHxNifg=;
        b=J44bvMzYb1c1qCWq3jENwq/hjTbdk9CoV64tIsgYpdFUfCmC5AfqhUE3eiqD0Ehz2F
         i0Itat67HYdSJQ0/AwZFMx3UCRiZZycvo1NqjszvyLuR1o8roxDNYs/dY3rHTw4zJCDh
         g6ENjoQg6akMdJdUY/arWMiiO/tJgcVcpCZP5djUPDGayGsO8ZD7why7QB1IG/1nKili
         SAWUYOSZ4PW3hLAjMJCSvWDHmvNUvPNWKP6eSmlj5xn8WInzLwaehN8O+N/PyatRK9PO
         /KZj8D3InpUv/21d3Mm57UILNg+i2YbYGyd1Arz3+My17wejYR7HVknbOX/qDr+IrvLY
         tDhA==
X-Forwarded-Encrypted: i=1; AJvYcCUJ38g4o2p5HUDAtumMuF6HXj2XxiE3+5ay3cwddwL7OvQHNuC6Q9NWQFwccem2+2gJBVbdw8RFjpR47C8P4FXyNRwBM39MJDYg
X-Gm-Message-State: AOJu0YywtmlXMY4reWPREzt/K9qv1UpIl+8MzAxQFr4v7euUjaTuYb5q
	HuyBV89i4SvYBClza6cHSn/oLe04TpWrBzwZ13Yaml+WCE5FKr5jgf8EB7Cs81Q=
X-Google-Smtp-Source: AGHT+IG9nkRVk+NgGLMyPlKdjw+Y3IsswCmGwjGEj2FO0wwKgpYsp4rScEINGBD3rE4r1rC3yAQIBg==
X-Received: by 2002:a05:6a00:4f94:b0:6e4:ea68:633f with SMTP id ld20-20020a056a004f9400b006e4ea68633fmr366985pfb.20.1709253656373;
        Thu, 29 Feb 2024 16:40:56 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id y13-20020aa7854d000000b006e56cc934b8sm1837363pfn.154.2024.02.29.16.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 16:40:55 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rfqxJ-00DKr4-1Q;
	Fri, 01 Mar 2024 11:40:53 +1100
Date: Fri, 1 Mar 2024 11:40:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, jack@suse.cz, tytso@mit.edu,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yi.zhang@huawei.com
Subject: Re: [PATCH RFC 1/2] iomap: Add a IOMAP_DIO_MAY_INLINE_COMP flag
Message-ID: <ZeEkFUCUQ4eR7AlX@dread.disaster.area>
References: <20240229113849.2222577-1-chengzhihao1@huawei.com>
 <20240229113849.2222577-2-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229113849.2222577-2-chengzhihao1@huawei.com>

On Thu, Feb 29, 2024 at 07:38:48PM +0800, Zhihao Cheng wrote:
> It will be more efficient to execute quick endio process(eg. non-sync
> overwriting case) under irq process rather than starting a worker to
> do it.
> Add a flag to control DIO to be finished inline(under irq context), which
> can be used for non-sync overwriting case.
> Besides, skip invalidating pages if DIO is finished inline, which will
> keep the same logic with dio_bio_end_aio in non-sync overwriting case.
> 
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>

A nice idea, but I don't think an ext4 specific API flag is the
right way to go about enabling this. The iomap dio code knows if
the write is pure overwrite already - we have the IOMAP_F_DIRTY flag
for that, and we combine this with IOMAP_DIO_WRITE_THROUGH to do the
pure overwrite FUA optimisations.

That is:

		/*
                 * Use a FUA write if we need datasync semantics, this is a pure
                 * data IO that doesn't require any metadata updates (including
                 * after IO completion such as unwritten extent conversion) and
                 * the underlying device either supports FUA or doesn't have
                 * a volatile write cache. This allows us to avoid cache flushes
                 * on IO completion. If we can't use writethrough and need to
                 * sync, disable in-task completions as dio completion will
                 * need to call generic_write_sync() which will do a blocking
                 * fsync / cache flush call.
                 */
                if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
                    (dio->flags & IOMAP_DIO_WRITE_THROUGH) &&
                    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
                        use_fua = true;

Hence if we want to optimise pure overwrites that have no data sync
requirements, we already have the detection and triggers in place to
do this. We just need to change the way we set up the IO flags to
allow write-through (i.e. non-blocking IO completions) to use inline
completions.

In __iomap_dio_rw():

+	/* Always try to complete inline. */
+	dio->flags |= IOMAP_DIO_INLINE_COMP;
	if (iov_iter_rw(iter) == READ) {                                         
-               /* reads can always complete inline */                           
-               dio->flags |= IOMAP_DIO_INLINE_COMP;
....

	} else {
+		/* Always try write-through semantics. If we can't
+		 * use writethough, it will be disabled along with
+		 * IOMAP_DIO_INLINE_COMP before dio completion is run
+		 * so it can be deferred to a task completion context
+		 * appropriately.
+		 */
+               dio->flags |= IOMAP_DIO_WRITE | IOMAP_DIO_WRITE_THROUGH;
		iomi.flags |= IOMAP_WRITE;
-               dio->flags |= IOMAP_DIO_WRITE;
.....
		/* for data sync or sync, we need sync completion processing */
                if (iocb_is_dsync(iocb)) {
                        dio->flags |= IOMAP_DIO_NEED_SYNC;

-                      /*
-                       * For datasync only writes, we optimistically try using
-                       * WRITE_THROUGH for this IO. This flag requires either
-                       * FUA writes through the device's write cache, or a
-                       * normal write to a device without a volatile write
-                       * cache. For the former, Any non-FUA write that occurs
-                       * will clear this flag, hence we know before completion
-                       * whether a cache flush is necessary.
-                       */
-                       if (!(iocb->ki_flags & IOCB_SYNC))
-                               dio->flags |= IOMAP_DIO_WRITE_THROUGH;
+			* For sync writes we know we are going to need
+			* blocking completion processing, so turn off
+			* writethrough now.
+			*/
			if (iocb->ki_flags & IOCB_SYNC) {
				dio->flags &= ~(IOMAP_DIO_WRITE_THROUGH |
						IOMAP_DIO_INLINE_COMP);
			}
                }

This then sets up iomap_dio_bio_iter() to be able to determine if
the iomap returned is for a pure overwrite and allow for the use of
inline write completions.

	/*
	 * If we have a pure overwrite, we know that IO completion
	 * will not block and so we can use write through completion
	 * semantics and complete the write inline. If it's not a
	 * pure overwrite, make sure that we always defer
	 * completions to a task context.
	 */
	if (dio->flags & IOMAP_DIO_WRITE_THROUGH) {
		if (iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) {
			dio->flags &= ~(IOMAP_DIO_WRITE_THROUGH |
					IOMAP_DIO_INLINE_COMP);
		} else if ((dio->flags & IOMAP_DIO_NEED_SYNC) &&
			   (bdev_fua(iomap->bdev) ||
			    !bdev_write_cache(iomap->bdev))) {
			/*
			 * Use REQ_FUA for datasync overwrites to
			 * avoid cache flushes on IO completion on
			 * devices that support FUA or don't have
			 * volatile caches.
			 */
			use_fua = true;
		}
	}


and iomap_dio_bio_opflags() gets changed to also clear
IOMAP_DIO_INLINE_COMP when it clears IOMAP_DIO_WRITE_THROUGH....

That then makes all pure overwrites for every filesystem do inline
completions without changing calling conventions. i.e. it's up to
the filesystem ->iomap_begin callouts to indicate whether the write
mapping returned requires blocking operations to be done in IO
completion (i.e. set the IOMAP_F_DIRTY flag) appropriately.

However, this does mean that any spinlock taken in the ->end_io()
callbacks now needs to be irq safe. e.g. in xfs_dio_write_end_io()
the spinlock protection around inode size updates will need to use
an irq safe locking, as will the locking in the DIO submission path
that it serialises against in xfs_file_write_checks(). That probably
is best implemented as a separate spinlock.

There will also be other filesystems that need to set IOMAP_F_DIRTY
unconditionally (e.g. zonefs) because they always take blocking
locks in their ->end_io callbacks and so must always run in task
context...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

