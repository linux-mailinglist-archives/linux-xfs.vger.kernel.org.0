Return-Path: <linux-xfs+bounces-10472-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C40D92A973
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2024 21:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EBD41C214B6
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2024 19:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B0714B975;
	Mon,  8 Jul 2024 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hj80xRBb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF6B4963A;
	Mon,  8 Jul 2024 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720465240; cv=none; b=dQukETaHUwdu7YNOpIAmQs1ueSHyIBYS9BMHepAoM2IrAljqC7Uvh9DQxPzPJ0RFU3KdMkfvHHe/27OjfwwCDPb4wkEs2vXhCeF4Kd1EblcRDdXY19vyod8gv6hmLrH3JxwOo7mtBloaWFwarSnIzisuGqK/ZgMZN/IS6kbXVh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720465240; c=relaxed/simple;
	bh=/KJSuRj9+leevqGL33u7xwNFS5JRZBNfnt+9fLhdWYA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mTJw2M+6z+4vU2DzhwzUvK9nd2W40w4YqJyTjIwoYmehKnsxo9cw/3n3I2GED7OjnHLH2Zs6X2GGM08Dip1irB/TYpvezQ5auOG5I7H0CQMagCe6x220XA6yGMCqznyiHAceuLRAAS6SVMsRxsAFt4zvxnwtHBwPJ6i1XXQK+xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hj80xRBb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4BDC116B1;
	Mon,  8 Jul 2024 19:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720465239;
	bh=/KJSuRj9+leevqGL33u7xwNFS5JRZBNfnt+9fLhdWYA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=hj80xRBbmLhzA8qcAJmBP/185o0WBmfsVtkHngJWOBRa2U2Ku68jRjMWefZa9+ySB
	 wjkiked2916GS2b5GtxyakCniHd2VrjnVDavBrm7exuKFt7h/VpBO8UxwWishJl6aM
	 RTo0tLfG85HSt8TeYHzvjprZ2SiOZ3OyLZPka2HarhwMb4OnpLEjOSTDRxYxsjOTKY
	 rekkZ7nIOGIFtWN2gS1UEZfrYinVb05byhi26qA3hOmkxCxLYBNnr6CWBe5Kwas42d
	 3mcKENB1pWoDrUBBnLz1R1StqMJf42E5JdV0cpGXXEuyS1AC6xzLjfbSQ0LZy6Wu5L
	 //PODtHLOeQ4w==
Message-ID: <0cedef23cf87d598b2c03e850262ac55bca9e792.camel@kernel.org>
Subject: Re: [PATCH v4 6/9] xfs: switch to multigrain timestamps
From: Jeff Layton <jlayton@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Chandan Babu R
 <chandan.babu@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Chris Mason <clm@fb.com>, Josef Bacik
 <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,  Hugh Dickins
 <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan
 Corbet <corbet@lwn.net>,  Dave Chinner <david@fromorbit.com>, Andi Kleen
 <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,  Uros Bizjak
 <ubizjak@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>,
 kernel-team@fb.com,  linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org,  linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
 linux-nfs@vger.kernel.org, linux-doc@vger.kernel.org
Date: Mon, 08 Jul 2024 15:00:36 -0400
In-Reply-To: <28e7a6c193674f2aa41ab1eec9bb8747ddba1a4c.camel@kernel.org>
References: <20240708-mgtime-v4-0-a0f3c6fb57f3@kernel.org>
	 <20240708-mgtime-v4-6-a0f3c6fb57f3@kernel.org>
	 <20240708184739.GP612460@frogsfrogsfrogs>
	 <28e7a6c193674f2aa41ab1eec9bb8747ddba1a4c.camel@kernel.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 (3.52.2-1.fc40app2) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-07-08 at 14:51 -0400, Jeff Layton wrote:
