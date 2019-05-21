Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667A224755
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 07:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbfEUFKG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 01:10:06 -0400
Received: from verein.lst.de ([213.95.11.211]:57296 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfEUFKG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 01:10:06 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id BB02768B05; Tue, 21 May 2019 07:09:43 +0200 (CEST)
Date:   Tue, 21 May 2019 07:09:43 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190521050943.GA29120@lst.de>
References: <20190520161347.3044-1-hch@lst.de> <20190520161347.3044-15-hch@lst.de> <20190520233233.GF29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520233233.GF29573@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 09:32:33AM +1000, Dave Chinner wrote:
> So while it's easy to drop the uncached buffer API from the kernel
> side, it leaves me with the question of what API do we use in
> userspace to provide this same functionality? I suspect that we
> probably need to separate all this log-to-bio code out into a
> separate file (e.g. xfs_log_io.[ch]) to leave a set of API stubs
> that we can reimplement in userspace to pread/pwrite directly to
> the log buftarg device fd as I've done already for the buffer
> code...

For one we still keep the uncached buffers in xfs_buf.c as we have users
of that outside of the log code, but I guess that is not what you mean.

I can split the log recovery code into a separate file, as you said
it should just be malloc + pread/pwrite in userspace, so implementing
it should be trivial.  The xlog_sync case is pretty different in the
kernel as it isn't synchonous, and it also doesn't currently exist in
userspace.  I'd rather keep that as-is unless you have plans to port
the logging code to userspace?  Even in that case we'll probably want
a different abstraction that maps to aio.
