Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19BA551A9
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 16:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfFYO2K (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 10:28:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45486 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729727AbfFYO2J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 10:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=UWwm+tDzPI+6EXkCs+tCq2XL9
        Vcg/KVmrga7p9vu7pJmQLbnKscf4X+wOkZa6UJ/ebTeChp3cMS9aHNNGQ00VXp4FEr9HBDAbuoopU
        bHagZBstRWAwyRjkqEWLB1U0iXEg7LfNQVwzN13jfQu221mytw0t1+b3ewzF7K2sBpigoOfWdD8xn
        3aSx64XGvyVFdVC3N6zIO7hW5K1HpCP6m9yhmxANkqpOcmKCQ6d3RcSm4iIaGUdxk5pAygPSTVNko
        tXPfBx+k19XCm+KTvvsy3X+my89yUSIZ6r+qXWYqMa9N0Zo31oqVy2F2V5g6tB6wNEMBdH2Tu4kJV
        u1nF/nFNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfmQa-0003Tl-D2; Tue, 25 Jun 2019 14:28:08 +0000
Date:   Tue, 25 Jun 2019 07:28:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] libfrog: refactor online geometry queries
Message-ID: <20190625142808.GA11059@infradead.org>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104938862.1172531.12358975440415614734.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156104938862.1172531.12358975440415614734.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
