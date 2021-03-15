Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716E033C610
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Mar 2021 19:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhCOSuB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Mar 2021 14:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhCOSta (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 14:49:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9603C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 11:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vTSUfKhX0AUGrpPYbna2HGWm/oAA8FPyDNGwjkcfcDg=; b=W9H8KgGZO/jBMnPFAUIg7CMqp5
        7w0PjIhlcUEIC1pxZcuJAX9hSbdDyLnH9TyUNuapmBTE1/Ipm7uPMzLBw8w/oqYVHyy2jhhsgR3RV
        xq9WuI02qdG4Nv5Z0EfjSNoh64N2yy1tKiqZ2BuhLXCOa0tTwfB3MWzzwUvPpQ1Lyy78kIJ6eVVrx
        N30HCSYJ9EafFUGpAaegnyY1GOPUvRMHDyRYUdrdjPiO+7dHzTgYzar5JmKNXZ34XxoAcHUIlesHo
        RDE5pT8JeNg8Llfw3G593YGYtwldklURzFNeEek6ulEab0r0FmWZNOu4r2oQ4qDJtg2zNH21NL/EO
        6igNHphQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLsH9-000cFi-4C; Mon, 15 Mar 2021 18:49:19 +0000
Date:   Mon, 15 Mar 2021 18:49:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: rename the blockgc workqueue
Message-ID: <20210315184911.GD140421@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543196819.1947934.4325937657338405659.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543196819.1947934.4325937657338405659.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:06:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since we're about to start using the blockgc workqueue to dispose of
> inactivated inodes, strip the "block" prefix from the name; now it's
> merely the general garbage collection (gc) workqueue.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
