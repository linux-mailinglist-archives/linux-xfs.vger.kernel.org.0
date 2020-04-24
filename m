Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56631B6E18
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Apr 2020 08:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgDXGXG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Apr 2020 02:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726659AbgDXGXG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 02:23:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A15C09B045;
        Thu, 23 Apr 2020 23:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6ksNm3BBT/lrPcyj1k2Kw1jDxVjgGPPrPYeKfaTWYcc=; b=QCpuGEaMlk3ynU5M2kT76Ps2K2
        l9Pefr+MlWiU+oiim0H6xNwWU+0k0Uo7IoZK0gJZXaXlnAmAmeD2vBKa8gsOi0cwCiqDul/WJx4Ag
        EdGKZioaPM8nt9QDkma75xWeeon6qQ8RawRRQARhBAEptIstYvU1952+BhBwNpODkZQCBHvxffkKM
        s7+BKPdPUhEyj85Bv0wkio7PAcb9JCxyRyYmFUYM5GS7R8rf6KFmY+qMT04LRFueP7vIr9BCZUVkz
        XHTJW3u5GKvCVouBCkuXiNKVtD62fyxLlpyzXNVXb00ZXbWAn0ucQJkWnB0yn5LIvBosx5LI9gpYO
        zL2r5etQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRrjs-0003lT-9C; Fri, 24 Apr 2020 06:23:04 +0000
Date:   Thu, 23 Apr 2020 23:23:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs/122: fix for linux 5.7 stuff
Message-ID: <20200424062304.GB2537@infradead.org>
References: <158768467175.3019327.8681440148230401150.stgit@magnolia>
 <158768470283.3019327.12107082366634108750.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158768470283.3019327.12107082366634108750.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 04:31:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix some regressions on xfsprogs 5.7.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.  I actually had the same changes locally but forgot to send
them out:

Reviewed-by: Christoph Hellwig <hch@lst.de>
