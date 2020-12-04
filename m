Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAD52CEF2C
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Dec 2020 15:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387614AbgLDOCK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Dec 2020 09:02:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387411AbgLDOCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 09:02:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o/qKEZWf0iyn/GQJB17CNoj3KU/1bFsU+bhimL2oFJg=;
        b=FSSp0ZrQLlnMjVPNdFlymrrhVgTv77Y6rqEiHF+IouPEWOC4OdzOkxZawiqLNgIuNpS+b5
        RrNqiacNzNzsBAHqHWrrVyQRjgESJb8D/Dhg0fYRCYGnKGNFtCrCG1eDbT5BAsWHq6mkG0
        XLpGN8jS0CiCihdBIL/oYi3ceoea2lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-q7PNiwjZO-unIp5WUFv_Zw-1; Fri, 04 Dec 2020 09:00:41 -0500
X-MC-Unique: q7PNiwjZO-unIp5WUFv_Zw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35A9681A33F;
        Fri,  4 Dec 2020 14:00:39 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA43D5C230;
        Fri,  4 Dec 2020 14:00:38 +0000 (UTC)
Date:   Fri, 4 Dec 2020 09:00:36 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: validate feature support when recovering
 rmap/refcount/bmap intents
Message-ID: <20201204140036.GK1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704435080.734470.11175993745850698818.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704435080.734470.11175993745850698818.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:12:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The bmap, rmap, and refcount log intent items were added to support the
> rmap and reflink features.  Because these features come with changes to
> the ondisk format, the log items aren't tied to a log incompat flag.
> 
> However, the log recovery routines don't actually check for those
> feature flags.  The kernel has no business replayng an intent item for a
> feature that isn't enabled, so check that as part of recovered log item
> validation.  (Note that kernels pre-dating rmap and reflink will fail
> the mount on the unknown log item type code.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_item.c     |    4 ++++
>  fs/xfs/xfs_refcount_item.c |    3 +++
>  fs/xfs/xfs_rmap_item.c     |    3 +++
>  3 files changed, 10 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 78346d47564b..4ea9132716c6 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -425,6 +425,10 @@ xfs_bui_validate(
>  {
>  	struct xfs_map_extent		*bmap;
>  
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) &&
> +	    !xfs_sb_version_hasreflink(&mp->m_sb))
> +		return false;
> +

Took me a minute to realize we use the map/unmap for extent swap if rmap
is enabled. That does make me wonder a bit.. had we made this kind of
recovery feature validation change before that came around (such that we
probably would have only checked _hasreflink() here), would we have
created an unnecessary backwards incompatibility?

Brian

>  	/* Only one mapping operation per BUI... */
>  	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
>  		return false;
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 8ad6c81f6d8f..2b28f5643c0b 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -423,6 +423,9 @@ xfs_cui_validate_phys(
>  	struct xfs_mount		*mp,
>  	struct xfs_phys_extent		*refc)
>  {
> +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> +		return false;
> +
>  	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
>  		return false;
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index f296ec349936..2628bc0080fe 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -466,6 +466,9 @@ xfs_rui_validate_map(
>  	struct xfs_mount		*mp,
>  	struct xfs_map_extent		*rmap)
>  {
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		return false;
> +
>  	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
>  		return false;
>  
> 

