Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BF61907EC
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Mar 2020 09:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgCXInp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Mar 2020 04:43:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgCXInp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 04:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=AKawQhPILI4CChfx0/mZEP7NlO
        /hHk3LfVXHUMlPxfKRREPFfJUl2lGrVOJvRdXKIOiXFRKS32Jze9hyWD+P6eUVVd/A/IdqhvWfa2i
        /HPTmtSIIf8DQL3+zh7/XLzIbHnqCa6aHLPsj4HNC4188Q/PC2yfq4rnF3eP5IRKn0Rg+mPtXdBVe
        ne9PNk4s39yGDNaKXPHnHtf/XsnN+0TjIAEaND3NT2IQx0sYjKbjbQXk14zKplOhpLs5LbQ/GUhyb
        G9qCzruGBWw7bTQxTjtospmVKKyTvWX38dCdZpLXj/Wo1iwJlkZZJFM0fUk45oSNSH5wzTFfVyZri
        /KQhvvEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGfA0-0003ii-V4; Tue, 24 Mar 2020 08:43:44 +0000
Date:   Tue, 24 Mar 2020 01:43:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfsprogs: Fix --disable-static option build
Message-ID: <20200324084344.GD32036@infradead.org>
References: <20200324001928.17894-1-david@fromorbit.com>
 <20200324001928.17894-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324001928.17894-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
