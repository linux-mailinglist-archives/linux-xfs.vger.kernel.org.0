Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C998A14E346
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Jan 2020 20:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgA3Tcc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Jan 2020 14:32:32 -0500
Received: from sandeen.net ([63.231.237.45]:59782 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgA3Tcc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Jan 2020 14:32:32 -0500
Received: from Liberator.local (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 808F117DCB;
        Thu, 30 Jan 2020 13:32:31 -0600 (CST)
Subject: Re: [PATCH 1/6] mkfs: check root inode location
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
 <157982505230.2765631.2328249334657581135.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <226f970e-2368-9e68-cb1b-4de92414d043@sandeen.net>
Date:   Thu, 30 Jan 2020 13:32:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <157982505230.2765631.2328249334657581135.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/23/20 6:17 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure the root inode gets created where repair thinks it should be
> created.

Actual mkfs-time location calculation is still completely separate from 
the code in xfs_ialloc_calc_rootino though, right?  Maybe there's nothing
to do about that.

I mostly find myself wondering what a user will do next if this check fails.

Assuming we trust xfs_ialloc_calc_rootino though, this seems fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    1 +
>  mkfs/xfs_mkfs.c          |   39 +++++++++++++++++++++++++++++++++------
>  2 files changed, 34 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index cc7304ad..9ede0125 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -172,6 +172,7 @@
>  
>  #define xfs_ag_init_headers		libxfs_ag_init_headers
>  #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
> +#define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
>  
>  #define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
>  #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 784fe6a9..91a25bf5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3549,6 +3549,38 @@ rewrite_secondary_superblocks(
>  	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>  }
>  
> +static void
> +check_root_ino(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_ino_t		ino;
> +
> +	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
> +		fprintf(stderr,
> +			_("%s: root inode created in AG %u, not AG 0\n"),
> +			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> +		exit(1);
> +	}
> +
> +	/*
> +	 * The superblock points to the root directory inode, but xfs_repair
> +	 * expects to find the root inode in a very specific location computed
> +	 * from the filesystem geometry for an extra level of verification.
> +	 *
> +	 * Fail the format immediately if those assumptions ever break, because
> +	 * repair will toss the root directory.
> +	 */
> +	ino = libxfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
> +	if (mp->m_sb.sb_rootino != ino) {
> +		fprintf(stderr,
> +	_("%s: root inode (%llu) not allocated in expected location (%llu)\n"),
> +			progname,
> +			(unsigned long long)mp->m_sb.sb_rootino,
> +			(unsigned long long)ino);
> +		exit(1);
> +	}
> +}
> +
>  int
>  main(
>  	int			argc,
> @@ -3835,12 +3867,7 @@ main(
>  	/*
>  	 * Protect ourselves against possible stupidity
>  	 */
> -	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
> -		fprintf(stderr,
> -			_("%s: root inode created in AG %u, not AG 0\n"),
> -			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> -		exit(1);
> -	}
> +	check_root_ino(mp);
>  
>  	/*
>  	 * Re-write multiple secondary superblocks with rootinode field set
> 
