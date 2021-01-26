Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3AB304532
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Jan 2021 18:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbhAZRZJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Jan 2021 12:25:09 -0500
Received: from verein.lst.de ([213.95.11.211]:47019 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389184AbhAZG5j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 01:57:39 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7B4A868B02; Tue, 26 Jan 2021 07:56:56 +0100 (CET)
Date:   Tue, 26 Jan 2021 07:56:56 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reduce ilock acquisitions in xfs_file_fsync
Message-ID: <20210126065656.GB26958@lst.de>
References: <20210122164643.620257-1-hch@lst.de> <20210122164643.620257-3-hch@lst.de> <20210122210801.GD4662@dread.disaster.area> <20210123064139.GA709@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123064139.GA709@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 07:41:39AM +0100, Christoph Hellwig wrote:
> > In fact, I wonder if we need to do anything other than just use
> > REQ_FUA unconditionally in iomap for this situation, as the block
> > layer will translate REQ_FUA to a write+post-flush if the device
> > doesn't support FUA writes directly.
> > 
> > You're thoughts on that, Christoph?
> 
> For the pure overwrite O_DIRECT + O_DSYNC case we'd get away with just
> a flush.  And using REQ_FUA will get us there, so it might be worth
> a try.

And looking at this a little more, while just using REQ_FUA would
work it would be rather suboptimal for many cases, as the block layer
flush state machine would do a flush for every bio.  So for each
O_DIRECT + O_DSYNC write that generates more than one bio we'd grow
extra flushes.
