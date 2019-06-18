Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D8D4ACE0
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 23:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbfFRVHJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 17:07:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34684 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730696AbfFRVHI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:07:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL49if034582;
        Tue, 18 Jun 2019 21:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=waso03l9uU6C4HuiOIHmdauOiq3KHh071FSLvuZIq4k=;
 b=llDWsRKPWItehRUICrdmeqCXmgbXV+QZVbOvWIxnz6Z/K/n8ggVdaossdSxzNlfvPQ5J
 cGQ9oTf6MH1B7bpD86oh/mPILJMHdfWooPKw/IH9QcbkIKTXKGLtTf/9Z/u7iXktXjQN
 NblOS6GtpaU4g6pp9XKgAiaZq7CCifmhLaxvY5GSJZrDooFd4RXIITZ+aKWHH9uV46yu
 iLAua3ft0eoeils1m4DIWPuFmqYVPotov+6dnholbE1UElvUC8e/+hgoBl0cGAkK0nWR
 pdXOGzugPOhwMtCIyQao8NEIMZ0AuwMigKs3yDxRZ9Nc+bk+skwTnwIxjUdayXpGwBP9 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t4r3tpuuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL5Ckh191627;
        Tue, 18 Jun 2019 21:07:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t5cpe9q14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:04 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IL73Xe000733;
        Tue, 18 Jun 2019 21:07:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 14:07:03 -0700
Subject: [PATCH 0/4] fstests: various fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 18 Jun 2019 14:07:00 -0700
Message-ID: <156089201978.345809.17444450351199726553.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=828
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=891 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix some more problems uncovered by wipefsing the scratch devices between
tests, and fix various problems with last week's xfs min log size calculation.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
