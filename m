Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3B13428DB
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Mar 2021 23:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCSWpP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Mar 2021 18:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230281AbhCSWow (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Mar 2021 18:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87CB161970;
        Fri, 19 Mar 2021 22:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616193892;
        bh=82rArIUTxIKhcrk1SBxxwnCuZ1vCnkb6O5CaffHmQOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X7lVaiDFtXAAeET/jwLSz52iCKdcFlCzUzn9NXtZI6thq0n+6aw7Hupb2+PO8mZwA
         o7x1EfIxMP3+Bc79ekWYyzSDrFCQMFAF80o+pxbdXjOvGW5bW8clSDFxmaKDUVMNHF
         aoPt6tTNiTlkX9ev4fXziRzEZhNlkbPFIdKoitRtToVmcTSW7E7snRjVHXRokp75rX
         r9BqVckT0hZXjNs4V1RDSl/xcXiUqVLsizw+qfrVpQrHG40tmwqcfHF4ELsZl6HFDr
         Ze1gMgV6GjON9Vk2VxMhu25zWiRC3jHldS6ZYX7RXTTuQu7SZcQLV7K4IleoXsjH81
         VQ1h2U2WhRcQg==
Date:   Fri, 19 Mar 2021 15:44:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hsiangkao@redhat.com
Subject: Re: [PATCH 6/7] repair: convert the dir byaddr hash to a radix tree
Message-ID: <20210319224450.GW22100@magnolia>
References: <20210319013355.776008-1-david@fromorbit.com>
 <20210319013355.776008-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319013355.776008-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 12:33:54PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Phase 6 uses a hash table to track the data segment addresses of the
> entries it has seen in a directory. This is indexed by the offset
> into the data segment for the dirent, and is used to check if the
> entry exists, is a duplicate or has a bad hash value. The lookup
> operations involve walking long hash chains on large directories and
> they are done for every entry in the directory. This means certain
> operations have O(n^2) scalability (or worse!) and hence hurt on
> very large directories.
> 
> It is also used to determine if the directory has unseen entries,
> which involves a full hash traversal that is very expensive on large
> directories. Hence the directory checking for unseen ends up being
> roughly a O(n^2 + n) algorithm.
> 
> Switch the byaddr indexing to a radix tree. While a radix tree will
> burn more memory than the linked list, it gives us O(log n) lookup
> operations instead of O(n) on large directories, and use for tags
> gives us O(1) determination of whether all entries have been seen or
> not. This brings the "entry seen" algorithm scalability back to
> O(nlog n) and so is a major improvement for processing large
> directories.
> 
> Given a filesystem with 10M empty files in a single directory, we
> see:
> 
> 5.6.0:
> 
>   97.56%  xfs_repair              [.] dir_hash_add.lto_priv.0
>    0.38%  xfs_repair              [.] avl_ino_start.lto_priv.0
>    0.37%  libc-2.31.so            [.] malloc
>    0.34%  xfs_repair              [.] longform_dir2_entry_check_data.lto_priv.0
> 
> Phase 6:        10/22 12:07:13  10/22 12:10:51  3 minutes, 38 seconds
> 
> Patched:
> 
>   97.11%  xfs_repair          [.] dir_hash_add
>    0.38%  xfs_repair          [.] longform_dir2_entry_check_data
>    0.34%  libc-2.31.so        [.] __libc_calloc
>    0.32%  xfs_repair          [.] avl_ino_start
> 
> Phase 6:        10/22 12:11:40  10/22 12:14:28  2 minutes, 48 seconds
> 
> So there's some improvement, but we are clearly still CPU bound due
> to the O(n^2) scalability of the duplicate name checking algorithm.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Didn't I RVB this last time?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  libfrog/radix-tree.c |  46 +++++++++
>  repair/phase6.c      | 222 ++++++++++++++++++++-----------------------
>  2 files changed, 148 insertions(+), 120 deletions(-)
> 
> diff --git a/libfrog/radix-tree.c b/libfrog/radix-tree.c
> index c1c74876964c..261fc2487de9 100644
> --- a/libfrog/radix-tree.c
> +++ b/libfrog/radix-tree.c
> @@ -312,6 +312,52 @@ void *radix_tree_lookup_first(struct radix_tree_root *root, unsigned long *index
>  
>  #ifdef RADIX_TREE_TAGS
>  
> +/**
> + * radix_tree_tag_get - get a tag on a radix tree node
> + * @root:		radix tree root
> + * @index:		index key
> + * @tag:		tag index (< RADIX_TREE_MAX_TAGS)
> + *
> + * Return values:
> + *
> + *  0: tag not present or not set
> + *  1: tag set
> + *
> + * Note that the return value of this function may not be relied on, even if
> + * the RCU lock is held, unless tag modification and node deletion are excluded
> + * from concurrency.
> + */
> +int radix_tree_tag_get(struct radix_tree_root *root,
> +			unsigned long index, unsigned int tag)
> +{
> +	unsigned int height, shift;
> +	struct radix_tree_node *slot;
> +
> +	height = root->height;
> +	if (index > radix_tree_maxindex(height))
> +		return 0;
> +
> +	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
> +	slot = root->rnode;
> +
> +	while (height > 0) {
> +		int offset;
> +
> +		if (slot == NULL)
> +			return 0;
> +
> +		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
> +		if (!tag_get(slot, tag, offset))
> +			return 0;
> +
> +		slot = slot->slots[offset];
> +		ASSERT(slot != NULL);
> +		shift -= RADIX_TREE_MAP_SHIFT;
> +		height--;
> +	}
> +	return 1;
> +}
> +
>  /**
>   *	radix_tree_tag_set - set a tag on a radix tree node
>   *	@root:		radix tree root
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 440b6a2982df..a432856cca52 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -66,8 +66,7 @@ add_dotdot_update(
>   * and whether their leaf entry has been seen. Also used for name
>   * duplicate checking and rebuilding step if required.
>   */
> -typedef struct dir_hash_ent {
> -	struct dir_hash_ent	*nextbyaddr;	/* next in addr bucket */
> +struct dir_hash_ent {
>  	struct dir_hash_ent	*nextbyhash;	/* next in name bucket */
>  	struct dir_hash_ent	*nextbyorder;	/* next in order added */
>  	xfs_dahash_t		hashval;	/* hash value of name */
> @@ -76,18 +75,19 @@ typedef struct dir_hash_ent {
>  	short			junkit;		/* name starts with / */
>  	short			seen;		/* have seen leaf entry */
>  	struct xfs_name		name;
> -} dir_hash_ent_t;
> +};
>  
> -typedef struct dir_hash_tab {
> +struct dir_hash_tab {
>  	int			size;		/* size of hash tables */
> -	dir_hash_ent_t		*first;		/* ptr to first added entry */
> -	dir_hash_ent_t		*last;		/* ptr to last added entry */
> -	dir_hash_ent_t		**byhash;	/* ptr to name hash buckets */
> -	dir_hash_ent_t		**byaddr;	/* ptr to addr hash buckets */
> -} dir_hash_tab_t;
> +	struct dir_hash_ent	*first;		/* ptr to first added entry */
> +	struct dir_hash_ent	*last;		/* ptr to last added entry */
> +	struct dir_hash_ent	**byhash;	/* ptr to name hash buckets */
> +#define HT_UNSEEN		1
> +	struct radix_tree_root	byaddr;
> +};
>  
>  #define	DIR_HASH_TAB_SIZE(n)	\
> -	(sizeof(dir_hash_tab_t) + (sizeof(dir_hash_ent_t *) * (n) * 2))
> +	(sizeof(struct dir_hash_tab) + (sizeof(struct dir_hash_ent *) * (n)))
>  #define	DIR_HASH_FUNC(t,a)	((a) % (t)->size)
>  
>  /*
> @@ -154,8 +154,8 @@ dir_read_buf(
>   */
>  static int
>  dir_hash_add(
> -	xfs_mount_t		*mp,
> -	dir_hash_tab_t		*hashtab,
> +	struct xfs_mount	*mp,
> +	struct dir_hash_tab	*hashtab,
>  	uint32_t		addr,
>  	xfs_ino_t		inum,
>  	int			namelen,
> @@ -163,19 +163,18 @@ dir_hash_add(
>  	uint8_t			ftype)
>  {
>  	xfs_dahash_t		hash = 0;
> -	int			byaddr;
>  	int			byhash = 0;
> -	dir_hash_ent_t		*p;
> +	struct dir_hash_ent	*p;
>  	int			dup;
>  	short			junk;
>  	struct xfs_name		xname;
> +	int			error;
>  
>  	xname.name = name;
>  	xname.len = namelen;
>  	xname.type = ftype;
>  
>  	junk = name[0] == '/';
> -	byaddr = DIR_HASH_FUNC(hashtab, addr);
>  	dup = 0;
>  
>  	if (!junk) {
> @@ -205,8 +204,14 @@ dir_hash_add(
>  		do_error(_("malloc failed in dir_hash_add (%zu bytes)\n"),
>  			sizeof(*p));
>  
> -	p->nextbyaddr = hashtab->byaddr[byaddr];
> -	hashtab->byaddr[byaddr] = p;
> +	error = radix_tree_insert(&hashtab->byaddr, addr, p);
> +	if (error == EEXIST) {
> +		do_warn(_("duplicate addrs %u in directory!\n"), addr);
> +		free(p);
> +		return 0;
> +	}
> +	radix_tree_tag_set(&hashtab->byaddr, addr, HT_UNSEEN);
> +
>  	if (hashtab->last)
>  		hashtab->last->nextbyorder = p;
>  	else
> @@ -232,33 +237,14 @@ dir_hash_add(
>  	return !dup;
>  }
>  
> -/*
> - * checks to see if any data entries are not in the leaf blocks
> - */
> -static int
> -dir_hash_unseen(
> -	dir_hash_tab_t	*hashtab)
> -{
> -	int		i;
> -	dir_hash_ent_t	*p;
> -
> -	for (i = 0; i < hashtab->size; i++) {
> -		for (p = hashtab->byaddr[i]; p; p = p->nextbyaddr) {
> -			if (p->seen == 0)
> -				return 1;
> -		}
> -	}
> -	return 0;
> -}
> -
>  static int
>  dir_hash_check(
> -	dir_hash_tab_t	*hashtab,
> -	xfs_inode_t	*ip,
> -	int		seeval)
> +	struct dir_hash_tab	*hashtab,
> +	struct xfs_inode	*ip,
> +	int			seeval)
>  {
> -	static char	*seevalstr[DIR_HASH_CK_TOTAL];
> -	static int	done;
> +	static char		*seevalstr[DIR_HASH_CK_TOTAL];
> +	static int		done;
>  
>  	if (!done) {
>  		seevalstr[DIR_HASH_CK_OK] = _("ok");
> @@ -270,7 +256,8 @@ dir_hash_check(
>  		done = 1;
>  	}
>  
> -	if (seeval == DIR_HASH_CK_OK && dir_hash_unseen(hashtab))
> +	if (seeval == DIR_HASH_CK_OK &&
> +	    radix_tree_tagged(&hashtab->byaddr, HT_UNSEEN))
>  		seeval = DIR_HASH_CK_NOLEAF;
>  	if (seeval == DIR_HASH_CK_OK)
>  		return 0;
> @@ -285,27 +272,28 @@ dir_hash_check(
>  
>  static void
>  dir_hash_done(
> -	dir_hash_tab_t	*hashtab)
> +	struct dir_hash_tab	*hashtab)
>  {
> -	int		i;
> -	dir_hash_ent_t	*n;
> -	dir_hash_ent_t	*p;
> +	int			i;
> +	struct dir_hash_ent	*n;
> +	struct dir_hash_ent	*p;
>  
>  	for (i = 0; i < hashtab->size; i++) {
> -		for (p = hashtab->byaddr[i]; p; p = n) {
> -			n = p->nextbyaddr;
> +		for (p = hashtab->byhash[i]; p; p = n) {
> +			n = p->nextbyhash;
> +			radix_tree_delete(&hashtab->byaddr, p->address);
>  			free(p);
>  		}
>  	}
>  	free(hashtab);
>  }
>  
> -static dir_hash_tab_t *
> +static struct dir_hash_tab *
>  dir_hash_init(
> -	xfs_fsize_t	size)
> +	xfs_fsize_t		size)
>  {
> -	dir_hash_tab_t	*hashtab;
> -	int		hsize;
> +	struct dir_hash_tab	*hashtab;
> +	int			hsize;
>  
>  	hsize = size / (16 * 4);
>  	if (hsize > 65536)
> @@ -315,51 +303,43 @@ dir_hash_init(
>  	if ((hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1)) == NULL)
>  		do_error(_("calloc failed in dir_hash_init\n"));
>  	hashtab->size = hsize;
> -	hashtab->byhash = (dir_hash_ent_t**)((char *)hashtab +
> -		sizeof(dir_hash_tab_t));
> -	hashtab->byaddr = (dir_hash_ent_t**)((char *)hashtab +
> -		sizeof(dir_hash_tab_t) + sizeof(dir_hash_ent_t*) * hsize);
> +	hashtab->byhash = (struct dir_hash_ent **)((char *)hashtab +
> +		sizeof(struct dir_hash_tab));
> +	INIT_RADIX_TREE(&hashtab->byaddr, 0);
>  	return hashtab;
>  }
>  
>  static int
>  dir_hash_see(
> -	dir_hash_tab_t		*hashtab,
> +	struct dir_hash_tab	*hashtab,
>  	xfs_dahash_t		hash,
>  	xfs_dir2_dataptr_t	addr)
>  {
> -	int			i;
> -	dir_hash_ent_t		*p;
> +	struct dir_hash_ent	*p;
>  
> -	i = DIR_HASH_FUNC(hashtab, addr);
> -	for (p = hashtab->byaddr[i]; p; p = p->nextbyaddr) {
> -		if (p->address != addr)
> -			continue;
> -		if (p->seen)
> -			return DIR_HASH_CK_DUPLEAF;
> -		if (p->junkit == 0 && p->hashval != hash)
> -			return DIR_HASH_CK_BADHASH;
> -		p->seen = 1;
> -		return DIR_HASH_CK_OK;
> -	}
> -	return DIR_HASH_CK_NODATA;
> +	p = radix_tree_lookup(&hashtab->byaddr, addr);
> +	if (!p)
> +		return DIR_HASH_CK_NODATA;
> +	if (!radix_tree_tag_get(&hashtab->byaddr, addr, HT_UNSEEN))
> +		return DIR_HASH_CK_DUPLEAF;
> +	if (p->junkit == 0 && p->hashval != hash)
> +		return DIR_HASH_CK_BADHASH;
> +	radix_tree_tag_clear(&hashtab->byaddr, addr, HT_UNSEEN);
> +	return DIR_HASH_CK_OK;
>  }
>  
>  static void
>  dir_hash_update_ftype(
> -	dir_hash_tab_t		*hashtab,
> +	struct dir_hash_tab	*hashtab,
>  	xfs_dir2_dataptr_t	addr,
>  	uint8_t			ftype)
>  {
> -	int			i;
> -	dir_hash_ent_t		*p;
> +	struct dir_hash_ent	*p;
>  
> -	i = DIR_HASH_FUNC(hashtab, addr);
> -	for (p = hashtab->byaddr[i]; p; p = p->nextbyaddr) {
> -		if (p->address != addr)
> -			continue;
> -		p->name.type = ftype;
> -	}
> +	p = radix_tree_lookup(&hashtab->byaddr, addr);
> +	if (!p)
> +		return;
> +	p->name.type = ftype;
>  }
>  
>  /*
> @@ -368,7 +348,7 @@ dir_hash_update_ftype(
>   */
>  static int
>  dir_hash_see_all(
> -	dir_hash_tab_t		*hashtab,
> +	struct dir_hash_tab	*hashtab,
>  	xfs_dir2_leaf_entry_t	*ents,
>  	int			count,
>  	int			stale)
> @@ -1222,19 +1202,19 @@ dir_binval(
>  
>  static void
>  longform_dir2_rebuild(
> -	xfs_mount_t		*mp,
> +	struct xfs_mount	*mp,
>  	xfs_ino_t		ino,
> -	xfs_inode_t		*ip,
> -	ino_tree_node_t		*irec,
> +	struct xfs_inode	*ip,
> +	struct ino_tree_node	*irec,
>  	int			ino_offset,
> -	dir_hash_tab_t		*hashtab)
> +	struct dir_hash_tab	*hashtab)
>  {
>  	int			error;
>  	int			nres;
> -	xfs_trans_t		*tp;
> +	struct xfs_trans	*tp;
>  	xfs_fileoff_t		lastblock;
> -	xfs_inode_t		pip;
> -	dir_hash_ent_t		*p;
> +	struct xfs_inode	pip;
> +	struct dir_hash_ent	*p;
>  	int			done = 0;
>  
>  	/*
> @@ -1393,14 +1373,14 @@ _("directory shrink failed (%d)\n"), error);
>   */
>  static void
>  longform_dir2_entry_check_data(
> -	xfs_mount_t		*mp,
> -	xfs_inode_t		*ip,
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*ip,
>  	int			*num_illegal,
>  	int			*need_dot,
> -	ino_tree_node_t		*current_irec,
> +	struct ino_tree_node	*current_irec,
>  	int			current_ino_offset,
>  	struct xfs_buf		*bp,
> -	dir_hash_tab_t		*hashtab,
> +	struct dir_hash_tab	*hashtab,
>  	freetab_t		**freetabp,
>  	xfs_dablk_t		da_bno,
>  	int			isblock)
> @@ -1927,10 +1907,10 @@ check_dir3_header(
>   */
>  static int
>  longform_dir2_check_leaf(
> -	xfs_mount_t		*mp,
> -	xfs_inode_t		*ip,
> -	dir_hash_tab_t		*hashtab,
> -	freetab_t		*freetab)
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*ip,
> +	struct dir_hash_tab	*hashtab,
> +	struct freetab		*freetab)
>  {
>  	int			badtail;
>  	__be16			*bestsp;
> @@ -2012,10 +1992,10 @@ longform_dir2_check_leaf(
>   */
>  static int
>  longform_dir2_check_node(
> -	xfs_mount_t		*mp,
> -	xfs_inode_t		*ip,
> -	dir_hash_tab_t		*hashtab,
> -	freetab_t		*freetab)
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*ip,
> +	struct dir_hash_tab	*hashtab,
> +	struct freetab		*freetab)
>  {
>  	struct xfs_buf		*bp;
>  	xfs_dablk_t		da_bno;
> @@ -2187,14 +2167,15 @@ longform_dir2_check_node(
>   * (ie. get libxfs to do all the grunt work)
>   */
>  static void
> -longform_dir2_entry_check(xfs_mount_t	*mp,
> -			xfs_ino_t	ino,
> -			xfs_inode_t	*ip,
> -			int		*num_illegal,
> -			int		*need_dot,
> -			ino_tree_node_t	*irec,
> -			int		ino_offset,
> -			dir_hash_tab_t	*hashtab)
> +longform_dir2_entry_check(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	struct xfs_inode	*ip,
> +	int			*num_illegal,
> +	int			*need_dot,
> +	struct ino_tree_node	*irec,
> +	int			ino_offset,
> +	struct dir_hash_tab	*hashtab)
>  {
>  	struct xfs_buf		*bp;
>  	xfs_dablk_t		da_bno;
> @@ -2397,13 +2378,14 @@ shortform_dir2_junk(
>  }
>  
>  static void
> -shortform_dir2_entry_check(xfs_mount_t	*mp,
> -			xfs_ino_t	ino,
> -			xfs_inode_t	*ip,
> -			int		*ino_dirty,
> -			ino_tree_node_t	*current_irec,
> -			int		current_ino_offset,
> -			dir_hash_tab_t	*hashtab)
> +shortform_dir2_entry_check(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	struct xfs_inode	*ip,
> +	int			*ino_dirty,
> +	struct ino_tree_node	*current_irec,
> +	int			current_ino_offset,
> +	struct dir_hash_tab	*hashtab)
>  {
>  	xfs_ino_t		lino;
>  	xfs_ino_t		parent;
> @@ -2745,15 +2727,15 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>   */
>  static void
>  process_dir_inode(
> -	xfs_mount_t 		*mp,
> +	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
> -	ino_tree_node_t		*irec,
> +	struct ino_tree_node	*irec,
>  	int			ino_offset)
>  {
>  	xfs_ino_t		ino;
> -	xfs_inode_t		*ip;
> -	xfs_trans_t		*tp;
> -	dir_hash_tab_t		*hashtab;
> +	struct xfs_inode	*ip;
> +	struct xfs_trans	*tp;
> +	struct dir_hash_tab	*hashtab;
>  	int			need_dot;
>  	int			dirty, num_illegal, error, nres;
>  
> -- 
> 2.30.1
> 
