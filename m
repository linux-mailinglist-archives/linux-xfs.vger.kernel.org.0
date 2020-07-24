Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7988A22CB5D
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Jul 2020 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGXQqc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Jul 2020 12:46:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58386 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXQqc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 12:46:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OGVvIX099143
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=/+vpTZ7u4gb8QKOfDzOOVT5hJSaFP4o/IU2dpyXJRvg=;
 b=bUv49ZmnFwARtSJf0o2oBNIAgvSm44lmRaa9+Lo7k2ooqlpYrpzKVVRdehx14c6GNJlc
 3TM4B+7YHbtS3HI9yiI+zJWBk+rlEL8u9jkaIKorQ/TuKva3eMPjSJF4H7uk+huX++nZ
 Jg4JudOF1xlXF4xAC2oZY/NcNzOTznQ+QnJWyUJaAf7soG8YpXcPYW640Faj/SPMslpu
 rzkNaLEwLt/4D7Vq2OGmEe1guZb9h8VJ+bqVfIUQekz1UxhGpMuMTlo7qCnNLzD7wnQK
 vGT1R9Qoh8WgOPUeFyPEy9r5edNN2tIZrji7BYQ0ldv+8G0XM8a892450zgr4mK2osjI hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32bs1n040a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:46:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OGhcgX092042
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:44:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32g3dw81k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:44:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06OGiRMP015963
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:44:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 09:44:27 -0700
Date:   Fri, 24 Jul 2020 09:44:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 9f347d7a7e0e
Message-ID: <20200724164426.GW3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=2
 malwarescore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

This second update contains both Carlos' series that eliminates our
bespoke kmem_alloc flags in favor of using the existing slab
functionality; and the first 22 patches of Allison's xattr cleanup
series, which by consolidating transaction management duties starts us
down the path towards directory parent pointers.  These patches have had
less time to soak together, so I think I'll delay these until the second
week of the merge window.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  This is it for 5.9, other than bug fixes.

