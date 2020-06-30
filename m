Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34820F893
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jun 2020 17:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgF3Plj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jun 2020 11:41:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389624AbgF3Pli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:41:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFRQlO109692
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=zNZTp0/ma1B+ubn4UnjBX2xZ8VkOTFSyrrqj24xKco8=;
 b=S5gLOJdTnu1G0HsElff4QM/MfllshSOMmNFggz0BYGqSiEJ9sA8lpTJq0TlxaW4bBe5F
 zcOOpRzpTdKFmQKn7CVxW+S/fZ7vWizyhEycjOW2TRkdBwi2SLbP8+I4uIX7Q7T4XzSg
 S5UY5yIzUr4WOfGSdL1kouOHYM8NihXzGmhPujzTkSwKawEp6gfhNvO8Dg7GodO6epbe
 Si6VjQTid+tp/2YoMLVi/mUaZ+3GzErK16nvn09P8Gxas85iScNBWwfz/lUjGfLOWPMc
 bG1IQlBO7CHk0oAtO/hMrQJB4IYWGmauNbbXj+2427JhzRbDERL6d2FOutd3TbSfOe7Y jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31ywrbkj76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFNkLp051028
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg1wy4qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:36 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UFfaUe000415
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:41:35 +0000
Subject: [PATCH 0/2] xfs: strengthen online checking
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:41:34 -0700
Message-ID: <159353169466.2864648.10518851810473831328.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes some missed checks in the realtime bitmap scrubber.
We previously did not check the size of the rtbitmap file, nor did we
actually check that the extent map does not contain holes or unwritten
extents.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fixes
---
 fs/xfs/scrub/rtbitmap.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

