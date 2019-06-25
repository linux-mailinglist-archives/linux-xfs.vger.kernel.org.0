Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A33854D11
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 13:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfFYLB3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 07:01:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36938 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbfFYLB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 07:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NPzymWGZFZtOe+/jKRLbVu5DHM/rAWyTP2BsW0jWWww=; b=ER5CB+O9Et4zJ0AxYzRZ4kCb8
        xXzQGe/0Enkw5XhsKsTtHAJwvgUk3oZZbnHrT37ivzc3+UsJMTgjyBar1uZSQlney0+WUdDe8mcsI
        BY2ociqMVCFBhHAkZvNI+sfSbcM3SDJBu/rdOjPQIfWYwSN6RwVh0KUAkyYA0+xfF6jDAWun1iJaD
        WvqBYtCO6ODKJDDM8gz2x2TCZoYqk14gSqQx4ZDh0iMt6rP6L2qISr5lXiAUTDFCELPFikgrpyqwf
        qDe01dI4SxIfKn8YhDr1SzyVC3JRGlJL6Tl494qvlECSNqtdtcU69s9QkOfy+331YNQckAs1CVTCw
        ILZu3uIQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfjCb-0002YO-3b; Tue, 25 Jun 2019 11:01:29 +0000
Date:   Tue, 25 Jun 2019 04:01:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/11] xfsprogs: remove unneeded #includes
Message-ID: <20190625110129.GB9601@infradead.org>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The whole series looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
