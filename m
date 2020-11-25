Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470F42C4927
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Nov 2020 21:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgKYUiC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Nov 2020 15:38:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgKYUiC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 15:38:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKOd3T136514;
        Wed, 25 Nov 2020 20:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4ph5lX7gNAo9G+r+Ma2YQOJpMNqyy61JNs/FR59JuCY=;
 b=PkNFPSQfEFUZrjX4qeDaCRr8SpmS8wVE8ZWhCH3Od5R7IHn6ikChhAo0kYSYg5uArq5J
 h+9xA/1ZO5cAkcCbGP9V7ZIId7KLLWvK1orwI59pEIVS4ePetNzsWGeCiEdDED3VGr9T
 uCPXheafQQFy3aofWDi7aICwxDfz1+i18ymFYVJNTi/xtuP69joQ0Hjh1Ql+ErESkpiM
 y/UjqgqoQxDDBJM+O+FY2hTR6mMbR3iTR2P4+Ahe7Z8Jg9ODZyug6CptIs9ev60JTjP0
 9WUjTzSIOxRggH5IXSrLRUx22X2usD/160e+mI7BR4Ln0XRuDyz4CssJgqK9YN/nPnfC Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 351kwhbars-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 25 Nov 2020 20:37:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKQ4xI066288;
        Wed, 25 Nov 2020 20:37:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 351n2jdye3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 20:37:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0APKbvDH028912;
        Wed, 25 Nov 2020 20:37:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Nov 2020 12:37:56 -0800
Subject: [PATCH v3 0/5] xfsprogs: fixes for 5.10-rc1
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Nov 2020 12:37:56 -0800
Message-ID: <160633667604.634603.7657982642827987317.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0
 spamscore=0 phishscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011250127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix various minor bugs in 5.10-rc1 (hence v3).

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.10-fixes
---
 debian/changelog           |    2 +-
 debian/control             |    2 +-
 include/platform_defs.h.in |    6 +++---
 libxfs/trans.c             |   14 ++++++++++++++
 tools/libxfs-apply         |   14 +++++++++++---
 5 files changed, 30 insertions(+), 8 deletions(-)

