Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E23292B8C
	for <lists+linux-xfs@lfdr.de>; Mon, 19 Oct 2020 18:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgJSQcR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 19 Oct 2020 12:32:17 -0400
Received: from sandeen.net ([63.231.237.45]:45830 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730565AbgJSQcR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Oct 2020 12:32:17 -0400
Received: from liberator.local (unknown [10.0.1.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 08EAE33FD;
        Mon, 19 Oct 2020 11:30:56 -0500 (CDT)
To:     xiakaixu1987@gmail.com, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
References: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
 <1603100845-12205-2-git-send-email-kaixuxia@tencent.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: use the SECTOR_SHIFT macro instead of the magic
 number
Message-ID: <771644f3-99dd-bdad-ef34-60f65faecd1a@sandeen.net>
Date:   Mon, 19 Oct 2020 11:32:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1603100845-12205-2-git-send-email-kaixuxia@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/19/20 4:47 AM, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We use the SECTOR_SHIFT macro to define the sector size shift, so maybe
> it is more reasonable to use it than the magic number 9.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Hm ...  SECTOR_SHIFT is a block layer #define, really,
and blkdev_issue_zeroout is a block layer interface I guess.

We also have our own BBSHIFT in XFS which is used elsewhere, though.

And FWIW, /many/ other fs/* manipulations still use the "- 9" today when
converting s_blocksize_bits to sectors.  *shrug* this seems like something
that should change tree-wide, if it's to be changed at all.

-Eric

> ---
>  fs/xfs/xfs_bmap_util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f2a8a0e75e1f..9f02c1824205 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -63,8 +63,8 @@ xfs_zero_extent(
>  	sector_t		block = XFS_BB_TO_FSBT(mp, sector);
>  
>  	return blkdev_issue_zeroout(target->bt_bdev,
> -		block << (mp->m_super->s_blocksize_bits - 9),
> -		count_fsb << (mp->m_super->s_blocksize_bits - 9),
> +		block << (mp->m_super->s_blocksize_bits - SECTOR_SHIFT),
> +		count_fsb << (mp->m_super->s_blocksize_bits - SECTOR_SHIFT),
>  		GFP_NOFS, 0);
>  }
>  
> 
