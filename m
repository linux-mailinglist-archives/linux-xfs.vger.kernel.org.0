Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344B9150FB9
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Feb 2020 19:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgBCSih (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Feb 2020 13:38:37 -0500
Received: from sandeen.net ([63.231.237.45]:45880 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727606AbgBCSih (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Feb 2020 13:38:37 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0B810F8B45;
        Mon,  3 Feb 2020 12:38:35 -0600 (CST)
Subject: Re: [PATCH 6/6] xfs: remove XFS_BUF_TO_SBP
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
References: <20200130133343.225818-1-hch@lst.de>
 <20200130133343.225818-7-hch@lst.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <d965fc02-1fa6-c52c-9d91-7803ac77a824@sandeen.net>
Date:   Mon, 3 Feb 2020 12:38:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200130133343.225818-7-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/30/20 7:33 AM, Christoph Hellwig wrote:
> Just dereference bp->b_addr directly and make the code a little
> simpler and more clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 2f60fc3c99a0..772649f4eed6 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -220,7 +220,7 @@ xfs_validate_sb_common(
>  	struct xfs_buf		*bp,
>  	struct xfs_sb		*sbp)
>  {
> -	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
> +	struct xfs_dsb		*dsb = bp->b_addr;
>  	uint32_t		agcount = 0;
>  	uint32_t		rem;
>  
> @@ -681,7 +681,7 @@ xfs_sb_read_verify(
>  {
>  	struct xfs_sb		sb;
>  	struct xfs_mount	*mp = bp->b_mount;
> -	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
> +	struct xfs_dsb		*dsb = bp->b_addr;
>  	int			error;
>  
>  	/*
> @@ -707,7 +707,7 @@ xfs_sb_read_verify(
>  	 * Check all the superblock fields.  Don't byteswap the xquota flags
>  	 * because _verify_common checks the on-disk values.
>  	 */
> -	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
> +	__xfs_sb_from_disk(&sb, bp->b_addr, false);

why not dsb here

>  	error = xfs_validate_sb_common(mp, bp, &sb);
>  	if (error)
>  		goto out_error;
> @@ -730,7 +730,7 @@ static void
>  xfs_sb_quiet_read_verify(
>  	struct xfs_buf	*bp)
>  {
> -	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
> +	struct xfs_dsb	*dsb = bp->b_addr;
>  
>  	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
>  		/* XFS filesystem, verify noisily! */
> @@ -748,13 +748,14 @@ xfs_sb_write_verify(
>  	struct xfs_sb		sb;
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +	struct xfs_dsb		*dsb = bp->b_addr;
>  	int			error;
>  
>  	/*
>  	 * Check all the superblock fields.  Don't byteswap the xquota flags
>  	 * because _verify_common checks the on-disk values.
>  	 */
> -	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
> +	__xfs_sb_from_disk(&sb, dsb, false);

(as you did here)

>  	error = xfs_validate_sb_common(mp, bp, &sb);
>  	if (error)
>  		goto out_error;
> @@ -766,7 +767,7 @@ xfs_sb_write_verify(
>  		return;
>  
>  	if (bip)
> -		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
> +		dsb->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
>  
>  	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
>  	return;
> @@ -927,7 +928,7 @@ xfs_log_sb(
>  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
>  	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
>  
> -	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> +	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);

hm no "dsb" in this case ...

In any case seems like if you already have a local xfs_dsb, use that vs. bp->b_addr?

-Eric

