Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB314179361
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2020 16:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgCDPaR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 10:30:17 -0500
Received: from verein.lst.de ([213.95.11.211]:55075 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgCDPaR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Mar 2020 10:30:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2728C68B20; Wed,  4 Mar 2020 16:30:14 +0100 (CET)
Date:   Wed, 4 Mar 2020 16:30:13 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: don't override sis->bdev in
 xfs_iomap_swapfile_activate
Message-ID: <20200304153013.GA10283@lst.de>
References: <20200301144925.48343-1-hch@lst.de> <20200303165157.GC8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303165157.GC8045@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 08:51:57AM -0800, Darrick J. Wong wrote:
> On Sun, Mar 01, 2020 at 07:49:25AM -0700, Christoph Hellwig wrote:
> > The swapon code itself sets sis->bdev up early, and performs various check
> > on the block devices.  Changing it later in the fact thus will cause a
> > mismatch of capabilities and must be avoided.
> 
> What kind of mismatch?  Are you talking about the bdi_cap_* and
> blk_queue_nonrot() logic in swapon()?  I wonder how much of that could
> be moved to after the ->swapfile_activate call.

The thing I ran into is the zone check with my zoned XFS prototype
code.  But when you look at the nonrot checks that will cause
resource leaks due to the override, and thus is the main is the
main issue for now.

I suspect much of this could be cleaned up one way or another, but
the layering of this code is horrible, so it would be a bigger
job.

btrfs hasn't picked up the iomap changes yet, but the next resend
should drop the bdev assignment as well.
