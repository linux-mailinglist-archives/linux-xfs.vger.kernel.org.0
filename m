Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD0E2B13DD
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Nov 2020 02:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgKMBe0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Nov 2020 20:34:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44876 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKMBe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 20:34:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1YDst010775
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2LIgE85wPqKUN189kTTVC4MXYK3zzOfxOB1AooBHR2A=;
 b=FZsm8iGgFpcZHcBh83w75eFj/dKxmO7GrVK1fltwkznUulsM6EoWKrpZqAJ+HdMd9H9U
 tM+LTy4ZfY4wamsS38DiGjXH45R7j9uIlt7ekzqpBg8jNXEo7CxwVi9YGduAnPHV2ZI5
 /qc8KrfJYl/VscWYYepc0oUaW+tmfz83gw3xiOu3PUzmggEXuzPQEuCt5Sklmz7CPzXv
 hNYnWKNZAhCgTa16rA+0emRpLvG43VfzxG3c8onT4kmE+uqxRWW7U9tXs9cmyDeIRMB9
 TogT0ISp7gosn6GVdLNy/n7VnEXkbfQTZy2epdjwCfxckkDTp01u4mVYe2NeGQy4OHpl mQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34nh3b8n3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:34:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1VKj9149230
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:32:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34p55s6yvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:32:17 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AD1WFaM007776
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:32:16 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 17:32:15 -0800
Subject: Re: [PATCH v13 05/10] xfs: Set up infastructure for deferred
 attribute operations
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-6-allison.henderson@oracle.com>
 <20201110215149.GG9695@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4f197703-f56d-5f43-c2da-a6e48b32952f@oracle.com>
