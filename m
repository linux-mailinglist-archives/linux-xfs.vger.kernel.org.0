Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA6A1E423F
	for <lists+linux-xfs@lfdr.de>; Wed, 27 May 2020 14:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgE0M17 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 27 May 2020 08:27:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37801 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725872AbgE0M17 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 08:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590582476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3XSfDQaAQqvJdt5ie0hSFg1Sq0I2YQ6UBhiDndc4MS4=;
        b=KM/Eo2g7XwqTtDIK0r6j01jyA4M+t2aoYnY9KosoqltWnGnroKdHi6QcPOuUvyhqtGDtz4
        e+lnYUMHd81s/aQ+xARR/Wqq8BhHgxS7b78wf0WiouPQLkLUUTwOLUhYVXJzK2Jw3bqX5J
        4/BDgEn01QOhiLVUG21kkUVsYL41lBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-u2GRwJpZOoqgSprJctOmMw-1; Wed, 27 May 2020 08:27:55 -0400
X-MC-Unique: u2GRwJpZOoqgSprJctOmMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15FCB100CCDE;
        Wed, 27 May 2020 12:27:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C58875C1B0;
        Wed, 27 May 2020 12:27:53 +0000 (UTC)
Date:   Wed, 27 May 2020 08:27:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: transfer freed blocks to blk res when lazy
 accounting
Message-ID: <20200527122752.GD12014@bfoster>
References: <20200522171828.53440-1-bfoster@redhat.com>
 <20200523013614.GE8230@magnolia>
 <20200526181629.GE5462@bfoster>
 <20200526211154.GI252930@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526211154.GI252930@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 02:11:54PM -0700, Darrick J. Wong wrote:
> On Tue, May 26, 2020 at 02:16:29PM -0400, Brian Foster wrote:
> > On Fri, May 22, 2020 at 06:36:14PM -0700, Darrick J. Wong wrote:
> > > On Fri, May 22, 2020 at 01:18:28PM -0400, Brian Foster wrote:
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > Darrick mentioned on IRC a few days ago that he'd seen an issue that
> > > > looked similar to the problem with the rmapbt based extent swap
> > > > algorithm when the associated inodes happen to bounce between extent and
> > > > btree format. That problem caused repeated bmapbt block allocations and
> > > > frees that exhausted the transaction block reservation across the
> > > > sequence of transaction rolls. The workaround for that was to use an
> > > > oversized block reservation, but that is not a generic or efficient
> > > > solution.
> > > > 
> > > > I was originally playing around with some hacks to set an optional base
> > > > block reservation on the transaction that we would attempt to replenish
> > > > across transaction roll sequences as the block reservation depletes, but
> > > > eventually noticed that there isn't much difference between stuffing
> > > > block frees in the transaction reservation counter vs. the delta counter
> > > > when lazy sb accounting is enabled (which is required for v5 supers). As
> > > > such, the following patch seems to address the rmapbt issue in my
> > > > isolated tests.
> > > > 
> > > > I think one tradeoff with this logic is that chains of rolling/freeing
> > > > transactions would now aggregate freed space until the final transaction
> > > > commits vs. as transactions roll. It's not immediately clear to me how
> > > > much of an issue that is, but it sounds a bit dicey when considering
> > > > things like truncates of large files. This behavior could still be tied
> > > > to a transaction flag to restrict its use to situations like rmapbt
> > > > swapext, however. Anyways, this is mostly untested outside of the extent
> > > > swap use case so I wanted to throw this on the list as an RFC for now
> > > > and see if anybody has thoughts or other ideas.
> > > 
> > > Hmm, well, this /would/ fix the immediate problem of running out of
> > > block reservation, but I wonder if there are other weird subtleties.
> > > If we're nearly out of space and we're mounted with -odiscard and the
> > > disk is really slow at processing discard, can we encounter weird
> > > failure cases where we end up stuck waiting for the extent busy tree to
> > > say that one of our pingponged blocks is ok to use again?
> > > 
> > 
> > Yeah, I think something like that could happen. I don't think it should
> > be a failure scenario though as the busy extent list should involve a
> > log force and retry in the worst case. Either way, we could always
> > mitigate risk by making this an optional accounting mode for particular
> > (extent swap) transactions...
> 
> Hmmm... OTOH I wonder how many people really run fsr?  Even I don't...
> :)
> 
> > > In the meantime, I noticed that xfs/227 on a pmem fs (or possibly
> > > anything with synchronous writes?) and reflink+rmap enabled seemed to
> > > fail pretty consistently.  In a hastily done and incomprehensi{ve,ble}
> > > survey I noted that I couldn't make the disastrous pingpong happen if
> > > there were more than ~4 blocks in the bmapbt, so maybe this would help
> > > there.
> > > 
> > 
> > Do you mean with this patch or with current upstream? I don't see
> > xfs/227 failures on my current setups (this patch passed a weekend auto
> > test run), but I'll have to retry with something synchronous...
> 
> It happens semi-frequently with current upstream, and all the time with
> the atomic file swap series.
> 

