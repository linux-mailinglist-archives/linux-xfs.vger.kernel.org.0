Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A78275275
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Sep 2020 09:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIWHtz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Sep 2020 03:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWHtz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:49:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51993C061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=60iuyTIsGk/33ynSBBtZC8RTMVhkhfOwFpHREcKom+k=; b=Yxvu9cB+LM38ocbWp2hCsqPPe8
        z/7TEdGFMMbYZCepMvaCWx6mXCgMkCruyrGlOS//LEEQQ4i9k8hj+mNJeLjGUecCTx2kr0r279Nbk
        p0LKBB/55pXUghnLDIVM33EtPHcKzxEZcqF24V/CQVAIFP7Fxm0VUoMqb6ilr2htcT1M8VrsRZZC3
        C6ZOtzLUoB6N/G8f51o8o4/XzJ7iDQEs4MaE3BE+BD2ej2YUlTIMfifFrLYCJHUnxCB8tma7hiFaN
        aTf5jz1c4mvq2+8+0La1LrjMnth5WRd3ZgF4FiS3nu1KB2yGzlVvNYjzdCpyTFqPGNA0ONiGHc1cb
        CFvjOv5A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKzXF-0001NK-V1; Wed, 23 Sep 2020 07:49:54 +0000
Date:   Wed, 23 Sep 2020 08:49:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
Message-ID: <20200923074953.GC31918@infradead.org>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
 <160031335967.3624461.12775342036527430147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031335967.3624461.12775342036527430147.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	list_for_each_entry_safe(dfc, next, dfops_freezers, dfc_list) {
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
> -				0, XFS_TRANS_RESERVE, &tp);
> +		error = xfs_trans_alloc(mp, &dfc->dfc_tres, 0, 0,
> +				XFS_TRANS_RESERVE, &tp);

... and this fixes the weird itruncate thing.  Nice!
