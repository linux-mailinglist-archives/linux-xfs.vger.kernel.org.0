Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAED336C4F
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Mar 2021 07:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCKGdw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Mar 2021 01:33:52 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:56558 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhCKGdl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 01:33:41 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 7E1491ADDEE;
        Thu, 11 Mar 2021 17:33:39 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKEt8-001BUM-KF; Thu, 11 Mar 2021 17:33:38 +1100
Date:   Thu, 11 Mar 2021 17:33:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/45] xfs: introduce per-cpu CIL tracking sructure
Message-ID: <20210311063338.GS74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-36-david@fromorbit.com>
 <20210311001143.GI3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311001143.GI3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=GHZnUlPYkmVdWoHcJBAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 04:11:43PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:33PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The CIL push lock is highly contended on larger machines, becoming a
> > hard bottleneck that about 700,000 transaction commits/s on >16p
> > machines. To address this, start moving the CIL tracking
> > infrastructure to utilise per-CPU structures.
> > 
> > We need to track the space used, the amount of log reservation space
> > reserved to write the CIL, the log items in the CIL and the busy
> > extents that need to be completed by the CIL commit.  This requires
> > a couple of per-cpu counters, an unordered per-cpu list and a
> > globally ordered per-cpu list.
> > 
> > Create a per-cpu structure to hold these and all the management
> > interfaces needed, as well as the hooks to handle hotplug CPUs.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c       | 94 ++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_log_priv.h      | 15 ++++++
> >  include/linux/cpuhotplug.h |  1 +
> >  3 files changed, 110 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index f8fb2f59e24c..1bcf0d423d30 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -1365,6 +1365,93 @@ xfs_log_item_in_current_chkpt(
> >  	return true;
> >  }
> >  
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +static LIST_HEAD(xlog_cil_pcp_list);
> > +static DEFINE_SPINLOCK(xlog_cil_pcp_lock);
> > +static bool xlog_cil_pcp_init;
> > +
> > +static int
> > +xlog_cil_pcp_dead(
> > +	unsigned int		cpu)
> > +{
> > +	struct xfs_cil		*cil;
> > +
> > +        spin_lock(&xlog_cil_pcp_lock);
> > +        list_for_each_entry(cil, &xlog_cil_pcp_list, xc_pcp_list) {
> 
> Weird indentation.
> 
> > +		/* move stuff on dead CPU to context */
> 
> Should this have some actual code?  I don't think any of the remaining
> patches add anything here.

They should be moving stuff to the current CIL ctx so it is captured
when the CPU goes down.

> 
> > +	}
> > +	spin_unlock(&xlog_cil_pcp_lock);
> > +	return 0;
> > +}
> > +
> > +static int
> > +xlog_cil_pcp_hpadd(
> > +	struct xfs_cil		*cil)
> > +{
> > +	if (!xlog_cil_pcp_init) {
> > +		int	ret;
> > +		ret = cpuhp_setup_state_nocalls(CPUHP_XFS_CIL_DEAD,
> > +						"xfs/cil_pcp:dead", NULL,
> > +						xlog_cil_pcp_dead);
> > +		if (ret < 0) {
> > +			xfs_warn(cil->xc_log->l_mp,
> > +	"Failed to initialise CIL hotplug, error %d. XFS is non-functional.",
> 
> How likely is to happen?

AFAICT, very unlikely, but....

> 
> > +				ret);
> > +			ASSERT(0);
> 
> I guess not that often?
> 
> > +			return -ENOMEM;
> 
> Why not return ret here?  I guess it's because ret could be any number
> of (not centrally documented?) error codes, and we don't really care to
> expose that to userspace?

... yeah.

The cpu hotplug stuff is poorly documented and the code is another
of those "maze of twisty passages" implementations that bounce
through many functions that can return all sorts of different stuff
from lots of different things that could got wrong. I see at least
EINVAL, ENOSPC, ENOMEM, EBUSY and EAGAIN could be returned, and I
have no idea what any of them would actually mean went wrong.

In the end I kinda just copied what the radix tree and percpu
counter code do with an error failing to init hotplug calls: WARN
and then ignore. Hence from the filesystem POV, the error may as
well be ENOMEM because we couldn't set something critical up and
that saves us getting confused over whether the error is fatal or
not at a higher level.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
