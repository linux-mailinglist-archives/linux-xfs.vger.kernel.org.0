Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72ED9B6A4D
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Sep 2019 20:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfIRSMG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Sep 2019 14:12:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36665 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfIRSMG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 14:12:06 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76553C04AC50;
        Wed, 18 Sep 2019 18:12:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FEAD1001281;
        Wed, 18 Sep 2019 18:12:06 +0000 (UTC)
Date:   Wed, 18 Sep 2019 14:12:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove xfs_release
Message-ID: <20190918181204.GG29377@bfoster>
References: <20190916122041.24636-1-hch@lst.de>
 <20190916122041.24636-2-hch@lst.de>
 <20190916125311.GB41978@bfoster>
 <20190918164938.GA19316@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918164938.GA19316@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 18 Sep 2019 18:12:06 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 06:49:38PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 16, 2019 at 08:53:11AM -0400, Brian Foster wrote:
> > The caller might not care if this call generates errors, but shouldn't
> > we care if something fails? IOW, perhaps we should have an exit path
> > with a WARN_ON_ONCE() or some such to indicate that an unhandled error
> > has occurred..?
> 
> Not sure there is much of a point.  Basically all errors are either
> due to a forced shutdown or cause a forced shutdown anyway, so we'll
> already get warnings.

Well, what's the point of this change in the first place? I see various
error paths that aren't directly related to shutdown. A writeback
submission error for instance looks like it will warn, but not
necessarily shut down (and the filemap_flush() call is already within a
!XFS_FORCED_SHUTDOWN() check). So not all errors are associated with or
cause shutdown. I suppose you could audit the various error paths that
lead back into this function and document that further if you really
wanted to go that route...

Also, you snipped the rest of my feedback... how does the fact that the
caller doesn't care about errors have anything to do with the fact that
the existing logic within this function does? I'm not convinced the
changes here are quite correct, but at the very least the commit log
description is lacking/misleading.

Brian
