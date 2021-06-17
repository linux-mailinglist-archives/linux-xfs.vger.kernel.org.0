Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367603AB949
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Jun 2021 18:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhFQQPZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Jun 2021 12:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233915AbhFQQOB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 12:14:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43C9C610A5;
        Thu, 17 Jun 2021 16:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623946313;
        bh=ITL9DG31od14Ha1/jPRYahDMWhBs1h6Ot2q5LsHhSH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xn5RPMaK5JR4D6b+G4p9DCXdnH1iu6M7ovTOgRyqLyh8/72PaciCQCHxi3VdMcKos
         WRBdl7tgxAziSDLe64o7hmgEs6DBFULJpNvMZ9tJri2aLQ4U0Gc8eeNASm7OdRtMAW
         fCUl0taDkmJlkg4oklmmAC0jjt+9WihIkbZa2GcUcww1daMRReHiI0xLvXtgHnvPE9
         lNj7NW7EZUTsZ9wUpl4HNlGT2YdDv0dN0jsgFarjMdYw9rl0d30CFL9LtwZ0iCensW
         oyxxFxYoaf+ogwtmTUI0TY/f2CVlkLKYYDE/5/2kri4S0XtlHmeArwcm9hFClbEjQw
         cZ4koY1v1X2Zg==
Date:   Thu, 17 Jun 2021 09:11:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     akpm@linux-foundation.org, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com
Subject: Re: [PATCH v3 1/8] ext4/xfs: add page refcount helper
Message-ID: <20210617161152.GA158156@locust>
References: <20210617151705.15367-1-alex.sierra@amd.com>
 <20210617151705.15367-2-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617151705.15367-2-alex.sierra@amd.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 10:16:58AM -0500, Alex Sierra wrote:
> From: Ralph Campbell <rcampbell@nvidia.com>
> 
> There are several places where ZONE_DEVICE struct pages assume a reference
> count == 1 means the page is idle and free. Instead of open coding this,
> add a helper function to hide this detail.
> 
> v2:
> [AS]: rename dax_layout_is_idle_page func to dax_page_unused
> 
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> ---
>  fs/dax.c            |  4 ++--
>  fs/ext4/inode.c     |  5 +----
>  fs/xfs/xfs_file.c   |  4 +---
>  include/linux/dax.h | 10 ++++++++++
>  4 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 26d5dcd2d69e..321f4ddc6643 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -358,7 +358,7 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>  	for_each_mapped_pfn(entry, pfn) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
> +		WARN_ON_ONCE(trunc && !dax_layout_is_idle_page(page));
>  		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
>  		page->mapping = NULL;
>  		page->index = 0;
> @@ -372,7 +372,7 @@ static struct page *dax_busy_page(void *entry)
>  	for_each_mapped_pfn(entry, pfn) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		if (page_ref_count(page) > 1)
> +		if (!dax_layout_is_idle_page(page))
>  			return page;
>  	}
>  	return NULL;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c173c8405856..9ee00186412f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3972,10 +3972,7 @@ int ext4_break_layouts(struct inode *inode)
>  		if (!page)
>  			return 0;
>  
> -		error = ___wait_var_event(&page->_refcount,
> -				atomic_read(&page->_refcount) == 1,
> -				TASK_INTERRUPTIBLE, 0, 0,
> -				ext4_wait_dax_page(ei));
> +		error = dax_wait_page(ei, page, ext4_wait_dax_page);
>  	} while (error == 0);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5b0f93f73837..39565fe5f817 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -782,9 +782,7 @@ xfs_break_dax_layouts(
>  		return 0;
>  
>  	*retry = true;
> -	return ___wait_var_event(&page->_refcount,
> -			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
> -			0, 0, xfs_wait_dax_page(inode));
> +	return dax_wait_page(inode, page, xfs_wait_dax_page);

Mechanically, this looks like a straightforward replacement, so:
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

>  }
>  
>  int
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b52f084aa643..8b5da1d60dbc 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -243,6 +243,16 @@ static inline bool dax_mapping(struct address_space *mapping)
>  	return mapping->host && IS_DAX(mapping->host);
>  }
>  
> +static inline bool dax_page_unused(struct page *page)
> +{
> +	return page_ref_count(page) == 1;
> +}
> +
> +#define dax_wait_page(_inode, _page, _wait_cb)				\
> +	___wait_var_event(&(_page)->_refcount,				\
> +		dax_page_unused(_page),				\
> +		TASK_INTERRUPTIBLE, 0, 0, _wait_cb(_inode))
> +
>  #ifdef CONFIG_DEV_DAX_HMEM_DEVICES
>  void hmem_register_device(int target_nid, struct resource *r);
>  #else
> -- 
> 2.17.1
> 
