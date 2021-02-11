Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1912D3192CC
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Feb 2021 20:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhBKTGb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Feb 2021 14:06:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230289AbhBKTFt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 14:05:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A30964E6B;
        Thu, 11 Feb 2021 19:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613070308;
        bh=dyGHZfhoGBG7K4wMYmhn8GEFOyhU8NVu+4VdynwPZtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rW4jEW99nFmvYALcz4l+eBthzcCekDu+MfgNiiu0C/nfzLNREdWoy1iQcfFkHThGL
         ikr8+9+nq1nS7PSfQMlhihHzPOyo0Psr7ywgbnejqcgCE9SVulE/Kr1ym+YPhPs3Fm
         GTxpNrX3PHLf38SUk1GbLoeoh6BK/UVATOb+nQUfN2Ex0yn7xrq64wYsjgadU76jpO
         F8PR5497EHlXw5OkqECx0/unl+EyUQNahMjjnb8NnpWzOyOzN3QZKTcjQkPA/4NWhS
         5sfaaa3PoD+SlhT9KooO8BRavJcJGVZCuCU3qdiUCurRg1MqHDpzA1MSxWnGX/xT7m
         y6PYgnSqVIekg==
Date:   Thu, 11 Feb 2021 11:05:07 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/6] common: capture metadump output if xfs filesystem
 check fails
Message-ID: <20210211190507.GF7193@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292579087.3504537.10519481439481869013.stgit@magnolia>
 <20210211135958.GB222065@bfoster>
 <20210211181234.GE7193@magnolia>
 <20210211183524.GH222065@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211183524.GH222065@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 11, 2021 at 01:35:24PM -0500, Brian Foster wrote:
> On Thu, Feb 11, 2021 at 10:12:34AM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 11, 2021 at 08:59:58AM -0500, Brian Foster wrote:
> > > On Tue, Feb 09, 2021 at 06:56:30PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@djwong.org>
> > > > 
> > > > Capture metadump output when various userspace repair and checker tools
> > > > fail or indicate corruption, to aid in debugging.  We don't bother to
> > > > annotate xfs_check because it's bitrotting.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  README     |    2 ++
> > > >  common/xfs |   26 ++++++++++++++++++++++++++
> > > >  2 files changed, 28 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/README b/README
> > > > index 43bb0cee..36f72088 100644
> > > > --- a/README
> > > > +++ b/README
> > > > @@ -109,6 +109,8 @@ Preparing system for tests:
> > > >               - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload
> > > >                 it between test invocations.  This assumes that the name of
> > > >                 the module is the same as FSTYP.
> > > > +	     - Set SNAPSHOT_CORRUPT_XFS=1 to record compressed metadumps of XFS
> > > > +	       filesystems if the various stages of _check_xfs_filesystem fail.
> > > >  
> > > >          - or add a case to the switch in common/config assigning
> > > >            these variables based on the hostname of your test
> > > > diff --git a/common/xfs b/common/xfs
> > > > index 2156749d..ad1eb6ee 100644
> > > > --- a/common/xfs
> > > > +++ b/common/xfs
> > > > @@ -432,6 +432,21 @@ _supports_xfs_scrub()
> > > >  	return 0
> > > >  }
> > > >  
> > > > +# Save a compressed snapshot of a corrupt xfs filesystem for later debugging.
> > > > +_snapshot_xfs() {
> > > 
> > > The term snapshot has a well known meaning. Can we just call this
> > > _metadump_xfs()?
> > 
> > Ok.
> > 
> > > 
> > > > +	local metadump="$1"
> > > > +	local device="$2"
> > > > +	local logdev="$3"
> > > > +	local options="-a -o"
> > > > +
> > > > +	if [ "$logdev" != "none" ]; then
> > > > +		options="$options -l $logdev"
> > > > +	fi
> > > > +
> > > > +	$XFS_METADUMP_PROG $options "$device" "$metadump" >> "$seqres.full" 2>&1
> > > > +	gzip -f "$metadump" >> "$seqres.full" 2>&1 &
> > > 
> > > Why compress in the background?
> > 
> > Sometimes the metadumps can become very large and I don't tend to have a
> > lot of space on the test appliances for storing blobs.
> > 
> > Also, I was under the impression that it was customary for people to
> > share compressed metadumps of crashes, so why not save everyone a step?
> > 
> > I do this in the background to avoid holding up the next fstest.
> > 
> > > I wonder if we should just skip the
> > > compression step since this requires an option to enable in the first
> > > place..
> > 
> > Seeing as it's optional, I think that's all the more reason to compress.
> > 
> 
> That's fair. It was more the background task that I was concerned about.
> If the issue is that the compression takes too long, ISTM there's a
> similar risk of the background compression conflicting with ongoing
> tests. E.g., we have various tests that scale out I/O threads to extreme
> levels and could delay the compression even longer (or vice versa), we
> have no way to prevent multiple background compression tasks from
> starting/competing as tests continue to run, etc.

<nod> Admittedly I chose gzip because it's decent in both the speed and
compression ratio traits; someone else might want xz --extreme.

> What about allowing the user to specify an optional env var in the
> config file to provide a compression command to use? If set, compress
> the file in the foreground. Then the user can determine whether
> compression is necessary at all, and if so, which compression tool might
> provide a suitable enough time/space tradeoff for the test environment
> (i.e., something like lz4 might be faster than gzip or bzip2 at the cost
> of space).

Good idea!  If the user sets SNAPSHOT_XFS_COMPRESSOR to the compressor
program of their choice (e.g. 'gzip -9') then we'll use that to compress
the metadump.

It also occurred to me that I could refactor _scratch_metadump to use
this new helper, so I think I'll implement some means for letting actual
tests disable compression unconditionally.

--D

> Brian
> 
> > > 
> > > > +}
> > > > +
> > > >  # run xfs_check and friends on a FS.
> > > >  _check_xfs_filesystem()
> > > >  {
> > > ...
> > > > @@ -540,6 +564,8 @@ _check_xfs_filesystem()
> > > >  			cat $tmp.repair				>>$seqres.full
> > > >  			echo "*** end xfs_repair output"	>>$seqres.full
> > > >  
> > > > +			test "$SNAPSHOT_CORRUPT_XFS" = "1" && \
> > > > +				_snapshot_xfs "$seqres.rebuildrepair.md" "$device" "$2"
> > > 
> > > Why do we collect so many metadump images? Shouldn't all but the last
> > > TEST_XFS_REPAIR_REBUILD thing not modify the fs? If so, it seems like we
> > > should be able to collect one image (and perhaps just call it
> > > "$seqres.$device.md") if any of the first several checks flag a problem.
> > 
> > Yes, the number of metadumps collected can be reduced to two.  One if
> > scrub or logprint or repair -n fail, and a second one if the user set
> > TEST_XFS_REPAIR_REBUILD=1 and either the repair or the repair -n fail.
> > 
> > Will change that.
> > 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > >  			ok=0
> > > >  		fi
> > > >  		rm -f $tmp.repair
> > > > 
> > > 
> > 
> 
