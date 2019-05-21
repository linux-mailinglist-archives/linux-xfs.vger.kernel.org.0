Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CDB25A45
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2019 00:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfEUWYj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 18:24:39 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60638 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbfEUWYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 18:24:39 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 737CACB79;
        Wed, 22 May 2019 08:24:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hTDBS-0003fA-1n; Wed, 22 May 2019 08:24:34 +1000
Date:   Wed, 22 May 2019 08:24:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190521222434.GH29573@dread.disaster.area>
References: <20190520161347.3044-1-hch@lst.de>
 <20190520161347.3044-15-hch@lst.de>
 <20190520233233.GF29573@dread.disaster.area>
 <20190521050943.GA29120@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521050943.GA29120@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=7-415B0cAAAA:8 a=tCD2SbZ7nBpncNM85jIA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 07:09:43AM +0200, Christoph Hellwig wrote:
> On Tue, May 21, 2019 at 09:32:33AM +1000, Dave Chinner wrote:
> > So while it's easy to drop the uncached buffer API from the kernel
> > side, it leaves me with the question of what API do we use in
> > userspace to provide this same functionality? I suspect that we
> > probably need to separate all this log-to-bio code out into a
> > separate file (e.g. xfs_log_io.[ch]) to leave a set of API stubs
> > that we can reimplement in userspace to pread/pwrite directly to
> > the log buftarg device fd as I've done already for the buffer
> > code...
> 
> For one we still keep the uncached buffers in xfs_buf.c as we have users
> of that outside of the log code, but I guess that is not what you mean.
> 
> I can split the log recovery code into a separate file, as you said
> it should just be malloc + pread/pwrite in userspace, so implementing
> it should be trivial.

Yeah, the log recovery code should probably be split in three - the
kernel specific IO code/API, the log parsing code (the bit that
finds head/tail and parses it into transactions for recovery) and
then the bit that actually does the recovery. THe logprint code in
userspace uses the parsing code, so that's the bit we need to share
with userspace...

> The xlog_sync case is pretty different in the
> kernel as it isn't synchonous, and it also doesn't currently exist in
> userspace.  I'd rather keep that as-is unless you have plans to port
> the logging code to userspace?

That's fine, I have no plans to pull the full logging code into
userspace right now.

> Even in that case we'll probably want
> a different abstraction that maps to aio.

I've got a rough AIO implementation backing the xfs_buf.c code in
userspace already. It works just fine and is massively faster than
the existing code on SSDs, so I don't see a problem with porting IO
code that assumes an AIO model anymore. i.e. Re-using the kernel AIO
model for all the buffer code in userspace is one of the reasons I'm
porting xfs-buf.c to userspace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
