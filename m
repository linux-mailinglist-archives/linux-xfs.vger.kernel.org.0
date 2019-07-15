Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD70068831
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Jul 2019 13:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbfGOLaM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 07:30:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729725AbfGOLaM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jul 2019 07:30:12 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C80630842AF
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2019 11:30:12 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 234345D705;
        Mon, 15 Jul 2019 11:30:09 +0000 (UTC)
Date:   Mon, 15 Jul 2019 07:30:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: sync up xfs_trans_inode with userspace
Message-ID: <20190715113007.GB23406@bfoster>
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
 <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 15 Jul 2019 11:30:12 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 12, 2019 at 12:46:17PM -0500, Eric Sandeen wrote:
> Add an XFS_ICHGTIME_CREATE case to xfs_trans_ichgtime() to keep in
> sync with userspace.  (Currently no kernel caller sends this flag.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 93d14e47269d..a9ad90926b87 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -66,6 +66,10 @@ xfs_trans_ichgtime(
>  		inode->i_mtime = tv;
>  	if (flags & XFS_ICHGTIME_CHG)
>  		inode->i_ctime = tv;
> +	if (flags & XFS_ICHGTIME_CREATE) {
> +		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> +		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> +	}

Could we add a "for libxfs" or some such one liner comment to this so
long as this is unused in the kernel? With that:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  }
>  
>  /*
> 
> 
