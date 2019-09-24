Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676B9BD508
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Sep 2019 00:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403986AbfIXWlx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Sep 2019 18:41:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41032 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394329AbfIXWlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 18:41:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OMcv6n087759;
        Tue, 24 Sep 2019 22:41:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ZYBRxwiQfukeog0jCExtNsFgA4ieCITZq0SaJQ7aMZU=;
 b=XuH+rhzcGG8Pc+h25x8vdtVF+HCEBg3JpIhV+Eb0js4o9JQWFEqdTrDF0wfewfsr5xLz
 XOFYLAtUxdGmqiTYjNNXiFFTu7GPPeNVh8w5fKKfHwfEf3q+afSI4HgSWc4QXoiCf5P+
 p8jNiRYaZghGefXPZrVrDADdAGN0tDflYs1hj+FLBN68Q7ttlp8uRjclSRjSVlIGPMBc
 fpMEDSBMbHwxHR8Xkj0TFbnDYvl5dwTdswCCgi9dWhktlqJCt3gh1FazsZ499Rhj4TMa
 3q/1V6ypnja8MOp1wEoCNWaaiFrC6ifHru9ThTKu4oWtnC4Tmky3nhoAe8qSOjLBxdwb oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btq15xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 22:41:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OMcr1c171317;
        Tue, 24 Sep 2019 22:41:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v6yvspdb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 22:41:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8OMfohY008825;
        Tue, 24 Sep 2019 22:41:50 GMT
Received: from localhost (/10.159.232.132)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 15:41:50 -0700
Date:   Tue, 24 Sep 2019 15:41:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: hard limit the background CIL push
Message-ID: <20190924224149.GC2229799@magnolia>
References: <20190909015159.19662-1-david@fromorbit.com>
 <20190909015159.19662-3-david@fromorbit.com>
 <20190916164255.GA2229799@magnolia>
 <20190924223625.GJ16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924223625.GJ16973@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 25, 2019 at 08:36:25AM +1000, Dave Chinner wrote:
> On Mon, Sep 16, 2019 at 09:42:55AM -0700, Darrick J. Wong wrote:
> > On Mon, Sep 09, 2019 at 11:51:59AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > In certain situations the background CIL push can be indefinitely
> > > delayed. While we have workarounds from the obvious cases now, it
> > > doesn't solve the underlying issue. This issue is that there is no
> > > upper limit on the CIL where we will either force or wait for
> > > a background push to start, hence allowing the CIL to grow without
> > > bound until it consumes all log space.
> > > 
> > > To fix this, add a new wait queue to the CIL which allows background
> > > pushes to wait for the CIL context to be switched out. This happens
> > > when the push starts, so it will allow us to block incoming
> > > transaction commit completion until the push has started. This will
> > > only affect processes that are running modifications, and only when
> > > the CIL threshold has been significantly overrun.
> > > 
> > > This has no apparent impact on performance, and doesn't even trigger
> > > until over 45 million inodes had been created in a 16-way fsmark
> > > test on a 2GB log. That was limiting at 64MB of log space used, so
> > > the active CIL size is only about 3% of the total log in that case.
> > > The concurrent removal of those files did not trigger the background
> > > sleep at all.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log_cil.c  | 30 +++++++++++++++++++++++++-----
> > >  fs/xfs/xfs_log_priv.h |  1 +
> > >  2 files changed, 26 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > index ef652abd112c..eec9b32f5e08 100644
> > > --- a/fs/xfs/xfs_log_cil.c
> > > +++ b/fs/xfs/xfs_log_cil.c
> > > @@ -670,6 +670,11 @@ xlog_cil_push(
> > >  	push_seq = cil->xc_push_seq;
> > >  	ASSERT(push_seq <= ctx->sequence);
> > >  
> > > +	/*
> > > +	 * Wake up any background push waiters now this context is being pushed.
> > > +	 */
> > > +	wake_up_all(&ctx->push_wait);
> > > +
> > >  	/*
> > >  	 * Check if we've anything to push. If there is nothing, then we don't
> > >  	 * move on to a new sequence number and so we have to be able to push
> > > @@ -746,6 +751,7 @@ xlog_cil_push(
> > >  	 */
> > >  	INIT_LIST_HEAD(&new_ctx->committing);
> > >  	INIT_LIST_HEAD(&new_ctx->busy_extents);
> > > +	init_waitqueue_head(&new_ctx->push_wait);
> > >  	new_ctx->sequence = ctx->sequence + 1;
> > >  	new_ctx->cil = cil;
> > >  	cil->xc_ctx = new_ctx;
> > > @@ -898,7 +904,7 @@ xlog_cil_push_work(
> > >   * checkpoint), but commit latency and memory usage limit this to a smaller
> > >   * size.
> > >   */
> > > -static void
> > > +static bool
> > >  xlog_cil_push_background(
> > >  	struct xlog	*log)
> > >  {
> > > @@ -915,14 +921,28 @@ xlog_cil_push_background(
> > >  	 * space available yet.
> > >  	 */
> > >  	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
> > > -		return;
> > > +		return false;
> > >  
> > >  	spin_lock(&cil->xc_push_lock);
> > >  	if (cil->xc_push_seq < cil->xc_current_sequence) {
> > >  		cil->xc_push_seq = cil->xc_current_sequence;
> > >  		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> > >  	}
> > > +
> > > +	/*
> > > +	 * If we are well over the space limit, throttle the work that is being
> > > +	 * done until the push work on this context has begun. This will prevent
> > > +	 * the CIL from violating maximum transaction size limits if the CIL
> > > +	 * push is delayed for some reason.
> > > +	 */
> > > +	if (cil->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log) * 2) {
> > > +		up_read(&cil->xc_ctx_lock);
> > > +		trace_printk("CIL space used %d", cil->xc_ctx->space_used);
> > 
> > Needs a real tracepoint before this drops RFC status.
> 
> Ok, that was just debugging stuff I forgot to remove, but I can turn
> it into a real tracepoint if you want.

<shrug> You could drop it too; I was just point out the trace_printk.

(For those of you following at home, trace_printk calls generate huge
debugging warnings at module load time.)

> > 
> > > +		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
> > > +		return true;
> > > +	}
> > >  	spin_unlock(&cil->xc_push_lock);
> > > +	return false;
> > >  
> > >  }
> > >  
> > > @@ -1038,9 +1058,8 @@ xfs_log_commit_cil(
> > >  		if (lip->li_ops->iop_committing)
> > >  			lip->li_ops->iop_committing(lip, xc_commit_lsn);
> > >  	}
> > > -	xlog_cil_push_background(log);
> > > -
> > > -	up_read(&cil->xc_ctx_lock);
> > > +	if (!xlog_cil_push_background(log))
> > > +		up_read(&cil->xc_ctx_lock);
> > 
> > Hmmmm... the return value here tell us if ctx_lock has been dropped.
> > /me wonders if this would be cleaner if xlog_cil_push_background
> > returned having called up_read...?
> 
> I thought about that - was on the fence about what to do. I'll
> change it to be unconditional.

<nod>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
