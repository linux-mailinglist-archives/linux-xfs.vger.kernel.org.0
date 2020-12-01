Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED502C9EC8
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgLAKIM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgLAKIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:08:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEB8C0613D4
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dIv65O1T+LdBIqPI+hsAzuLlyj3IGKomgVNg1YJwX2E=; b=DShvy7aWgWJKz9fCaaE3i/VHDU
        wiRXm0jk3SS7N201sqD2p05ZWFlCKY5tTc5SObA+8dL1pdxu7N4AaE39UxPK4bRFq4J4Jesn/+nWl
        795O9HcPyArjeK3yw+qa4Tkb/HBS7w9I5m1BCIGYN97dU4Gm61ZmW5wieCHDKI8Mz3C8k+7KnZEGf
        KfF31xe+OKkvcbx/pCgW8KQFngDkgVh5grNqFI74fjT22yFk9pZqbFu8WzZB1W2e2GfKRqbOAfNAH
        ivp5Sv1uaHEr6vUXWivUC+eJMBZEunXOEu71JXyH7MmvYauMf1bfP2aKFwuVZbdrDZA5wdDTKP24i
        XBsNiZFg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2ZG-0003IC-I6; Tue, 01 Dec 2020 10:07:30 +0000
Date:   Tue, 1 Dec 2020 10:07:30 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: validate feature support when recovering
 rmap/refcount/bmap intents
Message-ID: <20201201100730.GJ10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679391475.447963.3291546751575520166.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679391475.447963.3291546751575520166.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:38:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The bmap, rmap, and refcount log intent items were added to support the
> rmap and reflink features.  Because these features come with changes to
> the ondisk format, the log items aren't tied to a log incompat flags.
> 
> However, the log recovery routines don't actually check for those
> feature flags.  The kernel has no business replayng an intent item for a
> feature that isn't enabled, so check that as part of recovered log item
> validation.  (Note that kernels pre-dating rmap and reflink will fail
> the mount on the unknown log item type code.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
