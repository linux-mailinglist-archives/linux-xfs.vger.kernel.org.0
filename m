Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECA733B94
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 00:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFCWvE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 18:51:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfFCWvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 18:51:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53MnaJO162867
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=XYyabSclwFl+2teVF5OVbnmaZAsSwQT6i7Vv3GjeCNk=;
 b=auhfnl/+0srXUh95liMFNrCIWn9tdDh4yQUQdHRBf4svBEkz6mQZ1+6k47EHFIK6CkPp
 Vna9ImBKko9VAo3pD5vtka7xMJYhhbE1BEIJNZc6YpDztXRlNFWIW6CSq7St8/c+B4YX
 NPQR7xUwLzVLNBQ3D21XCi8rdg7EuHcmP+zqHmf5byDCh5m4geVKG9wJTkvc+MM3N5nA
 sGHkswS3nRoc9iYAdgCzGzKZgBhuo6WFSHpgOpFwimzdDe+WsQ7QH9DeDUVSSwjKnRWP
 XYRq364TynFfyX6TETFu3lIpOEeQgrGFoowOo7PIEVc3IN3kr63tmOs1zfcNsXR6xGI5 WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugst9sdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53Mol1B032667
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sv36sfgn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:01 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x53Mp0WU023475
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Jun 2019 15:51:00 -0700
Subject: [PATCH v2 0/5] xfs: refactor inode geometry
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 03 Jun 2019 15:50:59 -0700
Message-ID: <155960225918.1194435.11314723160642989835.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=907
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906030153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=940 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906030153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series starts by moving the in-core inode geometry calculations
into a separate structure.  It then combines several of the inode
geometry calculation functions into a single setup function.

Next we fix some longstanding bugs in the inode cluster size usage so
that inode flushing and log recovery on 64k-block filesystems works the
way it's supposed to.  Finally, we replace various open-coded geometry
calculations with accesses into this structure so that we calculate
positions and offsets of inodes and inode clusters correctly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-geometry

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-geometry
