Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5045B54D17
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 13:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfFYLCh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 07:02:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37014 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbfFYLCh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 07:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=jjpWZ/wxCvC/8vpoNCKFnwc6s
        UX1YMpOlaWpZqApA2Y3r4XBEkOG7ZctB8fKZwyPtiesM6ebH1D7Jsm3oNxbha1x+fQgFjLFEkPqOd
        5xwEAosn1ltdkTk8yH8F51Q5OWMDAAbVAYivN5/691pcbhmUVAJOabhQbJxr0u3PP5qLJtQYmsYee
        Zxqe5rRC5lrsvzcyVWkKM3BJ4IC1I5xXsbQ8UvIgkl2Gzzu1sV0tqktY51+HStPpxWWyoPWyMpEUc
        oHOwdWbriyzgZEShkBOya1rwCyr2CMBLhloabulnuoBRv4gKVVzgLJsIuajUV0O/9316nV4kkRjCr
        6PtR1kKJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfjDg-0002pq-SE; Tue, 25 Jun 2019 11:02:36 +0000
Date:   Tue, 25 Jun 2019 04:02:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] libfrog: don't set negative errno in conversion
 functions
Message-ID: <20190625110236.GD9601@infradead.org>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104937602.1172531.10936665245404210667.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156104937602.1172531.10936665245404210667.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
