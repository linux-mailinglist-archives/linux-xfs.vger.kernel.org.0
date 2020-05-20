Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539FD1DAAD6
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 08:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgETGmN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 May 2020 02:42:13 -0400
Received: from verein.lst.de ([213.95.11.211]:47947 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETGmN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 02:42:13 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2A44668B02; Wed, 20 May 2020 08:42:11 +0200 (CEST)
Date:   Wed, 20 May 2020 08:42:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/11] xfs: refactor eofb matching into a single helper
Message-ID: <20200520064210.GG2742@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993916213.976105.11958914131452778480.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993916213.976105.11958914131452778480.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:46:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the two eofb-matching logics into a single helper so that we
> don't repeat ourselves.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icache.c |   59 +++++++++++++++++++++++++++------------------------
>  1 file changed, 31 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ac66e7d8698d..1f12c6a0c48e 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1436,6 +1436,33 @@ xfs_inode_match_id_union(
>  	return 0;
>  }
>  
> +/*
> + * Is this inode @ip eligible for eof/cow block reclamation, given some
> + * filtering parameters @eofb?  The inode is eligible if @eofb is null or
> + * if the predicate functions match.
> + */
> +static bool
> +xfs_inode_matches_eofb(
> +	struct xfs_inode	*ip,
> +	struct xfs_eofblocks	*eofb)
> +{
> +	int			match;
> +
> +	if (!eofb)
> +		return true;
> +
> +	if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
> +		match = xfs_inode_match_id_union(ip, eofb);
> +	else
> +		match = xfs_inode_match_id(ip, eofb);
> +	if (match)
> +		return true;
> +
> +	/* skip the inode if the file size is too small */
> +	return !(eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
> +		 XFS_ISIZE(ip) < eofb->eof_min_file_size);

This looks wrong - the size check should be applied if we did already
find a match and not override it based on the current code, e.g.:

	if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
		match = xfs_inode_match_id_union(ip, eofb);
	else
		match = xfs_inode_match_id(ip, eofb);

	if (match) {
		/* skip the inode if the file size is too small */
		if ((eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE) &&
		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
			return false;
	}

	return match;
