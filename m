Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162681F49D
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 14:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfEOMll (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 08:41:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfEOMll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 08:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sr3Ogaee7jIVVUecMMJcm1w7A363Tl65DPAu1G4N84k=; b=M4N2mBKWmLRdqk/dSN8dhp/T0
        LLl3/XXtGQpqEBJQRcBn1wGS7m93YVejRciO0FxBsEgwfbXNmpM+0uVlIzwi69qzTQp36NBnmFtcZ
        ss+tMR6VkzsDz0NhvYyOgbydk/BTI0xuivAFxUrv3mNSUCoD2rJrLrU76aofzvGhQdQPXsSoj+1nF
        s4xmaZtJyoTlJTw2QinG6RpYTQgXp8GuICU88vn6Z0UHGz7WsVJYLXEpi538upHxnBjVLmZOJoA1Y
        /ph/biRUNVW42wt0NCsEDy5+9POogLj4LSgxr+jbefn4J9YgVijHXY7p7afee68BOxFYwLPISTk7u
        OgUX7LP6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQtE4-0005he-Li; Wed, 15 May 2019 12:41:40 +0000
Date:   Wed, 15 May 2019 05:41:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: Linus' tree hangs in generic/530
Message-ID: <20190515124140.GA21791@infradead.org>
References: <20190515063208.GA6981@infradead.org>
 <20190515120657.GA2898@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515120657.GA2898@bfoster>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 08:07:01AM -0400, Brian Foster wrote:
> Have you determined whether this is actually hung btw as opposed to
> hitting some kind of sequence with pathological performance that isn't
> typically hit during the test? I don't recall whether the older kernel
> tests I referred to above resulted in task hung warnings or not, but I
> guess it wouldn't surprise me given how long the tests seemed to take to
> complete (I eventually just killed and expunged them).

I just waited for about an hour and then gave up..
