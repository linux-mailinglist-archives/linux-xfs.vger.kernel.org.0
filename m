Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990E0284A7C
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Oct 2020 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgJFKua (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Oct 2020 06:50:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725891AbgJFKua (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 06:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601981444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ls/K5sdhX22DPENCjwSUQ/UHtMLicl+xH6cvfrxvlDc=;
        b=EHqYPSo/xWPYsKT+9T3IbwgELQhg11al/Hk+O/bVHM7zv+tnpTkyDEvlpEYGB5wjKVtTSg
        yXX8+epH9VU9QIWG2h249GqZuYJ2Z4VXablcyUb4oRqrKVLTkS23JBOArdUjwtHYk9CbUm
        4IKwhfpofNXd3LWa1IY2oZuPTOfQIRU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-OqPvjfrvO_eTYlrP2SAURA-1; Tue, 06 Oct 2020 06:50:30 -0400
X-MC-Unique: OqPvjfrvO_eTYlrP2SAURA-1
Received: by mail-wr1-f71.google.com with SMTP id l20so1964222wrc.20
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2020 03:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ls/K5sdhX22DPENCjwSUQ/UHtMLicl+xH6cvfrxvlDc=;
        b=qhHkCuu6NmxW/MB/ZxKcpdcZDdwpKZ6ql/9ndKJIRf5Oo76fNY3O3dltzbPPK5dFAi
         VNQsFp9jw1301XpPl1VdYaV4I4zrXsrBGGPbzPf0C81LvY7zNXqH6fOb7AIh/xbPwZ/n
         YdCN1r0QGUPi7KoRAItTucKkRZY8KE6DVGGbimMB0gBeHVn/bzo/MLWS7GlSnctFUlmv
         7ZxoapEvjJHft1wNCaQBoObDxjqfMx4rZEy4BzC383ze2hXvmDfozub5MIzYHiN5/EoP
         VG8RJhRRu9lXEmkL16jpnMp6+df/LpCdXTUPXG8WOzbdmQo/b7+YM7fwVCNGvZ1uSX3q
         V1Ww==
X-Gm-Message-State: AOAM531v8HjnMlyHHDzRuL9AmkSVjvhsepJ7dUR1z0il3Y2oTvQ/sjjI
        baAYc7tTxwtOQ5DoqIN9Hh8Yf6RQTyRyxyku/fKjHcu2kZNhESekrf2BYZGwg60NmwKc2l+xj1k
        q3pm1Pt6zs/pFQ5+S7EmC
X-Received: by 2002:a5d:69c2:: with SMTP id s2mr4164814wrw.389.1601981428676;
        Tue, 06 Oct 2020 03:50:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyev5f4MvLwCc7gbBeLMxgJhgDo1l25FJEpxQ5yYdpE+7OyaHSbwEOjGKgNUZSQnU8u1mIVPg==
X-Received: by 2002:a5d:69c2:: with SMTP id s2mr4164780wrw.389.1601981428280;
        Tue, 06 Oct 2020 03:50:28 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id h17sm4260290wro.27.2020.10.06.03.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 03:50:27 -0700 (PDT)
Subject: Re: [PATCH v8 4/4] xfs: replace mrlock_t with rw_semaphores
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201005213852.233004-1-preichl@redhat.com>
 <20201005213852.233004-5-preichl@redhat.com>
 <20201006041426.GH49547@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <1796931d-fe5d-2d81-e5bc-2369f89a4688@redhat.com>
Date:   Tue, 6 Oct 2020 12:50:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201006041426.GH49547@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/6/20 6:14 AM, Darrick J. Wong wrote:
> On Mon, Oct 05, 2020 at 11:38:52PM +0200, Pavel Reichl wrote:
>> Remove mrlock_t as it does not provide any extra value over
>> rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
>> replace mr*() functions with native rwsem calls.
>>
>> Release the lock in xfs_btree_split() just before the work-queue
>> executing xfs_btree_split_worker() is scheduled and make
>> xfs_btree_split_worker() to acquire the lock as a first thing and
>> release it just before returning from the function. This it done so the
>> ownership of the lock is transfered between kernel threads and thus
>> lockdep won't complain about lock being held by a different kernel
>> thread.
>>
>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>> ---
>>  fs/xfs/libxfs/xfs_btree.c | 10 +++++
>>  fs/xfs/mrlock.h           | 78 ---------------------------------------
>>  fs/xfs/xfs_inode.c        | 36 ++++++++++--------
>>  fs/xfs/xfs_inode.h        |  4 +-
>>  fs/xfs/xfs_iops.c         |  4 +-
>>  fs/xfs/xfs_linux.h        |  2 +-
>>  fs/xfs/xfs_super.c        |  6 +--
>>  7 files changed, 37 insertions(+), 103 deletions(-)
>>  delete mode 100644 fs/xfs/mrlock.h
>>
>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>> index 2d25bab68764..d798d288eed1 100644
>> --- a/fs/xfs/libxfs/xfs_btree.c
>> +++ b/fs/xfs/libxfs/xfs_btree.c
>> @@ -2816,6 +2816,7 @@ xfs_btree_split_worker(
>>  	unsigned long		pflags;
>>  	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
>>  
>> +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
>>  	/*
>>  	 * we are in a transaction context here, but may also be doing work
>>  	 * in kswapd context, and hence we may need to inherit that state
>> @@ -2832,6 +2833,7 @@ xfs_btree_split_worker(
>>  	complete(args->done);
>>  
>>  	current_restore_flags_nested(&pflags, new_pflags);
>> +	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>>  }
>>  
>>  /*
>> @@ -2863,8 +2865,16 @@ xfs_btree_split(
>>  	args.done = &done;
>>  	args.kswapd = current_is_kswapd();
>>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
>> +
>> +	/* Release the lock so it can be acquired in the kernel thread which
> 
> Strange comment style.

OK, I'll try to think about something better, but ideas are welcome :-).

> 
> Also, we're not really releasing the lock itself here, right?  We're
> merely updating lockdep's bookkeepping so that the worker can make
> itself look like the lock owner (to lockdep, anyway).

Hmm...I'm afraid I don't follow - yes we are doing this to satisfy lockdep's bookkeeping,
however we actually do this by releasing the lock in one kernel thread and acquiring it in another.


> 
> Does this exist as a helper anywhere in the kernel?  I don't really like
> XFS poking into the rw_semaphore innards, though I concede that this
> lock transferring dance is probably pretty rare.

I'll try to look for it.

> 
> --D
> 
>> +	 * executes the xfs_btree_split_worker.
>> +	 */
>> +	rwsem_release(&cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>>  	queue_work(xfs_alloc_wq, &args.work);
>> +
>>  	wait_for_completion(&done);
>> +	/* Re-aqcquire the lock previously released for the work queue. */
>> +	rwsem_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
>>  	destroy_work_on_stack(&args.work);
>>  	return args.result;
>>  }
>> diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
>> deleted file mode 100644
>> index 79155eec341b..000000000000
>> --- a/fs/xfs/mrlock.h
>> +++ /dev/null
>> @@ -1,78 +0,0 @@
>> -// SPDX-License-Identifier: GPL-2.0
>> -/*
>> - * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>> - * All Rights Reserved.
>> - */
>> -#ifndef __XFS_SUPPORT_MRLOCK_H__
>> -#define __XFS_SUPPORT_MRLOCK_H__
>> -
>> -#include <linux/rwsem.h>
>> -
>> -typedef struct {
>> -	struct rw_semaphore	mr_lock;
>> -#if defined(DEBUG) || defined(XFS_WARN)
>> -	int			mr_writer;
>> -#endif
>> -} mrlock_t;
>> -
>> -#if defined(DEBUG) || defined(XFS_WARN)
>> -#define mrinit(mrp, name)	\
>> -	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
>> -#else
>> -#define mrinit(mrp, name)	\
>> -	do { init_rwsem(&(mrp)->mr_lock); } while (0)
>> -#endif
>> -
>> -#define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
>> -#define mrfree(mrp)		do { } while (0)
>> -
>> -static inline void mraccess_nested(mrlock_t *mrp, int subclass)
>> -{
>> -	down_read_nested(&mrp->mr_lock, subclass);
>> -}
>> -
>> -static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
>> -{
>> -	down_write_nested(&mrp->mr_lock, subclass);
>> -#if defined(DEBUG) || defined(XFS_WARN)
>> -	mrp->mr_writer = 1;
>> -#endif
>> -}
>> -
>> -static inline int mrtryaccess(mrlock_t *mrp)
>> -{
>> -	return down_read_trylock(&mrp->mr_lock);
>> -}
>> -
>> -static inline int mrtryupdate(mrlock_t *mrp)
>> -{
>> -	if (!down_write_trylock(&mrp->mr_lock))
>> -		return 0;
>> -#if defined(DEBUG) || defined(XFS_WARN)
>> -	mrp->mr_writer = 1;
>> -#endif
>> -	return 1;
>> -}
>> -
>> -static inline void mrunlock_excl(mrlock_t *mrp)
>> -{
>> -#if defined(DEBUG) || defined(XFS_WARN)
>> -	mrp->mr_writer = 0;
>> -#endif
>> -	up_write(&mrp->mr_lock);
>> -}
>> -
>> -static inline void mrunlock_shared(mrlock_t *mrp)
>> -{
>> -	up_read(&mrp->mr_lock);
>> -}
>> -
>> -static inline void mrdemote(mrlock_t *mrp)
>> -{
>> -#if defined(DEBUG) || defined(XFS_WARN)
>> -	mrp->mr_writer = 0;
>> -#endif
>> -	downgrade_write(&mrp->mr_lock);
>> -}
>> -
>> -#endif /* __XFS_SUPPORT_MRLOCK_H__ */
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 49d296877494..dbc1b80629c5 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -191,14 +191,15 @@ xfs_ilock(
>>  	}
>>  
>>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
>> -		mrupdate_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
>> +		down_write_nested(&ip->i_mmaplock,
>> +				XFS_MMAPLOCK_DEP(lock_flags));
>>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
>> -		mraccess_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
>> +		down_read_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
>>  
>>  	if (lock_flags & XFS_ILOCK_EXCL)
>> -		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>> +		down_write_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>>  	else if (lock_flags & XFS_ILOCK_SHARED)
>> -		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>> +		down_read_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>>  }
>>  
>>  /*
>> @@ -242,27 +243,27 @@ xfs_ilock_nowait(
>>  	}
>>  
>>  	if (lock_flags & XFS_MMAPLOCK_EXCL) {
>> -		if (!mrtryupdate(&ip->i_mmaplock))
>> +		if (!down_write_trylock(&ip->i_mmaplock))
>>  			goto out_undo_iolock;
>>  	} else if (lock_flags & XFS_MMAPLOCK_SHARED) {
>> -		if (!mrtryaccess(&ip->i_mmaplock))
>> +		if (!down_read_trylock(&ip->i_mmaplock))
>>  			goto out_undo_iolock;
>>  	}
>>  
>>  	if (lock_flags & XFS_ILOCK_EXCL) {
>> -		if (!mrtryupdate(&ip->i_lock))
>> +		if (!down_write_trylock(&ip->i_lock))
>>  			goto out_undo_mmaplock;
>>  	} else if (lock_flags & XFS_ILOCK_SHARED) {
>> -		if (!mrtryaccess(&ip->i_lock))
>> +		if (!down_read_trylock(&ip->i_lock))
>>  			goto out_undo_mmaplock;
>>  	}
>>  	return 1;
>>  
>>  out_undo_mmaplock:
>>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
>> -		mrunlock_excl(&ip->i_mmaplock);
>> +		up_write(&ip->i_mmaplock);
>>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
>> -		mrunlock_shared(&ip->i_mmaplock);
>> +		up_read(&ip->i_mmaplock);
>>  out_undo_iolock:
>>  	if (lock_flags & XFS_IOLOCK_EXCL)
>>  		up_write(&VFS_I(ip)->i_rwsem);
>> @@ -309,14 +310,14 @@ xfs_iunlock(
>>  		up_read(&VFS_I(ip)->i_rwsem);
>>  
>>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
>> -		mrunlock_excl(&ip->i_mmaplock);
>> +		up_write(&ip->i_mmaplock);
>>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
>> -		mrunlock_shared(&ip->i_mmaplock);
>> +		up_read(&ip->i_mmaplock);
>>  
>>  	if (lock_flags & XFS_ILOCK_EXCL)
>> -		mrunlock_excl(&ip->i_lock);
>> +		up_write(&ip->i_lock);
>>  	else if (lock_flags & XFS_ILOCK_SHARED)
>> -		mrunlock_shared(&ip->i_lock);
>> +		up_read(&ip->i_lock);
>>  
>>  	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
>>  }
>> @@ -335,9 +336,9 @@ xfs_ilock_demote(
>>  		~(XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
>>  
>>  	if (lock_flags & XFS_ILOCK_EXCL)
>> -		mrdemote(&ip->i_lock);
>> +		downgrade_write(&ip->i_lock);
>>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
>> -		mrdemote(&ip->i_mmaplock);
>> +		downgrade_write(&ip->i_mmaplock);
>>  	if (lock_flags & XFS_IOLOCK_EXCL)
>>  		downgrade_write(&VFS_I(ip)->i_rwsem);
>>  
>> @@ -385,11 +386,14 @@ xfs_isilocked(
>>  	uint			lock_flags)
>>  {
>>  	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
>> +		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
>>  		return __xfs_rwsem_islocked(&ip->i_lock,
>>  				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
>>  	}
>>  
>>  	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
>> +		ASSERT(!(lock_flags &
>> +			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
>>  		return __xfs_rwsem_islocked(&ip->i_mmaplock,
>>  				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
>>  	}
>> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
>> index 77d5655191ab..02c98ecfe4c5 100644
>> --- a/fs/xfs/xfs_inode.h
>> +++ b/fs/xfs/xfs_inode.h
>> @@ -39,8 +39,8 @@ typedef struct xfs_inode {
>>  
>>  	/* Transaction and locking information. */
>>  	struct xfs_inode_log_item *i_itemp;	/* logging information */
>> -	mrlock_t		i_lock;		/* inode lock */
>> -	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
>> +	struct rw_semaphore	i_lock;		/* inode lock */
>> +	struct rw_semaphore	i_mmaplock;	/* inode mmap IO lock */
>>  	atomic_t		i_pincount;	/* inode pin count */
>>  
>>  	/*
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 80a13c8561d8..66cca3e599c7 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -1336,9 +1336,9 @@ xfs_setup_inode(
>>  		 */
>>  		lockdep_set_class(&inode->i_rwsem,
>>  				  &inode->i_sb->s_type->i_mutex_dir_key);
>> -		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
>> +		lockdep_set_class(&ip->i_lock, &xfs_dir_ilock_class);
>>  	} else {
>> -		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
>> +		lockdep_set_class(&ip->i_lock, &xfs_nondir_ilock_class);
>>  	}
>>  
>>  	/*
>> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
>> index ab737fed7b12..ba37217f86d2 100644
>> --- a/fs/xfs/xfs_linux.h
>> +++ b/fs/xfs/xfs_linux.h
>> @@ -22,7 +22,6 @@ typedef __u32			xfs_nlink_t;
>>  #include "xfs_types.h"
>>  
>>  #include "kmem.h"
>> -#include "mrlock.h"
>>  
>>  #include <linux/semaphore.h>
>>  #include <linux/mm.h>
>> @@ -61,6 +60,7 @@ typedef __u32			xfs_nlink_t;
>>  #include <linux/ratelimit.h>
>>  #include <linux/rhashtable.h>
>>  #include <linux/xattr.h>
>> +#include <linux/rwsem.h>
>>  
>>  #include <asm/page.h>
>>  #include <asm/div64.h>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 71ac6c1cdc36..00be9cfa29fa 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -708,10 +708,8 @@ xfs_fs_inode_init_once(
>>  	atomic_set(&ip->i_pincount, 0);
>>  	spin_lock_init(&ip->i_flags_lock);
>>  
>> -	mrlock_init(&ip->i_mmaplock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
>> -		     "xfsino", ip->i_ino);
>> -	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
>> -		     "xfsino", ip->i_ino);
>> +	init_rwsem(&ip->i_mmaplock);
>> +	init_rwsem(&ip->i_lock);
>>  }
>>  
>>  /*
>> -- 
>> 2.26.2
>>
> 

