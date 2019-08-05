Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF918130D
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 09:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfHEHVm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Aug 2019 03:21:42 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53549 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726394AbfHEHVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 03:21:42 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C9DCF43F9E9;
        Mon,  5 Aug 2019 17:21:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1huXIF-0007aG-9g; Mon, 05 Aug 2019 17:20:31 +1000
Date:   Mon, 5 Aug 2019 17:20:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v19 00/18] xfs: online repair support
Message-ID: <20190805072031.GW7777@dread.disaster.area>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=gu9DDhuZhshYSb5Zs/lkOA==:117 a=gu9DDhuZhshYSb5Zs/lkOA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=GqOU_hJ-fgrz2VzF4C8A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 04, 2019 at 05:34:43PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This is the first part of the nineteenth revision of a patchset that
> adds to XFS kernel support for online metadata scrubbing and repair.
> There aren't any on-disk format changes.
> 
> New for this version is a rebase against 5.3-rc2, integration with the
> health reporting subsystem, and the explicit revalidation of all
> metadata structures that were rebuilt.
> 
> Patch 1 lays the groundwork for scrub types specifying a revalidation
> function that will check everything that the repair function might have
> rebuilt.  This will be necessary for the free space and inode btree
> repair functions, which rebuild both btrees at once.
> 
> Patch 2 ensures that the health reporting query code doesn't get in the
> way of post-repair revalidation of all rebuilt metadata structures.
> 
> Patch 3 creates a new data structure that provides an abstraction of a
> big memory array by using linked lists.  This is where we store records
> for btree reconstruction.  This first implementation is memory
> inefficient and consumes a /lot/ of kernel memory, but lays the
> groundwork for the last patch in the set to convert the implementation
> to use a (memfd) swap file, which enables us to use pageable memory
> without pounding the slab cache.
> 
> Patches 4-10 implement reconstruction of the free space btrees, inode
> btrees, reference count btrees, inode records, inode forks, inode block
> maps, and symbolic links.

Darrick and I had a discussion on #xfs about the btree rebuilds
mainly centered around robustness. The biggest issue I saw with the
code as it stands is that we replace the existing btree as we build
it. As a result, we go from a complete tree with a single corruption
to an empty tree with lots of external dangling references (i.e.
massive corruption!) until the rebuild finishes. Hence if we crash
while the rebuild is in progress, we risk being in a state where:

	- log recovery will abort because it trips over partial tree
	  state
	- mounting won't run because scanning the btree at mount
	  time falls of the end of the btree unexpectedly, doesn't
	  find enough free space for reservations, etc
	- mounting succeeds but then the first operations fail
	  because the tree is incomplete and the filesystem
	  immediately shuts down.

So if we crash while there is a background repair taking place on
the root filesystem, then it is very likely the system will not boot
up after the crash. :(

We came to the conclusion - independently, at the same time :) -
that we should rebuild btrees in known free space with a dangling
root node and then, once the whole new tree has been built, we
atomically swap the btree root nodes. Hence if we crash during
rebuild, we just have some dangling, unreferenced used space that a
subsequent scrub/repair/rebuild cycle will release back to the free
space pool.

That leaves the original corrupt tree in place, and hence we don't
make things any worse than they already are by trying to repair the
tree. The atomic swap of the root nodes allows failsafe transition
between the old and new trees, and the rebuild can then free the
space the old tree used. If we crash at this point, then it's just
dangling free space and a subsequent scrub/repair/rebuild cycle will
release it back to the free space pool.

This mechanism also works with xfs_repair - if we run xfs_repair
after a crash during online rebuild, it will still see the original
corrupt trees, find the dangling free space as well, and clean
everything up with a new tree rebuild. Which means, again, an online
rebuild failure does not make anything worse than before the rebuild
started....

Darrick thinks that this can quite easily be done simply by skipping
the root node pointer update (->set_root, IIRC) until the new tree
has been fully rebuilt. Hopefully that is the case, because an
atomic swap mechanism like this will make the repair algorithms a
lot more robust. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
