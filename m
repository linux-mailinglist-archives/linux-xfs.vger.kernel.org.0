Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFF929E155
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 03:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgJ1Vvn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:51:43 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgJ1Vvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:51:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=onrXjGTWQdh6DYrx205Oc1+gxQl5xA/c8YCNRMh4YPE=; b=qYTNclf472Eup9RaqOMeVpf22I
        l5KsNfOHYQ7q0g3eyxhwTu4j0E++tf41h7tdGcD9lYharghGf1p1XnOc40u/KFrEUXv8Xux7eRS6D
        rMl3tJc5fXJswPV+Y/6dzATzVmKO0dDqVZ23bU20IXLEf5cNurTrFUhBKU1Z9QC0FP/ZHyJJKc4V9
        JeyR1yH7Syr7Qo6xHeR72akowVfys0HaifAuXSW3gk6dxSrskJQvhulEqRZHYh7rLsLlUzz7whph6
        0g7ZsjvRmi2jH82byIehJA0frHzLMPJPHLzrExInyzwa6XKUx8cT/xEGu8jz0HQs4H1wpSnafHaCZ
        k5iZ5e3g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXm3c-0002J4-OP; Wed, 28 Oct 2020 14:04:08 +0000
Date:   Wed, 28 Oct 2020 14:04:08 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: support partial page discard on writeback block
 mapping failure
Message-ID: <20201028140408.GA7841@infradead.org>
References: <20201026182019.1547662-1-bfoster@redhat.com>
 <20201028073127.GA32068@infradead.org>
 <20201028113200.GC1610972@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028113200.GC1610972@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 07:32:00AM -0400, Brian Foster wrote:
> I used the variable just to avoid having to split the function call into
> multiple lines. I.e., it just looked more readable to me than:
> 
>                if (wpc->ops->discard_page)
>                         wpc->ops->discard_page(page,
>                                                offset_in_page(file_offset));
> 
> I can change it back if that is preferred (or possibly use a function
> pointer variable instead). I suppose that's also avoided by passing
> file_offset directly, but that seems a little odd to me for a page
> oriented callback.

I think passing the file offset makes more sense, especially as the
only instance needs it anyway.
