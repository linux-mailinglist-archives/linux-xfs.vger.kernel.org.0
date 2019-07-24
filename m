Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8CEB72993
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 10:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfGXILx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 04:11:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfGXILx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 04:11:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O896Xd122348
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=evwCLKvKq8ReFzbA/ZNiGPR8D5BqIwGgkCAL8S7fbhc=;
 b=HdctshUPLcIkYthsGhJ6FkGM/3k4NKAgc8BTGibiCPX7aSTCCAc3toepSjxJKZ0U9MP5
 Jj8C0azzjJFqz8EvddYYrFS783N6AJrGGC1yOri1xNb2co/34B+ngTn8IdHK5VmQZ1Pk
 FbZt2BmNjoKxkld5PpfbSOiAW1sgolsKsjVKb1L2TdIHy7NrJIEhobAcOhRRXUwDgWYu
 C7bcwD0TGzcsxnvUl9nEpr2HQ9TgBLs12obKb68rd/glyzQ+FiILiS2+KggztGzm2Ubd
 61eTt3hZhX2AxNCCXXNMAjcHaLpbe6bvk7Mis68ezQeRRubdke7iIffBYCd/sWDg/CeB 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tx61bunmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O88Br5145826
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tx60x389n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6O8BnN3011508
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 08:11:49 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jul 2019 01:11:48 -0700
Date:   Wed, 24 Jul 2019 11:11:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: [bug report] xfs: introduce v5 inode group structure
Message-ID: <20190724081143.GA30722@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=626
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=681 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240091
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Darrick J. Wong,

The patch 5f19c7fc6873: "xfs: introduce v5 inode group structure"
from Jul 3, 2019, leads to the following static checker warning:

	fs/xfs/xfs_ioctl.c:738 xfs_fsinumbers_fmt()
	warn: check that 'ig1' doesn't leak information (struct has a hole after 'xi_alloccount')

fs/xfs/xfs_ioctl.c
   730  int
   731  xfs_fsinumbers_fmt(
   732          struct xfs_ibulk                *breq,
   733          const struct xfs_inumbers       *igrp)
   734  {
   735          struct xfs_inogrp               ig1;
   736  
   737          xfs_inumbers_to_inogrp(&ig1, igrp);

The xfs_inumbers_to_inogrp() call doesn't clear the struct hole.

   738          if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
   739                  return -EFAULT;
   740          return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
   741  }

regards,
dan carpenter
