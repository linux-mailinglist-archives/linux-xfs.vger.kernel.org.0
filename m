Return-Path: <linux-xfs+bounces-697-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92946811C3C
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Dec 2023 19:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AFE31C20E44
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Dec 2023 18:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA1D759540;
	Wed, 13 Dec 2023 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="um+/Iq8M"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC2856B7C
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 18:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AE8C433C7;
	Wed, 13 Dec 2023 18:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702491673;
	bh=wDPJ6dv+Tgkh1eTH3yM4UiUfTgqjlH1fbyy30VNQXlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=um+/Iq8M0XIj1d6WaJloR7teKehB3GD+ZFAud6hRvpCkU9ETfxLKdlgTQlOg4hNtT
	 dmshN3Pa3U8NlUv69SDK+TjLnagaVsMkegCk2O7g988OgBldPMvulLJFXtOVKwMAFv
	 ua7fpaVNCNS8sJyXJk0vpJEdpiH6zh87vqSWQ3Pe3x+CPmtF3izvsY1HfPx+EBJzFl
	 fJ5dnwIARaqU2Im5HXvDSodV9Vnz8l0h+d/51FU4BrK6VYkrJ1IcCgtgBk9rE9NHAd
	 RWSsgTx2WNCMkU5WBxLzMjOJIPlKImViQRnmMTRz/wLp1sZCm9/YRl1CePpcW72Rf6
	 D+G1o8LTCYAJA==
Date: Wed, 13 Dec 2023 10:21:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v3 2/2] xfs: fix perag leak when growfs fails
Message-ID: <20231213182112.GJ361584@frogsfrogsfrogs>
References: <20231213031013.390145-1-leo.lilong@huawei.com>
 <20231213031013.390145-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213031013.390145-2-leo.lilong@huawei.com>

On Wed, Dec 13, 2023 at 11:10:13AM +0800, Long Li wrote:
> During growfs, if new ag in memory has been initialized, however
> sb_agcount has not been updated, if an error occurs at this time it
> will cause perag leaks as follows, these new AGs will not been freed
> during umount , because of these new AGs are not visible(that is
> included in mp->m_sb.sb_agcount).
> 
> unreferenced object 0xffff88810be40200 (size 512):
>   comm "xfs_growfs", pid 857, jiffies 4294909093
>   hex dump (first 32 bytes):
>     00 c0 c1 05 81 88 ff ff 04 00 00 00 00 00 00 00  ................
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc 381741e2):
>     [<ffffffff8191aef6>] __kmalloc+0x386/0x4f0
>     [<ffffffff82553e65>] kmem_alloc+0xb5/0x2f0
>     [<ffffffff8238dac5>] xfs_initialize_perag+0xc5/0x810
>     [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
>     [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
>     [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
>     [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
>     [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a
> unreferenced object 0xffff88810be40800 (size 512):
>   comm "xfs_growfs", pid 857, jiffies 4294909093
>   hex dump (first 32 bytes):
>     20 00 00 00 00 00 00 00 57 ef be dc 00 00 00 00   .......W.......
>     10 08 e4 0b 81 88 ff ff 10 08 e4 0b 81 88 ff ff  ................
>   backtrace (crc bde50e2d):
>     [<ffffffff8191b43a>] __kmalloc_node+0x3da/0x540
>     [<ffffffff81814489>] kvmalloc_node+0x99/0x160
>     [<ffffffff8286acff>] bucket_table_alloc.isra.0+0x5f/0x400
>     [<ffffffff8286bdc5>] rhashtable_init+0x405/0x760
>     [<ffffffff8238dda3>] xfs_initialize_perag+0x3a3/0x810
>     [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
>     [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
>     [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
>     [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
>     [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a
> 
> Factor out xfs_free_unused_perag_range() from xfs_initialize_perag(),
> used for freeing unused perag within a specified range in error handling,
> included in the error path of the growfs failure.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>

This looks like a fix for a bug; is there a reason you omitted a Fixes:
tag?  Has this bug been here so long that blame points at the
granddaddy commit?

Code looks ok to me though.

--D

> ---
> v3:
> - Stop use of typedefs for struct pointers
> - Remove unnecessary indentation
> - Factor out xfs_free_unused_perag_range() from xfs_initialize_perag(),
>   not xfs_free_perag(). Compared to the v2 version, now the logic for
>   freeing perag in xfs_free_perag() and xfs_initialize_perag() error
>   handling not quite the same.
>  fs/xfs/libxfs/xfs_ag.c | 36 ++++++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_ag.h |  2 ++
>  fs/xfs/xfs_fsops.c     |  5 ++++-
>  3 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index c730976fdfc0..39d9525270b7 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -332,6 +332,31 @@ xfs_agino_range(
>  	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
>  }
>  
> +/*
> + * Free perag within the specified AG range, it is only used to free unused
> + * perags under the error handling path.
> + */
> +void
> +xfs_free_unused_perag_range(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agstart,
> +	xfs_agnumber_t		agend)
> +{
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		index;
> +
> +	for (index = agstart; index < agend; index++) {
> +		spin_lock(&mp->m_perag_lock);
> +		pag = radix_tree_delete(&mp->m_perag_tree, index);
> +		spin_unlock(&mp->m_perag_lock);
> +		if (!pag)
> +			break;
> +		xfs_buf_hash_destroy(pag);
> +		xfs_defer_drain_free(&pag->pag_intents_drain);
> +		kmem_free(pag);
> +	}
> +}
> +
>  int
>  xfs_initialize_perag(
>  	struct xfs_mount	*mp,
> @@ -431,16 +456,7 @@ xfs_initialize_perag(
>  	kmem_free(pag);
>  out_unwind_new_pags:
>  	/* unwind any prior newly initialized pags */
> -	for (index = first_initialised; index < agcount; index++) {
> -		spin_lock(&mp->m_perag_lock);
> -		pag = radix_tree_delete(&mp->m_perag_tree, index);
> -		spin_unlock(&mp->m_perag_lock);
> -		if (!pag)
> -			break;
> -		xfs_buf_hash_destroy(pag);
> -		xfs_defer_drain_free(&pag->pag_intents_drain);
> -		kmem_free(pag);
> -	}
> +	xfs_free_unused_perag_range(mp, first_initialised, agcount);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 2e0aef87d633..40d7b6427afb 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -133,6 +133,8 @@ __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
>  __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
>  __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
>  
> +void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
> +			xfs_agnumber_t agend);
>  int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
>  			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
>  int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index e8759b479516..22c3f1e9008e 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -153,7 +153,7 @@ xfs_growfs_data_private(
>  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, -delta, 0,
>  				0, &tp);
>  	if (error)
> -		return error;
> +		goto out_free_unused_perag;
>  
>  	last_pag = xfs_perag_get(mp, oagcount - 1);
>  	if (delta > 0) {
> @@ -227,6 +227,9 @@ xfs_growfs_data_private(
>  
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> +out_free_unused_perag:
> +	if (nagcount > oagcount)
> +		xfs_free_unused_perag_range(mp, oagcount, nagcount);
>  	return error;
>  }
>  
> -- 
> 2.31.1
> 
> 

