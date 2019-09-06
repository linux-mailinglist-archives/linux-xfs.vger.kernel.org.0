Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F014AB10D
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 05:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388768AbfIFDgT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Sep 2019 23:36:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732205AbfIFDgT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:36:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YDXS109862;
        Fri, 6 Sep 2019 03:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=C6p1fSJZi6SNjHkFQPtqCuHY8mweUIo2ZZQdXB/fFmo=;
 b=fmePW+mIVMFbFgGD6OPE6xp4UnZd2OGlhmh3LIQ8quZXCSsD25A9u2f2dA/v2c4Gcz6l
 ZVW/gfQ4i29jQTuqRX87VctSH9sxSE21qiFf2kdrrPAP29yu78GAaZuiricLea6SxBoE
 rU+sKEpdMZ/r+bZhhgiMUOmd+PuQ6F8t9nTqLT3ZCKtiGmtNqi1yKe9XaV9ZFuoY/G56
 CwSdEwSri6ums59t0hmFlCa0ZWNAQTRxultuxpiktjOLSf12NH3LUIYMt9E+s5WjAWe5
 gTOSA/agYMpViP6VMqXlt9iRsWdbTjqr1ajHmsk7lexNFlL/yXoM0QzZsZZPvx4aWX07 Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uuf4n038w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YOsO088476;
        Fri, 6 Sep 2019 03:36:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b99rrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:16 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863aFjT014969;
        Fri, 6 Sep 2019 03:36:15 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:36:15 -0700
Subject: [PATCH 00/13] libfrog/xfs_scrub: fix error handling
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:36:15 -0700
Message-ID: <156774097496.2644719.4441145106129821110.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=875
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=942 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The new code introduced by xfs_scrub do not deal with error returns in a
consistent fashion.  Some places we return -1 and set errno, some places
just do whatever libc does, others return positive error codes, and the
worst offenders do a combination of that.  Worse yet, sometimes we also
fail to check for error returns at all.

This series replaces all that with a single error handling strategy --
return positive error codes and always check the return codes from other
library functions.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libfrog-error-handling
