Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3521F3029D8
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Jan 2021 19:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbhAYSQE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Jan 2021 13:16:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731370AbhAYSP4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 13:15:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611598469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2TzLEGKRqJ/Fg/kFO9zJpNUnIrJKbZXaicmZt2E5CeU=;
        b=Ahpxj0A8Z0ycihHX1mlAqHOUuk/jXhlQVxMtNdzQa7plyCs2fZ8dbdozfyjikUo44gR25S
        GleQjhystaWUtdVqZFuQArFgUNyW9YLWZD2hnrY9m/AWZbe+AjuxzTK62yQ8Ty+6/Z65df
        wQrRNCxilFUWFuHCFR9QwjfAQFZCEIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-1xsVQUJVNFy5yZH7L047ww-1; Mon, 25 Jan 2021 13:14:25 -0500
X-MC-Unique: 1xsVQUJVNFy5yZH7L047ww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47302B8105;
        Mon, 25 Jan 2021 18:14:24 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A131760C0F;
        Mon, 25 Jan 2021 18:14:23 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:14:21 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 04/11] xfs: move and rename xfs_inode_free_quota_blocks
 to avoid conflicts
Message-ID: <20210125181421.GJ2047559@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142794187.2171939.6923227097082598204.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142794187.2171939.6923227097082598204.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:52:21AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move this function further down in the file so that later cleanups won't
> have to declare static functions.  Change the name because we're about
> to rework all the code that performs garbage collection of speculatively
> allocated file blocks.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c   |    2 -
>  fs/xfs/xfs_icache.c |  110 ++++++++++++++++++++++++++-------------------------
>  fs/xfs/xfs_icache.h |    2 -
>  3 files changed, 57 insertions(+), 57 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 69879237533b..d69e5abcc1b4 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -747,7 +747,7 @@ xfs_file_buffered_write(
>  	 */
>  	if (ret == -EDQUOT && !cleared_space) {
>  		xfs_iunlock(ip, iolock);
> -		cleared_space = xfs_inode_free_quota_blocks(ip);
> +		cleared_space = xfs_blockgc_free_quota(ip);
>  		if (cleared_space)
>  			goto write_retry;
>  		iolock = 0;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 10c1a0dee17d..aba901d5637b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1396,61 +1396,6 @@ xfs_icache_free_eofblocks(
>  			XFS_ICI_EOFBLOCKS_TAG);
>  }
>  
> -/*
> - * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
> - * with multiple quotas, we don't know exactly which quota caused an allocation
> - * failure. We make a best effort by including each quota under low free space
> - * conditions (less than 1% free space) in the scan.
> - */
> -bool
> -xfs_inode_free_quota_blocks(
> -	struct xfs_inode	*ip)
> -{
> -	struct xfs_eofblocks	eofb = {0};
> -	struct xfs_dquot	*dq;
> -	bool			do_work = false;
> -
> -	/*
> -	 * Run a sync scan to increase effectiveness and use the union filter to
> -	 * cover all applicable quotas in a single scan.
> -	 */
> -	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
> -
> -	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
> -		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
> -		if (dq && xfs_dquot_lowsp(dq)) {
> -			eofb.eof_uid = VFS_I(ip)->i_uid;
> -			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
> -			do_work = true;
> -		}
> -	}
> -
> -	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
> -		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
> -		if (dq && xfs_dquot_lowsp(dq)) {
> -			eofb.eof_gid = VFS_I(ip)->i_gid;
> -			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
> -			do_work = true;
> -		}
> -	}
> -
> -	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
> -		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
> -		if (dq && xfs_dquot_lowsp(dq)) {
> -			eofb.eof_prid = ip->i_d.di_projid;
> -			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
> -			do_work = true;
> -		}
> -	}
> -
> -	if (!do_work)
> -		return false;
> -
> -	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> -	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
> -	return true;
> -}
> -
>  static inline unsigned long
>  xfs_iflag_for_tag(
>  	int		tag)
> @@ -1699,3 +1644,58 @@ xfs_start_block_reaping(
>  	xfs_queue_eofblocks(mp);
>  	xfs_queue_cowblocks(mp);
>  }
> +
> +/*
> + * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
> + * with multiple quotas, we don't know exactly which quota caused an allocation
> + * failure. We make a best effort by including each quota under low free space
> + * conditions (less than 1% free space) in the scan.
> + */
> +bool
> +xfs_blockgc_free_quota(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_eofblocks	eofb = {0};
> +	struct xfs_dquot	*dq;
> +	bool			do_work = false;
> +
> +	/*
> +	 * Run a sync scan to increase effectiveness and use the union filter to
> +	 * cover all applicable quotas in a single scan.
> +	 */
> +	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
> +
> +	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
> +		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
> +		if (dq && xfs_dquot_lowsp(dq)) {
> +			eofb.eof_uid = VFS_I(ip)->i_uid;
> +			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
> +			do_work = true;
> +		}
> +	}
> +
> +	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
> +		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
> +		if (dq && xfs_dquot_lowsp(dq)) {
> +			eofb.eof_gid = VFS_I(ip)->i_gid;
> +			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
> +			do_work = true;
> +		}
> +	}
> +
> +	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
> +		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
> +		if (dq && xfs_dquot_lowsp(dq)) {
> +			eofb.eof_prid = ip->i_d.di_projid;
> +			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
> +			do_work = true;
> +		}
> +	}
> +
> +	if (!do_work)
> +		return false;
> +
> +	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> +	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
> +	return true;
> +}
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 3f7ddbca8638..21b726a05b0d 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -54,7 +54,7 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
>  
>  void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
>  
> -bool xfs_inode_free_quota_blocks(struct xfs_inode *ip);
> +bool xfs_blockgc_free_quota(struct xfs_inode *ip);
>  
>  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
>  void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
> 

