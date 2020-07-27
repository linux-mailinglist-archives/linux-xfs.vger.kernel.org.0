Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B7222E3FA
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Jul 2020 04:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgG0C0U (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Jul 2020 22:26:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44368 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgG0C0T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jul 2020 22:26:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R2LXUT162357
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=FzMsCe22/dPMJuNatTfp6abPZ12NCFjUcADWcPUQqnI=;
 b=yQEEOYKsjmwACCQnaVg8w5J8rkd0u9ffTnkfuWHjTUH880FL+4STvHYwZ+wC0l5Jnu2W
 ZSp3/r39PkicFLM0BYf+Iqp2D2ksDKqAtIb31K/gEUprYY+DpmZZKF3G6G9YhoBORwAy
 rrrVO8nf/sI9hYYw0nESFoqcAM+yo99aIvZ3UaUl7ZT5lvN2WdsqKUUIGHYu5FFxDKG/
 zEURBUddLpdXDw7N6x9AShLAmWRVfHwg89cMBFetYtZNtBJzS9RBbwNuFtaQb6Sa4tEF
 8jcUANtqZhfEQY+5WRUrMO7o/HR9QfYmfvtM95Pzaq4kWsw+zvyrUCHu7TdzJCU7jeE1 PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32gxd3j6g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R2OKer011258
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32hp3bg74f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06R2QHq6026091
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 02:26:17 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jul 2020 19:26:17 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2] xfs: Fix compiler warnings
Date:   Sun, 26 Jul 2020 19:26:06 -0700
Message-Id: <20200727022608.18535-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=1 spamscore=0 adultscore=0 mlxlogscore=914
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 suspectscore=1
 bulkscore=0 mlxlogscore=918 priorityscore=1501 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some variables added in the delayed attr series were only used in ASSERT
checks.  This caused some compiler warnings.  This is only declare them when
DEBUG is set

Allison Collins (2):
  xfs: Fix compiler warning in xfs_attr_node_removename_setup
  xfs: Fix compiler warning in xfs_attr_shortform_add

 fs/xfs/libxfs/xfs_attr.c      | 2 ++
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.7.4

