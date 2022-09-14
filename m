Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB1F5B8D26
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Sep 2022 18:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiINQck (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Sep 2022 12:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiINQb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2022 12:31:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1C184EE6
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 09:30:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA1DFB8172C
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 16:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65861C433C1;
        Wed, 14 Sep 2022 16:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663173051;
        bh=nDoEtahN4tKZsm0V31ArWRKiFXRi//uV6bal8lGr/nw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SeJ0s19wRoNKS/TRmTgsHGBBde9D0ezh66wdushd825nT4WAQx3fxXderpJz4/Bmb
         laQp5plNOAgqgdP3Mxi4CXWpPMXaNhYg4EejMtbf0/xyUkw8X9X0oO4kVKQGY3wiJ3
         zgZa5maotbhdAxMkRCy2RrYeRHxtdD94Os7esud7k43f+L2iDmKt06vHJFNpUbDlFB
         8kDfPUIDZvFMubp18rUSu0VyXBL7NTEVpmihgu8Vmgx/Eg3q+YTdANdp41iXeg4QMG
         BddZ6N/1G7AzAfhZxHpvbe400iMhi6PGB5D6YF614sqHH+A3d28P+miOrP9eiT2XX8
         F7Q0FK0FaqiBQ==
Date:   Wed, 14 Sep 2022 09:30:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Guo Xuenan <guoxuenan@huawei.com>, linux-xfs@vger.kernel.org,
        dchinner@redhat.com, chandan.babu@oracle.com, yi.zhang@huawei.com,
        houtao1@huawei.com, zhengbin13@huawei.com, jack.qiu@huawei.com
Subject: Re: [PATCH v2] xfs: fix uaf when leaf dir bestcount not match with
 dir data blocks
Message-ID: <YyIBugls6dI4xOUV@magnolia>
References: <20220831121639.3060527-1-guoxuenan@huawei.com>
 <20220912013154.GB3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912013154.GB3600936@dread.disaster.area>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 12, 2022 at 11:31:54AM +1000, Dave Chinner wrote:
> On Wed, Aug 31, 2022 at 08:16:39PM +0800, Guo Xuenan wrote:
> > For leaf dir, In most cases, there should be as many bestfree slots
> > as the dir data blocks that can fit under i_size (except for [1]).
> > 
> > Root cause is we don't examin the number bestfree slots, when the slots
> > number less than dir data blocks, if we need to allocate new dir data
> > block and update the bestfree array, we will use the dir block number as
> > index to assign bestfree array, while we did not check the leaf buf
> > boundary which may cause UAF or other memory access problem. This issue
> > can also triggered with test cases xfs/473 from fstests.
> > 
> > Considering the special case [1] , only add check bestfree array boundary,
> > to avoid UAF or slab-out-of bound.
> > 
> > [1] https://lore.kernel.org/all/163961697197.3129691.1911552605195534271.stgit@magnolia/
> > 
> > Simplify the testcase xfs/473 with commands below:
> > DEV=/dev/sdb
> > MP=/mnt/sdb
> > WORKDIR=/mnt/sdb/341 #1. mkfs create new xfs image
> > mkfs.xfs -f ${DEV}
> > mount ${DEV} ${MP}
> > mkdir -p ${WORKDIR}
> > for i in `seq 1 341` #2. create leaf dir with 341 entries file name len 8
> > do
> >     touch ${WORKDIR}/$(printf "%08d" ${i})
> > done
> > inode=$(ls -i ${MP} | cut -d' ' -f1)
> > umount ${MP}         #3. xfs_db set bestcount to 0
> > xfs_db -x ${DEV} -c "inode ${inode}" -c "dblock 8388608" \
> > -c "write ltail.bestcount 0"
> > mount ${DEV} ${MP}
> > touch ${WORKDIR}/{1..100}.txt #4. touch new file, reproduce
> .....
> > diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > index d9b66306a9a7..4b2a72b3a6f3 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > @@ -819,6 +819,18 @@ xfs_dir2_leaf_addname(
> >  		 */
> >  		else
> >  			xfs_dir3_leaf_log_bests(args, lbp, use_block, use_block);
> > +		/*
> > +		 * An abnormal corner case, bestfree count less than data
> > +		 * blocks, add a condition to avoid UAF or slab-out-of bound.
> > +		 */
> > +		if ((char *)(&bestsp[use_block]) > (char *)ltp) {

Aha, so this /can/ be detected by walking off the end of the buffer...

> > +			xfs_trans_brelse(tp, lbp);
> > +			if (tp->t_flags & XFS_TRANS_DIRTY)
> > +				xfs_force_shutdown(tp->t_mountp,
> > +						SHUTDOWN_CORRUPT_ONDISK);
> > +			return -EFSCORRUPTED;
> > +		}
> > +
> 
> As I explained here:
> 
> https://lore.kernel.org/linux-xfs/20220829081244.GT3600936@dread.disaster.area/
> 
> We don't check for overruns caused by on-disk format corruptions in
> every operation - we catch the corruption when the metadata is first
> read into memory via the verifier.
> 
> Please add a check for a corrupt/mismatched best sizes array to
> xfs_dir3_leaf_check_int() so that the corruption is detected on
> first read and the internal directory code is never exposed to such
> issues.

...in which case this should go in the buffer verifier.  Seconded.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