Date:   Thu, 12 Nov 2020 18:32:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201110215149.GG9695@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130006
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/10/20 2:51 PM, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 11:34:30PM -0700, Allison Henderson wrote:
>> Currently attributes are modified directly across one or more
>> transactions. But they are not logged or replayed in the event of an
>> error. The goal of delayed attributes is to enable logging and replaying
>> of attribute operations using the existing delayed operations
>> infrastructure.  This will later enable the attributes to become part of
>> larger multi part operations that also must first be recorded to the
>> log.  This is mostly of interest in the scheme of parent pointers which
>> would need to maintain an attribute containing parent inode information
>> any time an inode is moved, created, or removed.  Parent pointers would
>> then be of interest to any feature that would need to quickly derive an
>> inode path from the mount point. Online scrub, nfs lookups and fs grow
>> or shrink operations are all features that could take advantage of this.
>>
>> This patch adds two new log item types for setting or removing
>> attributes as deferred operations.  The xfs_attri_log_item logs an
>> intent to set or remove an attribute.  The corresponding
>> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
>> freed once the transaction is done.  Both log items use a generic
>> xfs_attr_log_format structure that contains the attribute name, value,
>> flags, inode, and an op_flag that indicates if the operations is a set
>> or remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/Makefile                 |   1 +
>>   fs/xfs/libxfs/xfs_attr.c        |   7 +-
>>   fs/xfs/libxfs/xfs_attr.h        |  19 +
>>   fs/xfs/libxfs/xfs_defer.c       |   1 +
>>   fs/xfs/libxfs/xfs_defer.h       |   3 +
>>   fs/xfs/libxfs/xfs_format.h      |   5 +
>>   fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
>>   fs/xfs/libxfs/xfs_log_recover.h |   2 +
>>   fs/xfs/libxfs/xfs_types.h       |   1 +
>>   fs/xfs/scrub/common.c           |   2 +
>>   fs/xfs/xfs_acl.c                |   2 +
>>   fs/xfs/xfs_attr_item.c          | 750 ++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr_item.h          |  76 ++++
>>   fs/xfs/xfs_attr_list.c          |   1 +
>>   fs/xfs/xfs_ioctl.c              |   2 +
>>   fs/xfs/xfs_ioctl32.c            |   2 +
>>   fs/xfs/xfs_iops.c               |   2 +
>>   fs/xfs/xfs_log.c                |   4 +
>>   fs/xfs/xfs_log_recover.c        |   2 +
>>   fs/xfs/xfs_ondisk.h             |   2 +
>>   fs/xfs/xfs_xattr.c              |   1 +
>>   21 files changed, 923 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
>> index 04611a1..b056cfc 100644
>> --- a/fs/xfs/Makefile
>> +++ b/fs/xfs/Makefile
>> @@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
>>   				   xfs_buf_item_recover.o \
>>   				   xfs_dquot_item_recover.o \
>>   				   xfs_extfree_item.o \
>> +				   xfs_attr_item.o \
>>   				   xfs_icreate_item.o \
>>   				   xfs_inode_item.o \
>>   				   xfs_inode_item_recover.o \
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 6453178..760383c 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -24,6 +24,7 @@
>>   #include "xfs_quota.h"
>>   #include "xfs_trans_space.h"
>>   #include "xfs_trace.h"
>> +#include "xfs_attr_item.h"
>>   
>>   /*
>>    * xfs_attr.c
>> @@ -59,8 +60,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>> -STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> -			     struct xfs_buf **leaf_bp);
>>   
>>   int
>>   xfs_inode_hasattr(
>> @@ -142,7 +141,7 @@ xfs_attr_get(
>>   /*
>>    * Calculate how many blocks we need for the new attribute,
>>    */
>> -STATIC int
>> +int
>>   xfs_attr_calc_size(
>>   	struct xfs_da_args	*args,
>>   	int			*local)
>> @@ -327,7 +326,7 @@ xfs_attr_set_args(
>>    * to handle this, and recall the function until a successful error code is
>>    * returned.
>>    */
>> -STATIC int
>> +int
>>   xfs_attr_set_iter(
>>   	struct xfs_delattr_context	*dac,
>>   	struct xfs_buf			**leaf_bp)
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 501f9df..5b4a1ca 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -247,6 +247,7 @@ enum xfs_delattr_state {
>>   #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>>   #define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
>>   #define XFS_DAC_LEAF_ADDNAME_INIT	0x04 /* xfs_attr_leaf_addname init*/
>> +#define XFS_DAC_DELAYED_OP_INIT		0x08 /* delayed operations init*/
>>   
>>   /*
>>    * Context used for keeping track of delayed attribute operations
>> @@ -254,6 +255,9 @@ enum xfs_delattr_state {
>>   struct xfs_delattr_context {
>>   	struct xfs_da_args      *da_args;
>>   
>> +	/* Used by delayed attributes to hold leaf across transactions */
> 
> "Used by xfs_attr_set to hold a leaf buffer across a transaction roll" ?
Sure, will update

> 
>> +	struct xfs_buf		*leaf_bp;
>> +
>>   	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
>>   	struct xfs_bmbt_irec	map;
>>   	xfs_dablk_t		lblkno;
>> @@ -267,6 +271,18 @@ struct xfs_delattr_context {
>>   	enum xfs_delattr_state  dela_state;
>>   };
>>   
>> +/*
>> + * List of attrs to commit later.
>> + */
>> +struct xfs_attr_item {
>> +	struct xfs_delattr_context	xattri_dac;
>> +	uint32_t			xattri_op_flags;/* attr op set or rm */
> 
> The comment for xattri_op_flags should be more direct in mentioning that
> it takes XFS_ATTR_OP_FLAGS_{SET,REMOVE}.
Alrighty, will do

> 
> (Alternately you could define an enum for the incore state tracker that
> causes the appropriate XFS_ATTR_OP_FLAG* to be set on the log item in
> xfs_attr_create_intent to avoid mixing of the flag namespaces, but that
> is a lot of paper-pushing...)
> 
>> +
>> +	/* used to log this item to an intent */
>> +	struct list_head		xattri_list;
>> +};
> 
> Ok, so going back to a confusing comment I had from the last series,
> I'm glad that you've moved all the attr code to be deferred operations.
> 
> Can you move all the xfs_delattr_context fields into xfs_attr_item?
> AFAICT (from git diff'ing the entire branch :P) we never allocate an
> xfs_delattr_context on its own; we only ever access the one that's
> embedded in xfs_attr_item, right?
Well, xfs_delattr_context is used earlier in the set by the top level 
routines xfs_attr_set/remove_args.  If we did this, it would pull the 
attr_item in the the lower part of the "delay ready" subseries, and I 
think people really just wanted that part to be "refactor only" just for 
reasons of making the reviewing easier.

How about an extra patch at the end that merges these struct after those 
high level functions back out?  That way we're not trying to introduce 
the log items before this patch?  That seems like a reasonable way to 
phase in the end result.

Also, such a change would imply that a lot of these lower level attr 
routines that sensitive the the state machine mechanics are not passing 
around a xfs_delattr_context any more, now they take a xfs_attr_item. 
Not entirly sure how people would feel about that, but again, I figure 
if we save it for the end, it's easy to take it or leave it with out 
causing too much surgery below.

> 
>> +
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -282,11 +298,14 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> +		      struct xfs_buf **leaf_bp);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>> +int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index eff4a12..e9caff7 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>>   };
>>   
>>   static void
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 05472f7..72a5789 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>>   	XFS_DEFER_OPS_TYPE_RMAP,
>>   	XFS_DEFER_OPS_TYPE_FREE,
>>   	XFS_DEFER_OPS_TYPE_AGFL_FREE,
>> +	XFS_DEFER_OPS_TYPE_ATTR,
>>   	XFS_DEFER_OPS_TYPE_MAX,
>>   };
>>   
>> @@ -63,6 +64,8 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>>   extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
>> +extern const struct xfs_defer_op_type xfs_attr_defer_type;
>> +
>>   
>>   /*
>>    * This structure enables a dfops user to detach the chain of deferred
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index dd764da..d419c34 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -584,6 +584,11 @@ static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
>>   		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
>>   }
>>   
>> +static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
>> +{
>> +	return false;
>> +}
>> +
>>   /*
>>    * end of superblock version macros
>>    */
>> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
>> index 8bd00da..de6309d 100644
>> --- a/fs/xfs/libxfs/xfs_log_format.h
>> +++ b/fs/xfs/libxfs/xfs_log_format.h
>> @@ -117,7 +117,12 @@ struct xfs_unmount_log_format {
>>   #define XLOG_REG_TYPE_CUD_FORMAT	24
>>   #define XLOG_REG_TYPE_BUI_FORMAT	25
>>   #define XLOG_REG_TYPE_BUD_FORMAT	26
>> -#define XLOG_REG_TYPE_MAX		26
>> +#define XLOG_REG_TYPE_ATTRI_FORMAT	27
>> +#define XLOG_REG_TYPE_ATTRD_FORMAT	28
>> +#define XLOG_REG_TYPE_ATTR_NAME	29
>> +#define XLOG_REG_TYPE_ATTR_VALUE	30
>> +#define XLOG_REG_TYPE_MAX		30
>> +
>>   
>>   /*
>>    * Flags to log operation header
>> @@ -240,6 +245,8 @@ typedef struct xfs_trans_header {
>>   #define	XFS_LI_CUD		0x1243
>>   #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
>>   #define	XFS_LI_BUD		0x1245
>> +#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
>> +#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
>>   
>>   #define XFS_LI_TYPE_DESC \
>>   	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
>> @@ -255,7 +262,9 @@ typedef struct xfs_trans_header {
>>   	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
>>   	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
>>   	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
>> -	{ XFS_LI_BUD,		"XFS_LI_BUD" }
>> +	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
>> +	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
>> +	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
>>   
>>   /*
>>    * Inode Log Item Format definitions.
>> @@ -863,4 +872,35 @@ struct xfs_icreate_log {
>>   	__be32		icl_gen;	/* inode generation number to use */
>>   };
>>   
>> +/*
>> + * Flags for deferred attribute operations.
>> + * Upper bits are flags, lower byte is type code
>> + */
>> +#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
>> +#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
>> +#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0x0FF	/* Flags type mask */
>> +
>> +/*
>> + * This is the structure used to lay out an attr log item in the
>> + * log.
>> + */
>> +struct xfs_attri_log_format {
>> +	uint16_t	alfi_type;	/* attri log item type */
>> +	uint16_t	alfi_size;	/* size of this item */
>> +	uint32_t	__pad;		/* pad to 64 bit aligned */
>> +	uint64_t	alfi_id;	/* attri identifier */
>> +	xfs_ino_t	alfi_ino;	/* the inode for this attr operation */
> 
> This is an ondisk structure; please use only explicitly sized data
> types like uint64_t.
Ok, will update

> 
>> +	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
>> +	uint32_t	alfi_name_len;	/* attr name length */
>> +	uint32_t	alfi_value_len;	/* attr value length */
>> +	uint32_t	alfi_attr_flags;/* attr flags */
>> +};
>> +
>> +struct xfs_attrd_log_format {
>> +	uint16_t	alfd_type;	/* attrd log item type */
>> +	uint16_t	alfd_size;	/* size of this item */
>> +	uint32_t	__pad;		/* pad to 64 bit aligned */
>> +	uint64_t	alfd_alf_id;	/* id of corresponding attrd */
> 
> "..of corresponding attri"
Yes, corresponding attri :-)

