Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68185FB709
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Nov 2019 19:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfKMSLG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Nov 2019 13:11:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbfKMSLG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 13:11:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADI9K2K081077;
        Wed, 13 Nov 2019 18:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=LSvUz7y7s0o0C6nq+NttOp9DK+d2pu1YFGc9ubn680k=;
 b=fFtanLSTP9gAMHzi0IVimcevM6vd+NP+7Lcy7o8zO5YUVXomqsuM/950dlifDiak4DsW
 EAv6MGNQQ6E/79v9VK7AKBN4OE2PuoxUo/NCz2EfceKqF+FG2B8aDJ56jIHjirkXeIrC
 XsLuzqLna+biUJ/aVogpbmSwHg2U5MaS4UBDIrbf4Uhin1Xbkh9eMLsnKJJfgA2Fe4g4
 B3Ken2RQAT7wkUD9j7QPEXX0Xmbx8kjONaPWUVxSR8XCNVE4qRir19Y4+MKG3dHPCR7D
 5qkdY/qh6ivFDX/LhxDHaSwTqm25u8Cbo0EFBkEpiY6tpHr9HES6jsXWtKAWU2nXxQG3 CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w5p3qx6t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:11:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADI3pfo160033;
        Wed, 13 Nov 2019 18:11:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w8ng3ugs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:11:02 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xADIB0iB010170;
        Wed, 13 Nov 2019 18:11:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 10:11:00 -0800
Date:   Wed, 13 Nov 2019 10:10:59 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: Remove kmem_realloc
Message-ID: <20191113181059.GL6235@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-8-cmaiolino@redhat.com>
 <20191113174054.GD6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113174054.GD6219@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 09:40:54AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 13, 2019 at 03:23:31PM +0100, Carlos Maiolino wrote:
> > We can use krealloc() with __GFP_NOFAIL directly
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/kmem.c                  | 22 ----------------------
> >  fs/xfs/kmem.h                  |  1 -
> >  fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
> >  fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
> >  fs/xfs/xfs_log_recover.c       |  2 +-
> >  fs/xfs/xfs_mount.c             |  4 ++--
> >  6 files changed, 8 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > index 2644fdaa0549..6e10e565632c 100644
> > --- a/fs/xfs/kmem.c
> > +++ b/fs/xfs/kmem.c
> > @@ -93,25 +93,3 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> >  		return ptr;
> >  	return __kmem_vmalloc(size, flags);
> >  }
> > -
> > -void *
> > -kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
> > -{
> > -	int	retries = 0;
> > -	gfp_t	lflags = kmem_flags_convert(flags);
> > -	void	*ptr;
> > -
> > -	trace_kmem_realloc(newsize, flags, _RET_IP_);
> > -
> > -	do {
> > -		ptr = krealloc(old, newsize, lflags);
> > -		if (ptr || (flags & KM_MAYFAIL))
> > -			return ptr;
> > -		if (!(++retries % 100))
> > -			xfs_err(NULL,
> > -	"%s(%u) possible memory allocation deadlock size %zu in %s (mode:0x%x)",
> > -				current->comm, current->pid,
> > -				newsize, __func__, lflags);
> > -		congestion_wait(BLK_RW_ASYNC, HZ/50);

I left a more detailed comment attached to patch 9, but is it ok to
remove this retry logic?

> > -	} while (1);
> > -}
> > diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> > index 46c8c5546674..18b62eee3177 100644
> > --- a/fs/xfs/kmem.h
> > +++ b/fs/xfs/kmem.h
> > @@ -55,7 +55,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
> >  extern void *kmem_alloc(size_t, xfs_km_flags_t);
> >  extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
> >  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
> > -extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
> >  static inline void  kmem_free(const void *ptr)
> >  {
> >  	kvfree(ptr);
> > diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> > index f2005671e86c..a929ea0b09b7 100644
> > --- a/fs/xfs/libxfs/xfs_iext_tree.c
> > +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> > @@ -607,7 +607,7 @@ xfs_iext_realloc_root(
> >  	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
> >  		new_size = NODE_SIZE;
> >  
> > -	new = kmem_realloc(ifp->if_u1.if_root, new_size, KM_NOFS);
> > +	new = krealloc(ifp->if_u1.if_root, new_size, GFP_NOFS | __GFP_NOFAIL);
> >  	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
> >  	ifp->if_u1.if_root = new;
> >  	cur->leaf = new;
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 2bffaa31d62a..34c336f45796 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -387,8 +387,8 @@ xfs_iroot_realloc(
> >  		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
> >  		new_max = cur_max + rec_diff;
> >  		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
> > -		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
> > -				KM_NOFS);
> > +		ifp->if_broot = krealloc(ifp->if_broot, new_size,
> > +				GFP_NOFS | __GFP_NOFAIL);
> >  		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
> >  						     ifp->if_broot_bytes);
> >  		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
> > @@ -497,8 +497,8 @@ xfs_idata_realloc(
> >  	 * in size so that it can be logged and stay on word boundaries.
> >  	 * We enforce that here.
> >  	 */
> > -	ifp->if_u1.if_data = kmem_realloc(ifp->if_u1.if_data,
> > -			roundup(new_size, 4), KM_NOFS);
> > +	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
> > +				      GFP_NOFS | __GFP_NOFAIL);
> >  	ifp->if_bytes = new_size;
> >  }
> >  
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index bc5c0aef051c..a7f1dcecc640 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -4211,7 +4211,7 @@ xlog_recover_add_to_cont_trans(
> >  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
> >  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
> >  
> > -	ptr = kmem_realloc(old_ptr, len + old_len, 0);
> > +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
> >  	memcpy(&ptr[old_len], dp, len);
> >  	item->ri_buf[item->ri_cnt-1].i_len += len;
> >  	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 91a5354f20fb..a14046314c1f 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -80,9 +80,9 @@ xfs_uuid_mount(
> >  	}
> >  
> >  	if (hole < 0) {
> > -		xfs_uuid_table = kmem_realloc(xfs_uuid_table,
> > +		xfs_uuid_table = krealloc(xfs_uuid_table,
> >  			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
> > -			0);
> > +			GFP_KERNEL | __GFP_NOFAIL);
> >  		hole = xfs_uuid_table_size++;
> >  	}
> >  	xfs_uuid_table[hole] = *uuid;
> 
> This whole uuid table thing is pretty ugly (what happens when someone
> tries to mount a few thousand xfs images?) but I guess fixing it is for
> another day...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

  ^^^^^^^^^^^ Withdrawn for the time being.

--D

> --D
> 
> > -- 
> > 2.23.0
> > 
