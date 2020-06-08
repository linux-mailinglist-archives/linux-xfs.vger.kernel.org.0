Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF61F1D60
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jun 2020 18:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgFHQcb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Jun 2020 12:32:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730333AbgFHQca (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 12:32:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058GD9ux043832;
        Mon, 8 Jun 2020 16:32:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xfpVIj+ZLbzHv1g5HYxxJvmZAn1ogP1VJq+iw5Npo1Y=;
 b=SUQub8pbOrG0r6C6BH5RF+grtK1nSR6HyNw+8s9FEqnrmufoTEurxMDIt2IbpXkdFfz4
 9zmoUiRc6fHlLNxsP3laq32O5hfsXsG/prQNQabGu/ngXSlFFXerbu5FVHr8UGM8KMEq
 45vlQHANlF0n657xE9Kmq5xas5lEquoHwREBIaC6Ykn0/BNbp1lEq9/Mv9rKDBHGBFzG
 WtBD3Mh1r3DSZkDiNYsKbGSJb6MrLXRTgEJsstL45arcarYDQDWt/eduivL0ZlEfH5JK
 PAH523udXevcoQ4d5eSfoyknq/32vYnkC1N7bfXtwFqbWaxQTLlZjdJ/gK2hjiVFVxpa mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31g33kyttt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 16:32:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058GCaT4166263;
        Mon, 8 Jun 2020 16:32:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31gn238ymk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 16:32:21 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 058GWJv9014302;
        Mon, 8 Jun 2020 16:32:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 09:32:19 -0700
Date:   Mon, 8 Jun 2020 09:32:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 2/7] xfs: Check for per-inode extent count overflow
Message-ID: <20200608163216.GD1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-3-chandanrlinux@gmail.com>
 <20200608162425.GC1334206@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608162425.GC1334206@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 08, 2020 at 09:24:25AM -0700, Darrick J. Wong wrote:
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
> 
> > +	if ((delta > 0 && nr_exts > max_exts)
> > +		|| (delta < 0 && nr_exts < 0))
> 
> Line these up, please.  e.g.,
> 
> 	if ((delta > 0 && nr_exts > max_exts) ||
>             (delta < 0 && nr_exts < 0))
> 
> --D
> 
> > +		return -EOVERFLOW;

Oh, also, shouldn't this be EFBIG ("File too big")?

--D

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
> > -- 
> > 2.20.1
> > 
