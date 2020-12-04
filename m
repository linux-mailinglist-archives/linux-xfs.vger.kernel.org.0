Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6408D2CEBE0
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Dec 2020 11:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbgLDKKY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Dec 2020 05:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgLDKKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 05:10:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24750C061A4F
        for <linux-xfs@vger.kernel.org>; Fri,  4 Dec 2020 02:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lwuOIzWElIpaGSL6SJj/tB18DqjuLKsW1NBdsQA2nx8=; b=TEVM2q/NqyzvyS5oG7Xg70N+ts
        q06qnqaD10lBMEXVlRYCTxBrZWR/sZl2NtNfB9cjk0BRg2eQNGL24eEUm5u1ZO4XtFcmig2EAH8Vc
        Lxk4F1jnFgy6i4CU9o5RaKa5ZSk3EjL5UxU93cKhXVhrlboGncj80KNxMVqIgFP0R4cCkzS+yTFE2
        vLFKOibfqeEdTXpgUBx7jlcePlEaRVGqOdV7AEAB7dmvK7sZEbohZfyCsEkBhfdxpTGr1pybrh8VT
        Tw4DlOYy7cY78cHZ/htd4k2fTvpEW+4vqYRUQm04Fe6/DqSTxlqUt4oRsUvzRmyGfhjVoMzcmo7vu
        aUFEZYuw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kl822-0000ZB-Rv; Fri, 04 Dec 2020 10:09:42 +0000
Date:   Fri, 4 Dec 2020 10:09:42 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix parent pointer scrubber bailing out on
 unallocated inodes
Message-ID: <20201204100942.GB1734@infradead.org>
References: <160704436050.736504.11280764290946254498.stgit@magnolia>
 <160704437622.736504.16651484693320221547.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704437622.736504.16651484693320221547.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:12:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_iget can return -ENOENT for a file that the inobt thinks is
> allocated but has zeroed mode.  This currently causes scrub to exit
> with an operational error instead of flagging this as a corruption.  The
> end result is that scrub mistakenly reports the ENOENT to the user
> instead of "directory parent pointer corrupt" like we do for EINVAL.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
