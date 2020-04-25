Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014081B8888
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Apr 2020 20:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgDYSeg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 25 Apr 2020 14:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYSeg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:34:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036C4C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E496AKGsbqgGfTswD3khclwL1MqulPAEDdG0FKure4Y=; b=PAw6RYNSen5uvz9TxLQ2CIF6Qr
        lMyrfmipIIaEoW/PDTA6S2L6N//92N32ANp0p6R5pUIAYzoYwAZy0y1oOpPY9e455UIHoSqIUjZun
        YLf42mF3QCyhYYac7DXswiXq57J7/J4BNi2ZqJeWLBnoJ/TVakSfqe2GMG1OG3F0QTOKPETfLqAJ9
        nBvfS1WE52DVemsDiQNQbJYqAIpskpyHLzti1K0yyfubInSK7E0ELSggb6xTnG8jxBC89sfPcd0/g
        2oO8x0DYLmKQ2L9EhfB/g6bSlqg7mQhasNI0OZb4qGoRcTuQlExuTQmTlTLg8YSdZlv1xcq99DrVM
        X7iDmVaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPdL-0000v5-T5; Sat, 25 Apr 2020 18:34:35 +0000
Date:   Sat, 25 Apr 2020 11:34:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/19] xfs: refactor adding recovered intent items to the
 log
Message-ID: <20200425183435.GH16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752126650.2140829.12864119186355641266.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752126650.2140829.12864119186355641266.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:07:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During recovery, every intent that we recover from the log has to be
> added to the AIL.  Replace the open-coded addition with a helper.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
