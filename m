Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DABB410C
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Sep 2019 21:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390912AbfIPTXZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Sep 2019 15:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387404AbfIPTXZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 15:23:25 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D47AF18CB8F5;
        Mon, 16 Sep 2019 19:23:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EC2A60A9D;
        Mon, 16 Sep 2019 19:23:24 +0000 (UTC)
Date:   Mon, 16 Sep 2019 15:23:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 00/19] Delayed Attributes
Message-ID: <20190916192322.GD41978@bfoster>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190916122754.GA41978@bfoster>
 <178f8a56-9db2-ca26-aa9b-a5739f6ebd5a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178f8a56-9db2-ca26-aa9b-a5739f6ebd5a@oracle.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Mon, 16 Sep 2019 19:23:24 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 11:41:13AM -0700, Allison Collins wrote:
> On 9/16/19 5:27 AM, Brian Foster wrote:
> > On Thu, Sep 05, 2019 at 03:18:18PM -0700, Allison Collins wrote:
> > > Hi all,
> > > 
> > > This set is a subset of a larger series for parent pointers.
> > > Delayed attributes allow attribute operations (set and remove) to be
> > > logged and committed in the same way that other delayed operations do.
> > > This will help break up more complex operations when we later introduce
> > > parent pointers which can be used in a number of optimizations.  Since
> > > delayed attributes can be implemented as a stand alone feature, I've
> > > decided to subdivide the set to help make it more manageable.  Delayed
> > > attributes may also provide the infastructure to later break up large
> > > attributes into smaller transactions instead of one large bwrite.
> > > 
> > > Changes since v2:
> > > Mostly review updates collected since v2.  Patch 17 is new and adds a
> > > new feature bit that is enabled through mkfs.xfs -n delattr.  Attr
> > > renames have been simplified into separate remove and set opertaions
> > > which removes the need for the INCOMPLETE state used in non delayed
> > > operations
> > > 
> > > I've also made the corresponding updates to the user space side, and
> > > xfstests as well.
> > > 
> > > Question, comment and feedback appreciated!
> > > 
> > > Thanks all!
> > > Allison
> > > 
> > > Allison Collins (15):
> > >    xfs: Replace attribute parameters with struct xfs_name
> > 
> > Hi Allison,
> > 
> > The first patch in the series doesn't apply to current for-next or
> > master. What is the baseline for this series? Perhaps a rebase is in
> > order..?
> > 
> > Brian
> 
> The base line for the kernel space set is:
> eb77b23 xfs: add a xfs_valid_startblock helper
> 

Hmm, I still cannot apply:

$ git log --oneline -1
eb77b23b565e (HEAD -> ac-delayed-attrs-v3, tag: xfs-5.4-merge-4) xfs: add a xfs_valid_startblock helper
$ git am <mbox>
Applying: xfs: Replace attribute parameters with struct xfs_name
error: patch failed: fs/xfs/libxfs/xfs_attr.c:61
error: fs/xfs/libxfs/xfs_attr.c: patch does not apply
error: patch failed: fs/xfs/libxfs/xfs_attr.h:144
error: fs/xfs/libxfs/xfs_attr.h: patch does not apply
error: patch failed: fs/xfs/xfs_acl.c:135
error: fs/xfs/xfs_acl.c: patch does not apply
error: patch failed: fs/xfs/xfs_ioctl.c:431
error: fs/xfs/xfs_ioctl.c: patch does not apply
error: patch failed: fs/xfs/xfs_iops.c:49
error: fs/xfs/xfs_iops.c: patch does not apply
error: patch failed: fs/xfs/xfs_xattr.c:20
error: fs/xfs/xfs_xattr.c: patch does not apply
Patch failed at 0001 xfs: Replace attribute parameters with struct xfs_name
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Have you tried to pull the patches from the mailing list and apply to
your baseline locally? I haven't seen issues merging other patches, so I
don't _think_ my local tree is busted..

Brian

