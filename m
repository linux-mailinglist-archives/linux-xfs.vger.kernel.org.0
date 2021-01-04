Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03D92E9883
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Jan 2021 16:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbhADP3l (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Jan 2021 10:29:41 -0500
Received: from sandeen.net ([63.231.237.45]:56694 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbhADP3l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jan 2021 10:29:41 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 60FEF1164F;
        Mon,  4 Jan 2021 09:27:38 -0600 (CST)
To:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org
References: <20210104113006.328274-1-zlang@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] mkfs: make inobtcount visible
Message-ID: <3c682608-3ba8-83bb-8d16-49c798e7258c@sandeen.net>
Date:   Mon, 4 Jan 2021 09:28:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210104113006.328274-1-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/4/21 5:30 AM, Zorro Lang wrote:
> When set inobtcount=1/0, we can't see it from xfs geometry report.
> So make it visible.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Hi Zorro - thanks for spotting this.

I think the libxfs changes need to hit the kernel first, then we can
pull it in and fix up the report_geom function.  Nothing calls
xfs_fs_geometry directly in userspace, FWIW.

Thanks,
-Eric

> ---
>  libfrog/fsgeom.c | 6 ++++--
>  libxfs/xfs_fs.h  | 1 +
>  libxfs/xfs_sb.c  | 2 ++
>  3 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index 14507668..c2b5f265 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -29,6 +29,7 @@ xfs_report_geom(
>  	int			rmapbt_enabled;
>  	int			reflink_enabled;
>  	int			bigtime_enabled;
> +	int			inobtcnt_enabled;
>  
>  	isint = geo->logstart > 0;
>  	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
> @@ -45,12 +46,13 @@ xfs_report_geom(
>  	rmapbt_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT ? 1 : 0;
>  	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
>  	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
> +	inobtcnt_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
>  
>  	printf(_(
>  "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
>  "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
>  "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
> -"         =%-22s reflink=%-4u bigtime=%u\n"
> +"         =%-22s reflink=%-4u bigtime=%u, inobtcount=%u\n"
>  "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
>  "         =%-22s sunit=%-6u swidth=%u blks\n"
>  "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
> @@ -60,7 +62,7 @@ xfs_report_geom(
>  		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
>  		"", geo->sectsize, attrversion, projid32bit,
>  		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
> -		"", reflink_enabled, bigtime_enabled,
> +		"", reflink_enabled, bigtime_enabled, inobtcnt_enabled,
>  		"", geo->blocksize, (unsigned long long)geo->datablocks,
>  			geo->imaxpct,
>  		"", geo->sunit, geo->swidth,
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 2a2e3cfd..6fad140d 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
>  #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
>  #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
> +#define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index fb2212b8..a5ab0211 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -1145,6 +1145,8 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
>  	if (xfs_sb_version_hasbigtime(sbp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
> +	if (xfs_sb_version_hasinobtcounts(sbp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
>  	if (xfs_sb_version_hassector(sbp))
>  		geo->logsectsize = sbp->sb_logsectsize;
>  	else
> 
