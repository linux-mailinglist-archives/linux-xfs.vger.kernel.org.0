Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D990380E8
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 00:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725267AbfFFWhH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Jun 2019 18:37:07 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60472 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbfFFWhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 18:37:07 -0400
Received: from dread.disaster.area (pa49-195-189-25.pa.nsw.optusnet.com.au [49.195.189.25])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id DEBB34EC0F2;
        Fri,  7 Jun 2019 08:37:04 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hZ0zP-0000hi-Ff; Fri, 07 Jun 2019 08:36:07 +1000
Date:   Fri, 7 Jun 2019 08:36:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Sheena Artrip <sheenobu@fb.com>, sheena.artrip@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_restore: detect rtinherit on destination
Message-ID: <20190606223607.GE14308@dread.disaster.area>
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
 <20190606195724.2975689-1-sheenobu@fb.com>
 <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
 <20190606215008.GA14308@dread.disaster.area>
 <4a03b347-1a71-857d-af9d-1d7eca00056a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a03b347-1a71-857d-af9d-1d7eca00056a@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=K5LJ/TdJMXINHCwnwvH1bQ==:117 a=K5LJ/TdJMXINHCwnwvH1bQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=7-415B0cAAAA:8 a=OoDP1d_ysIyUn33oZ8cA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 06, 2019 at 05:08:12PM -0500, Eric Sandeen wrote:
> On 6/6/19 4:50 PM, Dave Chinner wrote:
> > My take on this is that we need to decide which allocation policy to
> > use - the kernel policy or the dump file policy - in the different
> > situations. It's a simple, easy to document and understand solution.
> > 
> > At minimum, if there's a mismatch between rtdev/non-rtdev between
> > dump and restore, then restore should not try to restore or clear rt
> > flags at all. i.e the rt flags in the dump image should be
> > considered invalid in this situation and masked out in the restore
> > process. This prevents errors from being reported during restore,
> > and it does "the right thing" according to how the user has
> > configured the destination directory. i.e.  if the destdir has the
> > rtinherit bit set and there's a rtdev present, the kernel policy
> > will cause all file data that is restored to be allocated on the
> > rtdev. Otherwise the kernel will place it (correctly) on the data
> > dev.
> > 
> > In the case where both have rtdevs, but you want to restore to
> > ignore the dump file rtdev policy, we really only need to add a CLI
> > option to say "ignore rt flags" and that then allows the kernel
> > policy to dictate how the restored files are placed in the same way
> > that having a rtdev mismatch does.
> > 
> > This is simple, consistent, fulfils the requirements and should have
> > no hidden surprises for users....
> 
> Sounds reasonable.  So the CLI flag would say "ignore RT info in the
> dump, and write files according to the destination fs policy?"
> I think that makes sense.

*nod*

> Now: do we need to do the same for all inheritable flags?  projid,
> extsize, etc?  I think we probably do.

I disagree. These things are all supported on all destination
filesystems, unlike the rtdev. They are also things that can be
changed after the fact, unlike rtdev allocation policy. i.e. rtdev
has to be set /before/ restore, just about everything else can be
set or reset after the fact....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
