Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881F93EF67B
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Aug 2021 02:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhHRAIK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Aug 2021 20:08:10 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:44218 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232706AbhHRAIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Aug 2021 20:08:09 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 326331145FD3;
        Wed, 18 Aug 2021 10:07:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mG97B-001vwv-8z; Wed, 18 Aug 2021 10:07:29 +1000
Date:   Wed, 18 Aug 2021 10:07:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rename buffer cache index variable b_bn
Message-ID: <20210818000729.GL3657114@dread.disaster.area>
References: <20210810052851.42312-1-david@fromorbit.com>
 <20210810052851.42312-4-david@fromorbit.com>
 <20210811004632.GA3601443@magnolia>
 <20210817234827.GK3657114@dread.disaster.area>
 <20210817235609.GF12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817235609.GF12640@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=EXns9mbz2a-Rd76DZ1wA:9 a=QKGu5k3Wk_WS9xGK:21 a=wohshYAYA48IVkDh:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:56:09PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 18, 2021 at 09:48:27AM +1000, Dave Chinner wrote:
> > On Tue, Aug 10, 2021 at 05:46:32PM -0700, Darrick J. Wong wrote:
> > > On Tue, Aug 10, 2021 at 03:28:51PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > TO stop external users from using b_bn as the disk address of the
> > > > buffer, rename it to b_index to indicate that it is the buffer cache
> > > > index, not the block number of the buffer. Code that needs the disk
> > > > address should use xfs_buf_daddr() to obtain it.
> > > > 
> > > > Do the rename and clean up any of the remaining b_bn cruft that is
> > > > left over and is now unused.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_buf.c | 19 +++++++++++--------
> > > >  fs/xfs/xfs_buf.h | 18 +-----------------
> > > >  2 files changed, 12 insertions(+), 25 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > index c1bb6e41595b..6f6c6937baaa 100644
> > > > --- a/fs/xfs/xfs_buf.c
> > > > +++ b/fs/xfs/xfs_buf.c
> > > > @@ -251,7 +251,7 @@ _xfs_buf_alloc(
> > > >  		return error;
> > > >  	}
> > > >  
> > > > -	bp->b_bn = map[0].bm_bn;
> > > > +	bp->b_index = map[0].bm_bn;
> > > >  	bp->b_length = 0;
> > > >  	for (i = 0; i < nmaps; i++) {
> > > >  		bp->b_maps[i].bm_bn = map[i].bm_bn;
> > > > @@ -459,7 +459,7 @@ _xfs_buf_obj_cmp(
> > > >  	 */
> > > >  	BUILD_BUG_ON(offsetof(struct xfs_buf_map, bm_bn) != 0);
> > > >  
> > > > -	if (bp->b_bn != map->bm_bn)
> > > > +	if (bp->b_index != map->bm_bn)
> > > >  		return 1;
> > > >  
> > > >  	if (unlikely(bp->b_length != map->bm_len)) {
> > > > @@ -481,7 +481,7 @@ static const struct rhashtable_params xfs_buf_hash_params = {
> > > >  	.min_size		= 32,	/* empty AGs have minimal footprint */
> > > >  	.nelem_hint		= 16,
> > > >  	.key_len		= sizeof(xfs_daddr_t),
> > > > -	.key_offset		= offsetof(struct xfs_buf, b_bn),
> > > > +	.key_offset		= offsetof(struct xfs_buf, b_index),
> > > 
> > > I would've called this field b_rhash_key, since "index" is a kind of
> > > vague.
> > 
> > Ok.
> > 
> > > > @@ -875,7 +877,7 @@ xfs_buf_read_uncached(
> > > >  
> > > >  	/* set up the buffer for a read IO */
> > > >  	ASSERT(bp->b_map_count == 1);
> > > > -	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
> > > > +	bp->b_index = XFS_BUF_DADDR_NULL;
> > > >  	bp->b_maps[0].bm_bn = daddr;
> > > >  	bp->b_flags |= XBF_READ;
> > > >  	bp->b_ops = ops;
> > > > @@ -1513,7 +1515,7 @@ _xfs_buf_ioapply(
> > > >  						   SHUTDOWN_CORRUPT_INCORE);
> > > >  				return;
> > > >  			}
> > > > -		} else if (bp->b_bn != XFS_BUF_DADDR_NULL) {
> > > > +		} else if (bp->b_index != XFS_BUF_DADDR_NULL) {
> > > >  			struct xfs_mount *mp = bp->b_mount;
> > > >  
> > > >  			/*
> > > > @@ -1523,7 +1525,8 @@ _xfs_buf_ioapply(
> > > >  			if (xfs_has_crc(mp)) {
> > > >  				xfs_warn(mp,
> > > >  					"%s: no buf ops on daddr 0x%llx len %d",
> > > > -					__func__, bp->b_bn, bp->b_length);
> > > > +					__func__, xfs_buf_daddr(bp),
> > > > +					bp->b_length);
> > > >  				xfs_hex_dump(bp->b_addr,
> > > >  						XFS_CORRUPTION_DUMP_LEN);
> > > >  				dump_stack();
> > > > @@ -1793,7 +1796,7 @@ xfs_buftarg_drain(
> > > >  				xfs_buf_alert_ratelimited(bp,
> > > >  					"XFS: Corruption Alert",
> > > >  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> > > > -					(long long)bp->b_bn);
> > > > +					(long long)xfs_buf_daddr(bp));
> > > 
> > > These belong in the previous patch, right?
> > 
> > Depends on your POV. This patch cleans up all the internal (mis)uses of
> > b_bn, while the previous patches addressed all the external uses.
> > The mods could be in either, I just chose to split internal/external
> > modification based on the file rather than on the specific (ab)use
> > being corrected....
> 
> <nod> Ok then.  Would you mind noting that in the commit message with
> something along the lines of "...and convert internal users."?  My brain
> is likely to fall out before you repost this patch. :/

Already done. The previous patch already said "Stop directly
referencing b_bn in code outside the buffer cache, [...]", this one
now says "Do the rename and clean up any of the remaining internal
b_bn users. [...]".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
