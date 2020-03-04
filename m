Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE56F179B27
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2020 22:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388410AbgCDVlZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 16:41:25 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47105 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388338AbgCDVlZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 16:41:25 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DDF347E9E1B;
        Thu,  5 Mar 2020 08:41:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9blT-0004OI-Lp; Thu, 05 Mar 2020 08:41:15 +1100
Date:   Thu, 5 Mar 2020 08:41:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: move xlog_state_ioerror()
Message-ID: <20200304214115.GC10776@dread.disaster.area>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-7-david@fromorbit.com>
 <20200304155140.GE17565@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304155140.GE17565@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=y1tgy3-oDF08Q_HeNA0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 07:51:40AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2020 at 06:53:56PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To clean up unmount record writing error handling, we need to move
> > xlog_state_ioerror() higher up in the file. Also move the setting of
> > the XLOG_IO_ERROR state to inside the function.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> FYI, I have a pending series that kills xlog_state_ioerror and
> XLOG_IO_ERROR.  Let me send that out now that Brians fix is in for-next.

Can you rebase that on top of this? removing IOERROR is a much more
invasive and riskier set of state machine changes compared to what
this patchset does. This patchset simplifies some of the error
handling that handles IOERROR, too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