> 
>> +};
>> +
>>   #endif /* __XFS_LOG_FORMAT_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
>> index 3cca2bf..b6e5514 100644
>> --- a/fs/xfs/libxfs/xfs_log_recover.h
>> +++ b/fs/xfs/libxfs/xfs_log_recover.h
>> @@ -72,6 +72,8 @@ extern const struct xlog_recover_item_ops xlog_rui_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_rud_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_cui_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_cud_item_ops;
>> +extern const struct xlog_recover_item_ops xlog_attri_item_ops;
>> +extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
>>   
>>   /*
>>    * Macros, structures, prototypes for internal log manager use.
>> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
>> index 397d947..860cdd2 100644
>> --- a/fs/xfs/libxfs/xfs_types.h
>> +++ b/fs/xfs/libxfs/xfs_types.h
>> @@ -11,6 +11,7 @@ typedef uint32_t	prid_t;		/* project ID */
>>   typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
>>   typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
>>   typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
>> +typedef uint32_t	xfs_attrlen_t;	/* attr length */
> 
> This doesn't get used anywhere.
Ok, will clean out.

> 
>>   typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
>>   typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
>>   typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>> index 1887605..9a649d1 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -24,6 +24,8 @@
>>   #include "xfs_rmap_btree.h"
>>   #include "xfs_log.h"
>>   #include "xfs_trans_priv.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_reflink.h"
>>   #include "scrub/scrub.h"
>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> index c544951..cad1db4 100644
>> --- a/fs/xfs/xfs_acl.c
>> +++ b/fs/xfs/xfs_acl.c
>> @@ -10,6 +10,8 @@
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_error.h"
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> new file mode 100644
>> index 0000000..3980066
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -0,0 +1,750 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> 
> 2019 -> 2020.
Will update.  :-)

> 
>> + * Author: Allison Collins <allison.henderson@oracle.com>
>> + */
>> +
>> +#include "xfs.h"
>> +#include "xfs_fs.h"
>> +#include "xfs_format.h"
>> +#include "xfs_log_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_bit.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_mount.h"
>> +#include "xfs_defer.h"
>> +#include "xfs_trans.h"
>> +#include "xfs_trans_priv.h"
>> +#include "xfs_buf_item.h"
>> +#include "xfs_attr_item.h"
>> +#include "xfs_log.h"
>> +#include "xfs_btree.h"
>> +#include "xfs_rmap.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_icache.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>> +#include "xfs_attr.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_attr_item.h"
>> +#include "xfs_alloc.h"
>> +#include "xfs_bmap.h"
>> +#include "xfs_trace.h"
>> +#include "libxfs/xfs_da_format.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_quota.h"
>> +#include "xfs_log_priv.h"
>> +#include "xfs_log_recover.h"
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops;
>> +static const struct xfs_item_ops xfs_attrd_item_ops;
>> +
>> +static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
>> +{
>> +	return container_of(lip, struct xfs_attri_log_item, attri_item);
>> +}
>> +
>> +STATIC void
>> +xfs_attri_item_free(
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	kmem_free(attrip->attri_item.li_lv_shadow);
>> +	kmem_free(attrip);
>> +}
>> +
>> +/*
>> + * Freeing the attrip requires that we remove it from the AIL if it has already
>> + * been placed there. However, the ATTRI may not yet have been placed in the
>> + * AIL when called by xfs_attri_release() from ATTRD processing due to the
>> + * ordering of committed vs unpin operations in bulk insert operations. Hence
>> + * the reference count to ensure only the last caller frees the ATTRI.
>> + */
>> +STATIC void
>> +xfs_attri_release(
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
>> +	if (atomic_dec_and_test(&attrip->attri_refcount)) {
>> +		xfs_trans_ail_delete(&attrip->attri_item,
>> +				     SHUTDOWN_LOG_IO_ERROR);
>> +		xfs_attri_item_free(attrip);
>> +	}
>> +}
>> +
>> +/*
>> + * This returns the number of iovecs needed to log the given attri item. We
>> + * only need 1 iovec for an attri item.  It just logs the attr_log_format
>> + * structure.
>> + */
>> +static inline int
>> +xfs_attri_item_sizeof(
>> +	struct xfs_attri_log_item *attrip)
>> +{
>> +	return sizeof(struct xfs_attri_log_format);
>> +}
> 
> Please get rid of this trivial oneliner.
Sure, I think some of this I added just for reasons of being consistent 
with how the other delayed ops are implemented.

> 
>> +
>> +STATIC void
>> +xfs_attri_item_size(
>> +	struct xfs_log_item	*lip,
>> +	int			*nvecs,
>> +	int			*nbytes)
>> +{
>> +	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
>> +
>> +	*nvecs += 1;
>> +	*nbytes += xfs_attri_item_sizeof(attrip);
>> +
>> +	/* Attr set and remove operations require a name */
>> +	ASSERT(attrip->attri_name_len > 0);
>> +
>> +	*nvecs += 1;
>> +	*nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
>> +
>> +	/*
>> +	 * Set ops can accept a value of 0 len to clear an attr value.  Remove
>> +	 * ops do not need a value at all.  So only account for the value
>> +	 * when it is needed.
>> +	 */
>> +	if (attrip->attri_value_len > 0) {
>> +		*nvecs += 1;
>> +		*nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
>> +	}
>> +}
>> +
>> +/*
>> + * This is called to fill in the log iovecs for the given attri log
>> + * item. We use  1 iovec for the attri_format_item, 1 for the name, and
>> + * another for the value if it is present
>> + */
>> +STATIC void
>> +xfs_attri_item_format(
>> +	struct xfs_log_item	*lip,
>> +	struct xfs_log_vec	*lv)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_log_iovec		*vecp = NULL;
>> +
>> +	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
>> +	attrip->attri_format.alfi_size = 1;
>> +
>> +	/*
>> +	 * This size accounting must be done before copying the attrip into the
>> +	 * iovec.  If we do it after, the wrong size will be recorded to the log
>> +	 * and we trip across assertion checks for bad region sizes later during
>> +	 * the log recovery.
>> +	 */
>> +
>> +	ASSERT(attrip->attri_name_len > 0);
>> +	attrip->attri_format.alfi_size++;
>> +
>> +	if (attrip->attri_value_len > 0)
>> +		attrip->attri_format.alfi_size++;
>> +
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
>> +			&attrip->attri_format,
>> +			xfs_attri_item_sizeof(attrip));
>> +	if (attrip->attri_name_len > 0)
> 
> I thought we required attri_name_len > 0 always?
I think so.  I think this check may have come up in one of the earlier 
reviews.  I'll add a comment here, we even have the assert a few lines up.

