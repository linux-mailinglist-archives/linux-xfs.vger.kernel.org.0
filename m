Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1475275239
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Sep 2020 09:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIWHUR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Sep 2020 03:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgIWHUR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:20:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5DEC061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aps4JCxE42CR6G3zLTm+vDUYbinojX6AqQY17jZ0vAE=; b=PWv4yyTKS0GvdNQeE+As/gcuEm
        ZKseuy4Cw2xtQwyhcctRtGgk+6pjiUkN4Do9pSXOJwHm+nikBKpnKCjTvsAN6xQeFRm3Jgs2fMeF+
        lfcaFo9XU+WwGgmN6dqq70ewiDFol7XmHxLPain2xaUFkIK7oOKGLuW8TxGVvPCKC5+ySHfcQa06v
        Ft/Lvj2WOQD7C1tl/MjdWMxRditxCqreBploDNaXFYWXowo2eY18ya7D6tee5OU0IDEjwFlyJ5nY7
        ouit6gqwjpnn+ZNUs+uXXCpogpobZbV/DyVr6PF5Jt6ZslwJ+QJkL6g6K9UJDhLoljgzF1DES8Dbt
        vW5tRvnQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKz4Z-0008GP-7R; Wed, 23 Sep 2020 07:20:15 +0000
Date:   Wed, 23 Sep 2020 08:20:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20200923072015.GC29203@infradead.org>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031338272.3624582.1273521883524627790.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031338272.3624582.1273521883524627790.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:29:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_bui_item_recover, there exists a use-after-free bug with regards
> to the inode that is involved in the bmap replay operation.  If the
> mapping operation does not complete, we call xfs_bmap_unmap_extent to
> create a deferred op to finish the unmapping work, and we retain a
> pointer to the incore inode.
> 
> Unfortunately, the very next thing we do is commit the transaction and
> drop the inode.  If reclaim tears down the inode before we try to finish
> the defer ops, we dereference garbage and blow up.  Therefore, create a
> way to join inodes to the defer ops freezer so that we can maintain the
> xfs_inode reference until we're done with the inode.
> 
> Note: This imposes the requirement that there be enough memory to keep
> every incore inode in memory throughout recovery.

As in every inode that gets recovered, not every inode in the system.
I think the commit log could use a very slight tweak here.

Didn't we think of just storing the inode number for recovery, or
did this turn out too complicated? (I'm pretty sure we dicussed this
in detail before, but my memory gets foggy).
