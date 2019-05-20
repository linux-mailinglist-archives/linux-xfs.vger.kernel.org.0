Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48D8243FA
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfETXQr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:16:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfETXQr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:16:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNDela136210;
        Mon, 20 May 2019 23:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=COhFmLLBdmk+goGNZbOXdilNvyuNTKFL16WR0gusU2A=;
 b=OmOxOgORMSIPmk8+zPJqY9DFFKClNJ2o1fS/sOReSfBxDapOoqWKEAoXtbI6Kx/UWkEd
 54M99DJLQygaQ/h0HdAaph40ILIc0a+/mUBmUmF0/7CNRCqBHmDYRX5/m+2srvbvaOeM
 AiHdaLwHgESQ/xvM5PtAEA7gAoIEXOMDD6UnTKBg/pBnjOQC9KyWXTaIJRBXH5fxIil0
 HgiLua79DiOhzlwfjQsGXjOD7iviGQjvf21OkEy3kvHVR06ED+40IwJTitbsH6LPS7rT
 7O7uuIwYi/YrHtVsRPY0PANt548oV2hQOG0c3F28PvdFepkk9SOFqrS27uucJBA/hCSf NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sj9fta09s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:16:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNFT47118696;
        Mon, 20 May 2019 23:16:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2sks1xv82t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:16:43 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KNGgAt021767;
        Mon, 20 May 2019 23:16:42 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:16:42 +0000
Subject: [PATCH 00/12] xfsprogs-5.1: fix various problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:16:41 -0700
Message-ID: <155839420081.68606.4573219764134939943.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200142
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix various problems in the xfsprogs-specific parts of the libxfs code.

The first two patches fix some minor bugs in libxfs.

Patches 3-6 refactor all utilities to use common libhandle functions to
retrieve the filesystem geometry, bulkstat, and inumbers.  The helpers
will make it easier for newer userspace to fall back to older versions
of ioctls.

Patch 7 fixes the return types on the libfrog bitmap code functions to
be more general and less scrub specific.

Patch 8 ports xfs_repair to use the libxfs dirent and attr name check
functions.

Patch 9 reworks the xfs_scrub throttling function to use named constants
instead of magic values to make it easier to verify that it actually
does what the manpage says.

Patch 10 enables mkfs to set the DAX flag on the root directory.

Patch 11 strengthens mkfs's log alignment checking code.

Patch 12 enables reflink by default in mkfs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.1-fixes
