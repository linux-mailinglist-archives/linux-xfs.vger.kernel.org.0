Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCEC4F8BBE
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Apr 2022 02:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiDHAIM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Apr 2022 20:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiDHAIL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 20:08:11 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C94D293E53
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 17:06:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9202B5345A5;
        Fri,  8 Apr 2022 10:06:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ncc8b-00F2fQ-0X; Fri, 08 Apr 2022 10:06:05 +1000
Date:   Fri, 8 Apr 2022 10:06:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: recalculate free rt extents after log recovery
Message-ID: <20220408000605.GN1544202@dread.disaster.area>
References: <164936441107.457511.6646449842358518774.stgit@magnolia>
 <164936441684.457511.12252243723468714698.stgit@magnolia>
 <20220407215605.GL1544202@dread.disaster.area>
 <20220407233941.GC27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407233941.GC27690@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=624f7c6e
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=3Zn-1nR0ibHp-PmG46sA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 04:39:41PM -0700, Darrick J. Wong wrote:
> On Fri, Apr 08, 2022 at 07:56:05AM +1000, Dave Chinner wrote:
> > On Thu, Apr 07, 2022 at 01:46:56PM -0700, Darrick J. Wong wrote:
> > > @@ -1284,6 +1285,43 @@ xfs_rtmount_init(
> > >  	return 0;
> > >  }
> > >  
> > > +static inline int
> > > +xfs_rtalloc_count_frextent(
> > > +	struct xfs_trans		*tp,
> > > +	const struct xfs_rtalloc_rec	*rec,
> > > +	void				*priv)
> > > +{
> > > +	uint64_t			*valp = priv;
> > > +
> > > +	*valp += rec->ar_extcount;
> > > +	return 0;
> > > +}
> > > +
> > > +/* Reinitialize the number of free realtime extents from the realtime bitmap. */
> > > +STATIC int
> > > +xfs_rtalloc_reinit_frextents(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	struct xfs_trans	*tp;
> > > +	uint64_t		val = 0;
> > > +	int			error;
> > > +
> > > +	error = xfs_trans_alloc_empty(mp, &tp);
> > > +	if (error)
> > > +		return error;
> > 
> > At this point in the mount, the transaction subsystem is not
> > really available for use. I understand that this is an empty
> > transaction and it doesn't reserve log space, but I don't like
> > creating an implicit requirement that xfs_trans_alloc_empty() never
> > touches log state for this code to work correctly into the future.
> 
> <nod> I'd wondered if it was really a good idea to be creating a
> transaction at the "end" of log recovery.  Recovery itself does it, but
> at least that's a carefully controlled box...
> 
> > That is, the log isn't in a state where we can run normal
> > transactions because we can still have pending intent recovery
> > queued in the AIL. These can't be moved from the tail of the AIL
> > until xfs_log_mount_finish() is called to remove and process them.
> > They are dependent on there being enough log space remaining for the
> > transaction reservation they make to succeed and there may only be
> > just enough space for the first intent to make that reservation.
> > Hence if we consume any log space before we recover intents, we can
> > deadlock on log space when then trying to recover the intents. And
> > because the AIL can't push on intents, the same reservation deadlock
> > could occur with any transaction reservation we try to run before
> > xfs_log_mount_finish() has been run.
> > 
> > Yes, I know this is an empty transaction and so it doesn't push on
> > the log or consume any space. But I think it's a bad precedent even
> > to use transactions at all when we know we are in the middle of log
> > recovery and the transaction subsystem is not open for general use
> > yet.  Hence I think using transaction handles - even empty ones -
> > before xfs_log_mount_finish() is run is a pattern we want to avoid
> > if at all possible.
> 
> ...yes...
> 
> > > +
> > > +	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
> > > +	error = xfs_rtalloc_query_all(tp, xfs_rtalloc_count_frextent, &val);
> > 
> > Looking at the code here, AFAICT the only thing the tp is absolutely
> > required for here is to hold the mount pointer - all the internal
> > bitmap walk operations grab and release buffers using interfaces
> > that can handle a null tp being passed.
> > 
> > Hence it looks to me like a transaction context isn't necessary for
> > this read-only bitmap walk. Is that correct?  Converting
> > xfs_rtalloc_query_all() to take a mount and a trans would also make
> > this code becomes a lot simpler....
> 
> ...and I was about to say "Yeah, we could make xfs_rtalloc_query_all
> take the mount and an optional transaction", but it occurred to me:
> 
> The rtalloc queries need to read the rtbitmap file's data fork mappings
> into memory to find the blocks.  If the rtbitmap is fragmented enough
> that the data fork is in btree format and the bmbt contains an upward
> cycle, loading the bmbt will livelock the mount attempt.

"upward cycle", as in a corrupted btree?

> Granted, xfs_bmapi_read doesn't take a transaction, so this means that
> we'd either have to change it to take one, or we'd have to change the
> rtmount code to create an empty transaction and call iread_extents to
> detect a bmbt cycle.


> So yeah, I think the answer to your question is "yes", but then there's
> this other issue... :(

Yup, but keep in mind that:

xfs_fs_reserve_ag_blocks(tp == NULL)
  xfs_ag_resv_init
    xfs_finobt_calc_reserves
      xfs_inobt_count_blocks
        xfs_btree_count_blocks

Will do a finobt btree walk without a transaction pointer if
we don't have finobt block counts recorded in the AGI. So it
seems to me that we are already at risk of cycles in corrupted
btrees being able to cause mount hangs.

Hence from that perspective, I think worrying about a corrupted
rtbitmap BMBT btree is largely outside the scope of this patchset;
it's a generic issue with transaction-less btree walks, and one we
are already exposed to in the same phase of the mount/log recovery
process. Hence I think we should consider how to solve this problem
seperately rather that tie this patchset into twisty knots trying to
deal with here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
