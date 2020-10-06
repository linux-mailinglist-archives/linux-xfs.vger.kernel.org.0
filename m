Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE6F2845F9
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Oct 2020 08:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgJFGYt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Oct 2020 02:24:49 -0400
Received: from verein.lst.de ([213.95.11.211]:33169 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgJFGYt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 02:24:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5BD1A6736F; Tue,  6 Oct 2020 08:24:46 +0200 (CEST)
Date:   Tue, 6 Oct 2020 08:24:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20201006062446.GB7033@lst.de>
References: <160192203063.2569680.11574287082065783377.stgit@magnolia> <160192205008.2569680.4888893690951984814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160192205008.2569680.4888893690951984814.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 05, 2020 at 11:20:50AM -0700, Darrick J. Wong wrote:
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
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
