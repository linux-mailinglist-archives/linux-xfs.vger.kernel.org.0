Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5651A201891
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Jun 2020 19:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388022AbgFSQtt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Jun 2020 12:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388016AbgFSOjR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 10:39:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFF1C06174E
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jun 2020 07:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RpOQGm/Y5iq2zlnZbid+1EfPF+Z9i3lHo1/Ym2scOQQ=; b=paeCvWHxEJqIggvRg+CNdCId7E
        bjzn4Ae6LEWIXgiLxBLeLLmoLflKB/UkIptdG0xx4A1LZwp1dywR9OZ7Fjyxyddzwo8tZtRLjyAo1
        +EzxFnhQu8eigUJiNVZHhjULlWr7nK0AyiVEt0Gm/imtfxP0UdAxaiKMWG08w93vZsswShfnAL3RM
        ow45VQZC7sFwKLkcfRaeRuebWV0ZmDa/AtdGnPh03AX0OMytN8ii5z6EiGO0YnZSnaEMnEdMOHAxi
        rjxOl7JL5kDn45SZajprM2jyi/fYwIm1onoEHfaUyR7kwx1OgVgZhK5/5RKU3BpQD0PbaXvuiedq/
        GyCQnPLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmIAn-00030b-Pr; Fri, 19 Jun 2020 14:39:17 +0000
Date:   Fri, 19 Jun 2020 07:39:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, hch@infradead.org
Subject: Re: [PATCH 7/7] xfs: Extend attr extent counter to 32 bits
Message-ID: <20200619143917.GD29528@infradead.org>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-8-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606082745.15174-8-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 01:57:45PM +0530, Chandan Babu R wrote:
> This commit extends the per-inode attr extent counter to 32 bits.

And the reason for why this is needed or at least nice to have needs
to go here.
