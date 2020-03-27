Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB89B195B9D
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Mar 2020 17:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgC0Qww (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Mar 2020 12:52:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55008 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgC0Qwv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 12:52:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGdPa7064088;
        Fri, 27 Mar 2020 16:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tCfp/7ZfnbJGbLDqUhOWMJHGS35hFH03IQ58KePQCZ0=;
 b=0gs3Y84AIISUmi9TiJOYRz/qelf0R9eXEATHHBCeTrkH1QD2Lbe31yLZ03mDYPZSVWJk
 Ppec+TCQXp6UYyJAYyS6UyiuxYftx2t0I19pshoy5HC+J8CKpsxPL53G43FR6j9lcr2g
 wq1S9C/e/h98oHy1/hGfLXHotU3EbVBlvpi1q9JljztlFqs8vV7XovRj3ZoO+6YCvpoW
 VgNqbPtjdGiULmxsC8IriyJCsMHUDu/yuBrbTyD33CpGJSL/qqJVWqpG+t0d18IygLhh
 t2ORb3ef2He2gXthWO9GmtcdJ9OyQV8I73b8IK1zEs0JPBQl0lNpfBbmi7LSxcwtgvRF PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 301459c7hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 16:52:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGoe4F135367;
        Fri, 27 Mar 2020 16:50:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3006rakwmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 16:50:47 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02RGokDp022350;
        Fri, 27 Mar 2020 16:50:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 09:50:46 -0700
Date:   Fri, 27 Mar 2020 09:50:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200327165045.GQ29351@magnolia>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
 <20200327154527.GJ29339@magnolia>
 <20200327164440.GB29156@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327164440.GB29156@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 12:44:40PM -0400, Brian Foster wrote:
> On Fri, Mar 27, 2020 at 08:45:28AM -0700, Darrick J. Wong wrote:
> > On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> > > A dquot flush currently blocks on the buffer lock for the underlying
> > > dquot buffer. In turn, this causes xfsaild to block rather than
> > > continue processing other items in the meantime. Update
> > > xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> > > are handled, and return -EAGAIN if the lock fails. Fix up any
> > > callers that don't currently handle the error properly.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > 
> > Is xfs_qm_dquot_isolate returning LRU_RETRY an acceptable resolution (as
> > opposed to, say, LRU_SKIP) for xfs_qm_dqflush returning -EAGAIN?
> > 
> 
> Hmm.. this is reclaim so I suppose LRU_SKIP would be more appropriate
> than retry (along with more consistent with the other trylock failures
> in that function). Ok with something like the following?
> 
> @@ -461,7 +461,11 @@ xfs_qm_dquot_isolate(
>  		spin_unlock(lru_lock);
>  
>  		error = xfs_qm_dqflush(dqp, &bp);
> -		if (error)
> +		if (error == -EAGAIN) {
> +			xfs_dqunlock(dqp);
> +			spin_lock(lru_lock);
> +			goto out_miss_busy;
> +		} else if (error)
>  			goto out_unlock_dirty;
>  
>  		xfs_buf_delwri_queue(bp, &isol->buffers);

Yeah, looks good to me.

--D

> 
> Brian
> 
> > --D
> > 
> > > ---
> > >  fs/xfs/xfs_dquot.c      |  6 +++---
> > >  fs/xfs/xfs_dquot_item.c |  3 ++-
> > >  fs/xfs/xfs_qm.c         | 14 +++++++++-----
> > >  3 files changed, 14 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > index 711376ca269f..af2c8e5ceea0 100644
> > > --- a/fs/xfs/xfs_dquot.c
> > > +++ b/fs/xfs/xfs_dquot.c
> > > @@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
> > >  	 * Get the buffer containing the on-disk dquot
> > >  	 */
> > >  	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
> > > -				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> > > -				   &xfs_dquot_buf_ops);
> > > +				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
> > > +				   &bp, &xfs_dquot_buf_ops);
> > >  	if (error)
> > >  		goto out_unlock;
> > >  
> > > @@ -1177,7 +1177,7 @@ xfs_qm_dqflush(
> > >  
> > >  out_unlock:
> > >  	xfs_dqfunlock(dqp);
> > > -	return -EIO;
> > > +	return error;
> > >  }
> > >  
> > >  /*
> > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > index cf65e2e43c6e..baad1748d0d1 100644
> > > --- a/fs/xfs/xfs_dquot_item.c
> > > +++ b/fs/xfs/xfs_dquot_item.c
> > > @@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
> > >  		if (!xfs_buf_delwri_queue(bp, buffer_list))
> > >  			rval = XFS_ITEM_FLUSHING;
> > >  		xfs_buf_relse(bp);
> > > -	}
> > > +	} else if (error == -EAGAIN)
> > > +		rval = XFS_ITEM_LOCKED;
> > >  
> > >  	spin_lock(&lip->li_ailp->ail_lock);
> > >  out_unlock:
> > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > index de1d2c606c14..68c778d25c48 100644
> > > --- a/fs/xfs/xfs_qm.c
> > > +++ b/fs/xfs/xfs_qm.c
> > > @@ -121,12 +121,11 @@ xfs_qm_dqpurge(
> > >  {
> > >  	struct xfs_mount	*mp = dqp->q_mount;
> > >  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> > > +	int			error = -EAGAIN;
> > >  
> > >  	xfs_dqlock(dqp);
> > > -	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
> > > -		xfs_dqunlock(dqp);
> > > -		return -EAGAIN;
> > > -	}
> > > +	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0)
> > > +		goto out_unlock;
> > >  
> > >  	dqp->dq_flags |= XFS_DQ_FREEING;
> > >  
> > > @@ -139,7 +138,6 @@ xfs_qm_dqpurge(
> > >  	 */
> > >  	if (XFS_DQ_IS_DIRTY(dqp)) {
> > >  		struct xfs_buf	*bp = NULL;
> > > -		int		error;
> > >  
> > >  		/*
> > >  		 * We don't care about getting disk errors here. We need
> > > @@ -149,6 +147,8 @@ xfs_qm_dqpurge(
> > >  		if (!error) {
> > >  			error = xfs_bwrite(bp);
> > >  			xfs_buf_relse(bp);
> > > +		} else if (error == -EAGAIN) {
> > > +			goto out_unlock;
> > >  		}
> > >  		xfs_dqflock(dqp);
> > >  	}
> > > @@ -174,6 +174,10 @@ xfs_qm_dqpurge(
> > >  
> > >  	xfs_qm_dqdestroy(dqp);
> > >  	return 0;
> > > +
> > > +out_unlock:
> > > +	xfs_dqunlock(dqp);
> > > +	return error;
> > >  }
> > >  
> > >  /*
> > > -- 
> > > 2.21.1
> > > 
> > 
> 
