Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5756935FEE
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfFEPMg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 11:12:36 -0400
Received: from verein.lst.de ([213.95.11.211]:43549 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727971AbfFEPMg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jun 2019 11:12:36 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 5F086227A81; Wed,  5 Jun 2019 17:12:10 +0200 (CEST)
Date:   Wed, 5 Jun 2019 17:12:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/20] xfs: remove unused buffer cache APIs
Message-ID: <20190605151210.GB14846@lst.de>
References: <20190603172945.13819-1-hch@lst.de> <20190603172945.13819-19-hch@lst.de> <20190604062442.GS29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604062442.GS29573@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 04:24:42PM +1000, Dave Chinner wrote:
> > @@ -1258,7 +1192,7 @@ xfs_buf_ioend_async(
> >  	struct xfs_buf	*bp)
> >  {
> >  	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
> > -	queue_work(bp->b_ioend_wq, &bp->b_ioend_work);
> > +	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_ioend_work);
> >  }
> 
> It'd be nice to keep bp->b_ioend_wq to avoid pointer chasing here.
> Perhaps we could set it up in _xfs_buf_alloc() where we are pretty
> much guaranteed to have the xfs_mount hot in cache, and then it's
> set for the life of the buffer. Just a thought, but either way:

We'd need to benchmark this particular case, but the bloat to
the xfs_buf structure probably cancels out at least one pointer
dereference.  That being said we probably could at least remove
one indirection without bloating the buf, I'll take a look at that.
