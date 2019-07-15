Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4952C6882F
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Jul 2019 13:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfGOLaD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 07:30:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729725AbfGOLaD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jul 2019 07:30:03 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B3C7D307D88D
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2019 11:30:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 584C86013B;
        Mon, 15 Jul 2019 11:30:00 +0000 (UTC)
Date:   Mon, 15 Jul 2019 07:29:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: move xfs_trans_inode.c to libxfs/
Message-ID: <20190715112958.GA23406@bfoster>
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
 <eb65b33a-1104-6be9-530b-390a050b831e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb65b33a-1104-6be9-530b-390a050b831e@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 15 Jul 2019 11:30:03 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 12, 2019 at 12:44:48PM -0500, Eric Sandeen wrote:
> Userspace now has an identical xfs_trans_inode.c which it has already
> moved to libxfs/ so do the same move for kernelspace.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index b74a47169297..06b68b6115bc 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -49,6 +49,7 @@ xfs-y				+= $(addprefix libxfs/, \
>  				   xfs_refcount_btree.o \
>  				   xfs_sb.o \
>  				   xfs_symlink_remote.o \
> +				   xfs_trans_inode.o \
>  				   xfs_trans_resv.o \
>  				   xfs_types.o \
>  				   )
> @@ -107,8 +108,7 @@ xfs-y				+= xfs_log.o \
>  				   xfs_rmap_item.o \
>  				   xfs_log_recover.o \
>  				   xfs_trans_ail.o \
> -				   xfs_trans_buf.o \
> -				   xfs_trans_inode.o
> +				   xfs_trans_buf.o
>  
>  # optional features
>  xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> similarity index 100%
> rename from fs/xfs/xfs_trans_inode.c
> rename to fs/xfs/libxfs/xfs_trans_inode.c
> 
