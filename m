Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2489BF60B4
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Nov 2019 18:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfKIRcZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 Nov 2019 12:32:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44428 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfKIRcZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Nov 2019 12:32:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA9HTRE4157995
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 17:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=fBaqpsgBCHwZBa6CHT+mJH4M/9JKfaYbXHwPG2moTfM=;
 b=gLlmwIYLeekE0HTYIUxff6cSc2zxJwN6YmA8P/UmMG81DJjcy9Mklw2wCF0ej9l6hnf7
 bSDbRLrEFIZKg3e+5/XrUdjozGtRYuyNUcvy8pbp7aE5fE/Qvpznv2p95fkVWHPKfrDu
 2sjgbj7ABL5z62PvUky2eNik9PZoiSJrG50WaYbwQxDgwwY3vKpA6ch9qiuM9A8YAaCJ
 UeCCw5nvQBAK0yXz8z5aAbsId2MbcrsydIIo5aAS0Rhv4WjvwJRVgAodBVutFYNvs826
 MKNdGTq7u8w0RixVfVLnUQmfDzWez+uZJSnWNcu/vNnP5HVv9/t8C+9a0g380peFmG3w nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndpskas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 17:32:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA9HSV7b111610
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 17:32:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w5mt41ab1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 17:32:19 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA9HWJkV019565
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 17:32:19 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Nov 2019 17:32:18 +0000
Subject: Re: [PATCH v4 04/17] xfs: Add xfs_dabuf defines
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-5-allison.henderson@oracle.com>
 <20191108191928.GU6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a8db403f-f996-7352-0845-079630e1dae5@oracle.com>
Date:   Sat, 9 Nov 2019 10:32:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108191928.GU6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911090179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911090179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/8/19 12:19 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:48PM -0700, Allison Collins wrote:
>> This patch adds two new defines XFS_DABUF_MAP_NOMAPPING and
>> XFS_DABUF_MAP_HOLE_OK.  This helps to clean up hard numbers and
>> makes the code easier to read
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c       | 14 +++++++-----
>>   fs/xfs/libxfs/xfs_attr_leaf.c  | 23 +++++++++++--------
>>   fs/xfs/libxfs/xfs_attr_leaf.h  |  3 +++
>>   fs/xfs/libxfs/xfs_da_btree.c   | 50 ++++++++++++++++++++++++++++--------------
>>   fs/xfs/libxfs/xfs_dir2_block.c |  6 +++--
>>   fs/xfs/libxfs/xfs_dir2_data.c  |  3 ++-
>>   fs/xfs/libxfs/xfs_dir2_leaf.c  |  9 +++++---
>>   fs/xfs/libxfs/xfs_dir2_node.c  | 10 +++++----
>>   fs/xfs/scrub/dabtree.c         |  6 ++---
>>   fs/xfs/scrub/dir.c             |  4 +++-
>>   fs/xfs/xfs_attr_inactive.c     |  6 +++--
>>   fs/xfs/xfs_attr_list.c         | 16 +++++++++-----
>>   12 files changed, 97 insertions(+), 53 deletions(-)
> 
> <snip>
> 
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
>> index bb08800..017480e 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
>> @@ -16,6 +16,9 @@ struct xfs_da_state_blk;
>>   struct xfs_inode;
>>   struct xfs_trans;
>>   
>> +#define XFS_DABUF_MAP_NOMAPPING	(-1) /* Caller doesn't have a mapping. */
>> +#define XFS_DABUF_MAP_HOLE_OK	(-2) /* don't complain if we land in a hole. */
> 
> These are parameters to xfs_da_{get,read,reada}_buf, please put them
> next to the declarations for those functions.
Hmm, I dont see that these are declared in a header file, but how about 
fs/xfs/libxfs/xfs_da_btree.h ?  Did I miss them somewhere?

Allison


