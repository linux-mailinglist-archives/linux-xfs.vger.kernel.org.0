Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 684B6E4B90
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 14:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504635AbfJYMy0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Oct 2019 08:54:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34392 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501908AbfJYMy0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 08:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=QVjcmyHvxkYzBVDBxC9ZjfPOL
        fxtlbqhPpJS5Kj/dys2xeGzQIxsIahnfEfJy/LXqORQZB1Psy1mMabYSxjgB0vM+d+enN4MFk8oSh
        b5PUKJJFsPVCeUFaSNJSruPa0aRwWB2K0Q+wnWG2ws4PNdOqtfSXPiaXnpYtZb12+BZJWemoRpqX+
        CIV2bcCESNhzNv36GyCDONyvUOg/DrPL3z+hPUGgSysAYLhOTzyvujlc+nYNFqRpo8Nzr5ksL7Aoh
        5aOUIHGLuUkbFPrHdppMkRr5ub70HNhYx44Ek1KGDOXOKMAS0m0p67f48v1fFwofrCrRVhpXqp1hO
        FVwRNB+dA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNz6o-0007Tr-Bk; Fri, 25 Oct 2019 12:54:26 +0000
Date:   Fri, 25 Oct 2019 05:54:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: replace -EIO with -EFSCORRUPTED for corrupt
 metadata
Message-ID: <20191025125426.GC16251@infradead.org>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198051168.2873445.9385238357724841029.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157198051168.2873445.9385238357724841029.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
