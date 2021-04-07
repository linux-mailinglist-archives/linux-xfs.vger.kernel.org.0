Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71848356438
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Apr 2021 08:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345746AbhDGGlM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Apr 2021 02:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhDGGlL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 02:41:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDFDC06174A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 23:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=MtBmvtWZTvEgLZwyrPRmn5iWhv
        UrF9LXuF99w2YEKrIAax/WG+ycCTlsdyQb+N4g9x5uM5SjMUcJ44Ad+nwXq8rHP72x6Tf6JdXQhuU
        E+2ItLjd8yJecjJ5E1GuWxY2IvTvxb8xQCwP5LSmLLxnt3aEOJAvboOWWj/nWNbIc424WBn3nkoCu
        hS2Lkp0nNl9mX7gFcuPDJ9oDzrloeuQe+7vL6dRVwMllNLF5KoRXUaghR9GdxZNhE3O4PxUbeM4WM
        yY1aLIzhdYG2k8txrKC4ritQOsg9mR9GFo4ywQ0BPTwasGvMfJZTrOtYuZ1WQSRMVKmZQMQbty6Ew
        tXJp3hZw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU1s0-00E1uC-65; Wed, 07 Apr 2021 06:40:57 +0000
Date:   Wed, 7 Apr 2021 07:40:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/4] iomap: remove unused private field from ioend
Message-ID: <20210407064056.GF3339217@infradead.org>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210406102754.795429-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406102754.795429-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
