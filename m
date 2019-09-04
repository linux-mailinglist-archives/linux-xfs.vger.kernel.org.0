Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31775A7AB5
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 07:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfIDF0B (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 01:26:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfIDF0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 01:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iTTXQZO9r1ioRQbqNZ9gFQdejVsGffSnxJuk8XCIi48=; b=oaWDoHSvpIFuFqqHK1vsLbh0K
        xiWpKr7StHkNL7Vgovh3m29r6mbTr0mFebKPmNplQQflOOoQBrx/dyMg3ZuJ4we63OOhkR02gCMK5
        0hz6VOv63QcjCgoG7ggdjej7sAAm8qBiDAf4ulslxD+/X3s59Mz+ji3aKpCIc21oiXEWHMt1kw2sf
        Yo/1F1NxZ6oFc/AFHy8XDoiulf5j/F6cpI/6zgsCA3taf+FOnw51sMKAUvIAasz+rqvIFTrLuMNt7
        XCbkVYNxCdXYUGmPiJWl5HfIHl313YKgJSUSc9hXnkhkdqxt8z6l1os/vJeAhqeOcddmFSbZLZgOV
        lWuXWnp3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5Nns-0000Aa-QR; Wed, 04 Sep 2019 05:26:00 +0000
Date:   Tue, 3 Sep 2019 22:26:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/7] xfs: log race fixes and cleanups
Message-ID: <20190904052600.GA27276@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-1-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 02:24:44PM +1000, Dave Chinner wrote:
> HI folks,
> 
> This series of patches contain fixes for the generic/530 hangs that
> Chandan and Jan reported recently. The first patch in the series is
> the main fix for this, though in theory the last patch in the series
> is necessary to totally close the problem off.

While I haven't been active in the thread I already reported this weeks
ago as well..
