Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37DC1943ED
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Mar 2020 17:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCZQBF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 Mar 2020 12:01:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbgCZQBF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 12:01:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02QFwPBw084354
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 16:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=pDm9LbepKYOnYZ1emVpnnmdRrrfv0hMrlkyym4y2N8w=;
 b=xUxmsOLi6qsHEOOMQHorrjLC9Mci+QHFhpA3ywKyjF3NP0/GDwD4hbQEDOm6nJUaK8Tl
 dw/vyGJBo1TS7fao5/Tj+OB82sMwl0L4wqsH0uCMtnfQVyFyaHWBceybr9uhXsyNyfy4
 ghiLS6oSpY+Pk9FuhsI3ybycHEEhMeCwc0jOXTlVm+cCMlb16/Gid+w+IQzlJJP9sREQ
 98EHEa7K8hITygFXiiZS9dlhhGwcmNiDBRRhmF0rhBtcBhFsFjOS+jerp0r9dOG45bIN
 aB69glOVWB7Smc7Da52NV7p8SrBxGk0NzUaYiNo4Etj9Iv6ICnXNI557k81AdApkYdWI /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 300urk1dw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 16:01:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02QFvsVR054013
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 16:01:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3006r8pkuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 16:01:00 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02QG10V1000523
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 16:01:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 09:00:59 -0700
Date:   Thu, 26 Mar 2020 09:00:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 27fb5a72f50a
Message-ID: <20200326160059.GE29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=2
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

27fb5a72f50a xfs: prohibit fs freezing when using empty transactions

New Commits:

Brian Foster (7):
      [6b789c337a59] xfs: fix iclog release error check race with shutdown
      [b73df17e4c5b] xfs: open code insert range extent split helper
      [dd87f87d87fa] xfs: rework insert range into an atomic operation
      [211683b21de9] xfs: rework collapse range into an atomic operation
      [854f82b1f603] xfs: factor out quotaoff intent AIL removal and memory free
      [8a6271431339] xfs: fix unmount hang and memory leak on shutdown during quotaoff
      [842a42d126b4] xfs: shutdown on failure to add page to log bio