> 
>> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
>> +				attrip->attri_name,
>> +				ATTR_NVEC_SIZE(attrip->attri_name_len));
>> +
>> +	if (attrip->attri_value_len > 0)
>> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>> +				attrip->attri_value,
>> +				ATTR_NVEC_SIZE(attrip->attri_value_len));
>> +}
>> +
>> +/*
>> + * The unpin operation is the last place an ATTRI is manipulated in the log. It
>> + * is either inserted in the AIL or aborted in the event of a log I/O error. In
>> + * either case, the ATTRI transaction has been successfully committed to make
>> + * it this far. Therefore, we expect whoever committed the ATTRI to either
>> + * construct and commit the ATTRD or drop the ATTRD's reference in the event of
>> + * error. Simply drop the log's ATTRI reference now that the log is done with
>> + * it.
>> + */
>> +STATIC void
>> +xfs_attri_item_unpin(
>> +	struct xfs_log_item	*lip,
>> +	int			remove)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +
>> +	xfs_attri_release(attrip);
> 
> Nit: this could be shortened to xfs_attri_release(ATTRI_ITEM(lip)).
Ok, will shorten

> 
>> +}
>> +
>> +
>> +STATIC void
>> +xfs_attri_item_release(
>> +	struct xfs_log_item	*lip)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(lip));
>> +}
>> +
>> +/*
>> + * Allocate and initialize an attri item
>> + */
>> +STATIC struct xfs_attri_log_item *
>> +xfs_attri_init(
>> +	struct xfs_mount	*mp)
>> +
>> +{
>> +	struct xfs_attri_log_item	*attrip;
>> +	uint				size;
> 
> Can you line up the *mp in the parameter list with the *attrip in the
> local variables?
Sure

> 
>> +
>> +	size = (uint)(sizeof(struct xfs_attri_log_item));
> 
> kmem_zalloc takes a size_t parameter (which is the return type of sizeof);
> no need to do all this casting.
Ok, I'm thinking of adding an extra buffer_size param here, so that one 
of the callers doesnt have to realloc this for the trailing buffer 
needed during the commit.  One of the new test cases is showing an 
intermittent warning about allocating more than a page, so I'm trying to 
clean that up and figure that out

> 
>> +	attrip = kmem_zalloc(size, 0);
>> +
>> +	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
>> +			  &xfs_attri_item_ops);
>> +	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
>> +	atomic_set(&attrip->attri_refcount, 2);
>> +
>> +	return attrip;
>> +}
>> +
>> +/*
>> + * Copy an attr format buffer from the given buf, and into the destination attr
>> + * format structure.
>> + */
>> +STATIC int
>> +xfs_attri_copy_format(struct xfs_log_iovec *buf,
>> +		      struct xfs_attri_log_format *dst_attr_fmt)
>> +{
>> +	struct xfs_attri_log_format *src_attr_fmt = buf->i_addr;
>> +	uint len = sizeof(struct xfs_attri_log_format);
> 
> Indentation and whatnot with the parameter names.
Ok will fix
> 
>> +
>> +	if (buf->i_len != len)
>> +		return -EFSCORRUPTED;
>> +
>> +	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
>> +	return 0;
>> +}
>> +
>> +static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
>> +{
>> +	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
>> +}
>> +
>> +STATIC void
>> +xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
>> +{
>> +	kmem_free(attrdp->attrd_item.li_lv_shadow);
>> +	kmem_free(attrdp);
>> +}
>> +
>> +/*
>> + * This returns the number of iovecs needed to log the given attrd item.
>> + * We only need 1 iovec for an attrd item.  It just logs the attr_log_format
>> + * structure.
>> + */
>> +static inline int
>> +xfs_attrd_item_sizeof(
>> +	struct xfs_attrd_log_item *attrdp)
>> +{
>> +	return sizeof(struct xfs_attrd_log_format);
>> +}
>> +
>> +STATIC void
>> +xfs_attrd_item_size(
>> +	struct xfs_log_item	*lip,
>> +	int			*nvecs,
>> +	int			*nbytes)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
> 
> Variable name alignment between the parameter list and the local vars.
> 
>> +	*nvecs += 1;
> 
> Space between local variable declaration and the first line of code.
> 
>> +	*nbytes += xfs_attrd_item_sizeof(attrdp);
> 
> No need for a oneliner function for sizeof.

Ok, will fix
> 
>> +}
>> +
>> +/*
>> + * This is called to fill in the log iovecs for the given attrd log item. We use
>> + * only 1 iovec for the attrd_format, and we point that at the attr_log_format
>> + * structure embedded in the attrd item.
>> + */
>> +STATIC void
>> +xfs_attrd_item_format(
>> +	struct xfs_log_item	*lip,
>> +	struct xfs_log_vec	*lv)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
>> +	struct xfs_log_iovec		*vecp = NULL;
>> +
>> +	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
>> +	attrdp->attrd_format.alfd_size = 1;
>> +
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
>> +			&attrdp->attrd_format, xfs_attrd_item_sizeof(attrdp));
>> +}
>> +
>> +/*
>> + * The ATTRD is either committed or aborted if the transaction is cancelled. If
>> + * the transaction is cancelled, drop our reference to the ATTRI and free the
>> + * ATTRD.
>> + */
>> +STATIC void
>> +xfs_attrd_item_release(
>> +	struct xfs_log_item     *lip)
>> +{
>> +	struct xfs_attrd_log_item *attrdp = ATTRD_ITEM(lip);
>> +	xfs_attri_release(attrdp->attrd_attrip);
> 
> Space between the variable declaration and the first line of code.
Sure, will add.

> 
>> +	xfs_attrd_item_free(attrdp);
>> +}
>> +
>> +/*
>> + * Log an ATTRI it to the ATTRD when the attr op is done.  An attr operation
> 
> I don't know what "Log an ATTRI it to the ATTRD" means.  I think this is
> the function that performs one step of an attribute update intent and
> then tags the attrd item dirty, right?
Yes, I had modeled this function loosly around free extent code at the 
time.  It has similar commentary, though that's about what I interpreted 
it to mean.  Back then we were still trying to conceptualize how this 
looping behavior with the state machine was going to work though.

Maybe the comment should just state it like that if that's more clear?

"Performs one step of an attribute update intent and marks the attrd 
item dirty."

?

> 
>> + * may be a set or a remove.  Note that the transaction is marked dirty
>> + * regardless of whether the operation succeeds or fails to support the
>> + * ATTRI/ATTRD lifecycle rules.
>> + */
>> +int
>> +xfs_trans_attr(
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_attrd_log_item	*attrdp,
>> +	struct xfs_buf			**leaf_bp,
>> +	uint32_t			op_flags)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error;
>> +
>> +	error = xfs_qm_dqattach_locked(args->dp, 0);
>> +	if (error)
>> +		return error;
>> +
>> +	switch (op_flags) {
>> +	case XFS_ATTR_OP_FLAGS_SET:
>> +		args->op_flags |= XFS_DA_OP_ADDNAME;
>> +		error = xfs_attr_set_iter(dac, leaf_bp);
>> +		break;
>> +	case XFS_ATTR_OP_FLAGS_REMOVE:
>> +		ASSERT(XFS_IFORK_Q((args->dp)));
> 
> No need for the double parentheses around args->dp.
Ok, will clean out

> 
>> +		error = xfs_attr_remove_iter(dac);
>> +		break;
>> +	default:
>> +		error = -EFSCORRUPTED;
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * Mark the transaction dirty, even on error. This ensures the
>> +	 * transaction is aborted, which:
>> +	 *
>> +	 * 1.) releases the ATTRI and frees the ATTRD
>> +	 * 2.) shuts down the filesystem
>> +	 */
>> +	args->trans->t_flags |= XFS_TRANS_DIRTY;
>> +	if (xfs_sb_version_hasdelattr(&args->dp->i_mount->m_sb))
>> +		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
> 
> This could probably be:
> 
> 	if (attrdp)
> 		set_bit(...);

