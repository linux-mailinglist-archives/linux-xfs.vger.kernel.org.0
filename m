Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167753EA0BE
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Aug 2021 10:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhHLImC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Aug 2021 04:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhHLImB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:42:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D695CC061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=GHMGFSvpKKFl4J31jg/uvtsdKb
        tervHd38SczKk5BHrNwOXwfxrVcP72sieQSSFDWEKHxEit2d+D1auO29mG51IBd8lGH0KyN8qio7v
        IXSJb3cQywYn+sz1R8cX1ef5RPiB9LAyfcQuhlmiBYlZZJGwlSzKNtdOe6G9oKGQZbeiF2b+SgqET
        q/rHQtOvNE9BwKHFvlWIVIUXo9xHdImQw1p/yoy4rk19Q/YqTFBPW8KA++2RXKrCHCsi5t8hksZXX
        U3gYSvFJiWrv7p6PhXFCdvhbOsER1l3i3I6KZf9QCZaFHhy8BuxmzMsTTtc7nnLBWsBabTfG1q37W
        ejhRxilQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE6GK-00ELpO-NJ; Thu, 12 Aug 2021 08:40:48 +0000
Date:   Thu, 12 Aug 2021 09:40:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: make fsmap backend function key parameters const
Message-ID: <YRTefFA7CnCZZL0Q@infradead.org>
References: <162872991654.1220643.136984377220187940.stgit@magnolia>
 <162872993322.1220643.17973810836146274147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162872993322.1220643.17973810836146274147.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
