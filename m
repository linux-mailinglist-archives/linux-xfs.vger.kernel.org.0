Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909CC55EF3
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 04:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfFZCgv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 22:36:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfFZCgu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:36:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2YQ5t030165;
        Wed, 26 Jun 2019 02:36:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=lgYxSGe7pEyMRvZ5fkoQRsWt2DYvFdmER9c7nuuM1zU=;
 b=dNhBmszma1YRv7PnwLWDQlQgaicXMsdPX0onQ8TG0Cy0GdqhFVLoP4lSScLKT5R5qnev
 JkqzBbbSmoK2+gN56bDAHCKY5k2N6dn8NM35Tl2ozLwflaMjVReohL8YsVbI793mL/Lz
 l9LlxSDcambEq8gUfTYFrO8LRb3Y0EpnGhic1hoagOD2SuSSwi2ZgNcLsg/kaIr16igF
 nmnxXAMgu5DxRkiTUsBr5kL8PjqbvCcKc0wPTiA8X+qUjf3HP1dbpbmqoCsLuvzMg1VW
 xBAbNpBnGH9YV5kXTPuftRz4KHa+epiC3jwunFw5iNyjHtcdPBrsF/HTWXPNGNDIrN6J OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t9c9pqjup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:36:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2ZVrD155860;
        Wed, 26 Jun 2019 02:36:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t9accejjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:36:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5Q2akIE022767;
        Wed, 26 Jun 2019 02:36:46 GMT
Received: from localhost (/10.159.230.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 19:36:46 -0700
Subject: [PATCH v4 00/10] xfsprogs-5.1: fix various problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 25 Jun 2019 19:36:45 -0700
Message-ID: <156151660523.2286979.13694849827562044045.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Latest respin of patches fixing various problems in xfsprogs.

Patches 1-6 refactor all utilities to use common libfrog functions to
retrieve the filesystem geometry, bulkstat, and inumbers.  The helpers
will make it easier for newer userspace to fall back to older versions
of ioctls.

Patch 7 fixes libxfs-diff to handle files that are in libxfs/ in xfsprogs
but still in fs/xfs/ in the kernel.

Patch 8 removes the nearly empty "convert.h" file from db/ to eliminate
the possibility of confusion with include/convert.h.

Patch 9 adds a new "btheight" command to xfs_db so that we can calculate
the size of each level of a theoretical btree.

Patch 10 moves the topology function declarations into a separate header
file since they're no longer libxcmd functionality.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.1-fixes
