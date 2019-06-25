Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F304520D0
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 05:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbfFYDCg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 23:02:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41846 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730654AbfFYDCg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:02:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P2xUqT183808
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=j83NM7QDG8GpK2CGkq9Z3vbInm5eRrFTvl7uNw01xag=;
 b=N8luQlAkvNt1SQFAVcSB9XKBpo7fhRTToUE5NnFXZ6nBnuffI5oY0oZffB5nRYopdmTa
 xe2CZb9gbLIxgqJCQiAKYFTig0AC55IV67wFTM50ei6wWdws2K/uKrUZ13nec5WNmBgy
 mih3Z89t8/GElYb92rkBKtw2huyHkIdRVcCIsXpg3Qz28ovKE30Oa6XyV1w23FJYPfSJ
 cBrxGjogDtudWrDLJJ58EJfvOZSR8/nRfm9BQ0WeJpxdHJzgond7ul6ITQAQsAcurQxB
 mF/vfVqrGIGywGPGyglnaJcqTnmYfV/NxDfttpdGx43kOczOuND2KqAiCcYgGAOMlfdG mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brt1h9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P31XOj163879
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tat7byrw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:34 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5P32YXs032327
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 20:02:33 -0700
Subject: [PATCH 0/5] xfs: extended attribute scrub fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Jun 2019 20:02:32 -0700
Message-ID: <156143175282.2221192.3546713622107331271.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250023
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I discovered by sampling xfs_scrub stack trace swith a flame graph that
the attr scrub code has a sizeable oversight -- the xattr scrub code
always allocates a zeroed 65K temporary buffer before locking the inode,
even if it then turns out that the inode does not have extended
attributes.

In addition to the pointless memory allocation, the scrub code itself is
careful to initialize whatever part of the memory buffer it's going to
use before reading the contents, which means that the memory clearing is
not only painful (it's 5% of the sample traces!) but totally pointless.

Therefore, this series first cleans up the open-coded pointer
calculations where the buffer is concerned, and then restructures the
code so to allocate the smallest size buffer needed and only just before
it's actually needed.  The final patch disables buffer zeroing for
better performance.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=attr-scrub-fixes