Sure, that should work too.  I'm thinking a comment though?  Because 
this looses the subtle implication that attrdp is expected to be null 
when the feature bit is off.  Otherwise it may stir up future questions 
of why/how would this be null.  Maybe just something like:

/*
  * attr intent/done items are null when delayed attributes are disabled
  */

?

> 
>> +
>> +	return error;
>> +}
>> +
>> +/* Log an attr to the intent item. */
>> +STATIC void
>> +xfs_attr_log_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_attri_log_item	*attrip,
>> +	struct xfs_attr_item		*attr)
>> +{
>> +	struct xfs_attri_log_format	*attrp;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
>> +
>> +	/*
>> +	 * At this point the xfs_attr_item has been constructed, and we've
>> +	 * created the log intent. Fill in the attri log item and log format
>> +	 * structure with fields from this xfs_attr_item
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
>> +	attrp->alfi_op_flags = attr->xattri_op_flags;
>> +	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
>> +	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
>> +
>> +	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
>> +	attrip->attri_value = attr->xattri_dac.da_args->value;
>> +	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
>> +}
>> +
>> +/* Get an ATTRI. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_intent(
>> +	struct xfs_trans		*tp,
>> +	struct list_head		*items,
>> +	unsigned int			count,
>> +	bool				sort)
>> +{
>> +	struct xfs_mount		*mp = tp->t_mountp;
>> +	struct xfs_attri_log_item	*attrip;
>> +	struct xfs_attr_item		*attr;
>> +
>> +	ASSERT(count == 1);
>> +
>> +	if (!xfs_sb_version_hasdelattr(&mp->m_sb))
>> +		return NULL;
>> +
>> +	attrip = xfs_attri_init(mp);
>> +	xfs_trans_add_item(tp, &attrip->attri_item);
>> +	list_for_each_entry(attr, items, xattri_list)
>> +		xfs_attr_log_item(tp, attrip, attr);
>> +	return &attrip->attri_item;
>> +}
>> +
>> +/* Process an attr. */
>> +STATIC int
>> +xfs_attr_finish_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*done,
>> +	struct list_head		*item,
>> +	struct xfs_btree_cur		**state)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +	int				error;
>> +	struct xfs_delattr_context	*dac;
>> +	struct xfs_attrd_log_item	*attrdp;
>> +	struct xfs_attri_log_item	*attrip;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	dac = &attr->xattri_dac;
>> +
>> +	/*
>> +	 * Always reset trans after EAGAIN cycle
>> +	 * since the transaction is new
>> +	 */
>> +	dac->da_args->trans = tp;
>> +
>> +	error = xfs_trans_attr(dac, ATTRD_ITEM(done), &dac->leaf_bp,
>> +			       attr->xattri_op_flags);
>> +	/*
>> +	 * The attrip refers to xfs_attr_item memory to log the name and value
>> +	 * with the intent item. This already occurred when the intent was
>> +	 * committed so these fields are no longer accessed.
> 
> Can you clear the attri_{name,value} pointers after you've logged the
> intent item so that we don't have to do them here?
> 
Ok, maybe I can put this in xfs_attri_item_committed?

>> Clear them out of
>> +	 * caution since we're about to free the xfs_attr_item.
>> +	 */
>> +	if (xfs_sb_version_hasdelattr(&dac->da_args->dp->i_mount->m_sb)) {
>> +		attrdp = (struct xfs_attrd_log_item *)done;
> 
> attrdp = ATTRD_ITEM(done)?
Sure, will shorten
> 
>> +		attrip = attrdp->attrd_attrip;
>> +		attrip->attri_name = NULL;
>> +		attrip->attri_value = NULL;
>> +	}
>> +
>> +	if (error != -EAGAIN)
>> +		kmem_free(attr);
>> +
>> +	return error;
>> +}
>> +
>> +/* Abort all pending ATTRs. */
>> +STATIC void
>> +xfs_attr_abort_intent(
>> +	struct xfs_log_item		*intent)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(intent));
>> +}
>> +
>> +/* Cancel an attr */
>> +STATIC void
>> +xfs_attr_cancel_item(
>> +	struct list_head		*item)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	kmem_free(attr);
>> +}
>> +
>> +/*
>> + * The ATTRI is logged only once and cannot be moved in the log, so simply
>> + * return the lsn at which it's been logged.
>> + */
>> +STATIC xfs_lsn_t
>> +xfs_attri_item_committed(
>> +	struct xfs_log_item	*lip,
>> +	xfs_lsn_t		lsn)
>> +{
>> +	return lsn;
>> +}
> 
> You can omit this function because the default is "return lsn;" if you
> don't provide one.  See xfs_trans_committed_bulk.
Oh, ok.  I was thinking of moving some of the finish item clean up here 
though.
> 
>> +
>> +STATIC void
>> +xfs_attri_item_committing(
>> +	struct xfs_log_item	*lip,
>> +	xfs_lsn_t		lsn)
>> +{
>> +}
> 
> This function isn't required if it doesn't do anything.  See
> xfs_log_commit_cil.
Ok, will remove

