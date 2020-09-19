Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEC7270AC6
	for <lists+linux-xfs@lfdr.de>; Sat, 19 Sep 2020 07:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgISFN1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 19 Sep 2020 01:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISFN0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 01:13:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB2AC0613CE;
        Fri, 18 Sep 2020 22:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=scBfWh7sHcCSZAshZmmrF2PaXaPqtIe5tgMn0QFIf8U=; b=BzaJme7jO2z4sRs38H57X/ZKLp
        0nf2iNeTtnTfX2aoypKDC6lycdKLXF8/tdmdR+Gq+4J/lsCal5gjvGvNgHEe7d7j6o5+IjzxyWQWY
        MIYiPEv834vlgew3xp/pKmFTcW+TC12WUMc2sp/58wJRIGXnYIfSi4nXk85T2g4H212ydRyB/9bkT
        dXhw9JruGrKBw7YFfkfi2FZSKCBGSMd+O5x3XObyTQEWRNu8ON1a9NckmoFXP+bAlnbxtRzKzdvfD
        4e5hyYNjMsZB1S4hLSyGSTq7TPdrUAop7p6AdOuIjdMu76rbaDHL7m18LRltLt3mYKf/kRWdB3FeX
        EQz3myBA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJVBb-00080W-0W; Sat, 19 Sep 2020 05:13:23 +0000
Date:   Sat, 19 Sep 2020 06:13:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 25/24] common: kill _supported_os
Message-ID: <20200919051322.GA30063@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <20200918020936.GJ7954@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918020936.GJ7954@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:09:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> fstests only supports Linux, so get rid of this unnecessary predicate.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
