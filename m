Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8C9189191
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Mar 2020 23:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCQWpn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Mar 2020 18:45:43 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57642 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726476AbgCQWpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 18:45:43 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CF4563A27BA;
        Wed, 18 Mar 2020 09:45:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jEKxv-0004rR-Dt; Wed, 18 Mar 2020 09:45:39 +1100
Date:   Wed, 18 Mar 2020 09:45:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: use more suitable method to get the quota limit
 value
Message-ID: <20200317224539.GT10776@dread.disaster.area>
References: <1584439170-20993-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584439170-20993-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8 a=7-415B0cAAAA:8 a=bYcOrKCbppIr1DEv7TAA:9
        a=CjuIK1q_8ugA:10 a=IZKFYfNWVLfQsFoIDbx0:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 05:59:30PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> It is more suitable to use min_not_zero() to get the quota limit
> value, means to choose the minimum value not the softlimit firstly.
> And the meaning is more clear even though the hardlimit value must
> be larger than softlimit value.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_qm_bhv.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index fc2fa41..f1711f5 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -23,9 +23,8 @@
>  {
>  	uint64_t		limit;
>  
> -	limit = dqp->q_core.d_blk_softlimit ?
> -		be64_to_cpu(dqp->q_core.d_blk_softlimit) :
> -		be64_to_cpu(dqp->q_core.d_blk_hardlimit);
> +	limit = min_not_zero(be64_to_cpu(dqp->q_core.d_blk_softlimit),
> +				be64_to_cpu(dqp->q_core.d_blk_hardlimit));
>  	if (limit && statp->f_blocks > limit) {
>  		statp->f_blocks = limit;
>  		statp->f_bfree = statp->f_bavail =
> @@ -33,9 +32,8 @@
>  			 (statp->f_blocks - dqp->q_res_bcount) : 0;
>  	}
>  
> -	limit = dqp->q_core.d_ino_softlimit ?
> -		be64_to_cpu(dqp->q_core.d_ino_softlimit) :
> -		be64_to_cpu(dqp->q_core.d_ino_hardlimit);
> +	limit = min_not_zero(be64_to_cpu(dqp->q_core.d_ino_softlimit),
> +				be64_to_cpu(dqp->q_core.d_ino_hardlimit));

Which variable is "not zero"? The first, the second, or both?

Oh, it's both, so this is actually a change of logic:

	if (softlimit == 0)
		limit = hardlimit;
	else if (hardlimit == 0)
		limit = softlimit;
	else
		limit = min(softlimit, hardlimit);

So now if both soft and hard limit are set, the hard limit overrides
the soft limit, even when only the soft limit should apply (e.g.
during the grace period).

Hence this ends up being a user visible change in behaviour. And,
IMO, this doesn't make the code better or clearer as now I have go
find the definition of min_not_zero() to understand what the soft
limit vs hard limit quota policy logic is. That's not an improvement.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
