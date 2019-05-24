Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4C12982A
	for <lists+linux-xfs@lfdr.de>; Fri, 24 May 2019 14:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389057AbfEXMjL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 May 2019 08:39:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48252 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390781AbfEXMjK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 May 2019 08:39:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4CB069B37C;
        Fri, 24 May 2019 12:39:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EAF0E10027B9;
        Fri, 24 May 2019 12:39:06 +0000 (UTC)
Date:   Fri, 24 May 2019 08:39:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix broken log reservation debugging
Message-ID: <20190524123904.GA33461@bfoster>
References: <20190523160219.GH5141@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523160219.GH5141@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 24 May 2019 12:39:10 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 09:02:19AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xlog_print_tic_res() is supposed to print a human readable string for
> each element of the log ticket reservation array.  Unfortunately, I
> forgot to update the string array when we added rmap & reflink support,
> so the debug message prints "region[3]: (null) - 352 bytes" which isn't
> useful at all.  Add the missing elements and add a build check so that
> we don't forget again to add a string when adding a new XLOG_REG_TYPE.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 457ced3ee3e1..2466b0f5b6c4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2069,7 +2069,7 @@ xlog_print_tic_res(
>  
>  	/* match with XLOG_REG_TYPE_* in xfs_log.h */
>  #define REG_TYPE_STR(type, str)	[XLOG_REG_TYPE_##type] = str
> -	static char *res_type_str[XLOG_REG_TYPE_MAX + 1] = {
> +	static char *res_type_str[] = {
>  	    REG_TYPE_STR(BFORMAT, "bformat"),
>  	    REG_TYPE_STR(BCHUNK, "bchunk"),
>  	    REG_TYPE_STR(EFI_FORMAT, "efi_format"),
> @@ -2089,8 +2089,15 @@ xlog_print_tic_res(
>  	    REG_TYPE_STR(UNMOUNT, "unmount"),
>  	    REG_TYPE_STR(COMMIT, "commit"),
>  	    REG_TYPE_STR(TRANSHDR, "trans header"),
> -	    REG_TYPE_STR(ICREATE, "inode create")
> +	    REG_TYPE_STR(ICREATE, "inode create"),
> +	    REG_TYPE_STR(RUI_FORMAT, "rui_format"),
> +	    REG_TYPE_STR(RUD_FORMAT, "rud_format"),
> +	    REG_TYPE_STR(CUI_FORMAT, "cui_format"),
> +	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
> +	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
> +	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
>  	};
> +	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>  #undef REG_TYPE_STR
>  
>  	xfs_warn(mp, "ticket reservation summary:");
