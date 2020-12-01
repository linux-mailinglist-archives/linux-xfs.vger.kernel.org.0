Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3862C9EC6
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgLAKHm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgLAKHm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:07:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673DAC0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1AGxxEq49EJct63bqReFqGKvvscoer5fzCxnf8MPsjg=; b=VDLHxtUNKtn3I4KaWSRw+Q++dN
        r1hYwBYoWZXjakzDmEQkwNPs1Ep/UgcAfpkiVjX7US2Wb5n/uY7WA484vexbAsgC0yuiWkjbDGyqR
        geJWTlLTR3lnJ0oOPc7Wv+ZbD7qA0g+/JtOcVAM8TxTvwMXQthunGR7NxoaGbRFhQmHkr4a8bwV9j
        yIvqbs0Ur/H++NDyPq/J5yzXNRrTMdxn6LqfzGcAOa4Ani3ZfdLZAtXQa38f5eHhID2HeVhGsIGLF
        cgZbQOtdIwID8jSLJywoUPDGwvyLU9jj930J+ddf9UTweMuEa8E48iHa9mbukVSo9eDGHM6toLNhh
        67ZeDOSA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2Yn-0003F8-3Y; Tue, 01 Dec 2020 10:07:01 +0000
Date:   Tue, 1 Dec 2020 10:07:01 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: improve the code that checks recovered
 extent-free intent items
Message-ID: <20201201100701.GI10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679390871.447963.15070829026899571950.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679390871.447963.15070829026899571950.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good modulo the end nitpick:

Reviewed-by: Christoph Hellwig <hch@lst.de>