> 
> Also they probably ought to be explicitly cast to xfs_daddr_t, e.g.
> 
> /* Force a fresh lookup for the dir/attr mapping. */
> #define XFS_DABUF_MAP_NOMAPPING	((xfs_daddr_t)-1)
> 
> /* Don't complain if we land in a hole. */
> #define XFS_DABUF_MAP_HOLE_OK	((xfs_daddr_t)-2)
> 
>> +
>>   /*
>>    * Used to keep a list of "remote value" extents when unlinking an inode.
>>    */
> 
> <snip>
> 
>> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
>> index 8dedc30..6bc7651 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_block.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
>> @@ -20,6 +20,7 @@
>>   #include "xfs_error.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_log.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   /*
>>    * Local function prototypes.
>> @@ -123,8 +124,9 @@ xfs_dir3_block_read(
>>   	struct xfs_mount	*mp = dp->i_mount;
>>   	int			err;
>>   
>> -	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
>> -				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
>> +	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk,
>> +			      XFS_DABUF_MAP_NOMAPPING, bpp, XFS_DATA_FORK,
>> +			      &xfs_dir3_block_buf_ops);
>>   	if (!err && tp && *bpp)
>>   		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
>>   	return err;
> 
> I think this misses the xfs_dir3_data_read call in
> xfs_dir2_leaf_to_block?
> 
>> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
>> index 2c79be4..a4188de 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_data.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
>> @@ -17,6 +17,7 @@
>>   #include "xfs_trans.h"
>>   #include "xfs_buf_item.h"
>>   #include "xfs_log.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   static xfs_failaddr_t xfs_dir2_data_freefind_verify(
>>   		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
>> @@ -653,7 +654,7 @@ xfs_dir3_data_init(
>>   	 * Get the buffer set up for the block.
>>   	 */
>>   	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, blkno),
>> -			       -1, &bp, XFS_DATA_FORK);
>> +			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
>>   	if (error)
>>   		return error;
>>   	bp->b_ops = &xfs_dir3_data_buf_ops;
>> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> index b7046e2..a2cba6bd 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> @@ -19,6 +19,7 @@
>>   #include "xfs_trace.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_buf_item.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   /*
>>    * Local function declarations.
>> @@ -311,7 +312,7 @@ xfs_dir3_leaf_get_buf(
>>   	       bno < xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET));
>>   
>>   	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, bno),
>> -			       -1, &bp, XFS_DATA_FORK);
>> +			       XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
>>   	if (error)
>>   		return error;
>>   
>> @@ -594,7 +595,8 @@ xfs_dir2_leaf_addname(
>>   
>>   	trace_xfs_dir2_leaf_addname(args);
>>   
>> -	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
>> +	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
>> +				   XFS_DABUF_MAP_NOMAPPING, &lbp);
>>   	if (error)
>>   		return error;
>>   
> 
> I think there are some missing conversions for xfs_dir3_data_read calls
> in xfs_dir2_leaf_addname...
> 
>> @@ -1189,7 +1191,8 @@ xfs_dir2_leaf_lookup_int(
>>   	tp = args->trans;
>>   	mp = dp->i_mount;
>>   
>> -	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
>> +	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk,
>> +				   XFS_DABUF_MAP_NOMAPPING, &lbp);
>>   	if (error)
>>   		return error;
>>   
> 
> ...and two more dir3_leaf_read calls further down in this function...
> 
> ...and one more in xfs_dir2_leaf_trim_data...
> 
>> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
>> index 8bbd742..0a803e4 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_node.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
>> @@ -20,6 +20,7 @@
>>   #include "xfs_trans.h"
>>   #include "xfs_buf_item.h"
>>   #include "xfs_log.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   /*
>>    * Function declarations.
>> @@ -227,7 +228,7 @@ xfs_dir2_free_read(
>>   	xfs_dablk_t		fbno,
>>   	struct xfs_buf		**bpp)
>>   {
>> -	return __xfs_dir3_free_read(tp, dp, fbno, -1, bpp);
>> +	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_NOMAPPING, bpp);
>>   }
>>   
>>   static int
>> @@ -237,7 +238,7 @@ xfs_dir2_free_try_read(
>>   	xfs_dablk_t		fbno,
>>   	struct xfs_buf		**bpp)
>>   {
>> -	return __xfs_dir3_free_read(tp, dp, fbno, -2, bpp);
>> +	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_HOLE_OK, bpp);
>>   }
>>   
>>   static int
>> @@ -254,7 +255,7 @@ xfs_dir3_free_get_buf(
>>   	struct xfs_dir3_icfree_hdr hdr;
>>   
>>   	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, fbno),
>> -				   -1, &bp, XFS_DATA_FORK);
>> +				   XFS_DABUF_MAP_NOMAPPING, &bp, XFS_DATA_FORK);
>>   	if (error)
>>   		return error;
>>   
> 
> ...there's also a missing call in xfs_dir2_leafn_lookup_for_entry...
> 
>> @@ -1495,7 +1496,8 @@ xfs_dir2_leafn_toosmall(
>>   		 * Read the sibling leaf block.
>>   		 */
>>   		error = xfs_dir3_leafn_read(state->args->trans, dp,
>> -					    blkno, -1, &bp);
>> +					    blkno, XFS_DABUF_MAP_NOMAPPING,
>> +					    &bp);
>>   		if (error)
>>   			return error;
>>   
> 
> ...and another one in xfs_dir2_node_addname_int.
> 
>> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
>> index 77ff9f9..353455c 100644
>> --- a/fs/xfs/scrub/dabtree.c
>> +++ b/fs/xfs/scrub/dabtree.c
>> @@ -355,9 +355,9 @@ xchk_da_btree_block(
>>   		goto out_nobuf;
>>   
>>   	/* Read the buffer. */
>> -	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
>> -			&blk->bp, dargs->whichfork,
>> -			&xchk_da_btree_buf_ops);
>> +	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno,
>> +				XFS_DABUF_MAP_HOLE_OK, &blk->bp,
>> +				dargs->whichfork, &xchk_da_btree_buf_ops);
>>   	if (!xchk_da_process_error(ds, level, &error))
>>   		goto out_nobuf;
>>   	if (blk->bp)
>> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
>> index 1e2e117..eb0fa0f 100644
>> --- a/fs/xfs/scrub/dir.c
>> +++ b/fs/xfs/scrub/dir.c
>> @@ -18,6 +18,7 @@
>>   #include "scrub/scrub.h"
>>   #include "scrub/common.h"
>>   #include "scrub/dabtree.h"
>> +#include "xfs_attr_leaf.h"
>>   
>>   /* Set us up to scrub directories. */
>>   int
> 
> I also noticed missing conversions for xfs_dir3_data_read in
> xchk_dir_rec, xchk_directory_data_bestfree,
> xchk_directory_leaf1_bestfree, and xchk_directory_free_bestfree.
> 
>> @@ -492,7 +493,8 @@ xchk_directory_leaf1_bestfree(
>>   	int				error;
>>   
>>   	/* Read the free space block. */
>> -	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
>> +	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk,
>> +				   XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
>>   		goto out;
>>   	xchk_buffer_recheck(sc, bp);
> 
> There's also a missing xfs_dir3_data_readahead conversion in
> xchk_parent_count_parent_dentries in fs/xfs/scrub/parent.c.
> 
>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>> index f83f11d..9c22915 100644
>> --- a/fs/xfs/xfs_attr_inactive.c
>> +++ b/fs/xfs/xfs_attr_inactive.c
>> @@ -235,7 +235,8 @@ xfs_attr3_node_inactive(
>>   		 * traversal of the tree so we may deal with many blocks
>>   		 * before we come back to this one.
>>   		 */
>> -		error = xfs_da3_node_read(*trans, dp, child_fsb, -1, &child_bp,
>> +		error = xfs_da3_node_read(*trans, dp, child_fsb,
>> +					  XFS_DABUF_MAP_NOMAPPING, &child_bp,
>>   					  XFS_ATTR_FORK);
>>   		if (error)
>>   			return error;
>> @@ -321,7 +322,8 @@ xfs_attr3_root_inactive(
>>   	 * the extents in reverse order the extent containing
>>   	 * block 0 must still be there.
>>   	 */
>> -	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
>> +	error = xfs_da3_node_read(*trans, dp, 0, XFS_DABUF_MAP_NOMAPPING, &bp,
>> +				  XFS_ATTR_FORK);
>>   	if (error)
>>   		return error;
>>   	blkno = bp->b_bn;
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index c02f22d..fab416c 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -224,8 +224,9 @@ xfs_attr_node_list_lookup(
>>   	ASSERT(*pbp == NULL);
>>   	cursor->blkno = 0;
>>   	for (;;) {
>> -		error = xfs_da3_node_read(tp, dp, cursor->blkno, -1, &bp,
>> -				XFS_ATTR_FORK);
>> +		error = xfs_da3_node_read(tp, dp, cursor->blkno,
>> +					  XFS_DABUF_MAP_NOMAPPING, &bp,
>> +					  XFS_ATTR_FORK);
>>   		if (error)
>>   			return error;
>>   		node = bp->b_addr;
>> @@ -309,8 +310,9 @@ xfs_attr_node_list(
>>   	 */
>>   	bp = NULL;
>>   	if (cursor->blkno > 0) {
>> -		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, -1,
>> -					      &bp, XFS_ATTR_FORK);
>> +		error = xfs_da3_node_read(context->tp, dp, cursor->blkno,
>> +					  XFS_DABUF_MAP_NOMAPPING, &bp,
>> +					  XFS_ATTR_FORK);
>>   		if ((error != 0) && (error != -EFSCORRUPTED))
>>   			return error;
>>   		if (bp) {
>> @@ -377,7 +379,8 @@ xfs_attr_node_list(
>>   			break;
>>   		cursor->blkno = leafhdr.forw;
>>   		xfs_trans_brelse(context->tp, bp);
>> -		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno, -1, &bp);
>> +		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno,
>> +					    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   		if (error)
>>   			return error;
>>   	}
>> @@ -497,7 +500,8 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
>>   	trace_xfs_attr_leaf_list(context);
>>   
>>   	context->cursor->blkno = 0;
>> -	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, -1, &bp);
>> +	error = xfs_attr3_leaf_read(context->tp, context->dp, 0,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
>>   	if (error)
>>   		return error;
>>   
> 
> ...more missing conversions of xfs_dir3_data_read in
> xfs_dir2_leaf_readbuf; and of xfs_dir3_data_readahead in
> xfs_dir2_leaf_readbuf...
> 
> ...and a missing conversion of xfs_dir3_data_readahead in xfs_dir_open
> in fs/xfs/xfs_file.c.
> 
> --D
> 
>> -- 
>> 2.7.4
>>
