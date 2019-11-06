Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A23F0DEF
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Nov 2019 05:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfKFEoQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 Nov 2019 23:44:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55786 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729303AbfKFEoQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 23:44:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64i63L078419;
        Wed, 6 Nov 2019 04:44:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=qb+eyMX1LsRpH6FuSg3RlPCukuTmPMjTW/BN0OpYDfI=;
 b=M3Mi97YWVIrfFrkZVzY2xj2yOi2aTPDsAmmgcPCMlYgSehoInwwyl1Hvs0jhjp63IcKW
 AngGM2BLe1Yy0/ZMMuyx7rzF8ZaRQYWoLhfOLPPOEO7c6+4kf5AZjoLOUT16bh5rfGke
 ZzlvZ2wPRavL22Lr1hCKYeyQU+N1dCR3OEjthUKrTZJvNGOnW9HD3RUI3gbzx1aSfbW8
 RSw2/iiNEiXV33DPxQQWom+ZXCLCMSMAE0a0hQbUpPKRc0o0TQQ3DRSMxLylASnZQQ2a
 6mWih26WfD+hGVzXWNEvDrkcU20hztSdebqICDS6o2ixLaRVjwzhsmRrV3Lr4J/lOJ+K JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12eraxuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:44:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64i8Oc034349;
        Wed, 6 Nov 2019 04:44:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w35pq7bq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:44:10 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA64gsgD031414;
        Wed, 6 Nov 2019 04:42:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 20:42:54 -0800
Subject: [PATCH 0/2] xfs: fix scrub timeout warnings
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 05 Nov 2019 20:42:53 -0800
Message-ID: <157301537390.678524.16085197974806955970.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=671
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=754 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series makes scrub more responsive to the user aborting a
scrub by sending SIGTERM; and fixes a problem where the stall timeouts
trigger when the kernel isn't preemptible.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
