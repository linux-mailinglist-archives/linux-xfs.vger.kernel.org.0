Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D8F87A3F
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 14:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406522AbfHIMfF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 08:35:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406518AbfHIMfF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Aug 2019 08:35:05 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67FFE88309;
        Fri,  9 Aug 2019 12:35:05 +0000 (UTC)
Received: from redhat.com (ovpn-123-180.rdu2.redhat.com [10.10.123.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10BD360600;
        Fri,  9 Aug 2019 12:35:04 +0000 (UTC)
Date:   Fri, 9 Aug 2019 07:35:03 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] vfs: fix page locking deadlocks when deduping files
Message-ID: <20190809123503.GA26462@redhat.com>
References: <156527561023.1960675.17007470833732765300.stgit@magnolia>
 <156527561641.1960675.7113883901730327475.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156527561641.1960675.7113883901730327475.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 09 Aug 2019 12:35:05 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 08, 2019 at 07:46:56AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When dedupe wants to use the page cache to compare parts of two files
> for dedupe, we must be very careful to handle locking correctly.  The
> current code doesn't do this.  It must lock and unlock the page only
> once if the two pages are the same, since the overlapping range check
> doesn't catch this when blocksize < pagesize.  If the pages are distinct
> but from the same file, we must observe page locking order and lock them
> in order of increasing offset to avoid clashing with writeback locking.
> 
> Fixes: 876bec6f9bbfcb3 ("vfs: refactor clone/dedupe_file_range common functions")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/read_write.c |   36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 1f5088dec566..4dbdccffa59e 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1811,10 +1811,7 @@ static int generic_remap_check_len(struct inode *inode_in,
>  	return (remap_flags & REMAP_FILE_DEDUP) ? -EBADE : -EINVAL;
>  }
>  
> -/*
> - * Read a page's worth of file data into the page cache.  Return the page
> - * locked.
> - */
> +/* Read a page's worth of file data into the page cache. */
>  static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
>  {
>  	struct page *page;
> @@ -1826,10 +1823,32 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
>  		put_page(page);
>  		return ERR_PTR(-EIO);
>  	}
> -	lock_page(page);
>  	return page;
>  }
>  
> +/*
> + * Lock two pages, ensuring that we lock in offset order if the pages are from
> + * the same file.
> + */
> +static void vfs_lock_two_pages(struct page *page1, struct page *page2)
> +{
> +	/* Always lock in order of increasing index. */
> +	if (page1->index > page2->index)
> +		swap(page1, page2);
> +
> +	lock_page(page1);
> +	if (page1 != page2)
> +		lock_page(page2);
> +}
> +
> +/* Unlock two pages, being careful not to unlock the same page twice. */
> +static void vfs_unlock_two_pages(struct page *page1, struct page *page2)
> +{
> +	unlock_page(page1);
> +	if (page1 != page2)
> +		unlock_page(page2);
> +}
> +
>  /*
>   * Compare extents of two files to see if they are the same.
>   * Caller must have locked both inodes to prevent write races.
> @@ -1867,10 +1886,12 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  		dest_page = vfs_dedupe_get_page(dest, destoff);
>  		if (IS_ERR(dest_page)) {
>  			error = PTR_ERR(dest_page);
> -			unlock_page(src_page);
>  			put_page(src_page);
>  			goto out_error;
>  		}
> +
> +		vfs_lock_two_pages(src_page, dest_page);
> +
>  		src_addr = kmap_atomic(src_page);
>  		dest_addr = kmap_atomic(dest_page);
>  
> @@ -1882,8 +1903,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  
>  		kunmap_atomic(dest_addr);
>  		kunmap_atomic(src_addr);
> -		unlock_page(dest_page);
> -		unlock_page(src_page);
> +		vfs_unlock_two_pages(src_page, dest_page);
>  		put_page(dest_page);
>  		put_page(src_page);
>  
> 
