Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17E128EE6D
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgJOI0E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgJOI0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:26:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7ACC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=iNwlwufBWrhXa9jmH/i9k6c3cg
        spyuKS0G7t16B3LBf7Rbtw5nQaWB2KSsW6KY/piWrA7pLv+RZ7R1pEDSN86YmVgTXONIRm3geya6u
        UeI/Rot2Yo1kTy6VYgxYDqNKcfMx7We8DoIbnADKg7mFwYcx5wBHO2AhGh5M4QCpklmT6YLgjbTpc
        LtCglqeGJB16YFEMYudcBOcsHzlCGgRKQoUVYXeuPVLHqpRUbgTjCs4z12olKbItN8nTai1QUCL+L
        NEfFqXGmV8QBca2/5MHKkz/68kmqY9lKLW8gMhNMeDauoiqKllSsWgC4eMMYq5HZMMUrhuPpbkCI7
        RjpiliDw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyaG-0001Bu-0E; Thu, 15 Oct 2020 08:26:00 +0000
Date:   Thu, 15 Oct 2020 09:25:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
Message-ID: <20201015082559.GA4450@infradead.org>
References: <160212194125.16851.17467120219710843339.stgit@mickey.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160212194125.16851.17467120219710843339.stgit@mickey.themaw.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
