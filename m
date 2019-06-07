Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E032395A2
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbfFGTaU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:30:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56118 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbfFGTaU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:30:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSiG2086546;
        Fri, 7 Jun 2019 19:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=UZ2S0ZZ4U79EDumtXMIHYhHFmykPZ+d3YPRsyKpGjOQ=;
 b=pT9hZqb5rImJUEuLXV9wwffPRva/MwVuSoStdGOTiW3LP3cTna41yFhAxBvyyEdQVP6P
 3Afh7dI+dE7EIQZSTGSSkR8As3UtpOcEfbD918z3yKGVzpE2tO+Huy1RYxFK5OaUvjHM
 GH8OSfSfI2+QkMFA1/obs0HHe47E3Z2x4T2Tg7xrWYcvb9YhX+l1xYfkSOE2X1HWuGQ5
 dThALhwGFLqEPV6ifxKgB124QklY2NC0/Xtv5q5SNUuM7ZqP0WeWo08xkDp+hiN6T0XU
 bkPZA6sFcnRAogTDdGV7+v5EhNz83HKgOKACTrmmuUy4/+vBorPa8LUSra9npCQlVk9M uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2suj0r034y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:30:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSHvq053064;
        Fri, 7 Jun 2019 19:28:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2swnhbgcd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:28:17 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x57JSGEu030499;
        Fri, 7 Jun 2019 19:28:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 12:28:16 -0700
Subject: [PATCH v2 0/6] xfsprogs-5.1: fix various problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 07 Jun 2019 12:28:15 -0700
Message-ID: <155993569512.2343365.15510991248022865602.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Latest respin of patches fixing various problems in xfsprogs.

Patches 1-3 refactor all utilities to use common libfrog functions to
retrieve the filesystem geometry, bulkstat, and inumbers.  The helpers
will make it easier for newer userspace to fall back to older versions
of ioctls.

Patch 4 strengthens mkfs's log alignment checking code.

Patch 5 fixes xfs_io repair command error reporting.

Patch 6 fixes libxfs-diff to handle files that are in libxfs/ in xfsprogs
but still in fs/xfs/ in the kernel.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.1-fixes
