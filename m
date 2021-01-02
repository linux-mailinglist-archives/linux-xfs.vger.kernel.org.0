Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7772E8252
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Dec 2020 23:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgLaWpR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Dec 2020 17:45:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55668 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgLaWpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:45:16 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMiaDm154623
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lAy1inHoLrtuI/g7eigfwpI1r9D3Sr6VPCSCAwtlr7U=;
 b=IocPwuokX7sKKkSs/qvQfO6S46N8wKPcUPGIaewmX1Hn3dxtaWVBNPf26J4HE6alIfm2
 nEScgMWKG1KqXLoMUXly1HnBsd1bj0llQLkBAgPrRN1IGlOSItcK58p43kGk8qR55XL3
 QFvd2ZnnWcGO250t34HN/TGYk0P3cgwPQXVQ5+eTOIDzZHQSovYu4BJcy5FB4bL/UKFL
 vRpwRimQGekyvw+EbfSC2UHe+64/jQEHsCJjeCxS2D21PXwYne/N43sYqruhNWvwXxvb
 del48nJWc6OeMnkPUIt5xpnYeKbbM6GtLa/pCwJrs0Y1HR7nTUt9voMEMbTNNoY2mRqJ tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMehhV083635
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35pf307kjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:35 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMgZv3024289
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:42:35 -0800
Subject: [PATCHSET v2 0/2] xfs: fix online repair block reaping
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:42:34 -0800
Message-ID: <160945455414.2828471.12268741339940881464.stgit@magnolia>
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

These patches fix a few problems that I noticed in the code that deals
with old btree blocks after a successful repair. First, we clarify how
the reaping function works w.r.t. bitmap lifetimes.  Next we fix a bug
where we could incorrectly invalidate old btree blocks if they were
crosslinked.  Finally, we convert the reap function to use EFIs so that
we can delete blocks without overloading a transaction.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-reap-fixes
---
 fs/xfs/scrub/repair.c |  115 ++++++++++++++++++++++++++++---------------------
 fs/xfs/scrub/repair.h |    2 -
 2 files changed, 67 insertions(+), 50 deletions(-)