> 
>> +
>> +STATIC bool
>> +xfs_attri_item_match(
>> +	struct xfs_log_item	*lip,
>> +	uint64_t		intent_id)
>> +{
>> +	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>> +}
>> +
>> +/*
>> + * When the attrd item is committed to disk, all we need to do is delete our
>> + * reference to our partner attri item and then free ourselves. Since we're
>> + * freeing ourselves we must return -1 to keep the transaction code from
>> + * further referencing this item.
>> + */
>> +STATIC xfs_lsn_t
>> +xfs_attrd_item_committed(
>> +	struct xfs_log_item	*lip,
>> +	xfs_lsn_t		lsn)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
>> +
>> +	/*
>> +	 * Drop the ATTRI reference regardless of whether the ATTRD has been
>> +	 * aborted. Once the ATTRD transaction is constructed, it is the sole
>> +	 * responsibility of the ATTRD to release the ATTRI (even if the ATTRI
>> +	 * is aborted due to log I/O error).
>> +	 */
>> +	xfs_attri_release(attrdp->attrd_attrip);
>> +	xfs_attrd_item_free(attrdp);
>> +
>> +	return NULLCOMMITLSN;
>> +}
> 
> If you set XFS_ITEM_RELEASE_WHEN_COMMITTED in the attrd item ops,
> xfs_trans_committed_bulk will call ->iop_release instead of
> ->iop_committed and you therefore don't need this function.
Oh i see, will do that then

> 
>> +
>> +STATIC void
>> +xfs_attrd_item_committing(
>> +	struct xfs_log_item	*lip,
>> +	xfs_lsn_t		lsn)
>> +{
>> +}
> 
> Same comment as xfs_attri_item_committing.
ok, will remove this one

> 
>> +
>> +
>> +/*
>> + * Allocate and initialize an attrd item
>> + */
>> +struct xfs_attrd_log_item *
>> +xfs_attrd_init(
>> +	struct xfs_mount		*mp,
>> +	struct xfs_attri_log_item	*attrip)
>> +
>> +{
>> +	struct xfs_attrd_log_item	*attrdp;
>> +	uint				size;
>> +
>> +	size = (uint)(sizeof(struct xfs_attrd_log_item));
> 
> Same comment about sizeof and size_t as in xfs_attri_init.
> 
>> +	attrdp = kmem_zalloc(size, 0);
>> +	memset(attrdp, 0, size);
> 
> No need to memset-zero something you just zalloc'd.
ok, will clean these up

> 
>> +
>> +	xfs_log_item_init(mp, &attrdp->attrd_item, XFS_LI_ATTRD,
>> +			  &xfs_attrd_item_ops);
>> +	attrdp->attrd_attrip = attrip;
>> +	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
>> +
>> +	return attrdp;
>> +}
>> +
>> +/*
>> + * This routine is called to allocate an "attr free done" log item.
>> + */
>> +struct xfs_attrd_log_item *
>> +xfs_trans_get_attrd(struct xfs_trans		*tp,
>> +		  struct xfs_attri_log_item	*attrip)
>> +{
>> +	struct xfs_attrd_log_item		*attrdp;
>> +
>> +	ASSERT(tp != NULL);
>> +
>> +	attrdp = xfs_attrd_init(tp->t_mountp, attrip);
>> +	ASSERT(attrdp != NULL);
> 
> You could fold xfs_attrd_init into this function since there's only one
> caller.
Sure, there's not a lot in the init

> 
>> +
>> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
>> +	return attrdp;
>> +}
>> +
>> +static const struct xfs_item_ops xfs_attrd_item_ops = {
>> +	.iop_size	= xfs_attrd_item_size,
>> +	.iop_format	= xfs_attrd_item_format,
>> +	.iop_release    = xfs_attrd_item_release,
>> +	.iop_committing	= xfs_attrd_item_committing,
>> +	.iop_committed	= xfs_attrd_item_committed,
>> +};
>> +
>> +
>> +/* Get an ATTRD so we can process all the attrs. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_done(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*intent,
>> +	unsigned int			count)
>> +{
>> +	if (!xfs_sb_version_hasdelattr(&tp->t_mountp->m_sb))
>> +		return NULL;
> 
> This is probably better expressed as:
> 
> 	if (!intent)
> 		return NULL;
> 
> Since we don't need a log intent done item if there's no log intent
> item.
Ok, that makes sense

> 
>> +
>> +	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
>> +}
>> +
>> +const struct xfs_defer_op_type xfs_attr_defer_type = {
>> +	.max_items	= 1,
>> +	.create_intent	= xfs_attr_create_intent,
>> +	.abort_intent	= xfs_attr_abort_intent,
>> +	.create_done	= xfs_attr_create_done,
>> +	.finish_item	= xfs_attr_finish_item,
>> +	.cancel_item	= xfs_attr_cancel_item,
>> +};
>> +
>> +/*
>> + * Process an attr intent item that was recovered from the log.  We need to
>> + * delete the attr that it describes.
>> + */
>> +STATIC int
>> +xfs_attri_item_recover(
>> +	struct xfs_log_item		*lip,
>> +	struct list_head		*capture_list)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_mount		*mp = lip->li_mountp;
>> +	struct xfs_inode		*ip;
>> +	struct xfs_da_args		args;
>> +	struct xfs_attri_log_format	*attrp;
>> +	int				error;
>> +
>> +	/*
>> +	 * First check the validity of the attr described by the ATTRI.  If any
>> +	 * are bad, then assume that all are bad and just toss the ATTRI.
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	if (!(attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET ||
>> +	      attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE) ||
>> +	    (attrp->alfi_value_len > XATTR_SIZE_MAX) ||
>> +	    (attrp->alfi_name_len > XATTR_NAME_MAX) ||
>> +	    (attrp->alfi_name_len == 0)) {
> 
> This needs to call xfs_verify_ino() on attrp->alfi_ino.
Ok, will add

> 
> This also needs to check for xfs_sb_version_hasdelayedattr().
Well, ideally this would not be exectuing if the feature bit were not 
on.  Maybe we should add an ASSERT at the top?

> 
> I would refactor this into a separate validation predicate to eliminate
> the multi-line if statement.  I will post a series cleaning up the other
> log items' recover functions shortly.
Alrighty, I will keep an eye out

> 
>> +		/*
>> +		 * This will pull the ATTRI from the AIL and free the memory
>> +		 * associated with it.
>> +		 */
>> +		xfs_attri_release(attrip);
> 
> No need to call xfs_attri_release; one of the 5.10 cleanups was to
> recognize that the log recovery code does this for you automatically.
> 
Ok, will remove

