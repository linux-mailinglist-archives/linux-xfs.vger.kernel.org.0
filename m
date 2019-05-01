Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31ED10EEE
	for <lists+linux-xfs@lfdr.de>; Thu,  2 May 2019 00:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfEAWQ4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 May 2019 18:16:56 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37086 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbfEAWQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 May 2019 18:16:56 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 428843DBC64;
        Thu,  2 May 2019 08:16:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hLxX2-0004ty-Uh; Thu, 02 May 2019 08:16:52 +1000
Date:   Thu, 2 May 2019 08:16:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: change some error-less functions to void types
Message-ID: <20190501221652.GJ29573@dread.disaster.area>
References: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=u6UJkIbsG68hQ2HoRb4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 01, 2019 at 10:55:54AM -0500, Eric Sandeen wrote:
> There are several functions which have no opportunity to retun
> an error, and don't contain any ASSERTs which could be argued
> to be better constructed as error cases.  So, make them voids
> to simplify the callers.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
....
> @@ -1840,7 +1840,6 @@ xlog_sync(
>  	uint		count_init;	/* initial count before roundup */
>  	int		roundoff;       /* roundoff to BB or stripe */
>  	int		split = 0;	/* split write into two regions */
> -	int		error;
>  	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
>  	int		size;
>  
> @@ -1959,11 +1958,8 @@ xlog_sync(
>  	 * Don't call xfs_bwrite here. We do log-syncs even when the filesystem
>  	 * is shutting down.
>  	 */
> -	error = xlog_bdstrat(bp);
> -	if (error) {
> -		xfs_buf_ioerror_alert(bp, "xlog_sync");
> -		return error;
> -	}
> +	xlog_bdstrat(bp);

Shouldn't this be checking bp->b_error rather than completely
ignoring buffer submit errors?

> +
>  	if (split) {
>  		bp = iclog->ic_log->l_xbuf;
>  		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
> @@ -1978,11 +1974,7 @@ xlog_sync(
>  
>  		/* account for internal log which doesn't start at block #0 */
>  		XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
> -		error = xlog_bdstrat(bp);
> -		if (error) {
> -			xfs_buf_ioerror_alert(bp, "xlog_sync (split)");
> -			return error;
> -		}
> +		xlog_bdstrat(bp);

Ditto.

Otherwise it looks fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
