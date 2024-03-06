Return-Path: <linux-xfs+bounces-4664-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C54E87424F
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Mar 2024 23:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0223E1F25600
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Mar 2024 22:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FF6D1BF2B;
	Wed,  6 Mar 2024 22:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Y4NTMNyP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A361BDDB
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 22:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709762426; cv=none; b=JacNfvBgtVbzO1gTcyNem0tgUY6Ron6p347JTm2zsZcaUJBYge7k8w64JsOh2zl8cBdxooRuuwVAdBmS6eWGGnFoxI/iWcg5fGPGqzMnFBockb0gdNCtN+Bnqme+9R1Ys7ozNAbtkkQLYb+B9EbUut1z0Wqi3kkXGZRhFmYxyto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709762426; c=relaxed/simple;
	bh=pIV4cjBBCtBTtpNYYrIuTfIHpvgy8urb9H8iYweQDY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEs6wb2eTo0XqK7Fbq8pQPNBcjEudmowTSE9XsXxr2KnvBBCbY1ZNLqE3hbWE3JaKKqBKQOPD0SQo/escYXLp1v2BS8DlT7WD6w13/R8/8asFkAnetaMeVAIoxOa/6Jz6fpNMzOfX/sbs/VjU+mQB9yImQ+DHB7jTkFK+/opdP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Y4NTMNyP; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5d8ddbac4fbso143036a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 06 Mar 2024 14:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709762423; x=1710367223; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SWg95yW08D0vwgG2qvaClO3hmbUBx1qNSFvXxAof5Yk=;
        b=Y4NTMNyP0LvTIaRKcROqdpjKzFSBbp11mcaZEoGv8W4rFRC3LeyE8Q/b9TX3/fJlkD
         new0hcaqgTBZ4l+8J75zTllrK6AUzNv8j1shlMJOY3F7qFz3xFxEHxlGMzwWSXqMsgRO
         dNKtvj0BzRsagrCUqNwemsHj6L8+juJ3weFfCGY5u+KHLW4sk18lBske5BUJwO7kc+Kd
         Mrnx/tFg8ZC4pbGIp19KMv4uIZxQgGq0YXw42AzEPaQX6Nf4vOATG1suiVycgktE5f0b
         0F0FHPX1PzUlXZCJdp1Zvg/LjAtgIVclDtLz2+kt1BJOjNIBPZMAzlfy/J8sdVv32WRj
         svTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709762423; x=1710367223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWg95yW08D0vwgG2qvaClO3hmbUBx1qNSFvXxAof5Yk=;
        b=DNmXW+32MF+zRk6NSR44xD68V4vU1Bk8Ud1lsVw4t1PTeUVK/e2YUX93crMH13py+3
         Fslps5jCCn6uzFBh9PqjFqhBoWiQ+OFssGDhn2wp38sv1G8C/mOx3E9cFKVl8rvzRpsW
         sAJnu6oLeEqKQeoLjESW7LdlHX5RIJ9iJ2UEffjS/6VaW0/ArpnRoQR3/yOV7EHk63Xu
         LxRTdnI8K+/B6+K1dVZ98oIE92JR/x3asiQqPuhW400IOOPkpWBi8fUA8gw313OCUsQR
         5S2Fr+JPAzKBrkT71+G2GVxVEqo+jD1NotzifNiKGl/hRDBHqKWPWKMCbAjEN+ywHY0X
         9BVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjDmb9DdIA/TBZLv0UrDvxW32dz7PWaNlZuhjzxbtZmA9+wbvZOKBwMJoeBqFynelLBxDxLCn+RX6hi9OgWasgIvLNwnmTHAke
X-Gm-Message-State: AOJu0YxgtcCaF+JbyrpOvfMVpAJQLPGU1lCTckPoe9pVGjfsDv94TXL5
	kprt6OKXHZ8ro2s1nFnhfgnanr2VskfQT3mDUNwvuCE4ga6WiM9xF+h+icQl6FE=
