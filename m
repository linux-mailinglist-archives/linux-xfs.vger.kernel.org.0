Return-Path: <linux-xfs+bounces-26031-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AEBBA3ED5
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Sep 2025 15:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 424741C0404F
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Sep 2025 13:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC7CC148;
	Fri, 26 Sep 2025 13:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7L1RjO2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796C210E3
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 13:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758894324; cv=none; b=d4pjODXDH4pzZOn47QwHy2d4Gqhe4aFboHQb7u3t66xLKKMTVkORasIaLEtlljlFl2DljgUucSMO1TCDL3oOeGnAiLaP0etrzMKTmPsmfnFb0GgpJQ5VpI2tdIzGaabqNKfgqN2/58/zr2Kayzbnvm2T6beWsyT/wnda7i7OI5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758894324; c=relaxed/simple;
	bh=A3qaEJQkSuXsmXAYkB9oUz2Id5oqwrYjawxbp1qdRWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CViBRFBLSBKx+luNSB95da0FzdlOkGp/FXoN1OtXMoSv5+EVFMW0npaTMqDacrjWiEp30jnHVvkIs0bFxKcVZgMnEMCe7aPHz5QcWTTVk/7izPtAYN2XW4mlaWEB61+zxPUgmOIcFYnZD45bAjTOhhR+700ilr7c6Fg6X5tEEHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7L1RjO2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13863C4CEF4;
	Fri, 26 Sep 2025 13:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758894324;
	bh=A3qaEJQkSuXsmXAYkB9oUz2Id5oqwrYjawxbp1qdRWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X7L1RjO2x7EPQvgNNcbkSYkA6/Y6uIoymkIoc98gGVlDnyoaaf901+mo9WPqjTfRm
	 yL6QlxBox+2kG6gM+tJElHMKFpdYnqJWj5uwlaJskQ1UGO5DqEFeQf42p7zjZstOCZ
	 WNeBySR7FJ5trE4gmdPwL7fOFw2PN9UPYwXz9jLPZWStTRnPSF39Ic5T3j3wohHIJw
	 i6GB1Mlbtsrm/+IHdRBPfH3kolQT32BdX5oXMSdNlEyy6+jxbNEoaRfFXoCHHFsBZ5
	 RiK/hdjJ17Hsb4baFO/InYTtZ8QBliHhZuVn0m9DiD0KnInO6XvCo4Qxjg402Sp8K2
	 f5yotDrUA5Diw==
Date: Fri, 26 Sep 2025 15:45:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "hubert ." <hubjin657@outlook.com>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Message-ID: <ip6g2acleif3cyslm65uzdxd47dgzfum57xxgpmk73r4223poy@shhld7q7ls7i>
References: <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>
 <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
 <LV3PR05MB104071E0D6E7CAD06C7728DACFA26A@LV3PR05MB10407.namprd05.prod.outlook.com>
 <kZ0Ndjz5Uh9rHFbs-iYYoEFNVWoxMtkvK-3nrx6mrlxpglTxelNWuY_lqxKmfrItAPWl4M4ng-BzenCqcFiOaA==@protonmail.internalid>
 <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
 <IA0PR05MB9975ADAF48C73797473737BEFA38A@IA0PR05MB9975.namprd05.prod.outlook.com>
 <IA0PR05MB99755ED06F9965745B20D9DAFA1EA@IA0PR05MB9975.namprd05.prod.outlook.com>
 <7qd0IjCTUj1UpKLm2g6sPrhFI8HEoYrqIQ23o_ANTShTu58S7x7bgoMYTvXfR_fpqPdB85XxZoz16xrnllDcvA==@protonmail.internalid>
 <aNZfRuIVgIOiP6Qp@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNZfRuIVgIOiP6Qp@dread.disaster.area>

