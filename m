Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AA854C72
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfFYKju (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:39:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55900 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfFYKju (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cpbEg+uC8vi0OEM7e5JH6GSaMj0B5BI8OPPz/yiogog=; b=Mxsgzv8VOyhMDi5IpYp8mmR/f
        xrDtkal9/coREy8OdEJD6Hk0jMXnzv86OKfTlvOZ/YR7PPvNb4TYYYEji6KHTsuj9uHYibJ11YXc9
        uZHI2QEzCuUs2Ma3qH65XlOTtN6i+2zPscPE9rWEsNozLj44IuFNRL61WHAuHFV3bEJWK3qUC1vlm
        GVahTz7s+oM+mICFOS3wPOlpt/CDZHHIqgNCqX7Pxabb2uN6joDZujXAwNpQGpnq1V+JjzwM7P2Jc
        n9KhKnI/eEPgEJYOCtj+t4gsN+2I56lueKg+k9Kw2SSFliljlQnn5p+z83Q5FqCP7R4FOpMAQVkI5
        ZUTD9FVRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfird-0001mc-QG; Tue, 25 Jun 2019 10:39:49 +0000
Date:   Tue, 25 Jun 2019 03:39:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] libxfs: fix uncached buffer refcounting
Message-ID: <20190625103949.GE30156@infradead.org>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114703289.1643538.16263048212251920271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114703289.1643538.16263048212251920271.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 12:57:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, uncached buffers in userspace are created with zero refcount
> and are fed to cache_node_put when they're released.  This is totally
> broken -- the refcount should be 1 (because the caller now holds a
> reference) and we should never be dumping uncached buffers into the
> cache.  Fix both of these problems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
