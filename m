Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BF22F177C
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Jan 2021 15:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388497AbhAKOHR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Jan 2021 09:07:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388221AbhAKOHQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 09:07:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610373949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5hFv1LWqqfHjoCLbS04F7E0ZHmLfIiOuAIRYH48xgL0=;
        b=Q4tdPkEA9G5FI5ttFMw0yjYaR5f0iiiD/SBZNP6dlJINusJvU0NXybleVmjx/2CsTMsB9z
        FqpaRLimdZoCq5VEkupnqm0pC80svAjG1oyLwRZsawiY/7iJYX71Tz5lGQ5XUgv+YomDDv
        e2dP4S3oQI3tr4zexktRYl+gvtSitNE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-p7o3Y5oVNc6yTASxisGxNw-1; Mon, 11 Jan 2021 09:05:45 -0500
X-MC-Unique: p7o3Y5oVNc6yTASxisGxNw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22CEB1927801;
        Mon, 11 Jan 2021 14:05:44 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 483035B4A6;
        Mon, 11 Jan 2021 14:05:43 +0000 (UTC)
Date:   Mon, 11 Jan 2021 09:05:41 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     wenli xie <wlxie7296@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        chiluk@ubuntu.com, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210111140541.GA1091932@bfoster>
References: <20210108015648.GP6918@magnolia>
 <20210108151858.GB893097@bfoster>
 <20210109013948.GT6918@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109013948.GT6918@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 05:39:48PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 08, 2021 at 10:18:58AM -0500, Brian Foster wrote:
