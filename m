Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC84480FB7
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 02:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfHEAes (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 4 Aug 2019 20:34:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAes (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:34:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750OaKb030053
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=MJQLVXvRmRxkaGOsTzyCG0MchFsNBSUofm2UuLSl4UA=;
 b=EeS3qogYQb7CprIOVYG7i9NJGeiUy64veYOPvgxKFq1LvoNM2bsmrPo/LobQkih7Ak2c
 KF1DYmI0dgXbac2V/22tTp/dmJwiZSW2hJMTZ1R91aiMCuSEO8m+3ab7zqBx3gISEq+Q
 wYnBEq3JKOj62/aO5R0es8XTHYADbuuWiyoJ/lF8erGWG6ETQ5RF+LcH2w1ImqFelppG
 R4Oqq4TKbAxgzw0fdA+gx66341liAp64zjNUqrrn6+DL5rJ/1FouLLX4ezkQgKDcr7D/
 PtbxFIIH494O8PFYip9QjqCECk4HI2Z4ssPXWi0dQ4/I+TqP1Di6r/LjN8B850joVy+r wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u52wqv6qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:34:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750Mxlw149732
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:34:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u50abb894-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:34:44 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750YiAA017070
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:34:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Aug 2019 17:34:44 -0700
Subject: [PATCH v19 00/18] xfs: online repair support
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 04 Aug 2019 17:34:43 -0700
Message-ID: <156496528310.804304.8105015456378794397.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the first part of the nineteenth revision of a patchset that
adds to XFS kernel support for online metadata scrubbing and repair.
There aren't any on-disk format changes.

New for this version is a rebase against 5.3-rc2, integration with the
health reporting subsystem, and the explicit revalidation of all
metadata structures that were rebuilt.

Patch 1 lays the groundwork for scrub types specifying a revalidation
function that will check everything that the repair function might have
rebuilt.  This will be necessary for the free space and inode btree
repair functions, which rebuild both btrees at once.

Patch 2 ensures that the health reporting query code doesn't get in the
way of post-repair revalidation of all rebuilt metadata structures.

Patch 3 creates a new data structure that provides an abstraction of a
big memory array by using linked lists.  This is where we store records
for btree reconstruction.  This first implementation is memory
inefficient and consumes a /lot/ of kernel memory, but lays the
groundwork for the last patch in the set to convert the implementation
to use a (memfd) swap file, which enables us to use pageable memory
without pounding the slab cache.

Patches 4-10 implement reconstruction of the free space btrees, inode
btrees, reference count btrees, inode records, inode forks, inode block
maps, and symbolic links.

Patch 11 implements a new data structure for storing arbitrary key/value
pairs, which we're going to need to reconstruct extended attribute
forks.

Patches 12-14 clean up the block unmapping code so that we will be able
to perform a mass reset of an inode's fork.  This is a key component for
salvaging extended attributes, freeing all the attr fork blocks, and
reconstructing the extended attribute data.

Patch 15 implements extended attribute salvage operations.  There is no
redundant or secondary xattr metadata, so the best we can do is trawl
through the attr leaves looking for intact entities.

Patch 16 augments scrub to rebuild extended attributes when any of the
attr blocks are fragmented.

Patch 17 implements reconstruction of quota blocks.

Patch 18 converts both in-memory array implementations from the clunky
linked list implementation to something resembling C arrays.  The array
data are backed by a (memfd) file, which means that idle data can be
paged out to disk instead of pinning kernel memory.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-part-one

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-part-one

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-part-one
