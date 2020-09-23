Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4A5275214
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Sep 2020 09:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgIWHCs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Sep 2020 03:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIWHCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:02:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291A8C061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4avheywsxxnGZmnjb5on58L7dEW4D+J88j+OPm7JpSM=; b=TKsrmIPDnsSSNcbzh+iwUHmWXs
        wvW2rQstaC45oO9MP4JDCzqFTTUNfU8L80RVOdpW7yebjOZXISREwuCkvLNV8olfTg902r8xK55SC
        rXfLGTv4CUawhWsmsjSzBR1yl5GMKwMGioFPnvl/JzRuRrS8e/1vG1+zIJA6fYvz691wyXFiqXFBY
        mkI8xsTv8fSjit9mck5x81rSCM5H3ZyKqR4IyOoVgvScSJVc/S2YfA2J4PekA722B3xqxWqEXebCB
        Sw4svw5OIJrqQ6X3zL6t90hBf26NWjg4ix8xirly1/nuqeP54hQsG4pVdGrsJWlzI7pgGtNFhBTC5
        eswbJpIA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKynU-0007FK-LN; Wed, 23 Sep 2020 07:02:36 +0000
Date:   Wed, 23 Sep 2020 08:02:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH 2/3] xfs: remove the unused parameter id from
 xfs_qm_dqattach_one
Message-ID: <20200923070236.GB25798@infradead.org>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
 <1600765442-12146-3-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600765442-12146-3-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 05:04:01PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Since we never use the second parameter id, so remove it from
> xfs_qm_dqattach_one() function.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
