Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DD7324BE5
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 09:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbhBYIRv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 03:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbhBYIRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:17:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5C3C061786
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=giML4n9n0ZAMmqhwasJRemALOUfGsS9u/RhoFpuar9Q=; b=cd5l4Q4y535MkIY4ed2l6vv4vP
        fBpYLtHT+vZJVb+UN5HSjGDIhQUfnwyloQSUM9cVjv80ktzDlqtkarNAPgEa6BOBQS0ruUbmYcgVM
        riDwCgiYq6MwXszDRBEm3cVEHTCE7zeDYNEXng4Qf4Hoi3IQfpKp61Kn+g5nEvGN/Z3M/L/y4Qcf6
        rng99GQUz4Bxj9eS1t5yE7AxX4gOTWoaOnTeAJzPEYw3xCCCjafttDsCVVQDueFTxodvk9SCAE89x
        4ABhwo5zJJx73ny0Rhw4VTaNZu9eY/HFoThzfDxzrtMifMxjpNzlrjjuyXfKMGPrg2hQ8VjjIV/a3
        fcgx3stQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBp8-00ASJ5-W7; Thu, 25 Feb 2021 08:16:48 +0000
Date:   Thu, 25 Feb 2021 08:16:38 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_repair: set NEEDSREPAIR the first time we write
 to a filesystem
Message-ID: <20210225081638.GL2483198@infradead.org>
References: <161404926046.425602.766097344183886137.stgit@magnolia>
 <161404926616.425602.16421331298021628773.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161404926616.425602.16421331298021628773.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 75230ca5..f93a9f11 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -11,6 +11,8 @@ struct xfs_inode;
>  struct xfs_buftarg;
>  struct xfs_da_geometry;
>  
> +typedef void (*buf_writeback_fn)(struct xfs_buf *bp);

Any point in adding a typedef that is only used once?

> +	if (!bp || bp->b_error) {
> +		do_log(
> +	_("couldn't get superblock to set needsrepair, err=%d\n"),
> +				bp ? bp->b_error : ENOMEM);

Maybe add a goto out_buf_release goto here to avoid the extra level of
indentation for the normal path?

But the code itself looks good, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
