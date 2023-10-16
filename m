Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564A27CAE0E
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Oct 2023 17:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjJPPsa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Oct 2023 11:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjJPPs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 11:48:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F600AB
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 08:48:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A9EC433C7;
        Mon, 16 Oct 2023 15:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697471307;
        bh=dK8BOkmfaYRVWIpT6EhJBB+Z/80B2OtnDOphIoNuuGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i1rQiow1N3oWKsysLdRNWRfvAsrFUcEa2xhFEJ2qm5q6pmwTwfnj2mL1yoKxFO0Xn
         QVp6i+GHLrCJXcgrp+gJc/fAoPhLifcYRkssdPWdTTj3b9uPRrcn6LApitCOWCFGqg
         ZfSFpYJ5dyZLH4ETjgQ/8KQK4WB6RHF9coYbtbLf92JHSeBXhKd4ydmu2Nlijqcwj3
         VVQoc8lNpJe3lWa7ELPCGodaZyZm647FBrjI7amnCWIP0x33VNkRjKa3g4rZrKAWRS
         XRAJHc/fzLtUw4WVA5tkq8ljL9uyFngc831jX1fNThkRuC5n1p2244XY3rE6zIy6QW
         Mul/o8xx02/DA==
Date:   Mon, 16 Oct 2023 08:48:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: only remap the written blocks in
 xfs_reflink_end_cow_extent
Message-ID: <20231016154827.GC11402@frogsfrogsfrogs>
References: <20231016152852.1021679-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016152852.1021679-1-hch@lst.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2023 at 05:28:52PM +0200, Christoph Hellwig wrote:
> xfs_reflink_end_cow_extent looks up the COW extent and the data fork
> extent at offset_fsb, and then proceeds to remap the common subset
> between the two.
> 
> It does however not limit the remapped extent to the passed in
> [*offset_fsbm end_fsb] range and thus potentially remaps more blocks than
> the one handled by the current I/O completion.  This means that with
> sufficiently large data and COW extents we could be remapping COW fork
> mappings that have not been written to, leading to a stale data exposure
> on a powerfail event.
> 
> We use to have a xfs_trim_range to make the remap fit the I/O completion
> range, but that got (apparently accidentally) removed in commit
> df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents").
> 
> Note that I've only found this by code inspection, and a test case would
> probably require very specific delay and error injection.

Hmm.  xfs_prepare_ioend converts unwritten cowfork extents to written
prior to submit_bio.  So I guess you'd have to trick writeback into
issuing totally separate bios for the single mapping.  Then you'd have
to delay the bio for the higher offset part of the mapping while
allowing the bio for the lower part to complete, at which point it would
convey the entire mapping to the data fork.  Then you'd have to convince
the kernel to reread the contents from disk.  I think that would be hard
since the folios for the incomplete writeback are still uptodate and
marked for writeback.  directio will block trying to flush and
invalidate the cache, and buffered io will read the pagecache.

So I don't think there's an actual exposure vector here, but others can
chime in about whatever I've missed. ;)

> Fixes: df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep, that was a goof, thanks for catching that.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_reflink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index eb9102453affbf..0611af06771589 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -784,6 +784,7 @@ xfs_reflink_end_cow_extent(
>  		}
>  	}
>  	del = got;
> +	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
>  
>  	/* Grab the corresponding mapping in the data fork. */
>  	nmaps = 1;
> -- 
> 2.39.2
> 
