Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2428A7AC
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 22:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfHLUAj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 16:00:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLUAi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 16:00:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJx8h0162335
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 20:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=00q1kV0GRMvvEk+bH+DWD/kGdr891t9gWPtbEyeTI88=;
 b=j/wDWKfc7mhuhqOdu51Z16X1thL9Jek2G6asqq2t5yQn790wN8iL2x2Is+C9YbxUkd9F
 nP8NSrorFBQKRU8jLovL4v5ZQTy67/C93JkHmYg5DLtnuVkaEVS4hJJ2wk/lp5XLWJhx
 FpD2TmFr3nrkJ7JnPsmKrHui4KjSAGN2rvAkfoDusHZDHHLi62QQ+LOKrL4QH9C78jB4
 +tTVsjsb6ugjEBon0G21Zsc8XNYH0vdg8RjI51/atW/OCoi6QCJaUDzJgG8blpTw5paK
 ypAHvAJwj51Ngcmk2xQDeEng/KUsm3yWDxTIl5E9cxMr8zebo1fV1sgD+EK5k8X2TjmG yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=00q1kV0GRMvvEk+bH+DWD/kGdr891t9gWPtbEyeTI88=;
 b=TWUzn2NL/VQmXtNxxICitOIHHnjMBnQB6K8RPMgKogS+n1XCqBIZHs4zSPKmOMguBP3n
 CoT6R77MSMJDIj4eNVKETPVNKbn4ZWmki1Gqfem6MDcPhBab7PBuC9YOaEp80qNAS6nb
 6V6dyxpEKtKJ5B6ALY7oAx6AkYucmjLdTNuy+tud0bqrFkK+yQJX+6QjoE1QxDQZOdJ2
 S0xJSKtwjxK8mExh27erl2TJIEOXVAK8nPFGYhR+A3ba3R62eABS0ynpK2htUa0c8nag
 zYl8l90exaGQCswcFy/aVl+pW2sXReohOY1uH1HboB+UWR7Kcxz/MoJg7i4h25t81NJQ zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvp1vrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 20:00:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJwfTF072641
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 20:00:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u9n9h9748-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 20:00:34 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CK0YiS024410
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 20:00:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 13:00:33 -0700
Date:   Mon, 12 Aug 2019 13:00:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 05/18] xfs: Add xfs_has_attr and subroutines
Message-ID: <20190812200033.GN7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-6-allison.henderson@oracle.com>
 <20190812155635.GT7138@magnolia>
 <a097adb0-4b6f-4ee7-9c94-5ef442cf734a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a097adb0-4b6f-4ee7-9c94-5ef442cf734a@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120199
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 12, 2019 at 12:29:03PM -0700, Allison Collins wrote:
> On 8/12/19 8:56 AM, Darrick J. Wong wrote:
> > On Fri, Aug 09, 2019 at 02:37:13PM -0700, Allison Collins wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > This patch adds a new functions to check for the existence of
> > > an attribute.  Subroutines are also added to handle the cases
> > > of leaf blocks, nodes or shortform.  Common code that appears
> > > in existing attr add and remove functions have been factored
> > > out to help reduce the appearence of duplicated code.  We will
> > > need these routines later for delayed attributes since delayed
> > > operations cannot return error codes.
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c      | 151 +++++++++++++++++++++++++++---------------
> > >   fs/xfs/libxfs/xfs_attr.h      |   1 +
> > >   fs/xfs/libxfs/xfs_attr_leaf.c |  82 +++++++++++++++--------
> > >   fs/xfs/libxfs/xfs_attr_leaf.h |   2 +
> > >   4 files changed, 158 insertions(+), 78 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index a2fba0c..72af8e2 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -48,6 +48,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> > > +STATIC int xfs_leaf_has_attr(xfs_da_args_t *args, struct xfs_buf **bp);
> > 
> > Trailing whitespace, and please use "struct xfs_da_args", not the
> > typedef...
> Ok, will that clean up.
> 
> > 
> > >   /*
> > >    * Internal routines when attribute list is more than one block.
> > > @@ -55,6 +56,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > > +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > > +				 struct xfs_da_state **state);
> > >   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> > >   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> > > @@ -278,6 +281,32 @@ xfs_attr_set_args(
> > >   }
> > >   /*
> > > + * Return EEXIST if attr is found, or ENOATTR if not
> > > + */
> > > +int
> > > +xfs_has_attr(
> > > +	struct xfs_da_args      *args)
> > > +{
> > > +	struct xfs_inode        *dp = args->dp;
> > > +	struct xfs_buf		*bp;
> > > +	int                     error;
> > > +
> > > +	if (!xfs_inode_hasattr(dp)) {
> > > +		error = -ENOATTR;
> > > +	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> > > +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> > > +		error = xfs_shortform_has_attr(args, NULL, NULL);
> > > +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > +		error = xfs_leaf_has_attr(args, &bp);
> > > +		xfs_trans_brelse(args->trans, bp);
> > > +	} else {
> > > +		error = xfs_attr_node_hasname(args, NULL);
> > > +	}
> > > +
> > > +	return error;
> > > +}
> > > +
> > > +/*
> > >    * Remove the attribute specified in @args.
> > >    */
> > >   int
> > > @@ -616,26 +645,17 @@ STATIC int
> > >   xfs_attr_leaf_addname(
> > >   	struct xfs_da_args	*args)
> > >   {
> > > -	struct xfs_inode	*dp;
> > >   	struct xfs_buf		*bp;
> > >   	int			retval, error, forkoff;
> > > +	struct xfs_inode	*dp = args->dp;
> > >   	trace_xfs_attr_leaf_addname(args);
> > >   	/*
> > > -	 * Read the (only) block in the attribute list in.
> > > -	 */
> > > -	dp = args->dp;
> > > -	args->blkno = 0;
> > > -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
> > > -	if (error)
> > > -		return error;
> > > -
> > > -	/*
> > >   	 * Look up the given attribute in the leaf block.  Figure out if
> > >   	 * the given flags produce an error or call for an atomic rename.
> > >   	 */
> > > -	retval = xfs_attr3_leaf_lookup_int(bp, args);
> > > +	retval = xfs_leaf_has_attr(args, &bp);
> > >   	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> > >   		xfs_trans_brelse(args->trans, bp);
> > >   		return retval;
> > > @@ -787,6 +807,26 @@ xfs_attr_leaf_addname(
> > >   }
> > >   /*
> > > + * Return EEXIST if attr is found, or ENOATTR if not
> > > + */
> > > +STATIC int
> > > +xfs_leaf_has_attr(
> > > +	struct xfs_da_args      *args,
> > > +	struct xfs_buf		**bp)
> > > +{
> > > +	int                     error = 0;
> > > +
> > > +	args->blkno = 0;
> > > +	error = xfs_attr3_leaf_read(args->trans, args->dp,
> > > +			args->blkno, -1, bp);
> > 
> > Can we please get rid of these -1 and -2 magic values that eventually
> > become the mappedbno argument to xfs_dabuf_map?
> Sure, maybe we can add some constants here.  I took a quick peek at
> xfs_dabuf_map.  Maybe we can add something like this:
> 
> #define MBNO_NOMAP	-1
> #define MBNO_HOLE_OK	-2

#define XFS_DABUF_MAP_NOMAPPING	(-1)
#define XFS_DABUF_MAP_HOLE_OK	(-2)

Function flags should be named for the function that consumes them,
but otoh these values sink through multiple levels of call stack.

Macros should have parentheses around them to avoid unexpected fun with
the preprocessor, since:

printf("%d\n", XFS_DABUF_MAP_NOMAPPING XFS_DABUF_MAP_NOMAPPING);

Should produce a compile error, not a program that prints -2.

--D

> 
> 
> > 
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	error = xfs_attr3_leaf_lookup_int(*bp, args);
> > > +	return error;
> > 
> > "return xfs_attr3_leaf_lookup_int..." ?
> > 
> > > +}
> > > +
> > > +/*
> > >    * Remove a name from the leaf attribute list structure
> > >    *
> > >    * This leaf block cannot have a "remote" value, we only call this routine
> > > @@ -806,12 +846,8 @@ xfs_attr_leaf_removename(
> > >   	 * Remove the attribute.
> > >   	 */
> > >   	dp = args->dp;
> > > -	args->blkno = 0;
> > > -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
> > > -	if (error)
> > > -		return error;
> > > -	error = xfs_attr3_leaf_lookup_int(bp, args);
> > > +	error = xfs_leaf_has_attr(args, &bp);
> > >   	if (error == -ENOATTR) {
> > >   		xfs_trans_brelse(args->trans, bp);
> > >   		return error;
> > > @@ -848,12 +884,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
> > >   	trace_xfs_attr_leaf_get(args);
> > > -	args->blkno = 0;
> > > -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
> > > -	if (error)
> > > -		return error;
> > > -
> > > -	error = xfs_attr3_leaf_lookup_int(bp, args);
> > > +	error = xfs_leaf_has_attr(args, &bp);
> > >   	if (error != -EEXIST)  {
> > >   		xfs_trans_brelse(args->trans, bp);
> > >   		return error;
> > > @@ -866,6 +897,43 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
> > >   	return error;
> > >   }
> > > +/*
> > > + * Return EEXIST if attr is found, or ENOATTR if not
> > > + * statep: If not null is set to point at the found state.  Caller will
> > > + * 	   be responsible for freeing the state in this case.
> > > + */
> > > +STATIC int
> > > +xfs_attr_node_hasname(
> > > +	struct xfs_da_args	*args,
> > > +	struct xfs_da_state	**statep)
> > > +{
> > > +	struct xfs_da_state	*state;
> > > +	struct xfs_inode	*dp;
> > > +	int			retval, error;
> > > +
> > > +	/*
> > > +	 * Tie a string around our finger to remind us where we are.
> > > +	 */
> > > +	dp = args->dp;
> > > +	state = xfs_da_state_alloc();
> > > +	state->args = args;
> > > +	state->mp = dp->i_mount;
> > > +
> > > +	/*
> > > +	 * Search to see if name exists, and get back a pointer to it.
> > > +	 */
> > > +	error = xfs_da3_node_lookup_int(state, &retval);
> > > +	if (error == 0)
> > > +		error = retval;
> > > +
> > > +	if (statep != NULL)
> > > +		*statep = state;
> > > +	else
> > > +		xfs_da_state_free(state);
> > > +
> > > +	return error;
> > > +}
> > > +
> > >   /*========================================================================
> > >    * External routines when attribute list size > geo->blksize
> > >    *========================================================================*/
> > > @@ -898,17 +966,14 @@ xfs_attr_node_addname(
> > >   	dp = args->dp;
> > >   	mp = dp->i_mount;
> > >   restart:
> > > -	state = xfs_da_state_alloc();
> > > -	state->args = args;
> > > -	state->mp = mp;
> > > -
> > >   	/*
> > >   	 * Search to see if name already exists, and get back a pointer
> > >   	 * to where it should go.
> > >   	 */
> > > -	error = xfs_da3_node_lookup_int(state, &retval);
> > > -	if (error)
> > > +	error = xfs_attr_node_hasname(args, &state);
> > > +	if (error == -EEXIST)
> > >   		goto out;
> > > +
> > >   	blk = &state->path.blk[ state->path.active-1 ];
> > >   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> > >   	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> > > @@ -1113,29 +1178,15 @@ xfs_attr_node_removename(
> > >   {
> > >   	struct xfs_da_state	*state;
> > >   	struct xfs_da_state_blk	*blk;
> > > -	struct xfs_inode	*dp;
> > >   	struct xfs_buf		*bp;
> > >   	int			retval, error, forkoff;
> > > +	struct xfs_inode	*dp = args->dp;
> > >   	trace_xfs_attr_node_removename(args);
> > > -	/*
> > > -	 * Tie a string around our finger to remind us where we are.
> > > -	 */
> > > -	dp = args->dp;
> > > -	state = xfs_da_state_alloc();
> > > -	state->args = args;
> > > -	state->mp = dp->i_mount;
> > > -
> > > -	/*
> > > -	 * Search to see if name exists, and get back a pointer to it.
> > > -	 */
> > > -	error = xfs_da3_node_lookup_int(state, &retval);
> > > -	if (error || (retval != -EEXIST)) {
> > > -		if (error == 0)
> > > -			error = retval;
> > > +	error = xfs_attr_node_hasname(args, &state);
> > > +	if (error != -EEXIST)
> > >   		goto out;
> > > -	}
> > >   	/*
> > >   	 * If there is an out-of-line value, de-allocate the blocks.
> > > @@ -1355,17 +1406,13 @@ xfs_attr_node_get(xfs_da_args_t *args)
> > >   	trace_xfs_attr_node_get(args);
> > > -	state = xfs_da_state_alloc();
> > > -	state->args = args;
> > > -	state->mp = args->dp->i_mount;
> > > -
> > >   	/*
> > >   	 * Search to see if name exists, and get back a pointer to it.
> > >   	 */
> > > -	error = xfs_da3_node_lookup_int(state, &retval);
> > > -	if (error) {
> > > +	error = xfs_attr_node_hasname(args, &state);
> > > +	if (error != -EEXIST) {
> > >   		retval = error;
> > > -	} else if (retval == -EEXIST) {
> > > +	} else {
> > >   		blk = &state->path.blk[ state->path.active-1 ];
> > >   		ASSERT(blk->bp != NULL);
> > >   		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > index 0bade83..c082d34 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > @@ -170,6 +170,7 @@ int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
> > >   		 unsigned char *value, int valuelen);
> > >   int xfs_attr_set_args(struct xfs_da_args *args);
> > >   int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
> > > +int xfs_has_attr(struct xfs_da_args *args);
> > >   int xfs_attr_remove_args(struct xfs_da_args *args);
> > >   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
> > >   		  int flags, struct attrlist_cursor_kern *cursor);
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > index 70eb941..8d2e11f 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > @@ -546,6 +546,53 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
> > >   }
> > >   /*
> > > + * Return EEXIST if attr is found, or ENOATTR if not
> > > + * args:  args containing attribute name and namelen
> > > + * sfep:  If not null, pointer will be set to the last attr entry found
> > > + * basep: If not null, pointer is set to the byte offset of the entry in the
> > > + *	  list
> > > + */
> > > +int
> > > +xfs_shortform_has_attr(
> > > +	struct xfs_da_args	 *args,
> > > +	struct xfs_attr_sf_entry **sfep,
> > > +	int			 *basep)
> > > +{
> > > +	struct xfs_attr_shortform *sf;
> > > +	struct xfs_attr_sf_entry *sfe;
> > > +	int			base = sizeof(struct xfs_attr_sf_hdr);
> > > +	int			size = 0;
> > > +	int			end;
> > > +	int			i;
> > > +
> > > +	base = sizeof(struct xfs_attr_sf_hdr);
> > > +	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
> > > +	sfe = &sf->list[0];
> > > +	end = sf->hdr.count;
> > > +	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
> > > +			base += size, i++) {
> > > +		size = XFS_ATTR_SF_ENTSIZE(sfe);
> > > +		if (sfe->namelen != args->namelen)
> > > +			continue;
> > > +		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
> > > +			continue;
> > > +		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> > > +			continue;
> > > +		break;
> > > +	}
> > > +
> > > +	if (sfep != NULL)
> > > +		*sfep = sfe;
> > > +
> > > +	if (basep != NULL)
> > > +		*basep = base;
> > > +
> > > +	if (i == end)
> > > +		return -ENOATTR;
> > > +	return -EEXIST;
> > > +}
> > > +
> > > +/*
> > >    * Add a name/value pair to the shortform attribute list.
> > >    * Overflow from the inode has already been checked for.
> > >    */
> > > @@ -554,7 +601,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
> > >   {
> > >   	xfs_attr_shortform_t *sf;
> > >   	xfs_attr_sf_entry_t *sfe;
> > > -	int i, offset, size;
> > > +	int offset, size, error;
> > >   	xfs_mount_t *mp;
> > >   	xfs_inode_t *dp;
> > >   	struct xfs_ifork *ifp;
> > > @@ -568,18 +615,11 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
> > >   	ifp = dp->i_afp;
> > >   	ASSERT(ifp->if_flags & XFS_IFINLINE);
> > >   	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> > > -	sfe = &sf->list[0];
> > > -	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> > > +	error = xfs_shortform_has_attr(args, &sfe, NULL);
> > >   #ifdef DEBUG
> > > -		if (sfe->namelen != args->namelen)
> > > -			continue;
> > > -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> > > -			continue;
> > > -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> > > -			continue;
> > > +	if (error == -EEXIST)
> > >   		ASSERT(0);
> > 
> > ASSERT(error != -EEXIST); ?  Without the #ifdef DEBUG since ASSERT does
> > nothing if DEBUG isn't defined...
> > 
> > >   #endif
> > > -	}
> > >   	offset = (char *)sfe - (char *)sf;
> > >   	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> > > @@ -626,7 +666,7 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
> > >   {
> > >   	xfs_attr_shortform_t *sf;
> > >   	xfs_attr_sf_entry_t *sfe;
> > > -	int base, size=0, end, totsize, i;
> > > +	int base, size = 0, end, totsize, error;
> > >   	xfs_mount_t *mp;
> > >   	xfs_inode_t *dp;
> > 
> > Please fix the typedef and indentation here while you're changing this
> > (and all the other attr) functions.
> > 
> > Otherwise, I very much like this cleanup. :)
> Great!  I'll tidy these up then.  Thx for the review!
> 
> Allison
> 
> > 
> > --D
> > 
> > > @@ -634,23 +674,13 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
> > >   	dp = args->dp;
> > >   	mp = dp->i_mount;
> > > -	base = sizeof(xfs_attr_sf_hdr_t);
> > >   	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
> > > -	sfe = &sf->list[0];
> > >   	end = sf->hdr.count;
> > > -	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
> > > -					base += size, i++) {
> > > -		size = XFS_ATTR_SF_ENTSIZE(sfe);
> > > -		if (sfe->namelen != args->namelen)
> > > -			continue;
> > > -		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
> > > -			continue;
> > > -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> > > -			continue;
> > > -		break;
> > > -	}
> > > -	if (i == end)
> > > -		return -ENOATTR;
> > > +
> > > +	error = xfs_shortform_has_attr(args, &sfe, &base);
> > > +	if (error == -ENOATTR)
> > > +		return error;
> > > +	size = XFS_ATTR_SF_ENTSIZE(sfe);
> > >   	/*
> > >   	 * Fix up the attribute fork data, covering the hole
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> > > index 7b74e18..be1f636 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> > > @@ -39,6 +39,8 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
> > >   int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
> > >   			struct xfs_buf **leaf_bp);
> > >   int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> > > +int	xfs_shortform_has_attr(struct xfs_da_args *args,
> > > +			       struct xfs_attr_sf_entry **sfep, int *basep);
> > >   int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
> > >   int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
> > >   xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
> > > -- 
> > > 2.7.4
> > > 
