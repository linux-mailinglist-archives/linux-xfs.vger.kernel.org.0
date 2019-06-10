Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF8B3B69C
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390634AbfFJN7G (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 09:59:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390587AbfFJN7G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jun 2019 09:59:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 460A136887;
        Mon, 10 Jun 2019 13:59:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2F4C60A35;
        Mon, 10 Jun 2019 13:59:05 +0000 (UTC)
Date:   Mon, 10 Jun 2019 09:59:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: bulkstat should copy lastip whenever
 userspace supplies one
Message-ID: <20190610135901.GC6473@bfoster>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968498711.1657646.16552958514650953190.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968498711.1657646.16552958514650953190.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 10 Jun 2019 13:59:06 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:49:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When userspace passes in a @lastip pointer we should copy the results
> back, even if the @ocount pointer is NULL.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c   |   13 ++++++-------
>  fs/xfs/xfs_ioctl32.c |   13 ++++++-------
>  2 files changed, 12 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d7dfc13f30f5..5ffbdcff3dba 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -768,14 +768,13 @@ xfs_ioc_bulkstat(
>  	if (error)
>  		return error;
>  
> -	if (bulkreq.ocount != NULL) {
> -		if (copy_to_user(bulkreq.lastip, &inlast,
> -						sizeof(xfs_ino_t)))
> -			return -EFAULT;
> +	if (bulkreq.lastip != NULL &&
> +	    copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
> +		return -EFAULT;
>  
> -		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
> -			return -EFAULT;
> -	}
> +	if (bulkreq.ocount != NULL &&
> +	    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
> +		return -EFAULT;
>  
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 614fc6886d24..814ffe6fbab7 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -310,14 +310,13 @@ xfs_compat_ioc_bulkstat(
>  	if (error)
>  		return error;
>  
> -	if (bulkreq.ocount != NULL) {
> -		if (copy_to_user(bulkreq.lastip, &inlast,
> -						sizeof(xfs_ino_t)))
> -			return -EFAULT;
> +	if (bulkreq.lastip != NULL &&
> +	    copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
> +		return -EFAULT;
>  
> -		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
> -			return -EFAULT;
> -	}
> +	if (bulkreq.ocount != NULL &&
> +	    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
> +		return -EFAULT;
>  
>  	return 0;
>  }
> 
