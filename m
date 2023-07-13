Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF908751790
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jul 2023 06:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbjGMEgK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jul 2023 00:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbjGMEgI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 00:36:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2471319BE;
        Wed, 12 Jul 2023 21:36:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6C47619B0;
        Thu, 13 Jul 2023 04:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F536C433C8;
        Thu, 13 Jul 2023 04:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689222966;
        bh=9Vf66Ft1+ZYHc6n9EoSS+uw3LVH41Gz8WfEVRlTzP+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MEafoZ4f22esYVxsB2Q8KU/cOTeF+szhTopOc7JixAwnNucKTeP4SRB9e9cC47AxT
         ZSB1X8iKK4tdlfC7z+6PZyYqq8GgmQsNll+2N0zzvvEz9UXRHx+8dG3JehTGlfB60D
         U8VVjqwVKYybdF2oJLrLXY0QDQyZ7N5eun48Agw96qVadxo9l00sOUfSnHrwJAa0DY
         nlB+gm8VNnfm8cHa34n6/0iG5W7C8Cb44ea8rfyf0gpEXjUDRI7AKJS9B9/8vimtKX
         UJY3x/7Uei9K+TnVCjWZKDnuHep8ylIynm6huLp6qvCqqVnVLeKjULvj/ZkhSpg0yX
         1s70PQbP4dV3Q==
Date:   Wed, 12 Jul 2023 21:36:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Aravinda Herle <araherle@in.ibm.com>
Subject: Re: [PATCHv11 8/8] iomap: Add per-block dirty state tracking to
 improve performance
Message-ID: <20230713043605.GF108251@frogsfrogsfrogs>
References: <cover.1688188958.git.ritesh.list@gmail.com>
 <bb0c58bf80dcdec96d7387bc439925fb14a5a496.1688188958.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb0c58bf80dcdec96d7387bc439925fb14a5a496.1688188958.git.ritesh.list@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 01, 2023 at 01:04:41PM +0530, Ritesh Harjani (IBM) wrote:
