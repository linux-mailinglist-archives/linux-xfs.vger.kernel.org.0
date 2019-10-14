Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0B8D5C2A
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Oct 2019 09:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbfJNHSa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 14 Oct 2019 03:18:30 -0400
Received: from verein.lst.de ([213.95.11.211]:47575 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729928AbfJNHSa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Oct 2019 03:18:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B40E768CFC; Mon, 14 Oct 2019 09:18:27 +0200 (CEST)
Date:   Mon, 14 Oct 2019 09:18:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: disable xfs_ioc_space for always COW inodes
Message-ID: <20191014071827.GD10081@lst.de>
References: <20191011130316.13373-1-hch@lst.de> <20191011130316.13373-2-hch@lst.de> <20191012002954.GM13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012002954.GM13108@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 11, 2019 at 05:29:54PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 11, 2019 at 03:03:15PM +0200, Christoph Hellwig wrote:
> > If we always have to write out of place preallocating blocks is
> > pointless.  We already check for this in the normal falloc path, but
> > the check was missig in the legacy ALLOCSP path.
> 
> This function handles other things than preallocation, such as
> XFS_IOC_ZERO_RANGE and XFS_IOC_UNRESVSP, which call xfs_zero_file_space
> and xfs_free_file_space, respectively.  We don't prohibit fallocate
> from calling those two functions on an always_cow inode, so why do that
> here?

True.  I actually have a patch in my tree that switches those to
be handled in the core so that they enter XFS through ->fallocate.
It didn't make any sense to send this patch before that other change,
sorry.
