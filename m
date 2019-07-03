Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666575E781
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 17:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfGCPLg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 11:11:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46580 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfGCPLg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jul 2019 11:11:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63F9PIr182950;
        Wed, 3 Jul 2019 15:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=3QqglUnp3WMKBJnngLooDTXIjU9X2EZe+YImYvpkNNM=;
 b=bFBYDA2soxHv+1IGoR5kucuJWml8YEGHqMzkcqfZIQF5H8teaZa2AHflMzi69kfqrWKX
 Mxi21v3zbzNcZxbCFdbT0wWvF7CTdVvDycw9pbRJHHDOxL2OzfF/r3fWl/DTMmxfR5jG
 HdA/aXwvlJkr/tsEsJ5VRuRxs4glKows8yLs9HtIrv6qSFkNcXvCSnGMHExdq/9Vgrcf
 uQ3hVglSzVFTatvjBxqadWu+USkrGx3BO7jSiq5iuimMTja6zwTRwS0J/JIO3ytIwq4L
 hp1l5JnCQuK1H74lPIPPh0RhmJgnoeFzVRuDp/5sANcqkAsibtQdkNBnmukMgfC+daCQ PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2te61q24hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 15:11:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63F8sZx024042;
        Wed, 3 Jul 2019 15:09:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tebkux7h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 15:09:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x63F99ee011875;
        Wed, 3 Jul 2019 15:09:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 08:09:09 -0700
Date:   Wed, 3 Jul 2019 08:09:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 9/9] xfs: allow bulkstat_single of special inodes
Message-ID: <20190703150902.GV1404256@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158199168.495715.1433536766420003523.stgit@magnolia>
 <20190703132525.GI26057@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703132525.GI26057@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907030184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907030184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 03, 2019 at 09:25:25AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:46:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a new ireq flag (for single bulkstats) that enables userspace to
> > ask us for a special inode number instead of interpreting @ino as a
> > literal inode number.  This enables us to query the root inode easily.
> > 
> 
> Seems reasonable, though what's the use case for this? A brief
> description in the commit log would be helpful.

I will add:

"The reason for adding the ability to query specifically the root
directory inode is that certain programs (xfsdump and xfsrestore) want
to confirm when they've been pointed to the root directory.  The
userspace code assumes the root directory is always the first result
from calling bulkstat with lastino == 0, but this isn't true if the
(initial btree roots + initial AGFL + inode alignment padding) is itself
long enough to be allocated to new inodes if all of those blocks should
happen to be free at the same time.  Rather than make userspace guess
at internal filesystem state, we provide a direct query."

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h |   11 ++++++++++-
> >  fs/xfs/xfs_ioctl.c     |   10 ++++++++++
> >  2 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 77c06850ac52..1489bce07d66 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -482,7 +482,16 @@ struct xfs_ireq {
> >  	uint64_t	reserved[2];	/* must be zero			*/
> >  };
> >  
> > -#define XFS_IREQ_FLAGS_ALL	(0)
> > +/*
> > + * The @ino value is a special value, not a literal inode number.  See the
> > + * XFS_IREQ_SPECIAL_* values below.
> > + */
> > +#define XFS_IREQ_SPECIAL	(1 << 0)
> > +
> > +#define XFS_IREQ_FLAGS_ALL	(XFS_IREQ_SPECIAL)
> > +
> > +/* Operate on the root directory inode. */
> > +#define XFS_IREQ_SPECIAL_ROOT	(1)
> >  
> >  /*
> >   * ioctl structures for v5 bulkstat and inumbers requests
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index f71341cd8340..3bb5f980fabf 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -961,6 +961,16 @@ xfs_ireq_setup(
> >  	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
> >  		return -EINVAL;
> >  
> > +	if (hdr->flags & XFS_IREQ_SPECIAL) {
> > +		switch (hdr->ino) {
> > +		case XFS_IREQ_SPECIAL_ROOT:
> > +			hdr->ino = mp->m_sb.sb_rootino;
> > +			break;
> 
> Do you envision other ->ino magic values? I'm curious about the need for
> the special flag along with a magic inode value as opposed to just a
> "root dir" flag or some such.

I was thinking about a "return bulkstat of the fd" flag too, though I
haven't really come up with a use case for it yet.  Further on, if we
ever see Dave's subvolumes patchset again, we might want to be able to
query the ino/gen of the subvolumes root dir so that we can open a file
handle to it.

Basically the flag enables us to have 2^64 magic values instead of ~30.
We're probably never going to use that many but might as well reserve
the space for future flexibility.

--D

> Brian
> 
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> >  	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
> >  		return -EINVAL;
> >  
> > 
