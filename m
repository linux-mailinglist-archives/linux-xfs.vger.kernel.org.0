Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B342201E2
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jul 2020 03:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgGOBaP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 21:30:15 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36559 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727863AbgGOBaP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:30:15 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D322082343E;
        Wed, 15 Jul 2020 11:30:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jvWFM-0001mz-Mi; Wed, 15 Jul 2020 11:30:08 +1000
Date:   Wed, 15 Jul 2020 11:30:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fs/direct-io: avoid data race on ->s_dio_done_wq
Message-ID: <20200715013008.GD2005@dread.disaster.area>
References: <20200713033330.205104-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713033330.205104-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=1XWaLZrsAAAA:8 a=7-415B0cAAAA:8
        a=J4IdXHwxHjXuEvTYv6sA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 12, 2020 at 08:33:30PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Fix the preliminary checks for ->s_dio_done_wq to use READ_ONCE(), since
> it's a data race, and technically the behavior is undefined without
> READ_ONCE().  Also, on one CPU architecture (Alpha), the data read
> dependency barrier included in READ_ONCE() is needed to guarantee that
> the pointed-to struct is seen as fully initialized.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/direct-io.c       | 8 +++-----
>  fs/internal.h        | 9 ++++++++-
>  fs/iomap/direct-io.c | 3 +--
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 6d5370eac2a8..26221ae24156 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -590,7 +590,7 @@ static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
>   * filesystems that don't need it and also allows us to create the workqueue
>   * late enough so the we can include s_id in the name of the workqueue.
>   */
> -int sb_init_dio_done_wq(struct super_block *sb)
> +int __sb_init_dio_done_wq(struct super_block *sb)
>  {
>  	struct workqueue_struct *old;
>  	struct workqueue_struct *wq = alloc_workqueue("dio/%s",
> @@ -615,9 +615,7 @@ static int dio_set_defer_completion(struct dio *dio)
>  	if (dio->defer_completion)
>  		return 0;
>  	dio->defer_completion = true;
> -	if (!sb->s_dio_done_wq)
> -		return sb_init_dio_done_wq(sb);
> -	return 0;
> +	return sb_init_dio_done_wq(sb);
>  }
>  
>  /*
> @@ -1250,7 +1248,7 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
>  		retval = 0;
>  		if (iocb->ki_flags & IOCB_DSYNC)
>  			retval = dio_set_defer_completion(dio);
> -		else if (!dio->inode->i_sb->s_dio_done_wq) {
> +		else {
>  			/*
>  			 * In case of AIO write racing with buffered read we
>  			 * need to defer completion. We can't decide this now,
> diff --git a/fs/internal.h b/fs/internal.h
> index 9b863a7bd708..6736c9eee978 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -178,7 +178,14 @@ extern void mnt_pin_kill(struct mount *m);
>  extern const struct dentry_operations ns_dentry_operations;
>  
>  /* direct-io.c: */
> -int sb_init_dio_done_wq(struct super_block *sb);
> +int __sb_init_dio_done_wq(struct super_block *sb);
> +static inline int sb_init_dio_done_wq(struct super_block *sb)
> +{
> +	/* pairs with cmpxchg() in __sb_init_dio_done_wq() */
> +	if (likely(READ_ONCE(sb->s_dio_done_wq)))
> +		return 0;
> +	return __sb_init_dio_done_wq(sb);
> +}

Ummm, why don't you just add this check in sb_init_dio_done_wq(). I
don't see any need for adding another level of function call
abstraction in the source code?

Also, you need to explain the reason for the READ_ONCE() existing
rather than just saying "it pairs with <some other operation>".
Knowing what operation it pairs with doesn't explain why the pairing
is necessary in the first place, and that leads to nobody reading
the code being able to understand what this is protecting against.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
