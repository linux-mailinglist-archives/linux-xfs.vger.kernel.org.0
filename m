Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D04C7D2F3
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 03:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbfHABmt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 21:42:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfHABmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:42:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711YF8g077232;
        Thu, 1 Aug 2019 01:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=WxU5/2HWRiFwp0we7nRWTUji4TtcT8iKyEDBsXp6ZU8=;
 b=andmXvxVxWLSUQswlER4tm32iz9lQe4puaSEMi9zK5H7TcjenU1hFaMw8o9j1oeAvGPS
 iaWpyj7pdHfFl0LabqFuaM5nPm9SrfAVolup/PCu6ws1ezSI0pXBof4Uzo4nnaC6u9r9
 82aOlF+CKEkb6ZOebiOD0WpMu+ybHBIiXQ3efu7fCfqraEcdKELkmQg9vs4ATOBFaNQG
 8paXEar+yOfKrvRuW+Qr+wIfznOb6TuGyxTlisbKBM6hFZYbWFAy54A/b9AKz/Ww6p50
 hFi1Q21fbiHweE1Z9kZslzOhMVE7MSwgFmam/rL5EQKgtPIs5FlMF7IqCih98+p6z9Gf WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u0f8r8gha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:42:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711WoNH060270;
        Thu, 1 Aug 2019 01:42:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u38fbdyk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:42:37 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x711ga4r010987;
        Thu, 1 Aug 2019 01:42:36 GMT
Received: from localhost (/10.159.254.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Jul 2019 18:42:36 -0700
Subject: [PATCH v2 0/5] xfs: fixes and new tests for bulkstat v5
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com,
        fstests@vger.kernel.org
Date:   Wed, 31 Jul 2019 18:42:35 -0700
Message-ID: <156462375516.2945299.16564635037236083118.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=943
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010012
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
