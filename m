Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93C52E826C
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Dec 2020 23:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgLaWsE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Dec 2020 17:48:04 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57172 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgLaWsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:48:04 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMkRTX155714;
        Thu, 31 Dec 2020 22:47:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=n412d0/qjaoMCxsU22B2OlK5pCvkNFeAl8qlEae0BNs=;
 b=GfZ9BRMFO/y687Wt8oT75gj3Z3q7zz1sqapRePo7WQ3dk4IO2cPra/DQRHVlXIl4UE7r
 JjYB7OihJUk5rROyKMOKoFMUGwC6YfLPJ5JAzRYXe5RpLbHuOfGzYsPOajtAqeAOl0Xc
 EL3guDVew+6DeZnuid9ToH4JykguFspV6lDanFbtlnhMNknXNK+rAFn1Ws+EhXsdLYwM
 OIKMKEDwlne500QHtGDi3IrItNXGEmDUTA/tTuLb+vI9xMp8hN9oYHUtH5RkYurYTlfk
 jEzWGbJL7PW6yZ1HIrOIrg3/K9VWLOMVSkgy6iYo59iFxHdGznbFK156fcwy8k6Ls5pv fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Dec 2020 22:47:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMj5iB015906;
        Thu, 31 Dec 2020 22:47:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35pf40pdgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Dec 2020 22:47:19 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMlDlV003839;
        Thu, 31 Dec 2020 22:47:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:47:13 -0800
Subject: [PATCHSET 0/2] xfs_admin: support upgrading v5 filesystems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:47:12 -0800
Message-ID: <160945483209.2835113.1168762329292387769.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
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

Extend xfs_db and xfs_admin to support adding the inode btree counter and
bigtime features to an existing v5 filesystem.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fs-upgrades
---
 db/sb.c              |   38 ++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_admin.8 |   12 ++++++++++++
 man/man8/xfs_db.8    |    7 +++++++
 3 files changed, 57 insertions(+)

