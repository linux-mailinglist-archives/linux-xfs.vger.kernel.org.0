Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE771849DA
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Mar 2020 15:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCMOr3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Mar 2020 10:47:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36131 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726826AbgCMOr2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 10:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584110847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=auKsRJ30y7E3Ecrax/1hZKY8PKdGm6g5zduwhrgG62k=;
        b=HX7pnx6Mv5EdcCziB3Ph5PkxS521M/IcOiB/UYKyDiAqy57wJ8rB1Q7DINkTKxruvrVunh
        8yRzAo/Ip5KwI6HOzt01pHVINU6K0Ubimrl2m94wSb6NxyxfMGRGDfmRS+xKVopfDY4AWZ
        sJDZlmxRZ6rsCGYUi7LId0Cm++nUwF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-7d38y12xOOuuCFtN44vynQ-1; Fri, 13 Mar 2020 10:47:25 -0400
X-MC-Unique: 7d38y12xOOuuCFtN44vynQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 232581010ADE;
        Fri, 13 Mar 2020 14:47:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C50428D00;
        Fri, 13 Mar 2020 14:47:23 +0000 (UTC)
Date:   Fri, 13 Mar 2020 10:47:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: introduce fake roots for inode-rooted btrees
Message-ID: <20200313144721.GB11929@bfoster>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
 <158398474334.1308059.3288197233526483322.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158398474334.1308059.3288197233526483322.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:45:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create an in-core fake root for inode-rooted btree types so that callers
