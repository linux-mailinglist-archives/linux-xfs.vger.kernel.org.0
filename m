Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36B858E4F6
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Aug 2022 04:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiHJCvC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Aug 2022 22:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiHJCuz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 22:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D015558E6
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 19:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A680561224
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 02:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C26C433C1;
        Wed, 10 Aug 2022 02:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660099854;
        bh=e6N3fiyJBlQJWMRre8BmpDQj1yRd/5ZSXbJIVVHgQgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bHmJGK7yh369t67rBDapH54l5TjGqh+7C58sC6B/10hKBK3HG7/mIdS6YUpRBCbJx
         oAA3KVKrd4OgJucQI/NgwFok+QC3RKJT5aG6zrU6X36JqK+wYqq6tMSfCuwVUeC6il
         mEYuW99e8FAAqoxcFztG8HS0qgbXI56+4MBWkdL0uw61ur2Tj/PuZlRoYLRw7L44Wx
         e6BbMrOp1ufjXfRyT0Qt9u1PnJ4w/YslEHQqU9WJldntgdSQksOhUnTRyafPcs5jUg
         LginLXqH+pbVD2E5v15z/qNu9pnmTjP5F37KGFw0Nhul8GGFNq8fyNSPP3D7PMK7Zh
         z7MRhoN1O8UyA==
Date:   Tue, 9 Aug 2022 19:50:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     =?utf-8?B?5L2V5bCP5LmQ?= <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, hexiaole <hexiaole@kylinos.cn>
Subject: Re: Re: [PATCH v1] libxfs: fix inode reservation space for removing
 transaction
Message-ID: <YvMdDVpkwkZUufY2@magnolia>
References: <20220802031806.236-1-hexiaole1994@126.com>
 <YvLHHESN9UDqCJ/a@magnolia>
 <3d62cb5d.a53.1828570fa65.Coremail.hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d62cb5d.a53.1828570fa65.Coremail.hexiaole1994@126.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 09:49:10AM +0800, 何小乐 wrote:
> Thank you for review, Darrick.
> Yes, this problem(reserve 1 inode size rather than 2) exists in both
> the userspace utility 'xfsprogs' and kernel source 'xfs-linux'. 
> 
> The reason that sent patch against 'xfsprogs' only is that I'm not
> sure whether the patch is correct(whether there need reserve one more
> inode size for the removed inode or not) and hope the maintainers

Yep -- we do need to have enough space to log the parent directory inode
as well as the child that's being removed from the directory.

> helping to review for its correctness, if it's correct, I'm willing to
> send another patch against kernel source 'xfs-linux.
> 
> So, Darric, you said 'The logic looks correct.' means the patch is
> correct, rather than the original logic that reserving 1 inode size
> for removing transaction is correct, right? Hopelly I did not
> misunderstand.

Yes, the patch looks correct to me.  Please send us the kernel version,
so that we can land it in the kernel (and then xfsprogs). :)

--D

> 
> 
> 
> 
> 
> 
> 
> At 2022-08-10 04:44:12, "Darrick J. Wong" <djwong@kernel.org> wrote:
> >On Tue, Aug 02, 2022 at 11:18:06AM +0800, Xiaole He wrote:
> >> From: hexiaole <hexiaole@kylinos.cn>
> >> 
> >> In 'libxfs/xfs_trans_resv.c', the comment for transaction of removing a
> >> directory entry writes:
> >> 
> >> /* libxfs/xfs_trans_resv.c begin */
> >> /*
> >>  * For removing a directory entry we can modify:
> >>  *    the parent directory inode: inode size
> >>  *    the removed inode: inode size
> >> ...
> >> /* libxfs/xfs_trans_resv.c end */
> >> 
> >> There has 2 inode size of space to be reserverd, but the actual code
> >> for inode reservation space writes:
> >> 
> >> /* libxfs/xfs_trans_resv.c begin */
> >> /*
> >>  * For removing a directory entry we can modify:
> >>  *    the parent directory inode: inode size
> >>  *    the removed inode: inode size
> >> ...
> >> xfs_calc_remove_reservation(
> >>         struct xfs_mount        *mp)
> >> {
> >>         return XFS_DQUOT_LOGRES(mp) +
> >>                 xfs_calc_iunlink_add_reservation(mp) +
> >>                 max((xfs_calc_inode_res(mp, 1) +
> >> ...
> >> /* libxfs/xfs_trans_resv.c end */
> >> 
> >> There only count for 1 inode size to be reserved in
> >> 'xfs_calc_inode_res(mp, 1)', rather than 2.
> >
> >The logic looks correct.  Why is this patch against xfsprogs, though?
> >
> >--D
> >
> >> Signed-off-by: hexiaole <hexiaole@kylinos.cn>
> >> ---
> >>  libxfs/xfs_trans_resv.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
> >> index d4a9f69e..797176d7 100644
> >> --- a/libxfs/xfs_trans_resv.c
> >> +++ b/libxfs/xfs_trans_resv.c
> >> @@ -514,7 +514,7 @@ xfs_calc_remove_reservation(
> >>  {
> >>  	return XFS_DQUOT_LOGRES(mp) +
> >>  		xfs_calc_iunlink_add_reservation(mp) +
> >> -		max((xfs_calc_inode_res(mp, 1) +
> >> +		max((xfs_calc_inode_res(mp, 2) +
> >>  		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
> >>  				      XFS_FSB_TO_B(mp, 1))),
> >>  		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
> >> -- 
> >> 2.27.0
> >> 
