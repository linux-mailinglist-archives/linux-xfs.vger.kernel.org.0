Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A7C3BA70
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 19:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfFJRLH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 13:11:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38940 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfFJRLH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 13:11:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AH9JqK051626;
        Mon, 10 Jun 2019 17:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=uerL4/giBVFr0DvNJtkrcFpiBSlu+Nl5gpeqo9EOLnY=;
 b=R1XvX/CD+Kcy7yP8EcPzLM7EI1+WkauD5kHkRia+2JSegUcWPiZidyaDigv/Vgn+F7Cj
 dbiIQVaENT5txhxz0gLfGpqDZuDvaW7A/ETyEBvY95UK19RkfMlUkGlDo14j1e5kkQji
 iarDEBFcWR1oKA99pgoQgG0ByDCtuVe673zEgeLbNdC8RneUVsYcPgTWZj4f69uQOF/E
 /494SJq2xX0C+m717w80qUs/i1JxwQiJa1obN8n5RWL40PHEph1bxKPawcvmglVewOM/
 G4YYG8onAMiXYy+hwAof9aqVn1kwg6lvrzUogrKyKdcxJ8/f55gAVk0oRbLQ9UqGV6dE Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t05nqg3qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 17:10:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AHA7Nu107126;
        Mon, 10 Jun 2019 17:10:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t0p9qu2v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 17:10:07 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5AHA5rf001627;
        Mon, 10 Jun 2019 17:10:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Jun 2019 10:10:04 -0700
Date:   Mon, 10 Jun 2019 10:10:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 02/10] xfs: convert quotacheck to use the new iwalk
 functions
Message-ID: <20190610171003.GK1871505@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968498085.1657646.3518168545540841602.stgit@magnolia>
 <20190610135848.GB6473@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610135848.GB6473@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906100116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906100117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 09:58:52AM -0400, Brian Foster wrote:
> On Tue, Jun 04, 2019 at 02:49:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert quotacheck to use the new iwalk iterator to dig through the
> > inodes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_qm.c |   62 ++++++++++++++++++-------------------------------------
> >  1 file changed, 20 insertions(+), 42 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index aa6b6db3db0e..a5b2260406a8 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> ...
> > @@ -1136,20 +1135,18 @@ xfs_qm_dqusage_adjust(
> >  	 * rootino must have its resources accounted for, not so with the quota
> >  	 * inodes.
> >  	 */
> > -	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
> > -		*res = BULKSTAT_RV_NOTHING;
> > -		return -EINVAL;
> > -	}
> > +	if (xfs_is_quota_inode(&mp->m_sb, ino))
> > +		return 0;
> >  
> >  	/*
> >  	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
> >  	 * at mount time and therefore nobody will be racing chown/chproj.
> >  	 */
> > -	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, 0, &ip);
> > -	if (error) {
> > -		*res = BULKSTAT_RV_NOTHING;
> > +	error = xfs_iget(mp, tp, ino, XFS_IGET_DONTCACHE, 0, &ip);
> 
> I was wondering if we should start using IGET_UNTRUSTED here, but I
> guess we're 1.) protected by quotacheck context and 2.) have the same
> record validity semantics as the existing bulkstat walker. LGTM:

Yep.  There's nothing else running in the fs at quotacheck time so inode
records should not be changing while quotacheck runs.

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +	if (error == -EINVAL || error == -ENOENT)
> > +		return 0;
> > +	if (error)
> >  		return error;
> > -	}
> >  
> >  	ASSERT(ip->i_delayed_blks == 0);
> >  
> > @@ -1157,7 +1154,7 @@ xfs_qm_dqusage_adjust(
> >  		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> >  
> >  		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > -			error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> > +			error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> >  			if (error)
> >  				goto error0;
> >  		}
> > @@ -1200,13 +1197,8 @@ xfs_qm_dqusage_adjust(
> >  			goto error0;
> >  	}
> >  
> > -	xfs_irele(ip);
> > -	*res = BULKSTAT_RV_DIDONE;
> > -	return 0;
> > -
> >  error0:
> >  	xfs_irele(ip);
> > -	*res = BULKSTAT_RV_GIVEUP;
> >  	return error;
> >  }
> >  
> > @@ -1270,18 +1262,13 @@ STATIC int
> >  xfs_qm_quotacheck(
> >  	xfs_mount_t	*mp)
> >  {
> > -	int			done, count, error, error2;
> > -	xfs_ino_t		lastino;
> > -	size_t			structsz;
> > +	int			error, error2;
> >  	uint			flags;
> >  	LIST_HEAD		(buffer_list);
> >  	struct xfs_inode	*uip = mp->m_quotainfo->qi_uquotaip;
> >  	struct xfs_inode	*gip = mp->m_quotainfo->qi_gquotaip;
> >  	struct xfs_inode	*pip = mp->m_quotainfo->qi_pquotaip;
> >  
> > -	count = INT_MAX;
> > -	structsz = 1;
> > -	lastino = 0;
> >  	flags = 0;
> >  
> >  	ASSERT(uip || gip || pip);
> > @@ -1318,18 +1305,9 @@ xfs_qm_quotacheck(
> >  		flags |= XFS_PQUOTA_CHKD;
> >  	}
> >  
> > -	do {
> > -		/*
> > -		 * Iterate thru all the inodes in the file system,
> > -		 * adjusting the corresponding dquot counters in core.
> > -		 */
> > -		error = xfs_bulkstat(mp, &lastino, &count,
> > -				     xfs_qm_dqusage_adjust,
> > -				     structsz, NULL, &done);
> > -		if (error)
> > -			break;
> > -
> > -	} while (!done);
> > +	error = xfs_iwalk(mp, NULL, 0, xfs_qm_dqusage_adjust, 0, NULL);
> > +	if (error)
> > +		goto error_return;
> >  
> >  	/*
> >  	 * We've made all the changes that we need to make incore.  Flush them
> > 
