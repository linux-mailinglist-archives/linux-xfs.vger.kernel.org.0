Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4982876D5
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Oct 2020 17:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgJHPMD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Oct 2020 11:12:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53404 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730832AbgJHPMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 11:12:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098FAIY2167926;
        Thu, 8 Oct 2020 15:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gysNr+snY49uFAwskjyxunO1ujLGz/B/PKydvM/NbJo=;
 b=kCa6sy5GC6kBeZf0u7aUrn8d8aDyoSA8NLGQkY0QsOK57hJxWmMPz7ubNK8MbeuMHDza
 fwnUnjTgJpcqZ3WMzqEegRtV5AB/1GKIhGJUQbAdZvBQmZLpxhJKxMnOKSdfM1FKF+Yh
 NoVkluQskWw6JK726KHDAg5ZRnSQ10UpD7Xjl3Mepqd+Hjl6+THhGuJeMigjClYGs0wO
 mIDkisJXhfSKnkNTiQXQ4NwCAXELryykozXCUQfjI7E1j0Fb4dPf2+F/PsI+MIQDGyiF
 EVcyejEwyMrBDRxV0s3/ZdytzL6JJBbZsiQ5mSlGEZMwefbcs8Ku4iI5/a6rQG5VAX3k KQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetb8eek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 15:11:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098FBMBv118370;
        Thu, 8 Oct 2020 15:11:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vr5th6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 15:11:58 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098FBw6O008988;
        Thu, 8 Oct 2020 15:11:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 08:11:57 -0700
