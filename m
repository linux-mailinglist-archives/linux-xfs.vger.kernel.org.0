Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3779852C897
	for <lists+linux-xfs@lfdr.de>; Thu, 19 May 2022 02:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiESA1n (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 May 2022 20:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiESA1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 20:27:38 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD55B14FC9B
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 17:27:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 72147534559;
        Thu, 19 May 2022 10:27:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrU0l-00DeWh-44; Thu, 19 May 2022 10:27:27 +1000
Date:   Thu, 19 May 2022 10:27:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 2/3] xfs: share xattr name and value buffers when logging
 xattr updates
Message-ID: <20220519002727.GR1098723@dread.disaster.area>
References: <165290010248.1646163.12346986876716116665.stgit@magnolia>
 <165290011382.1646163.15379392968983343462.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165290011382.1646163.15379392968983343462.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62858ef1
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=0yYSzzcfNaPYpk2VbB4A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 11:55:13AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running xfs/297 and generic/642, I noticed a crash in
> xfs_attri_item_relog when it tries to copy the attr name to the new
> xattri log item.  I think what happened here was that we called
> ->iop_commit on the old attri item (which nulls out the pointers) as
> part of a log force at the same time that a chained attr operation was
> ongoing.  The system was busy enough that at some later point, the defer
> ops operation decided it was necessary to relog the attri log item, but
> as we've detached the name buffer from the old attri log item, we can't
> copy it to the new one, and kaboom.
> 
> I think there's a broader refcounting problem with LARP mode -- the
> setxattr code can return to userspace before the CIL actually formats
> and commits the log item, which results in a UAF bug.  Therefore, the
> xattr log item needs to be able to retain a reference to the name and
> value buffers until the log items have completely cleared the log.
> Furthermore, each time we create an intent log item, we allocate new
> memory and (re)copy the contents; sharing here would be very useful.
> 
> Solve the UAF and the unnecessary memory allocations by having the log
> code create a single refcounted buffer to contain the name and value
> contents.  This buffer can be passed from old to new during a relog
> operation, and the logging code can (optionally) attach it to the
> xfs_attr_item for reuse when LARP mode is enabled.
> 
> This also fixes a problem where the xfs_attri_log_item objects weren't
> being freed back to the same cache where they came from.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.h |    8 +
>  fs/xfs/xfs_attr_item.c   |  279 +++++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_attr_item.h   |   13 +-
>  3 files changed, 182 insertions(+), 118 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 1af7abe29eef..17746dcc2268 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -501,6 +501,8 @@ enum xfs_delattr_state {
>  	{ XFS_DAS_NODE_REMOVE_ATTR,	"XFS_DAS_NODE_REMOVE_ATTR" }, \
>  	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
>  
> +struct xfs_attri_log_nameval;

Ok, so this structure is:

struct xfs_attri_log_nameval {
	refcount_t		anvl_refcount;
	unsigned int		anvl_name_len;
	unsigned int		anvl_value_len;

	/* name and value follow the end of this struct */
};

If we are going to have a custom structure for this, let's actually
do it properly and not use magic pointers for the name/value
buffers. These are effectively iovecs, and we already do this
properly with log iovecs in shadow buffers. i.e:

struct xfs_attri_log_nameval {
	refcount_t		refcount;
	struct xfs_log_iovec	name;
	struct xfs_log_iovec	value;

	/* name and value follow the end of this struct */
};

When we set up the structure:

	nv.name.i_addr = (void *)&nv + 1;
	nv.name.i_len = name_len;
	memcpy(nv.name.i_addr, name, name_len);
	if (value_len) {
		nv.value.i_addr = nv.name.i_addr + nv.name.i_len;
		nv.value.i_len = value_len;
		memcpy(nv.value.i_addr, value, value_len);
	}

And from that point onwards we only ever use the i_addr/i_len pairs
to refer to the name/values. We don't need pointer magic anywhere
but the setup code.

(Also, "anvil"? Too clever by half and unnecessily verbose. It's a
just {name, value} pair, call it "nv").

>  /*
>   * Defines for xfs_attr_item.xattri_flags
>   */
> @@ -512,6 +514,12 @@ enum xfs_delattr_state {
>  struct xfs_attr_item {
>  	struct xfs_da_args		*xattri_da_args;
>  
> +	/*
> +	 * Shared buffer containing the attr name and value so that the logging
> +	 * code can share large memory buffers between log items.
> +	 */
> +	struct xfs_attri_log_nameval	*xattri_nameval;
> +
>  	/*
>  	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
>  	 */
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 4976b1ddc09f..7d4469e8a4fc 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -39,12 +39,91 @@ static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
>  	return container_of(lip, struct xfs_attri_log_item, attri_item);
>  }
>  
> +/*
> + * Shared xattr name/value buffers for logged extended attribute operations
> + *
> + * When logging updates to extended attributes, we can create quite a few
> + * attribute log intent items for a single xattr update.  To avoid cycling the
> + * memory allocator and memcpy overhead, the name (and value, for setxattr)
> + * are kept in a refcounted object that is shared across all related log items
> + * and the upper-level deferred work state structure.  The shared buffer has
> + * a control structure, followed by the name, and then the value.
> + */
> +
> +static inline struct xfs_attri_log_nameval *
> +xfs_attri_log_nameval_get(
> +	struct xfs_attri_log_nameval	*anvl)
> +{
> +	BUG_ON(!refcount_inc_not_zero(&anvl->anvl_refcount));
> +	return anvl;

No BUG_ON() error handling.

ASSERT or WARN, return NULL on failure. Handle failure in the
caller.

> +}
> +
> +static inline void
> +xfs_attri_log_nameval_put(
> +	struct xfs_attri_log_nameval	*anvl)
> +{
> +	if (refcount_dec_and_test(&anvl->anvl_refcount))
> +		kvfree(anvl);
> +}
> +
> +static inline void *
> +xfs_attri_log_namebuf(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	return attrip->attri_nameval + 1;

I don't know what this points to just looking at this. Trying to
work out if it points to an address in the attri_nameval region or
whether it points to something in the attrip structure makes my head
hurt.  I'd much prefer this be written as:

	return attrip->attri_nameval->name.i_addr;

Because it explicitly encodes exactly what buffer we are returning
here. And with this, we probably don't even need the wrapper
function now.

> +}
> +
> +static inline void *
> +xfs_attri_log_valbuf(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	struct xfs_attri_log_nameval	*anvl = attrip->attri_nameval;
> +
> +	if (anvl->anvl_value_len == 0)
> +		return NULL;
> +
> +	return (char *)xfs_attri_log_namebuf(attrip) + anvl->anvl_name_len;
> +}

And this becomes:

	return attrip->attri_nameval->value.i_addr;

Because it is initialised to NULL if there is no value.

I think the need for this wrapper goes away, too.

> +
> +static inline struct xfs_attri_log_nameval *
> +xfs_attri_log_nameval_alloc(
> +	const void			*name,
> +	unsigned int			name_len,
> +	const void			*value,
> +	unsigned int			value_len)
> +{
> +	struct xfs_attri_log_nameval	*anvl;
> +	void				*p;
> +
> +	/*
> +	 * This could be over 64kB in length, so we have to use kvmalloc() for
> +	 * this. But kvmalloc() utterly sucks, so we use our own version.
> +	 */
> +	anvl = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
> +					name_len + value_len);
> +	if (!anvl)
> +		return anvl;
> +
> +	anvl->anvl_name_len = name_len;
> +	anvl->anvl_value_len = value_len;

I'm really starting to dislike all the 4 and 5 letter variable name
prefixs in the new attr code. They are all just repeating the
variable name and so are largely redundant and makes the code
very verbose for no good reason. This:

	anvl->name_len = name_len;
	anvl->value_len = value_len;

is better because it is shorter and conveys exactly the same
information to the reader.

> +	p = anvl + 1;
> +	memcpy(p, name, name_len);
> +	if (value_len) {
> +		p += name_len;
> +		memcpy(p, value, value_len);
> +	}
> +	refcount_set(&anvl->anvl_refcount, 1);
> +	return anvl;
> +}
> +
>  STATIC void
>  xfs_attri_item_free(
>  	struct xfs_attri_log_item	*attrip)
>  {
>  	kmem_free(attrip->attri_item.li_lv_shadow);
> -	kvfree(attrip);
> +	if (attrip->attri_nameval)
> +		xfs_attri_log_nameval_put(attrip->attri_nameval);

Handle the NULL inside xfs_attri_log_nameval_put().

....

> @@ -108,22 +189,22 @@ xfs_attri_item_format(
>  	 * the log recovery.
>  	 */
>  
> -	ASSERT(attrip->attri_name_len > 0);
> +	ASSERT(anvl->anvl_name_len > 0);
>  	attrip->attri_format.alfi_size++;
>  
> -	if (attrip->attri_value_len > 0)
> +	if (anvl->anvl_value_len > 0)
>  		attrip->attri_format.alfi_size++;
>  
>  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
>  			&attrip->attri_format,
>  			sizeof(struct xfs_attri_log_format));
>  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
> -			attrip->attri_name,
> -			attrip->attri_name_len);
> -	if (attrip->attri_value_len > 0)
> +			xfs_attri_log_namebuf(attrip),
> +			anvl->anvl_name_len);

