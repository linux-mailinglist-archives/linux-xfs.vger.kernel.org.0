Return-Path: <linux-xfs+bounces-15224-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EEE59C22F4
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2024 18:30:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5B99B22FDB
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2024 17:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54701F4FB6;
	Fri,  8 Nov 2024 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8hLLCBf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7881DFD1;
	Fri,  8 Nov 2024 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731087007; cv=none; b=fT0p5zCDkJkCnnrQgRsjsLOS0UTD/anOmyv1ayqMYx+x70U8UE0gnUo/zo4afbMlVUS4G6gfnUo+hfoOxOH4y46Ra6ws7fi37veB6MT2EYqpin4BZg5GQuAkZRohQhD2Jh21LyQK3KXkM3yOlymYtVZO3b8awtM9Aeuvdo588s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731087007; c=relaxed/simple;
	bh=29DVLAh2HCtcArmnuxwpYrI5cfTUdqXRDhp9CcKrP+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts7tEV4zBZSJP+j8wHshdXH/+RhJHxM0iYLvOYcf42Go95hsorPre7QAUr0/XNj+Si3UJ/oxMBKfIKYi5wxKFOsOq6zv+G6dcoswwvSNU3X3t/+mpPbfIT1eiv8biiEFjl24A/mVhWxM73Y7TXaEtVCFGVmaXQtQ5kuqxYAk3KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8hLLCBf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1FDC4CECD;
	Fri,  8 Nov 2024 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731087006;
	bh=29DVLAh2HCtcArmnuxwpYrI5cfTUdqXRDhp9CcKrP+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j8hLLCBf8x6iuGLD5Z8eLntiO0L9tkSM8Ek1amA+tY/UUWKy7gYVe+u1bWnMCvUrz
	 w3k6cKEWgGMvWJO9lFeEfbxYYn5p8aP1VupU/aBRy5zu8yU4k4UKzNELMa7HvkIVMs
	 gvb/toW4F0aaAVeeP+vUX7v4urTAlTLLoglHttOz0tGy1mrsRN8kOLBBK0hvLqvgFS
	 NpeMmsqptwsPbmCwswzuB61M0KDfVC1j8d+vHFx24nHInBcYgbd3UbHRnYT9d5ljEV
	 Anl0oyQcQaNSSm0WhDAL+XjTuhFxdP0solLdkmAaivWOzWwEQMW/F3Fyt0ycL/8hBT
	 1VTjwKIOWcGYg==
Date: Fri, 8 Nov 2024 09:30:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH 1/2] xfs: Fix missing block calculations in xfs datadev
 fsmap
Message-ID: <20241108173006.GA168069@frogsfrogsfrogs>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
 <20240826031005.2493150-2-wozizhi@huawei.com>
 <20241107234352.GU2386201@frogsfrogsfrogs>
 <1549f04a-8431-405d-adfc-23e5988abe51@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1549f04a-8431-405d-adfc-23e5988abe51@huawei.com>

