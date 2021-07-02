Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A493B9DAD
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Jul 2021 10:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhGBIse (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Jul 2021 04:48:34 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:57739 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhGBIsd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:48:33 -0400
Received: from dread.disaster.area (pa49-179-204-119.pa.nsw.optusnet.com.au [49.179.204.119])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id DDAAF1B295A;
        Fri,  2 Jul 2021 18:45:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lzEoA-001pke-TK; Fri, 02 Jul 2021 18:45:58 +1000
Date:   Fri, 2 Jul 2021 18:45:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: convert XLOG_FORCED_SHUTDOWN() to
 xlog_is_shutdown()
Message-ID: <20210702084558.GG664593@dread.disaster.area>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-2-david@fromorbit.com>
 <YN7Et6kfwhGaVfEp@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN7Et6kfwhGaVfEp@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=Xomv9RKALs/6j/eO6r2ntA==:117 a=Xomv9RKALs/6j/eO6r2ntA==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=oK3C-Madq3iamnEB14EA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 08:48:07AM +0100, Christoph Hellwig wrote:
> > @@ -366,7 +366,7 @@ xfs_log_writable(
> >  		return false;
> >  	if (xfs_readonly_buftarg(mp->m_log->l_targ))
> >  		return false;
> > -	if (XFS_FORCED_SHUTDOWN(mp))
> > +	if (xlog_is_shutdown(mp->m_log))
> 
> This wasn't XLOG_FORCED_SHUTDOWN to start with.  Same for a few more
> spots.

Yup, but in the places where we are working on the log, we should be
checking the log state for shutdown, not the mount. They currently
mean the same thing, but that doesn't mean we should use mount based
checks in the log and vice versa.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
