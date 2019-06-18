Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178A74A7C6
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 19:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730069AbfFRQ7w (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 12:59:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbfFRQ7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 12:59:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IGvhYl037808
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 16:59:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=uMZGPvVbTtdSRUo4ssCmGIJP6w8u6rIIQb3zMOTiEyw=;
 b=Xt4pq0xUTH9juo2FAzbG3Bdrh6AEf/9603apZL6Hnasc5VXruUcx37uBTdMSM2Nornf1
 sE/V4bDXJ2iUp42lfMPvgsti4RlvFcBnNWR0Xm4uQlvl1b6U7vR7jlmITdlVHGvAf26f
 dmzZ7qJxBQo4O3vaOz4yR8xr+AXnjf/aGtKBSWri5oY2JDgth5CMgIWBar5KCchpWE3K
 wTYx8zqH8MrFH8eeRAYxJN2l+POKiFgy+xwauai7R7AEXd37YAzSOVmmOk7KAlt/6JvO
 cL3ahp7yHi9trdw+7kWNrzRymWbw6pRRMAKSVXGNtxnPJY7F6IPoUqxKJ7C3ZES5VzhW 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t4r3tnt6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 16:59:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IGxlAC013490
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 16:59:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t5mgc2sx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 16:59:50 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IGxnOK006792
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 16:59:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 09:59:48 -0700
Date:   Tue, 18 Jun 2019 09:59:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to fe0da9c09b2d
Message-ID: <20190618165947.GD5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=837
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=888 adultscore=0
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

This announcement only covers building a new for-next branch from the
copy-file-range-fixes branch for wider testing.  I pushed this out a
week ago, but apparently forgot to send an announcement specifically for
for-next. :/

The new head of the for-next branch is commit:

fe0da9c09b2d fuse: copy_file_range needs to strip setuid bits and update timestamps

New Commits:

Amir Goldstein (7):
      [a31713517dac] vfs: introduce generic_file_rw_checks()
      [646955cd5425] vfs: remove redundant checks from generic_remap_checks()
      [96e6e8f4a68d] vfs: add missing checks to copy_file_range
      [e38f7f53c352] vfs: introduce file_modified() helper
      [8c3f406c097b] xfs: use file_modified() helper
      [5dae222a5ff0] vfs: allow copy_file_range to copy across devices
      [fe0da9c09b2d] fuse: copy_file_range needs to strip setuid bits and update timestamps

Dave Chinner (2):
      [f16acc9d9b37] vfs: introduce generic_copy_file_range()
      [64bf5ff58dff] vfs: no fallback for ->copy_file_range


Code Diffstat:

 fs/ceph/file.c     |  23 ++++++++--
 fs/cifs/cifsfs.c   |   4 ++
 fs/fuse/file.c     |  29 +++++++++++--
 fs/inode.c         |  20 +++++++++
 fs/nfs/nfs4file.c  |  23 ++++++++--
 fs/read_write.c    | 124 +++++++++++++++++++++++++++++------------------------
 fs/xfs/xfs_file.c  |  15 +------
 include/linux/fs.h |   9 ++++
 mm/filemap.c       | 110 ++++++++++++++++++++++++++++++++++++++---------
 9 files changed, 257 insertions(+), 100 deletions(-)
