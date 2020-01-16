Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2EFD13E184
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2020 17:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgAPQt4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 11:49:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45590 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgAPQtz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:49:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6xUTcLRdNKg9haKoDMUvcijvSjLIzT6HSGepdiqUuhM=; b=qjuL9Py6YGh+mT+37oRUurTaW
        8yzY7H6Nn2N+Lok/BAu1GcWWveEQ1DtXZqeo9aSiIApefBzD3gIJN5q5BvZC52AtKm1YrUpzMg6UM
        YMSvLcLxkImYPjfWakim+91v6RvSV+DjLzTeSg1Mc7zGjXnUHY3W03rIocY1KBLSbn3kWvc39epuO
        SqW+Td8kVLABzNKayqCe2pNV808hCxvKGgAB/SJTQDNdNMTg+mZDXZH9LQH3nL4TLLkJtttJkj2rv
        zeQrw9d+gSSjJAa9ySHOhUicpu8WautYoCihzkJBBVBGTNUxdpi6qwNFzklubg3WGWoFdYgo41KW0
        WXHMVjYwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is8LD-0004VI-9V; Thu, 16 Jan 2020 16:49:55 +0000
Date:   Thu, 16 Jan 2020 08:49:55 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 0/2] xfs: fix stale disk exposure after crash
Message-ID: <20200116164955.GC4593@infradead.org>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915534429.2406747.2688273938645013888.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Btw, what happened to:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=djwong-wtf&id=c931d4b2a6634b94cc11958706592944f55870d4

?
