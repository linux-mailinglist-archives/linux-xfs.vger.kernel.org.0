Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CB52105CC
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 10:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgGAIFr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 04:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbgGAIFq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:05:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7797DC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=OLVk0GwvvtFpbm+UuRyGZ40OlU
        xsgsoksBCqQkGDyXh+0Hev2JEtNvxu6VQAM/+DxLVUnc0b/07Sa9H7rGDMkBdp9MDzBK+WSLLpjji
        7jxHp0io2p10M+cKjylCQWb/uP5xZJPmZX37yZ7GdqubTMPEmrwc2R4ezd6jMrh0L7D45TyusnzSq
        wZQCYDF0oq1P3sDXBjw4zgEWHZ4Z/0lWt1TPebXJf7va1DHNiFwI7+8yqqEbsKSVFfQx50evrb0b2
        TbjSbG1k8m3yxBtHaR5kY0qh13jWPDQUGWo7tY1l47BHI/8eJsSBgSpxXUF0RVWNlW/toMpy9AP6w
        PyWq+OFA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqXkW-0005CA-EG; Wed, 01 Jul 2020 08:05:44 +0000
Date:   Wed, 1 Jul 2020 09:05:44 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix quota off hang from non-blocking flush
Message-ID: <20200701080544.GA19229@infradead.org>
References: <20200701075144.2633976-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701075144.2633976-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
