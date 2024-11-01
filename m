Return-Path: <linux-xfs+bounces-14929-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 824949B89FA
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Nov 2024 04:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 294842830BA
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Nov 2024 03:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A7413FD83;
	Fri,  1 Nov 2024 03:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esi/ot+O"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C25F3FF1;
	Fri,  1 Nov 2024 03:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730432011; cv=none; b=EkdvD4IgFuEDtgdrz9IJCoKn3tuOkq2aGGdXc+C8X/dzFD5osnvDzbREYUotF+qDMSAINMZDtD00vm2b+U5ZXiUt9EYjbejYheo70eMMXO9IVGuXqc9b0r2ZsHitzVlIm1glcYLOw6IagDSWspvTvmZ4kWak0G5bR2kbzKlaHHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730432011; c=relaxed/simple;
	bh=neyokfw9ReJ8nD29TZJGBTmHGKCql/FyKj6TpaBD6Mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzUQdlNKcnkVmuFIBfbnb+mOecVfBit8eUBGjFFbbcWD5yxrt2WojBqbNYKLhKbXVCjfFQABzYzdyeWDymBAdhCTROfKssUqUF2ZJpLfTw1CM4i3RbwexBKXkDx8obEZGexSVKphAMYd/tUv8ZB3HLlQhFtpvp/F4mzgWVMFzoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esi/ot+O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC186C4CECD;
	Fri,  1 Nov 2024 03:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730432010;
	bh=neyokfw9ReJ8nD29TZJGBTmHGKCql/FyKj6TpaBD6Mg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=esi/ot+OiPBktTYiERfpmQ6AtgsP8TlK121d0b8148srjp+oUfyPrOMH/ErdiGchV
	 eqv20JV4zDpEExgdBvP4hgtWSf724eeDJ3lWIt1mXiTk+F+Lgb/1T3YBRrTv7kYk6G
	 3Yu4yrM7njMtat3JBuZLgQ9cizPRZSwpH9MG/SwnatBZ3fbclPGPydi4sBl+Nq3wd/
	 dg2C9kYSjJOKuvFhYsJrqtO8Eo9e9PC0UhbLOpm12fIRtJoXzwq101jxI/3teqOCXY
	 FXNyusYhOLeqp6asaaouDyWwEkrX2ZGcGcm5aBKYe+JwSMz3ZhZk3JB7Reaz5m5pJA
	 mUWKNa7Zun9jw==
Date: Thu, 31 Oct 2024 20:33:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: John Garry <john.g.garry@oracle.com>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] ext4: Add statx support for atomic writes
Message-ID: <20241101033330.GE2386201@frogsfrogsfrogs>
References: <cover.1730286164.git.ritesh.list@gmail.com>
 <3338514d98370498d49ebc297a9b6d48a55282b8.1730286164.git.ritesh.list@gmail.com>
 <20241031214204.GC21832@frogsfrogsfrogs>
 <875xp7znw4.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875xp7znw4.fsf@gmail.com>

