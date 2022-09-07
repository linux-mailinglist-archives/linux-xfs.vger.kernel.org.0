Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768A85B0604
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Sep 2022 16:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiIGOEv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Sep 2022 10:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiIGOEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2022 10:04:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350ED1707A
        for <linux-xfs@vger.kernel.org>; Wed,  7 Sep 2022 07:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZZvEnJ67hemFcUGkffl3ojqPT/uoPF5vgkYFllqoZeQ=; b=gwuRUkYUZaRZ6Xe0o3M/vpiykR
        U79GYyjsRJW/ZZE7TmfPaCu6+k92kkqWMt+6sKj3Tbs0IDYUVVltGFvSI2m1itRq1wGcobOwoA9cD
        ewJzRvnLTRywplNMIfwX/H0ndpPH24cv0hPKfKtLDgSMFfULTwutRYzF7KTgq4lghqoCmX6YoVGSh
        jomOV63cb8sZC5MVotBGRha+xCXUOMZjavZNmlnjKoivQhPTNo1BPjsh4bT5bdxLCNCXmPRRm1Js2
        8TwmXtbYYzMxnW0pvZ0vRu29Utj6qQfnDW25wHz81dVf0TCAbLkB23k551Ry2ZSH2RlKZg5SiAFDt
        MzIEl1Tw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVvfU-006hoO-DL; Wed, 07 Sep 2022 14:04:40 +0000
Date:   Wed, 7 Sep 2022 07:04:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: background AIL push targets physical space, not
 grant space
Message-ID: <Yxik+N0dAPfEbe1i@infradead.org>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  __xfs_ail_push_target(
>  	struct xfs_ail		*ailp)
>  {
> +	struct xlog		*log = ailp->ail_log;
> +	struct xfs_log_item	*lip;
>  
> +	xfs_lsn_t	target_lsn = 0;

Any reason for the empty line and different indentation here?

> +	xfs_lsn_t	max_lsn;
> +	xfs_lsn_t	min_lsn;
> +	int32_t		free_bytes;
> +	uint32_t	target_block;
> +	uint32_t	target_cycle;
> +
> +	lockdep_assert_held(&ailp->ail_lock);
> +
> +	lip = xfs_ail_max(ailp);
> +	if (!lip)
> +		return NULLCOMMITLSN;
> +	max_lsn = lip->li_lsn;
> +	min_lsn = __xfs_ail_min_lsn(ailp);

Ok, this appears to be when we actually need the ail_lock added in the
previous patch.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
