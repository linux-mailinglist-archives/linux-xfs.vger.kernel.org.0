Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCCD3D824C
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jul 2021 00:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhG0WKR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Jul 2021 18:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhG0WKR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 18:10:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC3F560F5E;
        Tue, 27 Jul 2021 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627423817;
        bh=xkNpNhUjFCmD0nTLvtzjiwdKwc/I0GwiD0I/4lG6cWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c6c824JQHEAAxXXeMF+P50PC6TKQpm9e0aU6hFikT0ZQTggCAtLXWktW7+oi3DOLr
         +H17MnfcjBqONpqcSYEBxDjR63A0+SqaqXrtgcHJFC1ostlVeMd6/tk8fjokrpGHWc
         MLhXIJah/Nkcav4dV6NB8U73tJamvJ9UCJ8BH4TLZkCuIGNvHh+TBeNy9P2sMY3Mwz
         mKaAVF1YErpcMu7Xdo/ncrfh8P8dHk693pDsvEnLaN865UwLjYJySJAbOKnRkDnS6L
         IU2DHVHCVLFFFBwtSVW6jdivwV08/s0oGGxkEnUWZTHA+TfMCN2mdarQr9pzTC/s0g
         bTeohpcRspwGw==
Date:   Tue, 27 Jul 2021 15:10:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 05/12] xfs: Introduce xfs_dfork_nextents() helper
Message-ID: <20210727221016.GO559212@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-6-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:34PM +0530, Chandan Babu R wrote:
> This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
> xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
> value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent

Yay fewer shouty macros!

