Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB41671DEB
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388653AbfGWRlx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 13:41:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388606AbfGWRlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 13:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+HMUQDK6wiIBWCIIF8WwUTw7ciIEQbt2CkPjlk5WDmc=; b=U4fjXLXfBXbuf3Q4CWPZR6vYE
        QqRuLDZRGwa0a9qzfohdkJwKivdpYG0HGc8aSPwopfyEFr78dvV/njfN9RmMIY00Kk/rgjWbgFVX1
        7W2vcm28P7VVrCatVkhHQIX1/xbKialK50N0hE3AQVYzqZYg2s466XbBI80aZYPHYke0gFRKJ3Woq
        6d6iy/BdFXsMfGjl5+x4pn5PBp740xoTdcDRF0ehtgPbtDJ0rJiTqpM5vmzAlOCvDn0Q62MQ3blKc
        uj8o6+Mz6fDlEQClVIvQ4qFWdMkjWhnBojcV1dDcrlUJYVwKIdWvBqY0BI1u96/xmsThPh/nuT50o
        gCY31Jkhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hpynR-0006YA-0V; Tue, 23 Jul 2019 17:41:53 +0000
Date:   Tue, 23 Jul 2019 10:41:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723174152.GA19405@infradead.org>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
 <20190723151102.GA1561054@magnolia>
 <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
 <20190723155135.GA16481@infradead.org>
 <c2f3542bd06860ecf33f1785b9c146a09a155bf7.camel@kernel.org>
 <20190723170843.GA1952@infradead.org>
 <70ea7252bc0cbfc99da7fde1ce58ddb92550885a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70ea7252bc0cbfc99da7fde1ce58ddb92550885a.camel@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 01:38:08PM -0400, Jeff Layton wrote:
> Ahh ok, I get it now. You're using it as a generic "free this, no matter
> what it is" wrapper, and relying on the caller to ensure that it will
> never try to free a vmalloc'ed addr from an atomic context.
> 
> I wonder how many other places are doing that? I count 858 call sites
> for kvfree. If significant portion of those are doing this, then we may
> have to re-think my patch. It seems like the right thing to do, but we
> there may be more fallout than I expected.

For xfs we only have 4 direct callers of kmem_alloc_large, and 8 callers
of kmem_zalloc_large, so it they aren't too many, even assuming that due
to error handling we usually have a few more sites that free the
buffers.
