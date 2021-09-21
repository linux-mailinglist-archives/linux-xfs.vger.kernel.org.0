Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A14241307E
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Sep 2021 10:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhIUIzn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Sep 2021 04:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhIUIzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 04:55:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15119C061574
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 01:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=PYuNs1/eKeMFwR/3Q5x89/ai2w
        cGrsNuZStHerVeNTZ8QVEjNacW76e15tizQ/gtUDms6qb+LfHuZNoYvsGE+7zTG243douNwmYLmDc
        4fVsQCLVTiMnev5CNxdNGTOXZvWiImoIzIo7gLqVrJexvzwq6uPFBaFAznmlwMllWQG7nf5PHoA7s
        mGdQDffRLevtzieoYBBcwvTlMy8Cl9sWouJmWjEtnw6uIVD37j+3+dgywU1jArMo1dbXcP3P738Uv
        NzeOq+QaL9P5jRBCgGa0AHhTW2bixnbrmIVMKx5QTn0QD0NJpv0VY/gR02wIrBXbKg95rN+5uX1Xn
        1LBBb48w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSbWq-003eRr-Po; Tue, 21 Sep 2021 08:53:40 +0000
Date:   Tue, 21 Sep 2021 09:53:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/14] xfs: refactor btree cursor allocation function
Message-ID: <YUmdiGoncW9AeO0p@infradead.org>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192859374.416199.6462613685926781959.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163192859374.416199.6462613685926781959.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
