Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E255229E7C9
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgJ2Juz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgJ2Juz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:50:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D07FC0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=SpFECmZUIT36WKyAh2Vb7xO+Ts
        QoqWEbHvdi18Pp79WoRnr/isMFPCp9fB0EO0ZVWe/Mc1Rv6r37px8b+zxidPgLQtb46VwioMS4OIL
        6U8gGtQIGXjGiKm0DKd57qR9RKjY73VootNk4Bacx9K1o1cCcCCDcNRO6aS1BB13oa/w7R6CfkLTs
        KBr9MqNrdZ0tevxuucTn8ULQ7O+v6GHQh/oavm4RA0m1J+SNxRwDP9o9O22hSCKQYzaWDxCZjoJOP
        fDKcWmNVUJawXprkKllaFOK73j9pbD/VdhmrcPPvwqdOxMl+TEih4WdXLxXePpfkO5k0ys0XYdlac
        wZo4hViA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4a4-0001jk-0Q; Thu, 29 Oct 2020 09:50:52 +0000
Date:   Thu, 29 Oct 2020 09:50:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs_db: support printing time limits
Message-ID: <20201029095051.GP2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375538229.881414.12318967122326451609.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375538229.881414.12318967122326451609.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
