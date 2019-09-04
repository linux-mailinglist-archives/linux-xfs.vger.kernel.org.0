Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C505A7BE7
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 08:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfIDGpL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 02:45:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDGpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:45:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Q0OCJzGF/a2U2N1akVhdyLEEnbWAGWyR0QWgFDuIMuo=; b=E5uVpPvBHocOsD+UtrB+FcxAV
        gPtMkFfpA3F3FmOeBECSWOQhnO/xoEsQq/Rb3JoWJiuIqdCMXuqkPR+qRqmaLHsV84sZoWo649yVs
        pGoVN0wINzK+8QhIaHDi1AbTpDauX8znoTprtNrTzHAA7o7prONP56F0CdcJttFCCi+KeuzhFZ6Oo
        WIbEGghD8PJ5TW+Oe/wD8WlQPhTP9gBPM5Nh/tA+HXsjgK+o91XFHS1Cc6S6T2fiM153dIDq6mywC
        pu5YOJpyvijahfy4gmddaqIekGA0T58GvOy95u8Nzie8DoP5dlEZKxS4xuCfgNk00p+vmxfjq0u3k
        L/QAIp56g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5P2U-0004Jl-Uf; Wed, 04 Sep 2019 06:45:10 +0000
Date:   Tue, 3 Sep 2019 23:45:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: push the grant head when the log head moves
 forward
Message-ID: <20190904064510.GC3960@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-8-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn), header_lsn) <= 0);

This adds an > 80 char line.

Otherwise this looks sensible to me.
