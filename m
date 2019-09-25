Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0B1BE745
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Sep 2019 23:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfIYVc7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Sep 2019 17:32:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfIYVc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:32:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTHs2053920;
        Wed, 25 Sep 2019 21:32:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=vFFeP7qXkjhogfKQp8UNh6Z1PyPzKblDJJtP8Bby24M=;
 b=KgYyQMYds+RAfqvjkMKthrHLvHNhhZZ7J4W+V5OIpNMUvGEZb01OCyoEPphi9dsyYQ/e
 osy8qfpiuiqWdXf8xJGowvKQ/K+IswiaOpRjDlnGVZqUQbnbTT9gHBig5xpbWyziqvua
 sbEXM7eA5li8fsVLstEBO+ZjatWF5ySMWB5fxz3l/xZd6AnFuLtkGWdHC7fjLWTmepGt
 WYYsQG+4zU5jPdCrRJ2F5GGRHHqXrt8Mg7XKLqqqiCny56yyIiwENpX6+aeiMW23uIky
 y5+ZIYt1osJZEeHaAyTSfxxVakzsi+eCAAxYRIElnn3X8UADp7lDCqQgejU4bmq3tSA9 Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tygsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTEaE011682;
        Wed, 25 Sep 2019 21:32:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v7vnyum3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:55 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLWtgW014174;
        Wed, 25 Sep 2019 21:32:55 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:32:55 -0700
Subject: [PATCH 0/4] xfsprogs: bulkstat v5
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:32:54 -0700
Message-ID: <156944717403.297551.9871784842549394192.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=843
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=945 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this series, we do the heavier lifting to support the new v5 bulkstat
code.  First, we add an xfs_io command so that we can actually test the
old and new interfaces.  Then, we start converting spaceman and scrub to
use the per-AG bulkstat functions so that they can shed a lot of
duplicated geometry calculation code.  Finally, we speed up scrub phase
7 by fixing a minor thinko.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bulkstat-v5-factoring
