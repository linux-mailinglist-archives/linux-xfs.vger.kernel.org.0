Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F103729E794
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgJ2JnE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgJ2JnD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:43:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A27C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/jSj1q6SsWK734893fXGXGWHuwefMvikuSYBRQ46yRA=; b=S+mmh2oda8EmqBiCeusbi4/2a5
        k2YXjUH0s2n39fDmFb0kbPtz+CL18H8RsZ1/ik7IM0Q78uFG/gpXo9TxYwjxdIX+ZvhzG8pVxv6+w
        EU2n4vx5/XFGcDV6nCirdVgBEdtAnldiAmtI3cEibFk+qUq1/G4yvN10Hyx4qiM874ao06uFoLmXU
        mizD/fv50rjAaFKGl/I1GuKdpKVFmSsqx7ouUMT//PR+sQe36Qae0zClW2c2zAfCo6HB7JeJuaFAy
        iNXKnJGuUqrKmzdonDLcO412c+7ihzPLTJW5OMjHUdjTF/q+VMz6w0eDi7RYUygWdCnW9xj2BF/qE
        9GMicZlg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4SJ-0001Bz-RL; Thu, 29 Oct 2020 09:42:51 +0000
Date:   Thu, 29 Oct 2020 09:42:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, Carlos Maiolino <cmaiolino@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfsprogs: sync with 5.10, part 1
Message-ID: <20201029094251.GC2091@infradead.org>
References: <160375516392.880210.12781119775998925242.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375516392.880210.12781119775998925242.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:32:43PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> The first part of syncing libxfs with 5.10.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

This all looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
