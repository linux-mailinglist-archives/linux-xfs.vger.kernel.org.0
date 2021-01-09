Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4962EFCC2
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Jan 2021 02:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbhAIBgc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Jan 2021 20:36:32 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53578 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbhAIBgb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 20:36:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1091Td2N082840;
        Sat, 9 Jan 2021 01:35:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UtSUDngftMq+/CxEyXeYhIG/oHhFM1Zo60B7quuX1Fw=;
 b=mKpNxnAo4LtVO8VN0kXM+gktWGV5i/Jc6R/cfxEn9S/48S3EBIYx7BtMdh8/0QskoZtH
 frTU1bcW+tB7e+dtHf22bqAxeet9TNJgS+tMysTyfq+RfLwh1Utgiqh6oHrziotDiBOv
 oxV0FMiRCVw8g7vfQ0DxAFZtt5rCqwJxxQxl41KB9FrzXpWmJe3b7avRC9PTCsairq6v
 rVNfNjTGHiTMNj4n9Ad9vcqZ24gRv18ps+dtibOUt3c8ohRfUOge5j2Ke+Ecz7Z7ZigH
 pDIPiLqiM5E0CoJLjDD7SQ/ChmQvlld+0OS7A3Jz2Q0O3mOIhthh2vzrjxzpISwNkUSc oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35y20ag2sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 01:35:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1091YYRJ143520;
        Sat, 9 Jan 2021 01:35:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35y2h9gdkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 01:35:43 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1091Zco2002722;
        Sat, 9 Jan 2021 01:35:38 GMT