Yeah, these wrappers to retrieve the actual buffer need to die.

FWIW, If we've already got the name encoded in a log iovec, add a
xlog_copy_from_iovec() method that handles empty iovecs and just
replace all this code with:

	xlog_copy_from_iovec(lv, &vecp, nv->name);
	xlog_copy_from_iovec(lv, &vecp, nv->value);

This is the first step towards sharing the NV buffer deep into the
CIL commit code so the shadow buffer doesn't need to allocate
another 64kB and copy that 64kB every time we log a new intent.

Not necessary for this patch, but I really want start in that
direction to get away from magic buffers so that the future
optimisations we already know we need to make are easier to do.

> +	if (anvl->anvl_value_len > 0)
>  		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> -				attrip->attri_value,
> -				attrip->attri_value_len);
> +				xfs_attri_log_valbuf(attrip),
> +				anvl->anvl_value_len);
>  }
>  
>  /*
> @@ -158,41 +239,17 @@ xfs_attri_item_release(
>  STATIC struct xfs_attri_log_item *
>  xfs_attri_init(
>  	struct xfs_mount		*mp,
> -	uint32_t			name_len,
> -	uint32_t			value_len)
> -
> +	struct xfs_attri_log_nameval	*anvl)
>  {
>  	struct xfs_attri_log_item	*attrip;
> -	uint32_t			buffer_size = name_len + value_len;
>  
> -	if (buffer_size) {
> -		/*
> -		 * This could be over 64kB in length, so we have to use
> -		 * kvmalloc() for this. But kvmalloc() utterly sucks, so we
> -		 * use own version.
> -		 */
> -		attrip = xlog_kvmalloc(sizeof(struct xfs_attri_log_item) +
> -					buffer_size);
> -	} else {
> -		attrip = kmem_cache_alloc(xfs_attri_cache,
> -					GFP_NOFS | __GFP_NOFAIL);
> -	}
> -	memset(attrip, 0, sizeof(struct xfs_attri_log_item));
> +	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_NOFS | __GFP_NOFAIL);
>  
> -	attrip->attri_name_len = name_len;
> -	if (name_len)
> -		attrip->attri_name = ((char *)attrip) +
> -				sizeof(struct xfs_attri_log_item);
> -	else
> -		attrip->attri_name = NULL;
> -
> -	attrip->attri_value_len = value_len;
> -	if (value_len)
> -		attrip->attri_value = ((char *)attrip) +
> -				sizeof(struct xfs_attri_log_item) +
> -				name_len;
> -	else
> -		attrip->attri_value = NULL;
> +	/*
> +	 * Grab an extra reference to the name/value buffer for this log item.
> +	 * The caller retains its own reference!
> +	 */
> +	attrip->attri_nameval = xfs_attri_log_nameval_get(anvl);

