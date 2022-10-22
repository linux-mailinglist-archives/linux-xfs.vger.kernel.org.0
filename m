Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A360838C
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Oct 2022 04:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJVCOf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Oct 2022 22:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJVCOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 22:14:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73137641D
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 19:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EFF8B82DB7
        for <linux-xfs@vger.kernel.org>; Sat, 22 Oct 2022 02:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39E8C43470;
        Sat, 22 Oct 2022 02:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666404868;
        bh=SeaeuDi4ZhcE0c0ZJ+O2OkqnztW5RalqZaLpyqovoAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MQQDeT/Srifn3fRGH8TINYN/92yGAorBS5iP68pBdhdMzW5fOHJZxJrKztQuShNpl
         S1UbNQYnSbOFL0NaCG3uVi212RlM3vYYM8rvMjupglsLxXVJowHpDY469kwUPz3wNN
         UGFhnJB20JwTew2yxtXstgI1rVcG5FvktWMMqdUdhLIT7l3qlJuCoOfquSIPDs8mMe
         VxMuEyySKJsxabbQA2NatZ0PCAZkGow5sdqFau/0lFhW6f9n/L1L7wpj0HsFTNoPxN
         Gj5Cwid0F2BufX/acS9r6caW+Nc+gNtgq8+QhG/YahQ7mB2oay485RKHSlbNQrlg3U
         C6/DOgFQAdjTg==
Date:   Fri, 21 Oct 2022 19:14:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v1] xfs: fix sb write verify for lazysbcount
Message-ID: <Y1NSBMwgUYxhW4PE@magnolia>
References: <20221022020345.GA2699923@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221022020345.GA2699923@ceph-admin>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 22, 2022 at 10:03:45AM +0800, Long Li wrote:
> When lazysbcount is enabled, multiple threads stress test the xfs report
> the following problems:
> 
> XFS (loop0): SB summary counter sanity check failed
> XFS (loop0): Metadata corruption detected at xfs_sb_write_verify
> 	     +0x13b/0x460, xfs_sb block 0x0
> XFS (loop0): Unmount and run xfs_repair
> XFS (loop0): First 128 bytes of corrupted metadata buffer:
> 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 28 00 00  XFSB.........(..
> 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000020: 69 fb 7c cd 5f dc 44 af 85 74 e0 cc d4 e3 34 5a  i.|._.D..t....4Z
> 00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
> 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> 00000050: 00 00 00 01 00 0a 00 00 00 00 00 04 00 00 00 00  ................
> 00000060: 00 00 0a 00 b4 b5 02 00 02 00 00 08 00 00 00 00  ................
> 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
> XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply
> 	+0xe1e/0x10e0 (fs/xfs/xfs_buf.c:1580).  Shutting down filesystem.
> XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> XFS (loop0): log mount/recovery failed: error -117
> XFS (loop0): log mount failed
> 
> The cause of the problem is that during the log recovery process, incorrect
> icount and ifree are recovered from the log and fail to pass the size check

Are you saying that the log contained a transaction in which ifree >
icount?

> in xfs_validate_sb_write().
> 
> With lazysbcount is enabled, There is no additional lock protection for
> reading m_ifree and m_icount in xfs_log_sb(), if other threads modifies
> the m_ifree between the read m_icount and the m_ifree, this will make the
> m_ifree larger than m_icount and written to the log. If we have an unclean
> shutdown, this will be corrected by xfs_initialize_perag_data() rebuilding
> the counters from the AGF block counts, and the correction is later than
> log recovery. During log recovery, incorrect ifree/icount may be restored
> from the log and written to the super block, since ifree and icount have
> not been corrected at this time, the relationship between ifree and icount
> cannot be checked in xfs_validate_sb_write().
> 
> So, don't check the size between ifree and icount in xfs_validate_sb_write()
> when lazysbcount is enabled.

Um, doesn't that neuter a sanity check on all V5 filesystems?

--D

> Fixes: 8756a5af1819 ("libxfs: add more bounds checking to sb sanity checks")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index a20cade590e9..b4a4e57361e7 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -245,7 +245,7 @@ xfs_validate_sb_write(
>  	if (xfs_buf_daddr(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
>  	    (sbp->sb_fdblocks > sbp->sb_dblocks ||
>  	     !xfs_verify_icount(mp, sbp->sb_icount) ||
> -	     sbp->sb_ifree > sbp->sb_icount)) {
> +	     (!xfs_has_lazysbcount(mp) && sbp->sb_ifree > sbp->sb_icount))) {
>  		xfs_warn(mp, "SB summary counter sanity check failed");
>  		return -EFSCORRUPTED;
>  	}
> -- 
> 2.31.1
> 
