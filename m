Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5037554D19
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 13:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfFYLCz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 07:02:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37036 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbfFYLCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 07:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=L4V6+lB5QHdhK0DQF6gZUUN5yHOkmsO+k0sgBpFRlqM=; b=Y3Zmzm6zC8c19cddblqPRW3Lk
        bkqTFE7TLLQ2A4M4W+DShVXV4p0Zf4jiFjOC+OCCR2W1CQo8qT1947n1UDWtDuQtgrc1iFiWt6cyH
        EigdXCRs1k3h4sUbs2ablPJyy7UVhG1/Ybh1CH9+pJH1UxN0bLqTql0DBFjVUC9AbiXYiJ8J+V7CG
        1nmLW2D3q3iWz82jCb4mMSzB29Ym8dKWhIgoCfilZD62d+2NQmWXN+4r14pBztfZmk678cQ1L6dum
        mSEb5S8vnfINt7hprb02T+5X+tC8RkjdA4wt07/nXoOfHELOTP9hOb2bF6uNC8y+CZezUmQlkcAGA
        5ZBIFGKxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfjDy-0002sY-SK; Tue, 25 Jun 2019 11:02:54 +0000
Date:   Tue, 25 Jun 2019 04:02:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] libfrog: cvt_u64 should use strtoull, not strtoll
Message-ID: <20190625110254.GE9601@infradead.org>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104938235.1172531.7192571581132527840.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156104938235.1172531.7192571581132527840.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 20, 2019 at 09:49:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> cvt_u64 converts a string to an unsigned 64-bit number, so it should use
> strtoull, not strtoll because we don't want negative numbers here.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
