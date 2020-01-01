Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09C012DD28
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jan 2020 02:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgAABUu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Dec 2019 20:20:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:20:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011Evr5112837;
        Wed, 1 Jan 2020 01:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=c0YpydhkmIdsI31MISNjSIFQZuzhdS2DJtU2j4d/dD8=;
 b=qMQymcshbW/F0PDNgdprSHmmBU4zXiTpVhVrK9ThySnOdDB0u5/GerXoFF7DN5b66/Y8
 4pgHUTYduNMVCeQc4yvWQE6zI/ysZpaNvo3rlrzZEo3NEYTQRzqskHH4uR3cjbY6h+nI
 QR3gr7RcMwFN+PFtctB73iNwMYmHXvnUtX+a+eyFdo3LsV68HU7kqVnQ34a3OGU4W2wv
 SSr9QXPejoUNyJ+gZXrwEKMnWGq9GFhvIJaZvauPK9jYEU5izng10iZ08aoXgWscQttm
 mcx5k96I2EinwpXdl32vJo110xfbbaqKJrpVi+2YQxZ94B2Cy2zVw4PE/JN+LEAsJv8U 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:20:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011IHl5057103;
        Wed, 1 Jan 2020 01:20:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x7medfhxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:20:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Ki0l015707;
        Wed, 1 Jan 2020 01:20:45 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:20:44 -0800
Subject: [PATCH v2 0/6] xfs_repair: do not trash valid root dirs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Tue, 31 Dec 2019 17:20:42 -0800
Message-ID: <157784164200.1371066.15490825981810186191.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Alex Lyakas observed that xfs_repair can accidentally trash the root
directory on a filesystem.  Specifically, if one formats a V4 filesystem
without sparse inodes but with sunit/swidth set and then mounts that
filesystem with a different sunit/swidth, the kernel will update the
values in the superblock.  This causes xfs_repair's sb_rootino
estimation to differ from the actual root directory, and it discards the
actual root directory even though there's nothing wrong with it.

Therefore, hoist the logic that computes the root inode location into
libxfs so that the kernel will avoid the sb update if the proposed
sunit/swidth changes would alter the sb_rootino estimation; and then
teach xfs_repair to retain the root directory even if the estimation
doesn't add up, as long as sb_rootino points to a directory whose '..'
entry points to itself.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-find-rootdir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-find-rootdir