> > On Thu, Jan 07, 2021 at 05:56:48PM -0800, Darrick J. Wong wrote:
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
> > > in order of increasing AG number per the locking rules.  Set
> > > t_firstblock so that a subsequent directory block allocation never tries
> > > to grab a lower-numbered AGF than the AGIs we grabbed.
> > > 
> > 
> > I don't see this patch do anything with t_firstblock... Even so, is that
> > necessary? I thought we had to lock AGIs before AGFs and always in agno
> > order, but not necessarily lock an AGF >= previously locked AGIs. Hm?
> 
> Oops, heh.  Yeah, I'd added chunks to prevent block allocation, but on
> further analysis I don't think that was necessary.
> 
> > > Reduce the likelihood that a directory expansion will ENOSPC by starting
> > > with AG 0 when allocating whiteout files.
> > > 
> > > Reported-by: wenli xie <wlxie7296@gmail.com>
> > > Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: Make it more obvious that we're grabbing all the AGI locks ahead of
> > > the AGFs, and hide functions that we don't need to export anymore.
> > > ---
> > >  fs/xfs/libxfs/xfs_dir2.h    |    2 --
> > >  fs/xfs/libxfs/xfs_dir2_sf.c |    2 +-
> > >  fs/xfs/xfs_inode.c          |   57 ++++++++++++++++++++++++++++++-------------
> > >  3 files changed, 41 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> > > index e55378640b05..d03e6098ded9 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2.h
> > > +++ b/fs/xfs/libxfs/xfs_dir2.h
> > > @@ -47,8 +47,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
> > >  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
> > >  				struct xfs_name *name, xfs_ino_t ino,
> > >  				xfs_extlen_t tot);
> > > -extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
> > > -				xfs_ino_t inum);
> > >  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
> > >  				struct xfs_name *name, xfs_ino_t inum,
> > >  				xfs_extlen_t tot);
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > > index 2463b5d73447..8c4f76bba88b 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> > > @@ -1018,7 +1018,7 @@ xfs_dir2_sf_removename(
> > >  /*
> > >   * Check whether the sf dir replace operation need more blocks.
> > >   */
> > > -bool
> > > +static bool
> > >  xfs_dir2_sf_replace_needblock(
> > >  	struct xfs_inode	*dp,
> > >  	xfs_ino_t		inum)
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index b7352bc4c815..528152770dc9 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -3000,6 +3000,24 @@ xfs_rename_alloc_whiteout(
> > >  	return 0;
> > >  }
> > >  
> > > +/* Decide if we need to lock the target IP's AGI as part of a rename. */
> > > +static inline bool
> > > +xfs_rename_lock_target_ip(
> > > +	struct xfs_inode	*src_ip,
> > > +	struct xfs_inode	*target_ip)
> > > +{
> > > +	unsigned int		tgt_nlink = VFS_I(target_ip)->i_nlink;
> > > +	bool			src_is_dir = S_ISDIR(VFS_I(src_ip)->i_mode);
> > > +
> > > +	/*
> > > +	 * We only need to lock the AGI if the target ip will end up on the
> > > +	 * unlinked list.
> > > +	 */
> > > +	if (src_is_dir)
> > > +		return tgt_nlink == 2;
> > 
> > IIUC, we can't rename dirs over nondirs and vice versa. I.e.:
> > 
> > # mv dir file
> > mv: overwrite 'file'? y
> > mv: cannot overwrite non-directory 'file' with directory 'dir'
> > # mv -T file dir
> > mv: overwrite 'dir'? y
> > mv: cannot overwrite directory 'dir' with non-directory
> > 
> > That means that if src_is_dir is true, target must either be NULL or an
> > empty directory for the rename to succeed, right? If so, have we already
> > enforced that by this point? I'm wondering if we need to check the link
> > count == 2 in this case or could possibly just reduce the logic to
> > (tgt_nlink == 1 || src_is_dir) And if so, whether that still warrants an
> > inline helper (where I suppose we could still assert that nlink == 2).
> 
> Hm.  I /think/ it's true that we can't ever rename atop an existing
> directory, so I think this cna go away:
> 
> $ mkdir /tmp/xx
> $ touch /tmp/yy
> $ strace -s99 -e renameat ./src/renameat2 /tmp/yy /tmp/xx
> renameat(AT_FDCWD, "/tmp/yy", AT_FDCWD, "/tmp/xx") = -1 EISDIR (Is a directory)
> 

Not sure if you mean to qualify that as "with another nondir" or not,
but fwiw we can rename over an empty dir if the source is a dir:

# mkdir d1
# mkdir d2
# ~/xfstests-dev/src/renameat2 d1 d2
#

Brian

> --D
> 
> > Brian
> > 
> > > +	return tgt_nlink == 1;
> > > +}
> > > +
> > >  /*
> > >   * xfs_rename
> > >   */
> > > @@ -3017,7 +3035,7 @@ xfs_rename(
> > >  	struct xfs_trans	*tp;
> > >  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
> > >  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> > > -	struct xfs_buf		*agibp;
> > > +	int			i;
> > >  	int			num_inodes = __XFS_SORT_INODES;
> > >  	bool			new_parent = (src_dp != target_dp);
> > >  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> > > @@ -3130,6 +3148,27 @@ xfs_rename(
> > >  		}
> > >  	}
> > >  
> > > +	/*
> > > +	 * Lock the AGI buffers we need to handle bumping the nlink of the
> > > +	 * whiteout inode off the unlinked list and to handle dropping the
> > > +	 * nlink of the target inode.  We have to do this in increasing AG
> > > +	 * order to avoid deadlocks, and before directory block allocation
> > > +	 * tries to grab AGFs.
> > > +	 */
> > > +	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
> > > +		if (inodes[i] == wip ||
> > > +		    (inodes[i] == target_ip &&
> > > +		     xfs_rename_lock_target_ip(src_ip, target_ip))) {
> > > +			struct xfs_buf	*bp;
> > > +			xfs_agnumber_t	agno;
> > > +
> > > +			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
> > > +			error = xfs_read_agi(mp, tp, agno, &bp);
> > > +			if (error)
> > > +				goto out_trans_cancel;
> > > +		}
> > > +	}
> > > +
> > >  	/*
> > >  	 * Directory entry creation below may acquire the AGF. Remove
> > >  	 * the whiteout from the unlinked list first to preserve correct
> > > @@ -3182,22 +3221,6 @@ xfs_rename(
> > >  		 * In case there is already an entry with the same
> > >  		 * name at the destination directory, remove it first.
> > >  		 */
> > > -
> > > -		/*
> > > -		 * Check whether the replace operation will need to allocate
> > > -		 * blocks.  This happens when the shortform directory lacks
> > > -		 * space and we have to convert it to a block format directory.
> > > -		 * When more blocks are necessary, we must lock the AGI first
> > > -		 * to preserve locking order (AGI -> AGF).
> > > -		 */
> > > -		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
> > > -			error = xfs_read_agi(mp, tp,
> > > -					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
> > > -					&agibp);
> > > -			if (error)
> > > -				goto out_trans_cancel;
> > > -		}
> > > -
> > >  		error = xfs_dir_replace(tp, target_dp, target_name,
> > >  					src_ip->i_ino, spaceres);
> > >  		if (error)
> > > 
> > 
> 

