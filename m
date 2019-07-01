Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6296E22BE2
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 08:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfETGJd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 02:09:33 -0400
Received: from verein.lst.de ([213.95.11.211]:49873 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729382AbfETGJd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 02:09:33 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 244D568B20; Mon, 20 May 2019 08:09:11 +0200 (CEST)
Date:   Mon, 20 May 2019 08:09:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/20] xfs: remove the iop_push implementation for
 quota off items
Message-ID: <20190520060910.GF31977@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-6-hch@lst.de> <20190517140841.GE7888@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517140841.GE7888@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 10:08:42AM -0400, Brian Foster wrote:
> Hmm, this one is a bit interesting because it's a potential change in
> behavior and I'm not sure the comment above accurately reflects the
> situation. In xfs_qm_scall_quotaoff(), we log the first quotaoff item
> and commit it synchronously. I believe this means it immediately goes
> into the AIL. Then we have to iterate inodes to drop all dquot
> references and purge the dquot cache, which can do I/O by writing back
> dquot bufs before we eventually log the quotaoff_end item. All in all
> this can take a bit of time (and we have test scenarios that reproduce
> quotaoff log deadlocks already).
> 
> I think this change can cause AIL processing concurrent to a quotaoff in
> progress to potentially force the log on every pass. I would not expect
> that to have a positive effect because a log force doesn't actually help
> the quotaoff progress until the quotaoff_end is committed, and that
> already occurs synchronously as well. I don't think it's wise to change
> behavior here, at least not without some testing and analysis around how
> this impacts those already somewhat flakey quota off operations.

True, the log force probably doesn't help.  I'll drop this for now,
the whole quotaoff logging scheme looks pretty dodgy to me to start
with, so it will need some more attention in the future.
