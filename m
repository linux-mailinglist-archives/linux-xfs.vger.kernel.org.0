Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4271C73FF
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgEFPQN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgEFPQN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:16:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2158EC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ylnLcZwyMUyLBFG2k9Qh1sSzBPgDfqSNeh3BD/OsSaQ=; b=KOTeXyBBP4m0HEEoieGZE8B4G9
        eNA+f+mEeENToyFeHy7/jXtelzMwxh0Xrj0UtbyaSSCfkl7BXQPPxDdXh8dJ5uFEMh4Xe0k9CScGY
        XsP7AUtHIoVs2AciyKbemlk67Q18D8OzjI7eF+P2KGMRN/f7gn64EiTW4W3wxw/fsbkc1bjIUUkOT
        GyWDciqN0UzfzYTRo5N1X8LKQfOZJ7TczzPrVuL43RwgdxsqjDsuVQIbRLG8nRywmeryu1x0SL+kH
        MrJzhRZRNvVtdnepf+J7VOK3OHPoMpNZ/SRyXDUAoefbdBDxmYDSW9/7TFAP5NgKeV7fgk91nbg1r
        lpJ189tQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLmN-0004hl-RW; Wed, 06 May 2020 15:16:12 +0000
Date:   Wed, 6 May 2020 08:16:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/28] xfs: remove log recovery quotaoff item dispatch
 for pass2 commit functions
Message-ID: <20200506151611.GQ7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864111362.182683.13426589599394215389.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864111362.182683.13426589599394215389.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index 07ff943972a3..a07c1c8344d8 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -197,4 +197,5 @@ xlog_recover_quotaoff_commit_pass1(
>  const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
>  	.item_type		= XFS_LI_QUOTAOFF,
>  	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
> +	.commit_pass2		= NULL, /* nothing to do in pass2 */

No need to initialize 0 or NULL fields in static structures.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
