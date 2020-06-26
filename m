Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952C320B10D
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jun 2020 13:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgFZL6H (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Jun 2020 07:58:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60430 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726256AbgFZL6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jun 2020 07:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593172684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4PJNIyKkp4ot9R/4vrkzI2jXA5A7MoktTD37UXKlQ3M=;
        b=LrgSqa7qPmygjhiG10Hv/e26HzwQGCTTz+mYLuJUpvgaB8exCt1h4FkDUE5dZBhfDJHKjV
        q6zKQPhefnWH6EVkDuM5uuHgFQhx/fYBwezQo15MGtqk/7lmYzfkFrzOGsK60RGOhGNgn/
        lwItST6r9suRBJ8UD4c+Hg1wobWBJH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-EbRdmIHyP0GVDla9-uSedA-1; Fri, 26 Jun 2020 07:58:03 -0400
X-MC-Unique: EbRdmIHyP0GVDla9-uSedA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0838287950B;
        Fri, 26 Jun 2020 11:58:02 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FD33100239F;
        Fri, 26 Jun 2020 11:58:01 +0000 (UTC)
Date:   Fri, 26 Jun 2020 07:57:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH v4.2 3/9] xfs: redesign the reflink remap loop to fix
 blkres depletion crash
Message-ID: <20200626115759.GA8729@bfoster>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304787925.874036.14054367123332450148.stgit@magnolia>
 <20200625172310.GO7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625172310.GO7606@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 10:23:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The existing reflink remapping loop has some structural problems that
> need addressing:
> 
> The biggest problem is that we create one transaction for each extent in
> the source file without accounting for the number of mappings there are
> for the same range in the destination file.  In other words, we don't
> know the number of remap operations that will be necessary and we
> therefore cannot guess the block reservation required.  On highly
> fragmented filesystems (e.g. ones with active dedupe) we guess wrong,
> run out of block reservation, and fail.
> 
> The second problem is that we don't actually use the bmap intents to
> their full potential -- instead of calling bunmapi directly and having
> to deal with its backwards operation, we could call the deferred ops
> xfs_bmap_unmap_extent and xfs_refcount_decrease_extent instead.  This
> makes the frontend loop much simpler.
> 
> Solve all of these problems by refactoring the remapping loops so that
> we only perform one remapping operation per transaction, and each
> operation only tries to remap a single extent from source to dest.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v4.2: move qres conditional to the next patch, rename bmap helper, try
> to clear up some of the smap/dmap confusion
> ---

