Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177AEB3EC1
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Sep 2019 18:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbfIPQUW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Sep 2019 12:20:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33972 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfIPQUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 12:20:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GGE1pU169491;
        Mon, 16 Sep 2019 16:20:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Nh/9l+YmSEU3LUJSFluHYqaD7iY4bn9+Er/8PRho8t8=;
 b=lISf1uCHgkHWuESLruel1nauHxv/qlrbomGIWA5HYUXcb6izev0o0xrNjdnQoP9fDJdR
 8Zj8wpnGbzDfsczcrRzyX/7cLB3g3ItfUg9UOS/YvrcpnaCdhRt0RksU6t72RedQLRmj
 mDAC5caNyVA/GDLSgFIsG9PFxPwRLvyq95VXovWB/74e/4TVn4yhAaL+Cz6FdD3wJY89
 bD+iu5oXs4FXuvvw9JixAcgxNvL8QXT87FOzFZ6XeDaEw3SJyhgBGvrpzmbaNkQjYl9g
 4kERE7trw8oj0b7xD3KaAvMl0m8L1g/E2DuAicOort8iwCrshvtIK/N93GSmIH64wZAl Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v2bx2runa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 16:20:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GGCq3b124593;
        Mon, 16 Sep 2019 16:20:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v0r1gqqd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 16:20:07 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8GGK6uA021513;
        Mon, 16 Sep 2019 16:20:06 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 09:20:06 -0700
Date:   Mon, 16 Sep 2019 09:20:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH] [RFC] xfs: fix inode fork extent count overflow
Message-ID: <20190916162005.GX2229799@magnolia>
References: <20190911012107.26553-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911012107.26553-1-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 11, 2019 at 11:21:07AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> [commit message is verbose for discussion purposes - will trim it
> down later. Some questions about implementation details at the end.]
> 
> Zorro Lang recently ran a new test to stress single inode extent
> counts now that they are no longer limited by memory allocation.
> The test was simply:
> 
> # xfs_io -f -c "falloc 0 40t" /mnt/scratch/big-file
> # ~/src/xfstests-dev/punch-alternating /mnt/scratch/big-file
> 
> This test uncovered a problem where the hole punching operation
> appeared to finish with no error, but apparently only created 268M
> extents instead of the 10 billion it was supposed to.
> 
> Further, trying to punch out extents that should have been present
> resulted in success, but no change in the extent count. It looked
> like a silent failure.
> 
> While running the test and observing the behaviour in real time,
> I observed the extent coutn growing at ~2M extents/minute, and saw
> this after about an hour:
> 
> # xfs_io -f -c "stat" /mnt/scratch/big-file |grep next ; \
> > sleep 60 ; \
> > xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
> fsxattr.nextents = 127657993
> fsxattr.nextents = 129683339
> #
> 
> And a few minutes later this:
> 
> # xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
> fsxattr.nextents = 4177861124
> #
> 
> Ah, what? Where did that 4 billion extra extents suddenly come from?
> 
> Stop the workload, unmount, mount:
> 
> # xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
> fsxattr.nextents = 166044375
> #
> 
> And it's back at the expected number. i.e. the extent count is
> correct on disk, but it's screwed up in memory. I loaded up the
> extent list, and immediately:
> 
> # xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
> fsxattr.nextents = 4192576215
> #
> 
> It's bad again. So, where does that number come from?
> xfs_fill_fsxattr():
> 
>                 if (ip->i_df.if_flags & XFS_IFEXTENTS)
>                         fa->fsx_nextents = xfs_iext_count(&ip->i_df);
>                 else
>                         fa->fsx_nextents = ip->i_d.di_nextents;
> 
> And that's the behaviour I just saw in a nutshell. The on disk count
> is correct, but once the tree is loaded into memory, it goes whacky.
> Clearly there's something wrong with xfs_iext_count():
> 
> inline xfs_extnum_t xfs_iext_count(struct xfs_ifork *ifp)
> {
>         return ifp->if_bytes / sizeof(struct xfs_iext_rec);
> }
> 
> Simple enough, but 134M extents is 2**27, and that's right about

On the plus side, 2^27 is way better than the last time anyone tried to
create an egregious number of extents.

