Return-Path: <linux-xfs+bounces-319-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3232B800087
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Dec 2023 01:48:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E146528176A
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Dec 2023 00:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476087EC;
	Fri,  1 Dec 2023 00:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B34NecWm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016ED387
	for <linux-xfs@vger.kernel.org>; Fri,  1 Dec 2023 00:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E2BC433C7;
	Fri,  1 Dec 2023 00:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701391717;
	bh=X3BUXBkYtJpQwRLU1TU93lDeXDMkOvPhcnf4C78mwE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B34NecWmUeynFoxpCccTt6X0ePUEaVz/2L95Aj+VnddScKVn/x0F4wjvOMXnI2TTB
	 FXX1VNB8ZcBQa01kvBfpJHTROGZFOdQXBDN6Kjm9rqBbfbGPbwtb5y81sntzf3JDaE
	 kwrSkHGlolekoczeVKSUfM7owM6p1L1yeY1EBJvUpmaR2+cZ78fEa1ISTXEdtXl2V9
	 GmTbNLpSLwy0i46h76+7YF7152eZVL3sjvXTx6Sikks1ZieN37ghoraiRU5NQA2XHM
	 faUokYGOtzMd2bmf5ePKtZnmJvLuJSMhunnUkfJ7lGGlzipGWqvoflW+cLjHQCXmBg
	 mzfoh4DDL6ocQ==
Date: Thu, 30 Nov 2023 16:48:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, xieyongji@bytedance.com, me@jcix.top,
	Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/3] xfs: update dir3 leaf block metadata after swap
Message-ID: <20231201004836.GS361584@frogsfrogsfrogs>
References: <20231130040516.35677-1-zhangjiachen.jaycee@bytedance.com>
 <20231130040516.35677-3-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130040516.35677-3-zhangjiachen.jaycee@bytedance.com>

On Thu, Nov 30, 2023 at 12:05:15PM +0800, Jiachen Zhang wrote:
> From: Zhang Tianci <zhangtianci.1997@bytedance.com>
> 
> xfs_da3_swap_lastblock() copy the last block content to the dead block,
> but do not update the metadata in it. We need update some metadata
> for some kinds of type block, such as dir3 leafn block records its
> blkno, we shall update it to the dead block blkno. Otherwise,
> before write the xfs_buf to disk, the verify_write() will fail in
> blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.
> 
> We will get this warning:
> 
>   XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
>   XFS (dm-0): Unmount and run xfs_repair
>   XFS (dm-0): First 128 bytes of corrupted metadata buffer:
>   00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
>   000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
>   000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
>   00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
>   00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
>   000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
>   00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
>   0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
>   XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
>   XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
>   XFS (dm-0): Please umount the filesystem and rectify the problem(s)
> 
> From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
> its blkno is 0x1a0.
> 
> Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
> Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>

Looks fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index e576560b46e9..f3f987a65bc1 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2316,10 +2316,18 @@ xfs_da3_swap_lastblock(
>  		return error;
>  	/*
>  	 * Copy the last block into the dead buffer and log it.
> +	 * If xfs enable crc, the node/leaf block records its blkno, we
> +	 * must update it.
>  	 */
>  	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
> +	if (xfs_has_crc(mp)) {
> +		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
> +
> +		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
> +	}
>  	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
>  	dead_info = dead_buf->b_addr;
> +
>  	/*
>  	 * Get values from the moved block.
>  	 */
> -- 
> 2.20.1
> 
> 

