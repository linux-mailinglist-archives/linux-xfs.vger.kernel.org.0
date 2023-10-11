Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0BC7C5B91
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Oct 2023 20:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjJKSrN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Oct 2023 14:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbjJKSrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:47:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6698B7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:47:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C4FC433C8;
        Wed, 11 Oct 2023 18:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697050029;
        bh=n/iTOOI8M9sdxw8tpDCKVbuwmoL7GWdiRySmoGXwni4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QV5ZDLqEZ0D3QDDDkDO2SuOUviP5ER8zfJJCzKNLTwOpUJLzh2DnRVr6m1pfn8FYU
         sCVoVcVjK3vUtdAi6Tss83sydJUtqUsYLKl0XDMIT+ICUGkHqK3qxbXIeYxwBkDdoq
         3i2KQ2VZqb9J9IMKOZJIyAiK1ZklsaazaPBtX4jFFU+iBj9x5DHrhBa7iaj6/52KoC
         u/e4X3wc3onFzV8X/Acaq7gZ5XuGpOoUYSr7vkcVUbWUrsDVcJjI+Z67XLc55DxZGH
         M4/wLbBtOvhs4xLLLo4geAVq8R4sn1lRbISej+ffp9kR7TGsrLbwoimjpp1xR4LMFg
         Igx6k85mU9IuA==
Date:   Wed, 11 Oct 2023 11:47:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 16/28] xfs: add bio_set and submit_io for ioend
 post-processing