>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
>> +	if (error)
>> +		return error;
> 
> I /think/ this needs to call xfs_qm_dqattach here, for reasons I'll get
> into shortly.
> 
> In the meantime, this /definitely/ needs to do:
> 
> 	if (VFS_I(ip)->i_nlink == 0)
> 		xfs_iflags_set(ip, XFS_IRECOVERY);
> 
> Because the IRECOVERY flag prevents inode inactivation from triggering
> on an unlinked inode while we're still performing log recovery.
> 
> If you want to steal the xlog_recover_iget helper from the atomic
> swapext series[0] please feel free. :)
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=51e23b9c9d9674a78dc97c5848c9efb4461e074d
Oh I see.  Ok, I will take  a look at that

> 
>> +	memset(&args, 0, sizeof(args));
>> +	args.dp = ip;
>> +	args.name = attrip->attri_name;
>> +	args.namelen = attrp->alfi_name_len;
>> +	args.attr_filter = attrp->alfi_attr_flags;
>> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
>> +		args.value = attrip->attri_value;
>> +		args.valuelen = attrp->alfi_value_len;
>> +	}
>> +
>> +	error = xfs_attr_set(&args);
> 
> Er...
> 
>> +
>> +	xfs_attri_release(attrip);
> 
> The transaction commit will take care of releasing attrip.
Mmmm, the new test case for attr replay hangs with out this line.  I 
suspect because we end up with an item in the ail that never goes away.

[Nov12 13:26] INFO: task mount:15718 blocked for more than 120 seconds.
[  +0.000009]       Tainted: G        W   E     5.9.0-rc4 #1
[  +0.000002] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.000004] task:mount           state:D stack:    0 pid:15718 ppid: 
15491 flags:0x00004000
[  +0.000005] Call Trace:
[  +0.000079]  __schedule+0x2d9/0x780
[  +0.000020]  schedule+0x4a/0xb0
[  +0.000120]  xfs_ail_push_all_sync+0xb8/0x100 [xfs]

...ect....


Little confused on this one.... I didnt think transaction commits 
released log items?
> 
>> +	xfs_irele(ip);
>> +	return error;
>> +}
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops = {
>> +	.iop_size	= xfs_attri_item_size,
>> +	.iop_format	= xfs_attri_item_format,
>> +	.iop_unpin	= xfs_attri_item_unpin,
>> +	.iop_committed	= xfs_attri_item_committed,
>> +	.iop_committing = xfs_attri_item_committing,
>> +	.iop_release    = xfs_attri_item_release,
>> +	.iop_recover	= xfs_attri_item_recover,
>> +	.iop_match	= xfs_attri_item_match,
> 
> This needs an ->iop_relog method so that we can relog the attri log item
> if the log starts to fill up.
Ok, will add

> 
>> +};
>> +
>> +
>> +
>> +STATIC int
>> +xlog_recover_attri_commit_pass2(
>> +	struct xlog                     *log,
>> +	struct list_head		*buffer_list,
>> +	struct xlog_recover_item        *item,
>> +	xfs_lsn_t                       lsn)
>> +{
>> +	int                             error;
>> +	struct xfs_mount                *mp = log->l_mp;
>> +	struct xfs_attri_log_item       *attrip;
>> +	struct xfs_attri_log_format     *attri_formatp;
>> +	char				*name = NULL;
>> +	char				*value = NULL;
>> +	int				region = 0;
>> +
>> +	attri_formatp = item->ri_buf[region].i_addr;
> 
> Please check the __pad field for zeroes here.
Ok, will do

> 
>> +	attrip = xfs_attri_init(mp);
>> +	error = xfs_attri_copy_format(&item->ri_buf[region],
>> +				      &attrip->attri_format);
>> +	if (error) {
>> +		xfs_attri_item_free(attrip);
>> +		return error;
>> +	}
>> +
>> +	attrip->attri_name_len = attri_formatp->alfi_name_len;
>> +	attrip->attri_value_len = attri_formatp->alfi_value_len;
>> +	attrip = krealloc(attrip, sizeof(struct xfs_attri_log_item) +
>> +			  attrip->attri_name_len + attrip->attri_value_len,
>> +			  GFP_NOFS | __GFP_NOFAIL);
>> +
>> +	ASSERT(attrip->attri_name_len > 0);
> 
> If attri_name_len is zero, reject the whole thing with EFSCORRUPTED.
Ok, makes sense

> 
>> +	region++;
>> +	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
>> +	memcpy(name, item->ri_buf[region].i_addr,
>> +	       attrip->attri_name_len);
>> +	attrip->attri_name = name;
>> +
>> +	if (attrip->attri_value_len > 0) {
>> +		region++;
>> +		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
>> +			attrip->attri_name_len;
>> +		memcpy(value, item->ri_buf[region].i_addr,
>> +			attrip->attri_value_len);
>> +		attrip->attri_value = value;
>> +	}
> 
> Question: is it valid for an attri item to have value_len > 0 for an
> XFS_ATTRI_OP_FLAGS_REMOVE operation?
Well, it shouldnt happen since the new attr_set routines assume that the 
absence of the value implies a remove operation.  It doesnt invalidate 
the item I suppose, though it would mean that it's carrying around a 
usless payload that it shouldnt.

> 
> Granted, that level of validation might be better left to the _recover
> function.
Maybe we should add and ASSERT there

> 
>> +
>> +	/*
>> +	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
>> +	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
>> +	 * directly and drop the ATTRI reference. Note that
>> +	 * xfs_trans_ail_update() drops the AIL lock.
>> +	 */
>> +	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
>> +	xfs_attri_release(attrip);
>> +	return 0;
>> +}
>> +
>> +const struct xlog_recover_item_ops xlog_attri_item_ops = {
>> +	.item_type	= XFS_LI_ATTRI,
>> +	.commit_pass2	= xlog_recover_attri_commit_pass2,
>> +};
>> +
>> +/*
>> + * This routine is called when an ATTRD format structure is found in a committed
>> + * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
>> + * it was still in the log. To do this it searches the AIL for the ATTRI with
>> + * an id equal to that in the ATTRD format structure. If we find it we drop
>> + * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
>> + */
>> +STATIC int
>> +xlog_recover_attrd_commit_pass2(
>> +	struct xlog			*log,
>> +	struct list_head		*buffer_list,
>> +	struct xlog_recover_item	*item,
>> +	xfs_lsn_t			lsn)
>> +{
>> +	struct xfs_attrd_log_format	*attrd_formatp;
>> +
>> +	attrd_formatp = item->ri_buf[0].i_addr;
>> +	ASSERT((item->ri_buf[0].i_len ==
>> +				(sizeof(struct xfs_attrd_log_format))));
>> +
>> +	xlog_recover_release_intent(log, XFS_LI_ATTRI,
>> +				    attrd_formatp->alfd_alf_id);
>> +	return 0;
>> +}
>> +
>> +const struct xlog_recover_item_ops xlog_attrd_item_ops = {
>> +	.item_type	= XFS_LI_ATTRD,
>> +	.commit_pass2	= xlog_recover_attrd_commit_pass2,
>> +};
>> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
>> new file mode 100644
>> index 0000000..7dd2572
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.h
>> @@ -0,0 +1,76 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later
>> + *
>> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
>> + */
>> +#ifndef	__XFS_ATTR_ITEM_H__
>> +#define	__XFS_ATTR_ITEM_H__
>> +
>> +/* kernel only ATTRI/ATTRD definitions */
>> +
>> +struct xfs_mount;
>> +struct kmem_zone;
>> +
>> +/*
>> + * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
>> + */
>> +#define	XFS_ATTRI_RECOVERED	1
>> +
>> +
>> +/* iovec length must be 32-bit aligned */
>> +#define ATTR_NVEC_SIZE(size) (size == sizeof(int32_t) ? sizeof(int32_t) : \
>> +				size + sizeof(int32_t) - \
>> +				(size % sizeof(int32_t)))
> 
> Can you turn this into a static inline helper?
> 
> And use one of the roundup() variants to ensure the proper alignment
> instead of this open-coded stuff? :)
Sure, will do

