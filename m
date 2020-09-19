Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E08270B1B
	for <lists+linux-xfs@lfdr.de>; Sat, 19 Sep 2020 08:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgISGaN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 19 Sep 2020 02:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISGaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 02:30:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A71C0613CE
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 23:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=GOhmYI4rHMTCn9pLJ3wXMKukwD
        he9IHtsYN+auNTaby/E2RkoImP6m1Kr7KqAa/7oCIDwdr4j9AyoOqiz/VPf17CqL0GgCwMiaWpFWA
        GmXOGnLiHHH1cDTB9FZsTP5jDtByACQHOlE6EdGh5ZcCe5B49z8RKYAvq3MbOn2H1QAxIk7mnDMBT
        P7SgfDpekxoBBPjqRosdzU3Aev6nQmV3ejnbbFg0YJTPK7zfxBR0cTtI0h/OwNAzQZXAHkyWefeGd
        QD1DWV3AEbUtSdX17x5K4y0tEnlXA8/+KPfMKJdqiYpt+RTEL3ozYb5oz7fYHeddm7UZHB2wphyL/
        m9eMtlDA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJWNl-0003kA-Nq; Sat, 19 Sep 2020 06:30:01 +0000
Date:   Sat, 19 Sep 2020 07:30:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 7/7] xfs: fix some comments
Message-ID: <20200919063001.GE13501@infradead.org>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
 <1600342728-21149-8-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600342728-21149-8-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