Sorry for this being later in the week than I wanted.  Still recovering
from back problems. :(

The new head of the for-next branch is commit:

9f347d7a7e0e xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname

New Commits:

Allison Collins (22):
      [cfe3d8821c6f] xfs: Add xfs_has_attr and subroutines
      [9a1ba001993d] xfs: Check for -ENOATTR or -EEXIST
      [4b971430bc8c] xfs: Factor out new helper functions xfs_attr_rmtval_set
      [6b92c2b89831] xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
      [11708ea13985] xfs: Split apart xfs_attr_leaf_addname
      [c7f19ffd8361] xfs: Refactor xfs_attr_try_sf_addname
      [83735a6dfca0] xfs: Pull up trans roll from xfs_attr3_leaf_setflag
      [ae20f9b47979] xfs: Factor out xfs_attr_rmtval_invalidate
      [28d507b43854] xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
      [963110828639] xfs: Refactor xfs_attr_rmtval_remove
      [5ad9fab778e2] xfs: Pull up xfs_attr_rmtval_invalidate
      [ca2b2d9c6bb3] xfs: Add helper function xfs_attr_node_shrink
      [7191ab01f48f] xfs: Remove unneeded xfs_trans_roll_inode calls
      [7edd32bc0375] xfs: Remove xfs_trans_roll in xfs_attr_node_removename
      [5c017e3e7378] xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
      [e55de149f8f3] xfs: Add helper function xfs_attr_leaf_mark_incomplete
      [2f9cc8554f2a] xfs: Add remote block helper functions
      [534c7e150352] xfs: Add helper function xfs_attr_node_removename_setup
      [a977f5557e6e] xfs: Add helper function xfs_attr_node_removename_rmt
      [daea66493061] xfs: Simplify xfs_attr_leaf_addname
      [e4dbaf503021] xfs: Simplify xfs_attr_node_addname
      [9f347d7a7e0e] xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname

Brian Foster (3):
      [f74681ba2006] xfs: preserve rmapbt swapext block reservation from freed blocks
      [c22c309bbfb2] xfs: drain the buf delwri queue before xfsaild idles
      [dddf0bdecbbd] xfs: fix inode allocation block res calculation precedence

Carlos Maiolino (5):
      [a96bebcf8ac3] xfs: Remove kmem_zone_alloc() usage
      [7b4920b0e334] xfs: Remove kmem_zone_zalloc() usage
      [cc0417dabb7e] xfs: Modify xlog_ticket_alloc() to use kernel's MM API
      [5736c4aab953] xfs: remove xfs_zone_{alloc,zalloc} helpers
      [65b9e9b3fac8] xfs: Refactor xfs_da_state_alloc() helper

Christoph Hellwig (1):
      [76622c88c2ce] xfs: remove SYNC_WAIT and SYNC_TRYLOCK

Darrick J. Wong (47):
      [eb0efe5063bb] xfs: don't eat an EIO/ENOSPC writeback error when scrubbing data fork
      [83895227aba1] xfs: fix reflink quota reservation accounting error
      [877f58f53684] xfs: rename xfs_bmap_is_real_extent to is_written_extent
      [00fd1d56dd08] xfs: redesign the reflink remap loop to fix blkres depletion crash
      [aa5d0ba0b5db] xfs: only reserve quota blocks for bmbt changes if we're changing the data fork
      [94b941fd7a98] xfs: only reserve quota blocks if we're mapping into a hole
      [168eae803ced] xfs: reflink can skip remap existing mappings
      [451d34ee0750] xfs: fix xfs_reflink_remap_prep calling conventions
      [10b4bd6c9cbc] xfs: refactor locking and unlocking two inodes against userspace IO
      [e2aaee9cd34d] xfs: move helpers that lock and unlock two inodes against userspace IO
      [f866560be219] xfs: rtbitmap scrubber should verify written extents
      [2fb94e36b683] xfs: rtbitmap scrubber should check inode size
      [80173d80c71d] xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
      [e21952105397] xfs: fix inode quota reservation checks
      [8dbcc82de92c] xfs: validate ondisk/incore dquot flags
      [55dd2acf0ba0] xfs: move the flags argument of xfs_qm_scall_trunc_qfiles to XFS_QMOPT_*
      [b28727897146] xfs: refactor quotacheck flags usage
      [7c69193f7bbb] xfs: rename dquot incore state flags
      [930ba8279a27] xfs: make XFS_DQUOT_CLUSTER_SIZE_FSB part of the ondisk format
      [edce943d38d8] xfs: stop using q_core.d_flags in the quota code
      [97c063443107] xfs: stop using q_core.d_id in the quota code
      [c5b54558911f] xfs: use a per-resource struct for incore dquot data
      [6acefb6b8425] xfs: stop using q_core limits in the quota code
      [296614b5cc0f] xfs: stop using q_core counters in the quota code
      [520dbb0f1a26] xfs: stop using q_core warning counters in the quota code
      [7359faf11c31] xfs: stop using q_core timers in the quota code
      [b7029e39b725] xfs: remove qcore from incore dquots
      [da67bbae6436] xfs: refactor default quota limits by resource
      [4ad67354ac45] xfs: remove unnecessary arguments from quota adjust functions
      [e7ff64e6d4d8] xfs: refactor quota exceeded test
      [6ca6b9a7bbdf] xfs: refactor xfs_qm_scall_setqlim
      [fd93db86adfd] xfs: refactor xfs_trans_dqresv
      [647ad56d03b0] xfs: refactor xfs_trans_apply_dquot_deltas
      [daed79d91b5f] xfs: assume the default quota limits are always set in xfs_qm_adjust_dqlimits
      [74388072e2e7] xfs: actually bump warning counts when we send warnings
      [e4c039328d54] xfs: add more dquot tracepoints
      [d2ab70323d96] xfs: drop the type parameter from xfs_dquot_verify
      [d307681cfc35] xfs: rename XFS_DQ_{USER,GROUP,PROJ} to XFS_DQTYPE_*
      [9ba905aaffe4] xfs: refactor testing if a particular dquot is being enforced
      [0350dbfe4e60] xfs: remove the XFS_QM_IS[UGP]DQ macros
      [178d57f792fe] xfs: refactor quota type testing
      [873aa0e36625] xfs: always use xfs_dquot_type when extracting type from a dquot
      [99c1aa0fd76a] xfs: remove unnecessary quota type masking
      [c92b1646dc44] xfs: replace a few open-coded XFS_DQTYPE_REC_MASK uses
      [0e98ad9caee2] xfs: create xfs_dqtype_t to represent quota types
      [7223a7180b9c] xfs: improve ondisk dquot flags checking
      [762d41cc223d] xfs: rename the ondisk dquot d_flags to d_type

Dave Chinner (31):
      [cd647d5651c0] xfs: use MMAPLOCK around filemap_map_pages()
      [96355d5a1f0e] xfs: Don't allow logging of XFS_ISTALE inodes
      [1dfde687a65f] xfs: remove logged flag from inode log item
      [1319ebefd6ed] xfs: add an inode item lock
      [f593bf144c7d] xfs: mark inode buffers in cache
      [0c7e5afbea99] xfs: mark dquot buffers in cache
      [9fe5c77cbe3c] xfs: mark log recovery buffers for completion
      [b01d1461ae6d] xfs: call xfs_buf_iodone directly
      [a7e134ef3717] xfs: clean up whacky buffer log item list reinit
      [aac855ab1a98] xfs: make inode IO completion buffer centric
      [6f5de1808e36] xfs: use direct calls for dquot IO completion
      [fec671cd350f] xfs: clean up the buffer iodone callback functions
      [2ef3f7f5db15] xfs: get rid of log item callbacks
      [428947e9d525] xfs: handle buffer log item IO errors directly
      [3536b61e74aa] xfs: unwind log item error flagging
      [e98084b8bef7] xfs: move xfs_clear_li_failed out of xfs_ail_delete_one()
      [298f7bec503f] xfs: pin inode backing buffer to the inode log item
      [993f951f501c] xfs: make inode reclaim almost non-blocking
      [617825fe3489] xfs: remove IO submission from xfs_reclaim_inode()
      [0e8e2c6343dd] xfs: allow multiple reclaimers per AG
      [9552e14d3e87] xfs: don't block inode reclaim on the ILOCK
      [50718b8d73dd] xfs: remove SYNC_TRYLOCK from inode reclaim
      [4d0bab3a4468] xfs: remove SYNC_WAIT from xfs_reclaim_inodes()
      [02511a5a6a49] xfs: clean up inode reclaim comments
      [71e3e3564686] xfs: rework stale inodes in xfs_ifree_cluster
      [48d55e2ae3ce] xfs: attach inodes to the cluster buffer when dirtied
      [90c60e164012] xfs: xfs_iflush() is no longer necessary
      [e6187b3444e8] xfs: rename xfs_iflush_int()
      [5717ea4d527a] xfs: rework xfs_iflush_cluster() dirty inode iteration
      [a69a1dc2842e] xfs: factor xfs_iflush_done
      [e2705b030477] xfs: remove xfs_inobp_check()

Eric Sandeen (1):
      [ea52eff66dcd] xfs: preserve inode versioning across remounts

Gao Xiang (1):
      [92a005448f6f] xfs: get rid of unnecessary xfs_perag_{get,put} pairs

Keyur Patel (1):
      [06734e3c95a3] xfs: Couple of typo fixes in comments

Randy Dunlap (1):
      [073a5a695e63] xfs: xfs_btree_staging.h: delete duplicated words

Waiman Long (1):
      [c3f2375b90d0] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim

Yafang Shao (1):
      [0d5a57140b3e] xfs: remove useless definitions in xfs_linux.h

YueHaibing (1):
      [8464e650b957] xfs: remove duplicated include from xfs_buf_item.c


Code Diffstat:

 fs/xfs/kmem.c                      |  21 -
 fs/xfs/kmem.h                      |   8 -
 fs/xfs/libxfs/xfs_ag.c             |   4 +-
 fs/xfs/libxfs/xfs_ag_resv.h        |  12 -
 fs/xfs/libxfs/xfs_alloc.c          |  25 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  10 +-
 fs/xfs/libxfs/xfs_attr.c           | 912 ++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h           |   1 +
 fs/xfs/libxfs/xfs_attr_leaf.c      | 117 +++--
 fs/xfs/libxfs/xfs_attr_leaf.h      |   3 +
 fs/xfs/libxfs/xfs_attr_remote.c    | 216 ++++++---
 fs/xfs/libxfs/xfs_attr_remote.h    |   3 +-
 fs/xfs/libxfs/xfs_bmap.c           |   8 +-
 fs/xfs/libxfs/xfs_bmap.h           |  19 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   2 +-
 fs/xfs/libxfs/xfs_btree_staging.h  |   6 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  12 +-
 fs/xfs/libxfs/xfs_da_btree.h       |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |  17 +-
 fs/xfs/libxfs/xfs_dquot_buf.c      |  25 +-
 fs/xfs/libxfs/xfs_format.h         |  36 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  28 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |  33 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |   6 -
 fs/xfs/libxfs/xfs_inode_fork.c     |   6 +-
 fs/xfs/libxfs/xfs_quota_defs.h     |  31 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   6 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  11 +-
 fs/xfs/libxfs/xfs_rtbitmap.c       |   2 +-
 fs/xfs/libxfs/xfs_shared.h         |   1 +
 fs/xfs/libxfs/xfs_trans_inode.c    | 110 +++--
 fs/xfs/libxfs/xfs_trans_space.h    |   2 +-
 fs/xfs/scrub/bmap.c                |  22 +-
 fs/xfs/scrub/dabtree.c             |   4 +-
 fs/xfs/scrub/quota.c               |  83 ++--
 fs/xfs/scrub/repair.c              |  10 +-
 fs/xfs/scrub/repair.h              |   4 +-
 fs/xfs/scrub/rtbitmap.c            |  47 ++
 fs/xfs/xfs_bmap_item.c             |   4 +-
 fs/xfs/xfs_bmap_util.c             |  18 +-
 fs/xfs/xfs_buf.c                   |  44 +-
 fs/xfs/xfs_buf.h                   |  48 +-
 fs/xfs/xfs_buf_item.c              | 436 +++++++++---------
 fs/xfs/xfs_buf_item.h              |   8 +-
 fs/xfs/xfs_buf_item_recover.c      |  14 +-
 fs/xfs/xfs_dquot.c                 | 415 +++++++++--------
 fs/xfs/xfs_dquot.h                 | 129 ++++--
 fs/xfs/xfs_dquot_item.c            |  26 +-
 fs/xfs/xfs_dquot_item_recover.c    |  14 +-
 fs/xfs/xfs_extfree_item.c          |   6 +-
 fs/xfs/xfs_file.c                  |  28 +-
 fs/xfs/xfs_icache.c                | 378 +++++----------
 fs/xfs/xfs_icache.h                |   5 +-
 fs/xfs/xfs_icreate_item.c          |   2 +-
 fs/xfs/xfs_inode.c                 | 702 +++++++++++++---------------
 fs/xfs/xfs_inode.h                 |   5 +-
 fs/xfs/xfs_inode_item.c            | 322 ++++++-------
 fs/xfs/xfs_inode_item.h            |  24 +-
 fs/xfs/xfs_inode_item_recover.c    |   2 +-
 fs/xfs/xfs_iomap.c                 |  42 +-
 fs/xfs/xfs_linux.h                 |   4 -
 fs/xfs/xfs_log.c                   |   9 +-
 fs/xfs/xfs_log_cil.c               |   3 +-
 fs/xfs/xfs_log_priv.h              |   4 +-
 fs/xfs/xfs_log_recover.c           |   5 +-
 fs/xfs/xfs_mount.c                 |  15 +-
 fs/xfs/xfs_mount.h                 |   1 -
 fs/xfs/xfs_qm.c                    | 189 ++++----
 fs/xfs/xfs_qm.h                    | 104 ++---
 fs/xfs/xfs_qm_bhv.c                |  22 +-
 fs/xfs/xfs_qm_syscalls.c           | 250 +++++-----
 fs/xfs/xfs_quota.h                 |  19 +-
 fs/xfs/xfs_quotaops.c              |  26 +-
 fs/xfs/xfs_refcount_item.c         |   5 +-
 fs/xfs/xfs_reflink.c               | 355 +++++++--------
 fs/xfs/xfs_reflink.h               |   2 -
 fs/xfs/xfs_rmap_item.c             |   5 +-
 fs/xfs/xfs_super.c                 |  19 +-
 fs/xfs/xfs_trace.h                 | 226 ++++++---
 fs/xfs/xfs_trans.c                 |  23 +-
 fs/xfs/xfs_trans.h                 |   5 -
 fs/xfs/xfs_trans_ail.c             |  26 +-
 fs/xfs/xfs_trans_buf.c             |  15 +-
 fs/xfs/xfs_trans_dquot.c           | 369 ++++++++-------
 85 files changed, 3277 insertions(+), 2963 deletions(-)
