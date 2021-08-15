Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC0E3EC848
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Aug 2021 11:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbhHOJSe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 15 Aug 2021 05:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhHOJSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 05:18:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365B1C061764
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 02:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1sQQs6Pc2lAqeutIRPV7t9e2GTscv8N+k2BTTBXYuPU=; b=Tq6MbLMp1Qqv9tmF9tNRwTyAs5
        pwt2zXTInHz5jKAY8/mg+FHC3BGbm6ZbqntJv6qEESUmJiTiHBn04YUneTMFN9OZH5rDidjzLb2Vg
        p1JW42ehQJic0oEqWUr6Cmh690/euxB22kRrhbe/bpUEbWvsLbUA8GxiozJ3Q7tVKIBE2GxXGXBGW
        CmRCrST70MHUlxRDoalIQlpeSCgtC2Fbi64set6QZEt/2301YOE2FcroLHi+AOWz3vT2yQEI6rVae
        lrTu7DDOtMwAomudnwiuwwUqkXT+f8plGIqTagvL6UPpU6tIewLxtp/w22Kffu8LSZhSfsyYCJmrm
        XruWxirw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFCGf-00Ha8J-1S; Sun, 15 Aug 2021 09:17:38 +0000
Date:   Sun, 15 Aug 2021 10:17:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: mark the record passed into xchk_btree
 functions as const
Message-ID: <YRjbodX52tAd0w8T@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881111657.1695493.2646352717736011507.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881111657.1695493.2646352717736011507.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
> +extern void xfs_bmbt_disk_get_all(const struct xfs_bmbt_rec *r,
> +		struct xfs_bmbt_irec *s);

Might be worth to drop the extern while you're at it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
