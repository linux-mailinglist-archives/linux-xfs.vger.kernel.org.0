Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E5B20670C
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jun 2020 00:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387757AbgFWWOm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jun 2020 18:14:42 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:48101 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387609AbgFWWOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 18:14:41 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id EBAA2D5C6E9;
        Wed, 24 Jun 2020 08:14:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnrBX-0000hq-HI; Wed, 24 Jun 2020 08:14:31 +1000
Date:   Wed, 24 Jun 2020 08:14:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
Message-ID: <20200623221431.GB2005@dread.disaster.area>
References: <20200623052059.1893966-1-david@fromorbit.com>
 <20200623211910.GG7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623211910.GG7606@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=eSglUqIqSMLvk5Se81QA:9 a=Bp1ua9J24Lt_N_46:21 a=wXGZdZFFRqYmG6m3:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 02:19:10PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 23, 2020 at 03:20:59PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The page faultround path ->map_pages is implemented in XFS via
> 
> What does "faultround" mean?

Typo - fault-around.

i.e. when we take a read page fault, the do_read_fault() code first
opportunistically tries to map a range of pages surrounding
surrounding the faulted page into the PTEs, not just the faulted
page. It uses ->map_pages() to do the page cache lookups for
cached pages in the range of the fault around and then inserts them
into the PTES is if finds any.

If the fault-around pass did not find the page fault page in cache
(i.e. vmf->page remains null) then it calls into do_fault(), which
ends up calling ->fault, which we then lock the MMAPLOCK and call
into filemap_fault() to populate the page cache and read the data
into it.

So, essentially, fault-around is a mechanism to reduce page faults
in the situation where previous readahead has brought adjacent pages
into the page cache by optimistically mapping up to
fault_around_bytes into PTEs on any given read page fault.

> I'm pretty convinced that this is merely another round of whackamole wrt
> taking the MMAPLOCK before relying on or doing anything to pages in the
> page cache, I just can't tell if 'faultround' is jargon or typo.

Well, it's whack-a-mole in that this is the first time I've actually
looked at what map_pages does. I knew there was fault-around in the
page fault path, but I know that it had it's own method for
page cache lookups and pte mapping, nor that it had it's own
truncate race checks to ensure it didn't map pages invalidated by
truncate into the PTEs.

There's so much technical debt hidden in the kernel code base. The
fact we're still finding places that assume only truncate can
invalidate the page cache over a file range indicates just how deep
this debt runs...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
