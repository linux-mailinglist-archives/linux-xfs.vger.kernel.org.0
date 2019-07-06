Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C4361304
	for <lists+linux-xfs@lfdr.de>; Sat,  6 Jul 2019 23:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfGFVZa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 6 Jul 2019 17:25:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfGFVZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jul 2019 17:25:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x66LNptH105732;
        Sat, 6 Jul 2019 21:25:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=nR/YVtM/JP2NxLKc/9+o9RCrzFu6n1MKio4e8kts4jg=;
 b=o0T+RzCkhdcjJOv1qO4facvetBzNzhhACgf6gPmqnZJuycOln+mkTzIto9Qwxvl62HQf
 lsnAYSj+awmoFdL4mHwn9KI9/0niDhL2mojtzcanTrfuRjQVQK59P7NzmTvQp1nD6HbU
 bF4Rfwg98UkvwwV2Vtw+r2nDqDcceSvBjH9hH87rQbLqGgET/9zGMv5XHaqet9xYg2KR
 TFqovPH+cEB89KRb+jgRhMDVwPOIoBeSvuo3R+3YSRYEiSOIIRtGePb35JnI7dpYHkkJ
 iO0QtuDWXoTUpCkIMyUlFqwcvIzaNYYdIXRMkYBUXncnc9miRSRu3+5ZT8PRlOtqwRr9 jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tjkkp9jph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Jul 2019 21:25:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x66LMjG9064006;
        Sat, 6 Jul 2019 21:25:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tjhpc0889-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Jul 2019 21:25:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x66LPIv0001763;
        Sat, 6 Jul 2019 21:25:18 GMT
Received: from localhost (/10.159.231.118)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 06 Jul 2019 21:25:18 +0000
Date:   Sat, 6 Jul 2019 14:25:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>,
        kernel test robot <rong.a.chen@intel.com>
Cc:     Brian Foster <bfoster@redhat.com>, lkp@01.org
Subject: [PATCH] xfs: don't update lastino for FSBULKSTAT_SINGLE
Message-ID: <20190706212517.GH1654093@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=927
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907060288
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=983 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907060289
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The kernel test robot found a regression of xfs/054 in the conversion of
bulkstat to use the new iwalk infrastructure -- if a caller set *lastip
= 128 and invoked FSBULKSTAT_SINGLE, the bstat info would be for inode
128, but *lastip would be increased by the kernel to 129.

FSBULKSTAT_SINGLE never incremented lastip before, so it's incorrect to
make such an update to the internal lastino value now.

Fixes: 2810bd6840e463 ("xfs: convert bulkstat to new iwalk infrastructure")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6bf04e71325b..1876461e5104 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -797,7 +797,6 @@ xfs_ioc_fsbulkstat(
 		breq.startino = lastino;
 		breq.icount = 1;
 		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
-		lastino = breq.startino;
 	} else {	/* XFS_IOC_FSBULKSTAT */
 		breq.startino = lastino ? lastino + 1 : 0;
 		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
