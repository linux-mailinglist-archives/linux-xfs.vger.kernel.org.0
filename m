Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAD44D43A
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFTQvf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:51:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55694 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFTQvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:51:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnBRb173690;
        Thu, 20 Jun 2019 16:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=qNJWXfrLccdOTTxZaVlmy8weneIvhDJmpsLiQt0B+5I=;
 b=yrvD5hcQFMgPhGR79zC8xqyx9iZ6P/xAMppp19ytahgwH/btu0PYvW45qMriLuqNOotf
 qjWdCkqRgB9GGnkh5/MQLWTGMe86Nd8icie6uUlFJa64LrRCTKI5+ISPGqNHdoSUVZpr
 Ad4C11p4h1qM468PCbDyCRDdsyt3KZ8kgFtRezLz4GjYCbR0sjTyCjGr+rWgnJMvx0vW
 38W5covhEktZf47j95ruIn6WLxzLiuSboG9N0+fXaq6iQ3XsnWK+Ohp+HiU4KVqN9pY4
 4ykO8tJgpR6yxLFzVGoZg9a3cgZ2A5tmGWEZGfdBB6iqWWHgtGZ9HfcNeUvheXFddBW0 qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t7809j7du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:51:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGltho053906;
        Thu, 20 Jun 2019 16:49:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t77ynqnw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:49:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KGnVVK012434;
        Thu, 20 Jun 2019 16:49:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:49:30 -0700
Subject: [PATCH v3 00/12] xfsprogs-5.1: fix various problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:49:29 -0700
Message-ID: <156104936953.1172531.2121427277342917243.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Latest respin of patches fixing various problems in xfsprogs.

The first two patches fix some problems in the number conversion code.

Patches 3-5 introduce a new structure for managing xfs runtime context.
For now this simply associates a file descriptor with reported xfs geometry
(and some computed values) that enable us to refactor per-ag calculations
out of xfs_scrub.  Later we'll use for things like graceful degradation
when xfsprogs supports bulkstat v5 but the kernel doesn't, and also doing
per-ag scanning operations.

Patches 6-8 refactor all utilities to use common libfrog functions to
retrieve the filesystem geometry, bulkstat, and inumbers.  The helpers
will make it easier for newer userspace to fall back to older versions
of ioctls.

Patch 9 strengthens mkfs's log alignment checking code.

Patch 10 fixes xfs_io repair command error reporting.

Patch 11 fixes libxfs-diff to handle files that are in libxfs/ in xfsprogs
but still in fs/xfs/ in the kernel.

Patch 12 adds a new "btheight" command to xfs_db so that we can calculate
the size of each level of a theoretical btree.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.1-fixes
