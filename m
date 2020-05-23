Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6C91DFB60
	for <lists+linux-xfs@lfdr.de>; Sun, 24 May 2020 00:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgEWWfH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 23 May 2020 18:35:07 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:33259 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgEWWfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 18:35:07 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 005565AAD33;
        Sun, 24 May 2020 08:35:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jccjM-0000rK-Gd; Sun, 24 May 2020 08:35:00 +1000
Date:   Sun, 24 May 2020 08:35:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: remove IO submission from xfs_reclaim_inode()
Message-ID: <20200523223500.GI2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-15-david@fromorbit.com>
 <20200523094055.GB7083@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523094055.GB7083@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=6rIWI3sFN3MIVjKWv6IA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 23, 2020 at 02:40:55AM -0700, Christoph Hellwig wrote:
> > +out_ifunlock:
> > +	xfs_ifunlock(ip);
> > +out:
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	xfs_iflags_clear(ip, XFS_IRECLAIM);
> > +	return false;
> >  
> >  reclaim:
> 
> I find the reordering of the error handling to sit before the actual
> reclaim action here really weird to read.  What about something like
> this folded in instead?

Yeah, once the writeback restart goes away, it does look somewhat
weird.  I've been considering pulling the actual inode reclaim code
into it's own function, just to separate it from the "try-lock and
check if we can reclaim this inode" operations.

I'll have a look and see what falls out...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