> And the user space set is:
> e74aec5 xfsprogs: Release v5.3.0-rc1
> 
> And xfstests:
> cda9817 common/quota: enable project quota correctly on f2fs
> 
> Yes, the for-next's may have advanced a bit since, so I'll need to update
> it.  Sometimes stuff moves so fast, by the time I've worked through all the
> conflicts, there's a new for-next already! I kind of figured though that
> people are still sort of settling on what they want the design to even look
> like, especially WRT to the *_later routines which are sort of complicated.
> So I haven't been too worried about it since rebasing is mostly just
> mechanical adjustments, and it could be the next review may take the design
> in a different direction anyway.
> 
> For now though, please use those baselines if you want to apply the sets.  I
> will work on getting the bases updated.
> 
> Thanks!
> 
> Allison
> 
> > 
> > >    xfs: Embed struct xfs_name in xfs_da_args
> > >    xfs: Add xfs_dabuf defines
> > >    xfs: Factor out new helper functions xfs_attr_rmtval_set
> > >    xfs: Factor up trans handling in xfs_attr3_leaf_flipflags
> > >    xfs: Factor out xfs_attr_leaf_addname helper
> > >    xfs: Factor up commit from xfs_attr_try_sf_addname
> > >    xfs: Factor up trans roll from xfs_attr3_leaf_setflag
> > >    xfs: Add xfs_attr3_leaf helper functions
> > >    xfs: Factor out xfs_attr_rmtval_invalidate
> > >    xfs: Factor up trans roll in xfs_attr3_leaf_clearflag
> > >    xfs: Add delay context to xfs_da_args
> > >    xfs: Add delayed attribute routines
> > >    xfs: Add feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
> > >    xfs: Enable delayed attributes
> > > 
> > > Allison Henderson (4):
> > >    xfs: Add xfs_has_attr and subroutines
> > >    xfs: Set up infastructure for deferred attribute operations
> > >    xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
> > >    xfs_io: Add delayed attributes error tag
> > > 
> > >   fs/xfs/Makefile                 |    2 +-
> > >   fs/xfs/libxfs/xfs_attr.c        | 1068 ++++++++++++++++++++++++++++++++++-----
> > >   fs/xfs/libxfs/xfs_attr.h        |   53 +-
> > >   fs/xfs/libxfs/xfs_attr_leaf.c   |  277 ++++++----
> > >   fs/xfs/libxfs/xfs_attr_leaf.h   |    7 +
> > >   fs/xfs/libxfs/xfs_attr_remote.c |  103 +++-
> > >   fs/xfs/libxfs/xfs_attr_remote.h |    4 +-
> > >   fs/xfs/libxfs/xfs_da_btree.c    |    8 +-
> > >   fs/xfs/libxfs/xfs_da_btree.h    |   27 +-
> > >   fs/xfs/libxfs/xfs_defer.c       |    1 +
> > >   fs/xfs/libxfs/xfs_defer.h       |    3 +
> > >   fs/xfs/libxfs/xfs_dir2.c        |   22 +-
> > >   fs/xfs/libxfs/xfs_dir2_block.c  |    6 +-
> > >   fs/xfs/libxfs/xfs_dir2_leaf.c   |    6 +-
> > >   fs/xfs/libxfs/xfs_dir2_node.c   |    8 +-
> > >   fs/xfs/libxfs/xfs_dir2_sf.c     |   30 +-
> > >   fs/xfs/libxfs/xfs_errortag.h    |    4 +-
> > >   fs/xfs/libxfs/xfs_format.h      |   11 +-
> > >   fs/xfs/libxfs/xfs_fs.h          |    1 +
> > >   fs/xfs/libxfs/xfs_log_format.h  |   44 +-
> > >   fs/xfs/libxfs/xfs_sb.c          |    2 +
> > >   fs/xfs/libxfs/xfs_types.h       |    1 +
> > >   fs/xfs/scrub/attr.c             |   12 +-
> > >   fs/xfs/scrub/common.c           |    2 +
> > >   fs/xfs/xfs_acl.c                |   29 +-
> > >   fs/xfs/xfs_attr_item.c          |  764 ++++++++++++++++++++++++++++
> > >   fs/xfs/xfs_attr_item.h          |   88 ++++
> > >   fs/xfs/xfs_attr_list.c          |    1 +
> > >   fs/xfs/xfs_error.c              |    3 +
> > >   fs/xfs/xfs_ioctl.c              |   30 +-
> > >   fs/xfs/xfs_ioctl32.c            |    2 +
> > >   fs/xfs/xfs_iops.c               |   14 +-
> > >   fs/xfs/xfs_log.c                |    4 +
> > >   fs/xfs/xfs_log_recover.c        |  173 +++++++
> > >   fs/xfs/xfs_ondisk.h             |    2 +
> > >   fs/xfs/xfs_super.c              |    4 +
> > >   fs/xfs/xfs_trace.h              |   20 +-
> > >   fs/xfs/xfs_trans.h              |    1 -
> > >   fs/xfs/xfs_xattr.c              |   31 +-
> > >   39 files changed, 2509 insertions(+), 359 deletions(-)
> > >   create mode 100644 fs/xfs/xfs_attr_item.c
> > >   create mode 100644 fs/xfs/xfs_attr_item.h
> > > 
> > > -- 
> > > 2.7.4
> > > 
