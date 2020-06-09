Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599D41F3E08
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jun 2020 16:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgFIOYi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jun 2020 10:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730004AbgFIOYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 10:24:36 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CCAC05BD1E
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2020 07:24:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b5so10140529pfp.9
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 07:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GBPl/h7Xsu1UEdFrePv51K8PBAJjBv4tQpNh7BiZ50Q=;
        b=Jrm7XNIQJdPTiG3D1numY0vQ/MjQXoJlAGPi/LnqOipsH1gQpVg+0+QMRmHTSHt4JF
         BYX+JMb5lZon/c+qAqovQW4qBCW1Q+vSTV3664ENHBMonGnLfap4HaOijHePFqapUBs6
         CiZo+tbUO1hQ1Qt4NmSh2Dt0byhtu5JyPz/vacU0/BMYOq5nxdnzq9tD+UPWPh+at+C0
         vx9BuzFp9BX8KWlUj40067VQZeFisgsdgRlYp/GWnDD2ZQQuXXDPreiWGv0Y7NVZZKMJ
         Q/RtUIW6rz0s2pneqNxEt3HEKePts92POnFa7HsI4z3b45SYbZ0U+ryni0gFJddtXVFl
         FTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GBPl/h7Xsu1UEdFrePv51K8PBAJjBv4tQpNh7BiZ50Q=;
        b=tHX0ADW6KvkWVDNpManGKLU62GiwBG6/Yhf7cI2sjJxtNweXhFtXZADTX3vnclwpmZ
         cJ4iTwjx0qejfHvfHsTK7jFP83w06PgTfy3TH0RtqCDMGZnuYWYYykkh63wN1lUlt2tQ
         VBX+m1h4DsGZeSyIJ4wZmUPnYNB8sPp7bS+jo7tdSkS+HpMBZTWoD/4ql1gVgq7bFgjU
         GL8R9Znu3XNLYD8oiCp7B+Q8cKSMXdVqd12zvYKW8jMtVELTEo1Bo+OX+YKh1Lu79x/P
         TCbZ3C5r/0Nso1+7vf10n+RUS/Yw03SWPSycLKfRET+ly9KZB9ek54gAlMxKH8dF/C7Z
         JeFA==
X-Gm-Message-State: AOAM530CTk+Z6+Ph4pafgBvbo4tuqG1vQ+cjDm/e2BEh4cz1UtUONbpk
        xKIPucnekj9crHbhoWUXw6U=
X-Google-Smtp-Source: ABdhPJwxAsDQg7GQlhga+lPc/m3nNPpQejqKcKbV71emijMy+b7S0mToXI+BiBfjXgdQD3a441CZEw==
X-Received: by 2002:a63:e652:: with SMTP id p18mr25293160pgj.421.1591712674774;
        Tue, 09 Jun 2020 07:24:34 -0700 (PDT)
Received: from garuda.localnet ([171.48.18.33])
        by smtp.gmail.com with ESMTPSA id u35sm8768931pgm.48.2020.06.09.07.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:24:34 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 2/7] xfs: Check for per-inode extent count overflow
