Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC3E5B8E84
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Sep 2022 20:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiINSEp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Sep 2022 14:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiINSEm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2022 14:04:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CADA63DB
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 11:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59F62B81AD2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 18:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF51C433C1;
        Wed, 14 Sep 2022 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663178677;
        bh=B5iP9uSvAZU0ERc0fL9qjdIVtpBGlutLv8m3HEIX6a4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XokGtpKMwWyOUkAbMSUdC+YdOFzqMc6eqUyYjwAIU8qL7rBaRLFGk014lQb/fodvV
         L+eiNSnQmABN9PQnw+hz/3jfpNfmLmuNUElqv0MqPwHuqhDg1Cqo53sfpUBlN4XBN7
         XmvrHajt7b8q6JOR2LDwhOo95GELVwG9vEoM3dt9idcFwmjpoQnoeFXNRVWL2AHoCU
         pvst97AWekHRADeSSCiw9ghZV7usdZRret/oN/X8B761hj3e9gdw/ZoEoU36/+m+Ll
         N8lt3b+C+UrWohWvB5lIr9pAx6XE+ivkFKZ6L4SbfnC7yy1TZBTCzfqh6+lSXQj3NQ
         uxKSiFijVbufg==
Date:   Wed, 14 Sep 2022 11:04:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: port to vfs{g,u}id_t and associated helpers
Message-ID: <YyIXtNoDbuck222O@magnolia>
References: <20220909095659.944062-1-brauner@kernel.org>
 <YyIL8i497RPKywYV@magnolia>
 <20220914172921.vlwhpzae3deh7axl@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914172921.vlwhpzae3deh7axl@wittgenstein>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 14, 2022 at 07:29:21PM +0200, Christian Brauner wrote:
