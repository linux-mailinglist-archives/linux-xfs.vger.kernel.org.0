Return-Path: <linux-xfs+bounces-14711-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 607869B0D55
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2024 20:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 919DE1C2308B
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2024 18:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FDB2022EC;
	Fri, 25 Oct 2024 18:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXngwBpC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3611FB8B8;
	Fri, 25 Oct 2024 18:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729881061; cv=none; b=Fxmae2sCTPP77gdwwxGlKpAU4rmY4oIHqUunyJpJXQIPfZe3ltJyr67Eqgnx4vcL0XspdDu6pdkR/2TZRSVu52IWnCPRw/0odBBIdym5VlJdLr1mWMBbgDkDojfEZW2GrhRXz7CKmeiuCpS5HGTCwud+3TCAzfKnjBlFnmqHLdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729881061; c=relaxed/simple;
	bh=f0TE3+2pgkv//jEdQU4n847l2QP0sDqWuOnHzmp+Pu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mc0qcGaHdeeUH80IO2Z5PolxfnIOaQFCRj/gjArp8+bsu9EFPuV1/0SAdWQw9Q7filRGihfhpKJdKXldilQqwu0EsZUeK0yATG3YOSLZNI0ChU6NjWiOR08MVwOU4kZv2XFeHKalS3tVYWR7LNt8u4l4inhJKhUUJeRpm6s7J8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SXngwBpC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17640C4CEC3;
	Fri, 25 Oct 2024 18:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729881061;
	bh=f0TE3+2pgkv//jEdQU4n847l2QP0sDqWuOnHzmp+Pu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SXngwBpCW231RtGAIo8OgEakr9O1dQm6S3C+KK32f1G/Ei9YWO51lGa35wfYVD1i5
	 CRBKLvgfyTdpYvZ6oLB+UyglPv4URlNr827euKnPnyOpyfleuUalwicSLAiwr5Bqal
	 ZRm6HBOzpgdZrhNPTy5q1EkrlqRogcoOcz1qIvXFfNr3DrVm7gwkItlACwTaDH0wpF
	 DoL0DiA0FqeN+EilchJL7gcGPVuj2Emp2bbffFzqhCJtTeafA3OzC2DndKIEMZkkuj
	 n6MpkZgZfESi/ZwT20JxYlJqjvgKqOCdbXZoSMt1pgKlrBbk/y3a33idVidxtzB6bH
	 M5x3P/vAwGoeg==
Date: Fri, 25 Oct 2024 11:31:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	John Garry <john.g.garry@oracle.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Carlos Maiolino <cem@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] xfs: Do not fallback to buffered-io for DIO atomic write
Message-ID: <20241025183100.GN2386201@frogsfrogsfrogs>
References: <627c14b7987a3ab91d9bff31b99d86167d56f476.1729879630.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <627c14b7987a3ab91d9bff31b99d86167d56f476.1729879630.git.ritesh.list@gmail.com>

On Fri, Oct 25, 2024 at 11:48:05PM +0530, Ritesh Harjani (IBM) wrote:
> iomap can return -ENOTBLK if pagecache invalidation fails.
> Let's make sure if -ENOTBLK is ever returned for atomic
> writes than we fail the write request (-EIO) instead of
> fallback to buffered-io.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> This should be on top of John's atomic write series [1].
> [1]: https://lore.kernel.org/linux-xfs/20241019125113.369994-1-john.g.garry@oracle.com/
> 
>  fs/xfs/xfs_file.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index ca47cae5a40a..b819a9273511 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -876,6 +876,14 @@ xfs_file_write_iter(
>  		ret = xfs_file_dio_write(iocb, from);
>  		if (ret != -ENOTBLK)
>  			return ret;
> +		/*
> +		 * iomap can return -ENOTBLK if pagecache invalidation fails.
> +		 * Let's make sure if -ENOTBLK is ever returned for atomic
> +		 * writes than we fail the write request instead of fallback
> +		 * to buffered-io.
> +		 */
> +		if (iocb->ki_flags & IOCB_ATOMIC)
> +			return -EIO;
>  	}
> 
>  	return xfs_file_buffered_write(iocb, from);
> --
> 2.39.5
> 
> 