Received: from localhost (/10.159.135.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 17:33:52 -0800
Date:   Fri, 8 Jan 2021 17:33:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: Re: [PATCH V12 04/14] xfs: Check for extent overflow when
 adding/removing dir entries
Message-ID: <20210109013351.GS6918@magnolia>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
 <20210104103120.41158-5-chandanrlinux@gmail.com>
 <20210108011713.GP38809@magnolia>
 <2055679.3ixLThe9JB@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2055679.3ixLThe9JB@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090007
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 10:25:35AM +0530, Chandan Babu R wrote:
> On Thu, 07 Jan 2021 17:17:13 -0800, Darrick J. Wong wrote:
> > On Mon, Jan 04, 2021 at 04:01:10PM +0530, Chandan Babu R wrote:
> > > Directory entry addition can cause the following,
> > > 1. Data block can be added/removed.
> > >    A new extent can cause extent count to increase by 1.
> > > 2. Free disk block can be added/removed.
> > >    Same behaviour as described above for Data block.
> > > 3. Dabtree blocks.
> > >    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
> > >    can be new extents. Hence extent count can increase by
> > >    XFS_DA_NODE_MAXDEPTH.
> > > 
> > > Directory entry remove and rename (applicable only to the source
> > > directory entry) operations are handled specially to allow them to
> > > succeed in low extent count availability scenarios
> > > i.e. xfs_bmap_del_extent_real() will now return -ENOSPC when a possible
> > > extent count overflow is detected. -ENOSPC is already handled by higher
> > > layers of XFS by letting,
> > > 1. Empty Data/Free space index blocks to linger around until a future
> > >    remove operation frees them.
> > > 2. Dabtree blocks would be swapped with the last block in the leaf space
> > >    followed by unmapping of the new last block.
> > > 
> > > Also, Extent overflow check is performed for the target directory entry
> > > of the rename operation only when the entry does not exist and a
> > > non-zero space reservation is obtained successfully.
> > > 
> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c       | 15 ++++++++++++
> > >  fs/xfs/libxfs/xfs_inode_fork.h | 13 ++++++++++
> > >  fs/xfs/xfs_inode.c             | 45 ++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_symlink.c           |  5 ++++
> > >  4 files changed, 78 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index 32aeacf6f055..5fd804534e67 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -5151,6 +5151,21 @@ xfs_bmap_del_extent_real(
> > >  		/*
> > >  		 * Deleting the middle of the extent.
> > >  		 */
> > > +
> > > +		/*
> > > +		 * For directories, -ENOSPC will be handled by higher layers of
> > > +		 * XFS by letting the corresponding empty Data/Free blocks to
> > > +		 * linger around until a future remove operation. Dabtree blocks
> > > +		 * would be swapped with the last block in the leaf space and
> > > +		 * then the new last block will be unmapped.
> > > +		 */
> > > +		if (S_ISDIR(VFS_I(ip)->i_mode) &&
> > > +		    whichfork == XFS_DATA_FORK &&
> > > +		    xfs_iext_count_may_overflow(ip, whichfork, 1)) {
> > > +			error = -ENOSPC;
> > > +			goto done;
> > 
> > Hmm... it strikes me as a little odd that we're checking file mode and
> > fork type in the middle of the bmap code.  However, I think it's the
> > case that the only place where anyone would punch a hole in the /middle/
> > of an extent is xattr trees and regular files, right?  And both of those
> > cases are checked before we end up in the bmap code, right?
> 
> Yes, your observation is correct. I will remove the file mode and fork type
> checks.

You might want to leave an assert there just in case someone else trips
over that...

> 
> > 
> > So we only really need this check to prevent extent count overflows when
> > removing dirents from directories, like the comment says, and only
> > because directories don't have a hard requirement that the bunmapi
> > succeeds.  And I think this logic covers xfs_remove too?  That's a bit
> > subtle, but as there's no extent count check in that function, there's
> > not much to attach a comment to... :)
> 
> Yes, To provide more clarity, I should replace the above comment with
> following,
> 
>   /*
>    * -ENOSPC is returned since a directory entry remove operation must not fail
>    * due to low extent count availability. -ENOSPC will be handled by higher
>    * layers of XFS by letting the corresponding empty Data/Free blocks to linger

grammar nit: "...by letting the corresponding empty Data/Free blocks linger
until a future remove operation."

>    * around until a future remove operation. Dabtree blocks would be swapped with
>    * the last block in the leaf space and then the new last block will be
>    * unmapped.
>    *
>    * The above logic also applies to the source directory entry of a rename
>    * operation.
>    */
> 
> > 
> > Hm.  I think I'd like xfs_rename to get a brief comment that we're
> > protected from extent count overflows in xfs_remove() by virtue of this
> > "leave the dir block in place if we ENOSPC" capability:
> > 
> > 	/*
> > 	 * NOTE: We don't need to check for extent overflows here
> > 	 * because the dir removename code will leave the dir block
> > 	 * in place if the extent count would overflow.
> > 	 */
> > 	error = xfs_dir_removename(...);
> 
> Sure, I will add that.
> 
> > 
> > Do xattr trees also have the same ability?  I think they do, at least
> > for the dabtree part...?
> 
> The following code snippet from xfs_da_shrink_inode() does the special casing
> only for the data fork i.e. for blocks holding directory entries.
> 
>    for (;;) {
>            /*
>             * Remove extents.  If we get ENOSPC for a dir we have to move
>             * the last block to the place we want to kill.
>             */
>            error = xfs_bunmapi(tp, dp, dead_blkno, count,
>                                xfs_bmapi_aflag(w), 0, &done);
>            if (error == -ENOSPC) {
>                    if (w != XFS_DATA_FORK)
>                            break;
>                    error = xfs_da3_swap_lastblock(args, &dead_blkno,
>                                                  &dead_buf);
> 
> So this facility is available only for directory entries.
> 
> Hence for xattrs, if we ever reach the extent count limit, the only way out is
> to delete the corresponding file.

Ok.  Just checking. :)

> > 
> > I think I would've split this patch into three pieces:
> > 
> >  - create, link, and symlink in one patch (adding dirents),
> >  - the xfs_bmap_del_extent_real change and a comment for xfs_remove
> >    (removing dirents)
> >  - all the xfs_rename changes (adding and removing dirents)
> > 
> > Though I dunno, this series is already 14 patches, and the part that I
> > care most about is not leaving that subtlety in xfs_remove(). :)
> 
> I think you are right about that. I will split this patch according to what
> you have mentioned above.


Thanks!

FWIW I didn't see any regressions in fstests...

--D

> > 
> > Other than that, I follow the logic in this patch and will give it a
> > testrun tonight.
> 
> Thank you!
> 
> > 
> > --D
> > 
> > > +		}
> > > +
> > >  		old = got;
> > >  
> > >  		got.br_blockcount = del->br_startoff - got.br_startoff;
> > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > > index bcac769a7df6..ea1a9dd8a763 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > > @@ -47,6 +47,19 @@ struct xfs_ifork {
> > >   */
> > >  #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
> > >  
> > > +/*
> > > + * Directory entry addition can cause the following,
> > > + * 1. Data block can be added/removed.
> > > + *    A new extent can cause extent count to increase by 1.
> > > + * 2. Free disk block can be added/removed.
> > > + *    Same behaviour as described above for Data block.
> > > + * 3. Dabtree blocks.
> > > + *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
> > > + *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
> > > + */
> > > +#define XFS_IEXT_DIR_MANIP_CNT(mp) \
> > > +	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
> > > +
> > >  /*
> > >   * Fork handling.
> > >   */
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index b7352bc4c815..0db21368c7e1 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -1042,6 +1042,11 @@ xfs_create(
> > >  	if (error)
> > >  		goto out_trans_cancel;
> > >  
> > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > > +	if (error)
> > > +		goto out_trans_cancel;
> > > +
> > >  	/*
> > >  	 * A newly created regular or special file just has one directory
> > >  	 * entry pointing to them, but a directory also the "." entry
> > > @@ -1258,6 +1263,11 @@ xfs_link(
> > >  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> > >  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> > >  
> > > +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > > +	if (error)
> > > +		goto error_return;
> > > +
> > >  	/*
> > >  	 * If we are using project inheritance, we only allow hard link
> > >  	 * creation in our tree when the project IDs are the same; else
> > > @@ -3106,6 +3116,35 @@ xfs_rename(
> > >  	/*
> > >  	 * Check for expected errors before we dirty the transaction
> > >  	 * so we can return an error without a transaction abort.
> > > +	 *
> > > +	 * Extent count overflow check:
> > > +	 *
> > > +	 * From the perspective of src_dp, a rename operation is essentially a
> > > +	 * directory entry remove operation. Hence the only place where we check
> > > +	 * for extent count overflow for src_dp is in
> > > +	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
> > > +	 * -ENOSPC when it detects a possible extent count overflow and in
> > > +	 * response, the higher layers of directory handling code do the
> > > +	 * following:
> > > +	 * 1. Data/Free blocks: XFS lets these blocks linger around until a
> > > +	 *    future remove operation removes them.
> > > +	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
> > > +	 *    Leaf space and unmaps the last block.
> > > +	 *
> > > +	 * For target_dp, there are two cases depending on whether the
> > > +	 * destination directory entry exists or not.
> > > +	 *
> > > +	 * When destination directory entry does not exist (i.e. target_ip ==
> > > +	 * NULL), extent count overflow check is performed only when transaction
> > > +	 * has a non-zero sized space reservation associated with it.  With a
> > > +	 * zero-sized space reservation, XFS allows a rename operation to
> > > +	 * continue only when the directory has sufficient free space in its
> > > +	 * data/leaf/free space blocks to hold the new entry.
> > > +	 *
> > > +	 * When destination directory entry exists (i.e. target_ip != NULL), all
> > > +	 * we need to do is change the inode number associated with the already
> > > +	 * existing entry. Hence there is no need to perform an extent count
> > > +	 * overflow check.
> > >  	 */
> > >  	if (target_ip == NULL) {
> > >  		/*
> > > @@ -3116,6 +3155,12 @@ xfs_rename(
> > >  			error = xfs_dir_canenter(tp, target_dp, target_name);
> > >  			if (error)
> > >  				goto out_trans_cancel;
> > > +		} else {
> > > +			error = xfs_iext_count_may_overflow(target_dp,
> > > +					XFS_DATA_FORK,
> > > +					XFS_IEXT_DIR_MANIP_CNT(mp));
> > > +			if (error)
> > > +				goto out_trans_cancel;
> > >  		}
> > >  	} else {
> > >  		/*
> > > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > > index 1f43fd7f3209..0b8136a32484 100644
> > > --- a/fs/xfs/xfs_symlink.c
> > > +++ b/fs/xfs/xfs_symlink.c
> > > @@ -220,6 +220,11 @@ xfs_symlink(
> > >  	if (error)
> > >  		goto out_trans_cancel;
> > >  
> > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > > +	if (error)
> > > +		goto out_trans_cancel;
> > > +
> > >  	/*
> > >  	 * Allocate an inode for the symlink.
> > >  	 */
> > 
> 
> 
> -- 
> chandan
> 
> 
> 