Date:   Thu, 8 Oct 2020 08:11:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v10 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201008151157.GO6540@magnolia>
References: <20201008134605.863269-1-preichl@redhat.com>
 <20201008134605.863269-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008134605.863269-5-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=2 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=2 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080116
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 08, 2020 at 03:46:05PM +0200, Pavel Reichl wrote:
> Remove mrlock_t as it does not provide any extra value over
> rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
> replace mr*() functions with native rwsem calls.
> 
> Release the lock in xfs_btree_split() just before the work-queue
> executing xfs_btree_split_worker() is scheduled and make
> xfs_btree_split_worker() to acquire the lock as a first thing and
> release it just before returning from the function. This it done so the
> ownership of the lock is transfered between kernel threads and thus
> lockdep won't complain about lock being held by a different kernel
> thread.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks reasonable, let's see how this fares w/ testing...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_btree.c | 24 ++++++++++++
>  fs/xfs/mrlock.h           | 78 ---------------------------------------
>  fs/xfs/xfs_inode.c        | 50 +++++++++++++------------
>  fs/xfs/xfs_inode.h        |  4 +-
>  fs/xfs/xfs_iops.c         |  4 +-
>  fs/xfs/xfs_linux.h        |  2 +-
>  fs/xfs/xfs_super.c        |  6 +--
>  7 files changed, 57 insertions(+), 111 deletions(-)
>  delete mode 100644 fs/xfs/mrlock.h
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2d25bab68764..d1fdb180f7ae 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2816,6 +2816,12 @@ xfs_btree_split_worker(
>  	unsigned long		pflags;
>  	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
>  
> +	/*
> +	 * Update lockdep's lock ownership information to point to
> +	 * this thread as the thread that scheduled this worker is waiting
> +	 * for its completion.
> +	 */
> +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
>  	/*
>  	 * we are in a transaction context here, but may also be doing work
>  	 * in kswapd context, and hence we may need to inherit that state
> @@ -2829,6 +2835,12 @@ xfs_btree_split_worker(
>  
>  	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>  					 args->key, args->curp, args->stat);
> +	/*
> +	 * Update lockdep's lock ownership information to reflect that we will
> +	 * be transferring the ilock from this worker back to the scheduling
> +	 * thread.
> +	 */
> +	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>  	complete(args->done);
>  
>  	current_restore_flags_nested(&pflags, new_pflags);
> @@ -2863,8 +2875,20 @@ xfs_btree_split(
>  	args.done = &done;
>  	args.kswapd = current_is_kswapd();
>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
> +	/*
> +	 * Update lockdep's ownership information to reflect that we
> +	 * will be transferring the ilock from this thread to the
> +	 * worker.
> +	 */
> +	rwsem_release(&cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>  	queue_work(xfs_alloc_wq, &args.work);
>  	wait_for_completion(&done);
> +	/*
> +	 * Update lockdep's lock ownership information to point to
> +	 * this thread as the lock owner now that the worker item is
> +	 * done.
> +	 */
> +	rwsem_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
>  	destroy_work_on_stack(&args.work);
>  	return args.result;
>  }
> diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
> deleted file mode 100644
> index 79155eec341b..000000000000
> --- a/fs/xfs/mrlock.h
> +++ /dev/null
> @@ -1,78 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - */
> -#ifndef __XFS_SUPPORT_MRLOCK_H__
> -#define __XFS_SUPPORT_MRLOCK_H__
> -
> -#include <linux/rwsem.h>
> -
> -typedef struct {
> -	struct rw_semaphore	mr_lock;
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	int			mr_writer;
> -#endif
> -} mrlock_t;
> -
> -#if defined(DEBUG) || defined(XFS_WARN)
> -#define mrinit(mrp, name)	\
> -	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
> -#else
> -#define mrinit(mrp, name)	\
> -	do { init_rwsem(&(mrp)->mr_lock); } while (0)
> -#endif
> -
> -#define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
> -#define mrfree(mrp)		do { } while (0)
> -
> -static inline void mraccess_nested(mrlock_t *mrp, int subclass)
> -{
> -	down_read_nested(&mrp->mr_lock, subclass);
> -}
> -
> -static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
> -{
> -	down_write_nested(&mrp->mr_lock, subclass);
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	mrp->mr_writer = 1;
> -#endif
> -}
> -
> -static inline int mrtryaccess(mrlock_t *mrp)
> -{
> -	return down_read_trylock(&mrp->mr_lock);
> -}
> -
> -static inline int mrtryupdate(mrlock_t *mrp)
> -{
> -	if (!down_write_trylock(&mrp->mr_lock))
> -		return 0;
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	mrp->mr_writer = 1;
> -#endif
> -	return 1;
> -}
> -
> -static inline void mrunlock_excl(mrlock_t *mrp)
> -{
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	mrp->mr_writer = 0;
> -#endif
> -	up_write(&mrp->mr_lock);
> -}
> -
> -static inline void mrunlock_shared(mrlock_t *mrp)
> -{
> -	up_read(&mrp->mr_lock);
> -}
> -
> -static inline void mrdemote(mrlock_t *mrp)
> -{
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	mrp->mr_writer = 0;
> -#endif
> -	downgrade_write(&mrp->mr_lock);
> -}
> -
> -#endif /* __XFS_SUPPORT_MRLOCK_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index a3baec1c5bcf..213a4a947854 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -191,14 +191,15 @@ xfs_ilock(
>  	}
>  
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrupdate_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
> +		down_write_nested(&ip->i_mmaplock,
> +				XFS_MMAPLOCK_DEP(lock_flags));
>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
> -		mraccess_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
> +		down_read_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
>  
>  	if (lock_flags & XFS_ILOCK_EXCL)
> -		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
> +		down_write_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>  	else if (lock_flags & XFS_ILOCK_SHARED)
> -		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
> +		down_read_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>  }
>  
>  /*
> @@ -242,27 +243,27 @@ xfs_ilock_nowait(
>  	}
>  
>  	if (lock_flags & XFS_MMAPLOCK_EXCL) {
> -		if (!mrtryupdate(&ip->i_mmaplock))
> +		if (!down_write_trylock(&ip->i_mmaplock))
>  			goto out_undo_iolock;
>  	} else if (lock_flags & XFS_MMAPLOCK_SHARED) {
> -		if (!mrtryaccess(&ip->i_mmaplock))
> +		if (!down_read_trylock(&ip->i_mmaplock))
>  			goto out_undo_iolock;
>  	}
>  
>  	if (lock_flags & XFS_ILOCK_EXCL) {
> -		if (!mrtryupdate(&ip->i_lock))
> +		if (!down_write_trylock(&ip->i_lock))
>  			goto out_undo_mmaplock;
>  	} else if (lock_flags & XFS_ILOCK_SHARED) {
> -		if (!mrtryaccess(&ip->i_lock))
> +		if (!down_read_trylock(&ip->i_lock))
>  			goto out_undo_mmaplock;
>  	}
>  	return 1;
>  
>  out_undo_mmaplock:
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrunlock_excl(&ip->i_mmaplock);
> +		up_write(&ip->i_mmaplock);
>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
> -		mrunlock_shared(&ip->i_mmaplock);
> +		up_read(&ip->i_mmaplock);
>  out_undo_iolock:
>  	if (lock_flags & XFS_IOLOCK_EXCL)
>  		up_write(&VFS_I(ip)->i_rwsem);
> @@ -309,14 +310,14 @@ xfs_iunlock(
>  		up_read(&VFS_I(ip)->i_rwsem);
>  
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrunlock_excl(&ip->i_mmaplock);
> +		up_write(&ip->i_mmaplock);
>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
> -		mrunlock_shared(&ip->i_mmaplock);
> +		up_read(&ip->i_mmaplock);
>  
>  	if (lock_flags & XFS_ILOCK_EXCL)
> -		mrunlock_excl(&ip->i_lock);
> +		up_write(&ip->i_lock);
>  	else if (lock_flags & XFS_ILOCK_SHARED)
> -		mrunlock_shared(&ip->i_lock);
> +		up_read(&ip->i_lock);
>  
>  	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
>  }
> @@ -335,9 +336,9 @@ xfs_ilock_demote(
>  		~(XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
>  
>  	if (lock_flags & XFS_ILOCK_EXCL)
> -		mrdemote(&ip->i_lock);
> +		downgrade_write(&ip->i_lock);
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrdemote(&ip->i_mmaplock);
> +		downgrade_write(&ip->i_mmaplock);
>  	if (lock_flags & XFS_IOLOCK_EXCL)
>  		downgrade_write(&VFS_I(ip)->i_rwsem);
>  
> @@ -384,16 +385,17 @@ xfs_isilocked(
>  	struct xfs_inode	*ip,
>  	uint			lock_flags)
>  {
> -	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> -		if (!(lock_flags & XFS_ILOCK_SHARED))
> -			return !!ip->i_lock.mr_writer;
> -		return rwsem_is_locked(&ip->i_lock.mr_lock);
> +	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
> +		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
> +		return __xfs_rwsem_islocked(&ip->i_lock,
> +				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
>  	}
>  
> -	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> -		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> -			return !!ip->i_mmaplock.mr_writer;
> -		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> +	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
> +		ASSERT(!(lock_flags &
> +			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
> +		return __xfs_rwsem_islocked(&ip->i_mmaplock,
> +				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
>  	}
>  
>  	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 77d5655191ab..02c98ecfe4c5 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -39,8 +39,8 @@ typedef struct xfs_inode {
>  
>  	/* Transaction and locking information. */
>  	struct xfs_inode_log_item *i_itemp;	/* logging information */
> -	mrlock_t		i_lock;		/* inode lock */
> -	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
> +	struct rw_semaphore	i_lock;		/* inode lock */
> +	struct rw_semaphore	i_mmaplock;	/* inode mmap IO lock */
>  	atomic_t		i_pincount;	/* inode pin count */
>  
>  	/*
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 80a13c8561d8..66cca3e599c7 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1336,9 +1336,9 @@ xfs_setup_inode(
>  		 */
>  		lockdep_set_class(&inode->i_rwsem,
>  				  &inode->i_sb->s_type->i_mutex_dir_key);
> -		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
> +		lockdep_set_class(&ip->i_lock, &xfs_dir_ilock_class);
>  	} else {
> -		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
> +		lockdep_set_class(&ip->i_lock, &xfs_nondir_ilock_class);
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index ab737fed7b12..ba37217f86d2 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -22,7 +22,6 @@ typedef __u32			xfs_nlink_t;
>  #include "xfs_types.h"
>  
>  #include "kmem.h"
> -#include "mrlock.h"
>  
>  #include <linux/semaphore.h>
>  #include <linux/mm.h>
> @@ -61,6 +60,7 @@ typedef __u32			xfs_nlink_t;
>  #include <linux/ratelimit.h>
>  #include <linux/rhashtable.h>
>  #include <linux/xattr.h>
> +#include <linux/rwsem.h>
>  
>  #include <asm/page.h>
>  #include <asm/div64.h>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 71ac6c1cdc36..00be9cfa29fa 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -708,10 +708,8 @@ xfs_fs_inode_init_once(
>  	atomic_set(&ip->i_pincount, 0);
>  	spin_lock_init(&ip->i_flags_lock);
>  
> -	mrlock_init(&ip->i_mmaplock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
> -		     "xfsino", ip->i_ino);
> -	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
> -		     "xfsino", ip->i_ino);
> +	init_rwsem(&ip->i_mmaplock);
> +	init_rwsem(&ip->i_lock);
>  }
>  
>  /*
> -- 
> 2.26.2
> 
