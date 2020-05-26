Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CB61B194D
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Apr 2020 00:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgDTWTN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 Apr 2020 18:19:13 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58197 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgDTWTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 18:19:12 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C99353A3FE0;
        Tue, 21 Apr 2020 08:19:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQeku-0006KG-Q2; Tue, 21 Apr 2020 08:19:08 +1000
Date:   Tue, 21 Apr 2020 08:19:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: refactor failed buffer resubmission into
 xfsaild
Message-ID: <20200420221908.GO9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-2-bfoster@redhat.com>
 <20200420024556.GD9800@dread.disaster.area>
 <20200420135825.GA27516@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420135825.GA27516@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=MzdJU4Orhpkszo7Ei48A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 09:58:25AM -0400, Brian Foster wrote:
> On Mon, Apr 20, 2020 at 12:45:56PM +1000, Dave Chinner wrote:
> > On Fri, Apr 17, 2020 at 11:08:48AM -0400, Brian Foster wrote:
> > > Flush locked log items whose underlying buffers fail metadata
> > > writeback are tagged with a special flag to indicate that the flush
> > > lock is already held. This is currently implemented in the type
> > > specific ->iop_push() callback, but the processing required for such
> > > items is not type specific because we're only doing basic state
> > > management on the underlying buffer.
> > > 
> > > Factor the failed log item handling out of the inode and dquot
> > > ->iop_push() callbacks and open code the buffer resubmit helper into
> > > a single helper called from xfsaild_push_item(). This provides a
> > > generic mechanism for handling failed metadata buffer writeback with
> > > a bit less code.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > .....
> > > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > > index 564253550b75..0c709651a2c6 100644
> > > --- a/fs/xfs/xfs_trans_ail.c
> > > +++ b/fs/xfs/xfs_trans_ail.c
> > > @@ -345,6 +345,45 @@ xfs_ail_delete(
> > >  	xfs_trans_ail_cursor_clear(ailp, lip);
> > >  }
> > >  
> > > +/*
> > > + * Requeue a failed buffer for writeback.
> > > + *
> > > + * We clear the log item failed state here as well, but we have to be careful
> > > + * about reference counts because the only active reference counts on the buffer
> > > + * may be the failed log items. Hence if we clear the log item failed state
> > > + * before queuing the buffer for IO we can release all active references to
> > > + * the buffer and free it, leading to use after free problems in
> > > + * xfs_buf_delwri_queue. It makes no difference to the buffer or log items which
> > > + * order we process them in - the buffer is locked, and we own the buffer list
> > > + * so nothing on them is going to change while we are performing this action.
> > > + *
> > > + * Hence we can safely queue the buffer for IO before we clear the failed log
> > > + * item state, therefore  always having an active reference to the buffer and
> > > + * avoiding the transient zero-reference state that leads to use-after-free.
> > > + */
> > > +static inline int
> > > +xfsaild_push_failed(
> > 
> > Bad name IMO. Makes me think it's an action that is taken when an
> > item push failed, not an action that resubmits a buffer that had an
> > IO failure.
> > 
> > i.e. "push" doesn't imply IO, and failure to push an item doesn't
> > mean there was an IO error - it may be locked, already flushing,
> > pinned, etc.
> > 
> 
> Yeah..
> 
> > > +	struct xfs_log_item	*lip,
> > > +	struct list_head	*buffer_list)
> > > +{
> > > +	struct xfs_buf		*bp = lip->li_buf;
> > 
> > This also assumes that the log item has a buffer associated with it.
> > So perhaps "xfsaild_resubmit_failed_buffer()" would be more
> > approriate here.
> > 
> 
> The buffer pointer is an implementation detail of failed items. It would
> be nice to find a way to avoid that. How about xfsaild_resubmit_item()
> to be consistent with the parent function (xfsaild_push_item())?

That works, too. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
