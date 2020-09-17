Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F97226D1A6
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 05:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgIQD25 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Sep 2020 23:28:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49580 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgIQD2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:28:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Oaim116016;
        Thu, 17 Sep 2020 03:28:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Ehzv4jcyzFZpMiZwj/7E91kUH8nk8rm5oqbgCYK+m4Y=;
 b=kef/L0W/uHXGYRNm/s1Kum+x9xIQp/wKhbGno8eNrVQLcmDpWFt/DfxwSLExHiK8Ypuc
 uEq7GwCN4OsuWNysBK1tJ3t4075fzTHw8WhVKOKH7XL4hGZAk2GI+c+k0Rv5NXPETPLU
 WnornhKbn9Ctq4nN63h73CDqrJOKDtt529y6N/me4zgiHzyQ0Cr9ezNeE5PPDqm04X3g
 nBE7WU3zH5iD/nSAr60hayJb+tdHQ03Hf1kpizguDNl/oQ/nEkes8KQfB0w3nWTGPv4L
 vfrfRoV1Hdd0WKpuXZLmPYc/fv210+twmanvZeaJvJTcCRs5ffsQgnArj/IGbaDDvOAn JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dr5fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:28:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Q2B8060956;
        Thu, 17 Sep 2020 03:28:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33khpmd15a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:28:45 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08H3SiCX020148;
        Thu, 17 Sep 2020 03:28:44 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:28:44 +0000
Subject: [PATCH 0/2] xfs: fix simple problems with log intent recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 16 Sep 2020 20:28:43 -0700
Message-ID: <160031332353.3624373.16349101558356065522.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Dave and I were talking about various issues that he had discovered
while wandering through the log recovery code, and then I started taking
a closer look and found bugs aplenty.  This first series is a very short
one that cleans up some low hanging fruit I found -- the most serious is
that we don't log new intent items created in the process of recovering
intent items that we found in the log, which breaks the recoverability
of log chains.  The other thing I found was that bmap intent recovery
didn't attach dquots, which could lead to incorrect quota accounting if
the BUI recovery caused a bmap btree shape change.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-log-intent-recovery
---
 fs/xfs/libxfs/xfs_defer.c  |   26 ++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h  |    6 ++++++
 fs/xfs/xfs_bmap_item.c     |    7 ++++++-
 fs/xfs/xfs_refcount_item.c |    2 +-
 4 files changed, 37 insertions(+), 4 deletions(-)