Christoph Hellwig (60):
      [3d8f2821502d] xfs: ensure that the inode uid/gid match values match the icdinode ones
      [542951592c99] xfs: remove the icdinode di_uid/di_gid members
      [ba8adad5d036] xfs: remove the kuid/kgid conversion wrappers
      [13b1f811b14e] xfs: ratelimit xfs_buf_ioerror_alert messages
      [4ab45e259f31] xfs: ratelimit xfs_discard_page messages
      [4d542e4c1e28] xfs: reject invalid flags combinations in XFS_IOC_ATTRLIST_BY_HANDLE
      [5e81357435cc] xfs: remove the ATTR_INCOMPLETE flag
      [0eb81a5f5c34] xfs: merge xfs_attr_remove into xfs_attr_set
      [6cc4f4fff10d] xfs: merge xfs_attrmulti_attr_remove into xfs_attrmulti_attr_set
      [2282a9e65177] xfs: use strndup_user in XFS_IOC_ATTRMULTI_BY_HANDLE
      [d0ce64391128] xfs: factor out a helper for a single XFS_IOC_ATTRMULTI_BY_HANDLE op
      [79f2280b9bfd] xfs: remove the name == NULL check from xfs_attr_args_init
      [4df28c64e438] xfs: remove the MAXNAMELEN check from xfs_attr_args_init
      [ead189adb8ab] xfs: turn xfs_da_args.value into a void pointer
      [a25446224353] xfs: pass an initialized xfs_da_args structure to xfs_attr_set
      [e5171d7e9894] xfs: pass an initialized xfs_da_args to xfs_attr_get
      [c36f533f1407] xfs: remove the xfs_inode argument to xfs_attr_get_ilocked
      [e513e25c380a] xfs: remove ATTR_KERNOVAL
      [d49db18b247d] xfs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
      [1d7330199400] xfs: replace ATTR_KERNOTIME with XFS_DA_OP_NOTIME
      [377f16ac6723] xfs: factor out a xfs_attr_match helper
      [a9c8c69b4961] xfs: cleanup struct xfs_attr_list_context
      [fe960087121a] xfs: remove the unused ATTR_ENTRY macro
      [2f014aad03d8] xfs: open code ATTR_ENTSIZE
      [3e7a779937a2] xfs: move the legacy xfs_attr_list to xfs_ioctl.c
      [17e1dd83ea21] xfs: rename xfs_attr_list_int to xfs_attr_list
      [f60463195179] xfs: lift common checks into xfs_ioc_attr_list
      [eb241c747463] xfs: lift buffer allocation into xfs_ioc_attr_list
      [53ac39fdb301] xfs: lift cursor copy in/out into xfs_ioc_attr_list
      [5a3930e27ef9] xfs: improve xfs_forget_acl
      [f3e93d95feef] xfs: clean up the ATTR_REPLACE checks
      [d5f0f49a9bdd] xfs: clean up the attr flag confusion
      [254f800f8104] xfs: remove XFS_DA_OP_INCOMPLETE
      [e3a19cdea84a] xfs: embedded the attrlist cursor into struct xfs_attr_list_context
      [f311d771a090] xfs: clean up bufsize alignment in xfs_ioc_attr_list
      [ed02d13f5da8] xfs: only allocate the buffer size actually needed in __xfs_set_acl
      [5680c3907361] xfs: switch xfs_attrmulti_attr_get to lazy attr buffer allocation
      [183606d82446] xfs: remove the agfl_bno member from struct xfs_agfl
      [4b97510859b2] xfs: remove the xfs_agfl_t typedef
      [370c782b9843] xfs: remove XFS_BUF_TO_AGI
      [9798f615ad2b] xfs: remove XFS_BUF_TO_AGF
      [3e6e8afd3abb] xfs: remove XFS_BUF_TO_SBP
      [b941c71947a0] xfs: mark XLOG_FORCED_SHUTDOWN as unlikely
      [cb3d425fa59a] xfs: remove the unused XLOG_UNMOUNT_REC_TYPE define
      [550319e9df3a] xfs: remove the unused return value from xfs_log_unmount_write
      [6178d104075a] xfs: remove dead code from xfs_log_unmount_write
      [13859c984301] xfs: cleanup xfs_log_unmount_write
      [b81b79f4eda2] xfs: add a new xfs_sb_version_has_v3inode helper
      [e9e2eae89ddb] xfs: only check the superblock version for dinode size calculation
      [b3d1d37544d8] xfs: simplify di_flags2 inheritance in xfs_ialloc
      [5e28aafe708b] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
      [6471e9c5e7a1] xfs: remove the di_version field from struct icdinode
      [c7cc296ddd1f] xfs: merge xlog_cil_push into xlog_cil_push_work
      [81e5b50a8fb5] xfs: factor out a xlog_wait_on_iclog helper
      [f97a43e43662] xfs: simplify the xfs_log_release_iclog calling convention
      [a582f32fade2] xfs: simplify log shutdown checking in xfs_log_release_iclog
      [12e6a0f449d5] xfs: remove the aborted parameter to xlog_state_done_syncing
      [c814b4f24eba] xfs: refactor xlog_state_clean_iclog
      [5781464bd1ee] xfs: move the ioerror check out of xlog_state_clean_iclog
      [693639994b13] xfs: remove xlog_state_want_sync

Darrick J. Wong (28):
      [93baa55af1a1] xfs: improve error message when we can't allocate memory for xfs_buf
      [496b9bcd62b0] xfs: fix use-after-free when aborting corrupt attr inactivation
      [a71e4228e6f2] xfs: fix xfs_rmap_has_other_keys usage of ECANCELED
      [8d57c21600a5] xfs: add a function to deal with corrupt buffers post-verifiers
      [e83cf875d67a] xfs: xfs_buf_corruption_error should take __this_address
      [ce99494c9699] xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
      [1cb5deb5bc09] xfs: don't ever return a stale pointer from __xfs_dir3_free_read
      [6fb5aac73310] xfs: check owner of dir3 free blocks
      [a10c21ed5d52] xfs: check owner of dir3 data blocks
      [1b2c1a63b678] xfs: check owner of dir3 blocks
      [2e107cf869ee] xfs: mark dir corrupt when lookup-by-hash fails
      [806d3909a57e] xfs: mark extended attr corrupt when lookup-by-hash fails
      [faf8ee8476c1] xfs: xfs_dabuf_map should return ENOMEM when map allocation fails
      [77ca1eed5a7d] xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock
      [37a6547d92af] xfs: xrep_reap_extents should not destroy the bitmap
      [00b10d487b29] xfs: rename xfs_bitmap to xbitmap
      [608eb3cee703] xfs: replace open-coded bitmap weight logic
      [e06536a692e0] xfs: introduce fake roots for ag-rooted btrees
      [349e1c0380db] xfs: introduce fake roots for inode-rooted btrees
      [60e3d7070749] xfs: support bulk loading of staged btrees
      [e6eb33d905c2] xfs: add support for free space btree staging cursors
      [c29ce8f48e21] xfs: add support for inode btree staging cursors
      [56e98164ffea] xfs: add support for refcount btree staging cursors
      [59d677127cf1] xfs: add support for rmap btree staging cursors
      [5885539f0af3] xfs: preserve default grace interval during quotacheck
      [afbabf56305f] xfs: drop all altpath buffers at the end of the sibling check
      [d59f44d3e723] xfs: directory bestfree check should release buffers
      [27fb5a72f50a] xfs: prohibit fs freezing when using empty transactions