Date:   Tue, 09 Jun 2020 19:52:37 +0530
Message-ID: <1885585.BIgNe5D0sC@garuda>
In-Reply-To: <20200608162425.GC1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <20200606082745.15174-3-chandanrlinux@gmail.com> <20200608162425.GC1334206@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 8 June 2020 9:54:25 PM IST Darrick J. Wong wrote:
> On Sat, Jun 06, 2020 at 01:57:40PM +0530, Chandan Babu R wrote:
> > The following error message was noticed when a workload added one
> > million xattrs, deleted 50% of them and then inserted 400,000 new
> > xattrs.
> > 
> > XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> > 
> > The error message was printed during unmounting the filesystem. The
> > value printed under "total extents" indicates that we overflowed the
> > per-inode signed 16-bit xattr extent counter.
> > 
> > Instead of letting this silent corruption occur, this patch checks for
> > extent counter (both data and xattr) overflow before we assign the
> > new value to the corresponding in-memory extent counter.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       | 92 +++++++++++++++++++++++++++-------
> >  fs/xfs/libxfs/xfs_inode_fork.c | 29 +++++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h |  1 +
> >  3 files changed, 104 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index edc63dba007f..798fca5c52af 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -906,7 +906,10 @@ xfs_bmap_local_to_extents(
> >  	xfs_iext_first(ifp, &icur);
> >  	xfs_iext_insert(ip, &icur, &rec, 0);
> >  
> > -	ifp->if_nextents = 1;
> > +	error = xfs_next_set(ip, whichfork, 1);
> > +	if (error)
> > +		goto done;
> 
> Are you sure that if_nextents == 0 is a precondition here?  Technically
> speaking, this turns an assignment into an increment operation.

Hmm. I didn't pay attention to that. I will check and update the code
appropriately. Thanks for pointing this out.

> 
> > +
> >  	ip->i_d.di_nblocks = 1;
> >  	xfs_trans_mod_dquot_byino(tp, ip,
> >  		XFS_TRANS_DQ_BCOUNT, 1L);
> > @@ -1594,7 +1597,10 @@ xfs_bmap_add_extent_delay_real(
> >  		xfs_iext_remove(bma->ip, &bma->icur, state);
> >  		xfs_iext_prev(ifp, &bma->icur);
> >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
> > -		ifp->if_nextents--;
> > +
> > +		error = xfs_next_set(bma->ip, whichfork, -1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (bma->cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > @@ -1698,7 +1704,10 @@ xfs_bmap_add_extent_delay_real(
> >  		PREV.br_startblock = new->br_startblock;
> >  		PREV.br_state = new->br_state;
> >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
> > -		ifp->if_nextents++;
> > +
> > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (bma->cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > @@ -1764,7 +1773,10 @@ xfs_bmap_add_extent_delay_real(
> >  		 * The left neighbor is not contiguous.
> >  		 */
> >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
> > -		ifp->if_nextents++;
> > +
> > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (bma->cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > @@ -1851,7 +1863,10 @@ xfs_bmap_add_extent_delay_real(
> >  		 * The right neighbor is not contiguous.
> >  		 */
> >  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
> > -		ifp->if_nextents++;
> > +
> > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (bma->cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > @@ -1937,7 +1952,10 @@ xfs_bmap_add_extent_delay_real(
> >  		xfs_iext_next(ifp, &bma->icur);
> >  		xfs_iext_insert(bma->ip, &bma->icur, &RIGHT, state);
> >  		xfs_iext_insert(bma->ip, &bma->icur, &LEFT, state);
> > -		ifp->if_nextents++;
> > +
> > +		error = xfs_next_set(bma->ip, whichfork, 1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (bma->cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > @@ -2141,7 +2159,11 @@ xfs_bmap_add_extent_unwritten_real(
> >  		xfs_iext_remove(ip, icur, state);
> >  		xfs_iext_prev(ifp, icur);
> >  		xfs_iext_update_extent(ip, state, icur, &LEFT);
> > -		ifp->if_nextents -= 2;
> > +
> > +		error = xfs_next_set(ip, whichfork, -2);
> > +		if (error)
> > +			goto done;
> > +
> >  		if (cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> >  		else {
> > @@ -2193,7 +2215,11 @@ xfs_bmap_add_extent_unwritten_real(
> >  		xfs_iext_remove(ip, icur, state);
> >  		xfs_iext_prev(ifp, icur);
> >  		xfs_iext_update_extent(ip, state, icur, &LEFT);
> > -		ifp->if_nextents--;
> > +
> > +		error = xfs_next_set(ip, whichfork, -1);
> > +		if (error)
> > +			goto done;
> > +
> >  		if (cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> >  		else {
> > @@ -2235,7 +2261,10 @@ xfs_bmap_add_extent_unwritten_real(
> >  		xfs_iext_remove(ip, icur, state);
> >  		xfs_iext_prev(ifp, icur);
> >  		xfs_iext_update_extent(ip, state, icur, &PREV);
> > -		ifp->if_nextents--;
> > +
> > +		error = xfs_next_set(ip, whichfork, -1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > @@ -2343,7 +2372,10 @@ xfs_bmap_add_extent_unwritten_real(
> >  
> >  		xfs_iext_update_extent(ip, state, icur, &PREV);
> >  		xfs_iext_insert(ip, icur, new, state);
> > -		ifp->if_nextents++;
> > +
> > +		error = xfs_next_set(ip, whichfork, 1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > @@ -2419,7 +2451,10 @@ xfs_bmap_add_extent_unwritten_real(
> >  		xfs_iext_update_extent(ip, state, icur, &PREV);
> >  		xfs_iext_next(ifp, icur);
> >  		xfs_iext_insert(ip, icur, new, state);
> > -		ifp->if_nextents++;
> > +
> > +		error = xfs_next_set(ip, whichfork, 1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > @@ -2471,7 +2506,10 @@ xfs_bmap_add_extent_unwritten_real(
> >  		xfs_iext_next(ifp, icur);
> >  		xfs_iext_insert(ip, icur, &r[1], state);
> >  		xfs_iext_insert(ip, icur, &r[0], state);
> > -		ifp->if_nextents += 2;
> > +
> > +		error = xfs_next_set(ip, whichfork, 2);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (cur == NULL)
> >  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> > @@ -2787,7 +2825,10 @@ xfs_bmap_add_extent_hole_real(
> >  		xfs_iext_remove(ip, icur, state);
> >  		xfs_iext_prev(ifp, icur);
> >  		xfs_iext_update_extent(ip, state, icur, &left);
> > -		ifp->if_nextents--;
> > +
> > +		error = xfs_next_set(ip, whichfork, -1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (cur == NULL) {
> >  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
> > @@ -2886,7 +2927,10 @@ xfs_bmap_add_extent_hole_real(
> >  		 * Insert a new entry.
> >  		 */
> >  		xfs_iext_insert(ip, icur, new, state);
> > -		ifp->if_nextents++;
> > +
> > +		error = xfs_next_set(ip, whichfork, 1);
> > +		if (error)
> > +			goto done;
> >  
> >  		if (cur == NULL) {
> >  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
> > @@ -5083,7 +5127,10 @@ xfs_bmap_del_extent_real(
> >  		 */
> >  		xfs_iext_remove(ip, icur, state);
> >  		xfs_iext_prev(ifp, icur);
> > -		ifp->if_nextents--;
> > +
> > +		error = xfs_next_set(ip, whichfork, -1);
> > +		if (error)
> > +			goto done;
> >  
> >  		flags |= XFS_ILOG_CORE;
> >  		if (!cur) {
> > @@ -5193,7 +5240,10 @@ xfs_bmap_del_extent_real(
> >  		} else
> >  			flags |= xfs_ilog_fext(whichfork);
> >  
> > -		ifp->if_nextents++;
> > +		error = xfs_next_set(ip, whichfork, 1);
> > +		if (error)
> > +			goto done;
> > +
> >  		xfs_iext_next(ifp, icur);
> >  		xfs_iext_insert(ip, icur, &new, state);
> >  		break;
> > @@ -5660,7 +5710,10 @@ xfs_bmse_merge(
> >  	 * Update the on-disk extent count, the btree if necessary and log the
> >  	 * inode.
> >  	 */
> > -	ifp->if_nextents--;
> > +	error = xfs_next_set(ip, whichfork, -1);
> > +	if (error)
> > +		goto done;
> > +
> >  	*logflags |= XFS_ILOG_CORE;
> >  	if (!cur) {
> >  		*logflags |= XFS_ILOG_DEXT;
> > @@ -6047,7 +6100,10 @@ xfs_bmap_split_extent(
> >  	/* Add new extent */
> >  	xfs_iext_next(ifp, &icur);
> >  	xfs_iext_insert(ip, &icur, &new, 0);
> > -	ifp->if_nextents++;
> > +
> > +	error = xfs_next_set(ip, whichfork, 1);
> > +	if (error)
> > +		goto del_cursor;
> >  
> >  	if (cur) {
> >  		error = xfs_bmbt_lookup_eq(cur, &new, &i);
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 28b366275ae0..3bf5a2c391bd 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -728,3 +728,32 @@ xfs_ifork_verify_local_attr(
> >  
> >  	return 0;
> >  }
> > +
> > +int
> > +xfs_next_set(
> 
> "next"... please choose an abbreviation that doesn't collide with a
> common English word.
> 
> > +	struct xfs_inode	*ip,
> > +	int			whichfork,
> > +	int			delta)
> 
> Delta?  I thought this was a setter function?
> 
> > +{
> > +	struct xfs_ifork	*ifp;
> > +	int64_t			nr_exts;
> > +	int64_t			max_exts;
> > +
> > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> > +
> > +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> > +		max_exts = MAXEXTNUM;
> > +	else if (whichfork == XFS_ATTR_FORK)
> > +		max_exts = MAXAEXTNUM;
> > +	else
> > +		ASSERT(0);
> > +
> > +	nr_exts = ifp->if_nextents + delta;
> 
> Nope, it's a modify function all right.  Then it should be named:
> 
> xfs_nextents_mod(ip, whichfork, delta)

Ok. I will change this.

> 
> > +	if ((delta > 0 && nr_exts > max_exts)
> > +		|| (delta < 0 && nr_exts < 0))
> 
> Line these up, please.  e.g.,
> 
> 	if ((delta > 0 && nr_exts > max_exts) ||
>             (delta < 0 && nr_exts < 0))

Ok.

> 
> --D
> 
> > +		return -EOVERFLOW;
> > +
> > +	ifp->if_nextents = nr_exts;
> > +
> > +	return 0;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index a4953e95c4f3..a84ae42ace79 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -173,4 +173,5 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
> >  int xfs_ifork_verify_local_data(struct xfs_inode *ip);
> >  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
> >  
> > +int xfs_next_set(struct xfs_inode *ip, int whichfork, int delta);
> >  #endif	/* __XFS_INODE_FORK_H__ */
> 


-- 
chandan



