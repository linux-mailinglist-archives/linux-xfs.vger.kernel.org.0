Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27208294DF7
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Oct 2020 15:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441983AbgJUNvg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Oct 2020 09:51:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:48496 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439766AbgJUNvg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Oct 2020 09:51:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 71E9FACE6;
        Wed, 21 Oct 2020 13:51:33 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1AADC1E0E89; Wed, 21 Oct 2020 15:51:33 +0200 (CEST)
Date:   Wed, 21 Oct 2020 15:51:33 +0200
From:   Jan Kara <jack@suse.cz>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, ira.weiny@intel.com,
        linux-xfs@vger.kernel.org, viro@zeniv.linux.org.uk,
        y-goto@fujitsu.com, Hao Li <lihao2018.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v2] fs: Kill DCACHE_DONTCACHE dentry even if
 DCACHE_REFERENCED is set
Message-ID: <20201021135133.GA25702@quack2.suse.cz>
References: <20200924055958.825515-1-lihao2018.fnst@cn.fujitsu.com>
 <20200924145856.GB3361@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924145856.GB3361@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hum, Al, did this patch get lost?

								Honza

On Thu 24-09-20 16:58:56, Jan Kara wrote:
> On Thu 24-09-20 13:59:58, Hao Li wrote:
> > If DCACHE_REFERENCED is set, fast_dput() will return true, and then
> > retain_dentry() have no chance to check DCACHE_DONTCACHE. As a result,
> > the dentry won't be killed and the corresponding inode can't be evicted.
> > In the following example, the DAX policy can't take effects unless we
> > do a drop_caches manually.
> > 
> >   # DCACHE_LRU_LIST will be set
> >   echo abcdefg > test.txt
> > 
> >   # DCACHE_REFERENCED will be set and DCACHE_DONTCACHE can't do anything
> >   xfs_io -c 'chattr +x' test.txt
> > 
> >   # Drop caches to make DAX changing take effects
> >   echo 2 > /proc/sys/vm/drop_caches
> > 
> > What this patch does is preventing fast_dput() from returning true if
> > DCACHE_DONTCACHE is set. Then retain_dentry() will detect the
> > DCACHE_DONTCACHE and will return false. As a result, the dentry will be
> > killed and the inode will be evicted. In this way, if we change per-file
> > DAX policy, it will take effects automatically after this file is closed
> > by all processes.
> > 
> > I also add some comments to make the code more clear.
> > 
> > Signed-off-by: Hao Li <lihao2018.fnst@cn.fujitsu.com>
> 
> The patch looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 
> > ---
> > v1 is split into two standalone patch as discussed in [1], and the first
> > patch has been reviewed in [2]. This is the second patch.
> > 
> > [1]: https://lore.kernel.org/linux-fsdevel/20200831003407.GE12096@dread.disaster.area/
> > [2]: https://lore.kernel.org/linux-fsdevel/20200906214002.GI12131@dread.disaster.area/
> > 
> >  fs/dcache.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index ea0485861d93..97e81a844a96 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -793,10 +793,17 @@ static inline bool fast_dput(struct dentry *dentry)
> >  	 * a reference to the dentry and change that, but
> >  	 * our work is done - we can leave the dentry
> >  	 * around with a zero refcount.
> > +	 *
> > +	 * Nevertheless, there are two cases that we should kill
> > +	 * the dentry anyway.
> > +	 * 1. free disconnected dentries as soon as their refcount
> > +	 *    reached zero.
> > +	 * 2. free dentries if they should not be cached.
> >  	 */
> >  	smp_rmb();
> >  	d_flags = READ_ONCE(dentry->d_flags);
> > -	d_flags &= DCACHE_REFERENCED | DCACHE_LRU_LIST | DCACHE_DISCONNECTED;
> > +	d_flags &= DCACHE_REFERENCED | DCACHE_LRU_LIST |
> > +			DCACHE_DISCONNECTED | DCACHE_DONTCACHE;
> >  
> >  	/* Nothing to do? Dropping the reference was all we needed? */
> >  	if (d_flags == (DCACHE_REFERENCED | DCACHE_LRU_LIST) && !d_unhashed(dentry))
> > -- 
> > 2.28.0
> > 
> > 
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
