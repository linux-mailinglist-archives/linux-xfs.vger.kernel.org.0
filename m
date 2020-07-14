Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC92821EABA
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 09:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgGNH6S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 03:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgGNH6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 03:58:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7B7C061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 00:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=mQ0QGNU45VGJkoGDGwfSOfCjHt
        ZeRb1jr7Tik2Mt+Ilc//Eb65xy7yBqawzZcFkfHGmeYy0Y91VGcjHrsQ1yf1/6jRrawZgBvoATR7y
        j+fI7CXdlOfcGrG0K5NpDC2zWJJ3FlAtj0JIVVb4L3Pm5ocvxj71JpevmgB6ufQJ/0xRkj32M1HMx
        MZxkn99l0g0hcjg2qIVgWa68XsC/0/7Lvf5tznsbitUlzxskWFrkx/Xg9mRz5LifeF/Dx9hxmJCeF
        v6JsSPWPjf5Drbp80SmgYnJycjtJm1eZWyZ8qWibJL4RHDqtGp0zVJKHfHqKAT7tID8geAnLIZElj
        pGMJy+1Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFpQ-0006su-LA; Tue, 14 Jul 2020 07:58:16 +0000
Date:   Tue, 14 Jul 2020 08:58:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/26] xfs: refactor quotacheck flags usage
Message-ID: <20200714075816.GC19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469032681.2914673.14228303787291427994.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469032681.2914673.14228303787291427994.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
