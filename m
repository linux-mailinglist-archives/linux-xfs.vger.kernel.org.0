Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1BB27E0EC
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Sep 2020 08:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbgI3GRv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Sep 2020 02:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI3GRv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 02:17:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1616FC061755
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2020 23:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=QnPQzH2uOl2Z30GhoaIbLi2S8s
        UuGZz6H4YzKcpKiQ3TWVbfy3Y/8wp45qp4FwZl993/O3N2EkQoydhhf6SuA2Ogz7bb5A56vxf2cG8
        QBlGANvT1Qt0K1TGJZdZZqrc88Q6Mj5W+55WTlMxka3IuCAuDG6zXYu4RDHYS5O35Y8eL7n8BSykp
        FHjl/nsO76CWOxgnSS9+01H0KFHGg5hFIfaAEquumhpkvBjY5NCx6sWJ98InbqxVY4VsYtjosWwa8
        2oztvtX7JI7/tt2mqVzkSa1TC0wLY7jmjL0KIgvgIGJzCgInC422nZex3VUOJ8+GC/hTBu4sS3Jxr
        ctzKdhyw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kNVQv-0001Av-Td; Wed, 30 Sep 2020 06:17:45 +0000
Date:   Wed, 30 Sep 2020 07:17:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/7] xfs_repair: throw away totally bad clusters
Message-ID: <20200930061745.GA4363@infradead.org>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950115513.567790.16525509399719506379.stgit@magnolia>
 <20200929153505.GH49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929153505.GH49547@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
