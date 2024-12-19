Return-Path: <linux-xfs+bounces-17132-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5344F9F8209
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 18:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7D657A1F63
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 17:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D551A08CA;
	Thu, 19 Dec 2024 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+IZFrwy"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4794216CD1D;
	Thu, 19 Dec 2024 17:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629776; cv=none; b=WRwI3oNtJ7g9/RKJFad8xR66vGpzuHjYenoidMZG9TF51RYzLUKTyjxnbh5swrW11A2zcMx6ygTeek4GM7ki9isFJK3S3DF+ZLSHe7cFykNzFwSx4Yn9e2jc8DWNjhhixAp1bsducyZKO9KsPuZpAQuBnoHzjU/uRlmfGo4FMaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629776; c=relaxed/simple;
	bh=v8sOdf72n3AByQGR+xQea8Gzlyv2wzKICda1OgTRDZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WIhCtBoDv7C+O7ylBmm5B05jryPPxTWrgsFsdQKiqIfcosrTUTeEU1/ah9pmQpASOuKmxpShUvYrvuXBEpziNX6VmeFrT6exmy79nWZutpBtmfjjKr0STidp5sBusBQGDnqmpcEAkoTdV3M5Na2o6mh1/FETI3N3suODrFpw96w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+IZFrwy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92C6C4CECE;
	Thu, 19 Dec 2024 17:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629775;
	bh=v8sOdf72n3AByQGR+xQea8Gzlyv2wzKICda1OgTRDZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m+IZFrwyO5wVnfFsUHB/htsWCi1Ys9fh3RAHclAAMH8t0q8k8ejJZM9mMvWnTznXA
	 U8KKj1u+7SwSpTUcrnHix1ofKX6heZtuwAprhyJqFr91811UF3TUPWU7sKqLrXCwSi
	 FJN9Tw/BnBN1nkXAzVsyLVorzt3K9q1SNxDGwCuBvlMVn+UsJTdwFqzN0uX9x/CGJE
	 ZwOziPMAZalS23skoyq5DAef/inh4pGDQDim7fNeMGsSYaxKzXaDz1NYrfEm8Z3dwF
	 XVg7Md+ijazmBMVp+weGlxG5Vfc2psIfJC2MOSUfDu5S3rCMoLczaPTxMWvJXnyeIa
	 Im7J9pMDf6JWA==
Date: Thu, 19 Dec 2024 09:36:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, flyingpeng@tencent.com,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH] xfs: using mutex instead of semaphore for xfs_buf_lock()
Message-ID: <20241219173615.GL6174@frogsfrogsfrogs>
References: <20241219171629.73327-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241219171629.73327-1-alexjlzheng@tencent.com>

On Fri, Dec 20, 2024 at 01:16:29AM +0800, Jinliang Zheng wrote:
> xfs_buf uses a semaphore for mutual exclusion, and its count value
> is initialized to 1, which is equivalent to a mutex.
> 
> However, mutex->owner can provide more information when analyzing
> vmcore, making it easier for us to identify which task currently
> holds the lock.

Does XFS pass buffers between tasks?  xfs_btree_split has that whole
blob of ugly code where it can pass a locked inode and transaction to a
workqueue function to avoid overrunning the kernel stack.

--D

> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
>  fs/xfs/xfs_buf.c   |  9 +++++----
>  fs/xfs/xfs_buf.h   |  4 ++--
>  fs/xfs/xfs_trace.h | 25 +++++--------------------
>  3 files changed, 12 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index aa4dbda7b536..7c59d7905ea1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -243,7 +243,8 @@ _xfs_buf_alloc(
>  	INIT_LIST_HEAD(&bp->b_lru);
>  	INIT_LIST_HEAD(&bp->b_list);
>  	INIT_LIST_HEAD(&bp->b_li_list);
> -	sema_init(&bp->b_sema, 0); /* held, no waiters */
> +	mutex_init(&bp->b_mutex);
> +	mutex_lock(&bp->b_mutex); /* held, no waiters */
>  	spin_lock_init(&bp->b_lock);
>  	bp->b_target = target;
>  	bp->b_mount = target->bt_mount;
> @@ -1168,7 +1169,7 @@ xfs_buf_trylock(
>  {
>  	int			locked;
>  
> -	locked = down_trylock(&bp->b_sema) == 0;
> +	locked = mutex_trylock(&bp->b_mutex);
>  	if (locked)
>  		trace_xfs_buf_trylock(bp, _RET_IP_);
>  	else
> @@ -1193,7 +1194,7 @@ xfs_buf_lock(
>  
>  	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
>  		xfs_log_force(bp->b_mount, 0);
> -	down(&bp->b_sema);
> +	mutex_lock(&bp->b_mutex);
>  
>  	trace_xfs_buf_lock_done(bp, _RET_IP_);
>  }
> @@ -1204,7 +1205,7 @@ xfs_buf_unlock(
>  {
>  	ASSERT(xfs_buf_islocked(bp));
>  
> -	up(&bp->b_sema);
> +	mutex_unlock(&bp->b_mutex);
>  	trace_xfs_buf_unlock(bp, _RET_IP_);
>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index b1580644501f..2c48e388d451 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -171,7 +171,7 @@ struct xfs_buf {
>  	atomic_t		b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
>  	xfs_buf_flags_t		b_flags;	/* status flags */
> -	struct semaphore	b_sema;		/* semaphore for lockables */
> +	struct mutex		b_mutex;	/* mutex for lockables */
>  
>  	/*
>  	 * concurrent access to b_lru and b_lru_flags are protected by
> @@ -304,7 +304,7 @@ extern int xfs_buf_trylock(struct xfs_buf *);
>  extern void xfs_buf_lock(struct xfs_buf *);
>  extern void xfs_buf_unlock(struct xfs_buf *);
>  #define xfs_buf_islocked(bp) \
> -	((bp)->b_sema.count <= 0)
> +	mutex_is_locked(&(bp)->b_mutex)
>  
>  static inline void xfs_buf_relse(struct xfs_buf *bp)
>  {
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 180ce697305a..ba6c003b82af 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -443,7 +443,6 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
>  		__field(int, nblks)
>  		__field(int, hold)
>  		__field(int, pincount)
> -		__field(unsigned, lockval)
>  		__field(unsigned, flags)
>  		__field(unsigned long, caller_ip)
>  		__field(const void *, buf_ops)
> @@ -454,19 +453,17 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
>  		__entry->nblks = bp->b_length;
>  		__entry->hold = atomic_read(&bp->b_hold);
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
> -		__entry->lockval = bp->b_sema.count;
>  		__entry->flags = bp->b_flags;
>  		__entry->caller_ip = caller_ip;
>  		__entry->buf_ops = bp->b_ops;
>  	),
>  	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
> -		  "lock %d flags %s bufops %pS caller %pS",
> +		  "flags %s bufops %pS caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->bno,
>  		  __entry->nblks,
>  		  __entry->hold,
>  		  __entry->pincount,
> -		  __entry->lockval,
>  		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
>  		  __entry->buf_ops,
>  		  (void *)__entry->caller_ip)
> @@ -514,7 +511,6 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
>  		__field(unsigned int, length)
>  		__field(int, hold)
>  		__field(int, pincount)
> -		__field(unsigned, lockval)
>  		__field(unsigned, flags)
>  		__field(unsigned long, caller_ip)
>  	),
> @@ -525,17 +521,15 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
>  		__entry->flags = flags;
>  		__entry->hold = atomic_read(&bp->b_hold);
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
> -		__entry->lockval = bp->b_sema.count;
>  		__entry->caller_ip = caller_ip;
>  	),
>  	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
> -		  "lock %d flags %s caller %pS",
> +		  "flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->bno,
>  		  __entry->length,
>  		  __entry->hold,
>  		  __entry->pincount,
> -		  __entry->lockval,
>  		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
>  		  (void *)__entry->caller_ip)
>  )
> @@ -558,7 +552,6 @@ TRACE_EVENT(xfs_buf_ioerror,
>  		__field(unsigned, flags)
>  		__field(int, hold)
>  		__field(int, pincount)
> -		__field(unsigned, lockval)
>  		__field(int, error)
>  		__field(xfs_failaddr_t, caller_ip)
>  	),
> @@ -568,19 +561,17 @@ TRACE_EVENT(xfs_buf_ioerror,
>  		__entry->length = bp->b_length;
>  		__entry->hold = atomic_read(&bp->b_hold);
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
> -		__entry->lockval = bp->b_sema.count;
>  		__entry->error = error;
>  		__entry->flags = bp->b_flags;
>  		__entry->caller_ip = caller_ip;
>  	),
>  	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
> -		  "lock %d error %d flags %s caller %pS",
> +		  "error %d flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->bno,
>  		  __entry->length,
>  		  __entry->hold,
>  		  __entry->pincount,
> -		  __entry->lockval,
>  		  __entry->error,
>  		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
>  		  (void *)__entry->caller_ip)
> @@ -595,7 +586,6 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__field(unsigned int, buf_len)
>  		__field(int, buf_hold)
>  		__field(int, buf_pincount)
> -		__field(int, buf_lockval)
>  		__field(unsigned, buf_flags)
>  		__field(unsigned, bli_recur)
>  		__field(int, bli_refcount)
> @@ -612,18 +602,16 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__entry->buf_flags = bip->bli_buf->b_flags;
>  		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
>  		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
> -		__entry->buf_lockval = bip->bli_buf->b_sema.count;
>  		__entry->li_flags = bip->bli_item.li_flags;
>  	),
>  	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
> -		  "lock %d flags %s recur %d refcount %d bliflags %s "
> +		  "flags %s recur %d refcount %d bliflags %s "
>  		  "liflags %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long long)__entry->buf_bno,
>  		  __entry->buf_len,
>  		  __entry->buf_hold,
>  		  __entry->buf_pincount,
> -		  __entry->buf_lockval,
>  		  __print_flags(__entry->buf_flags, "|", XFS_BUF_FLAGS),
>  		  __entry->bli_recur,
>  		  __entry->bli_refcount,
> @@ -4802,7 +4790,6 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
>  		__field(int, nblks)
>  		__field(int, hold)
>  		__field(int, pincount)
> -		__field(unsigned int, lockval)
>  		__field(unsigned int, flags)
>  	),
>  	TP_fast_assign(
> @@ -4811,16 +4798,14 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
>  		__entry->nblks = bp->b_length;
>  		__entry->hold = atomic_read(&bp->b_hold);
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
> -		__entry->lockval = bp->b_sema.count;
>  		__entry->flags = bp->b_flags;
>  	),
> -	TP_printk("xfino 0x%lx daddr 0x%llx bbcount 0x%x hold %d pincount %d lock %d flags %s",
> +	TP_printk("xfino 0x%lx daddr 0x%llx bbcount 0x%x hold %d pincount %d flags %s",
>  		  __entry->xfino,
>  		  (unsigned long long)__entry->bno,
>  		  __entry->nblks,
>  		  __entry->hold,
>  		  __entry->pincount,
> -		  __entry->lockval,
>  		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS))
>  )
>  
> -- 
> 2.41.1
> 
> 

