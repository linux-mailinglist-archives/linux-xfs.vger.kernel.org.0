Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321F2B7F8D
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Sep 2019 19:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390741AbfISRDy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Sep 2019 13:03:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390734AbfISRDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 13:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xvNpgDIFPYE34Flooqgjn8l47mbkSbvgxxgLnWlg6Y8=; b=aKdxnP9BypU/1U6crCPwIUyhM
        pAX9jTqp3ENZpNuxT7mnmp0jCK0jAKf8jmUifUPjGYMrVckEDoYlkOfl2Z7VsGUpAqt6SpssVLzQU
        kOD97+5mvaI8QUCYDbnZQEdOeu+cazV0YZJZ+UzLIUO+/OOCB3uDpbL46sJ6Bd5IWUjL7PkCDy+91
        xLEmQxM/u8rH1hViXVheoKTl9N5V1/fWTQ2e8Y855kBu4Vxs5YDkUlyo+jXkwJRGVivnCIQTQA/RM
        3gps3ZYgDFg+FE9IhTwsO4aXWXL3BLAGARBTE3e3bCXaWT2fnqzpxNQW2R5L+EVgo6Z9uGgOODWmM
        xxAvpbS+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iAzqT-0000RN-9B; Thu, 19 Sep 2019 17:03:53 +0000
Date:   Thu, 19 Sep 2019 10:03:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: assure zeroed memory buffers for certain kmem
 allocations
Message-ID: <20190919170353.GA1646@infradead.org>
References: <20190916153504.30809-1-billodo@redhat.com>
 <20190919150154.30302-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919150154.30302-1-billodo@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 10:01:54AM -0500, Bill O'Donnell wrote:
> +	uint			kmflag_mask = 0;
> +
> +	if (!(flags & XBF_READ))
> +		kmflag_mask |= KM_ZERO;

> @@ -391,7 +396,7 @@ xfs_buf_allocate_memory(
>  		struct page	*page;
>  		uint		retries = 0;
>  retry:
> -		page = alloc_page(gfp_mask);
> +		page = alloc_page(gfp_mask | kmflag_mask);

alloc_page takes GFP_ flags, not KM_.  In fact sparse should have warned
about this.