Looks good. Thanks for the tweaks..

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.h |   13 ++
>  fs/xfs/xfs_reflink.c     |  240 +++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_trace.h       |   52 +---------
>  3 files changed, 142 insertions(+), 163 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 2b18338d0643..e1bd484e5548 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -158,6 +158,13 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
>  	{ BMAP_ATTRFORK,	"ATTR" }, \
>  	{ BMAP_COWFORK,		"COW" }
>  
> +/* Return true if the extent is an allocated extent, written or not. */
> +static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
> +{
> +	return irec->br_startblock != HOLESTARTBLOCK &&
> +		irec->br_startblock != DELAYSTARTBLOCK &&
> +		!isnullstartblock(irec->br_startblock);
> +}
>  
>  /*
>   * Return true if the extent is a real, allocated extent, or false if it is  a
> @@ -165,10 +172,8 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
>   */
>  static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
>  {
> -	return irec->br_state != XFS_EXT_UNWRITTEN &&
> -		irec->br_startblock != HOLESTARTBLOCK &&
> -		irec->br_startblock != DELAYSTARTBLOCK &&
> -		!isnullstartblock(irec->br_startblock);
> +	return xfs_bmap_is_real_extent(irec) &&
> +	       irec->br_state != XFS_EXT_UNWRITTEN;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 22fdea6d69d3..e7dd8950d40a 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -984,41 +984,28 @@ xfs_reflink_ag_has_free_space(
>  }
>  
>  /*
> - * Unmap a range of blocks from a file, then map other blocks into the hole.
> - * The range to unmap is (destoff : destoff + srcioff + irec->br_blockcount).
> - * The extent irec is mapped into dest at irec->br_startoff.
> + * Remap the given extent into the file.  The dmap blockcount will be set to
> + * the number of blocks that were actually remapped.
>   */
>  STATIC int
>  xfs_reflink_remap_extent(
>  	struct xfs_inode	*ip,
> -	struct xfs_bmbt_irec	*irec,
> -	xfs_fileoff_t		destoff,
> +	struct xfs_bmbt_irec	*dmap,
>  	xfs_off_t		new_isize)
>  {
> +	struct xfs_bmbt_irec	smap;
>  	struct xfs_mount	*mp = ip->i_mount;
> -	bool			real_extent = xfs_bmap_is_written_extent(irec);
>  	struct xfs_trans	*tp;
> -	unsigned int		resblks;
> -	struct xfs_bmbt_irec	uirec;
> -	xfs_filblks_t		rlen;
> -	xfs_filblks_t		unmap_len;
>  	xfs_off_t		newlen;
> -	int64_t			qres;
> +	int64_t			qres, qdelta;
> +	unsigned int		resblks;
> +	bool			smap_real;
> +	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
> +	int			nimaps;
>  	int			error;
>  
> -	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
> -	trace_xfs_reflink_punch_range(ip, destoff, unmap_len);
> -
> -	/* No reflinking if we're low on space */
> -	if (real_extent) {
> -		error = xfs_reflink_ag_has_free_space(mp,
> -				XFS_FSB_TO_AGNO(mp, irec->br_startblock));
> -		if (error)
> -			goto out;
> -	}
> -
>  	/* Start a rolling transaction to switch the mappings */
> -	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> +	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
>  	if (error)
>  		goto out;
> @@ -1027,92 +1014,121 @@ xfs_reflink_remap_extent(
>  	xfs_trans_ijoin(tp, ip, 0);
>  
>  	/*
> -	 * Reserve quota for this operation.  We don't know if the first unmap
> -	 * in the dest file will cause a bmap btree split, so we always reserve
> -	 * at least enough blocks for that split.  If the extent being mapped
> -	 * in is written, we need to reserve quota for that too.
> +	 * Read what's currently mapped in the destination file into smap.
> +	 * If smap isn't a hole, we will have to remove it before we can add
> +	 * dmap to the destination file.
>  	 */
> +	nimaps = 1;
> +	error = xfs_bmapi_read(ip, dmap->br_startoff, dmap->br_blockcount,
> +			&smap, &nimaps, 0);
> +	if (error)
> +		goto out_cancel;
> +	ASSERT(nimaps == 1 && smap.br_startoff == dmap->br_startoff);
> +	smap_real = xfs_bmap_is_real_extent(&smap);
> +
> +	/*
> +	 * We can only remap as many blocks as the smaller of the two extent
> +	 * maps, because we can only remap one extent at a time.
> +	 */
> +	dmap->br_blockcount = min(dmap->br_blockcount, smap.br_blockcount);
> +	ASSERT(dmap->br_blockcount == smap.br_blockcount);
> +
> +	trace_xfs_reflink_remap_extent_dest(ip, &smap);
> +
> +	/* No reflinking if the AG of the dest mapping is low on space. */
> +	if (dmap_written) {
> +		error = xfs_reflink_ag_has_free_space(mp,
> +				XFS_FSB_TO_AGNO(mp, dmap->br_startblock));
> +		if (error)
> +			goto out_cancel;
> +	}
> +
> +	/*
> +	 * Compute quota reservation if we think the quota block counter for
> +	 * this file could increase.
> +	 *
> +	 * We start by reserving enough blocks to handle a bmbt split.
> +	 *
> +	 * If we are mapping a written extent into the file, we need to have
> +	 * enough quota block count reservation to handle the blocks in that
> +	 * extent.
> +	 *
> +	 * Note that if we're replacing a delalloc reservation with a written
> +	 * extent, we have to take the full quota reservation because removing
> +	 * the delalloc reservation gives the block count back to the quota
> +	 * count.  This is suboptimal, but the VFS flushed the dest range
> +	 * before we started.  That should have removed all the delalloc
> +	 * reservations, but we code defensively.
> +	 */
> +	qdelta = 0;
>  	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> -	if (real_extent)
> -		qres += irec->br_blockcount;
> +	if (dmap_written)
> +		qres += dmap->br_blockcount;
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
>  			XFS_QMOPT_RES_REGBLKS);
>  	if (error)
>  		goto out_cancel;
>  
> -	trace_xfs_reflink_remap(ip, irec->br_startoff,
> -				irec->br_blockcount, irec->br_startblock);
> -
> -	/* Unmap the old blocks in the data fork. */
> -	rlen = unmap_len;
> -	while (rlen) {
> -		ASSERT(tp->t_firstblock == NULLFSBLOCK);
> -		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1);
> -		if (error)
> -			goto out_cancel;
> -
> +	if (smap_real) {
>  		/*
> -		 * Trim the extent to whatever got unmapped.
> -		 * Remember, bunmapi works backwards.
> +		 * If the extent we're unmapping is backed by storage (written
> +		 * or not), unmap the extent and drop its refcount.
>  		 */
> -		uirec.br_startblock = irec->br_startblock + rlen;
> -		uirec.br_startoff = irec->br_startoff + rlen;
> -		uirec.br_blockcount = unmap_len - rlen;
> -		uirec.br_state = irec->br_state;
> -		unmap_len = rlen;
> +		xfs_bmap_unmap_extent(tp, ip, &smap);
> +		xfs_refcount_decrease_extent(tp, &smap);
> +		qdelta -= smap.br_blockcount;
> +	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
> +		xfs_filblks_t	len = smap.br_blockcount;
>  
> -		/* If this isn't a real mapping, we're done. */
> -		if (!real_extent || uirec.br_blockcount == 0)
> -			goto next_extent;
> -
> -		trace_xfs_reflink_remap(ip, uirec.br_startoff,
> -				uirec.br_blockcount, uirec.br_startblock);
> -
> -		/* Update the refcount tree */
> -		xfs_refcount_increase_extent(tp, &uirec);
> -
> -		/* Map the new blocks into the data fork. */
> -		xfs_bmap_map_extent(tp, ip, &uirec);
> +		/*
> +		 * If the extent we're unmapping is a delalloc reservation,
> +		 * we can use the regular bunmapi function to release the
> +		 * incore state.  Dropping the delalloc reservation takes care
> +		 * of the quota reservation for us.
> +		 */
> +		error = __xfs_bunmapi(NULL, ip, smap.br_startoff, &len, 0, 1);
> +		if (error)
> +			goto out_cancel;
> +		ASSERT(len == 0);
> +	}
>  
> -		/* Update quota accounting. */
> -		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
> -				uirec.br_blockcount);
> +	/*
> +	 * If the extent we're sharing is backed by written storage, increase
> +	 * its refcount and map it into the file.
> +	 */
> +	if (dmap_written) {
> +		xfs_refcount_increase_extent(tp, dmap);
> +		xfs_bmap_map_extent(tp, ip, dmap);
> +		qdelta += dmap->br_blockcount;
> +	}
>  
> -		/* Update dest isize if needed. */
> -		newlen = XFS_FSB_TO_B(mp,
> -				uirec.br_startoff + uirec.br_blockcount);
> -		newlen = min_t(xfs_off_t, newlen, new_isize);
> -		if (newlen > i_size_read(VFS_I(ip))) {
> -			trace_xfs_reflink_update_inode_size(ip, newlen);
> -			i_size_write(VFS_I(ip), newlen);
> -			ip->i_d.di_size = newlen;
> -			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -		}
> +	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, qdelta);
>  
> -next_extent:
> -		/* Process all the deferred stuff. */
> -		error = xfs_defer_finish(&tp);
> -		if (error)
> -			goto out_cancel;
> +	/* Update dest isize if needed. */
> +	newlen = XFS_FSB_TO_B(mp, dmap->br_startoff + dmap->br_blockcount);
> +	newlen = min_t(xfs_off_t, newlen, new_isize);
> +	if (newlen > i_size_read(VFS_I(ip))) {
> +		trace_xfs_reflink_update_inode_size(ip, newlen);
> +		i_size_write(VFS_I(ip), newlen);
> +		ip->i_d.di_size = newlen;
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	}
>  
> +	/* Commit everything and unlock. */
>  	error = xfs_trans_commit(tp);
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	if (error)
> -		goto out;
> -	return 0;
> +	goto out_unlock;
>  
>  out_cancel:
>  	xfs_trans_cancel(tp);
> +out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out:
> -	trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
> +	if (error)
> +		trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
>  	return error;
>  }
>  
> -/*
> - * Iteratively remap one file's extents (and holes) to another's.
> - */
> +/* Remap a range of one file to the other. */
>  int
>  xfs_reflink_remap_blocks(
>  	struct xfs_inode	*src,
> @@ -1123,25 +1139,22 @@ xfs_reflink_remap_blocks(
>  	loff_t			*remapped)
>  {
>  	struct xfs_bmbt_irec	imap;
> -	xfs_fileoff_t		srcoff;
> -	xfs_fileoff_t		destoff;
> +	struct xfs_mount	*mp = src->i_mount;
> +	xfs_fileoff_t		srcoff = XFS_B_TO_FSBT(mp, pos_in);
> +	xfs_fileoff_t		destoff = XFS_B_TO_FSBT(mp, pos_out);
>  	xfs_filblks_t		len;
> -	xfs_filblks_t		range_len;
>  	xfs_filblks_t		remapped_len = 0;
>  	xfs_off_t		new_isize = pos_out + remap_len;
>  	int			nimaps;
>  	int			error = 0;
>  
> -	destoff = XFS_B_TO_FSBT(src->i_mount, pos_out);
> -	srcoff = XFS_B_TO_FSBT(src->i_mount, pos_in);
> -	len = XFS_B_TO_FSB(src->i_mount, remap_len);
> +	len = min_t(xfs_filblks_t, XFS_B_TO_FSB(mp, remap_len),
> +			XFS_MAX_FILEOFF);
>  
> -	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
> -	while (len) {
> -		uint		lock_mode;
> +	trace_xfs_reflink_remap_blocks(src, srcoff, len, dest, destoff);
>  
> -		trace_xfs_reflink_remap_blocks_loop(src, srcoff, len,
> -				dest, destoff);
> +	while (len > 0) {
> +		unsigned int	lock_mode;
>  
>  		/* Read extent from the source file */
>  		nimaps = 1;
> @@ -1150,18 +1163,25 @@ xfs_reflink_remap_blocks(
>  		xfs_iunlock(src, lock_mode);
>  		if (error)
>  			break;
> -		ASSERT(nimaps == 1);
> +		/*
> +		 * The caller supposedly flushed all dirty pages in the source
> +		 * file range, which means that writeback should have allocated
> +		 * or deleted all delalloc reservations in that range.  If we
> +		 * find one, that's a good sign that something is seriously
> +		 * wrong here.
> +		 */
> +		ASSERT(nimaps == 1 && imap.br_startoff == srcoff);
> +		if (imap.br_startblock == DELAYSTARTBLOCK) {
> +			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> +			error = -EFSCORRUPTED;
> +			break;
> +		}
>  
> -		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_DATA_FORK,
> -				&imap);
> +		trace_xfs_reflink_remap_extent_src(src, &imap);
>  
> -		/* Translate imap into the destination file. */
> -		range_len = imap.br_startoff + imap.br_blockcount - srcoff;
> -		imap.br_startoff += destoff - srcoff;
> -
> -		/* Clear dest from destoff to the end of imap and map it in. */
> -		error = xfs_reflink_remap_extent(dest, &imap, destoff,
> -				new_isize);
> +		/* Remap into the destination file at the given offset. */
> +		imap.br_startoff = destoff;
> +		error = xfs_reflink_remap_extent(dest, &imap, new_isize);
>  		if (error)
>  			break;
>  
> @@ -1171,10 +1191,10 @@ xfs_reflink_remap_blocks(
>  		}
>  
>  		/* Advance drange/srange */
> -		srcoff += range_len;
> -		destoff += range_len;
> -		len -= range_len;
> -		remapped_len += range_len;
> +		srcoff += imap.br_blockcount;
> +		destoff += imap.br_blockcount;
> +		len -= imap.br_blockcount;
> +		remapped_len += imap.br_blockcount;
>  	}
>  
>  	if (error)
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 460136628a79..50c478374a31 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3052,8 +3052,7 @@ DEFINE_EVENT(xfs_inode_irec_class, name, \
>  DEFINE_INODE_EVENT(xfs_reflink_set_inode_flag);
>  DEFINE_INODE_EVENT(xfs_reflink_unset_inode_flag);
>  DEFINE_ITRUNC_EVENT(xfs_reflink_update_inode_size);
> -DEFINE_IMAP_EVENT(xfs_reflink_remap_imap);
> -TRACE_EVENT(xfs_reflink_remap_blocks_loop,
> +TRACE_EVENT(xfs_reflink_remap_blocks,
>  	TP_PROTO(struct xfs_inode *src, xfs_fileoff_t soffset,
>  		 xfs_filblks_t len, struct xfs_inode *dest,
>  		 xfs_fileoff_t doffset),
> @@ -3084,59 +3083,14 @@ TRACE_EVENT(xfs_reflink_remap_blocks_loop,
>  		  __entry->dest_ino,
>  		  __entry->dest_lblk)
>  );
> -TRACE_EVENT(xfs_reflink_punch_range,
> -	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
> -		 xfs_extlen_t len),
> -	TP_ARGS(ip, lblk, len),
> -	TP_STRUCT__entry(
> -		__field(dev_t, dev)
> -		__field(xfs_ino_t, ino)
> -		__field(xfs_fileoff_t, lblk)
> -		__field(xfs_extlen_t, len)
> -	),
> -	TP_fast_assign(
> -		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> -		__entry->lblk = lblk;
> -		__entry->len = len;
> -	),
> -	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x",
> -		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -		  __entry->ino,
> -		  __entry->lblk,
> -		  __entry->len)
> -);
> -TRACE_EVENT(xfs_reflink_remap,
> -	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
> -		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
> -	TP_ARGS(ip, lblk, len, new_pblk),
> -	TP_STRUCT__entry(
> -		__field(dev_t, dev)
> -		__field(xfs_ino_t, ino)
> -		__field(xfs_fileoff_t, lblk)
> -		__field(xfs_extlen_t, len)
> -		__field(xfs_fsblock_t, new_pblk)
> -	),
> -	TP_fast_assign(
> -		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> -		__entry->lblk = lblk;
> -		__entry->len = len;
> -		__entry->new_pblk = new_pblk;
> -	),
> -	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x new_pblk %llu",
> -		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -		  __entry->ino,
> -		  __entry->lblk,
> -		  __entry->len,
> -		  __entry->new_pblk)
> -);
>  DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
> +DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_src);
> +DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
>  
>  /* dedupe tracepoints */
>  DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
> 