On Fri, Nov 08, 2024 at 10:29:08AM +0800, Zizhi Wo wrote:
> 
> 
> 在 2024/11/8 7:43, Darrick J. Wong 写道:
> > On Mon, Aug 26, 2024 at 11:10:04AM +0800, Zizhi Wo wrote:
> > > In xfs datadev fsmap query, I noticed a missing block calculation problem:
> > > [root@fedora ~]# xfs_db -r -c "sb 0" -c "p" /dev/vdb
> > > magicnum = 0x58465342
> > > blocksize = 4096
> > > dblocks = 5242880
> > > ......
> > > [root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
> > > ...
> > > 30: 253:16 [31457384..41943031]: free space            3  (104..10485751)    10485648
> > > 
> > > (41943031 + 1) / 8 = 5242879 != 5242880
> > > We missed one block in our fsmap calculation!
> > 
> > Eek.
> > 
> > > The root cause of the problem lies in __xfs_getfsmap_datadev(), where the
> > > calculation of "end_fsb" requires a classification discussion. If "end_fsb"
> > > is calculated based on "eofs", we need to add an extra sentinel node for
> > > subsequent length calculations. Otherwise, one block will be missed. If
> > > "end_fsb" is calculated based on "keys[1]", then there is no need to add an
> > > extra node. Because "keys[1]" itself is unreachable, it cancels out one of
> > > the additions. The diagram below illustrates this:
> > > 
> > > |0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|-----eofs
> > > |---------------|---------------------|
> > > a       n       b         n+1         c
> > > 
> > > Assume that eofs is 16, the start address of the previous query is block n,
> > > sector 0, and the length is 1, so the "info->next" is at point b, sector 8.
> > > In the last query, suppose the "rm_startblock" calculated based on
> > > "eofs - 1" is the last block n+1 at point b. All we get is the starting
> > > address of the block, not the end. Therefore, an additional sentinel node
> > > needs to be added to move it to point c. After that, subtracting one from
> > > the other will yield the remaining 1.
> > > 
> > > Although we can now calculate the exact last query using "info->end_daddr",
> > > we will still get an incorrect value if the device at this point is not the
> > > boundary device specified by "keys[1]", as "end_daddr" is still the initial
> > > value. Therefore, the eofs situation here needs to be corrected. The issue
> > > is resolved by adding a sentinel node.
> > 
> > Why don't we set end_daddr unconditionally, then?
> > 
> > Hmm, looking at the end_daddr usage in fsmap.c, I think it's wrong.  If
> > end_daddr is set at all, it's set either to the last sector for which
> > the user wants a mapping; or it's set to the last sector for the device.
> > But then look at how we use it:
> > 
> > 	if (info->last...)
> > 		frec->start_daddr = info->end_daddr;
> > 
> > 	...
> > 
> > 	/* "report the gap..."
> > 	if (frec->start_daddr > info->next_daddr) {
> > 		fmr.fmr_length = frec->start_daddr - info->next_daddr;
> > 	}
> > 
> > This is wrong -- we're using start_daddr to compute the distance from
> > the last mapping that we output up to the end of the range that we want.
> > The "end of the range" is modeled with a phony rmap record that starts
> > at the first fsblock after that range.
> > 
> 
> In the current code, we set "rec_daddr = end_daddr" only when
> (info->last && info->end_daddr != NULL), which should ensure that this
> is the last query?

Right.

> Because end_daddr is set to the last device, and
> info->last is set to the last query. Therefore, assigning it to
> start_daddr should not cause issues in the next query?

Right, the code currently sets end_daddr only for the last device, so
there won't be any issues with the next query.

That said, we reset the xfs_getfsmap_info state between each device, so
it's safe to set end_daddr for every device, not just the last time
through that loop.

> Did I misunderstand something? Or is it because the latest code
> constantly updates end_daddr, which is why this issue arises?

The 6.13 metadir/rtgroups patches didn't change when end_daddr gets set,
but my fixpatch *does* make it set end_daddr for all devices.  Will send
a patch + fstests update shortly to demonstrate. :)

> > IOWs, that assignment should have been
> > frec->start_daddr = info->end_daddr + 1.
> > 
> > Granted in August the codebase was less clear about the difference
> > between rec_daddr and rmap->rm_startblock.  For 6.13, hch cleaned all
> > that up -- rec_daddr is now called start_daddr and the fsmap code passes
> > rmap records with space numbers in units of daddrs via a new struct
> > xfs_fsmap_rec.  Unfortunately, that's all buried in the giant pile of
> > pull requests I sent a couple of days ago which hasn't shown up on
> > for-next yet.
> > 
> > https://lore.kernel.org/linux-xfs/173084396955.1871025.18156568347365549855.stgit@frogsfrogsfrogs/
> > 
> > So I think I know how to fix this against the 6.13 codebase, but I'm
> > going to take a slightly different approach than yours...
> > 
> > > Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
> > > Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> > > ---
> > >   fs/xfs/xfs_fsmap.c | 19 +++++++++++++++++--
> > >   1 file changed, 17 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > > index 85dbb46452ca..8a2dfe96dae7 100644
> > > --- a/fs/xfs/xfs_fsmap.c
> > > +++ b/fs/xfs/xfs_fsmap.c
> > > @@ -596,12 +596,27 @@ __xfs_getfsmap_datadev(
> > >   	xfs_agnumber_t			end_ag;
> > >   	uint64_t			eofs;
> > >   	int				error = 0;
> > > +	int				sentinel = 0;
> > >   	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> > >   	if (keys[0].fmr_physical >= eofs)
> > >   		return 0;
> > >   	start_fsb = XFS_DADDR_TO_FSB(mp, keys[0].fmr_physical);
> > > -	end_fsb = XFS_DADDR_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
> > > +	/*
> > > +	 * For the case of eofs, we need to add a sentinel node;
> > > +	 * otherwise, one block will be missed when calculating the length
> > > +	 * in the last query.
> > > +	 * For the case of key[1], there is no need to add a sentinel node
> > > +	 * because it already represents a value that cannot be reached.
> > > +	 * For the case where key[1] after shifting is within the same
> > > +	 * block as the starting address, it is resolved using end_daddr.
> > > +	 */
> > > +	if (keys[1].fmr_physical > eofs - 1) {
> > > +		sentinel = 1;
> > > +		end_fsb = XFS_DADDR_TO_FSB(mp, eofs - 1);
> > > +	} else {
> > > +		end_fsb = XFS_DADDR_TO_FSB(mp, keys[1].fmr_physical);
> > > +	}
> > 
> > ...because running against djwong-wtf, I actually see the same symptoms
> > for the realtime device.  So I think a better solution is to change
> > xfs_getfsmap to set end_daddr always, and then fix the off by one error.
> > 
> 
> Yes, my second patch looks at this rt problem...
> Thank you for your reply

<nod>

--D

> Thanks,
> Zizhi Wo
> 
> 
> > I also don't really like "sentinel" values because they're not
> > intuitive.
> > 
> > I will also go update xfs/273 to check that there are no gaps in the
> > mappings returned, and that they go to where the filesystem thinks is
> > the end of the device.  Thanks for reporting this, sorry I was too busy
> > trying to get metadir/rtgroups done to look at this until now. :(
> > 
> > --D
> > 
> 
> 
> 
> > >   	/*
> > >   	 * Convert the fsmap low/high keys to AG based keys.  Initialize
> > > @@ -649,7 +664,7 @@ __xfs_getfsmap_datadev(
> > >   		info->pag = pag;
> > >   		if (pag->pag_agno == end_ag) {
> > >   			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
> > > -					end_fsb);
> > > +					end_fsb) + sentinel;
> > >   			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
> > >   					keys[1].fmr_offset);
> > >   			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
> > > -- 
> > > 2.39.2
> > > 
> > > 
> 

