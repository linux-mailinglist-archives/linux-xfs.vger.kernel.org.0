Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5FF5A3C8
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jun 2019 20:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfF1Sfe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 14:35:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfF1Sfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 14:35:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SIYsAP109247
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=0WPxXhK8lqkCRYbqw4qyPwFpiCliMqu41qKKmFS3QJA=;
 b=UBAmfHNE1j8qrhgmPLRuzFGilzpKaOWzcXcXxlhrjql8Sb28sANYkZ86jE/+Zprp0oeC
 RUshxyRRO37AOGvGmknT3PWMuduJcyIwfov3XEq2BzHsO9KSjpt9hKf3uMtRvWG/Axuu
 JDaX0pONKWgrEecsUQmrJ31Tr8welHKfghFdi3/d1TCw4KodhElhjvJN83N9pJL5uMOj
 NgmklnIrNuCHP9V1RREjhDsUIO6yYyzJunKeAGa0ZwN4dl3Ueaqd+305PN4szf7Ttb1y
 yzZqTVTEheRU2cWMm4jX5Jk4zlxvTXe+FFUWsNk7k/bUIbQzJ/UXHwbSWyym/FcnH+Ga KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brtq3m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SIZW6m004345
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tat7e3gft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:32 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5SIZSwC022272
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Jun 2019 11:35:27 -0700
Subject: [PATCH v2 0/3] xfs: further FSSETXATTR cleanups
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Jun 2019 11:35:26 -0700
Message-ID: <156174692684.1557952.3770482995772643434.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=922
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906280209
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=991 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906280210
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Now that we've refactored a lot of the FSSETXATTR parameter checking
code into generic functions, shorten the XFS FS_IOC_[GS]ETFLAGS
implementations by making them wrappers around FS_IOC_FS[GS]ETXATTR.
Finally, kill all the useless support code that prepared the memory
manager to change the S_DAX flag since none of it works anyway.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=setxattr-cleanups
