Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7C14EFAF
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 21:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfFUT5A (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 15:57:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFUT47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:56:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJsD1b001921;
        Fri, 21 Jun 2019 19:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=JP07mUbIBg+kf5Gh9ThkUHBUX5i/dtky0BZN9uZCWTY=;
 b=irgxcIMMSoruQgjitx06G2E3M4thcdSpuJGjyYFF1BUznYlPQpeu0hTKEqSiepzhR7m1
 cNVhVYCxqtDaDLMkx+yioOC6LQCiIeCyxtRm3Tu9Qgc7WKgtQXDpheNZt5Gslezy2wN7
 k0p5Sy+NIU+rHjwwH/dqWK/cPV0SdKwFWav1apl77lST+9fkxfZH9jitqo/BYukT2rLp
 3iyAEPAKBdBauEPF4sopEMzk5iJTZHHbabjpGZIG0lPsXdB2pd0FaPKjKEezBqBE1oiL
 Sswlh86xDAsCP8KnAeQ12wAedGbQJ7Vn57MUYpmEg+nuW+eIpnfyfkxYr/B5fIcyhiv1 Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t7809r5s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:56:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJtKaL107004;
        Fri, 21 Jun 2019 19:56:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t7rdxwt7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:56:55 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LJutAA013433;
        Fri, 21 Jun 2019 19:56:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 19:56:54 +0000
Subject: [PATCH RFC 0/6] xfs: help mkfs shed its AG initialization code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 21 Jun 2019 12:56:53 -0700
Message-ID: <156114701371.1643538.316410894576032261.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=826
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=871 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this series, we start by adapting the libxfs AG construction code to
be aware that an internal log can be placed with an AG that is being
initialized.  This is necessary to refactor mkfs to use the AG
construction set instead of its own open-coded initialization work.

In userspace, the next thing we have to do is to fix the uncached buffer
code so that libxfs_putbuf won't try to suck them into the buffer cache;
and then fix delwri_{queue,submit} so that IO errors are returned by the
submit function.

The final patch in the xfsprogs series replaces all of mkfs' AG
initialization functions with a single call to the functions in libxfs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=mkfs-refactor

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-refactor