> 
>> +
>> +/*
>> + * This is the "attr intention" log item.  It is used to log the fact that some
>> + * attribute operations need to be processed.  An operation is currently either
>> + * a set or remove.  Set or remove operations are described by the xfs_attr_item
>> + * which may be logged to this intent.  Intents are used in conjunction with the
>> + * "attr done" log item described below.
>> + *
>> + * The ATTRI is reference counted so that it is not freed prior to both the
>> + * ATTRI and ATTRD being committed and unpinned. This ensures the ATTRI is
>> + * inserted into the AIL even in the event of out of order ATTRI/ATTRD
>> + * processing. In other words, an ATTRI is born with two references:
>> + *
>> + *      1.) an ATTRI held reference to track ATTRI AIL insertion
>> + *      2.) an ATTRD held reference to track ATTRD commit
>> + *
>> + * On allocation, both references are the responsibility of the caller. Once the
>> + * ATTRI is added to and dirtied in a transaction, ownership of reference one
>> + * transfers to the transaction. The reference is dropped once the ATTRI is
>> + * inserted to the AIL or in the event of failure along the way (e.g., commit
>> + * failure, log I/O error, etc.). Note that the caller remains responsible for
>> + * the ATTRD reference under all circumstances to this point. The caller has no
>> + * means to detect failure once the transaction is committed, however.
>> + * Therefore, an ATTRD is required after this point, even in the event of
>> + * unrelated failure.
>> + *
>> + * Once an ATTRD is allocated and dirtied in a transaction, reference two
>> + * transfers to the transaction. The ATTRD reference is dropped once it reaches
>> + * the unpin handler. Similar to the ATTRI, the reference also drops in the
>> + * event of commit failure or log I/O errors. Note that the ATTRD is not
>> + * inserted in the AIL, so at this point both the ATTRI and ATTRD are freed.
> 
> I don't think it's necessary to document the entire log intent/log done
> refcount state machine here; it'll do to record just the bits that are
> specific to delayed xattr operations.
Ok, maybe just the first 3 lines are enough then? I think that's all 
that really stands out from the other delayed ops

> 
>> + */
>> +struct xfs_attri_log_item {
>> +	struct xfs_log_item		attri_item;
>> +	atomic_t			attri_refcount;
>> +	int				attri_name_len;
>> +	void				*attri_name;
>> +	int				attri_value_len;
>> +	void				*attri_value;
> 
> Please compress this structure a bit by moving the two pointers to be
> adjacent instead of interspersed with ints.
Alrighty, will do.

> 
> Ok, now on to digesting the new state machine...
> 
> --D
Ok then, thanks for the thorough review!!

Allison
> 
>> +	struct xfs_attri_log_format	attri_format;
>> +};
>> +
>> +/*
>> + * This is the "attr done" log item.  It is used to log the fact that some attrs
>> + * earlier mentioned in an attri item have been freed.
>> + */
>> +struct xfs_attrd_log_item {
>> +	struct xfs_attri_log_item	*attrd_attrip;
>> +	struct xfs_log_item		attrd_item;
>> +	struct xfs_attrd_log_format	attrd_format;
>> +};
>> +
>> +#endif	/* __XFS_ATTR_ITEM_H__ */
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 8f8837f..d7787a5 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -15,6 +15,7 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_attr_sf.h"
>>   #include "xfs_attr_leaf.h"
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 3fbd98f..d5d1959 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -15,6 +15,8 @@
>>   #include "xfs_iwalk.h"
>>   #include "xfs_itable.h"
>>   #include "xfs_error.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_bmap_util.h"
>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>> index c1771e7..62e1534 100644
>> --- a/fs/xfs/xfs_ioctl32.c
>> +++ b/fs/xfs/xfs_ioctl32.c
>> @@ -17,6 +17,8 @@
>>   #include "xfs_itable.h"
>>   #include "xfs_fsops.h"
>>   #include "xfs_rtalloc.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_ioctl.h"
>>   #include "xfs_ioctl32.h"
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 5e16545..5ecc76c 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -13,6 +13,8 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_acl.h"
>>   #include "xfs_quota.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index fa2d05e..3457f22 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -1993,6 +1993,10 @@ xlog_print_tic_res(
>>   	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>>   	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>>   	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
>> +	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
>> +	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
>> +	    REG_TYPE_STR(ATTR_NAME, "attr_name"),
>> +	    REG_TYPE_STR(ATTR_VALUE, "attr_value"),
>>   	};
>>   	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>>   #undef REG_TYPE_STR
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index a8289ad..cb951cd 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -1775,6 +1775,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
>>   	&xlog_cud_item_ops,
>>   	&xlog_bui_item_ops,
>>   	&xlog_bud_item_ops,
>> +	&xlog_attri_item_ops,
>> +	&xlog_attrd_item_ops,
>>   };
>>   
>>   static const struct xlog_recover_item_ops *
>> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
>> index 0aa87c2..bc9c25e 100644
>> --- a/fs/xfs/xfs_ondisk.h
>> +++ b/fs/xfs/xfs_ondisk.h
>> @@ -132,6 +132,8 @@ xfs_check_ondisk_structs(void)
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
>> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
>> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
>>   
>>   	/*
>>   	 * The v5 superblock format extended several v4 header structures with
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index bca48b3..9b0c790 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -10,6 +10,7 @@
>>   #include "xfs_log_format.h"
>>   #include "xfs_da_format.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_acl.h"
>>   #include "xfs_da_btree.h"
>> -- 
>> 2.7.4
>>
