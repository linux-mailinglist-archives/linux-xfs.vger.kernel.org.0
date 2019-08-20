Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9805E96A94
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Aug 2019 22:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfHTUah (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Aug 2019 16:30:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57298 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730619AbfHTUah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:30:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKT1Su180561;
        Tue, 20 Aug 2019 20:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=TZ/nr00KxUvyUvY2Gx6ZLubYK8APHkzshAY5ZuYdA9M=;
 b=McZe5GQsFIqtjNZ70KxAFuSCcnNvkhFj2Hm6RShbSD0WBWrRvnBKIppiVQ5FBFL6Ing6
 dKlPxAJKCXPomnXPpC9z1rlC1LMleIC3nYPZi26nxKI2FCBXN/Vr4KR1b5V/xFg2+I7f
 c2fe/bRbrO6Lv4SqWtucMMkXfolXqtQ0VOv1Zt2RgPCR217zXQnWWeQAya1v6cH5+ytd
 arjjxTk/LRRjMDIpUjf36TGEEBskIlmh5PqPnjRnNFpZPrGcDvpHe0+XcN+xXnNw9Tnf
 WcNt8IY3TyLDK/e2+Eb+llsUDRD9W9TWxjmLTeBqBAQQgl39lVNCIT04ziJwtLxcoDq1 xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ue9hph0dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:30:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTV41104948;
        Tue, 20 Aug 2019 20:30:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ug269633k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:30:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKUXFT019238;
        Tue, 20 Aug 2019 20:30:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:30:33 -0700
Subject: [PATCH 0/6] libxfrog: wrap version ioctl calls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:30:32 -0700
Message-ID: <156633303230.1215733.4447734852671168748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series introduces into libfrog some wrapper functions for the XFS
geometry, bulkstat, and inumbers ioctls, then converts the tools to use
the new wrappers.  This is intended to smooth the transition to the new
v5 ioctls that were introduced in kernel 5.3 by providing standard
fallback code to the old ioctls on old kernels.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libfrog-refactor