> On Mon, 2024-07-08 at 11:47 -0700, Darrick J. Wong wrote:
> > On Mon, Jul 08, 2024 at 11:53:39AM -0400, Jeff Layton wrote:
> > > Enable multigrain timestamps, which should ensure that there is an
> > > apparent change to the timestamp whenever it has been written after
> > > being actively observed via getattr.
> > >=20
> > > Also, anytime the mtime changes, the ctime must also change, and thos=
e
> > > are now the only two options for xfs_trans_ichgtime. Have that functi=
on
> > > unconditionally bump the ctime, and ASSERT that XFS_ICHGTIME_CHG is
> > > always set.
> > >=20
> > > Finally, stop setting STATX_CHANGE_COOKIE in getattr, since the ctime
> > > should give us better semantics now.
> > >=20
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_trans_inode.c |  6 +++---
> > >  fs/xfs/xfs_iops.c               | 10 +++-------
> > >  fs/xfs/xfs_super.c              |  2 +-
> > >  3 files changed, 7 insertions(+), 11 deletions(-)
> > >=20
> > > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_tran=
s_inode.c
> > > index 69fc5b981352..1f3639bbf5f0 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > > @@ -62,12 +62,12 @@ xfs_trans_ichgtime(
> > >  	ASSERT(tp);
> > >  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
> > > =20
> > > -	tv =3D current_time(inode);
> > > +	/* If the mtime changes, then ctime must also change */
> > > +	ASSERT(flags & XFS_ICHGTIME_CHG);
> > > =20
> > > +	tv =3D inode_set_ctime_current(inode);
> > >  	if (flags & XFS_ICHGTIME_MOD)
> > >  		inode_set_mtime_to_ts(inode, tv);
> > > -	if (flags & XFS_ICHGTIME_CHG)
> > > -		inode_set_ctime_to_ts(inode, tv);
> > >  	if (flags & XFS_ICHGTIME_CREATE)
> > >  		ip->i_crtime =3D tv;
> > >  }
> > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > index a00dcbc77e12..d25872f818fa 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -592,8 +592,9 @@ xfs_vn_getattr(
> > >  	stat->gid =3D vfsgid_into_kgid(vfsgid);
> > >  	stat->ino =3D ip->i_ino;
> > >  	stat->atime =3D inode_get_atime(inode);
> > > -	stat->mtime =3D inode_get_mtime(inode);
> > > -	stat->ctime =3D inode_get_ctime(inode);
> > > +
> > > +	fill_mg_cmtime(stat, request_mask, inode);
> >=20
> > Sooo... for setting up a commit-range operation[1], XFS_IOC_START_COMMI=
T
> > could populate its freshness data by calling:
> >=20
> > 	struct kstat dummy;
> >=20
> > 	fill_mg_ctime(&dummy, STATX_CTIME | STATX_MTIME, inode);
> >=20
> > and then using dummy.[cm]time to populate the freshness data that it
> > gives to userspace, right?  Having set QUERIED, a write to the file
> > immediately afterwards will cause a (tiny) increase in ctime_nsec which
> > will cause the XFS_IOC_COMMIT_RANGE to reject the commit[2].  Right?
> >=20
>=20
> Yes. Once you call fill_mg_ctime, the first write after that point
> should cause the kernel to ensure that there is a distinct change in
> the ctime.
>=20
> IOW, I think this should alleviate the concerns I had before with using
> timestamps with the XFS_IOC_COMMIT_RANGE interface.
>=20
>=20

Oh, and to be clear, if you're _only_ worried about changes to the
contents of the file (and not the metadata), you should be able to do
this instead:

    fill_mg_ctime(&dummy, STATX_MTIME, inode);

...and that should avoid false positives from metadata-only changes.

Querying only the mtime still causes the QUERIED flag to be set, and
the kernel to give you distinct timestamps.

> > --D
> >=20
> > [1] https://lore.kernel.org/linux-xfs/20240227174649.GL6184@frogsfrogsf=
rogs/
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.gi=
t/commit/?h=3Datomic-file-commits&id=3D0520d89c2698874c1f56ddf52ec4b8a3595b=
aa14
> >=20
> > > +
> > >  	stat->blocks =3D XFS_FSB_TO_BB(mp, ip->i_nblocks + ip->i_delayed_bl=
ks);
> > > =20
> > >  	if (xfs_has_v3inodes(mp)) {
> > > @@ -603,11 +604,6 @@ xfs_vn_getattr(
> > >  		}
> > >  	}
> > > =20
> > > -	if ((request_mask & STATX_CHANGE_COOKIE) && IS_I_VERSION(inode)) {
> > > -		stat->change_cookie =3D inode_query_iversion(inode);
> > > -		stat->result_mask |=3D STATX_CHANGE_COOKIE;
> > > -	}
> > > -
> > >  	/*
> > >  	 * Note: If you add another clause to set an attribute flag, please
> > >  	 * update attributes_mask below.
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 27e9f749c4c7..210481b03fdb 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -2052,7 +2052,7 @@ static struct file_system_type xfs_fs_type =3D =
{
> > >  	.init_fs_context	=3D xfs_init_fs_context,
> > >  	.parameters		=3D xfs_fs_parameters,
> > >  	.kill_sb		=3D xfs_kill_sb,
> > > -	.fs_flags		=3D FS_REQUIRES_DEV | FS_ALLOW_IDMAP,
> > > +	.fs_flags		=3D FS_REQUIRES_DEV | FS_ALLOW_IDMAP | FS_MGTIME,
> > >  };
> > >  MODULE_ALIAS_FS("xfs");
> > > =20
> > >=20
> > > --=20
> > > 2.45.2
> > >=20
> > >=20
>=20

--=20
Jeff Layton <jlayton@kernel.org>

