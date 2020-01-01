Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB3212DCE8
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jan 2020 02:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgAABMl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Dec 2019 20:12:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53722 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABMl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:12:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119dfM089262
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=zKQghzVlGgnljjR4PuyJIw/U+Ip5qZdHt8SYWRkoGOI=;
 b=nyqcN/4awvB9G7DH73AuTC4N7o5TQB0flVK+H9ZX3IOMf8ll+bePXAskswrAUMvCnQir
 +omSaQ2eFM9+IcCR9/R7wBFrwjDzFPZ3gs5yAPnVO7lETk0JV8sj1qlbjWuaZwUNSgxf
 NrGOKy3YbYtWb7jWULzQ7+uBrr/dA0U2ur8h06hz5O0GY8tHAjxnyElvA1kQKogZPvO4
 iqUp7hC/kmjJh8JrPdC11UNhE3HqEgEjxRgnwzHl51Hb85eUvJl2VVwRp0j+Fe3JpLJo
 GtoHTJTcpCZZkY4usOeP/+8NGX5S/2ImNnOIzXJOfKCwyP/0s4k+Fx7R3GzDcuo4s7kX Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uAC045259
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x7medfda4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:39 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011CcOg012310
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:38 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:12:38 -0800
Subject: [PATCH v2 00/21] xfs: hoist inode operations to libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:12:36 -0800
Message-ID: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=978
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series hoists inode creation, renaming, and deletion operations to
libxfs in anticipation of the metadata inode directory feature, which
maintains a directory tree of metadata inodes.  This will be necessary
for further enhancements to the realtime feature, subvolume support.

There aren't supposed to be any functional changes in this intense
refactoring -- we just split the functions into pieces that are generic
and pieces that are specific to libxfs clients.  As a bonus, we can
remove various open-coded pieces of mkfs.xfs and xfs_repair when this
series gets to xfsprogs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-refactor

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-refactor
