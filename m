Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDE02CE4CB
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Dec 2020 02:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgLDBN2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Dec 2020 20:13:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47048 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgLDBN2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:13:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4192kS014319
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=/qyUM3iayjQeZZ0piTUZm6bHRzjmGG2ejU9BRXTmPb0=;
 b=VKd++5SujF40BBh3gLk0QX7lophEOpj96+lhnfGtO/RZ54Wd4zmDxy+YYuLfxzeyru1u
 Zf2H3LiuGN7SblGiohAfC2vOsSHtskElO/9FUb2aDeMH9KLNDtd4sYFfOr3uKfWJmaLS
 51wXV1RXRb8r3Ysdki09B75Rn67HFy4wJjsY9UO5CtJmEkplhhYqtPxB8eiFq6lqW2Eb
 i8QbV4hqu5qUUWK0A1KsK0GomWrTsGK54kWsgY45Eu6Z/DbPTnRsIHtqZnWaQqxQvV+Z
 PKMT461SzVw/tpBK71mWVo0W4IhWJL4yIuxqg/q/HY5sLoEbG8tVQNg+Q9fl+6D9XDaT vA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egm0ymj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:12:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41BSFW157200
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:12:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540g2swb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:12:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B41CjZD025441
        for <linux-xfs@vger.kernel.org>; Fri, 4 Dec 2020 01:12:45 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:12:41 -0800
Subject: [PATCH 0/3] xfs: random fixes for 5.11
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 03 Dec 2020 17:12:40 -0800
Message-ID: <160704436050.736504.11280764290946254498.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=942 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=973 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a few fixes for 5.11.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.11
---
 fs/xfs/libxfs/xfs_bmap.c |    5 +++++
 fs/xfs/scrub/dir.c       |   21 ++++++++++++++++++---
 fs/xfs/scrub/parent.c    |   10 +++++-----
 3 files changed, 28 insertions(+), 8 deletions(-)