X-Google-Smtp-Source: AGHT+IEMxgFRiIgrC0TNH58lu4Sx9PZsPrr7kqi++6UXKWNSWa0Z6dn8DLbnTssOehFcOv9vCwBsZw==
X-Received: by 2002:a17:902:ea05:b0:1dc:f157:51bc with SMTP id s5-20020a170902ea0500b001dcf15751bcmr7790861plg.3.1709762422545;
        Wed, 06 Mar 2024 14:00:22 -0800 (PST)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902d68b00b001d8f251c8b2sm13040426ply.221.2024.03.06.14.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 14:00:22 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rhzJD-00Fz7a-21;
	Thu, 07 Mar 2024 09:00:19 +1100
Date: Thu, 7 Mar 2024 09:00:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: djwong@kernel.org, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, chandan.babu@oracle.com,
	axboe@kernel.dk, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	ojaswin@linux.ibm.com, ritesh.list@gmail.com,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v2 08/14] fs: xfs: iomap: Sub-extent zeroing
Message-ID: <Zejnc+M32wRIutNZ@dread.disaster.area>
References: <20240304130428.13026-1-john.g.garry@oracle.com>
 <20240304130428.13026-9-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240304130428.13026-9-john.g.garry@oracle.com>

On Mon, Mar 04, 2024 at 01:04:22PM +0000, John Garry wrote:
> Set iomap->extent_shift when sub-extent zeroing is required.
> 
> We treat a sub-extent write same as an unaligned write, so we can leverage
> the existing sub-FSblock unaligned write support, i.e. try a shared lock
> with IOMAP_DIO_OVERWRITE_ONLY flag, if this fails then try the exclusive
> lock.
> 
> In xfs_iomap_write_unwritten(), FSB calcs are now based on the extsize.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/xfs/xfs_file.c  | 28 +++++++++++++++-------------
>  fs/xfs/xfs_iomap.c | 15 +++++++++++++--
>  2 files changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e33e5e13b95f..d0bd9d5f596c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -617,18 +617,19 @@ xfs_file_dio_write_aligned(
>   * Handle block unaligned direct I/O writes
>   *
>   * In most cases direct I/O writes will be done holding IOLOCK_SHARED, allowing
> - * them to be done in parallel with reads and other direct I/O writes.  However,
> - * if the I/O is not aligned to filesystem blocks, the direct I/O layer may need
> - * to do sub-block zeroing and that requires serialisation against other direct
> - * I/O to the same block.  In this case we need to serialise the submission of
> - * the unaligned I/O so that we don't get racing block zeroing in the dio layer.
> - * In the case where sub-block zeroing is not required, we can do concurrent
> - * sub-block dios to the same block successfully.
> + * them to be done in parallel with reads and other direct I/O writes.
> + * However if the I/O is not aligned to filesystem blocks/extent, the direct
> + * I/O layer may need to do sub-block/extent zeroing and that requires
> + * serialisation against other direct I/O to the same block/extent.  In this
> + * case we need to serialise the submission of the unaligned I/O so that we
> + * don't get racing block/extent zeroing in the dio layer.
> + * In the case where sub-block/extent zeroing is not required, we can do
> + * concurrent sub-block/extent dios to the same block/extent successfully.
>   *
>   * Optimistically submit the I/O using the shared lock first, but use the
>   * IOMAP_DIO_OVERWRITE_ONLY flag to tell the lower layers to return -EAGAIN
> - * if block allocation or partial block zeroing would be required.  In that case
> - * we try again with the exclusive lock.
> + * if block/extent allocation or partial block/extent zeroing would be
> + * required.  In that case we try again with the exclusive lock.
>   */
>  static noinline ssize_t
>  xfs_file_dio_write_unaligned(
> @@ -643,9 +644,9 @@ xfs_file_dio_write_unaligned(
>  	ssize_t			ret;
>  
>  	/*
> -	 * Extending writes need exclusivity because of the sub-block zeroing
> -	 * that the DIO code always does for partial tail blocks beyond EOF, so
> -	 * don't even bother trying the fast path in this case.
> +	 * Extending writes need exclusivity because of the sub-block/extent
> +	 * zeroing that the DIO code always does for partial tail blocks
> +	 * beyond EOF, so don't even bother trying the fast path in this case.
>  	 */
>  	if (iocb->ki_pos > isize || iocb->ki_pos + count >= isize) {
>  		if (iocb->ki_flags & IOCB_NOWAIT)
> @@ -709,13 +710,14 @@ xfs_file_dio_write(
>  	struct iov_iter		*from)
>  {
>  	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_buftarg      *target = xfs_inode_buftarg(ip);
>  	size_t			count = iov_iter_count(from);
>  
>  	/* direct I/O must be aligned to device logical sector size */
>  	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
>  		return -EINVAL;
> -	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
> +	if ((iocb->ki_pos | count) & (XFS_FSB_TO_B(mp, xfs_get_extsz(ip)) - 1))
>  		return xfs_file_dio_write_unaligned(ip, iocb, from);
>  	return xfs_file_dio_write_aligned(ip, iocb, from);
>  }
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 70fe873951f3..88cc20bb19c9 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -98,6 +98,7 @@ xfs_bmbt_to_iomap(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> +	xfs_extlen_t		extsz = xfs_get_extsz(ip);
>  
>  	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
>  		return xfs_alert_fsblock_zero(ip, imap);
> @@ -134,6 +135,8 @@ xfs_bmbt_to_iomap(
>  
>  	iomap->validity_cookie = sequence_cookie;
>  	iomap->folio_ops = &xfs_iomap_folio_ops;
> +	if (extsz > 1)
> +		iomap->extent_shift = ffs(extsz) - 1;

	iomap->extent_size = mp->m_bsize;
	if (xfs_inode_has_force_align(ip))
		iomap->extent_size *= ip->i_extsize;

> @@ -563,11 +566,19 @@ xfs_iomap_write_unwritten(
>  	xfs_fsize_t	i_size;
>  	uint		resblks;
>  	int		error;
> +	xfs_extlen_t	extsz = xfs_get_extsz(ip);
>  
>  	trace_xfs_unwritten_convert(ip, offset, count);
>  
> -	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
> +	if (extsz > 1) {
> +		xfs_extlen_t extsize_bytes = XFS_FSB_TO_B(mp, extsz);
> +
> +		offset_fsb = XFS_B_TO_FSBT(mp, round_down(offset, extsize_bytes));
> +		count_fsb = XFS_B_TO_FSB(mp, round_up(offset + count, extsize_bytes));
> +	} else {
> +		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +		count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
> +	}

I don't think this is correct. We should only be converting the
extent when the entire range has had data written to it. If we are
doing unaligned writes, we end up running 3 separate unwritten
conversion transactions - the leading zeroing, the data written and
the trailing zeroing.

This will end up converting the entire range to written when the
leading zeroing completes, exposing stale data until the data and
trailing zeroing completes.

Concurrent reads (both DIO and buffered) can see this stale data
while the write is in progress, leading to a mechanism where a user
can issue sub-atomic write range IO and concurrent overlapping reads
to read arbitrary stale data from the disk just before it is
overwritten.

I suspect the only way to fix this for sub-force-aligned DIo writes
if for iomap_dio_bio_iter() to chain the zeroing and data bios so
the entire range gets a single completion run on it instead of three
separate sub-aligned extent IO completions. We only need to do this
in the zeroing case - this is already the DIo slow path, so
additional submission overhead is not an issue. It would, however,
reduce completion overhead and latency, as we only need to run a
single extent conversion instead of 3, so chaining the bios on
aligned writes may well be a net win...

Thoughts? Christoph probably needs to weigh in on this one...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

