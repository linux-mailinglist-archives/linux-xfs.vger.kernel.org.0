Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C213811D6
	for <lists+linux-xfs@lfdr.de>; Fri, 14 May 2021 22:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhENUcI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 May 2021 16:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhENUcI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 May 2021 16:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6935061263;
        Fri, 14 May 2021 20:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621024256;
        bh=RCcGvoCGT/DTaRZL8J5aQybMvghviD3IaozNeZZ6tXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uH1/0pV5+GH5J/c3oAPF88uxd0Be0M60htIaTVLI7JMI9BkQKTZdc6j83M7dllsPa
         18RZmNUs7A1y6qUWy5BvDnXdq1AUElz75cpdaG3wLtxxMCknlBe9yFjJjbdWrxvx6X
         +W3UmNqTcUyZbeZ3ER/Mo5TD3Ia3Df7Va2PkZ1q7UZIJLFGSA1X6AGNsLiCvGVoJfE
         uE70pRjWRsLAV35MPrnqpZjhFKIY/I1CUTFhYcHBTlCwDx9gUJ1u2Xf0Jm6hv4MuJW
         q/vb2bDNlcZPnpP5jl4XIbLhepWfoCh8GIyCtgzM4dgnFzM7qyMoxxX9l6T1YygC7q
         HSG2IK6njBk2Q==
Date:   Fri, 14 May 2021 13:30:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: validate extsz hints against rt extent size
 when rtinherit is set
Message-ID: <20210514203055.GO9675@magnolia>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
 <162086771885.3685783.16422648250546171771.stgit@magnolia>
 <YJ5vS+o3BydK1DrP@bfoster>
 <20210514182253.GN9675@magnolia>
 <YJ7GxqPURmuPiIbE@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ7GxqPURmuPiIbE@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 14, 2021 at 02:51:50PM -0400, Brian Foster wrote:
> On Fri, May 14, 2021 at 11:22:53AM -0700, Darrick J. Wong wrote:
> > On Fri, May 14, 2021 at 08:38:35AM -0400, Brian Foster wrote:
> > > On Wed, May 12, 2021 at 06:01:58PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > The RTINHERIT bit can be set on a directory so that newly created
> > > > regular files will have the REALTIME bit set to store their data on the
> > > > realtime volume.  If an extent size hint (and EXTSZINHERIT) are set on
> > > > the directory, the hint will also be copied into the new file.
> > > > 
> > > > As pointed out in previous patches, for realtime files we require the
> > > > extent size hint be an integer multiple of the realtime extent, but we
> > > > don't perform the same validation on a directory with both RTINHERIT and
> > > > EXTSZINHERIT set, even though the only use-case of that combination is
> > > > to propagate extent size hints into new realtime files.  This leads to
> > > > inode corruption errors when the bad values are propagated.
> > > > 
> > > > Strengthen the validation routine to avoid this situation and fix the
> > > > open-coded unit conversion while we're at it.  Note that this is
> > > > technically a breaking change to the ondisk format, but the risk should
> > > > be minimal because (a) most vendors disable realtime, (b) letting
> > > > unaligned hints propagate to new files would immediately crash the
> > > > filesystem, and (c) xfs_repair flags such filesystems as corrupt, so
> > > > anyone with such a configuration is broken already anyway.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > 
> > > Ok, so this looks more like a proper fix, but does this turn an existing
> > > directory with (rtinherit && extszinherit) and a badly aligned extsz
> > > hint into a read validation error?
> > 
> > Hmm, you're right.  This fix needs to be more targeted in its nature.
> > For non-rt filesystems, the rtinherit bit being set on a directory is
> > benign because we won't set the realtime bit on new files, so there's no
> > need to introduce a new verifier error that will fail existing
> > filesystems.
> > 
> > We /do/ need to trap the misconfiguration for filesystems with an rt
> > volume because those filesystems will fail if the propagation happens.
> > 
> > I think the solution here is to change the verifier check here to
> > prevent the spread of bad extent size hints:
> > 
> > 	if (rt_flag || (xfs_sb_version_hasrealtime(&mp->m_sb) &&
> > 			rtinherit_flag && inherit_flag))
> > 		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> > 	else
> > 		blocksize_bytes = mp->m_sb.sb_blocksize;
> > 
> > ...and add a check to xfs_ioctl_setattr_check_extsize to prevent
> > sysadmins from misconfiguring directories in the first place.
> > 
> 
> It definitely makes sense to prevent this misconfiguration going
> forward, but I'm a little confused on the intended behavior for
> filesystems where this is already present (and not benign). ISTM the
> previous patch is intended to allow the filesystem to continue running
> with the added behavior that we restrict further propagation of
> preexisting misconfigured extent size hints, but would this patch
> trigger a verifier failure on read of such a misconfigured directory
> inode..?

Yeah, it would.  In the longer term I think we'd want to make it a part
of the verifier if whatever's the next new new inode-related feature is
set.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > >  fs/xfs/libxfs/xfs_inode_buf.c |    7 ++++---
> > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > > > index 5c9a7440d9e4..25261dd73290 100644
> > > > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > > > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > > > @@ -569,19 +569,20 @@ xfs_inode_validate_extsize(
> > > >  	uint16_t			mode,
> > > >  	uint16_t			flags)
> > > >  {
> > > > -	bool				rt_flag;
> > > > +	bool				rt_flag, rtinherit_flag;
> > > >  	bool				hint_flag;
> > > >  	bool				inherit_flag;
> > > >  	uint32_t			extsize_bytes;
> > > >  	uint32_t			blocksize_bytes;
> > > >  
> > > >  	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> > > > +	rtinherit_flag = (flags & XFS_DIFLAG_RTINHERIT);
> > > >  	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
> > > >  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
> > > >  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
> > > >  
> > > > -	if (rt_flag)
> > > > -		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> > > > +	if (rt_flag || (rtinherit_flag && inherit_flag))
> > > > +		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> > > >  	else
> > > >  		blocksize_bytes = mp->m_sb.sb_blocksize;
> > > >  
> > > > 
> > > 
> > 
> 
