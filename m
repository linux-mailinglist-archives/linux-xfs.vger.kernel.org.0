Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D01B197BA3
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Mar 2020 14:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbgC3MPu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 30 Mar 2020 08:15:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:46399 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729867AbgC3MPu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Mar 2020 08:15:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585570549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XIB3Kt4/Qz93A6/QQAEfG9SAR/UO9k/yyPLAYa54zXg=;
        b=Ne6rea0U4Q3MILETW3uAHEwuOAXsj/JbiNZixEao0n20Mrj5mY0oCuZTEmsum/lGPCjsew
        hTVlOSUz3PlbMAvb/NA6q6SL3MPsbKazERxHxBQUYDUlrK+ihpvZlH+ODj3kwH1eO6hrJW
        +K44D3XdqFli2SVxozLWnyxyPnQ8SNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-T5CdNj-cPweEAG1-zuD2pg-1; Mon, 30 Mar 2020 08:15:47 -0400
X-MC-Unique: T5CdNj-cPweEAG1-zuD2pg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B73D119251A7;
        Mon, 30 Mar 2020 12:15:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 565F5194BB;
        Mon, 30 Mar 2020 12:15:46 +0000 (UTC)
Date:   Mon, 30 Mar 2020 08:15:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200330121544.GA45961@bfoster>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
 <20200329224602.GT10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329224602.GT10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 30, 2020 at 09:46:02AM +1100, Dave Chinner wrote:
> On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> > A dquot flush currently blocks on the buffer lock for the underlying
> > dquot buffer. In turn, this causes xfsaild to block rather than
> > continue processing other items in the meantime. Update
> > xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> > are handled, and return -EAGAIN if the lock fails. Fix up any
> > callers that don't currently handle the error properly.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
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
> 
> Doesn't xfs_inode_item_push() also have this problem in that it
> doesn't handle -EAGAIN properly?
> 
> Also, we can get -EIO, -EFSCORRUPTED, etc here. They probably
> shouldn't return XFS_ITEM_SUCCESS, either....
> 

Good point. I'm actually not sure what we should return in that case
given the item return codes all seem to assume a valid state. We could
define an XFS_ITEM_ERROR return, but I'm not sure it's worth it for what
is currently stat/tracepoint logic in the caller. Perhaps a broader
rework of error handling in this context is in order that would lift
generic (fatal) error handling into xfsaild. E.g., I see that
xfs_qm_dqflush() is inconsistent by itself in that the item is removed
from the AIL if we're already shut down, but not if that function
invokes the shutdown; we shutdown if the direct xfs_dqblk_verify() call
fails but not if the read verifier (which also looks like it calls
xfs_dqblk_verify() on every on-disk dquot) returns -EFSCORRUPTED, etc.
It might make some sense to let iop_push() return negative error codes
if that facilitates consistent error handling...

Brian

> Otherwise seems OK.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

