Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F52662B5C
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 00:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732782AbfGHWQU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Jul 2019 18:16:20 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60722 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732609AbfGHWQU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 18:16:20 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 3230B3DC6BC;
        Tue,  9 Jul 2019 08:16:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hkbue-0007DR-ML; Tue, 09 Jul 2019 08:15:08 +1000
Date:   Tue, 9 Jul 2019 08:15:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/24] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190708221508.GJ7689@dread.disaster.area>
References: <20190605191511.32695-1-hch@lst.de>
 <20190605191511.32695-20-hch@lst.de>
 <20190708073740.GI7689@dread.disaster.area>
 <20190708161919.GN1404256@magnolia>
 <20190708213423.GA18177@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708213423.GA18177@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=7-415B0cAAAA:8 a=QoYP325K56WoTT4Oj5MA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 08, 2019 at 11:34:23PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 08, 2019 at 09:19:19AM -0700, Darrick J. Wong wrote:
> > So I think the solution is that we have to call submit_bio_wait on that
> > very first bio (bio0) since the bios created in the inner loop will be
> > chained to it... ?  Thoughts/flames/"go finish your morning coffee"?
> 
> I think we could also just turn the direction of the chaining around,
> then the newly allocated bio is the "parent" to the previous one and
> we can simply wait for the last one.  Something like the patch below,
> running it through xfstests now, and then after that I'll add a way
> to inject chaining even into relatively small I/Os to actually
> test this code path:
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index 757c1d9293eb..e2148f2d5d6b 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -43,7 +43,7 @@ xfs_rw_bdev(
>  			bio_copy_dev(bio, prev);
>  			bio->bi_iter.bi_sector = bio_end_sector(prev);
>  			bio->bi_opf = prev->bi_opf;
> -			bio_chain(bio, prev);
> +			bio_chain(prev, bio);

That fixes the problem I saw, but I think bio_chain() needs some
more checks to prevent this happening in future. It's trivially
easy to chain the bios in the wrong order, very difficult to spot
in review, and difficult to trigger in testing as it requires
chain nesting and adverse IO timing to expose....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
