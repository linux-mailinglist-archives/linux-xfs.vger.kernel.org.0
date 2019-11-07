Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1269F296B
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 09:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733218AbfKGImY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 03:42:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733170AbfKGImY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 03:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dHcruc6BvyPrZTslX5qzvh4tOfoekOTaxA5q5uCxQ+c=; b=kp533JOzITsutr+4WiBduvzAi
        88chEkbWqjLe2cF8ZNZrsCjhp2XNPC8xLhqzq0G165GALVYhuQG/9bMBJYi22uEtVhyFMGcFf16J2
        eEI/de22xqjY5pJdc6nW+2vTotXv9IaJzSxCePqsHT37hsLlvCFAwhucwXCrhm+nES39jd2VebGWy
        HKr4TaEWZ++LjrLvgTdckMVUVYB0QLx8MeKMgQ4qEJ9cgTqkMl2eAur5WlGV9+AvTIkXYsXiz1/RP
        ZkFD8f4X5rG5HsoYmsFTtjPAoIrhlpr3NAcUReRDYpBf0CC7UIpnN6G5dkcx/bGo0OfR+ltTguNrH
        NkJtXbRyQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSdN1-0007WI-Kc; Thu, 07 Nov 2019 08:42:23 +0000
Date:   Thu, 7 Nov 2019 00:42:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: range check ri_cnt when recovering log items
Message-ID: <20191107084223.GF6729@infradead.org>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
 <157309578133.46520.12978933521645962496.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309578133.46520.12978933521645962496.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 07:03:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Range check the region counter when we're reassembling regions from log
> items during log recovery.  In the old days ASSERT would halt the
> kernel, but this isn't true any more so we have to make an explicit
> error return.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
