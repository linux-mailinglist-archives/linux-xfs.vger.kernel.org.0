Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552C22127E4
	for <lists+linux-xfs@lfdr.de>; Thu,  2 Jul 2020 17:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgGBP3B (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Jul 2020 11:29:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50678 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgGBP3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 11:29:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FMUX5003890;
        Thu, 2 Jul 2020 15:28:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ARWF+eFhIRVL9PZ5dumu6SoMECwDZ2dVh+VI4+xRKtU=;
 b=FEaqUXLEcAdiViHyNNXzcATkaUYIMpsmCC8izec2shg6PIelufmFD+w4Dz/78Eb9MXQW
 4yT9x643fyB1u0lqA2uqNVtWy1FH8lWNegBW9tUab6s0eQU+dz0fvIya0A1egSUnJGTq
 6WONEYDKmP29VZoMmh5xGbSthfJDVLWdRLqGzuG4+uZ+38FO6nqKoWq9nzoUI5aJDmFR
 fpYcXhfWZG/awRLrMiQACBUaVRXlInfp01P08TiwbAZd3YnVQU+myQkQAsGxQ0etV/ny
 TGS5PFs1x9fgBJPG9qONwzOnHoEvB78APtY/nOiZl4myAHWo+goxyFQghhAXGF67XXGJ rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrnh3uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 15:28:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FN4kH033126;
        Thu, 2 Jul 2020 15:26:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31xg19jjg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 15:26:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 062FQsNN025482;
        Thu, 2 Jul 2020 15:26:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 15:26:51 +0000
Subject: [PATCH v2 0/3] xfs_repair: more fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 02 Jul 2020 08:26:50 -0700
Message-ID: <159370361029.3579756.1711322369086095823.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020107
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Two more fixes for repair: first, we actually complain if ag header crc
verification fails.  Second, we now try to propagate enough of an AGFL
so that fixing the freelist should never require splitting the free
space btrees.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fixes
---
 repair/agbtree.c  |   78 +++++++++++++++++++++++++++++++++++++++--------------
 repair/bulkload.c |    2 +
 repair/bulkload.h |    3 ++
 repair/scan.c     |    6 ++++
 4 files changed, 69 insertions(+), 20 deletions(-)

