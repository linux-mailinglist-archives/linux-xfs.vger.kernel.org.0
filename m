Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689394A7C7
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 19:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbfFRRBh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 13:01:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43592 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRRBh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 13:01:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IGwJgw038327
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=UJtLXSP8LL81ssloPo7UxvmXW4bRFj/8G4g2ud6PSz0=;
 b=snW++E3sU2gsTJSQpGk4CH6BbTyvjdOB/XwYAWwEkyYJWipx7iAE25zEmU50zz/4Hu7j
 kZdbNql85FzcIre3Gqa6SAxSST0ZdUwAEhwqHHI/I72xh3b3AP3Oqr17Uv/MHVW2mf9u
 nq/ybRVvmjSSASO1bPFH0SYRPRaqAOReEPUAMQEf0BY1ondfwIZnhkoZd2e27AT54AOu
 CoUQiWnM6v86KfxiGdlQgU1Q2aScOy8lc195TQheO9/eCRdK/tSOC9fN2vXv5J80yx2b
 rFCNtvXeC7BEYS7LTYuVKF7fC8JLv7179fpjiYgQu4/QYupq3tp0ZZ8vvunFDUJLSmZp HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t4r3tntjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:01:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IH1ZIB027767
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:01:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t59gdxum7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:01:35 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IH1WeA008233
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:01:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 10:01:32 -0700
Date:   Tue, 18 Jun 2019 10:01:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to f5b999c03f4c
Message-ID: <20190618170131.GE5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180135
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

The patches being announced here are the earliest things I felt were
ready for 5.3; I'm still testing Christoph's huge log rework so that
will wait for a later update.

The new head of the for-next branch is commit:

f5b999c03f4c xfs: remove unused flag arguments

New Commits:

Christoph Hellwig (2):
      [f9a196ee5ab5] xfs: merge xfs_buf_zero and xfs_buf_iomove
      [76dee76921e1] xfs: remove the debug-only q_transp field from struct xfs_dquot

Darrick J. Wong (4):
      [ef325959993e] xfs: separate inode geometry
      [494dba7b276e] xfs: refactor inode geometry setup routines
      [490d451fa518] xfs: fix inode_cluster_size rounding mayhem
      [4b4d98cca320] xfs: finish converting to inodes_per_cluster

Eric Sandeen (3):
      [d03a2f1b9fa8] xfs: include WARN, REPAIR build options in XFS_BUILD_OPTIONS
      [8c9ce2f707a1] xfs: remove unused flags arg from getsb interfaces
      [f5b999c03f4c] xfs: remove unused flag arguments


Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c           |   8 +-
 fs/xfs/libxfs/xfs_alloc.c        |   4 +-
 fs/xfs/libxfs/xfs_attr_remote.c  |   2 +-
 fs/xfs/libxfs/xfs_bmap.c         |  14 +--
 fs/xfs/libxfs/xfs_btree.c        |  30 ++---
 fs/xfs/libxfs/xfs_btree.h        |  10 +-
 fs/xfs/libxfs/xfs_format.h       |  43 ++++++-
 fs/xfs/libxfs/xfs_ialloc.c       | 236 ++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_ialloc.h       |  18 +--
 fs/xfs/libxfs/xfs_ialloc_btree.c |  15 +--
 fs/xfs/libxfs/xfs_inode_buf.c    |   5 +-
 fs/xfs/libxfs/xfs_sb.c           |  28 ++---
 fs/xfs/libxfs/xfs_trans_resv.c   |  15 +--
 fs/xfs/libxfs/xfs_trans_space.h  |   7 +-
 fs/xfs/libxfs/xfs_types.c        |   4 +-
 fs/xfs/scrub/ialloc.c            |  21 ++--
 fs/xfs/scrub/quota.c             |   2 +-
 fs/xfs/scrub/repair.c            |   2 +-
 fs/xfs/xfs_bmap_util.c           |   6 +-
 fs/xfs/xfs_buf.c                 |  25 +----
 fs/xfs/xfs_buf.h                 |  16 +--
 fs/xfs/xfs_dquot.h               |   1 -
 fs/xfs/xfs_dquot_item.c          |   5 -
 fs/xfs/xfs_fsops.c               |   4 +-
 fs/xfs/xfs_inode.c               |  20 ++--
 fs/xfs/xfs_itable.c              |  11 +-
 fs/xfs/xfs_log_recover.c         |  24 ++--
 fs/xfs/xfs_mount.c               |  98 +---------------
 fs/xfs/xfs_mount.h               |  21 +---
 fs/xfs/xfs_super.c               |   6 +-
 fs/xfs/xfs_super.h               |  14 +++
 fs/xfs/xfs_trans.c               |   2 +-
 fs/xfs/xfs_trans.h               |   2 +-
 fs/xfs/xfs_trans_buf.c           |   7 +-
 fs/xfs/xfs_trans_dquot.c         |  10 --
 35 files changed, 349 insertions(+), 387 deletions(-)
