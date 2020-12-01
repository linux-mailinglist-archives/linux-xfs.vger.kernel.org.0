Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFF82C9F07
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391107AbgLAKTp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391103AbgLAKTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:19:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2649EC0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=pkBBiX+ZYU79s72AEhXBgtYZMy
        L9FNZjaE5A1THFNuIxzQ/QHeypalGPbwRp21CMEcEKI3a4x2DTP9rNAdwtWwhRt6n+pLdyWntJq3g
        nEQ1iaGBOPGpi8f3OhZ+0fRZrathNOQ1sZBwnAHaOr7qpKTUDUzG/dnkEKW1SCG5kp6wCjB7eB8BT
        8uNHKdKUGqIQR9AeMvvX5OPzstXMoXWgT0CMhAG5/kfpv9OqYrOr5xi91X5ibXcV6ET3RGNx4pmCs
        P+xw/ky49QoZxECI/NIO72A4HJMj5DAr9CouliJLWhH7NaAPn1ABdoG6IF6/E095h8kRYmg+LiRaP
        Y324lt1A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2kQ-000413-Mo; Tue, 01 Dec 2020 10:19:02 +0000
Date:   Tue, 1 Dec 2020 10:19:02 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: convert noroom, okalloc in xfs_dialloc() to bool
Message-ID: <20201201101902.GE12730@infradead.org>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124155130.40848-1-hsiangkao@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
