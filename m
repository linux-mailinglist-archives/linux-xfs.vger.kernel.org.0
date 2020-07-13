Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFD321BA5D
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Jul 2020 18:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGJQJ3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jul 2020 12:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgGJQJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 12:09:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023BEC08C5CE
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SJeoQwl94h9Zw0iHCI9CE7tOfhpSTL7doPg3HeY+KnI=; b=HWOF3kxYT9VphAjAC7wCjanR7+
        /M69rehRFiGH+/jT6QE3lyozJIIzZy/0DtOEj2mxhVipNIpBrY9wBag5DhoUVcqC59c5XrvdHfnVx
        VMLEtefrJlyjlNyix8WzjQGjPGD4nhs5IJTi4adKhgvrn83IHSwfSHeOjurNZehvxapRLuFoonkGH
        W89U4Ta7OPyKHCMeMcuhLR11pUy4KsvrbOwjYFxXImnMqq4+9jI/ZBDRk0dKAHGJsAm8mFvSUyKaW
        mBjOiRMbVor00tSTA4CEEBTVzUeJXi3HRxg38QPYmWJQ8lI+hwSq1c47935uQEAsyKbNaAt6zb5P/
        3qqDbLAg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtvaZ-00032N-I5; Fri, 10 Jul 2020 16:09:27 +0000
Date:   Fri, 10 Jul 2020 17:09:27 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V3 3/5] xfs: Modify xlog_ticket_alloc() to use kernel's
 MM API
Message-ID: <20200710160927.GC10364@infradead.org>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710091536.95828-4-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 10, 2020 at 11:15:34AM +0200, Carlos Maiolino wrote:
> xlog_ticket_alloc() is always called under NOFS context, except from
> unmount path, which eitherway is holding many FS locks, so, there is no
> need for its callers to keep passing allocation flags into it.
> 
> change xlog_ticket_alloc() to use default kmem_cache_zalloc(), remove
> its alloc_flags argument, and always use GFP_NOFS | __GFP_NOFAIL flags.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
