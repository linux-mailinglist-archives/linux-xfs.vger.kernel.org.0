Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6A12EA6DB
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Jan 2021 10:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbhAEJCx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 Jan 2021 04:02:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbhAEJCw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 04:02:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609837285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pnuCFGuJ4IwBrNkY+vsONp8QIqfhHtVFbhZUNPAwNAQ=;
        b=J8/E/i63oStbFFoSzSZeWlcdVLZoC5sHVy2+EwBVAHgCEmcnEEdShEZfDwLihrVQEt7qzo
        tJ1zGTPwOp2wKAzMh5O9kh6A1oK9q1a4CVWnIp19wFYCc5+OGXKWb4B/C4Eh/RUysHZh4K
        cN1cpPStyHySWOATfudZzmsdiskcSr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-S0fW4BDfMqaBD9qeu1MGug-1; Tue, 05 Jan 2021 04:01:23 -0500
X-MC-Unique: S0fW4BDfMqaBD9qeu1MGug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2098D107ACE6;
        Tue,  5 Jan 2021 09:01:22 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 782EB1349A;
        Tue,  5 Jan 2021 09:01:21 +0000 (UTC)
Date:   Tue, 5 Jan 2021 04:01:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     wenli xie <wlxie7296@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        chiluk@ubuntu.com
Subject: Re: [PATCH] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210105090119.GA284433@bfoster>
References: <20210104194437.GJ38809@magnolia>
 <20210104202714.GE254939@bfoster>
 <20210105011432.GS6918@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105011432.GS6918@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 05:14:32PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 04, 2021 at 03:27:14PM -0500, Brian Foster wrote:
> > On Mon, Jan 04, 2021 at 11:44:37AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > When overlayfs is running on top of xfs and the user unlinks a file in
> > > the overlay, overlayfs will create a whiteout inode and ask xfs to
> > > "rename" the whiteout file atop the one being unlinked.  If the file
> > > being unlinked loses its one nlink, we then have to put the inode on the
> > > unlinked list.
> > > 
> > > This requires us to grab the AGI buffer of the whiteout inode to take it
> > > off the unlinked list (which is where whiteouts are created) and to grab
> > > the AGI buffer of the file being deleted.  If the whiteout was created
> > > in a higher numbered AG than the file being deleted, we'll lock the AGIs
> > > in the wrong order and deadlock.
> > > 
> > > Therefore, grab all the AGI locks we think we'll need ahead of time, and
> > > in the correct order.
> > > 
> > > Reported-by: wenli xie <wlxie7296@gmail.com>
> > > Tested-by: wenli xie <wlxie7296@gmail.com>
> > > Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_inode.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 46 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index b7352bc4c815..dd419a1bc6ba 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -3000,6 +3000,48 @@ xfs_rename_alloc_whiteout(
> > >  	return 0;
> > >  }
> > >  
> > > +/*
> > > + * For the general case of renaming files, lock all the AGI buffers we need to
> > > + * handle bumping the nlink of the whiteout inode off the unlinked list and to
> > > + * handle dropping the nlink of the target inode.  We have to do this in
> > > + * increasing AG order to avoid deadlocks.
> > > + */
> > > +static int
> > > +xfs_rename_lock_agis(
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_inode	*wip,
> > > +	struct xfs_inode	*target_ip)
> > > +{
> > > +	struct xfs_mount	*mp = tp->t_mountp;
> > > +	struct xfs_buf		*bp;
> > > +	xfs_agnumber_t		agi_locks[2] = { NULLAGNUMBER, NULLAGNUMBER };
> > > +	int			error;
> > > +
> > > +	if (wip)
> > > +		agi_locks[0] = XFS_INO_TO_AGNO(mp, wip->i_ino);
> > > +
> > > +	if (target_ip && VFS_I(target_ip)->i_nlink == 1)
> > > +		agi_locks[1] = XFS_INO_TO_AGNO(mp, target_ip->i_ino);
> > > +
> > > +	if (agi_locks[0] != NULLAGNUMBER && agi_locks[1] != NULLAGNUMBER &&
> > > +	    agi_locks[0] > agi_locks[1])
> > > +		swap(agi_locks[0], agi_locks[1]);
> > > +
> > > +	if (agi_locks[0] != NULLAGNUMBER) {
> > > +		error = xfs_read_agi(mp, tp, agi_locks[0], &bp);
> > > +		if (error)
> > > +			return error;
> > > +	}
> > > +
> > > +	if (agi_locks[1] != NULLAGNUMBER) {
> > > +		error = xfs_read_agi(mp, tp, agi_locks[1], &bp);
> > > +		if (error)
> > > +			return error;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > 
> > This all looks reasonable to me, but I wonder if we can simplify
> > a bit by reusing the sorted inodes array we've already created earlier
> > in xfs_rename(). E.g., something like:
> > 
> > 	for (i = 0; i < num_inodes; i++) {
> > 		if (inodes[i] != wip && inodes[i] != target_ip)
> > 			continue;
> > 		error = xfs_read_agi(...);
> > 		...
> > 	}
> > 
> > IOW, similar to how xfs_lock_inodes() and xfs_qm_vop_rename_dqattach()
> > work.
> 
> I think it would be difficult to do that because we only need to grab
> target_ip's AGI if we're going to droplink it, and we haven't yet taken
> target_ip's ILOCK when we invoke the sorting hat so the link count isn't
> stable.
> 

I'm not following how using the inodes array affects this.
xfs_sort_for_rename() simply puts the inodes in inode number order. That
sorted array is reused for various purposes that require that ordering
information (such as acquiring inode locks in the first place). This
patch duplicates a subset of that sorting logic for the agnos of wip and
target_ip to ensure the AGIs are read (if necessary) in order.

The suggestion above would just refer to the already sorted array to
establish order of the associated AGI reads rather than checking and
sorting the agnos explicitly. This would still occur in
xfs_rename_lock_agis() where inode locks have already been acquired, and
so ISTM that the logic could be enhanced to also consider ->i_nlink just
as the original patch does. Hm?

Brian

> --D
> 
> > Brian
> > 
> > > +
> > >  /*
> > >   * xfs_rename
> > >   */
> > > @@ -3130,6 +3172,10 @@ xfs_rename(
> > >  		}
> > >  	}
> > >  
> > > +	error = xfs_rename_lock_agis(tp, wip, target_ip);
> > > +	if (error)
> > > +		return error;
> > > +
> > >  	/*
> > >  	 * Directory entry creation below may acquire the AGF. Remove
> > >  	 * the whiteout from the unlinked list first to preserve correct
> > > 
> > 
> 

