Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C03D994
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Apr 2019 00:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfD1Wlt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 28 Apr 2019 18:41:49 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53158 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbfD1Wlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Apr 2019 18:41:49 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 36E6D10CC09;
        Mon, 29 Apr 2019 08:41:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hKsUT-00049f-MI; Mon, 29 Apr 2019 08:41:45 +1000
Date:   Mon, 29 Apr 2019 08:41:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add missing error check in xfs_prepare_shift()
Message-ID: <20190428224145.GG29573@dread.disaster.area>
References: <20190426120633.36420-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426120633.36420-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=oexKYjalfGEA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=0ldHZi7yVlyTHLqT_7QA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 26, 2019 at 08:06:33AM -0400, Brian Foster wrote:
> xfs_prepare_shift() fails to check the error return from
> xfs_flush_unmap_range(). If the latter fails, that could lead to an
> insert/collapse range operation over a delalloc range, which is not
> supported.
> 
> Add an error check and return appropriately. This is reproduced
> rarely by generic/475.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2db43ff4f8b5..06d07f1e310b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1193,6 +1193,8 @@ xfs_prepare_shift(
>  	 * about to shift down every extent from offset to EOF.
>  	 */
>  	error = xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip));
> +	if (error)
> +		return error;

Urk. My fault.

Fixes: 7f9f71be84bc ("xfs: extent shifting doesn't fully invalidate page cache")

Not sure how I screwed up that simple change so obviously and didn't
notice it.

Fix for the fix looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