Handle _get failure here, or better, pass in an already referenced
nv because the caller should always have a reference to begin
with. Caller can probably handle allocation failure, too, because
this should be called before we've dirtied the transaction, right?

.....

> @@ -385,16 +435,33 @@ xfs_attr_create_intent(
>  	 * Each attr item only performs one attribute operation at a time, so
>  	 * this is a list of one
>  	 */
> -	list_for_each_entry(attr, items, xattri_list) {
> -		attrip = xfs_attri_init(mp, attr->xattri_da_args->namelen,
> -					attr->xattri_da_args->valuelen);
> -		if (attrip == NULL)
> -			return NULL;
> +	attr = list_first_entry_or_null(items, struct xfs_attr_item,
> +			xattri_list);
>  
> -		xfs_trans_add_item(tp, &attrip->attri_item);
> -		xfs_attr_log_item(tp, attrip, attr);
> +	/*
> +	 * Create a buffer to store the attribute name and value.  This buffer
> +	 * will be shared between the higher level deferred xattr work state
> +	 * and the lower level xattr log items.
> +	 */
> +	if (!attr->xattri_nameval) {
> +		struct xfs_da_args	*args = attr->xattri_da_args;
> +
> +		/*
> +		 * Transfer our reference to the name/value buffer to the
> +		 * deferred work state structure.
> +		 */
> +		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
> +				args->namelen, args->value, args->valuelen);
> +	}
> +	if (!attr->xattri_nameval) {
> +		xlog_force_shutdown(mp->m_log, SHUTDOWN_LOG_IO_ERROR);
> +		return NULL;
>  	}

Why shutdown on ENOMEM? I would have expects that we return to the
caller so it can cancel the transaction. That way we only shut down
if the transaction is dirty or the caller context can't handle
errors....

>  
> +	attrip = xfs_attri_init(mp, attr->xattri_nameval);
> +	xfs_trans_add_item(tp, &attrip->attri_item);
> +	xfs_attr_log_item(tp, attrip, attr);
> +
>  	return &attrip->attri_item;
>  }
>  
> @@ -404,6 +471,8 @@ xfs_attr_free_item(
>  {
>  	if (attr->xattri_da_state)
>  		xfs_da_state_free(attr->xattri_da_state);
> +	if (attr->xattri_nameval)
> +		xfs_attri_log_nameval_put(attr->xattri_nameval);

Handle the null inside xfs_attri_log_nameval_put().

> @@ -567,10 +615,17 @@ xfs_attri_item_recover(
>  	attr->xattri_op_flags = attrp->alfi_op_flags &
>  						XFS_ATTR_OP_FLAGS_TYPE_MASK;
>  
> +	/*
> +	 * We're reconstructing the deferred work state structure from the
> +	 * recovered log item.  Grab a reference to the name/value buffer and
> +	 * attach it to the new work state.
> +	 */
> +	attr->xattri_nameval = xfs_attri_log_nameval_get(anvl);

and handle NULL here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
