Return-Path: <linux-xfs+bounces-7996-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C178B839C
	for <lists+linux-xfs@lfdr.de>; Wed,  1 May 2024 02:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA3261F23030
	for <lists+linux-xfs@lfdr.de>; Wed,  1 May 2024 00:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A0C81E;
	Wed,  1 May 2024 00:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="yMO3Ewp2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A731B173
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 00:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522264; cv=none; b=OWMMyaN/fDx1OvGwwlvmSSZ7iIaX2x6bRqqNXOHJrPFICujSpsY5PnJQETtsl7xMrpcx3hY5IyKzjyoXtuKIwWgfWn7Mbn1e3Dsi4caCEXY546ZDDeDVf0w+tfVZQ/HZnSmVB0JSJlXMSMgNskggDZo16L9BrOPYVE83p2KX574=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522264; c=relaxed/simple;
	bh=sSO6dh8KNFY+YwfUmmoyAukDGCYEhucFS5/dS54kCYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RHOayCKlmwvXqHnBZoz5eVbYK5tGy0pZtI21ilDVn3JugFW5tAJhKKc/ESk7lDDqnTxoXAKbJikGSLyf7qfaDs5YdLewigjhSndBU+jFojlOoFIqZvUX9Se09Bw9BYysZt63QUt1IaWjlRXtuJk8qNS6TRkJC8aGakeiYKs8VDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=yMO3Ewp2; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6ee0642f718so304757b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 17:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714522262; x=1715127062; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rZ/9qicPxGQaaPDcPC5n5ignkZa6a7DoBwymuEfhOJw=;
        b=yMO3Ewp2A4ysL9IgnIe9EFOHvqFxO++Fs/BYubSI4c2tP3bgu1TOZ+NEqGMwNn3GmZ
         5h9oAw2UZbiwLKq7gECExtfb/4uPFiJXRzgQaa3DkA0cXj3tBsR+Nug9gIxJXfFsmi5y
         Apg+RyGcxncOsATldKciPVprKIKxy7X4tIbWv0EjOXeOA5UJpJdI3BaxyVD9v5vFCKyU
         KJlXkVWRJyLK/XISZuBBnjspw01m8FrSmslQQl+8giG0GkwfucplU7+7rrBo3t9RpQ/A
         cqNQRUq+6r7RgzSam7BpApoDBGiXO4g7E6Gdpzdgv7mbawMQ5HT6ushNEcxtz4cx1KNz
         K3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714522262; x=1715127062;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZ/9qicPxGQaaPDcPC5n5ignkZa6a7DoBwymuEfhOJw=;
        b=QtV0x1XNV21ddhZtQrkkeLKLtLkVEDWx52cJaBX7DheUdBGCLiKj0U/gM4UiiHV125
         yMYOdbXk6lR5aylhSANCO0GxSMtqLCJU5FYF0f0WD3QA2UUAMfBU6B51mZ5wPjv0krBV
         Wu7ZfDn3eH8Ka6z4GaaHML3hYeyIVf9kW/d/1vUeM+RPMuOdJI9eEtp+M5tNd8AkIJUv
         fb4jgYq8a3i5vIq+iVjULAqSh9r93RMYPyucSF5gNfyEkSW86WcWq9yox6iQcMKYc1AK
         Y1z6oDNoA+im8is6PBxi4KQDYYCTZHX7W8qZEkNaWq6yOLa+lkqyXpoVD9wNBzYbsYah
         5iHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnucdtgy/jOaUjaSERvQ/orbTxty4hnNbOU7KwuMOa4ZpMEKRIUeEeLmXwD2+hMF5SPz0d0p10ukOrcaIJjoC0zcfZPsDkCX6V
X-Gm-Message-State: AOJu0YwHfoQZpGc8XoG9JHTpNykIMEt+GkWLMmbO4L4qOMepQO2+r8de
	s4MGF3X0OeFmOOJPsnCaQla2jbWYxHDvXLyS6nhwT/ap3eTG0Z1wRuNR1+Zdglc=
X-Google-Smtp-Source: AGHT+IEG6NH1QHNLpZzkQmg5AjwrcE2NxKLckqvSU7/Ip5lLqz1027nr9cedQH0qastwL2x6xybBHg==
X-Received: by 2002:a05:6a20:6a13:b0:1ac:dead:68 with SMTP id p19-20020a056a206a1300b001acdead0068mr2216896pzk.24.1714522261820;
        Tue, 30 Apr 2024 17:11:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id ei9-20020a056a0080c900b006f33c0aee44sm13980314pfb.91.2024.04.30.17.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 17:11:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s1xYo-00GlOK-0Z;
	Wed, 01 May 2024 10:10:58 +1000
Date: Wed, 1 May 2024 10:10:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: djwong@kernel.org, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, chandan.babu@oracle.com,
	willy@infradead.org, axboe@kernel.dk, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, jbongio@google.com, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, mcgrof@kernel.org, p.raghav@samsung.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH RFC v3 11/21] xfs: Unmap blocks according to forcealign
