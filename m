Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2217B7D981
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 12:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfHAKkB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 06:40:01 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47524 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbfHAKkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 06:40:01 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D06FA362529;
        Thu,  1 Aug 2019 20:39:58 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1ht8Tz-0006j7-6T; Thu, 01 Aug 2019 20:38:51 +1000
Date:   Thu, 1 Aug 2019 20:38:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: show error code when printing writeback error
 messages.
Message-ID: <20190801103851.GL7777@dread.disaster.area>
References: <1564653826-8916-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564653826-8916-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=a5PUgtkmG6ULH8o35iYA:9 a=D1-ITyf_VnGRno2C:21
        a=1q7RvUhNA1oJjN_3:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 07:03:46PM +0900, Tetsuo Handa wrote:
> Even without backtraces, including error code should be helpful.
> 
>   [  630.162595][ T9218] XFS (sda1): writeback error -12 on sector 131495992
>   [  631.718685][ T9432] XFS (sda1): writeback error -12 on sector 131503928
>   [  632.015588][  T442] XFS (sda1): writeback error -12 on sector 157773936
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  fs/xfs/xfs_aops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f16d5f196c6b..d2c9076643cf 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -112,7 +112,7 @@ xfs_destroy_ioend(
>  
>  	if (unlikely(error && !quiet)) {
>  		xfs_err_ratelimited(XFS_I(inode)->i_mount,
> -			"writeback error on sector %llu", start);
> +			"writeback error %d on sector %llu", error, start);

If you are going to do this, make the error message properly useful.
Report the inode number and the ioend offset and length so we know
what file and where in the file the writeback failure occurred.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
