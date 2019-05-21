Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022F125597
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfEUQax (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 12:30:53 -0400
Received: from sandeen.net ([63.231.237.45]:58850 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfEUQax (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 12:30:53 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4DA27325F;
        Tue, 21 May 2019 11:30:49 -0500 (CDT)
Subject: Re: [PATCH 01/12] libxfs: fix attr include mess
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839420721.68606.5873005194118073203.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <6f6804b1-9f23-a0b3-515d-f74f09db3ada@sandeen.net>
Date:   Tue, 21 May 2019 11:30:52 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <155839420721.68606.5873005194118073203.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/20/19 6:16 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove all the userspace xfs_attr shim cruft so that we have one
> definition of ATTR_* macros so that we can actually use xfs_attr.c
> routines and include xfs_attr.h without problems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

<handwaves about namespace for flag #defines ok sure>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/libxfs.h         |   10 +---------
>  libxfs/libxfs_api_defs.h |    5 +++++
>  libxfs/libxfs_priv.h     |    8 --------
>  libxfs/xfs_attr.c        |    1 +
>  libxfs/xfs_attr_leaf.c   |    1 +
>  5 files changed, 8 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 230bc3e8..dd5fe542 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -211,14 +211,6 @@ libxfs_bmbt_disk_get_all(
>  int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
>  bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
>  
> -/* XXX: need parts of xfs_attr.h in userspace */
> -#define LIBXFS_ATTR_ROOT	0x0002	/* use attrs in root namespace */
> -#define LIBXFS_ATTR_SECURE	0x0008	/* use attrs in security namespace */
> -#define LIBXFS_ATTR_CREATE	0x0010	/* create, but fail if attr exists */
> -#define LIBXFS_ATTR_REPLACE	0x0020	/* set, but fail if attr not exists */
> -
> -int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
> -int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
> -		 unsigned char *value, int valuelen, int flags);
> +#include "xfs_attr.h"
>  
>  #endif	/* __LIBXFS_H__ */
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 1150ec93..34bb552d 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -144,4 +144,9 @@
>  #define xfs_fs_geometry			libxfs_fs_geometry
>  #define xfs_init_local_fork		libxfs_init_local_fork
>  
> +#define LIBXFS_ATTR_ROOT		ATTR_ROOT
> +#define LIBXFS_ATTR_SECURE		ATTR_SECURE
> +#define LIBXFS_ATTR_CREATE		ATTR_CREATE
> +#define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
> +
>  #endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index d668a157..f60bff06 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -104,14 +104,6 @@ extern char    *progname;
>   */
>  #define PTR_FMT "%p"
>  
> -/* XXX: need to push these out to make LIBXFS_ATTR defines */
> -#define ATTR_ROOT			0x0002
> -#define ATTR_SECURE			0x0008
> -#define ATTR_CREATE			0x0010
> -#define ATTR_REPLACE			0x0020
> -#define ATTR_KERNOTIME			0
> -#define ATTR_KERNOVAL			0
> -
>  #define XFS_IGET_CREATE			0x1
>  #define XFS_IGET_UNTRUSTED		0x2
>  
> diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
> index b8838302..170e64cf 100644
> --- a/libxfs/xfs_attr.c
> +++ b/libxfs/xfs_attr.c
> @@ -20,6 +20,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_attr_remote.h"
>  #include "xfs_trans_space.h"
> diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
> index 679c7d0d..1027ca01 100644
> --- a/libxfs/xfs_attr_leaf.c
> +++ b/libxfs/xfs_attr_leaf.c
> @@ -21,6 +21,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_attr_sf.h"
>  #include "xfs_attr_remote.h"
> +#include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_trace.h"
>  #include "xfs_cksum.h"
> 
