Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41C60860
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 16:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfGEOwO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 10:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727565AbfGEOwO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 10:52:14 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12E4F87620;
        Fri,  5 Jul 2019 14:52:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A8D4686426;
        Fri,  5 Jul 2019 14:52:13 +0000 (UTC)
Date:   Fri, 5 Jul 2019 10:52:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: refactor attr scrub memory allocation function
Message-ID: <20190705145211.GF37448@bfoster>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158201810.495944.4418480612524937333.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158201810.495944.4418480612524937333.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 05 Jul 2019 14:52:14 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:46:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the code that allocates memory buffers for the extended attribute
> scrub code into a separate function so we can reduce memory allocations
> in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/attr.c |   33 ++++++++++++++++++++++++---------
>  fs/xfs/scrub/attr.h |    2 ++
>  2 files changed, 26 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index fd16eb3fa003..c20b6da1db84 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -31,26 +31,41 @@
>  #include <linux/posix_acl_xattr.h>
>  #include <linux/xattr.h>
>  
> -/* Set us up to scrub an inode's extended attributes. */
> +/* Allocate enough memory to hold an attr value and attr block bitmaps. */
>  int
> -xchk_setup_xattr(
> +xchk_setup_xattr_buf(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	size_t			value_size)
>  {
>  	size_t			sz;
>  
>  	/*
> -	 * Allocate the buffer without the inode lock held.  We need enough
> -	 * space to read every xattr value in the file or enough space to
> -	 * hold three copies of the xattr free space bitmap.  (Not both at
> -	 * the same time.)
> +	 * We need enough space to read an xattr value from the file or enough
> +	 * space to hold three copies of the xattr free space bitmap.  We don't
> +	 * need the buffer space for both purposes at the same time.
>  	 */
> -	sz = max_t(size_t, XATTR_SIZE_MAX, 3 * sizeof(long) *
> -			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize));
> +	sz = 3 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
> +	sz = max_t(size_t, sz, value_size);
> +
>  	sc->buf = kmem_zalloc_large(sz, KM_SLEEP);
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
> +	return 0;
> +}
> +
> +/* Set us up to scrub an inode's extended attributes. */
> +int
> +xchk_setup_xattr(
> +	struct xfs_scrub	*sc,
> +	struct xfs_inode	*ip)
> +{
> +	int			error;
> +
> +	error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX);
> +	if (error)
> +		return error;
> +
>  	return xchk_setup_inode_contents(sc, ip, 0);
>  }
>  
> diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
> index 88bb5e29c60c..27e879aeaafc 100644
> --- a/fs/xfs/scrub/attr.h
> +++ b/fs/xfs/scrub/attr.h
> @@ -62,4 +62,6 @@ xchk_xattr_dstmap(
>  			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
>  }
>  
> +int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size);
> +
>  #endif	/* __XFS_SCRUB_ATTR_H__ */
> 
