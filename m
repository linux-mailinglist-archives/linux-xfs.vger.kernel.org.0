Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282389CAF2
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2019 09:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbfHZHsT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Aug 2019 03:48:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34946 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfHZHsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 03:48:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vCXYzQ4npzkEffk/9+6qLUJrW4qzgjkkuIzQo8k1g68=; b=YvNShwu0R8j54PxCTrRHWSXFw
        aJqTqW7cNErVIZCRTTmi6YVPp3FAagf84/k12Y0H4u+NhS77hHXJrIAtI3ibTNKctITl7OkyrZKyl
        Rq9JPGVnoP33iX/HP+KsnZ9mBiumrrbIJPqT7V4PTbvq6Ps31ZdYefvAcDSihgG5VNLoneQnPhPDD
        fU80JHvnH1hndQ8AgD/dR8FXeejVnciE44z8viA2XVHOUCKhF2Po2aQPL2MDmlQjRqWEoFDVK2acT
        8PYBZr8OAInE8lkwvrRrXLCQ1nIJm9SaLJgFHSkDsB8A0LBZhuOMQkPxb5AbZoYcI+dV933BUKGZb
        e7Rewkp5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i29je-000305-Um; Mon, 26 Aug 2019 07:48:18 +0000
Date:   Mon, 26 Aug 2019 00:48:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: get allocation alignment from the buftarg
Message-ID: <20190826074818.GB20346@infradead.org>
References: <20190826014007.10877-1-david@fromorbit.com>
 <20190826014007.10877-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826014007.10877-3-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 11:40:06AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Needed to feed into the allocation routine to guarantee the memory
> buffers we add to bios are correctly aligned to the underlying
> device.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I don't really see the real need for the wrapper, but it also doesn't
seem actively harmful, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
