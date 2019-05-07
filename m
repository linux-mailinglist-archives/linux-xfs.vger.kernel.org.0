Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C55A1687A
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 18:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfEGQ5F (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 May 2019 12:57:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfEGQ5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:57:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47GhqIJ183779;
        Tue, 7 May 2019 16:56:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=bQUsbqApeW1fEUPJVowUezZqc3rYDjf/ZVOz66GjwYY=;
 b=jdsClnmn8wG4td2U0Z+7iLpzX3f64l7IZfoX9UafqHZ14OE9ck5VBYmFPBrdSkXZZNEs
 sKYclx4h4M5Ca9YSDNhOY4ymN58EPWP/gkidiRVvHBEn+/dJjxa1k+ZxnEP2vVORlgCQ
 oxYaE3/rnZLbt+DBH2CLYCLu4dlCTBPFWYPyIG3UpG89NEXXrrS5mddmt8pjHeTkB1ym
 A3f0LIE/UjMQlGhkaeww4sYNK9qdfPi349sWCzyvUOoHbqHwKvISxCSl/W5tAr+0/7hv
 5dnqmF8SC7YcnxPc1Q2WgZzS917ZYNbZgaBDCzM3Mh7zSDrK81goZEBgCDsSeA7usckv tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2s94b0prt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 16:56:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47Gtx6E002885;
        Tue, 7 May 2019 16:56:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2sagyu29m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 16:56:52 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x47Gupae006442;
        Tue, 7 May 2019 16:56:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 May 2019 09:56:51 -0700
Subject: [PATCH 0/3] fstests: various fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, xuyang2018.jy@cn.fujitsu.com,
        fstests@vger.kernel.org
Date:   Tue, 07 May 2019 09:56:50 -0700
Message-ID: <155724821034.2624631.4172554705843296757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=965
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905070109
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905070109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are three patches fixing various regressions in xfstests when
mkfs.xfs defaults to enabling reflink and/or rmap by default.  Most of
the changes deal with the change in minimum log size requirements.  They
weren't caught until now because there are a number of tests that call
mkfs on a loop device or a file without using MKFS_OPTIONS.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
