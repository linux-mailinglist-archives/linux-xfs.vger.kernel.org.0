Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1674E5A28
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Mar 2022 21:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245369AbiCWUua (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Mar 2022 16:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240768AbiCWUu3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 16:50:29 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C94638BE4
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 13:48:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 425E510E5104;
        Thu, 24 Mar 2022 07:48:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nX7ua-0092zC-UV; Thu, 24 Mar 2022 07:48:56 +1100
Date:   Thu, 24 Mar 2022 07:48:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: actually set aside enough space to handle a
 bmbt split
Message-ID: <20220323204856.GV1544202@dread.disaster.area>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779461835.550479.15316047141170352189.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164779461835.550479.15316047141170352189.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623b87ba
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Pitg15Sqe30maEZy9pkA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 20, 2022 at 09:43:38AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The comment for xfs_alloc_set_aside indicates that we want to set aside
> enough space to handle a bmap btree split.  The code, unfortunately,
> hardcodes this to 4.
> 
> This is incorrect, since file bmap btrees can be taller than that:
> 
> xfs_db> btheight bmapbt -n 4294967295 -b 512
> bmapbt: worst case per 512-byte block: 13 records (leaf) / 13 keyptrs (node)
> level 0: 4294967295 records, 330382100 blocks
> level 1: 330382100 records, 25414008 blocks
> level 2: 25414008 records, 1954924 blocks
> level 3: 1954924 records, 150379 blocks
> level 4: 150379 records, 11568 blocks
> level 5: 11568 records, 890 blocks
> level 6: 890 records, 69 blocks
> level 7: 69 records, 6 blocks
> level 8: 6 records, 1 block
> 9 levels, 357913945 blocks total
> 
> Or, for V5 filesystems:
> 
> xfs_db> btheight bmapbt -n 4294967295 -b 1024
> bmapbt: worst case per 1024-byte block: 29 records (leaf) / 29 keyptrs (node)
> level 0: 4294967295 records, 148102321 blocks
> level 1: 148102321 records, 5106977 blocks
> level 2: 5106977 records, 176103 blocks
> level 3: 176103 records, 6073 blocks
> level 4: 6073 records, 210 blocks
> level 5: 210 records, 8 blocks
> level 6: 8 records, 1 block
> 7 levels, 153391693 blocks total
> 
> Fix this by using the actual bmap btree maxlevel value for the
> set-aside.  We subtract one because the root is always in the inode and
> hence never splits.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |    7 +++++--
>  fs/xfs/libxfs/xfs_sb.c    |    2 --
>  fs/xfs/xfs_mount.c        |    7 +++++++
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b0678e96ce61..747b3e45303f 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -107,13 +107,16 @@ xfs_prealloc_blocks(
>   * aside a few blocks which will not be reserved in delayed allocation.
>   *
>   * For each AG, we need to reserve enough blocks to replenish a totally empty
> - * AGFL and 4 more to handle a potential split of the file's bmap btree.
> + * AGFL and enough to handle a potential split of a file's bmap btree.
>   */
>  unsigned int
>  xfs_alloc_set_aside(
>  	struct xfs_mount	*mp)
>  {
> -	return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + 4);
> +	unsigned int		bmbt_splits;
> +
> +	bmbt_splits = max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]) - 1;
> +	return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + bmbt_splits);
>  }

So right now I'm trying to understand why this global space set
aside ever needed to take into account the space used by a single
BMBT split. ISTR it was done back in 2006 because the ag selection
code, alloc args and/or xfs_alloc_space_available() didn't take into
account the BMBT space via args->minleft correctly to ensure that
the AGF we select had enough space in it for both the data extent
and the followup BMBT split. Hence the original SET ASIDE (which
wasn't per AG) was just 8 blocks - 4 for the AGFL, 4 for the BMBT.

The transaction reservation takes into account the space needed by
BMBT splits so we don't over-commit global space on user allocation
anymore, args->minleft takes it into account so we don't overcommit
AG space on extent allocation, and we have the reserved block pool
to handle situations were delalloc extents are fragmented more than
the initial indirect block reservation that is taken with the
delalloc extent reservation.

So where/why is this needed anymore?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