On Fri, Nov 01, 2024 at 08:00:35AM +0530, Ritesh Harjani wrote:
> 
> Hi John & Darrick,
> 
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
> > On Wed, Oct 30, 2024 at 09:27:38PM +0530, Ritesh Harjani (IBM) wrote:
> >> This patch adds base support for atomic writes via statx getattr.
> >> On bs < ps systems, we can create FS with say bs of 16k. That means
> >> both atomic write min and max unit can be set to 16k for supporting
> >> atomic writes.
> >> 
> >> Co-developed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> >> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> >> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> >> ---
> >>  fs/ext4/ext4.h  |  9 +++++++++
> >>  fs/ext4/inode.c | 14 ++++++++++++++
> >>  fs/ext4/super.c | 31 +++++++++++++++++++++++++++++++
> >>  3 files changed, 54 insertions(+)
> >> 
> >> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> >> index 44b0d418143c..6ee49aaacd2b 100644
> >> --- a/fs/ext4/ext4.h
> >> +++ b/fs/ext4/ext4.h
> >> @@ -1729,6 +1729,10 @@ struct ext4_sb_info {
> >>  	 */
> >>  	struct work_struct s_sb_upd_work;
> >>  
> >> +	/* Atomic write unit values in bytes */
> >> +	unsigned int s_awu_min;
> >> +	unsigned int s_awu_max;
> >> +
> >>  	/* Ext4 fast commit sub transaction ID */
> >>  	atomic_t s_fc_subtid;
> >>  
> >> @@ -3855,6 +3859,11 @@ static inline int ext4_buffer_uptodate(struct buffer_head *bh)
> >>  	return buffer_uptodate(bh);
> >>  }
> >>  
> >> +static inline bool ext4_can_atomic_write(struct super_block *sb)
> >> +{
> >> +	return EXT4_SB(sb)->s_awu_min > 0;
> >
> > Huh, I was expecting you to stick to passing in the struct inode,
> > and then you end up with:
> >
> > static inline bool ext4_can_atomic_write(struct inode *inode)
> > {
> > 	return S_ISREG(inode->i_mode) &&
> > 	       EXT4_SB(inode->i_sb)->s_awu_min > 0);
> > }
> >
> 
> Ok. John also had commented on the same thing before. 
> We may only need this, when ext4 get extsize hint support. But for now
> we mainly only need to check that EXT4 SB supports atomic write or not.
> i.e. s_awu_min should be greater than 0. 
> 
> But sure I can make above suggested change to keep it consistent with XFS, along
> with below discussed change (Please have a look)...
> 
> >> +}
> >> +
> >>  extern int ext4_block_write_begin(handle_t *handle, struct folio *folio,
> >>  				  loff_t pos, unsigned len,
> >>  				  get_block_t *get_block);
> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >> index 54bdd4884fe6..fcdee27b9aa2 100644
> >> --- a/fs/ext4/inode.c
> >> +++ b/fs/ext4/inode.c
> >> @@ -5578,6 +5578,20 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
> >>  		}
> >>  	}
> >>  
> >> +	if (S_ISREG(inode->i_mode) && (request_mask & STATX_WRITE_ATOMIC)) {
> >
> > ...and then the callsites become:
> >
> > 	if (request_mask & STATX_WRITE_ATOMIC) {
> > 		unsigned int awu_min = 0, awu_max = 0;
> >
> > 		if (ext4_can_atomic_write(inode)) {
> > 			awu_min = sbi->s_awu_min;
> > 			awu_max = sbi->s_awu_max;
> > 		}
> >
> > 		generic_fill_statx_atomic_writes(stat, awu_min, awu_max);
> > 	}
> >
> > (I forget, is it bad if statx to a directory returns STATX_WRITE_ATOMIC
> > even with awu_{min,max} set to zero?)
> 
> I mainly kept it consistent with XFS. But it's not a bad idea to do that. 
> That will help applications check for atomic write support on the root
> directory mount point rather than creating a regular file just for
> verification. Because of below result_mask, which we only set within generic_fill_statx_atomic_writes() 
> 
> 	stat->result_mask |= STATX_WRITE_ATOMIC;
> 
> If we make this change to ext4, XFS will have to fix it too, to keep
> the behavior consistent for both.
> Shall I go ahead and make the change in v4 for EXT4?

Hmmm, that's a good question -- if a program asks for STATX_WRITE_ATOMIC
on a directory, should we set the ATOMIC flag in statx.stx_mask but
leave the values as zeroes if the underlying block device/fs supports
atomic writes at all?  For XFS I guess the "underlying bdev" is
determined by the directory's RTINHERIT bit && xfs_has_realtime().

Thoughts?

But maybe that doesn't make sense since (a) fundamentally you can't do a
directio write to a directory and (b) it's not that hard to create a
file, set the REALTIME bit on it as desired (on xfs) and then query the
untorn write geometry.  So maybe that check should be:

if (request_mask & STATX_WRITE_ATOMIC && S_ISREG(inode->i_mode))

--D

> -ritesh
> 
> >
> > Other than that nit, this looks good to me.
> >
> > --D
> >
> >> +		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> >> +		unsigned int awu_min, awu_max;
> >> +
> >> +		if (ext4_can_atomic_write(inode->i_sb)) {
> >> +			awu_min = sbi->s_awu_min;
> >> +			awu_max = sbi->s_awu_max;
> >> +		} else {
> >> +			awu_min = awu_max = 0;
> >> +		}
> >> +
> >> +		generic_fill_statx_atomic_writes(stat, awu_min, awu_max);
> >> +	}
> >> +
> >>  	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
> >>  	if (flags & EXT4_APPEND_FL)
> >>  		stat->attributes |= STATX_ATTR_APPEND;
> >> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >> index 16a4ce704460..ebe1660bd840 100644
> >> --- a/fs/ext4/super.c
> >> +++ b/fs/ext4/super.c
> >> @@ -4425,6 +4425,36 @@ static int ext4_handle_clustersize(struct super_block *sb)
> >>  	return 0;
> >>  }
> >>  
> >> +/*
> >> + * ext4_atomic_write_init: Initializes filesystem min & max atomic write units.
> >> + * @sb: super block
> >> + * TODO: Later add support for bigalloc
> >> + */
> >> +static void ext4_atomic_write_init(struct super_block *sb)
> >> +{
> >> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> >> +	struct block_device *bdev = sb->s_bdev;
> >> +
> >> +	if (!bdev_can_atomic_write(bdev))
> >> +		return;
> >> +
> >> +	if (!ext4_has_feature_extents(sb))
> >> +		return;
> >> +
> >> +	sbi->s_awu_min = max(sb->s_blocksize,
> >> +			      bdev_atomic_write_unit_min_bytes(bdev));
> >> +	sbi->s_awu_max = min(sb->s_blocksize,
> >> +			      bdev_atomic_write_unit_max_bytes(bdev));
> >> +	if (sbi->s_awu_min && sbi->s_awu_max &&
> >> +	    sbi->s_awu_min <= sbi->s_awu_max) {
> >> +		ext4_msg(sb, KERN_NOTICE, "Supports (experimental) DIO atomic writes awu_min: %u, awu_max: %u",
> >> +			 sbi->s_awu_min, sbi->s_awu_max);
> >> +	} else {
> >> +		sbi->s_awu_min = 0;
> >> +		sbi->s_awu_max = 0;
> >> +	}
> >> +}
> >> +
> >>  static void ext4_fast_commit_init(struct super_block *sb)
> >>  {
> >>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> >> @@ -5336,6 +5366,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
> >>  
> >>  	spin_lock_init(&sbi->s_bdev_wb_lock);
> >>  
> >> +	ext4_atomic_write_init(sb);
> >>  	ext4_fast_commit_init(sb);
> >>  
> >>  	sb->s_root = NULL;
> >> -- 
> >> 2.46.0
> >> 
> >> 
> 

