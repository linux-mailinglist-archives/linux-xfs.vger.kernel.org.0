Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDAB35ED24
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Apr 2021 08:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349197AbhDNGVF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Apr 2021 02:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbhDNGVF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:21:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C569C061574;
        Tue, 13 Apr 2021 23:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=FP1VAFolYtZusxx9d3PENVkygO
        jlYQ9rfaR3d+Mb0KYl6XE6JNS4UqsVnc0NQEcIl2D0YSJE7Eu84XcHXO2k/GTnrxoCsIoxoazEhGi
        UTKmY8rCH8HTiVcCZQZr0oIl0xnHwy5tF+5WwUAZqcZXwWvh6Ro25MSI5SUsM8B46f405dH5cx5O3
        SgO62Al/c9R2iFvK1bto0mCu0v7nPsnE+tqyZgv1JXE1FrHwo3exaYgYBUFJXqAW2WCMp++9se0X/
        /5+t31AE1XUHxJdQTc08OWKaoF7elH14YFXOPeXiBFJtXWqsE3ZcwRiILt7DiH4CT28wuv65+XtrE
        t/lI2htA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYtD-006jiy-3m; Wed, 14 Apr 2021 06:20:40 +0000
Date:   Wed, 14 Apr 2021 07:20:39 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 8/9] generic/{094,225}: skip test when the xfs rt extent
 size is larger than 1 fsb
Message-ID: <20210414062039.GJ1602505@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836232004.2754991.941115577343319256.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836232004.2754991.941115577343319256.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
