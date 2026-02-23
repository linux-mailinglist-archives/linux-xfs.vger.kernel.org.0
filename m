Return-Path: <linux-xfs+bounces-31226-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yAW9AYV/nGm6IQQAu9opvQ
	(envelope-from <linux-xfs+bounces-31226-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Feb 2026 17:25:41 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 31078179B13
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Feb 2026 17:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 40F74302BB9D
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Feb 2026 16:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72C1270568;
	Mon, 23 Feb 2026 16:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3HH/3Pv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A484119ABC6
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 16:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771863556; cv=none; b=HabmPLBRny0mmCyGyeZ3knppjF+oI+jS6Gcd+dFSWI2w3ZYnJWD1qxbN7L0AqDLxkgR8umGFN/0xhG6LbuzM01heAK+gOzo6NYVnvotsSA+at3hyGTXxlLz759BB4vwmacL8hGAK95oxu7i6YhILcS4lXrrvr2IM7DrzSyVAVIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771863556; c=relaxed/simple;
	bh=GdNppqAVq3HF892D2B8NGPqbm+P8olnGWEgsRPmTlyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRL2z+/B4pD+I5DpsEqMzZCfB5htdiBYCGzLfYgPklNh2Gdj2lYzt9HL7nVJHGs/wfUayy6W40qhBhGHijEd9yazT1Ys0eNOZiywelfVeOElfm5ReoKSob0gX1CUoYhC2wu+ukcZ9J9C2AAu6mEz/f/sBJQtxdgOdEpZp3IwuPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3HH/3Pv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81325C116C6;
	Mon, 23 Feb 2026 16:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771863556;
	bh=GdNppqAVq3HF892D2B8NGPqbm+P8olnGWEgsRPmTlyg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g3HH/3Pv4MZPwzij6hiqSVB54VT4HPkwV5yPlOb3gIGI/W8UTsy+iCZ1CV0EJrFeZ
	 CUbFchJFywZPR7fD9EoGAVHZcp9tJm68jMbmhamYT845LSwzaLvkLAXqK5vBL7gAhz
	 vCt55aCjScYyxRdipm/7+tLTAxAWqefo4gtkMYM4Zqufz0FibJH47lw99Jv3a0+XEA
	 eCLXIsvjsjYvChF1irVgzCpEHDib5dD564biJLku1GZiZgFnQ30dyDirgtr0ZFq8gZ
	 v9234wfUim+T/lgz9m6rgaIYNqprwv5HC2b8dTINXrvZ/YysethvkzQwA6RNpCblZN
	 vEdGZXFxeO4zw==
Date: Mon, 23 Feb 2026 08:19:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v9] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20260223161915.GA2390353@frogsfrogsfrogs>
References: <20260223091106.296338-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223091106.296338-2-lukas@herbolt.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31226-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,herbolt.com:email]
X-Rspamd-Queue-Id: 31078179B13
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 10:11:07AM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_bmap_util.c |  5 +++--
>  fs/xfs/xfs_bmap_util.h |  2 +-
>  fs/xfs/xfs_file.c      | 39 ++++++++++++++++++++++++++-------------
>  3 files changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2208a720ec3f..0c1b1fa82f8b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -646,7 +646,8 @@ int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset,
> -	xfs_off_t		len)
> +	xfs_off_t		len,
> +	uint32_t		bmapi_flags)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	xfs_off_t		count;
> @@ -748,7 +749,7 @@ xfs_alloc_file_space(
>  		 * will eventually reach the requested range.
>  		 */
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> +				allocatesize_fsb, bmapi_flags, 0, imapp,
>  				&nimaps);
>  		if (error) {
>  			if (error != -ENOSR)
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b3361630..2895cc97a572 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -56,7 +56,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  
>  /* preallocation and hole punch interface */
>  int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -		xfs_off_t len);
> +		xfs_off_t len, uint32_t bmapi_flags);
>  int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7874cf745af3..83c45ada3cc8 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1293,6 +1293,7 @@ xfs_falloc_zero_range(
>  	unsigned int		blksize = i_blocksize(inode);
>  	loff_t			new_size = 0;
>  	int			error;
> +	uint32_t                bmapi_flags;
>  
>  	trace_xfs_zero_file_space(ip);
>  
> @@ -1300,18 +1301,27 @@ xfs_falloc_zero_range(
>  	if (error)
>  		return error;
>  
> -	if (xfs_falloc_force_zero(ip, ac)) {
> -		error = xfs_zero_range(ip, offset, len, ac, NULL);
> -	} else {
> -		error = xfs_free_file_space(ip, offset, len, ac);

Where did this call to xfs_free_file_space go?  This looks like a
behavior change in the classic zero-range behavior.

--D

> -		if (error)
> -			return error;
>  
> -		len = round_up(offset + len, blksize) -
> -			round_down(offset, blksize);
> -		offset = round_down(offset, blksize);
> -		error = xfs_alloc_file_space(ip, offset, len);
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (xfs_is_always_cow_inode(ip) ||
> +		    !bdev_write_zeroes_unmap_sectors(
> +				xfs_inode_buftarg(ip)->bt_bdev))
> +			return -EOPNOTSUPP;
> +		bmapi_flags = XFS_BMAPI_ZERO;
> +	} else {
> +		if (xfs_falloc_force_zero(ip, ac)) {
> +			error = xfs_zero_range(ip, offset, len, ac, NULL);
> +			goto set_filesize;
> +		}
> +		bmapi_flags = XFS_BMAPI_PREALLOC;
>  	}
> +
> +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> +	offset = round_down(offset, blksize);
> +
> +	error = xfs_alloc_file_space(ip, offset, len, bmapi_flags);
> +
> +set_filesize:
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1336,7 +1346,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1364,7 +1375,8 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1374,7 +1386,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
>  
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1417,6 +1429,7 @@ __xfs_file_fallocate(
>  	case FALLOC_FL_INSERT_RANGE:
>  		error = xfs_falloc_insert_range(file, offset, len);
>  		break;
> +	case FALLOC_FL_WRITE_ZEROES:
>  	case FALLOC_FL_ZERO_RANGE:
>  		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
>  		break;
> -- 
> 2.53.0
> 
> 

