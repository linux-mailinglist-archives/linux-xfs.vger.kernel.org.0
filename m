Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442545E701
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 16:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfGCOm3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 10:42:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCOm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jul 2019 10:42:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63EcrV1144487;
        Wed, 3 Jul 2019 14:42:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=MyXMlkD6xs+VJ1lnxfcjmtz6xcb7SWT96eT0CqdKrKQ=;
 b=14rPaoWo8ZNcIZjmomU6SN/zE4A9itLPYX4cKZboPiAeii8DunbV/bymOBw9YNOvPxom
 dGihU1O19KT86W6aN1+gjUd5Yx8DvIBA8krh0IuBa94GD8HAuisEb+Il/b7UV6qJ1Ki3
 Bi0tQ5gBPzlwkNj8W1j4g9dxqm7M+6P2pBmGIaHkB44Mpv7X7pfqNB3fCYift6BtnXzg
 t6CZwa0refsdRaxz8WHJLkqdq49TWd5wcE9y0JJdDg28h72oyHaKyhxaNxBQgm8+RF5G
 zD3PmkFDFCOyJQiUmlA5Qi8FMqSvJAO8tMU5nGYI6zh0G4Af7PFDwklhxNufxTvAJYpp 2g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2te61e9x2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 14:42:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63Eg7QD037074;
        Wed, 3 Jul 2019 14:42:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tebamdn2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 14:42:11 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x63EgADW013624;
        Wed, 3 Jul 2019 14:42:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 07:42:09 -0700
Date:   Wed, 3 Jul 2019 07:42:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/9] xfs: introduce new v5 bulkstat structure
Message-ID: <20190703144208.GT1404256@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158195258.495715.3305107510637882010.stgit@magnolia>
 <20190703132346.GC26057@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703132346.GC26057@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907030179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907030180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 03, 2019 at 09:23:46AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:45:52PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Introduce a new version of the in-core bulkstat structure that supports
> > our new v5 format features.  This structure also fills the gaps in the
> > previous structure.  We leave wiring up the ioctls for the next patch.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h     |   48 ++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_health.h |    2 +
> >  fs/xfs/xfs_health.c        |    2 +
> >  fs/xfs/xfs_ioctl.c         |    9 ++++-
> >  fs/xfs/xfs_ioctl.h         |    2 +
> >  fs/xfs/xfs_ioctl32.c       |   10 ++++--
> >  fs/xfs/xfs_itable.c        |   75 +++++++++++++++++++++++++++++++++-----------
> >  fs/xfs/xfs_itable.h        |    4 ++
> >  fs/xfs/xfs_ondisk.h        |    2 +
> >  9 files changed, 124 insertions(+), 30 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index 45f0618efb8d..50c2bb8e13c4 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> ...
> > @@ -266,6 +266,43 @@ xfs_bulkstat(
> >  	return error;
> >  }
> >  
> > +/* Convert bulkstat (v5) to bstat (v1). */
> > +void
> > +xfs_bulkstat_to_bstat(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_bstat		*bs1,
> > +	const struct xfs_bulkstat	*bstat)
> > +{
> > +	bs1->bs_ino = bstat->bs_ino;
> > +	bs1->bs_mode = bstat->bs_mode;
> > +	bs1->bs_nlink = bstat->bs_nlink;
> > +	bs1->bs_uid = bstat->bs_uid;
> > +	bs1->bs_gid = bstat->bs_gid;
> > +	bs1->bs_rdev = bstat->bs_rdev;
> > +	bs1->bs_blksize = bstat->bs_blksize;
> > +	bs1->bs_size = bstat->bs_size;
> > +	bs1->bs_atime.tv_sec = bstat->bs_atime;
> > +	bs1->bs_mtime.tv_sec = bstat->bs_mtime;
> > +	bs1->bs_ctime.tv_sec = bstat->bs_ctime;
> > +	bs1->bs_atime.tv_nsec = bstat->bs_atime_nsec;
> > +	bs1->bs_mtime.tv_nsec = bstat->bs_mtime_nsec;
> > +	bs1->bs_ctime.tv_nsec = bstat->bs_ctime_nsec;
> > +	bs1->bs_blocks = bstat->bs_blocks;
> > +	bs1->bs_xflags = bstat->bs_xflags;
> > +	bs1->bs_extsize = bstat->bs_extsize_blks << mp->m_sb.sb_blocklog;
> > +	bs1->bs_extents = bstat->bs_extents;
> > +	bs1->bs_gen = bstat->bs_gen;
> > +	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
> > +	bs1->bs_forkoff = bstat->bs_forkoff;
> > +	bs1->bs_projid_hi = bstat->bs_projectid >> 16;
> > +	bs1->bs_sick = bstat->bs_sick;
> > +	bs1->bs_checked = bstat->bs_checked;
> > +	bs1->bs_cowextsize = bstat->bs_cowextsize_blks << mp->m_sb.sb_blocklog;
> > +	bs1->bs_dmevmask = 0;
> > +	bs1->bs_dmstate = 0;
> 
> Any particular reason these fields are now stubbed out?
> Deprecated/unused? It looks like we at least still have a mechanism to
> set these values, but I have no idea if there are any users (or what
> they're for for that matter :P).

Those fields were for DMAPI hierarchal storage management, but upstream
XFS has never supported it so I didn't see much point in adding them
back.  If we do decide to support it there's plenty of space in the v5
structure.

> Also, should we zero the padding space in bs1 here? It looks like the
> callers allocate bs1 on the stack without any initialization, do the
> conversion and immediately copy to userspace.

Yes, we shouldn't be leaking unset memory contents here.  I'll change
the conversion functions to memset since the same problem happens in
userspace.

--D

> Brian
> 
> > +	bs1->bs_aextents = bstat->bs_aextents;
> > +}
> > +
> >  struct xfs_inumbers_chunk {
> >  	inumbers_fmt_pf		formatter;
> >  	struct xfs_ibulk	*breq;
> > diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> > index cfd3c93226f3..60e259192056 100644
> > --- a/fs/xfs/xfs_itable.h
> > +++ b/fs/xfs/xfs_itable.h
> > @@ -38,10 +38,12 @@ xfs_ibulk_advance(
> >   */
> >  
> >  typedef int (*bulkstat_one_fmt_pf)(struct xfs_ibulk *breq,
> > -		const struct xfs_bstat *bstat);
> > +		const struct xfs_bulkstat *bstat);
> >  
> >  int xfs_bulkstat_one(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
> >  int xfs_bulkstat(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
> > +void xfs_bulkstat_to_bstat(struct xfs_mount *mp, struct xfs_bstat *bs1,
> > +		const struct xfs_bulkstat *bstat);
> >  
> >  typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
> >  		const struct xfs_inogrp *igrp);
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index c8ba98fae30a..0b4cdda68524 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -146,6 +146,8 @@ xfs_check_ondisk_structs(void)
> >  	XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
> >  	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
> >  	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
> > +
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
> >  }
> >  
> >  #endif /* __XFS_ONDISK_H */
> > 
