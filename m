Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78E014D71B
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Jan 2020 08:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgA3HpE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Jan 2020 02:45:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgA3HpD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 02:45:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xtxC9/f59fGPSXsGOpdnQklLQ2l1L3h4aXSHI+6lWrU=; b=L7eM6TwOGNyLTmrgXGWuOxYUg
        YhW0D5TRmf5tzso4Ejd8vbMLtkbm7OXokg9PDVFHzZWPv00fjwef8AkNYMOd4Th77V8g3lJfB8+Mf
        sDDE5NOhfr2cCb4kS+RZ7UztF6ikiWVerNMadmEneQoW2B5iG2ByK623QY+Ucjj8GN2oDYSKSqLWb
        9cWCU8awoDcoH807ztvhToMFaWjWdKpdWCuMqT7SRUZIS0ZNGucuBIILEMfuXuORv62yxxvyfvr0E
        uSzdYHuJYPTLybRilumJigenXpoqUmtHIFbfclMU0RzmKlYvKYHzk80/UoCgc3/sOgbH/fScL4fI+
        yNXFiBzGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ix4Vb-0007QS-NO; Thu, 30 Jan 2020 07:45:03 +0000
Date:   Wed, 29 Jan 2020 23:45:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: replace mr*() functions with native rwsem calls
Message-ID: <20200130074503.GB26672@infradead.org>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128145528.2093039-5-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 28, 2020 at 03:55:28PM +0100, Pavel Reichl wrote:
> Remove mr*() functions as they only wrap the standard kernel functions
> for kernel manimulation.

I think patches 2, 3 and 4 make more sense if merged into a single
patch to replace the mrlocks with rw_sempahores.