> can generate a whole new btree using the upcoming btree bulk load
> function without making the new tree accessible from the rest of the
> filesystem.  It is up to the individual btree type to provide a function
> to create a staged cursor (presumably with the appropriate callouts to
> update the fakeroot) and then commit the staged root back into the
> filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Same question as the previous patch, but otherwise looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.c |  111 +++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_btree.h |   31 +++++++++++++
>  fs/xfs/xfs_trace.h        |   33 +++++++++++++
>  3 files changed, 171 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 085bc070e804..4e1d4f184d4b 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -644,6 +644,17 @@ xfs_btree_ptr_addr(
>  		((char *)block + xfs_btree_ptr_offset(cur, n, level));
>  }
>  
> +struct xfs_ifork *
> +xfs_btree_ifork_ptr(
> +	struct xfs_btree_cur	*cur)
> +{
> +	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> +
> +	if (cur->bc_flags & XFS_BTREE_STAGING)
> +		return cur->bc_ino.ifake->if_fork;
> +	return XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
> +}
> +
>  /*
>   * Get the root block which is stored in the inode.
>   *
> @@ -654,9 +665,8 @@ STATIC struct xfs_btree_block *
>  xfs_btree_get_iroot(
>  	struct xfs_btree_cur	*cur)
>  {
> -	struct xfs_ifork	*ifp;
> +	struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
>  
> -	ifp = XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
>  	return (struct xfs_btree_block *)ifp->if_broot;
>  }
>  
> @@ -4985,8 +4995,17 @@ xfs_btree_fakeroot_init_ptr_from_cur(
>  
>  	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
>  
> -	afake = cur->bc_ag.afake;
> -	ptr->s = cpu_to_be32(afake->af_root);
> +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> +		/*
> +		 * The root block lives in the inode core, so we zero the
> +		 * pointer (like the bmbt code does) to make it obvious if
> +		 * anyone ever tries to use this pointer.
> +		 */
> +		ptr->l = cpu_to_be64(0);
> +	} else {
> +		afake = cur->bc_ag.afake;
> +		ptr->s = cpu_to_be32(afake->af_root);
> +	}
>  }
>  
>  /*
> @@ -5076,3 +5095,87 @@ xfs_btree_commit_afakeroot(
>  	cur->bc_flags &= ~XFS_BTREE_STAGING;
>  	cur->bc_tp = tp;
>  }
> +
> +/*
> + * Bulk Loading for Inode-Rooted Btrees
> + * ====================================
> + *
> + * For a btree rooted in an inode fork, pass a xbtree_ifakeroot structure to
> + * the staging cursor.  This structure should be initialized as follows:
> + *
> + * - if_fork_size field should be set to the number of bytes available to the
> + *   fork in the inode.
> + *
> + * - if_fork should point to a freshly allocated struct xfs_ifork.
> + *
> + * - if_format should be set to the appropriate fork type (e.g.
> + *   XFS_DINODE_FMT_BTREE).
> + *
> + * All other fields must be zero.
> + *
> + * The _stage_cursor() function for a specific btree type should call
> + * xfs_btree_stage_ifakeroot to set up the in-memory cursor as a staging
> + * cursor.  The corresponding _commit_staged_btree() function should log the
> + * new root and call xfs_btree_commit_ifakeroot() to transform the staging
> + * cursor into a regular btree cursor.
> + */
> +
> +/*
> + * Initialize an inode-rooted btree cursor with the given inode btree fake
> + * root.  The btree cursor's bc_ops will be overridden as needed to make the
> + * staging functionality work.  If new_ops is not NULL, these new ops will be
> + * passed out to the caller for further overriding.
> + */
> +void
> +xfs_btree_stage_ifakeroot(
> +	struct xfs_btree_cur		*cur,
> +	struct xbtree_ifakeroot		*ifake,
> +	struct xfs_btree_ops		**new_ops)
> +{
> +	struct xfs_btree_ops		*nops;
> +
> +	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
> +	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> +	ASSERT(cur->bc_tp == NULL);
> +
> +	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
> +	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
> +	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
> +	nops->free_block = xfs_btree_fakeroot_free_block;
> +	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
> +	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
> +
> +	cur->bc_ino.ifake = ifake;
> +	cur->bc_nlevels = ifake->if_levels;
> +	cur->bc_ops = nops;
> +	cur->bc_flags |= XFS_BTREE_STAGING;
> +
> +	if (new_ops)
> +		*new_ops = nops;
> +}
> +
> +/*
> + * Transform an inode-rooted staging btree cursor back into a regular cursor by
> + * substituting a real btree root for the fake one and restoring normal btree
> + * cursor ops.  The caller must log the btree root change prior to calling
> + * this.
> + */
> +void
> +xfs_btree_commit_ifakeroot(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_trans		*tp,
> +	int				whichfork,
> +	const struct xfs_btree_ops	*ops)
> +{
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +	ASSERT(cur->bc_tp == NULL);
> +
> +	trace_xfs_btree_commit_ifakeroot(cur);
> +
> +	kmem_free((void *)cur->bc_ops);
> +	cur->bc_ino.ifake = NULL;
> +	cur->bc_ino.whichfork = whichfork;
> +	cur->bc_ops = ops;
> +	cur->bc_flags &= ~XFS_BTREE_STAGING;
> +	cur->bc_tp = tp;
> +}
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index aa4a7bd40023..047067f52063 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -10,6 +10,7 @@ struct xfs_buf;
>  struct xfs_inode;
>  struct xfs_mount;
>  struct xfs_trans;
> +struct xfs_ifork;
>  
>  extern kmem_zone_t	*xfs_btree_cur_zone;
>  
> @@ -198,6 +199,7 @@ struct xfs_btree_cur_ag {
>  /* Btree-in-inode cursor information */
>  struct xfs_btree_cur_ino {
>  	struct xfs_inode	*ip;
> +	struct xbtree_ifakeroot	*ifake;		/* fake inode fork */
>  	int			allocated;
>  	short			forksize;
>  	char			whichfork;
> @@ -506,6 +508,7 @@ union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
>  int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
>  		union xfs_btree_irec *high, bool *exists);
>  bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
> +struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
>  
>  /* Does this cursor point to the last block in the given level? */
>  static inline bool
> @@ -543,4 +546,32 @@ void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
>  void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
>  		struct xfs_buf *agbp, const struct xfs_btree_ops *ops);
>  
> +/* Fake root for an inode-rooted btree. */
> +struct xbtree_ifakeroot {
> +	/* Fake inode fork. */
> +	struct xfs_ifork	*if_fork;
> +
> +	/* Number of blocks used by the btree. */
> +	int64_t			if_blocks;
> +
> +	/* Height of the new btree. */
> +	unsigned int		if_levels;
> +
> +	/* Number of bytes available for this fork in the inode. */
> +	unsigned int		if_fork_size;
> +
> +	/* Fork format. */
> +	unsigned int		if_format;
> +
> +	/* Number of records. */
> +	unsigned int		if_extents;
> +};
> +
> +/* Cursor interactions with with fake roots for inode-rooted btrees. */
> +void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
> +		struct xbtree_ifakeroot *ifake,
> +		struct xfs_btree_ops **new_ops);
> +void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
> +		int whichfork, const struct xfs_btree_ops *ops);
> +
>  #endif	/* __XFS_BTREE_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index d8c229492973..05db0398f040 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3633,6 +3633,39 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
>  		  __entry->agbno)
>  )
>  
> +TRACE_EVENT(xfs_btree_commit_ifakeroot,
> +	TP_PROTO(struct xfs_btree_cur *cur),
> +	TP_ARGS(cur),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_btnum_t, btnum)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, agino)
> +		__field(unsigned int, levels)
> +		__field(unsigned int, blocks)
> +		__field(int, whichfork)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = cur->bc_mp->m_super->s_dev;
> +		__entry->btnum = cur->bc_btnum;
> +		__entry->agno = XFS_INO_TO_AGNO(cur->bc_mp,
> +					cur->bc_ino.ip->i_ino);
> +		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
> +					cur->bc_ino.ip->i_ino);
> +		__entry->levels = cur->bc_ino.ifake->if_levels;
> +		__entry->blocks = cur->bc_ino.ifake->if_blocks;
> +		__entry->whichfork = cur->bc_ino.whichfork;
> +	),
> +	TP_printk("dev %d:%d btree %s ag %u agino %u whichfork %s levels %u blocks %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> +		  __entry->agno,
> +		  __entry->agino,
> +		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
> +		  __entry->levels,
> +		  __entry->blocks)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 

