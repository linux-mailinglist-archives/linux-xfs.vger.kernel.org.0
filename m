Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63F424E675
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Aug 2020 10:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgHVI7F (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 22 Aug 2020 04:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgHVI7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 04:59:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEF3C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 01:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0zcHgJnpLnsI/o12SZwImWfafy3lWwlWXEwuN/9ptvA=; b=FW4KjQUF/38Ni7ZBhjwS3mtiXF
        pjSCfHvrqI4UuWTi/ekrwxSmbLqh/dLNkGdJfNylrERuzFc0ouAxUqavBI9tvsOFWsux1LaH6+shq
        H0nMrLcbTHnzwh79Z73STcoVbpVpbU7W20F7hwhoL1+IaylXJZzpmUiIF08aVv0gvVkRUgVEdBcU8
        oZPHPmlQY41iq6HpXIB7kMZriQEXNZ63cU6Ws9rFLkvWuTpAXeoj/E+8iRI4aeVOtEmP8LzWfV5y2
        +WR0LOvxdliOBM+s8P5Scff17ksYU3klJ7OK4wKoGs9QfVybHLGGY4gXykGhPJM0rrBCFlYHEpHBn
        hKV7/vFQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9PMc-0006f5-T4; Sat, 22 Aug 2020 08:59:02 +0000
Date:   Sat, 22 Aug 2020 09:59:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: remove kmem_realloc()
Message-ID: <20200822085902.GA24471@infradead.org>
References: <20200819130050.115687-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819130050.115687-1-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 19, 2020 at 03:00:50PM +0200, Carlos Maiolino wrote:
> Remove kmem_realloc() function and convert its users to use MM API
> directly (krealloc())
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
