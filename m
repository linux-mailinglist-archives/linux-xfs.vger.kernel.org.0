Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 471774A9A0
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 20:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbfFRSRd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 14:17:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39928 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRSRd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 14:17:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gTPWxx+4Wck5LgKwgCJ01sLP8TQjjuy+FFN93OCQRTQ=; b=iSAVRMphYsTZEeSy4gazvhXuv
        Yep5/YP92Uha2SOd29YbZL0NjnB8H1VgjzMCHas93qgK+4gI+YZPKtaSQTCuISS6oDou1wsjpnMT4
        CK6cclIZcpIgkrL2Ln11myMCE0j3tImZ7LcRKMk5EBGSurrudC4oHKjx+IwmPZY2U8lTjAeVu5fsn
        zuk1tJEfgCDYaXnNkG6K2QiVJNFYU4hpUV/7sz6y3uUaEDUXJsSw5kqGSzU0qOb3FaYEIXwgMTzX8
        0+b7AupYzOTdshSW56EaPWTKkEFeQx2vvbOj6kmxDTcmFDXmt41oRMXvA2Vvi1F8q+iHjht03lfDQ
        sB+dEtdzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hdIfk-0000Ft-Th; Tue, 18 Jun 2019 18:17:32 +0000
Date:   Tue, 18 Jun 2019 11:17:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/4] xfs: separate inode geometry
Message-ID: <20190618181732.GA873@infradead.org>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
 <155968493890.1657505.14039176301049696712.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968493890.1657505.14039176301049696712.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sorry for spotting this so late, but this one is pretty bogus as-is.

The geometry information is not an on-disk structure in any sense,
and has absolutely no business in xfs_format.h.
