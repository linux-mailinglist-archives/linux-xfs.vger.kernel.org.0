Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8A1725BD
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 06:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfGXENW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 00:13:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53436 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfGXENV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O48fI6120945;
        Wed, 24 Jul 2019 04:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=WxU5/2HWRiFwp0we7nRWTUji4TtcT8iKyEDBsXp6ZU8=;
 b=WdHKfKaA46Hp+0fD/S5cwXA8mFm+eq9darxvL5OtpJ9/PFgmBmmDM+Iwmc6iJw881586
 vO6Ts7l/otXIOLwNlyXi8Ix9VfG38/TTnkKTA2Hk8gMZqzq7+QPDwSjuLQ0RVxR4iLIF
 uvQ+hpOiXpY4wBbo8jf7aFMGsgH4mFjDBaDXtgFO+tI91ZWLS2uJK/XN9iVFulf67gEx
 0FQ37GF/ckOJhfHyetRdRTICqKntVGtBQxro5jj1fRHtzOOv+dQeMq05XqTgCHDGlxos
 8MAWBElx4qxEFKc9BkltQ+Lvdn6aJmkgUY8CpCNPBY+a8Pjr3agBGiFrqHck5QMIsxeF aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tx61btjjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O4DJ3U140108;
        Wed, 24 Jul 2019 04:13:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tx60xg8m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:19 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6O4DFpH012978;
        Wed, 24 Jul 2019 04:13:15 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 21:13:15 -0700
Subject: [PATCH 0/4] xfs: fixes and new tests for bulkstat v5
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 23 Jul 2019 21:13:14 -0700
Message-ID: <156394159426.1850833.16316913520596851191.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=944
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=998 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix some problems introduced by the creation of the V5 bulkstat ioctl,
and then add some new tests to make sure the new libxfrog bulkstat
wrappers work fine with both the new v5 ioctl and emulating it with the
old v1 ioctl.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bulkstat-v5

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bulkstat-v5

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bulkstat-v5
