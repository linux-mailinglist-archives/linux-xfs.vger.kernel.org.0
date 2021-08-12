Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1467F3EA07B
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Aug 2021 10:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhHLIVS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Aug 2021 04:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbhHLIVF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:21:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5F7C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=dLS+viob3ifk5LtM9x3Yg+nq1n
        KLqPNjeEE4RFOzsLteIG4qgIa5KQPEdgaiNEOL0EEgsF1eRJrmG8kQYTIzTjsgLE97TtYuTOu+HWe
        ddxSSuYGoyRrRGUx8dozRfP5FNbcVpDMkPuq3JeKv3bkuuWdd8zi6MoxkZgj1sdg5K9VBOMopW7Vn
        2YO1bQbrYYkpZIQRh46RgBsFOFLMOp1e+IjVs2VtcSMdy9vl/5SKHBJZvLGyZOoDArOLTgNqBYVIb
        2wQcmbZQwQ7Ae9A/cjuLDHXkFXaMqli9nDGf77wZlnCmKMpRGRtm845gBUyRkaTq7zZWJ1YGhbH4n
        qqsRobJA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5wX-00EL4g-MS; Thu, 12 Aug 2021 08:20:09 +0000
Date:   Thu, 12 Aug 2021 09:20:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: convert bp->b_bn references to xfs_buf_daddr()
Message-ID: <YRTZsT/FMVCvCSzg@infradead.org>
References: <20210810052851.42312-1-david@fromorbit.com>
 <20210810052851.42312-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052851.42312-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
