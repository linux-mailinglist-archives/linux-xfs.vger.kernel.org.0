Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CFB181023
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Mar 2020 06:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgCKFjp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Mar 2020 01:39:45 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56706 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725813AbgCKFjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 01:39:45 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D23BF7E92F9;
        Wed, 11 Mar 2020 16:39:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBu5n-0007FR-8E; Wed, 11 Mar 2020 16:39:43 +1100
Date:   Wed, 11 Mar 2020 16:39:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: fix buffer corruption reporting when
 xfs_dir3_free_header_check fails
Message-ID: <20200311053943.GW10776@dread.disaster.area>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
 <158388765361.939165.18143580183240823438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388765361.939165.18143580183240823438.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=L86aNoYa587FchDg01oA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:47:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_verifier_error is supposed to be called on a corrupt metadata buffer
> from within a buffer verifier function, whereas xfs_buf_corruption_error

xfs_buf_mark_corrupt()?

> is the function to be called when a piece of code has read a buffer and
> catches something that a read verifier cannot.  The first function sets
> b_error anticipating that the low level buffer handling code will see
> the nonzero b_error and clear XBF_DONE on the buffer, whereas the second
> function does not.
> 
> Since xfs_dir3_free_header_check examines fields in the dir free block
> header that require more context than can be provided to read verifiers,
> we must call xfs_buf_corruption_error when it finds a problem.

And again?

> 
> Switching the calls has a secondary effect that we no longer corrupt the
> buffer state by setting b_error and leaving XBF_DONE set.  When /that/
> happens, we'll trip over various state assertions (most commonly the
> b_error check in xfs_buf_reverify) on a subsequent attempt to read the
> buffer.
> 
> Fixes: bc1a09b8e334bf5f ("xfs: refactor verifier callers to print address of failing check")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_node.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index dbd1e901da92..af4f22dc3891 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -226,7 +226,7 @@ __xfs_dir3_free_read(
>  	/* Check things that we can't do in the verifier. */
>  	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
>  	if (fa) {
> -		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
> +		__xfs_buf_mark_corrupt(*bpp, fa);
>  		xfs_trans_brelse(tp, *bpp);
>  		return -EFSCORRUPTED;
>  	}

Code looks fine. WIth the commit description fixes,

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