Message-ID: <ZjGIktQV12qas14f@dread.disaster.area>
References: <20240429174746.2132161-1-john.g.garry@oracle.com>
 <20240429174746.2132161-12-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429174746.2132161-12-john.g.garry@oracle.com>

On Mon, Apr 29, 2024 at 05:47:36PM +0000, John Garry wrote:
> For when forcealign is enabled, blocks in an inode need to be unmapped
> according to extent alignment, like what is already done for rtvol.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 39 +++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_inode.h       |  5 +++++
>  2 files changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4f39a43d78a7..4a78ab193753 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5339,6 +5339,15 @@ xfs_bmap_del_extent_real(
>  	return 0;
>  }
>  
> +/* Return the offset of an block number within an extent for forcealign. */
> +static xfs_extlen_t
> +xfs_forcealign_extent_offset(
> +	struct xfs_inode	*ip,
> +	xfs_fsblock_t		bno)
> +{
> +	return bno & (ip->i_extsize - 1);
> +}
> +
>  /*
>   * Unmap (remove) blocks from a file.
>   * If nexts is nonzero then the number of extents to remove is limited to
> @@ -5361,6 +5370,7 @@ __xfs_bunmapi(
>  	struct xfs_bmbt_irec	got;		/* current extent record */
>  	struct xfs_ifork	*ifp;		/* inode fork pointer */
>  	int			isrt;		/* freeing in rt area */
> +	int			isforcealign;	/* freeing for file inode with forcealign */
>  	int			logflags;	/* transaction logging flags */
>  	xfs_extlen_t		mod;		/* rt extent offset */
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -5397,7 +5407,10 @@ __xfs_bunmapi(
>  		return 0;
>  	}
>  	XFS_STATS_INC(mp, xs_blk_unmap);
> -	isrt = xfs_ifork_is_realtime(ip, whichfork);
> +	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);

Why did you change this check? What's wrong with
xfs_ifork_is_realtime(), and if there is something wrong, why
shouldn't xfs_ifork_is_relatime() get fixed?

> +	isforcealign = (whichfork == XFS_DATA_FORK) &&
> +			xfs_inode_has_forcealign(ip) &&
> +			xfs_inode_has_extsize(ip) && ip->i_extsize > 1;

This is one of the reasons why I said xfs_inode_has_forcealign()
should be checking that extent size hints should be checked in that
helper....

>  	end = start + len;
>  
>  	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
> @@ -5459,11 +5472,15 @@ __xfs_bunmapi(
>  		if (del.br_startoff + del.br_blockcount > end + 1)
>  			del.br_blockcount = end + 1 - del.br_startoff;
>  
> -		if (!isrt || (flags & XFS_BMAPI_REMAP))
> +		if ((!isrt && !isforcealign) || (flags & XFS_BMAPI_REMAP))
>  			goto delete;
>  
> -		mod = xfs_rtb_to_rtxoff(mp,
> -				del.br_startblock + del.br_blockcount);
> +		if (isrt)
> +			mod = xfs_rtb_to_rtxoff(mp,
> +					del.br_startblock + del.br_blockcount);
> +		else if (isforcealign)
> +			mod = xfs_forcealign_extent_offset(ip,
> +					del.br_startblock + del.br_blockcount);

There's got to be a cleaner way to do this.

We already know that either isrt or isforcealign must be set here,
so there's no need for the "else if" construct.

Also, forcealign should take precedence over realtime, so that
forcealign will work on realtime devices as well. I'd change this
code to call a wrapper like:

		mod = xfs_bunmapi_align(ip, del.br_startblock + del.br_blockcount);

static xfs_extlen_t
xfs_bunmapi_align(
	struct xfs_inode	*ip,
	xfs_fsblock_t		bno)
{
	if (!XFS_INODE_IS_REALTIME(ip)) {
		ASSERT(xfs_inode_has_forcealign(ip))
		if (is_power_of_2(ip->i_extsize))
			return bno & (ip->i_extsize - 1);
		return do_div(bno, ip->i_extsize);
	}
	return xfs_rtb_to_rtxoff(ip->i_mount, bno);
}



>  		if (mod) {
>  			/*
>  			 * Realtime extent not lined up at the end.
> @@ -5511,9 +5528,19 @@ __xfs_bunmapi(
>  			goto nodelete;
>  		}
>  
> -		mod = xfs_rtb_to_rtxoff(mp, del.br_startblock);
> +		if (isrt)
> +			mod = xfs_rtb_to_rtxoff(mp, del.br_startblock);
> +		else if (isforcealign)
> +			mod = xfs_forcealign_extent_offset(ip,
> +					del.br_startblock);
> +
		mod = xfs_bunmapi_align(ip, del.br_startblock);

>  		if (mod) {
> -			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
> +			xfs_extlen_t off;
> +
> +			if (isrt)
> +				off = mp->m_sb.sb_rextsize - mod;
> +			else if (isforcealign)
> +				off = ip->i_extsize - mod;

			if (forcealign)
				off = ip->i_extsize - mod;
			else
				off = mp->m_sb.sb_rextsize - mod;

-Dave.
-- 
Dave Chinner
david@fromorbit.com

