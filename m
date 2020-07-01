Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A992116C0
	for <lists+linux-xfs@lfdr.de>; Thu,  2 Jul 2020 01:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgGAXpV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 19:45:21 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:43609 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbgGAXpV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:45:21 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id CF8A8D5B689;
        Thu,  2 Jul 2020 09:45:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqmPl-0001Ef-AP; Thu, 02 Jul 2020 09:45:17 +1000
Date:   Thu, 2 Jul 2020 09:45:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] xfs: stop using q_core limits in the quota code
Message-ID: <20200701234517.GG2005@dread.disaster.area>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353175596.2864738.3236954866547071975.stgit@magnolia>
 <20200701230136.GB2005@dread.disaster.area>
 <20200701231343.GN7625@magnolia>
 <20200701233330.GX7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701233330.GX7606@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=3XQjghkQ7L7xg0bvoPsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 04:33:30PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 01, 2020 at 04:13:43PM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 02, 2020 at 09:01:36AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 30, 2020 at 08:42:36AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add limits fields in the incore dquot, and use that instead of the ones
> > > > in qcore.  This eliminates a bunch of endian conversions and will
> > > > eventually allow us to remove qcore entirely.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ....
> > > > @@ -124,82 +123,67 @@ xfs_qm_adjust_dqtimers(
> > > >  	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
> > > >  
> > > >  #ifdef DEBUG
> > > > -	if (d->d_blk_hardlimit)
> > > > -		ASSERT(be64_to_cpu(d->d_blk_softlimit) <=
> > > > -		       be64_to_cpu(d->d_blk_hardlimit));
> > > > -	if (d->d_ino_hardlimit)
> > > > -		ASSERT(be64_to_cpu(d->d_ino_softlimit) <=
> > > > -		       be64_to_cpu(d->d_ino_hardlimit));
> > > > -	if (d->d_rtb_hardlimit)
> > > > -		ASSERT(be64_to_cpu(d->d_rtb_softlimit) <=
> > > > -		       be64_to_cpu(d->d_rtb_hardlimit));
> > > > +	if (dq->q_blk.hardlimit)
> > > > +		ASSERT(dq->q_blk.softlimit <= dq->q_blk.hardlimit);
> > > > +	if (dq->q_ino.hardlimit)
> > > > +		ASSERT(dq->q_ino.softlimit <= dq->q_ino.hardlimit);
> > > > +	if (dq->q_rtb.hardlimit)
> > > > +		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
> > > >  #endif
> > > 
> > > You can get rid of the ifdef DEBUG here - if ASSERT is not defined
> > > then the compiler will elide all this code anyway.
> > 
> > OK.
> 
> Actually, not ok.  A later patch in this series will refactor this whole
> ugly function (and in the next round the #ifdefs) out of existence, so
> I'll leave this part of the patch the way it is.

Ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
