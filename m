Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C1621061A
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 10:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgGAI0k (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 04:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbgGAI0k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:26:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74A3C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QCRfT8pxUXaxhXi8O8P4MXNp2WFlIA8l66UB0kJ48cA=; b=qwypuVCVwHS3kJ5KwZS0ojqHVE
        wGXsu84zISPynv7V+TU3FPzOVA2LKJAXAfLDWWe0UCN28sEx1AOWQup6lQf7qxvzcSCHP1ggOdk8U
        SFEwh3shzuf66SDnV+4KgXNyOQxzzShTUZArI6n6yiCp4HgMxBvl7uxD3HYi8FJ1bTKrJ8WL9noA0
        JFt2Lmvuim/jnT4I8i+jR4PgwgH5VVFKOO+StgRc5nuSzC302dsouKUpcrxAzvgmkAir3vrn3jKPQ
        bWIEWVc3iWbXEpjbMNFjjay8V/DtFvlyxIi0C963bVdsvz3qCgY9oLio2AVj9SNYK8LjCG6OY/shT
        gCsP2U7g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqY4h-0006EI-ND; Wed, 01 Jul 2020 08:26:35 +0000
Date:   Wed, 1 Jul 2020 09:26:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        edwin@etorok.net
Subject: Re: [PATCH 8/9] xfs: refactor locking and unlocking two inodes
 against userspace IO
Message-ID: <20200701082635.GG20101@infradead.org>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304791141.874036.1859363040705399580.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304791141.874036.1859363040705399580.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:18:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the two functions that we use to lock and unlock two inodes to
> block userspace from initiating IO against a file, whether via system
> calls or mmap activity.

This seems to miss an explanation of what is actually changed.  From
inspect it passes inodes instead of files to the unlock helper, and
adds a lock two inodes helper, which looks fine to me.

> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -56,7 +56,6 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
>  		loff_t *remapped);
>  extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
>  		xfs_extlen_t cowextsize, unsigned int remap_flags);
> -extern void xfs_reflink_remap_unlock(struct file *file_in,
> -		struct file *file_out);
> +extern void xfs_reflink_remap_unlock(struct xfs_inode *ip1, struct xfs_inode *ip2);

This adds an overly long line.  Trivially fixed by dropping the
pointless extern..
