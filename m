Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9F2270B18
	for <lists+linux-xfs@lfdr.de>; Sat, 19 Sep 2020 08:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgISG23 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 19 Sep 2020 02:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgISG23 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 02:28:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F28C0613CE
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 23:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qEv84X9D7MpDeu86+xtPvvnRYnS2vwyzNgdpTbDz6+c=; b=VUub5fM6k1uZr2vr6VAOZJbqN9
        uk5AuTspMkb1qRYbrVpsgwRoOlARa4Nr+uagzCpE62SJNjcoOffS+RLEVWkAf6Tk87YglEC4ntqe7
        Da2aad1Nt4TfgQTgvewqELLmT2mtBTheSznMppwsLqqd9UxWbNRmwOOKurtI2P5UPZgKkZxDJMr6W
        JHUL/C7kt9iQ7w9/c9qaedDmGkmf9c6VU/ilvPp/aelj/lgeUxUufXdwPUludAQaKjP/1F2RbQTIw
        6TS1Yf5BRCtFVmgE/17NbvSZ1d6S0I3ZDDG/IrQUE2JjnwrH4FW+oNklzakYBPCpBy5ZXRwRW/gHP
        oGxV5ixg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJWM6-0003fR-D9; Sat, 19 Sep 2020 06:28:18 +0000
Date:   Sat, 19 Sep 2020 07:28:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 5/7] xfs: remove the redundant crc feature check in
 xfs_attr3_rmt_verify
Message-ID: <20200919062818.GC13501@infradead.org>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
 <1600342728-21149-6-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600342728-21149-6-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:38:46PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We already check whether the crc feature is enabled before calling
> xfs_attr3_rmt_verify(), so remove the redundant feature check in that
> function.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
