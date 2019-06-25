Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C0854C7C
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfFYKln (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:41:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57308 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfFYKln (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fZqPeNPPGpejasboz9ZWvZonD+HEUMiLeVI3P/fnpbM=; b=ebwYD05557RtVWTEw6Nd+vRrd
        J5qulJFz39OyX2hQTIrIcnaE5tdOJcGfwU7XNlpmIh1vMcYrsKaVeC1jvbKFQYv7Aqgvwrbplcmbu
        vyX287ZOmzbV0nXFtq3nWxIesmbRvTkvxZtMk0g/wX1vIEPpzMgwRCAWzKHnF0SaPq8PsRmbvQpqA
        GbIonmI9HnCVJQM1q6Srn1n/cOuiY4VsQAbbtYecVidfkCBYNNH9WG9qIcKU3n64EF7dIrsNF8i5d
        JPJloD+9a4ZcBA5dvsHauXpvFeQAUdqosVc41j5GGMN8ac4qhj1wDCjBJVugMNNXS058EiZEt4bx+
        5zwit6kCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfitS-0003Kl-Mj; Tue, 25 Jun 2019 10:41:42 +0000
Date:   Tue, 25 Jun 2019 03:41:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] mkfs: use libxfs to write out new AGs
Message-ID: <20190625104142.GH30156@infradead.org>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114705924.1643538.6635085530435538461.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114705924.1643538.6635085530435538461.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Nice!

Reviewed-by: Christoph Hellwig <hch@lst.de>
