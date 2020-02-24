Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881B8169CCB
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2020 04:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgBXD64 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Feb 2020 22:58:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727168AbgBXD6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 22:58:55 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O3sExc076455;
        Sun, 23 Feb 2020 22:58:52 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yb1c5rabe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:52 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01O3tOQU078737;
        Sun, 23 Feb 2020 22:58:51 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yb1c5rab7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:51 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01O3tLL1018603;
        Mon, 24 Feb 2020 03:58:51 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 2yaux688xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 03:58:51 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O3wo4449611024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 03:58:50 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E897D6E04C;
        Mon, 24 Feb 2020 03:58:49 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CEF96E054;
        Mon, 24 Feb 2020 03:58:47 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.91.136])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 03:58:46 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: [PATCH V4 RESEND 0/7] xfsprogs: Fix log reservation calculation for xattr insert operation
Date:   Mon, 24 Feb 2020 09:31:29 +0530
Message-Id: <20200224040136.31078-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_07:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Log space reservation for xattr insert operation can be divided into two
parts,
1. Mount time
   - Inode
   - Superblock for accounting space allocations
   - AGF for accounting space used by count, block number, rmap and refcnt
     btrees.

2. The remaining log space can only be calculated at run time because,
   - A local xattr can be large enough to cause a double split of the dabtree.
   - The value of the xattr can be large enough to be stored in remote
     blocks. The contents of the remote blocks are not logged.

   The log space reservation could be,
   - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
     number of blocks are required if xattr is large enough to cause another
     split of the dabtree path from root to leaf block.
   - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
     entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
     case of a double split of the dabtree path from root to leaf blocks.
   - Space for logging blocks of count, block number, rmap and refcnt btrees.

At present mount time log reservation includes block count required for a
single split of the dabtree. The dabtree block count is also taken into
account by xfs_attr_calc_size().

Also, AGF log space reservation isn't accounted for.

Due to the reasons mentioned above, log reservation calculation for xattr
insert operation gives an incorrect value.

Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.

This patchset aims to fix this log space reservation calcuation bug.

Patches 1-2 and 4-6 refactor the existing code around
xfs_attr_calc_size(). Patches 3 and 7 change the logic to fix log
reservation calculation.

The patchset can also be obtained from
https://github.com/chandanr/xfsprogs-dev/tree/xfs-fix-attr-resv-calc-v4.

Changelog:
V1 -> V2:
1. Use convenience variables to reduce indentation of code.

V2 -> V3:
1. Introduce 'struct xfs_attr_set_resv' to collect various block size
   reservations when inserting an xattr.
2. Add xfs_calc_attr_res() to calculate the total log reservation to
   required when inserting an xattr.

V3 -> V4:
1. Rebase the patchset on top of Christoph's "Clean attr interface"
   patchset. 
2. Split the patchset into
   - Patches which refactor the existing calculation in
     xfs_attr_calc_size().
   - One patch which fixes the calculation inside
     xfs_attr_calc_size().
3. Fix indentation issues.
4. Pass attribute geometry pointer to xfs_attr_leaf_newentsize()
   instead of a pointer to 'struct xfs_mount'.

Chandan Rajendra (7):
  xfsprogs: Pass xattr name and value length explicitly to
    xfs_attr_leaf_newentsize
  xfsprogs: xfs_attr_calc_size: Use local variables to track individual
    space components
  xfsprogs: xfs_attr_calc_size: Calculate Bmbt blks only once
  xfsprogs: Introduce struct xfs_attr_set_resv
  xfsprogs: xfs_attr_calc_size: Explicitly pass mp, namelen and valuelen
    args
  xfsprogs: Make xfs_attr_calc_size() non-static
  xfsprogs: Fix log reservation calculation for xattr insert operation

 libxfs/xfs_attr.c       | 104 ++++++++++++++++++++++------------------
 libxfs/xfs_attr.h       |  18 +++++++
 libxfs/xfs_attr_leaf.c  |  39 ++++++++++-----
 libxfs/xfs_attr_leaf.h  |   3 +-
 libxfs/xfs_log_rlimit.c |  16 +++----
 libxfs/xfs_trans_resv.c |  50 ++++++++++---------
 libxfs/xfs_trans_resv.h |   2 +
 7 files changed, 138 insertions(+), 94 deletions(-)

-- 
2.19.1

