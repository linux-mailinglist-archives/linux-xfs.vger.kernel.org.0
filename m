Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03B6572DB
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFZUoV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:44:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:44:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKi0CT126161;
        Wed, 26 Jun 2019 20:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=i9DmPyOCH6y6Gz8q/3l9Zf4emWGQzlJjCj91Qo231jY=;
 b=S+kVr5rk+HKiZAC3aZHGY+kcskA/1hrPAgLYqmKWKtwrNEdA4O35j47lFq5s+msCPX/T
 S22Sl8LD1QXb8a8jH+8J6vWo5Z+lNWErpIJHlkn11Ay8nxulQemm3W7LJQhHSAN5JZ66
 XyFWyuTdHgktOECVuyKtFoku41jtkWRcp4LMnMPvvWEpawhzei4DcEmti+qKfYMcghuA
 H/GNpsIexpou7xVT8RkECIrIP7wZpu7jVE8ZFcAP4DtPLXRie7D5UijK8sGbiZcH9vov
 IPYqWXvIhoMFs+1VTcPjfc09/3T9AGZyCUfwq4D8Y1PXOdgHBT6OgMn6jw1KsU7puZkJ Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t9c9pvk0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:44:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhXTB142953;
        Wed, 26 Jun 2019 20:43:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2t9accwdb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:43:59 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKhwsf006306;
        Wed, 26 Jun 2019 20:43:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:43:58 -0700
Subject: [PATCH v6 00/15] xfs: refactor and improve inode iteration
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 26 Jun 2019 13:43:57 -0700
Message-ID: <156158183697.495087.5371839759804528321.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=945
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=990 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
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
