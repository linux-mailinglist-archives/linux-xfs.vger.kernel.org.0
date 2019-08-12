Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7858989D
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 10:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfHLITz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 04:19:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52902 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfHLITz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 04:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Pm16XNp3tdyYf3anO0W3YuwxKGiixpPX1HD1r7bgy4o=; b=chQ6XXDKGfeq5Lv+yRw7RV4xm
        ukILzBRrVYE/8v7Jdau/R/Wo48S2OWvV9/uYC9pL5S8EV8WNqqCNjJbGslIrdDCcSA7XwCcCX7Q9Z
        6NUEEiEfMV/B8TO1m+x5dStqFGQa/JDOLwIJ+dNuN0Ooc7AfbusDCqsTpEqbpsin6GdbKha60IFh0
        udHDwzl5v75UEoyDATw8JqiPGZXLGEsgicWe1F0yX9I0ul4oHzowL06qdOdWbjb+ySVFgFCt00l3L
        9kUgcqGgXbIJhsL+81lAanlx15WEancTd7H3NJYWEgF9K5gZlOiBh3tIeZ8a3ev9UgedZyQ0wrWdd
        CNw2ksKkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hx5YY-0006aS-Dc; Mon, 12 Aug 2019 08:19:54 +0000
Date:   Mon, 12 Aug 2019 01:19:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/18] Delayed Attributes
Message-ID: <20190812081954.GA9484@infradead.org>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Btw, this seems like the right series to also look into our problem
that large attributes are not updated transactionally.  We just do
a synchronous write (xfs_bwrite) for them but don't include them
in the transaction.  With the deferred operations and rolled
transactions that should be fairly easy to fix.
