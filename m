Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FDA7C5D15
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Oct 2023 20:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbjJKSyr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Oct 2023 14:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbjJKSyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:54:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6873194
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:54:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06310C433C7;
        Wed, 11 Oct 2023 18:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697050485;
        bh=IRnLspIiHI6Z3V+0zGgODvbCLnTlM66rVD5cXwnNSQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FPA13b9XZ5QdIP6U4CajdMCLEnYuz/0YnH32YEYUE7V0s2MUJ31KAj5bpaLusclMy
         Q3JovSh5b0GgAFuswwpMt5uVFabQLhH5Os8Vfus5pLIE6uLu8HvXGmXz+6D12o+sY/
         8UmoOxDgpC+anFkgNE7iunCSMYCOQ6SgZPjug04tmBRcJEIPNx5chAbjSIcyZxvN6E
         ighOMDEblRP12Z4fH2E/vWcBZBQM9p/+q1aGR3pQdS29K3pcLostr33ih9JUSymeq/
         gE8gSOGcSXPy7euDJm+ZN5M8B+GQeU5iS5HkVk5xznNmZOmFW6ThAbBI3hltJUFQmi
         es4+zSW+oAZ0Q==
Date:   Wed, 11 Oct 2023 11:54:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 13/28] xfs: add XBF_VERITY_CHECKED xfs_buf flag
Message-ID: <20231011185444.GR21298@frogsfrogsfrogs>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-14-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-14-aalbersh@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:49:07PM +0200, Andrey Albershteyn wrote:
> One of essential ideas of fs-verity is that pages which are already
> verified won't need to be re-verified if they still in page cache.
> 
> XFS will store Merkle tree blocks in extended attributes. Each
> attribute has one Merkle tree block. When read extended attribute
> data is put into xfs_buf.
> 
> The data in the buffer is not aligned with xfs_buf pages and we
> don't have a reference to these pages. Moreover, these pages are
> released when value is copied out in xfs_attr code. In other words,
> we can not directly mark underlying xfs_buf's pages as verified.

/me wonders why the fs/verity code itself doesn't track which parts of
the merkle tree have been verified.

> One way to track that these pages were verified is to mark xattr's
> buffer as verified instead. If buffer is evicted the incore
> XBF_VERITY_CHECKED flag is lost. When the xattr is read again
> xfs_attr_get() returns new buffer without the flag. The xfs_buf's
> flag is then used to tell fs-verity if it's new page or cached one.
> 
> The meaning of the flag is that value of the extended attribute in
> the buffer is verified.

Can there be multiple blocks from distant parts of the merkle tree
stored in a single xattr leaf block?  I'm imagining the case where
merkle tree blocks are 4K each, but the fs block size is 64k.

(Or: what is the relationship between merkle tree blocks and fs
blocksize?  Are they always the same, or can they differ?)

Or, is there some guarantee that merkle tree blocks will always be
stored as remote xattrs?

I'm worrying about the case where an xfs_buf might contain 2 merkle tree
blocks, we set XBF_VERITY_CHECKED having checked *one* of them but then
forget to check any other verity blobs that might be in the same buffer.

--D

> Note that, the underlying pages have PageChecked() == false (the way
> fs-verity identifies verified pages).
> 
> The flag is being used later to SetPageChecked() on pages handed to
> the fs-verity.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_buf.h | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index df8f47953bb4..d0fadb6d4b59 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -24,14 +24,15 @@ struct xfs_buf;
>  
>  #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
>  
> -#define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
> -#define XBF_WRITE	 (1u << 1) /* buffer intended for writing to device */
> -#define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
> -#define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
> -#define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
> -#define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
> -#define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
> -#define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
> +#define XBF_READ		(1u << 0) /* buffer intended for reading from device */
> +#define XBF_WRITE		(1u << 1) /* buffer intended for writing to device */
> +#define XBF_READ_AHEAD		(1u << 2) /* asynchronous read-ahead */
> +#define XBF_NO_IOACCT		(1u << 3) /* bypass I/O accounting (non-LRU bufs) */
> +#define XBF_ASYNC		(1u << 4) /* initiator will not wait for completion */
> +#define XBF_DONE		(1u << 5) /* all pages in the buffer uptodate */
> +#define XBF_STALE		(1u << 6) /* buffer has been staled, do not find it */
> +#define XBF_WRITE_FAIL		(1u << 7) /* async writes have failed on this buffer */
> +#define XBF_VERITY_CHECKED	(1u << 8) /* buffer was verified by fs-verity*/
>  
>  /* buffer type flags for write callbacks */
>  #define _XBF_INODES	 (1u << 16)/* inode buffer */
> -- 
> 2.40.1
> 
