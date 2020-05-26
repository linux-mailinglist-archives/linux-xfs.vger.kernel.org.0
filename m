Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBAB1DF63B
	for <lists+linux-xfs@lfdr.de>; Sat, 23 May 2020 11:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbgEWJT2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 23 May 2020 05:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387498AbgEWJT2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 05:19:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105A2C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 02:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=qa9Edr0s1zx9poEmsxs+TExJDv
        Km14uvXksEtxsp+NkW9xif4VJBdUgAV5jbG3JnQZo9ZcITrea2I2Wy7QhHDi7fsF4gAodfjKRbDDP
        CvOwcQod77O222cbH9QOjC7NA6eh1s7NHG80gvYUNdZvbfx4Ub1/uTuYN2bLMGWodg6LcnGuWkOGN
        2pfiRaw1n7PXj2msFkqxjeF2QEdmzszWlhaFzb0J3lDGakuNs4AMl7B6dOEHKREO1PL04C6dG7d/b
        ANnJTxd6MXyxOuCKPcBtEjY9WzVoxdjT4I7aQC5Xx7b00tdfFNppToH1JIcr3nas7cpDLmv64NPXa
        bwRi6RFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcQJT-00025A-Uk; Sat, 23 May 2020 09:19:27 +0000
Date:   Sat, 23 May 2020 02:19:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: get rid of log item callbacks
Message-ID: <20200523091927.GC28135@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-12-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
