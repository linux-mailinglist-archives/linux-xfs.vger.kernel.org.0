Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C082C62626
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2019 18:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfGHQYw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Jul 2019 12:24:52 -0400
Received: from verein.lst.de ([213.95.11.211]:34862 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbfGHQYw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jul 2019 12:24:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9F5D2227A81; Mon,  8 Jul 2019 18:24:50 +0200 (CEST)
Date:   Mon, 8 Jul 2019 18:24:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/24] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190708162450.GA10355@lst.de>
References: <20190605191511.32695-1-hch@lst.de> <20190605191511.32695-20-hch@lst.de> <20190708073740.GI7689@dread.disaster.area> <20190708161919.GN1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708161919.GN1404256@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 08, 2019 at 09:19:19AM -0700, Darrick J. Wong wrote:
> The submit_bio_wait blows away our old assignment of bio1->bi_end_io ==
> bio_chain_endio and replaces it with submit_bio_wait_endio.  So
> xfs_rw_bdev waits /only/ for bio1 to finish and exits without waiting
> for bio0, and if you're lucky bio0 completes soon enough that the caller
> doesn't notice.  AFAICT, I think bio0 just leaks.
> 
> So I think the solution is that we have to call submit_bio_wait on that
> very first bio (bio0) since the bios created in the inner loop will be
> chained to it... ?  Thoughts/flames/"go finish your morning coffee"?

I'm going to finish my morning coffee first given that I'm on pacific
time at the moment, but the analysis sounds relatively sane.
