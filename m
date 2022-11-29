Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581E063B852
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Nov 2022 04:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiK2DAo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Nov 2022 22:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235160AbiK2DAn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 22:00:43 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9944508C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 19:00:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VVylzC-_1669690837;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VVylzC-_1669690837)
          by smtp.aliyun-inc.com;
          Tue, 29 Nov 2022 11:00:38 +0800
Date:   Tue, 29 Nov 2022 11:00:36 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: shut up -Wuninitialized in xfsaild_push
Message-ID: <Y4V11E8A2jOv7AjN@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <166930917525.2061853.17523624187254825450.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <166930917525.2061853.17523624187254825450.stgit@magnolia>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 24, 2022 at 08:59:35AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> -Wuninitialized complains about @target in xfsaild_push being
> uninitialized in the case where the waitqueue is active but there is no
> last item in the AIL to wait for.  I /think/ it should never be the case
> that the subsequent xfs_trans_ail_cursor_first returns a log item and
> hence we'll never end up at XFS_LSN_CMP, but let's make this explicit.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

As far as I understand, I don't think this can happen as well.

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang


> ---
>  fs/xfs/xfs_trans_ail.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index f51df7d94ef7..7d4109af193e 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -422,7 +422,7 @@ xfsaild_push(
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_log_item	*lip;
>  	xfs_lsn_t		lsn;
> -	xfs_lsn_t		target;
> +	xfs_lsn_t		target = NULLCOMMITLSN;
>  	long			tout;
>  	int			stuck = 0;
>  	int			flushing = 0;
> @@ -472,6 +472,8 @@ xfsaild_push(
>  
>  	XFS_STATS_INC(mp, xs_push_ail);
>  
> +	ASSERT(target != NULLCOMMITLSN);
> +
>  	lsn = lip->li_lsn;
>  	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
>  		int	lock_result;
