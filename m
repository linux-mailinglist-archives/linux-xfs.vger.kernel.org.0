Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E43026D5AD
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 10:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgIQIH3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 04:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgIQIHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:07:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194C4C061788
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+PQECES7cZuFaT5MRFnApndgufxF6VEPrb4LMW88uXw=; b=wLADQrWZouw02SbNgPXODof+VW
        tHZfW0xyt6/7QG5JT4DmSmsPN2DpkUbxMibHoDRYxge6QygqEN8eItE+imA8HdMdlbSvS9Nop3KfJ
        IiLDrgLPt2EOv1YXgHWRml/vLpR+8ylwhJh7R6nicEpToUwrhlFQKTntaJFYrxwX5TBc49rpGIrYr
        GwWiy9mwwytgRPW/m/T/d4qchHijBXoJ6DhemqJxjVmPW20duLXbnSgd5HqBX9BzcJACyV2PT0duj
        eS58KpWzsGhbC+lloLgupq86e5m4QOz6zaB3oXEVkFybx+DX/GiGqqxBxQwzvCRuHtlfBBSiCjsQM
        2VRD2VpQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIowZ-0008AC-M4; Thu, 17 Sep 2020 08:07:03 +0000
Date:   Thu, 17 Sep 2020 09:07:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the unnecessary xfs_dqid_t type cast
Message-ID: <20200917080703.GA26262@infradead.org>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-4-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600255152-16086-4-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 07:19:06PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Since the type prid_t and xfs_dqid_t both are uint32_t, seems the
> type cast is unnecessary, so remove it.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