> where things went wrong. A struct xfs_iext_rec is 16 bytes in size,
> which means 2**27 * 2**4 = 2**31 and we're right on target for an
> integer overflow. And, sure enough:
> 
> struct xfs_ifork {
>         int                     if_bytes;       /* bytes in if_u1 */
> ....
> 
> Once we get 2**27 extents in a file, we overflow if_bytes and the
> in-core extent count goes wrong. And when we reach 2**28 extents,
> if_bytes wraps back to zero and things really start to go wrong
> there. This is where the silent failure comes from - only the first
> 2**28 extents can be looked up directly due to the overflow, all the
> extents above this index wrap back to somewhere in the first 2**28
> extents. Hence with a regular pattern, trying to punch a hole in the
> range that didn't have holes mapped to a hole in the first 2**28
> extents and so "succeeded" without changing anything. Hence "silent
> failure"...
> 
> Fix this by converting if_bytes to a int64_t and converting all the
> index variables and size calculations to use int64_t types to avoid
> overflows in future. Signed integers are still used to enable easy
> detection of extent count underflows. This enables scalability of
> extent counts to the limits of the on-disk format - MAXEXTNUM
> (2**31) extents.
> 
> Current testing is at over 500M extents and still going:
> 
> fsxattr.nextents = 517310478
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks reasonable to me; did Zorro retest w/ this patch?

If so,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  | 18 ++++++++++--------
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  2 +-
>  fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
>  fs/xfs/libxfs/xfs_inode_fork.h | 14 ++++++++------
>  5 files changed, 24 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b9f019603d0b..0bfb1ba919e2 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -453,13 +453,15 @@ xfs_attr_copy_value(
>   * special case for dev/uuid inodes, they have fixed size data forks.
>   */
>  int
> -xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
> +xfs_attr_shortform_bytesfit(
> +	struct xfs_inode	*dp,
> +	int			bytes)
>  {
> -	int offset;
> -	int minforkoff;	/* lower limit on valid forkoff locations */
> -	int maxforkoff;	/* upper limit on valid forkoff locations */
> -	int dsize;
> -	xfs_mount_t *mp = dp->i_mount;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	int64_t			dsize;
> +	int			minforkoff;
> +	int			maxforkoff;
> +	int			offset;
>  
>  	/* rounded down */
>  	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
> @@ -525,7 +527,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
>  	 * A data fork btree root must have space for at least
>  	 * MINDBTPTRS key/ptr pairs if the data fork is small or empty.
>  	 */
> -	minforkoff = max(dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
> +	minforkoff = max_t(int64_t, dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
>  	minforkoff = roundup(minforkoff, 8) >> 3;
>  
>  	/* attr fork btree root can have at least this many key/ptr pairs */
> @@ -939,7 +941,7 @@ xfs_attr_shortform_verify(
>  	char				*endp;
>  	struct xfs_ifork		*ifp;
>  	int				i;
> -	int				size;
> +	int64_t				size;
>  
>  	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
>  	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 85f14fc2a8da..ae16ca7c422a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -628,7 +628,7 @@ xfs_dir2_sf_verify(
>  	int				i;
>  	int				i8count;
>  	int				offset;
> -	int				size;
> +	int64_t				size;
>  	int				error;
>  	uint8_t				filetype;
>  
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index 7bc87408f1a0..52451809c478 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -596,7 +596,7 @@ xfs_iext_realloc_root(
>  	struct xfs_ifork	*ifp,
>  	struct xfs_iext_cursor	*cur)
>  {
> -	size_t new_size = ifp->if_bytes + sizeof(struct xfs_iext_rec);
> +	int64_t new_size = ifp->if_bytes + sizeof(struct xfs_iext_rec);
>  	void *new;
>  
>  	/* account for the prev/next pointers */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index c643beeb5a24..8fdd0424070e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -129,7 +129,7 @@ xfs_init_local_fork(
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	const void		*data,
> -	int			size)
> +	int64_t			size)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	int			mem_size = size, real_size = 0;
> @@ -467,11 +467,11 @@ xfs_iroot_realloc(
>  void
>  xfs_idata_realloc(
>  	struct xfs_inode	*ip,
> -	int			byte_diff,
> +	int64_t			byte_diff,
>  	int			whichfork)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> -	int			new_size = (int)ifp->if_bytes + byte_diff;
> +	int64_t			new_size = ifp->if_bytes + byte_diff;
>  
>  	ASSERT(new_size >= 0);
>  	ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));
> @@ -552,7 +552,7 @@ xfs_iextents_copy(
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_irec	rec;
> -	int			copied = 0;
> +	int64_t			copied = 0;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  	ASSERT(ifp->if_bytes > 0);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 00c62ce170d0..7b845c052fb4 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -13,16 +13,16 @@ struct xfs_dinode;
>   * File incore extent information, present for each of data & attr forks.
>   */
>  struct xfs_ifork {
> -	int			if_bytes;	/* bytes in if_u1 */
> -	unsigned int		if_seq;		/* fork mod counter */
> +	int64_t			if_bytes;	/* bytes in if_u1 */
>  	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
> -	short			if_broot_bytes;	/* bytes allocated for root */
> -	unsigned char		if_flags;	/* per-fork flags */
> +	unsigned int		if_seq;		/* fork mod counter */
>  	int			if_height;	/* height of the extent tree */
>  	union {
>  		void		*if_root;	/* extent tree root */
>  		char		*if_data;	/* inline file data */
>  	} if_u1;
> +	short			if_broot_bytes;	/* bytes allocated for root */
> +	unsigned char		if_flags;	/* per-fork flags */
>  };
>  
>  /*
> @@ -93,12 +93,14 @@ int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
>  void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
>  				struct xfs_inode_log_item *, int);
>  void		xfs_idestroy_fork(struct xfs_inode *, int);
> -void		xfs_idata_realloc(struct xfs_inode *, int, int);
> +void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
> +				int whichfork);
>  void		xfs_iroot_realloc(struct xfs_inode *, int, int);
>  int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
>  int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
>  				  int);
> -void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int);
> +void		xfs_init_local_fork(struct xfs_inode *ip, int whichfork,
> +				const void *data, int64_t size);
>  
>  xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
>  void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
> -- 
> 2.23.0.rc1
> 
