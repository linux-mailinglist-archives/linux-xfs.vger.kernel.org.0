Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A65BA481F
	for <lists+linux-xfs@lfdr.de>; Sun,  1 Sep 2019 09:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbfIAHdM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 1 Sep 2019 03:33:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42380 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfIAHdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Sep 2019 03:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bdUqwCHyTuNXqhhXdWpQ4uCbSX0pTVrvNTFnO0RL+9M=; b=OE3Y1t4bk2i5AGTzoyws9wjxc
        2flVzPYarijE8gaoJY3I2kVBAkH90zCDcToPaKkHsSQDAa0AWO84I9908+1E185Bx/ir+t8LumLcY
        0Pf7GZEvI2uUV6LT6jKI4oWqQpdyI+rrDCjfJ0iDvBqFJajBbSZjNoNFp0W/1O6GSgjbLZoGFBGex
        yGtmyMtpt8yN9Xr2hvEdOnbgMYLIcKe7MKFjX/UTs7opbm6ET06efNQF0snSxwMJDycI+Nph5Hho9
        iX9clxEjd7wlYCjRovwz8sFBhW8QoNSbq0cMqsU5Q2BDenEJQYqFJbfxPLW+z6UHio+duMXcIQv47
        LvkkppEKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i4KMJ-0003kd-VN; Sun, 01 Sep 2019 07:33:11 +0000
Date:   Sun, 1 Sep 2019 00:33:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 1baa2800e62d
Message-ID: <20190901073311.GA13954@infradead.org>
References: <20190831193917.GA568270@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190831193917.GA568270@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 31, 2019 at 12:39:17PM -0700, Darrick J. Wong wrote:
> Dave Chinner (13):
>       [0ad95687c3ad] xfs: add kmem allocation trace points
>       [d916275aa4dd] xfs: get allocation alignment from the buftarg
>       [f8f9ee479439] xfs: add kmem_alloc_io()

Btw, shouldn't these go into 5.3-rc?  Linus also mentioned to me in a
private mail that he is going to do a -rc8 due to his travel schedule,
so we'd at least have some soaking time.
