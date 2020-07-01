Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBD2211678
	for <lists+linux-xfs@lfdr.de>; Thu,  2 Jul 2020 01:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgGAXH6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 19:07:58 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:41091 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgGAXH6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:07:58 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 696D9D5BEBC;
        Thu,  2 Jul 2020 09:07:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqlpa-00012A-Hx; Thu, 02 Jul 2020 09:07:54 +1000
Date:   Thu, 2 Jul 2020 09:07:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/18] xfs: remove qcore from incore dquots
Message-ID: <20200701230754.GC2005@dread.disaster.area>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353178119.2864738.14352743945962585449.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353178119.2864738.14352743945962585449.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=tubq6eRdZO55jiZcQK8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:43:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've stopped using qcore entirely, drop it from the incore
> dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....
> @@ -1180,7 +1184,6 @@ xfs_qm_dqflush(
>  	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
>  	struct xfs_buf		*bp;
>  	struct xfs_dqblk	*dqb;
> -	struct xfs_disk_dquot	*ddqp;
>  	xfs_failaddr_t		fa;
>  	int			error;
>  
> @@ -1204,22 +1207,6 @@ xfs_qm_dqflush(
>  	if (error)
>  		goto out_abort;
>  
> -	/*
> -	 * Calculate the location of the dquot inside the buffer.
> -	 */
> -	dqb = bp->b_addr + dqp->q_bufoffset;
> -	ddqp = &dqb->dd_diskdq;
> -
> -	/* sanity check the in-core structure before we flush */
> -	fa = xfs_dquot_verify(mp, &dqp->q_core, dqp->q_id, 0);
> -	if (fa) {
> -		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> -				dqp->q_id, fa);
> -		xfs_buf_relse(bp);
> -		error = -EFSCORRUPTED;
> -		goto out_abort;
> -	}
> -
>  	fa = xfs_qm_dqflush_check(dqp);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> @@ -1229,7 +1216,9 @@ xfs_qm_dqflush(
>  		goto out_abort;
>  	}
>  
> -	xfs_dquot_to_disk(ddqp, dqp);
> +	/* Flush the incore dquot to the ondisk buffer. */
> +	dqb = bp->b_addr + dqp->q_bufoffset;
> +	xfs_dquot_to_disk(&dqb->dd_diskdq, dqp);

Oh, this is really hard to read now. d, q, b, and p are all the same
shape just at different rotations/mirroring, so this now just looks
like a jumble of random letter salad...

Can you rename dqb to dqblk so it's clearly the pointer to the
on-disk dquot block and so easy to differentiate at a glance from
the in-memory dquot pointer?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
