Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F63BB7D7F
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Sep 2019 17:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390839AbfISPEm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Sep 2019 11:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63204 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389382AbfISPEm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 11:04:42 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BE2053C919;
        Thu, 19 Sep 2019 15:04:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 548665C1B5;
        Thu, 19 Sep 2019 15:04:41 +0000 (UTC)
Date:   Thu, 19 Sep 2019 11:04:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 08/11] xfs: refactor and reuse best extent scanning
 logic
Message-ID: <20190919150439.GF35460@bfoster>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-9-bfoster@redhat.com>
 <20190918210320.GZ2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918210320.GZ2229799@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 19 Sep 2019 15:04:41 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 02:03:20PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 16, 2019 at 08:16:32AM -0400, Brian Foster wrote:
> > The bnobt "find best" helper implements a simple btree walker
> > function. This general pattern, or a subset thereof, is reused in
> > various parts of a near mode allocation operation. For example, the
> > bnobt left/right scans are each iterative btree walks along with the
> > cntbt lastblock scan.
> > 
> > Rework this function into a generic btree walker, add a couple
> > parameters to control termination behavior from various contexts and
> > reuse it where applicable.
> > 
> > XXX: This slightly changes the cntbt lastblock scan logic to scan
> > the entire block and use the best candidate as opposed to the
> > current logic of checking until we locate a perfect match. Fix up
> > cur_check() to terminate on perfect match.
> 
> Did that fix up happen in a previous patch?
> 

No, I think at one point I convinced myself to just drop this because it
didn't seem likely to find an exact extent via the cntbt and then forgot
to update the commit log. That said, I'll revisit this because as rare
as it might be, I think it might make sense to just deactivate the cntbt
cursor in the (acur->len == args->maxlen && acur->diff == 0) scenario
and let that terminate the search reasonably gracefully.

> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 103 ++++++++++++++++++--------------------
> >  1 file changed, 48 insertions(+), 55 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 3eacc799c4cb..ab494fd50dd7 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1172,30 +1172,38 @@ xfs_alloc_ag_vextent_exact(
> >  }
> >  
> >  /*
> > - * Search the btree in a given direction and check the records against the good
> > - * extent we've already found.
> > + * Search a given number of btree records in a given direction. Check each
> > + * record against the good extent we've already found.
> >   */
> >  STATIC int
> > -xfs_alloc_find_best_extent(
> > +xfs_alloc_walk_iter(
> >  	struct xfs_alloc_arg	*args,
> >  	struct xfs_alloc_cur	*acur,
> >  	struct xfs_btree_cur	*cur,
> > -	bool			increment)
> > +	bool			increment,
> > +	bool			find_one,/* quit on first candidate */
> 
> Space between the comma and the comment?
> 

Fixed and aligned both comments with spaces.

Brian

> --D
> 
> > +	int			count,	/* rec count (-1 for infinite) */
> > +	int			*stat)
> >  {
> >  	int			error;
> >  	int			i;
> >  
> > +	*stat = 0;
> > +
> >  	/*
> >  	 * Search so long as the cursor is active or we find a better extent.
> >  	 * The cursor is deactivated if it extends beyond the range of the
> >  	 * current allocation candidate.
> >  	 */
> > -	while (xfs_alloc_cur_active(cur)) {
> > +	while (xfs_alloc_cur_active(cur) && count) {
> >  		error = xfs_alloc_cur_check(args, acur, cur, &i);
> >  		if (error)
> >  			return error;
> > -		if (i == 1)
> > -			break;
> > +		if (i == 1) {
> > +			*stat = 1;
> > +			if (find_one)
> > +				break;
> > +		}
> >  		if (!xfs_alloc_cur_active(cur))
> >  			break;
> >  
> > @@ -1207,6 +1215,9 @@ xfs_alloc_find_best_extent(
> >  			return error;
> >  		if (i == 0)
> >  			cur->bc_private.a.priv.abt.active = false;
> > +
> > +		if (count > 0)
> > +			count--;
> >  	}
> >  
> >  	return 0;
> > @@ -1226,7 +1237,6 @@ xfs_alloc_ag_vextent_near(
> >  	struct xfs_btree_cur	*fbcur = NULL;
> >  	int		error;		/* error code */
> >  	int		i;		/* result code, temporary */
> > -	int		j;		/* result code, temporary */
> >  	xfs_agblock_t	bno;
> >  	xfs_extlen_t	len;
> >  	bool		fbinc = false;
> > @@ -1313,19 +1323,12 @@ xfs_alloc_ag_vextent_near(
> >  			if (!i)
> >  				break;
> >  		}
> > -		i = acur.cnt->bc_ptrs[0];
> > -		for (j = 1;
> > -		     !error && j && xfs_alloc_cur_active(acur.cnt) &&
> > -		     (acur.len < args->maxlen || acur.diff > 0);
> > -		     error = xfs_btree_increment(acur.cnt, 0, &j)) {
> > -			/*
> > -			 * For each entry, decide if it's better than
> > -			 * the previous best entry.
> > -			 */
> > -			error = xfs_alloc_cur_check(args, &acur, acur.cnt, &i);
> > -			if (error)
> > -				goto out;
> > -		}
> > +
> > +		error = xfs_alloc_walk_iter(args, &acur, acur.cnt, true, false,
> > +					    -1, &i);
> > +		if (error)
> > +			goto out;
> > +
> >  		/*
> >  		 * It didn't work.  We COULD be in a case where
> >  		 * there's a good record somewhere, so try again.
> > @@ -1357,49 +1360,39 @@ xfs_alloc_ag_vextent_near(
> >  		goto out;
> >  
> >  	/*
> > -	 * Loop going left with the leftward cursor, right with the
> > -	 * rightward cursor, until either both directions give up or
> > -	 * we find an entry at least as big as minlen.
> > +	 * Loop going left with the leftward cursor, right with the rightward
> > +	 * cursor, until either both directions give up or we find an entry at
> > +	 * least as big as minlen.
> >  	 */
> >  	do {
> > -		if (xfs_alloc_cur_active(acur.bnolt)) {
> > -			error = xfs_alloc_cur_check(args, &acur, acur.bnolt, &i);
> > -			if (error)
> > -				goto out;
> > -			if (i == 1) {
> > -				trace_xfs_alloc_cur_left(args);
> > -				fbcur = acur.bnogt;
> > -				fbinc = true;
> > -				break;
> > -			}
> > -			error = xfs_btree_decrement(acur.bnolt, 0, &i);
> > -			if (error)
> > -				goto out;
> > -			if (!i)
> > -				acur.bnolt->bc_private.a.priv.abt.active = false;
> > +		error = xfs_alloc_walk_iter(args, &acur, acur.bnolt, false,
> > +					    true, 1, &i);
> > +		if (error)
> > +			goto out;
> > +		if (i == 1) {
> > +			trace_xfs_alloc_cur_left(args);
> > +			fbcur = acur.bnogt;
> > +			fbinc = true;
> > +			break;
> >  		}
> > -		if (xfs_alloc_cur_active(acur.bnogt)) {
> > -			error = xfs_alloc_cur_check(args, &acur, acur.bnogt, &i);
> > -			if (error)
> > -				goto out;
> > -			if (i == 1) {
> > -				trace_xfs_alloc_cur_right(args);
> > -				fbcur = acur.bnolt;
> > -				fbinc = false;
> > -				break;
> > -			}
> > -			error = xfs_btree_increment(acur.bnogt, 0, &i);
> > -			if (error)
> > -				goto out;
> > -			if (!i)
> > -				acur.bnogt->bc_private.a.priv.abt.active = false;
> > +
> > +		error = xfs_alloc_walk_iter(args, &acur, acur.bnogt, true, true,
> > +					    1, &i);
> > +		if (error)
> > +			goto out;
> > +		if (i == 1) {
> > +			trace_xfs_alloc_cur_right(args);
> > +			fbcur = acur.bnolt;
> > +			fbinc = false;
> > +			break;
> >  		}
> >  	} while (xfs_alloc_cur_active(acur.bnolt) ||
> >  		 xfs_alloc_cur_active(acur.bnogt));
> >  
> >  	/* search the opposite direction for a better entry */
> >  	if (fbcur) {
> > -		error = xfs_alloc_find_best_extent(args, &acur, fbcur, fbinc);
> > +		error = xfs_alloc_walk_iter(args, &acur, fbcur, fbinc, true, -1,
> > +					    &i);
> >  		if (error)
> >  			goto out;
> >  	}
> > -- 
> > 2.20.1
> > 
