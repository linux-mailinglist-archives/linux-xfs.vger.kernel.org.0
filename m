Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C711C73B0
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgEFPNS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbgEFPNR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:13:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFC8C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=udKCYD5dYjWCpySK8qoO8kUBrK
        sS9hFwhxlDh+Bm2/ENQ7335jJ46omoL2yOwusjmEhcnt5ay+4OJefu6mEqOSutWbobX4q6rdRrITb
        rcRCovBXnpJImdwWHA165Q+nFRTvFpRVBjAAvI7flZ03gleYZgJHc9vglBPVOQVjsiPuXmBYPkFC3
        UN6dbZIWWKvEaIeQlwgTslp/DjP2TBB4QRc2TZVkAB9un3VbDOpW1uCvG/l2PkSC6f7k2rT97O0V8
        Hvj5hkDWGTj/x2UFcaTnX467TRoLLODR6UYnNVfBKX7bmtMLNSsvvOQHhhJpJ19npWLU2V99KmY5N
        ulRYwL2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLjZ-0008Kc-Kc; Wed, 06 May 2020 15:13:17 +0000
Date:   Wed, 6 May 2020 08:13:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/28] xfs: refactor log recovery RUI item dispatch for
 pass2 commit functions
Message-ID: <20200506151317.GN7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864109518.182683.10374774193978011328.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864109518.182683.10374774193978011328.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
