Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A104A29E7C7
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJ2JuP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgJ2JuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:50:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2566C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d7Ztm7co8SP9tCfuuyFSOoMUTM2diZCdbIWLPqQOlmw=; b=DXTbZ6wdoN0Lo6XQWXwP0Gods+
        gTByMFCl1ImQ1BO1lRlxfomQK/eI29Ygu5TUe4jGL7g/ERcQ2eVsM4izpkbZZ/5lWPaxIvY8ADIEg
        LPFogob9sjkkkufwQAZVao2NuwP7zJxnV94FqFMLql8/ELXlQ/xzSeTnbe4a263FA4KF1ZQVkiz5N
        +wyrZ6ee/WBSzSOjQGg5fuhszn5QEl0qbGB/uOqpOMXg5sbKN5jgadqK3eWNf+x1aRAFcDTw8RgBS
        4NSwDaXqicDlzpa6J5rXzuSJzMtmLZIhTpCaBA3rt8qJopQQucnykwDxlOBG/6A+SkqXn8VR3sq4T
        W6NxgWhw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4ZO-0001io-GH; Thu, 29 Oct 2020 09:50:11 +0000
Date:   Thu, 29 Oct 2020 09:50:10 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/26] xfs_db: report bigtime format timestamps
Message-ID: <20201029095010.GO2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375537615.881414.8162037930017365466.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375537615.881414.8162037930017365466.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +static void
> +fp_time64(
> +	time64_t		sec)
>  {
> +	time_t			tt = sec;
>  	char			*c;
> +
> +	BUILD_BUG_ON(sizeof(long) != sizeof(time_t));

Why?