Message-ID: <20231011184709.GP21298@frogsfrogsfrogs>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-17-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-17-aalbersh@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:49:10PM +0200, Andrey Albershteyn wrote:
> The read IO path provides callout for configuring ioend. This allows
> filesystem to add verification of completed BIOs. One of such tasks
> is verification against fs-verity tree when pages were read. iomap
> allows using custom bio_set with submit_bio() to add ioend
> processing. The xfs_prepare_read_ioend() configures bio->bi_end_io
> which places verification task in the workqueue. The task does
> fs-verity verification and then call back to the iomap to finish IO.
> 
> This patch adds callouts implementation to verify pages with
> fs-verity. Also implements folio operation .verify_folio for direct
> folio verification by fs-verity.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_aops.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_aops.h  |  2 ++
>  fs/xfs/xfs_linux.h |  1 +
>  fs/xfs/xfs_super.c |  9 ++++-
>  4 files changed, 93 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index b413a2dbcc18..fceb0c3de61f 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -26,6 +26,8 @@ struct xfs_writepage_ctx {
>  	unsigned int		cow_seq;
>  };
>  
> +static struct bio_set xfs_read_ioend_bioset;
> +
>  static inline struct xfs_writepage_ctx *
>  XFS_WPC(struct iomap_writepage_ctx *ctx)
>  {
> @@ -548,19 +550,97 @@ xfs_vm_bmap(
>  	return iomap_bmap(mapping, block, &xfs_read_iomap_ops);
>  }
>  
> +static void
> +xfs_read_work_end_io(
> +	struct work_struct *work)
> +{
> +	struct iomap_read_ioend *ioend =
> +		container_of(work, struct iomap_read_ioend, work);
> +	struct bio *bio = &ioend->read_inline_bio;
> +
> +	fsverity_verify_bio(bio);
> +	iomap_read_end_io(bio);
> +	/*
> +	 * The iomap_read_ioend has been freed by bio_put() in
> +	 * iomap_read_end_io()
> +	 */
> +}
> +
> +static void
> +xfs_read_end_io(
> +	struct bio *bio)
> +{
> +	struct iomap_read_ioend *ioend =
> +		container_of(bio, struct iomap_read_ioend, read_inline_bio);
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +
> +	WARN_ON_ONCE(!queue_work(ip->i_mount->m_postread_workqueue,
> +					&ioend->work));

If queue_work fails we should EIO the read.

> +}
> +
> +static int
> +xfs_verify_folio(
> +	struct folio	*folio,
> +	loff_t		pos,
> +	unsigned int	len)
> +{
> +	if (fsverity_verify_blocks(folio, len, pos))
> +		return 0;
> +	return -EFSCORRUPTED;
> +}
> +
> +int
> +xfs_init_iomap_bioset(void)

Probably should be marked __init, right?

> +{
> +	return bioset_init(&xfs_read_ioend_bioset,
> +			   4 * (PAGE_SIZE / SECTOR_SIZE),
> +			   offsetof(struct iomap_read_ioend, read_inline_bio),
> +			   BIOSET_NEED_BVECS);

Also, there's nothing specific to XFS in this bioset, is there?
Shouldn't this be in fs/iomap/buffered-io.c and not XFS?

> +}
> +
> +void
> +xfs_free_iomap_bioset(void)
> +{
> +	bioset_exit(&xfs_read_ioend_bioset);
> +}
> +
> +static void
> +xfs_submit_read_bio(
> +	const struct iomap_iter *iter,
> +	struct bio *bio,
> +	loff_t file_offset)
> +{
> +	struct iomap_read_ioend *ioend;
> +
> +	ioend = container_of(bio, struct iomap_read_ioend, read_inline_bio);
> +	ioend->io_inode = iter->inode;
> +	if (fsverity_active(ioend->io_inode)) {
> +		INIT_WORK(&ioend->work, &xfs_read_work_end_io);
> +		ioend->read_inline_bio.bi_end_io = &xfs_read_end_io;
> +	}
> +
> +	submit_bio(bio);
> +}
> +
> +static const struct iomap_readpage_ops xfs_readpage_ops = {
> +	.verify_folio		= &xfs_verify_folio,
> +	.submit_io		= &xfs_submit_read_bio,
> +	.bio_set		= &xfs_read_ioend_bioset,
> +};
> +
>  STATIC int
>  xfs_vm_read_folio(
>  	struct file		*unused,
>  	struct folio		*folio)
>  {
> -	return iomap_read_folio(folio, &xfs_read_iomap_ops, NULL);
> +	return iomap_read_folio(folio, &xfs_read_iomap_ops, &xfs_readpage_ops);

Leave the ops parameter as NULL for non-verity filesystems to avoid the
overhead of indirect calls.  Work data partitions aren't going to enable
verity.

--D

>  }
>  
>  STATIC void
>  xfs_vm_readahead(
>  	struct readahead_control	*rac)
>  {
> -	iomap_readahead(rac, &xfs_read_iomap_ops, NULL);
> +	iomap_readahead(rac, &xfs_read_iomap_ops, &xfs_readpage_ops);
>  }
>  
>  static int
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index e0bd68419764..fa7c512b2717 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -10,5 +10,7 @@ extern const struct address_space_operations xfs_address_space_operations;
>  extern const struct address_space_operations xfs_dax_aops;
>  
>  int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
> +int	xfs_init_iomap_bioset(void);
> +void	xfs_free_iomap_bioset(void);
>  
>  #endif /* __XFS_AOPS_H__ */
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index e9d317a3dafe..ee213c6dfcaf 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -64,6 +64,7 @@ typedef __u32			xfs_nlink_t;
>  #include <linux/xattr.h>
>  #include <linux/mnt_idmapping.h>
>  #include <linux/debugfs.h>
> +#include <linux/fsverity.h>
>  
>  #include <asm/page.h>
>  #include <asm/div64.h>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5e1ec5978176..3cdb642961f4 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2375,11 +2375,17 @@ init_xfs_fs(void)
>  	if (error)
>  		goto out_remove_dbg_kobj;
>  
> -	error = register_filesystem(&xfs_fs_type);
> +	error = xfs_init_iomap_bioset();
>  	if (error)
>  		goto out_qm_exit;
> +
> +	error = register_filesystem(&xfs_fs_type);
> +	if (error)
> +		goto out_iomap_bioset;
>  	return 0;
>  
> + out_iomap_bioset:
> +	xfs_free_iomap_bioset();
>   out_qm_exit:
>  	xfs_qm_exit();
>   out_remove_dbg_kobj:
> @@ -2412,6 +2418,7 @@ init_xfs_fs(void)
>  STATIC void __exit
>  exit_xfs_fs(void)
>  {
> +	xfs_free_iomap_bioset();
>  	xfs_qm_exit();
>  	unregister_filesystem(&xfs_fs_type);
>  #ifdef DEBUG
> -- 
> 2.40.1
> 
