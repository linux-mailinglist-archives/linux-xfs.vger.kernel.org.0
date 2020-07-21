Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC53228300
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Jul 2020 17:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGUPBt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jul 2020 11:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUPBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 11:01:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CD1C061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 08:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7Ha4QdV5JEas/XF0S4XPbhr+9mutWS9t2prMfHYbeKs=; b=PLn+hjFpDdkxL1aVX1tG0us1aU
        yykImNHD4awcAcdroPIigGdZfD+N6GK76318FcybmGQ/hslOPPG2ePpGpvsOa45vrNgekVDY5J3Bo
        prnoLPbH26Nk/dMZEZXLkZRiPM+fyvwvnyKz3qwrfvko9Gm789sOUG3c44pxKyt+N663Xr1juq/oy
        S6XaGSFOqIIzcgUQMEgz4EbsSBSVEJEHMSq17G2Z8FQexQxy4tRCcJvYifMegeVnt5B750chqCT4U
        gf2KkM0X7qOwWjnRxXVa7vlTRGRvZHNn93rvrJywJq8RVi+WOst+x9IXHP9hggBTxxkLTcb8AboOO
        PK2XXb2Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtm6-00026L-Rj; Tue, 21 Jul 2020 15:01:46 +0000
Date:   Tue, 21 Jul 2020 16:01:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix inode allocation block res calculation
 precedence
Message-ID: <20200721150146.GB7506@infradead.org>
References: <20200715193310.22002-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715193310.22002-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good as a quick fix:

Reviewed-by: Christoph Hellwig <hch@lst.de>

and I'm all for further cleanups on top.
