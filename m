Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065FCA7A0E
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 06:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfIDEil (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 00:38:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54298 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDEil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:38:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cSi5028126;
        Wed, 4 Sep 2019 04:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=ELGTRdv/oXlsUQFTpsULsZTgj/Hd54yR9T9eO6VwEJM=;
 b=EW0AXTWTv5I0NF4kA7mlTtkLgVqtO/mcBdPLtEhYaGx6TXL6Bir2DCOzevUj4Sc1DTds
 R7luKy6kSml3KAO1HoI3ngb3HHnlqeShgWQOD//jsWnDpiF7pMGO+DnlNsxde9cglIaX
 cND6qUpHKZktc0cxDeqEJGzcbAgvJtRIHv1vqIJnCh6GO4G5p1QR/dZ9e0C8VG+v2CuF
 Fu2v3z9qRjSnWicxheJBNzxfxhZ+qw68bM0fV4RDEe80knoGMaWd3C5Dxh30uPk3eI5R
 vQ9tryX6Vk6jJmxT+yJ1a2cNQ11g4PKDBJqbG+UerK8AU0nTmr6LhJC/YaZCAZU9uoiQ vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ut6ds003k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:38:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cabJ035660;
        Wed, 4 Sep 2019 04:38:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2usu51c5ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:38:38 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844cHDl024489;
        Wed, 4 Sep 2019 04:38:17 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:38:17 -0700
Subject: [PATCH v2 0/4] xfs_spaceman: use runtime support library
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:38:16 -0700
Message-ID: <156757189636.1838733.8025635445292375382.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Convert xfs_spaceman to use the XFS online runtime support library.  The
first two patches clean up a few things.  Patches 3 converts spaceman to
use struct xfs_fd, and patch 4 establishishes libfrog unit conversion
helpers to replace open-coded conversion code.

This series comes after the xfsprogs 5.3 fixes series.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=spaceman-xfrog-conversion
