Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914C3109C7
	for <lists+linux-xfs@lfdr.de>; Wed,  1 May 2019 17:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfEAPFQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 May 2019 11:05:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54586 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfEAPFQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 May 2019 11:05:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41ExK1w181707
        for <linux-xfs@vger.kernel.org>; Wed, 1 May 2019 15:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=PFussQxHFiX763XBBP09Zm5P61tmY+7XE2vmgO/KRx4=;
 b=B2o8c7kePF04s/rclEXzu8IzbmMM70rhIBp5uW0bRy44gw74daLT5vEImcl7mAZxV+77
 Z5VFo+8qtWIlOZbbXYDslmPXW0+fW+FGG/T9yvHh7UaYyieiwk6KjKVEnoz/4Rg5AfJ2
 DN/XpjorlmZM9gUjhoSOTOCmyz1cZZgl6TgWLJzxhokO8bKVhV2DJ4mXRGLU0NO5hVGD
 vptcytBgL9/gAoxnuWWsf9LGMI2ereVbM+2WMBnokQCe6btxiRIQH/Vj/2OiqR+cFYt+
 7KtmCXJdHjm6zUatIQG12YullNTfAhEnCA8jKVo5QRjEJ0cQEMFo1L+d6NeJzyZxtrZj Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s6xhyk5hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 May 2019 15:05:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41F4h8e191072
        for <linux-xfs@vger.kernel.org>; Wed, 1 May 2019 15:05:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2s6xhgj7y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 May 2019 15:05:13 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x41F5D3G030847
        for <linux-xfs@vger.kernel.org>; Wed, 1 May 2019 15:05:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 May 2019 08:05:13 -0700
Date:   Wed, 1 May 2019 08:05:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to f00b8b784f75
Message-ID: <20190501150513.GJ5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9243 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905010096
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9243 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905010096
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
the next update.  This is yesterday's for-next branch with the iomap
branch merged in; if you want /only/ one branch or the other, please see
either of the {iomap,xfs}-5.2-merge branches.

The new head of the for-next branch is commit:

f00b8b784f75 Merge remote-tracking branch 'korg/iomap-5.2-merge' into for-next

New Commits:

Andreas Gruenbacher (3):
      [26ddb1f4fd88] fs: Turn __generic_write_end into a void function
      [7a77dad7e3be] iomap: Fix use-after-free error in page_done callback
      [df0db3ecdb8f] iomap: Add a page_prepare callback

Brian Foster (7):
      [4d09807f2046] xfs: fix use after free in buf log item unlock assert
      [545aa41f5cba] xfs: wake commit waiters on CIL abort before log item abort
      [22fedd80b652] xfs: shutdown after buf release in iflush cluster abort path
      [1ca89fbc48e1] xfs: don't account extra agfl blocks as available
      [945c941fcd82] xfs: make tr_growdata a permanent transaction
      [362f5e745ae2] xfs: assert that we don't enter agfl freeing with a non-permanent transaction
      [1749d1ea89bd] xfs: add missing error check in xfs_prepare_shift()

Christoph Hellwig (3):
      [73ce6abae5f9] iomap: convert to SPDX identifier
      [94079285756d] xfs: don't parse the mtpt mount option
      [dbc582b6fb6a] iomap: Clean up __generic_write_end calling

Darrick J. Wong (28):
      [6772c1f11206] xfs: track metadata health status
      [39353ff6e96f] xfs: replace the BAD_SUMMARY mount flag with the equivalent health code
      [519841c207de] xfs: clear BAD_SUMMARY if unmounting an unhealthy filesystem
      [7cd5006bdb6f] xfs: add a new ioctl to describe allocation group geometry
      [c23232d40935] xfs: report fs and rt health via geometry structure
      [1302c6a24fd9] xfs: report AG health via AG geometry ioctl
      [89d139d5ad46] xfs: report inode health via bulkstat
      [9d71e15586fd] xfs: refactor scrub context initialization
      [f8c2a2257ca1] xfs: collapse scrub bool state flags into a single unsigned int
      [160b5a784525] xfs: hoist the already_fixed variable to the scrub context
      [4860a05d2475] xfs: scrub/repair should update filesystem metadata health
      [4fb7951fde64] xfs: scrub should only cross-reference with healthy btrees
      [cb357bf3d105] xfs: implement per-inode writeback completion queues
      [28408243706e] xfs: remove unused m_data_workqueue
      [3994fc489575] xfs: merge adjacent io completions of the same type
      [1fdeaea4d92c] xfs: abort unaligned nowait directio early
      [903b1fc2737f] xfs: widen quota block counters to 64-bit integers
      [394aafdc15da] xfs: widen inode delalloc block counter to 64-bits
      [078f4a7d3109] xfs: kill the xfs_dqtrx_t typedef
      [3de5eab3fde1] xfs: unlock inode when xfs_ioctl_setattr_get_trans can't get transaction
      [f60be90fc9a9] xfs: fix broken bhold behavior in xrep_roll_ag_trans
      [9fe82b8c422b] xfs: track delayed allocation reservations across the filesystem
      [ed30dcbd901c] xfs: rename the speculative block allocation reclaim toggle functions
      [9a1f3049f473] xfs: allow scrubbers to pause background reclaim
      [47cd97b5b239] xfs: scrub should check incore counters against ondisk headers
      [710d707d2fa9] xfs: always rejoin held resources during defer roll
      [75efa57d0bf5] xfs: add online scrub for superblock counters
      [f00b8b784f75] Merge remote-tracking branch 'korg/iomap-5.2-merge' into for-next

