Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE0BE72B
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Sep 2019 23:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfIYVbL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Sep 2019 17:31:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfIYVbL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:31:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTO9l050816;
        Wed, 25 Sep 2019 21:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=5hF80WkrpbqWSgrqqL+0f78DBdMRowAmyea1RqWmnd0=;
 b=nY7pTYXRktU/nJlTRfrbbBpP9c9ogJ+H1OAivL/mMGSL3AJCO4i8dAgqlZDLREtXRjdd
 1kVDPnnJb0TqKwxpS+EqoR7aP8eAybRMHTB3UZB5YQp427Lnd/bgyVTAPaYWdN0lINyH
 ZBVNdQGDJZPKtN4ClZ2kO1yLR1D6dE/9Vhz2L11QP8XnqjSMI3Y0AacnK42o5BA4GH2W
 VtAL/U+rznXDyQEQ7EU9WpPumtyiY0EQJDHueUscoaJ71j6FdVn9J0wG/BsAzO4lpvZH
 PJd0/hU/tLI/8BPEYs72bQ95Cw92ozvBPIK9Lh0GNIjhGLdQd9qmlNdGyv/e5nDUlds5 OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgr7eeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTD5q085232;
        Wed, 25 Sep 2019 21:31:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v82qakkqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:08 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLV68m012507;
        Wed, 25 Sep 2019 21:31:06 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:31:06 -0700
Subject: [PATCH 0/5] xfsprogs: scrub filesystem summary counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:31:05 -0700
Message-ID: <156944706528.296129.7604742756772046951.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series introduces a totally new filesystem summary counter
online scrub feature.  Whereas previous iterations froze the filesystem
to count inodes and free blocks, this one drastically reduces overhead
by loosening its precision somewhat.  Instead of freezing the fs, we
race the expected summary counter calculation with normal fs operations
and use thresholding to check that the counters are in the ballpark,
where ballpark means "off by less than 6% or so".

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-summary-counters

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-summary-counters
