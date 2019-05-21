Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F5C25427
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 17:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfEUPhp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 11:37:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:35596 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbfEUPhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 11:37:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LFYFGr132480
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=GrU7345dptx6l25mpmvLzmme//dVzrImIjaFZFZixKU=;
 b=rLzYH3cfnEQ3GoGJ7UTi9kgmhiQ6UDLQkM2AnUytG541ooG/ZPlEjtA6tHXDPBQpBisp
 zE2YGmb9BdLeN1MhZwj2QdnSUIdU9Ebs8vwpnNLJv5SZQf4+XC5ttWJMhm2ngzp57RTA
 Q3Ltxu8kkLO2fpY3naovV6mbCBcx7mssTyjH3+WNCYDzFyCMOAHEgPPfQ1HO25O6oVKs
 vMV0b8rE7k4fE+Vz8PrMn2F2BEhTXI/oLsYbkQ41CMIhoR4MvodT51r5IPkn/Fd1Dp3c
 74umIL+HhTK9+NSEFwtqaKdStr5VgVuMMvklbWLzpO1fHsbmZ+FjyzCMKWvlYHl4jGe2 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2sj7jdpgbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LFbeH6116084
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2sks1jh64u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LFbgYj031610
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 15:37:42 +0000
Date:   Tue, 21 May 2019 08:37:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5cd213b0fec6
Message-ID: <20190521153741.GA5141@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905210097
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210097
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

5cd213b0fec6 xfs: don't reserve per-AG space for an internal log

New Commits:

Darrick J. Wong (1):
      [5cd213b0fec6] xfs: don't reserve per-AG space for an internal log


Code Diffstat:

 fs/xfs/libxfs/xfs_ialloc_btree.c   | 9 +++++++++
 fs/xfs/libxfs/xfs_refcount_btree.c | 9 +++++++++
 fs/xfs/libxfs/xfs_rmap_btree.c     | 9 +++++++++
 3 files changed, 27 insertions(+)