On Fri, Sep 26, 2025 at 07:39:18PM +1000, Dave Chinner wrote:
> On Fri, Sep 26, 2025 at 09:04:12AM +0000, hubert . wrote:
> > >> Regarding the xfs_metadump segfault, yes, a core might be useful to
> > >> investigate where the segfault is triggered, but you'll need to be
> > >> running xfsprogs from the upstream tree (preferentially latest code), so
> > >> we can actually match the core information the code.
> > >
> > > I figured it was not all the needed info, thanks for clarifying.
> > >
> > > Right now we had to put away the original hdds, as we cannot afford
> > > another failed drive and time is pressing, and are dd'ing the image to a
> > > real partition to try xfs_repair on it directly (takes days, of course,
> > > but we're lucky we got the storage).
> > > I will try the metadump and do further debugging if it segfaults again.
> >
> > So I'm back now with a real partition.
> > First, I ran "xfs_repair -vn" and it did complete, reporting - as expected - a
> > bunch of entries to junk, skipping the last phases with "Inode allocation
> > btrees are too corrupted, skipping phases 6 and 7".
> > It created a 270MB log, I can upload it somewhere if it could be of interest.
> 
> No need, but thanks for the offer.
> 
> > Core was generated by `/usr/sbin/xfs_db -i -p xfs_metadump -c metadump /dev/sda1'.
> > Program terminated with signal SIGSEGV, Segmentation fault.
> > #0  libxfs_bmbt_disk_get_all (rec=0x55c47aec3eb0, irec=<synthetic pointer>) at ../include/libxfs.h:226
> >
> > warning: 226	../include/libxfs.h: No such file or directory
> > (gdb) bt full
> > #0  libxfs_bmbt_disk_get_all (rec=0x55c47aec3eb0, irec=<synthetic pointer>) at ../include/libxfs.h:226
> >         l0 = <optimized out>
> >         l1 = <optimized out>
> >         l0 = <optimized out>
> >         l1 = <optimized out>
> 
> Ok, so it's faulted when trying to read a BMBT record from an
> in-memory buffer...
> 
> Remember the addr of the rec (0x55c47aec3eb0) now....
> 
> > #1  convert_extent (rp=0x55c47aec3eb0, op=<synthetic pointer>, sp=<synthetic pointer>, cp=<synthetic pointer>, fp=<synthetic pointer>) at /build/reproducible-path/xfsprogs-6.16.0/db/bmap.c:320
> >         irec = <optimized out>
> >         irec = <optimized out>
> > #2  process_bmbt_reclist (dip=dip@entry=0x55c37aec3e00, whichfork=whichfork@entry=0, rp=0x55c37aec3eb0, numrecs=numrecs@entry=268435457) at /build/reproducible-path/xfsprogs-6.16.0/db/metadump.c:2181
> 
> Smoking gun:
> 
> numrecs=numrecs@entry=268435457
> 
> 268435457 = 2^28 + 1
> 
> >         is_meta = false
> >         btype = <optimized out>
> >         i = <optimized out>
> >         o = <optimized out>
> >         op = <optimized out>
> >         s = <optimized out>
> >         c = <optimized out>
> >         cp = <optimized out>
> >         f = <optimized out>
> >         last = <optimized out>
> >         agno = <optimized out>
> >         agbno = <optimized out>
> >         rval = <optimized out>
> > #3  0x000055c36404e042 in process_exinode (dip=0x55c37aec3e00, whichfork=0) at /build/reproducible-path/xfsprogs-6.16.0/db/metadump.c:2421
> >         max_nex = <optimized out>
> >         nex = 268435457
> 
> Yup, that's the problem.
> 
> The inode is in extent format, which means the extent records are in
> the inode data fork area, which is about 300 bytes max for a 512
> byte inode. IOWs, it can hold about 12 BMBT records. The BMBT
> records are in the on-disk inode buffer, as is the disk inode @dip.
> 
> Look at the address of dip:  0x55c37aec3e00
> The address of the BMBT rec: 0x55c47aec3eb0
> 
> Now lok at what BMBT record convert_extent() is trying to access:
> 
> process_bmbt_reclist()
> {
> .....
> 	convert_extent(&rp[numrecs - 1], &o, &s, &c, &f);
> .....
> 
> Yeah, that inode buffer isn't 268 million bmbt recrods long....
> 
> So there must be a bounds checking bug in process_exinode():
> 
> static int
> process_exinode(
>         struct xfs_dinode       *dip,
>         int                     whichfork)
> {
>         xfs_extnum_t            max_nex = xfs_iext_max_nextents(
>                         xfs_dinode_has_large_extent_counts(dip), whichfork);
>         xfs_extnum_t            nex = xfs_dfork_nextents(dip, whichfork);
>         int                     used = nex * sizeof(struct xfs_bmbt_rec);
> 
>         if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
>                 if (metadump.show_warnings)
>                         print_warning("bad number of extents %llu in inode %lld",
>                                 (unsigned long long)nex,
>                                 (long long)metadump.cur_ino);
>                 return 1;
>         }
> 
> Can you spot it?
> 
> Hint: ((2^28 + 1) * 2^4) - 1 as an int is?

Perhaps the patch below will suffice?


diff --git a/db/metadump.c b/db/metadump.c
index 34f2d61700fe..1dd38ab84ade 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2395,7 +2395,7 @@ process_btinode(
 
 static int
 process_exinode(
-	struct xfs_dinode 	*dip,
+	struct xfs_dinode	*dip,
 	int			whichfork)
 {
 	xfs_extnum_t		max_nex = xfs_iext_max_nextents(
@@ -2403,7 +2403,13 @@ process_exinode(
 	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			used = nex * sizeof(struct xfs_bmbt_rec);
 
-	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
+	/*
+	 * We need to check for overflow of used counter.
+	 * If the inode extent count is corrupted, we risk having a
+	 * big enough number of extents to overflow it.
+	 */
+	if (used < nex || nex > max_nex ||
+	    used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (metadump.show_warnings)
 			print_warning("bad number of extents %llu in inode %lld",
 				(unsigned long long)nex,


