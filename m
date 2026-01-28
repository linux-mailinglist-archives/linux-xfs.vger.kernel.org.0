Return-Path: <linux-xfs+bounces-30405-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BbAD+hoeWmPwwEAu9opvQ
	(envelope-from <linux-xfs+bounces-30405-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 02:39:52 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 767FF9BF62
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 02:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32B5430107DA
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 01:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE6C241103;
	Wed, 28 Jan 2026 01:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyDcSmoT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD3D23EA84
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 01:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564389; cv=none; b=ZXYT8z1l3oYtUcdnI5FXzDIpnCpYN3N2UJ54vHXb1NeXzdSwrz0xUgytg5wmhPAzXtC/1hyJ7rYb98IuhH5ZsM9rkAzY+1o7io/66FWpTGT/Lefx5My5SBaL/POrVstnwIp4ddCMWPCbi0Phq41sH0/M8Vhbq3JQ8/x/tpa1yxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564389; c=relaxed/simple;
	bh=9KGAjfCEiPgaCav1qrLh72aBIxL7BtyqaGyk0K3WSLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBB5K1y3BB426Dk6bsLqHyXb4A4graQjH7eaAg18b5m2YQJ7QDI1HQL7ecNDDts3GdUsSuH9z/wBsoUQotSQlmu4bl5CIygE76HdDk48rPBWz89stsbJyFdD8mOGzpAH89DdJXr3fAnte8ctjrqIMipuHyb/4aV84rJSJmquEL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyDcSmoT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE256C116C6;
	Wed, 28 Jan 2026 01:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769564388;
	bh=9KGAjfCEiPgaCav1qrLh72aBIxL7BtyqaGyk0K3WSLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gyDcSmoTvuOLcvmCeVHiLPo3vo2Z1fgL5HQTprmcXM8AZzWrd4mXxkfJrk1W+BSUS
	 gmKJYQQjYCZdhAFgys770iBzhEMilo3nHTl7RgXrNUA3lEAWdLsIGGNTAHty1Id5pq
	 V8e3/v4lo6mzw+6HCmoIcaMW72qJ4DqYeMdzaVJpEHpo/J98QPlqHP6hSu52uZcuN6
	 Vphxn/+cJNw/E4x9ebWI5ipSAONg+LOZDU2jSBGXdGRVMjuh4eSAO7lMNWrX+pPtyZ
	 Pxu9d/X2OqrPVoKb6iFmDNnWmUmL/fzPmP3AqDc5WBaF3P+LDSTcc4ZVOKBHoZSn0s
	 oZWjNKzd/5h5g==
Date: Tue, 27 Jan 2026 17:39:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: add zone reset error injection
Message-ID: <20260128013948.GI5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-10-hch@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30405-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 767FF9BF62
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 05:05:49PM +0100, Christoph Hellwig wrote:
> Add a new errortag to test that zone reset errors are handled correctly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This seems pretty straightforward.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_errortag.h |  6 ++++--
>  fs/xfs/xfs_zone_gc.c         | 13 +++++++++++--
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index b7d98471684b..6de207fed2d8 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -74,7 +74,8 @@
>  #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
>  #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
>  #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
> -#define XFS_ERRTAG_MAX					47
> +#define XFS_ERRTAG_ZONE_RESET				47
> +#define XFS_ERRTAG_MAX					48
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -135,7 +136,8 @@ XFS_ERRTAG(WB_DELAY_MS,		wb_delay_ms,		3000) \
>  XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
>  XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
>  XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
> -XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4)
> +XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
> +XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
>  #endif /* XFS_ERRTAG */
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 4023448e85d1..570102184904 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -16,6 +16,8 @@
>  #include "xfs_rmap.h"
>  #include "xfs_rtbitmap.h"
>  #include "xfs_rtrmap_btree.h"
> +#include "xfs_errortag.h"
> +#include "xfs_error.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_zone_priv.h"
>  #include "xfs_zones.h"
> @@ -898,9 +900,17 @@ xfs_submit_zone_reset_bio(
>  	struct xfs_rtgroup	*rtg,
>  	struct bio		*bio)
>  {
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +
>  	trace_xfs_zone_reset(rtg);
>  
>  	ASSERT(rtg_rmap(rtg)->i_used_blocks == 0);
> +
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_ZONE_RESET)) {
> +		bio_io_error(bio);
> +		return;
> +	}
> +
>  	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
>  	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
>  		/*
> @@ -913,8 +923,7 @@ xfs_submit_zone_reset_bio(
>  		}
>  		bio->bi_opf &= ~REQ_OP_ZONE_RESET;
>  		bio->bi_opf |= REQ_OP_DISCARD;
> -		bio->bi_iter.bi_size =
> -			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
> +		bio->bi_iter.bi_size = XFS_FSB_TO_B(mp, rtg_blocks(rtg));
>  	}
>  
>  	submit_bio(bio);
> -- 
> 2.47.3
> 
> 

