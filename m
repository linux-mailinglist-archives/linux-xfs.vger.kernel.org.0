Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B29D3268F2
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Feb 2021 21:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBZUwQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Feb 2021 15:52:16 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:45206 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229863AbhBZUwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 15:52:16 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id AB0FEFA75A7;
        Sat, 27 Feb 2021 07:51:28 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFk58-005n9L-Ty; Sat, 27 Feb 2021 07:51:26 +1100
Date:   Sat, 27 Feb 2021 07:51:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "hch@lst.de" <hch@lst.de>, "rgoldwyn@suse.de" <rgoldwyn@suse.de>,
        "y-goto@fujitsu.com" <y-goto@fujitsu.com>,
        "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
        "fnstml-iaas@cn.fujitsu.com" <fnstml-iaas@cn.fujitsu.com>
Subject: Re: Question about the "EXPERIMENTAL" tag for dax in XFS
Message-ID: <20210226205126.GX4662@dread.disaster.area>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
 <OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20210226190454.GD7272@magnolia>
 <CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=kMQJH97U55PVhH6LZb8A:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 26, 2021 at 11:24:53AM -0800, Dan Williams wrote:
> On Fri, Feb 26, 2021 at 11:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Fri, Feb 26, 2021 at 09:45:45AM +0000, ruansy.fnst@fujitsu.com wrote:
> > > Hi, guys
> > >
> > > Beside this patchset, I'd like to confirm something about the
> > > "EXPERIMENTAL" tag for dax in XFS.
> > >
> > > In XFS, the "EXPERIMENTAL" tag, which is reported in waring message
> > > when we mount a pmem device with dax option, has been existed for a
> > > while.  It's a bit annoying when using fsdax feature.  So, my initial
> > > intention was to remove this tag.  And I started to find out and solve
> > > the problems which prevent it from being removed.
> > >
> > > As is talked before, there are 3 main problems.  The first one is "dax
> > > semantics", which has been resolved.  The rest two are "RMAP for
> > > fsdax" and "support dax reflink for filesystem", which I have been
> > > working on.
> >
> > <nod>
> >
> > > So, what I want to confirm is: does it means that we can remove the
> > > "EXPERIMENTAL" tag when the rest two problem are solved?
> >
> > Yes.  I'd keep the experimental tag for a cycle or two to make sure that
> > nothing new pops up, but otherwise the two patchsets you've sent close
> > those two big remaining gaps.  Thank you for working on this!
> >
> > > Or maybe there are other important problems need to be fixed before
> > > removing it?  If there are, could you please show me that?
> >
> > That remains to be seen through QA/validation, but I think that's it.
> >
> > Granted, I still have to read through the two patchsets...
> 
> I've been meaning to circle back here as well.
> 
> My immediate concern is the issue Jason recently highlighted [1] with
> respect to invalidating all dax mappings when / if the device is
> ripped out from underneath the fs. I don't think that will collide
> with Ruan's implementation, but it does need new communication from
> driver to fs about removal events.
> 
> [1]: http://lore.kernel.org/r/CAPcyv4i+PZhYZiePf2PaH0dT5jDfkmkDX-3usQy1fAhf6LPyfw@mail.gmail.com

Oh, yay.

The XFS shutdown code is centred around preventing new IO from being
issued - we don't actually do anything about DAX mappings because,
well, I don't think anyone on the filesystem side thought they had
to do anything special if pmem went away from under it.

My understanding -was- that the pmem removal invalidates
all the ptes currently mapped into CPU page tables that point at
the dax device across the system. THe vmas that manage these
mappings are not really something the filesystem really manages,
but a function of the mm subsystem. What the filesystem cares about
is that it gets page faults triggered when a change of state occurs
so that it can remap the page to it's backing store correctly.

IOWs, all the mm subsystem needs to when pmem goes away is clear the
CPU ptes, because then when then when userspace tries to access the
mapped DAX pages we get a new page fault. In processing the fault, the
filesystem will try to get direct access to the pmem from the block
device. This will get an ENODEV error from the block device because
because the backing store (pmem) has been unplugged and is no longer
there...

AFAICT, as long as pmem removal invalidates all the active ptes that
point at the pmem being removed, the filesystem doesn't need to
care about device removal at all, DAX or no DAX...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
