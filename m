Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1579752FF2
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfFYKeq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:34:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbfFYKeq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/6VAIBDYLsl2k+Jd4TvkY4vdl59S4Sf3vU/eGn4Ihm4=; b=Z6ICy/Zmnx0PSUhIEbGfQOvqs
        f9bOnB5ep/UfUtiSJOFkQMh5O0vKP3euqNoU7griTJBk/gXNFOvlYrBP/MhIlncB3ahf/VSZPbwli
        JcPcxrYKMeGNicN2iPduoRmitxm3jK2SZFqqcs2/D4JFyV3BYvmWARm4KR+oTsAPXeLNJju1T6x1p
        QHsM4s4ylZfmI2eO1AZWerRiFM6piImzlzYPtqC+3gK1zxk3/XgEQ6luIC+x+Ss6AAAhpF84s6aAK
        JAdQxEUZGkhlyCY6mQybss73RG63yzbSKPZuZIHYmPXuE0oOy/jW/4tgFc0Frzrw6xUL8bAULOki0
        SbVdf0K5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfimk-0008OF-2J; Tue, 25 Jun 2019 10:34:46 +0000
Date:   Tue, 25 Jun 2019 03:34:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 01/10] xfs: mount-api - add fs parameter description
Message-ID: <20190625103445.GA30156@infradead.org>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134510205.2519.16185588460828778620.stgit@fedora-28>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is missing a cover letter to explain the point of this
series.

It adds giant amount of code for not user visible benefit.  Why would
we want this series?
