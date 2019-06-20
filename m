Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F904D99C
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 20:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbfFTSmx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 14:42:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41992 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFTSmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 14:42:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KId6jH063684
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=JP07mUbIBg+kf5Gh9ThkUHBUX5i/dtky0BZN9uZCWTY=;
 b=t+KdSOSoJ5xntD3ThdH3AMz5i7lxhiMyELJOU4wTh45IRiofk9YLQuDn6FtEbTaQvqZZ
 4rFOYWz575pJ5ZgZyiqcOHR5SS484Rifu4slKd++s3irO4DG39xhu+r6bboEhbVF+cFQ
 XYzXHuCIGWs/TISRu/ZIEpR/DX90rXKgBIikr2GZ8J7FyHtqbL9UP/2tzzHgg9U4cQ0l
 6Gr8VjTWuvLSt+i17GCwwYkBcFUCTVURktGhUCdLuIVLamomU2ELeL7dDYNIq4KJ9Lnm
 o7gLevbbkuPfj9AbCII8yQ0O9x83M5Y8FKDV/IrGYaawaZzvyi+bWFRrs50XG6WC2uPM Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t7809jpnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KIgdA2151491
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2t77yphh6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:51 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KIgorr019670
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:42:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 18:42:50 +0000
Subject: [PATCH 0/2] xfs: help mkfs shed its AG initialization code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 11:42:48 -0700
Message-ID: <156105616866.1200596.7212155126558008316.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=831
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=865 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200135
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
