Return-Path: <linux-xfs+bounces-27093-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F780C1CB78
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Oct 2025 19:13:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9BED1893801
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Oct 2025 18:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27CFD355804;
	Wed, 29 Oct 2025 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qz88XQJ9"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB46F2E8B85;
	Wed, 29 Oct 2025 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761761616; cv=none; b=D2Isi/719GFQSHoWLD4d+l80LNkraJ4oT23/wSlUSmODYts+lEVkqQEvW+c3TzmL8lMtc4+ymhFS4HAKlOxqnQDOJ/IvtznhOl4Zw4vy1WkrNEAhIlMAUhcWvlGJvt6iS3RbWd0TK7rT1D7tY+rutulYgg/Z8SMIrFtKZBar/94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761761616; c=relaxed/simple;
	bh=O4pe0KaVYZJ0MRJ62aWnJfMj3faZYC7std7ttBoAfbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DF8Mc+JZBa9iG9G24yLddGQP5GwDD1gzH6XE1qKBpX7y/T4N8aaeewQYyEAwaqQOG7r46UhBbqSPNei5EYm/FnLjwRmgBia3eRkIlR7+wxsKNFmVQsme7T11jXvLeUs8WSgBGY47aAHQoEFNZWjzxPaoMD4Z+uHKW/ULlBI9gwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qz88XQJ9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C516C4CEF7;
	Wed, 29 Oct 2025 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761761616;
	bh=O4pe0KaVYZJ0MRJ62aWnJfMj3faZYC7std7ttBoAfbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qz88XQJ9zKHAbGZg5PxJkjG0or11MnFuSlnvz/8tjBZ9pyG5eU721l0WAvtmHwlFm
	 mqKyrkYqEl2KNEfM5O/lA1Q1T2ajYV0qLIBSPEfzZSP+h5OtlCh4wAnnTbFOVzJp3E
	 RbKCTtYOXzhCc56qg0vc/x3xTHLizK+EN4bEv9utTA7i4ZttuBGI/1uEHrbp1Um+ml
	 wQ+Rva7RVEnZWpAsWDTqLdA1HwS3KkqqLBZbeX4/tOlUCboUUad9yXnBR0s2kOzg9s
	 erbQ1dMayhPRFdqg74N3UVOkWqIxgPLXbXFPNq6H4qHuIGPBNICQd4jw4iC5TVe9f8
	 gfjBKkO2AwjEw==
Date: Wed, 29 Oct 2025 11:13:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>,
	fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
Message-ID: <20251029181336.GJ3356773@frogsfrogsfrogs>
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029181132.GH3356773@frogsfrogsfrogs>

On Wed, Oct 29, 2025 at 11:11:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> With the 5 Oct 2025 release of fstests, generic/521 fails for me on
> regular (aka non-block-atomic-writes) storage:
> 
> QA output created by 521
> dowrite: write: Input/output error
> LOG DUMP (8553 total operations):
> 1(  1 mod 256): SKIPPED (no operation)
> 2(  2 mod 256): WRITE    0x7e000 thru 0x8dfff	(0x10000 bytes) HOLE
> 3(  3 mod 256): READ     0x69000 thru 0x79fff	(0x11000 bytes)
> 4(  4 mod 256): FALLOC   0x53c38 thru 0x5e853	(0xac1b bytes) INTERIOR
> 5(  5 mod 256): COPY 0x55000 thru 0x59fff	(0x5000 bytes) to 0x25000 thru 0x29fff
> 6(  6 mod 256): WRITE    0x74000 thru 0x88fff	(0x15000 bytes)
> 7(  7 mod 256): ZERO     0xedb1 thru 0x11693	(0x28e3 bytes)
> <snip>
> 
> with a warning in dmesg from iomap about XFS trying to give it a
> delalloc mapping for a directio write.  Fix the software atomic write
> iomap_begin code to convert the reservation into a written mapping.
> This doesn't fix the data corruption problems reported by generic/760,
> but it's a start.

Grrrr I forgot to remove the reply-to tag when I harvested the cc list
from this old thread for a bug fix.  Sorry about that.

--D

> 
> Cc: <stable@vger.kernel.org> # v6.16
> Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_iomap.c |   21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index d3f6e3e42a1191..e1da06b157cf94 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1130,7 +1130,7 @@ xfs_atomic_write_cow_iomap_begin(
>  		return -EAGAIN;
>  
>  	trace_xfs_iomap_atomic_write_cow(ip, offset, length);
> -
> +retry:
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
>  	if (!ip->i_cowfp) {
> @@ -1141,6 +1141,8 @@ xfs_atomic_write_cow_iomap_begin(
>  	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
>  		cmap.br_startoff = end_fsb;
>  	if (cmap.br_startoff <= offset_fsb) {
> +		if (isnullstartblock(cmap.br_startblock))
> +			goto convert;
>  		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>  		goto found;
>  	}
> @@ -1169,8 +1171,10 @@ xfs_atomic_write_cow_iomap_begin(
>  	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
>  		cmap.br_startoff = end_fsb;
>  	if (cmap.br_startoff <= offset_fsb) {
> -		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>  		xfs_trans_cancel(tp);
> +		if (isnullstartblock(cmap.br_startblock))
> +			goto convert;
> +		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
>  		goto found;
>  	}
>  
> @@ -1210,6 +1214,19 @@ xfs_atomic_write_cow_iomap_begin(
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
>  
> +convert:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	error = xfs_bmapi_convert_delalloc(ip, XFS_COW_FORK, offset, iomap,
> +			NULL);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Try the lookup again, because the delalloc conversion might have
> +	 * turned the COW mapping into unwritten, but we need it to be in
> +	 * written state.
> +	 */
> +	goto retry;
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> 

