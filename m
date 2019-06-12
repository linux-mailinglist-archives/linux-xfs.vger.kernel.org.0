Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A60041C83
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 08:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFLGrz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 02:47:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52692 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfFLGrz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:47:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6hb1U062422;
        Wed, 12 Jun 2019 06:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=i9DmPyOCH6y6Gz8q/3l9Zf4emWGQzlJjCj91Qo231jY=;
 b=YSAVbnVSAoMviX7NjhiEPUuxbtlMtgT03DVcWmX60TCI+WXazdTepjFcVG2s3335oDDv
 K87bZl7PBoA0ZydkEm07xLFic1tg/q0GM0Hr0hai1OVFrY4AuQgfcJFkX0MCqQ1qC84m
 mBjn6e7/mLsw6mdTisRa4ZsIXcWgrSYfZk0m7QeNgeWkHsU316UD1RzsPoZCNcg5D0YX
 dvxa9JAPDNyHJ6WpByQotdccJSpBDJFVanQFa2Dlzu6M4yKzFzri0VSew8y0AN0F+iha
 5GZYp7W/uE9dtQnJP4TJe2sDqg7xDpulSCyoYYP6JiuVm+sr11Hc963diO69oCDnCXKI Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2t02hesk38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:47:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6lTBk096667;
        Wed, 12 Jun 2019 06:47:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t024uth7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:47:33 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5C6lX74005662;
        Wed, 12 Jun 2019 06:47:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 23:47:32 -0700
Subject: [PATCH v5 00/14] xfs: refactor and improve inode iteration
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 11 Jun 2019 23:47:31 -0700
Message-ID: <156032205136.3774243.15725828509940520561.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=951
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=992 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120046
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This next series refactors all the inode walking code in XFS into a
single set of helper functions.  The goal is to separate the mechanics
of iterating a subset of inode in the filesystem from bulkstat.

First we clean up a few weird things in XFS, then build a generic inode
iteration function.  Next, we convert the bulkstat ioctl to use it, then
fix a few things from some of the code we saved from the old bulkstat
inode iteration code.  After that, we restructure the code slightly to
support the inumbers functionality, and then port the inumbers ioctl to
it too.

Finally, we introduce a parallel inode walk feature to speed up
quotacheck on large filesystems.  The justification for this part is a
little questionable since it needs further discovery of what hardware
and software this works best on.  It's also an open question of whether
or not bulkstat could be optimized further.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=parallel-iwalk

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=parallel-iwalk