Dave Chinner (7):
      [7cace18ab576] xfs: introduce new private btree cursor names
      [576af7322807] xfs: convert btree cursor ag-private member name
      [92219c292af8] xfs: convert btree cursor inode-private member names
      [8ef547976a18] xfs: rename btree cursor private btree member flags
      [352890735e52] xfs: make btree cursor private union anonymous
      [68422d90dad4] xfs: make the btree cursor union members named structure
      [c4aa10d04196] xfs: make the btree ag cursor private union anonymous

Eric Biggers (1):
      [10a98cb16d80] xfs: clear PF_MEMALLOC before exiting xfsaild thread

Jules Irenge (1):
      [daebba1b3609] xfs: Add missing annotation to xfs_ail_check()

Qian Cai (1):
      [4982bff1ace1] xfs: fix an undefined behaviour in _da3_path_shift

Takashi Iwai (1):
      [17bb60b74124] xfs: Use scnprintf() for avoiding potential buffer overflow

Tommi Rantala (1):
      [3d28e7e27891] xfs: fix regression in "cleanup xfs_dir2_block_getdents"

Zheng Bin (1):
      [d0c7feaf8767] xfs: add agf freeblocks verify in xfs_agf_verify


Code Diffstat:

 fs/xfs/Makefile                    |   1 +
 fs/xfs/libxfs/xfs_ag.c             |  16 +-
 fs/xfs/libxfs/xfs_alloc.c          |  99 +++--
 fs/xfs/libxfs/xfs_alloc.h          |   9 +
 fs/xfs/libxfs/xfs_alloc_btree.c    | 119 +++--
 fs/xfs/libxfs/xfs_alloc_btree.h    |   7 +
 fs/xfs/libxfs/xfs_attr.c           | 351 +++++----------
 fs/xfs/libxfs/xfs_attr.h           | 114 +----
 fs/xfs/libxfs/xfs_attr_leaf.c      | 130 +++---
 fs/xfs/libxfs/xfs_attr_leaf.h      |   1 -
 fs/xfs/libxfs/xfs_attr_remote.c    |   2 +-
 fs/xfs/libxfs/xfs_bmap.c           |  88 ++--
 fs/xfs/libxfs/xfs_bmap.h           |   3 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  50 +--
 fs/xfs/libxfs/xfs_btree.c          |  93 ++--
 fs/xfs/libxfs/xfs_btree.h          |  82 +++-
 fs/xfs/libxfs/xfs_btree_staging.c  | 879 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree_staging.h  | 123 ++++++
 fs/xfs/libxfs/xfs_da_btree.c       |  17 +-
 fs/xfs/libxfs/xfs_da_btree.h       |  11 +-
 fs/xfs/libxfs/xfs_da_format.h      |  12 -
 fs/xfs/libxfs/xfs_dir2_block.c     |  33 +-
 fs/xfs/libxfs/xfs_dir2_data.c      |  32 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |  11 +-
 fs/xfs/libxfs/xfs_format.h         |  48 +-
 fs/xfs/libxfs/xfs_fs.h             |  32 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  35 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   | 104 ++++-
 fs/xfs/libxfs/xfs_ialloc_btree.h   |   6 +
 fs/xfs/libxfs/xfs_inode_buf.c      |  43 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |   5 -
 fs/xfs/libxfs/xfs_inode_fork.c     |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.h     |   9 +-
 fs/xfs/libxfs/xfs_log_format.h     |  10 +-
 fs/xfs/libxfs/xfs_refcount.c       | 110 ++---
 fs/xfs/libxfs/xfs_refcount_btree.c | 104 +++--
 fs/xfs/libxfs/xfs_refcount_btree.h |   6 +
 fs/xfs/libxfs/xfs_rmap.c           | 123 +++---
 fs/xfs/libxfs/xfs_rmap_btree.c     |  99 +++--
 fs/xfs/libxfs/xfs_rmap_btree.h     |   5 +
 fs/xfs/libxfs/xfs_sb.c             |  17 +-
 fs/xfs/libxfs/xfs_trans_resv.c     |   2 +-
 fs/xfs/scrub/agheader.c            |  20 +-
 fs/xfs/scrub/agheader_repair.c     |  78 ++--
 fs/xfs/scrub/alloc.c               |   2 +-
 fs/xfs/scrub/attr.c                |  20 +-
 fs/xfs/scrub/bitmap.c              |  87 ++--
 fs/xfs/scrub/bitmap.h              |  23 +-
 fs/xfs/scrub/bmap.c                |   4 +-
 fs/xfs/scrub/dabtree.c             |  42 +-
 fs/xfs/scrub/dir.c                 |  13 +-
 fs/xfs/scrub/ialloc.c              |   8 +-
 fs/xfs/scrub/refcount.c            |   2 +-
 fs/xfs/scrub/repair.c              |  28 +-
 fs/xfs/scrub/repair.h              |   6 +-
 fs/xfs/scrub/rmap.c                |   2 +-
 fs/xfs/scrub/scrub.c               |   9 +
 fs/xfs/scrub/trace.c               |   4 +-
 fs/xfs/scrub/trace.h               |   4 +-
 fs/xfs/xfs_acl.c                   | 132 +++---
 fs/xfs/xfs_acl.h                   |   6 +-
 fs/xfs/xfs_aops.c                  |   2 +-
 fs/xfs/xfs_attr_inactive.c         |   6 +-
 fs/xfs/xfs_attr_list.c             | 169 +------
 fs/xfs/xfs_bmap_util.c             |  73 +--
 fs/xfs/xfs_buf.c                   |  29 +-
 fs/xfs/xfs_buf.h                   |   2 +
 fs/xfs/xfs_buf_item.c              |   2 +-
 fs/xfs/xfs_dir2_readdir.c          |  12 +-
 fs/xfs/xfs_discard.c               |   7 +-
 fs/xfs/xfs_dquot.c                 |   4 +-
 fs/xfs/xfs_dquot_item.c            |  44 +-
 fs/xfs/xfs_dquot_item.h            |   1 +
 fs/xfs/xfs_error.c                 |   7 +-
 fs/xfs/xfs_error.h                 |   2 +-
 fs/xfs/xfs_fsmap.c                 |  13 +-
 fs/xfs/xfs_icache.c                |   4 +
 fs/xfs/xfs_inode.c                 |  57 +--
 fs/xfs/xfs_inode_item.c            |  16 +-
 fs/xfs/xfs_ioctl.c                 | 355 +++++++++------
 fs/xfs/xfs_ioctl.h                 |  35 +-
 fs/xfs/xfs_ioctl32.c               |  99 +----
 fs/xfs/xfs_iops.c                  |  25 +-
 fs/xfs/xfs_itable.c                |   6 +-
 fs/xfs/xfs_linux.h                 |  27 +-
 fs/xfs/xfs_log.c                   | 472 +++++++++-----------
 fs/xfs/xfs_log.h                   |   5 +-
 fs/xfs/xfs_log_cil.c               |  58 +--
 fs/xfs/xfs_log_priv.h              |   9 +-
 fs/xfs/xfs_log_recover.c           |  18 +-
 fs/xfs/xfs_mount.c                 |   2 +-
 fs/xfs/xfs_qm.c                    |  55 ++-
 fs/xfs/xfs_qm_syscalls.c           |  13 +-
 fs/xfs/xfs_quota.h                 |   4 +-
 fs/xfs/xfs_stats.c                 |  10 +-
 fs/xfs/xfs_symlink.c               |   6 +-
 fs/xfs/xfs_trace.c                 |   2 +
 fs/xfs/xfs_trace.h                 | 209 +++++++--
 fs/xfs/xfs_trans.c                 |   7 +-
 fs/xfs/xfs_trans_ail.c             |   5 +-
 fs/xfs/xfs_xattr.c                 |  92 ++--
 102 files changed, 3313 insertions(+), 2186 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_btree_staging.c
 create mode 100644 fs/xfs/libxfs/xfs_btree_staging.h