> counter fields will add more logic to this helper.
> 
> This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
> with calls to xfs_dfork_nextents().
> 
> No functional changes have been made.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     |  4 ----
>  fs/xfs/libxfs/xfs_inode_buf.c  | 41 +++++++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_inode_buf.h  |  2 ++
>  fs/xfs/libxfs/xfs_inode_fork.c | 12 ++++++----
>  fs/xfs/scrub/inode.c           | 19 +++++++++-------
>  fs/xfs/scrub/inode_repair.c    | 38 +++++++++++++++++++------------
>  6 files changed, 81 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 920e3f9c418f..001a4077a7c6 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1166,10 +1166,6 @@ enum xfs_dinode_fmt {
>  	((w) == XFS_DATA_FORK ? \
>  		(dip)->di_format : \
>  		(dip)->di_aformat)
> -#define XFS_DFORK_NEXTENTS(dip,w) \
> -	((w) == XFS_DATA_FORK ? \
> -		be32_to_cpu((dip)->di_nextents) : \
> -		be16_to_cpu((dip)->di_anextents))
>  
>  /*
>   * For block and character special files the 32bit dev_t is stored at the
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index cba9a38f3270..6bef0757fca4 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -342,9 +342,11 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		di_nextents;
>  	xfs_extnum_t		max_extents;
>  
> +	di_nextents = xfs_dfork_nextents(mp, dip, whichfork);
> +
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		/*
> @@ -375,6 +377,31 @@ xfs_dinode_verify_fork(
>  	return NULL;
>  }
>  
> +xfs_extnum_t
> +xfs_dfork_nextents(
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	*dip,
> +	int			whichfork)
> +{
> +	xfs_extnum_t		nextents = 0;
> +
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +		nextents = be32_to_cpu(dip->di_nextents);
> +		break;
> +
> +	case XFS_ATTR_FORK:
> +		nextents = be16_to_cpu(dip->di_anextents);
> +		break;
> +
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
> +
> +	return nextents;
> +}

This could be a static inline function taking the place of
XFS_DFORK_NEXTENTS instead of another new function with a stack frame,
etc:

static inline xfs_extnum_t
xfs_dfork_nextents(
	struct xfs_mount	*mp,
	struct xfs_dinode	*dip,
	int			whichfork)
{
	switch (whichfork) {
	case XFS_DATA_FORK:
		return be32_to_cpu(dip->di_nextents);
	case XFS_ATTR_FORK:
		return be16_to_cpu(dip->di_anextents);
	default:
		ASSERT(0);
		return 0;
	}
}

> +
>  static xfs_failaddr_t
>  xfs_dinode_verify_forkoff(
>  	struct xfs_dinode	*dip,
> @@ -474,6 +501,8 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	xfs_extnum_t            nextents;
> +	int64_t			nblocks;

xfs_rfsblock_t, since that's the type we use for nblocks in xfs_inode.

>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
> @@ -504,10 +533,12 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> +	nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
> +	nextents += xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
> +	nblocks = be64_to_cpu(dip->di_nblocks);
> +
>  	/* Fork checks carried over from xfs_iformat_fork */
> -	if (mode &&
> -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> -			be64_to_cpu(dip->di_nblocks))
> +	if (mode && nextents > nblocks)
>  		return __this_address;
>  
>  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> @@ -564,7 +595,7 @@ xfs_dinode_verify(
>  		default:
>  			return __this_address;
>  		}
> -		if (dip->di_anextents)
> +		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
>  			return __this_address;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index a30b7676098a..ea2c35091609 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -36,6 +36,8 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
>  xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
>  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
>  		uint64_t flags2);
> +xfs_extnum_t xfs_dfork_nextents(struct xfs_mount *mp, struct xfs_dinode *dip,
> +		int whichfork);
>  
>  static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
>  {
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index a1e40df585a3..38dd2dfc31fa 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -107,7 +107,7 @@ xfs_iformat_extents(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		nex = xfs_dfork_nextents(mp, dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
> @@ -226,6 +226,7 @@ xfs_iformat_data_fork(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*dip)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
>  	int			error;
>  
> @@ -234,7 +235,7 @@ xfs_iformat_data_fork(
>  	 * depend on it.
>  	 */
>  	ip->i_df.if_format = dip->di_format;
> -	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> +	ip->i_df.if_nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -301,14 +302,17 @@ xfs_iformat_attr_fork(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*dip)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_extnum_t		nextents;

naextents for consistency?

>  	int			error = 0;
>  
> +	nextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
> +
>  	/*
>  	 * Initialize the extent count early, as the per-format routines may
>  	 * depend on it.
>  	 */
> -	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
> -				be16_to_cpu(dip->di_anextents));
> +	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, nextents);
>  
>  	switch (ip->i_afp->if_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 246d11ca133f..a161dac31a6f 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -220,6 +220,7 @@ xchk_dinode(
>  	unsigned long long	isize;
>  	uint64_t		flags2;
>  	xfs_extnum_t		nextents;
> +	xfs_extnum_t		naextents;
>  	prid_t			prid;
>  	uint16_t		flags;
>  	uint16_t		mode;
> @@ -378,7 +379,7 @@ xchk_dinode(
>  	xchk_inode_extsize(sc, dip, ino, mode, flags);
>  
>  	/* di_nextents */
> -	nextents = be32_to_cpu(dip->di_nextents);
> +	nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
>  	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
> @@ -395,10 +396,12 @@ xchk_dinode(
>  		break;
>  	}
>  
> +	naextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
> +
>  	/* di_forkoff */
>  	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
>  		xchk_ino_set_corrupt(sc, ino);
> -	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
> +	if (naextents != 0 && dip->di_forkoff == 0)
>  		xchk_ino_set_corrupt(sc, ino);
>  	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
>  		xchk_ino_set_corrupt(sc, ino);
> @@ -410,19 +413,18 @@ xchk_dinode(
>  		xchk_ino_set_corrupt(sc, ino);
>  
>  	/* di_anextents */
> -	nextents = be16_to_cpu(dip->di_anextents);
>  	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_aformat) {
>  	case XFS_DINODE_FMT_EXTENTS:
> -		if (nextents > fork_recs)
> +		if (naextents > fork_recs)
>  			xchk_ino_set_corrupt(sc, ino);
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		if (nextents <= fork_recs)
> +		if (naextents <= fork_recs)
>  			xchk_ino_set_corrupt(sc, ino);
>  		break;
>  	default:
> -		if (nextents != 0)
> +		if (naextents != 0)
>  			xchk_ino_set_corrupt(sc, ino);
>  	}
>  
> @@ -487,6 +489,7 @@ xchk_inode_xref_bmap(
>  	struct xfs_scrub	*sc,
>  	struct xfs_dinode	*dip)
>  {
> +	struct xfs_mount	*mp = sc->mp;
>  	xfs_extnum_t		nextents;
>  	xfs_filblks_t		count;
>  	xfs_filblks_t		acount;
> @@ -500,14 +503,14 @@ xchk_inode_xref_bmap(
>  			&nextents, &count);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents < be32_to_cpu(dip->di_nextents))
> +	if (nextents < xfs_dfork_nextents(mp, dip, XFS_DATA_FORK))
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
>  			&nextents, &acount);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents != be16_to_cpu(dip->di_anextents))
> +	if (nextents != xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	/* Check nblocks against the inode. */
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index 042c7d0bc0f5..bdb4685923c0 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c

Hey waitaminute, is this based off of djwong-dev??

> @@ -602,7 +602,7 @@ xrep_dinode_bad_extents_fork(
>  	int			i;
>  	int			fork_size;
>  
> -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	nex = xfs_dfork_nextents(sc->mp, dip, whichfork);
>  	fork_size = nex * sizeof(struct xfs_bmbt_rec);
>  	if (fork_size < 0 || fork_size > dfork_size)
>  		return true;
> @@ -636,7 +636,7 @@ xrep_dinode_bad_btree_fork(
>  	int			nrecs;
>  	int			level;
>  
> -	if (XFS_DFORK_NEXTENTS(dip, whichfork) <=
> +	if (xfs_dfork_nextents(sc->mp, dip, whichfork) <=
>  			dfork_size / sizeof(struct xfs_bmbt_rec))
>  		return true;
>  
> @@ -831,12 +831,16 @@ xrep_dinode_ensure_forkoff(
>  	struct xrep_dinode_stats	*dis)
>  {
>  	struct xfs_bmdr_block		*bmdr;
> +	xfs_extnum_t			anextents, dnextents;
>  	size_t				bmdr_minsz = xfs_bmdr_space_calc(1);
>  	unsigned int			lit_sz = XFS_LITINO(sc->mp);
>  	unsigned int			afork_min, dfork_min;
>  
>  	trace_xrep_dinode_ensure_forkoff(sc, dip);
>  
> +	dnextents = xfs_dfork_nextents(sc->mp, dip, XFS_DATA_FORK);
> +	anextents = xfs_dfork_nextents(sc->mp, dip, XFS_ATTR_FORK);
> +
>  	/*
>  	 * Before calling this function, xrep_dinode_core ensured that both
>  	 * forks actually fit inside their respective literal areas.  If this
> @@ -857,15 +861,14 @@ xrep_dinode_ensure_forkoff(
>  		afork_min = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
> -		if (dip->di_anextents) {
> +		if (anextents) {
>  			/*
>  			 * We must maintain sufficient space to hold the entire
>  			 * extent map array in the data fork.  Note that we
>  			 * previously zapped the fork if it had no chance of
>  			 * fitting in the inode.
>  			 */
> -			afork_min = sizeof(struct xfs_bmbt_rec) *
> -						be16_to_cpu(dip->di_anextents);
> +			afork_min = sizeof(struct xfs_bmbt_rec) * anextents;
>  		} else if (dis->attr_extents > 0) {
>  			/*
>  			 * The attr fork thinks it has zero extents, but we
> @@ -908,15 +911,14 @@ xrep_dinode_ensure_forkoff(
>  		dfork_min = be64_to_cpu(dip->di_size);
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
> -		if (dip->di_nextents) {
> +		if (dnextents) {
>  			/*
>  			 * We must maintain sufficient space to hold the entire
>  			 * extent map array in the data fork.  Note that we
>  			 * previously zapped the fork if it had no chance of
>  			 * fitting in the inode.
>  			 */
> -			dfork_min = sizeof(struct xfs_bmbt_rec) *
> -						be32_to_cpu(dip->di_nextents);
> +			dfork_min = sizeof(struct xfs_bmbt_rec) * dnextents;
>  		} else if (dis->data_extents > 0 || dis->rt_extents > 0) {
>  			/*
>  			 * The data fork thinks it has zero extents, but we
> @@ -956,7 +958,7 @@ xrep_dinode_ensure_forkoff(
>  	 * recovery fork, move the attr fork up.
>  	 */
>  	if (dip->di_format == XFS_DINODE_FMT_EXTENTS &&
> -	    dip->di_nextents == 0 &&
> +	    dnextents == 0 &&
>  	    (dis->data_extents > 0 || dis->rt_extents > 0) &&
>  	    bmdr_minsz > XFS_DFORK_DSIZE(dip, sc->mp)) {
>  		if (bmdr_minsz + afork_min > lit_sz) {
> @@ -982,7 +984,7 @@ xrep_dinode_ensure_forkoff(
>  	 * recovery fork, move the attr fork down.
>  	 */
>  	if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	    dip->di_anextents == 0 &&
> +	    anextents == 0 &&
>  	    dis->attr_extents > 0 &&
>  	    bmdr_minsz > XFS_DFORK_ASIZE(dip, sc->mp)) {
>  		if (dip->di_format == XFS_DINODE_FMT_BTREE) {
> @@ -1019,6 +1021,9 @@ xrep_dinode_zap_forks(
>  	struct xfs_dinode		*dip,
>  	struct xrep_dinode_stats	*dis)
>  {
> +	uint64_t			nblocks;

xfs_rfsblock_t.

--D

> +	xfs_extnum_t			nextents;
> +	xfs_extnum_t			naextents;
>  	uint16_t			mode;
>  	bool				zap_datafork = false;
>  	bool				zap_attrfork = false;
> @@ -1028,12 +1033,17 @@ xrep_dinode_zap_forks(
>  	mode = be16_to_cpu(dip->di_mode);
>  
>  	/* Inode counters don't make sense? */
> -	if (be32_to_cpu(dip->di_nextents) > be64_to_cpu(dip->di_nblocks))
> +	nblocks = be64_to_cpu(dip->di_nblocks);
> +
> +	nextents = xfs_dfork_nextents(sc->mp, dip, XFS_DATA_FORK);
> +	if (nextents > nblocks)
>  		zap_datafork = true;
> -	if (be16_to_cpu(dip->di_anextents) > be64_to_cpu(dip->di_nblocks))
> +
> +	naextents = xfs_dfork_nextents(sc->mp, dip, XFS_ATTR_FORK);
> +	if (naextents > nblocks)
>  		zap_attrfork = true;
> -	if (be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> -			be64_to_cpu(dip->di_nblocks))
> +
> +	if (nextents + naextents > nblocks)
>  		zap_datafork = zap_attrfork = true;
>  
>  	if (!zap_datafork)
> -- 
> 2.30.2
> 
