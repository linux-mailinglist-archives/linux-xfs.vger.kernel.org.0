Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DC21C73A3
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgEFPK4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgEFPKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:10:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D06C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I3m+bh8vS1gnf2auul7CPhmXXK4H1cog6UZ/oDsZaQc=; b=S+RrioJiQTUvu2Zhm5jYi7fCCP
        0Y/KPKiy718c7xUBxMP8FbCIkk4B375b2gs9skuavfJeO0Yh/lcGcZRkPCOfcnuxPWk+oVUat5Hnt
        KUZ6edmlVlNDLCw9xbTtbjSevxRtF0BiqxnoUhC6oH+ndqfpTcvHKcw0Lv8O9sFtim1ij947Tsyc6
        k1qPGB1mNDMQthpQSqm2xDutnU9L0PN5uhlWgDfolVVcMIekrxeIvxqwJnFXqrx4xdGKH8NNTQeTi
        A6/9T7Uy3fWSQQ2JsmTz9FSA7WkrxGs0VhaKdb/gvVEACVJnVKqaFvxiJJuv+jMD2t0oyLNpsuuyb
        2Du4XaIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLhH-0007lD-Pk; Wed, 06 May 2020 15:10:55 +0000
Date:   Wed, 6 May 2020 08:10:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/28] xfs: refactor log recovery inode item dispatch for
 pass2 commit functions
Message-ID: <20200506151055.GI7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864107031.182683.11762407692516826021.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864107031.182683.11762407692516826021.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:11:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the log inode item pass2 commit code into the per-item source code
> files and use the dispatch function to call it.  We do these one at a
> time because there's a lot of code to move.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
