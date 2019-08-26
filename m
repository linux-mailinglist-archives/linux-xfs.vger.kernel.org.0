Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD179D9D4
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2019 01:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfHZXP0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Aug 2019 19:15:26 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44401 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbfHZXP0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 19:15:26 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 64C2643C76C;
        Tue, 27 Aug 2019 09:15:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2OCo-0000lH-MY; Tue, 27 Aug 2019 09:15:22 +1000
Date:   Tue, 27 Aug 2019 09:15:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 3/4] xfs: don't return _QUERY_ABORT from
 xfs_rmap_has_other_keys
Message-ID: <20190826231522.GO1119@dread.disaster.area>
References: <156685612356.2853532.10960947509015722027.stgit@magnolia>
 <156685614244.2853532.3739810624053899109.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685614244.2853532.3739810624053899109.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=UD9wB-r_hoJu2ZtOc3wA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:49:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The xfs_rmap_has_other_keys helper aborts the iteration as soon as it
> has an answer.  Don't let this abort leak out to callers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_rmap.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index e6aeb390b2fb..819693ef852c 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2540,8 +2540,11 @@ xfs_rmap_has_other_keys(
>  
>  	error = xfs_rmap_query_range(cur, &low, &high,
>  			xfs_rmap_has_other_keys_helper, &rks);
> +	if (error < 0)
> +		return error;
> +
>  	*has_rmap = rks.has_rmap;
> -	return error;
> +	return 0;
>  }

Yup, makes sense - XFS_BTREE_QUERY_RANGE_ABORT has a positive value,
so this makes success have a return value of 0 and that fixes
the spurious error detection in xrep_reap_block().

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
