Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958CE2E8259
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Dec 2020 23:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgLaWqT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Dec 2020 17:46:19 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56268 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgLaWqT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:46:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMia9X154626
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sFTiZc0VSemeWxrEYra06a6UtJ6YsxVucmpBjHq4qp8=;
 b=wz7tWi1WmIweix7faqXp51rSATfp0X1JVamSCQgWw6JdCBCL9GOY6TvV3ELuwi3BuOQg
 rijHDiRHHoAS2B+jLjX57ixpPU7q5cLjTqPfel7KsoeC8+2rrSc5b6f8A7vi2mpzyLzC
 OzmgTMrEOWVvKUrBz0/QlK29DA1FxRvGIEfv41hrttuFDzgw3xMtTZQOiIseEHVekTMK
 gUowSDFClQ0B1QuW7WZr0Q9EewpPZ5ONrKMpFSpSWxrVwv/GKMqLysLX4yu3tioIMAjS
 gL7FvBFbyaVbAYrCdKeDLjtR1AD3jMi4Qyssi+3AShhILQTckPGFSeVJeMs3zEZi+pEh uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMehhk083635
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35pf307mcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:37 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMjb1l025311
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:45:37 -0800
Subject: [PATCHSET 0/2] xfs: refactor realtime meta inode locking
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:45:36 -0800
Message-ID: <160945473626.2831998.4239234277317510682.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Replace all the open-coded locking of realtime metadata inodes with a
single rtlock function that can lock all the pieces that the caller
wants in a single call.  This will be important for maintaining correct
locking order later when we start adding more realtime metadata inodes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rt-locking

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rt-locking
---
 fs/xfs/libxfs/xfs_bmap.c |    7 ++-----
 fs/xfs/scrub/bmap.c      |    4 ++++
 fs/xfs/scrub/common.c    |   32 ++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h    |    2 ++
 fs/xfs/scrub/rtbitmap.c  |    9 ++------
 fs/xfs/scrub/rtsummary.c |   26 +++++-------------------
 fs/xfs/scrub/scrub.c     |    3 ++-
 fs/xfs/scrub/scrub.h     |    8 ++++++++
 fs/xfs/xfs_bmap_util.c   |    5 +----
 fs/xfs/xfs_fsmap.c       |    4 ++--
 fs/xfs/xfs_rtalloc.c     |   49 ++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_rtalloc.h     |    9 ++++++++
 12 files changed, 110 insertions(+), 48 deletions(-)

