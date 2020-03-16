Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA30186DD5
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Mar 2020 15:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbgCPOv5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Mar 2020 10:51:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34434 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GEhYBW052792;
        Mon, 16 Mar 2020 14:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kUbVWJXojxPwWLvO5TqfpP55HcOFj8HMpAnHw4utrcI=;
 b=BQuufXQy1ahFVoEooEaglwz8lWyWsAj8Dyo1v3x4iWWfE2PlIv4+ZDEwZyeBRhBfBkY+
 rtU5ZmKkRNZgjcyb5z97iS9W5r5VZT6EIqWo6jmKDnSNudyHZH6yxU5qmIjfCVt0nMtB
 uWEc8FxjG5xme007+f/FZh245k0WWqrpoViG5fp2D7UARVhtucGFt3dY0w+TQ9MNDbLO
 CPwC+DaOmnpjGm2hgAIK0DeU/C2luVt8kM0KqtqZsbyoFOy0gHwaXox2M0jSYg38gUFX
 7MZUubg9VJohNPG8IQxd6eWCItNs3B+4Z/JCFfB/hlU93cevgrH3RkaEdSBnGxQSWh6V 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yrqwmy8ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 14:51:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GEobTr041590;
        Mon, 16 Mar 2020 14:51:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ys8rcm5f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 14:51:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GEpnBX003959;
        Mon, 16 Mar 2020 14:51:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 07:51:49 -0700
Date:   Mon, 16 Mar 2020 07:51:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: add a new xfs_sb_version_has_large_dinode helper
Message-ID: <20200316145149.GA256767@magnolia>
References: <20200312142235.550766-1-hch@lst.de>
 <20200312142235.550766-2-hch@lst.de>
 <20200316131649.GE12313@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316131649.GE12313@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160071
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 09:16:49AM -0400, Brian Foster wrote:
> On Thu, Mar 12, 2020 at 03:22:31PM +0100, Christoph Hellwig wrote:
> > Add a new wrapper to check if a file system supports the newer large
> > dinode format.  Previously we uses xfs_sb_version_hascrc for that,
> > which is technically correct but a little confusing to read.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_format.h     |  5 +++++
> >  fs/xfs/libxfs/xfs_ialloc.c     |  4 ++--
> >  fs/xfs/libxfs/xfs_inode_buf.c  | 12 ++++++++----
> >  fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
> >  fs/xfs/xfs_buf_item.c          |  2 +-
> >  fs/xfs/xfs_log_recover.c       |  2 +-
> >  6 files changed, 18 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index cd814f99da28..a28bf6a978ad 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -497,6 +497,11 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
> >  	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> >  }
> >  
> 
> A comment would be useful here to indicate what this means (i.e., we can
> assume v3 inode format). The function name is a little vague too I
> suppose (will the inode ever get larger than large? :P). I wonder if
> something like _has_v3_inode() is more clear, but we can always change
> it easily enough and either way is better than hascrc() IMO.
> 
> Brian
> 
> > +static inline bool xfs_sb_version_has_large_dinode(struct xfs_sb *sbp)

/me agrees that this function ought to have a comment saying that
"large_dinode" means v3 inodes.

Not sure about larger than large inodes though -- the last di_flags2
could be made to mean "...and now expand structure by X bytes" whenever
we run out of space.

(The rest of the series looks ok to me)

--D

> > +{
> > +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> > +}
> > +
> >  static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
> >  {
> >  	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index b4a404278935..6adffaa68fb8 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -304,7 +304,7 @@ xfs_ialloc_inode_init(
> >  	 * That means for v3 inode we log the entire buffer rather than just the
> >  	 * inode cores.
> >  	 */
> > -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +	if (xfs_sb_version_has_large_dinode(&mp->m_sb)) {
> >  		version = 3;
> >  		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
> >  
> > @@ -2872,7 +2872,7 @@ xfs_ialloc_setup_geometry(
> >  	 * cannot change the behavior.
> >  	 */
> >  	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
> > -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +	if (xfs_sb_version_has_large_dinode(&mp->m_sb)) {
> >  		int	new_size = igeo->inode_cluster_size_raw;
> >  
> >  		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 17e88a8c8353..a5aa2f220c28 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -44,14 +44,18 @@ xfs_inobp_check(
> >  }
> >  #endif
> >  
> > +/*
> > + * v4 and earlier file systems only support the small dinode, and must use the
> > + * v1 or v2 inode formats.  v5 file systems support a larger dinode, and must
> > + * use the v3 inode format.
> > + */
> >  bool
> >  xfs_dinode_good_version(
> >  	struct xfs_mount *mp,
> >  	__u8		version)
> >  {
> > -	if (xfs_sb_version_hascrc(&mp->m_sb))
> > +	if (xfs_sb_version_has_large_dinode(&mp->m_sb))
> >  		return version == 3;
> > -
> >  	return version == 1 || version == 2;
> >  }
> >  
> > @@ -454,7 +458,7 @@ xfs_dinode_verify(
> >  
> >  	/* Verify v3 integrity information first */
> >  	if (dip->di_version >= 3) {
> > -		if (!xfs_sb_version_hascrc(&mp->m_sb))
> > +		if (!xfs_sb_version_has_large_dinode(&mp->m_sb))
> >  			return __this_address;
> >  		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
> >  				      XFS_DINODE_CRC_OFF))
> > @@ -629,7 +633,7 @@ xfs_iread(
> >  
> >  	/* shortcut IO on inode allocation if possible */
> >  	if ((iget_flags & XFS_IGET_CREATE) &&
> > -	    xfs_sb_version_hascrc(&mp->m_sb) &&
> > +	    xfs_sb_version_has_large_dinode(&mp->m_sb) &&
> >  	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
> >  		VFS_I(ip)->i_generation = prandom_u32();
> >  		ip->i_d.di_version = 3;
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 7a9c04920505..294e23d47912 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -187,7 +187,7 @@ xfs_calc_inode_chunk_res(
> >  			       XFS_FSB_TO_B(mp, 1));
> >  	if (alloc) {
> >  		/* icreate tx uses ordered buffers */
> > -		if (xfs_sb_version_hascrc(&mp->m_sb))
> > +		if (xfs_sb_version_has_large_dinode(&mp->m_sb))
> >  			return res;
> >  		size = XFS_FSB_TO_B(mp, 1);
> >  	}
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 663810e6cd59..d004ae3455d7 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -345,7 +345,7 @@ xfs_buf_item_format(
> >  	 * occurs during recovery.
> >  	 */
> >  	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
> > -		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
> > +		if (xfs_sb_version_has_large_dinode(&lip->li_mountp->m_sb) ||
> >  		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
> >  		      xfs_log_item_in_current_chkpt(lip)))
> >  			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 6abc0863c9c3..e5e976b5cc11 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2997,7 +2997,7 @@ xlog_recover_inode_pass2(
> >  	 * superblock flag to determine whether we need to look at di_flushiter
> >  	 * to skip replay when the on disk inode is newer than the log one
> >  	 */
> > -	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
> > +	if (!xfs_sb_version_has_large_dinode(&mp->m_sb) &&
> >  	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> >  		/*
> >  		 * Deal with the wrap case, DI_MAX_FLUSH is less
> > -- 
> > 2.24.1
> > 
> 
