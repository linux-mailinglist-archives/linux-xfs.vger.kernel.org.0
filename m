Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B92884C2
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfHIVhg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:37:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49420 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfHIVhg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYXTh071914
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=R9r4AyazEiXw/CEamfK+fzXmofgcK5m8+qQL/lUIYcc=;
 b=Fnajh5zSaNMmwe+OWqr9ITkAxvAiHR6hdX1ptGbbBB05mieH8qObTyFf3lLpddT1/QFP
 ULh7v/tyjFK1O5oMnt0KK45b/OvXxipqpkLhwJu1QoahPJEOu8KFAjXkELBA4mmKKsUp
 u49fB1nYnIOvcQE5RY99Smnep4Pff/veiopg4NccMWwGcaHW+Rfe1KuioQKuqXFCq3GV
 HbrI1iLpsxAj30ncib5zekBH3HF1RJmtCtLcit7IU9Oq9AdgOhRsb1iQnxR1eJhb5o5X
 5ZFntxN5aS3xvJy3xhlfNQISDU0WatmefO8aWraVFLukYqDUFThAHz6KStZupiXFH9I5 mQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=R9r4AyazEiXw/CEamfK+fzXmofgcK5m8+qQL/lUIYcc=;
 b=MYCmX91jCs70hfNAacFw+MoSCie38eEhLgW2I2dDbvWylj7m9vtCAkmYAJYhGfPJwpUA
 8dO4cxNq3Nq6yEzi5BXFHR4sgXTa3dMq/PZvbnJ7m2rHsiHA91oaghXWsJ1jslPlXc0k
 3f9DWVspcKSebtn3XeXui7EsAq5HjP5+lfT3h5vamAVVn7sJHXvvG5rrSNi+4jtBHNhP
 5nm4ECNRibq/re/BpERwjfmbL3z9/jNQEFkXw9/54yvyb0zeM326Oo95n7UvUSDZ8Bs6
 OnWkUdbLZaLFKTPSyYoBoWLSn1wWpytUaxSVC6B7nH+skEm1/Nvq8y/koTaTIJYciKib oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LO3Ne007968
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u8x1h6vfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LbWNl018939
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:33 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:37:32 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 00/18] Delayed Attributes
Date:   Fri,  9 Aug 2019 14:37:08 -0700
Message-Id: <20190809213726.32336-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for parent pointers. 
Delayed attributes allow attribute operations (set and remove) to be 
logged and committed in the same way that other delayed operations do.
This will help break up more complex operations when we later introduce
parent pointers which can be used in a number of optimizations.  Since
delayed attributes can be implemented as a stand alone feature, I've
decided to subdivide the set to help make it more manageable.

Changes since v2:
Patches 6 through 17 are new and focus mostly on refactoring the
attribute set and remove operations.  Since delayed operations can
not be handling transactions, to goal of the refactoring is to
factor up the transaction specific code as much as possible while
modularizing the remaining code into helper functions that we can
reuse for our new delayed attr routines.

Patch 15 then adds a new set of xfs_attr_da* routines that
return EAGAIN when a new transaction is needed.  Patch 14 adds
a new struct xfs_delay_context which these new routine will use
to stash local variables or other information they need to more
or less pickup where they left off. 

I've also made the corresponding updates to the user space side, and
added a new test case to xfstests as well.  I'm still getting an
error about busy inodes after the journal replay, but I figure
theres plenty here to people to review while I work on that.

Question, comment and feedback appreciated! 

Thanks all!
Allison

Allison Collins (13):
  xfs: Replace attribute parameters with struct xfs_name
  xfs: Factor out new helper functions xfs_attr_rmtval_set
  xfs: Factor up trans handling in xfs_attr3_leaf_flipflags
  xfs: Factor out xfs_attr_leaf_addname helper
  xfs: Factor up commit from xfs_attr_try_sf_addname
  xfs: Factor up trans roll from xfs_attr3_leaf_setflag
  xfs: Add xfs_attr3_leaf helper functions
  xfs: Factor out xfs_attr_rmtval_remove_value
  xfs: Factor up trans roll in xfs_attr3_leaf_clearflag
  xfs: Add delay context to xfs_da_args
  xfs: Add delayed attribute routines
  xfs: Roll delayed attr operations by returning EAGAIN
  xfs: Enable delayed attributes

Allison Henderson (5):
  xfs: Remove all strlen in all xfs_attr_* functions for attr names.
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Add xfs_has_attr and subroutines
  xfs: Add delayed attributes error tag

 fs/xfs/Makefile                 |    2 +-
 fs/xfs/libxfs/xfs_attr.c        | 1145 ++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_attr.h        |   49 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |  167 ++++--
 fs/xfs/libxfs/xfs_attr_leaf.h   |    4 +
 fs/xfs/libxfs/xfs_attr_remote.c |   98 +++-
 fs/xfs/libxfs/xfs_attr_remote.h |    5 +-
 fs/xfs/libxfs/xfs_da_btree.h    |   23 +
 fs/xfs/libxfs/xfs_defer.c       |    1 +
 fs/xfs/libxfs/xfs_defer.h       |    3 +
 fs/xfs/libxfs/xfs_errortag.h    |    4 +-
 fs/xfs/libxfs/xfs_log_format.h  |   44 +-
 fs/xfs/libxfs/xfs_types.h       |    1 +
 fs/xfs/scrub/common.c           |    2 +
 fs/xfs/xfs_acl.c                |   26 +-
 fs/xfs/xfs_attr_item.c          |  804 +++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  102 ++++
 fs/xfs/xfs_attr_list.c          |    1 +
 fs/xfs/xfs_error.c              |    3 +
 fs/xfs/xfs_ioctl.c              |   21 +-
 fs/xfs/xfs_ioctl32.c            |    2 +
 fs/xfs/xfs_iops.c               |   10 +-
 fs/xfs/xfs_log.c                |    4 +
 fs/xfs/xfs_log_recover.c        |  174 ++++++
 fs/xfs/xfs_ondisk.h             |    2 +
 fs/xfs/xfs_trans.h              |    4 +-
 fs/xfs/xfs_xattr.c              |   20 +-
 27 files changed, 2504 insertions(+), 217 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.7.4