> When filesystem blocksize is less than folio size (either with
> mapping_large_folio_support() or with blocksize < pagesize) and when the
> folio is uptodate in pagecache, then even a byte write can cause
> an entire folio to be written to disk during writeback. This happens
> because we currently don't have a mechanism to track per-block dirty
> state within struct iomap_folio_state. We currently only track uptodate
> state.
> 
> This patch implements support for tracking per-block dirty state in
> iomap_folio_state->state bitmap. This should help improve the filesystem
> write performance and help reduce write amplification.
> 
> Performance testing of below fio workload reveals ~16x performance
> improvement using nvme with XFS (4k blocksize) on Power (64K pagesize)
> FIO reported write bw scores improved from around ~28 MBps to ~452 MBps.
> 
> 1. <test_randwrite.fio>
> [global]
> 	ioengine=psync
> 	rw=randwrite
> 	overwrite=1
> 	pre_read=1
> 	direct=0
> 	bs=4k
> 	size=1G
> 	dir=./
> 	numjobs=8
> 	fdatasync=1
> 	runtime=60
> 	iodepth=64
> 	group_reporting=1
> 
> [fio-run]
> 
> 2. Also our internal performance team reported that this patch improves
>    their database workload performance by around ~83% (with XFS on Power)
> 
> Reported-by: Aravinda Herle <araherle@in.ibm.com>
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  fs/gfs2/aops.c         |   2 +-
>  fs/iomap/buffered-io.c | 149 ++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_aops.c      |   2 +-
>  fs/zonefs/file.c       |   2 +-
>  include/linux/iomap.h  |   1 +
>  5 files changed, 142 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index a5f4be6b9213..75efec3c3b71 100644
> --- a/fs/gfs2/aops.c
> +++ b/fs/gfs2/aops.c
> @@ -746,7 +746,7 @@ static const struct address_space_operations gfs2_aops = {
>  	.writepages = gfs2_writepages,
>  	.read_folio = gfs2_read_folio,
>  	.readahead = gfs2_readahead,
> -	.dirty_folio = filemap_dirty_folio,
> +	.dirty_folio = iomap_dirty_folio,
>  	.release_folio = iomap_release_folio,
>  	.invalidate_folio = iomap_invalidate_folio,
>  	.bmap = gfs2_bmap,
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index fb6c2b6a4358..2fd9413838de 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -25,7 +25,7 @@
>  
>  typedef int (*iomap_punch_t)(struct inode *inode, loff_t offset, loff_t length);
>  /*
> - * Structure allocated for each folio to track per-block uptodate state
> + * Structure allocated for each folio to track per-block uptodate, dirty state
>   * and I/O completions.
>   */
>  struct iomap_folio_state {
> @@ -78,6 +78,61 @@ static void iomap_set_range_uptodate(struct folio *folio, size_t off,
>  		folio_mark_uptodate(folio);
>  }
>  
> +static inline bool ifs_block_is_dirty(struct folio *folio,
> +		struct iomap_folio_state *ifs, int block)
> +{
> +	struct inode *inode = folio->mapping->host;
> +	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> +
> +	return test_bit(block + blks_per_folio, ifs->state);
> +}
> +
> +static void ifs_clear_range_dirty(struct folio *folio,
> +		struct iomap_folio_state *ifs, size_t off, size_t len)
> +{
> +	struct inode *inode = folio->mapping->host;
> +	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> +	unsigned int first_blk = (off >> inode->i_blkbits);
> +	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> +	unsigned int nr_blks = last_blk - first_blk + 1;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ifs->state_lock, flags);
> +	bitmap_clear(ifs->state, first_blk + blks_per_folio, nr_blks);

Much clearer now that these have been simplified.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +	spin_unlock_irqrestore(&ifs->state_lock, flags);
> +}
> +
> +static void iomap_clear_range_dirty(struct folio *folio, size_t off, size_t len)
> +{
> +	struct iomap_folio_state *ifs = folio->private;
> +
> +	if (ifs)
> +		ifs_clear_range_dirty(folio, ifs, off, len);
> +}
> +
> +static void ifs_set_range_dirty(struct folio *folio,
> +		struct iomap_folio_state *ifs, size_t off, size_t len)
> +{
> +	struct inode *inode = folio->mapping->host;
> +	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> +	unsigned int first_blk = (off >> inode->i_blkbits);
> +	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> +	unsigned int nr_blks = last_blk - first_blk + 1;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ifs->state_lock, flags);
> +	bitmap_set(ifs->state, first_blk + blks_per_folio, nr_blks);
> +	spin_unlock_irqrestore(&ifs->state_lock, flags);
> +}
> +
> +static void iomap_set_range_dirty(struct folio *folio, size_t off, size_t len)
> +{
> +	struct iomap_folio_state *ifs = folio->private;
> +
> +	if (ifs)
> +		ifs_set_range_dirty(folio, ifs, off, len);
> +}
> +
>  static struct iomap_folio_state *ifs_alloc(struct inode *inode,
>  		struct folio *folio, unsigned int flags)
>  {
> @@ -93,14 +148,24 @@ static struct iomap_folio_state *ifs_alloc(struct inode *inode,
>  	else
>  		gfp = GFP_NOFS | __GFP_NOFAIL;
>  
> -	ifs = kzalloc(struct_size(ifs, state, BITS_TO_LONGS(nr_blocks)),
> -		      gfp);
> -	if (ifs) {
> -		spin_lock_init(&ifs->state_lock);
> -		if (folio_test_uptodate(folio))
> -			bitmap_fill(ifs->state, nr_blocks);
> -		folio_attach_private(folio, ifs);
> -	}
> +	/*
> +	 * ifs->state tracks two sets of state flags when the
> +	 * filesystem block size is smaller than the folio size.
> +	 * The first state tracks per-block uptodate and the
> +	 * second tracks per-block dirty state.
> +	 */
> +	ifs = kzalloc(struct_size(ifs, state,
> +		      BITS_TO_LONGS(2 * nr_blocks)), gfp);
> +	if (!ifs)
> +		return ifs;
> +
> +	spin_lock_init(&ifs->state_lock);
> +	if (folio_test_uptodate(folio))
> +		bitmap_set(ifs->state, 0, nr_blocks);
> +	if (folio_test_dirty(folio))
> +		bitmap_set(ifs->state, nr_blocks, nr_blocks);
> +	folio_attach_private(folio, ifs);
> +
>  	return ifs;
>  }
>  
> @@ -523,6 +588,17 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len)
>  }
>  EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
>  
> +bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio)
> +{
> +	struct inode *inode = mapping->host;
> +	size_t len = folio_size(folio);
> +
> +	ifs_alloc(inode, folio, 0);
> +	iomap_set_range_dirty(folio, 0, len);
> +	return filemap_dirty_folio(mapping, folio);
> +}
> +EXPORT_SYMBOL_GPL(iomap_dirty_folio);
> +
>  static void
>  iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
>  {
> @@ -727,6 +803,7 @@ static size_t __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
>  	if (unlikely(copied < len && !folio_test_uptodate(folio)))
>  		return 0;
>  	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
> +	iomap_set_range_dirty(folio, offset_in_folio(folio, pos), copied);
>  	filemap_dirty_folio(inode->i_mapping, folio);
>  	return copied;
>  }
> @@ -891,6 +968,43 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  }
>  EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
>  
> +static int iomap_write_delalloc_ifs_punch(struct inode *inode,
> +		struct folio *folio, loff_t start_byte, loff_t end_byte,
> +		iomap_punch_t punch)
> +{
> +	unsigned int first_blk, last_blk, i;
> +	loff_t last_byte;
> +	u8 blkbits = inode->i_blkbits;
> +	struct iomap_folio_state *ifs;
> +	int ret = 0;
> +
> +	/*
> +	 * When we have per-block dirty tracking, there can be
> +	 * blocks within a folio which are marked uptodate
> +	 * but not dirty. In that case it is necessary to punch
> +	 * out such blocks to avoid leaking any delalloc blocks.
> +	 */
> +	ifs = folio->private;
> +	if (!ifs)
> +		return ret;
> +
> +	last_byte = min_t(loff_t, end_byte - 1,
> +			folio_pos(folio) + folio_size(folio) - 1);
> +	first_blk = offset_in_folio(folio, start_byte) >> blkbits;
> +	last_blk = offset_in_folio(folio, last_byte) >> blkbits;
> +	for (i = first_blk; i <= last_blk; i++) {
> +		if (!ifs_block_is_dirty(folio, ifs, i)) {
> +			ret = punch(inode, folio_pos(folio) + (i << blkbits),
> +				    1 << blkbits);
> +			if (ret)
> +				return ret;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +
>  static int iomap_write_delalloc_punch(struct inode *inode, struct folio *folio,
>  		loff_t *punch_start_byte, loff_t start_byte, loff_t end_byte,
>  		iomap_punch_t punch)
> @@ -907,6 +1021,13 @@ static int iomap_write_delalloc_punch(struct inode *inode, struct folio *folio,
>  		if (ret)
>  			return ret;
>  	}
> +
> +	/* Punch non-dirty blocks within folio */
> +	ret = iomap_write_delalloc_ifs_punch(inode, folio, start_byte,
> +			end_byte, punch);
> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * Make sure the next punch start is correctly bound to
>  	 * the end of this data range, not the end of the folio.
> @@ -1637,7 +1758,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  		struct writeback_control *wbc, struct inode *inode,
>  		struct folio *folio, u64 end_pos)
>  {
> -	struct iomap_folio_state *ifs = ifs_alloc(inode, folio, 0);
> +	struct iomap_folio_state *ifs = folio->private;
>  	struct iomap_ioend *ioend, *next;
>  	unsigned len = i_blocksize(inode);
>  	unsigned nblocks = i_blocks_per_folio(inode, folio);
> @@ -1645,6 +1766,11 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  	int error = 0, count = 0, i;
>  	LIST_HEAD(submit_list);
>  
> +	if (!ifs && nblocks > 1) {
> +		ifs = ifs_alloc(inode, folio, 0);
> +		iomap_set_range_dirty(folio, 0, folio_size(folio));
> +	}
> +
>  	WARN_ON_ONCE(ifs && atomic_read(&ifs->write_bytes_pending) != 0);
>  
>  	/*
> @@ -1653,7 +1779,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  	 * invalid, grab a new one.
>  	 */
>  	for (i = 0; i < nblocks && pos < end_pos; i++, pos += len) {
> -		if (ifs && !ifs_block_is_uptodate(ifs, i))
> +		if (ifs && !ifs_block_is_dirty(folio, ifs, i))
>  			continue;
>  
>  		error = wpc->ops->map_blocks(wpc, inode, pos);
> @@ -1697,6 +1823,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  		}
>  	}
>  
> +	iomap_clear_range_dirty(folio, 0, end_pos - folio_pos(folio));
>  	folio_start_writeback(folio);
>  	folio_unlock(folio);
>  
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 451942fb38ec..2fca4b4e7fd8 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -578,7 +578,7 @@ const struct address_space_operations xfs_address_space_operations = {
>  	.read_folio		= xfs_vm_read_folio,
>  	.readahead		= xfs_vm_readahead,
>  	.writepages		= xfs_vm_writepages,
> -	.dirty_folio		= filemap_dirty_folio,
> +	.dirty_folio		= iomap_dirty_folio,
>  	.release_folio		= iomap_release_folio,
>  	.invalidate_folio	= iomap_invalidate_folio,
>  	.bmap			= xfs_vm_bmap,
> diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
> index 132f01d3461f..e508c8e97372 100644
> --- a/fs/zonefs/file.c
> +++ b/fs/zonefs/file.c
> @@ -175,7 +175,7 @@ const struct address_space_operations zonefs_file_aops = {
>  	.read_folio		= zonefs_read_folio,
>  	.readahead		= zonefs_readahead,
>  	.writepages		= zonefs_writepages,
> -	.dirty_folio		= filemap_dirty_folio,
> +	.dirty_folio		= iomap_dirty_folio,
>  	.release_folio		= iomap_release_folio,
>  	.invalidate_folio	= iomap_invalidate_folio,
>  	.migrate_folio		= filemap_migrate_folio,
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index e2b836c2e119..eb9335c46bf3 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -264,6 +264,7 @@ bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
>  struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos);
>  bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
>  void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
> +bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
>  int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
>  		const struct iomap_ops *ops);
>  int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
> -- 
> 2.40.1
> 