> On Wed, Sep 14, 2022 at 10:14:26AM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 09, 2022 at 11:56:59AM +0200, Christian Brauner wrote:
> > > A while ago we introduced a dedicated vfs{g,u}id_t type in commit
> > > 1e5267cd0895 ("mnt_idmapping: add vfs{g,u}id_t"). We already switched
> > > over a good part of the VFS. Ultimately we will remove all legacy
> > > idmapped mount helpers that operate only on k{g,u}id_t
> > 
> > Does this mean i_uid_into_mnt is going away?
> 
> Yes, all of the non-vfs{g,u}id_t helper will be removed once we finished
> converting. That hopefully won't take long. I was just a bit busy with
> posix acls (still am tbh) so didn't get around to removing it
> completely yet. But the fs/attr.c and fs/posix_acl.c codepaths are
> already switched.
> 
> > 
> > > in favor of the
> > > new type safe helpers that operate on vfs{g,u}id_t.
> > > 
> > > Cc: Dave Chinner <dchinner@redhat.com>
> > > Cc: Seth Forshee (Digital Ocean) <sforshee@kernel.org>
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Cc: Darrick J. Wong <djwong@kernel.org>
> > > Cc: linux-xfs@vger.kernel.org
> > > Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> > > ---
> > >  fs/xfs/xfs_inode.c  | 5 ++---
> > >  fs/xfs/xfs_iops.c   | 6 ++++--
> > >  fs/xfs/xfs_itable.c | 8 ++++++--
> > >  3 files changed, 12 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 28493c8e9bb2..bca204a5aecf 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -835,9 +835,8 @@ xfs_init_new_inode(
> > >  	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
> > >  	 * (and only if the irix_sgid_inherit compatibility variable is set).
> > >  	 */
> > > -	if (irix_sgid_inherit &&
> > > -	    (inode->i_mode & S_ISGID) &&
> > > -	    !in_group_p(i_gid_into_mnt(mnt_userns, inode)))
> > > +	if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
> > > +	    !vfsgid_in_group_p(i_gid_into_vfsgid(mnt_userns, inode)))
> > >  		inode->i_mode &= ~S_ISGID;
> > >  
> > >  	ip->i_disk_size = 0;
> > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > index 45518b8c613c..5d670c85dcc2 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -558,6 +558,8 @@ xfs_vn_getattr(
> > >  	struct inode		*inode = d_inode(path->dentry);
> > >  	struct xfs_inode	*ip = XFS_I(inode);
> > >  	struct xfs_mount	*mp = ip->i_mount;
> > > +	vfsuid_t		vfsuid = i_uid_into_vfsuid(mnt_userns, inode);
> > > +	vfsgid_t		vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
> > >  
> > >  	trace_xfs_getattr(ip);
> > >  
> > > @@ -568,8 +570,8 @@ xfs_vn_getattr(
> > >  	stat->dev = inode->i_sb->s_dev;
> > >  	stat->mode = inode->i_mode;
> > >  	stat->nlink = inode->i_nlink;
> > > -	stat->uid = i_uid_into_mnt(mnt_userns, inode);
> > > -	stat->gid = i_gid_into_mnt(mnt_userns, inode);
> > > +	stat->uid = vfsuid_into_kuid(vfsuid);
> > > +	stat->gid = vfsgid_into_kgid(vfsgid);
> > >  	stat->ino = ip->i_ino;
> > >  	stat->atime = inode->i_atime;
> > >  	stat->mtime = inode->i_mtime;
> > > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > > index 36312b00b164..a1c2bcf65d37 100644
> > > --- a/fs/xfs/xfs_itable.c
> > > +++ b/fs/xfs/xfs_itable.c
> > > @@ -66,6 +66,8 @@ xfs_bulkstat_one_int(
> > >  	struct xfs_bulkstat	*buf = bc->buf;
> > >  	xfs_extnum_t		nextents;
> > >  	int			error = -EINVAL;
> > > +	vfsuid_t		vfsuid;
> > > +	vfsgid_t		vfsgid;
> > >  
> > >  	if (xfs_internal_inum(mp, ino))
> > >  		goto out_advance;
> > > @@ -81,14 +83,16 @@ xfs_bulkstat_one_int(
> > >  	ASSERT(ip != NULL);
> > >  	ASSERT(ip->i_imap.im_blkno != 0);
> > >  	inode = VFS_I(ip);
> > > +	vfsuid = i_uid_into_vfsuid(mnt_userns, inode);
> > > +	vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
> > >  
> > >  	/* xfs_iget returns the following without needing
> > >  	 * further change.
> > >  	 */
> > >  	buf->bs_projectid = ip->i_projid;
> > >  	buf->bs_ino = ino;
> > > -	buf->bs_uid = from_kuid(sb_userns, i_uid_into_mnt(mnt_userns, inode));
> > > -	buf->bs_gid = from_kgid(sb_userns, i_gid_into_mnt(mnt_userns, inode));
> > > +	buf->bs_uid = from_kuid(sb_userns, vfsuid_into_kuid(vfsuid));
> > > +	buf->bs_gid = from_kgid(sb_userns, vfsgid_into_kgid(vfsgid));
> > 
> > Hmm.  How does this work, exactly?
> > 
> > First we map inode.i_uid into a uid in the (file) mount userns, which I
> > guess is what a vfsuid_t is?  And then we map that vfsuid_t into a
> 
> Yes.
> 
> > kernel uid (hence kuid_t)?  After which we map that kuid_t into the...
> > filesystem(?)'s userns, which is what we return to userspace?
> 
> Yes.
> 
> > 
> > /me confused, need picture. :/
> 
> Without going into all of [1] the gist is that we undo the filesystem
> idmapping and apply the mount idmapping. For this we use a new type to
> clearly indicate that this is a {g,u}id as seen from the mount.
> 
> Since this ioctl reports ownership information we now need to translate
> that vfs{g,u}id_t into a userspace {g,u}id.
> 
> A filesystem would usually not see this unless it has something like xfs
> does where it allows to report ownership outside of the vfs.

Heh, I'm surprised I understood all that. :)

> Note that the bulkstat code also doesn't currently support idmapped
> mounts - and won't because it can operate on the whole filesystem not
> just within a mount. So i_uid_into_vfsuid() is always a nop and just
> changes the type.
> 
> > 
> > (Admittedly my unfamiliarity with idmapping isn't helping here -- this
> > looks consistent with what the VFS does, but I don't quite grok the
> > layers...)
> 
> [1]: So it is fully documented in
>      Documentations/filesystems/idmappings.rst.
> I'll update that with the new helpers and types in a bit.

Ok.  I did take a look at
https://www.kernel.org/doc/html/latest/filesystems/idmappings.html
but it was the lack of any mention of the new helpers that I got stuck
on. :(

With documentation updates :D,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


--D