I repeated on a box using ramdisk devices and still don't reproduce
after 30+ iters, FWIW. Perhaps it depends on pmem for some reason.

> > BTW, is xfs/227 related to the problem you had mentioned on IRC? I
> > wasn't quite sure what operation was involved with whatever error report
> > you had. xfs/227 looks like an xfs_fsr test, so I'd have thought the
> > upstream workaround would have addressed that.. (though I see some attr
> > ops in there as well so perhaps this is related to the attr fork..?).
> 
> It's related, but only in the sense that the "zomg hundreds of thousands
> of intents sitting around in memory" were a side effect of creating a
> test that creates two files with ~50000 extents and fsr'ing them.
> 

Ok, well I'm a little confused then... do we have a user report of a
block reservation exhaustion problem or is the primary issue the
occasional failure of xfs/227?

Brian

> --D
> 
> > Brian
> > 
> > > In unrelated news, I also tried fixing the log recovery defer ops chain
> > > transactions to absorb the unused block reservations that the
> > > xfs_*i_item_recover functions created, but that just made fdblocks be
> > > wrong.  But it didn't otherwise blow up! :P
> > > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > >  fs/xfs/xfs_bmap_util.c | 11 -----------
> > > >  fs/xfs/xfs_trans.c     |  4 ++++
> > > >  2 files changed, 4 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > > index f37f5cc4b19f..74b3bad6c414 100644
> > > > --- a/fs/xfs/xfs_bmap_util.c
> > > > +++ b/fs/xfs/xfs_bmap_util.c
> > > > @@ -1628,17 +1628,6 @@ xfs_swap_extents(
> > > >  		 */
> > > >  		resblks = XFS_SWAP_RMAP_SPACE_RES(mp, ipnext, w);
> > > >  		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
> > > > -
> > > > -		/*
> > > > -		 * Handle the corner case where either inode might straddle the
> > > > -		 * btree format boundary. If so, the inode could bounce between
> > > > -		 * btree <-> extent format on unmap -> remap cycles, freeing and
> > > > -		 * allocating a bmapbt block each time.
> > > > -		 */
> > > > -		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
> > > > -			resblks += XFS_IFORK_MAXEXT(ip, w);
> > > > -		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
> > > > -			resblks += XFS_IFORK_MAXEXT(tip, w);
> > > >  	}
> > > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> > > >  	if (error)
> > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > index 28b983ff8b11..b421d27445c1 100644
> > > > --- a/fs/xfs/xfs_trans.c
> > > > +++ b/fs/xfs/xfs_trans.c
> > > > @@ -370,6 +370,10 @@ xfs_trans_mod_sb(
> > > >  			tp->t_blk_res_used += (uint)-delta;
> > > >  			if (tp->t_blk_res_used > tp->t_blk_res)
> > > >  				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > > +		} else if (delta > 0 &&
> > > > +			   xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > > +			tp->t_blk_res += delta;
> > > > +			delta = 0;
> > > >  		}
> > > >  		tp->t_fdblocks_delta += delta;
> > > >  		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > > > -- 
> > > > 2.21.1
> > > > 
> > > 
> > 
> 

