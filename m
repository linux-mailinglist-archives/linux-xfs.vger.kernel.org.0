Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC61E82D2
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Oct 2019 08:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfJ2H5R (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 03:57:17 -0400
Received: from verein.lst.de ([213.95.11.211]:38630 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfJ2H5R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Oct 2019 03:57:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4C9BC68AFE; Tue, 29 Oct 2019 08:57:15 +0100 (CET)
Date:   Tue, 29 Oct 2019 08:57:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: remove the extsize argument to
 xfs_eof_alignment
Message-ID: <20191029075715.GC18999@lst.de>
References: <20191025150336.19411-1-hch@lst.de> <20191025150336.19411-4-hch@lst.de> <20191028160638.GC15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028160638.GC15222@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 09:06:38AM -0700, Darrick J. Wong wrote:
> Why does it make more sense to do the inode extsize roundup only for
> direct writes and not as an intermediate step of determining the
> speculative preallocation size than what the code does now?

No behavior change in this patch.  xfs_buffered_write_iomap_begin
already passes a 0 extsize to xfs_eof_alignment, making the code moved
from xfs_eof_alignment to xfs_iomap_eof_align_last_fsb a no-op for
the buffered write path.
