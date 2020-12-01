Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284CB2C9EFA
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgLAKR4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgLAKR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:17:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45E3C0613D2
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ALjtE/RLH5iBgGnpO0dwIByehavzI/jnbO1CeAlOphg=; b=j51j+R0ZwleIi8CPHsRrq8J8gB
        PWvVOgKTapd/5BAK1yfEhh4Pdc4yLmLoecPCqF2Q2NKdOv8TeHsyMvdIENRTny2S7ZC4F55OpEMS7
        KWTbZqcAAo/AnglCmd+sC/XRZV15wEDX20dC/aY016nQ/xSpkNQHxspucYMr94wAF+nUjLxbj/JNn
        pio9V7emU3sM4pXpj+IIBpLfKxQokHs6CD7BMEBd+S9fbEbL7uCNONoTGYi7DcW040SckQJvf96Ds
        b4G8/8V5UW5x9JC3blrw8U9iV3wK7dJvOtEUZk/yYgud1iynRDIlwcY4qgjid7P7kwE5ijff2IRbv
        T99Ib9JQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2id-0003ui-Kp; Tue, 01 Dec 2020 10:17:11 +0000
Date:   Tue, 1 Dec 2020 10:17:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: add an ls command
Message-ID: <20201201101711.GB12730@infradead.org>
References: <160633671056.635630.15067741092455507598.stgit@magnolia>
 <160633672276.635630.209542592059319318.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160633672276.635630.209542592059319318.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 25, 2020 at 12:38:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add to xfs_db the ability to list a directory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
