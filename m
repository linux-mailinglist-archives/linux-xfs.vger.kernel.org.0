Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E24195B5B
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Mar 2020 17:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgC0Qou (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Mar 2020 12:44:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:21720 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727287AbgC0Qou (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 12:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585327489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LXcD4qrBzdJWxeAg6iBRsWL6QmpgCRj/+ykm+ucIhdI=;
        b=fNYGlM+0n4q7lMaVvzgyqknBOOZ6Y00Y4fd6yLITWcX6B+5WsSP+i0/Ix+ty8N8vn+FQqx
        KyLEQU+8MgYMexBTMHEH59BSFgdQcG76B0cFrNZjT+nLiCjwlTJ4xU8Gpy8oNB2Myo8p9g
        ruzv2OY8QsJF5NGqrl5ptOc05hdDO8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-93UI-A_XMXWDXwu2D1hBrQ-1; Fri, 27 Mar 2020 12:44:44 -0400
X-MC-Unique: 93UI-A_XMXWDXwu2D1hBrQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40CB31005513;
        Fri, 27 Mar 2020 16:44:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C59CB60FC1;
        Fri, 27 Mar 2020 16:44:42 +0000 (UTC)
Date:   Fri, 27 Mar 2020 12:44:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200327164440.GB29156@bfoster>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
 <20200327154527.GJ29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327154527.GJ29339@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 08:45:28AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> > A dquot flush currently blocks on the buffer lock for the underlying
> > dquot buffer. In turn, this causes xfsaild to block rather than
> > continue processing other items in the meantime. Update
> > xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> > are handled, and return -EAGAIN if the lock fails. Fix up any
> > callers that don't currently handle the error properly.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Is xfs_qm_dquot_isolate returning LRU_RETRY an acceptable resolution (as
> opposed to, say, LRU_SKIP) for xfs_qm_dqflush returning -EAGAIN?
> 

Hmm.. this is reclaim so I suppose LRU_SKIP would be more appropriate
than retry (along with more consistent with the other trylock failures
in that function). Ok with something like the following?

@@ -461,7 +461,11 @@ xfs_qm_dquot_isolate(
 		spin_unlock(lru_lock);
 
 		error = xfs_qm_dqflush(dqp, &bp);
-		if (error)
+		if (error == -EAGAIN) {
+			xfs_dqunlock(dqp);
+			spin_lock(lru_lock);
+			goto out_miss_busy;
+		} else if (error)
 			goto out_unlock_dirty;
 
 		xfs_buf_delwri_queue(bp, &isol->buffers);

Brian

> --D
> 
> > ---
> >  fs/xfs/xfs_dquot.c      |  6 +++---
> >  fs/xfs/xfs_dquot_item.c |  3 ++-
> >  fs/xfs/xfs_qm.c         | 14 +++++++++-----
> >  3 files changed, 14 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 711376ca269f..af2c8e5ceea0 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
> >  	 * Get the buffer containing the on-disk dquot
> >  	 */
> >  	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
> > -				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> > -				   &xfs_dquot_buf_ops);
> > +				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
> > +				   &bp, &xfs_dquot_buf_ops);
> >  	if (error)
> >  		goto out_unlock;
> >  
> > @@ -1177,7 +1177,7 @@ xfs_qm_dqflush(
> >  
> >  out_unlock:
> >  	xfs_dqfunlock(dqp);
> > -	return -EIO;
> > +	return error;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > index cf65e2e43c6e..baad1748d0d1 100644
> > --- a/fs/xfs/xfs_dquot_item.c
> > +++ b/fs/xfs/xfs_dquot_item.c
> > @@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
> >  		if (!xfs_buf_delwri_queue(bp, buffer_list))
> >  			rval = XFS_ITEM_FLUSHING;
> >  		xfs_buf_relse(bp);
> > -	}
> > +	} else if (error == -EAGAIN)
> > +		rval = XFS_ITEM_LOCKED;
> >  
> >  	spin_lock(&lip->li_ailp->ail_lock);
> >  out_unlock:
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index de1d2c606c14..68c778d25c48 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -121,12 +121,11 @@ xfs_qm_dqpurge(
> >  {
> >  	struct xfs_mount	*mp = dqp->q_mount;
> >  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> > +	int			error = -EAGAIN;
> >  
> >  	xfs_dqlock(dqp);
> > -	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
> > -		xfs_dqunlock(dqp);
> > -		return -EAGAIN;
> > -	}
> > +	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0)
> > +		goto out_unlock;
> >  
> >  	dqp->dq_flags |= XFS_DQ_FREEING;
> >  
> > @@ -139,7 +138,6 @@ xfs_qm_dqpurge(
> >  	 */
> >  	if (XFS_DQ_IS_DIRTY(dqp)) {
> >  		struct xfs_buf	*bp = NULL;
> > -		int		error;
> >  
> >  		/*
> >  		 * We don't care about getting disk errors here. We need
> > @@ -149,6 +147,8 @@ xfs_qm_dqpurge(
> >  		if (!error) {
> >  			error = xfs_bwrite(bp);
> >  			xfs_buf_relse(bp);
> > +		} else if (error == -EAGAIN) {
> > +			goto out_unlock;
> >  		}
> >  		xfs_dqflock(dqp);
> >  	}
> > @@ -174,6 +174,10 @@ xfs_qm_dqpurge(
> >  
> >  	xfs_qm_dqdestroy(dqp);
> >  	return 0;
> > +
> > +out_unlock:
> > +	xfs_dqunlock(dqp);
> > +	return error;
> >  }
> >  
> >  /*
> > -- 
> > 2.21.1
> > 
> 