Dave Chinner (1):
      [1b6d968de22b] xfs: bump XFS_IOC_FSGEOMETRY to v5 structures

Wang Shilong (1):
      [2bf9d264efed] xfs,fstrim: fix to return correct minlen


Code Diffstat:

 fs/buffer.c                    |   8 +-
 fs/gfs2/bmap.c                 |  15 +-
 fs/internal.h                  |   2 +-
 fs/iomap.c                     |  65 ++++---
 fs/xfs/Makefile                |   3 +
 fs/xfs/libxfs/xfs_ag.c         |  54 ++++++
 fs/xfs/libxfs/xfs_ag.h         |   2 +
 fs/xfs/libxfs/xfs_alloc.c      |  13 +-
 fs/xfs/libxfs/xfs_attr.c       |  35 ++--
 fs/xfs/libxfs/xfs_attr.h       |   2 +-
 fs/xfs/libxfs/xfs_bmap.c       |  17 +-
 fs/xfs/libxfs/xfs_defer.c      |  14 +-
 fs/xfs/libxfs/xfs_fs.h         | 139 +++++++++++----
 fs/xfs/libxfs/xfs_health.h     | 190 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c         |  10 +-
 fs/xfs/libxfs/xfs_trans_resv.c |   6 +-
 fs/xfs/libxfs/xfs_types.c      |   2 +-
 fs/xfs/libxfs/xfs_types.h      |   2 +
 fs/xfs/scrub/agheader.c        |  20 +++
 fs/xfs/scrub/common.c          |  47 ++++-
 fs/xfs/scrub/common.h          |   4 +
 fs/xfs/scrub/fscounters.c      | 366 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.c          | 237 +++++++++++++++++++++++++
 fs/xfs/scrub/health.h          |  14 ++
 fs/xfs/scrub/ialloc.c          |   4 +-
 fs/xfs/scrub/parent.c          |   2 +-
 fs/xfs/scrub/quota.c           |   2 +-
 fs/xfs/scrub/repair.c          |  34 ++--
 fs/xfs/scrub/repair.h          |   5 +-
 fs/xfs/scrub/scrub.c           |  49 ++++--
 fs/xfs/scrub/scrub.h           |  27 ++-
 fs/xfs/scrub/trace.h           |  63 ++++++-
 fs/xfs/xfs_aops.c              | 135 ++++++++++++--
 fs/xfs/xfs_aops.h              |   1 -
 fs/xfs/xfs_bmap_util.c         |   2 +
 fs/xfs/xfs_buf_item.c          |   4 +-
 fs/xfs/xfs_discard.c           |   3 +-
 fs/xfs/xfs_dquot.c             |  17 +-
 fs/xfs/xfs_file.c              |   6 +-
 fs/xfs/xfs_health.c            | 392 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c            |  11 +-
 fs/xfs/xfs_icache.h            |   4 +-
 fs/xfs/xfs_inode.c             |   4 +-
 fs/xfs/xfs_inode.h             |  17 +-
 fs/xfs/xfs_ioctl.c             |  55 +++---
 fs/xfs/xfs_ioctl32.c           |   4 +-
 fs/xfs/xfs_itable.c            |   2 +
 fs/xfs/xfs_log.c               |   3 +-
 fs/xfs/xfs_log_cil.c           |  21 ++-
 fs/xfs/xfs_mount.c             |  35 +++-
 fs/xfs/xfs_mount.h             |  32 +++-
 fs/xfs/xfs_qm.c                |   3 +-
 fs/xfs/xfs_qm.h                |   8 +-
 fs/xfs/xfs_quota.h             |  37 ++--
 fs/xfs/xfs_super.c             |  33 ++--
 fs/xfs/xfs_trace.h             |  76 ++++++++
 fs/xfs/xfs_trans_dquot.c       |  52 +++---
 include/linux/iomap.h          |  22 ++-
 58 files changed, 2130 insertions(+), 302 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_health.h
 create mode 100644 fs/xfs/scrub/fscounters.c
 create mode 100644 fs/xfs/scrub/health.c
 create mode 100644 fs/xfs/scrub/health.h
 create mode 100644 fs/xfs/xfs_health.c
