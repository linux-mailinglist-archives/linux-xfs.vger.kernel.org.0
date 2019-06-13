Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5989F4433F
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 18:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388905AbfFMQ2M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 12:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390780AbfFMQ1U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jun 2019 12:27:20 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5446F3004159;
        Thu, 13 Jun 2019 16:27:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F264B4128;
        Thu, 13 Jun 2019 16:27:19 +0000 (UTC)
Date:   Thu, 13 Jun 2019 12:27:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: remove unnecessary includes of xfs_itable.h
Message-ID: <20190613162715.GC21773@bfoster>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
 <156032208315.3774243.12030637267920512012.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156032208315.3774243.12030637267920512012.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 13 Jun 2019 16:27:20 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 11:48:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't include xfs_itable.h in files that don't need it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/common.c |    1 -
>  fs/xfs/scrub/dir.c    |    1 -
>  fs/xfs/scrub/scrub.c  |    1 -
>  fs/xfs/xfs_trace.c    |    1 -
>  4 files changed, 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 973aa59975e3..561d7e818e8b 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -17,7 +17,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
> -#include "xfs_itable.h"
>  #include "xfs_alloc.h"
>  #include "xfs_alloc_btree.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index a38a22785a1a..9018ca4aba64 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -17,7 +17,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
> -#include "xfs_itable.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index f630389ee176..5689a33e999c 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -17,7 +17,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
> -#include "xfs_itable.h"
>  #include "xfs_alloc.h"
>  #include "xfs_alloc_btree.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index cb6489c22cad..f555a3c560b9 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -16,7 +16,6 @@
>  #include "xfs_btree.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_ialloc.h"
> -#include "xfs_itable.h"
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr.h"
> 
