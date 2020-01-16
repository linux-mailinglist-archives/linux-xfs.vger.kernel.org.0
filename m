Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15813D368
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2020 06:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgAPFKk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 00:10:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51878 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgAPFKk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:10:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59EYt193182;
        Thu, 16 Jan 2020 05:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=JAygRFxg6kSC5Gk3owh82tYyqOL55zbrfBySl840DY0=;
 b=iK8YmE7WtYUPxrnizZz4ZblXw3NtqcVfElVQdr8+atB97zWp+mJRpoqnqgRHus8dKjmw
 3YlMhf6h68V9DctT2XPDgCDncuNkHWVBsPOks5bQdbyCaqSEU+D3z1XSJ7YKDmdRM+0A
 ZVDSRSFNHgYuVxARRBPj5bo/iMj3jPCUmRAHXLG/Jpb9fKjQblHI+o9LwtzwPJ/Gk2o3
 Ey0GV7xyBm2aXkgayxkD5SWz4Dhl2PEUGp5rMnKWNC6eUkaboD0yZKa70rarDizN5TGo
 drz92CJZZh2jPc/tjGhjAlSpjz9hORycJwODVqrUWKV7q7VrSi2L42BZJY7TlOh8n5LN 9g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sg6ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:10:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G58NIE185648;
        Thu, 16 Jan 2020 05:10:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1at7hv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:10:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G5Aabh000377;
        Thu, 16 Jan 2020 05:10:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:10:36 -0800
Subject: [PATCH 0/7] fstests: random fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:10:35 -0800
Message-ID: <157915143549.2374854.7759901526137960493.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=547
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=622 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are numerous small fixes for regressions that I found while running
fstests on 32-bit platforms.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
