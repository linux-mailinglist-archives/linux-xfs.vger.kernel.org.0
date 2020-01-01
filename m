Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED3F12DC95
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jan 2020 02:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgAABDu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Dec 2019 20:03:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgAABDu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:03:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00110COc104675
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=S+1y0wZyhcqGA8K9SnmMFn+FgtLRhpcUGckt3wmvZWQ=;
 b=dAreNG0okiOUkb9eQOMy3FYhQFqU/ccWqoIGP8xebjHWaUYgBSs27kk22mUszkf5Szwu
 pKDBkP24Qa9DxlN+61QyVkFLax0gtTiN1ph+4LoIrHZ8v6Wog7f61Ejj9y9jEZFWPa6W
 RQzM10kV2JVFEeFqoYBdBna8UjabWWkV17RNGjeB8wQUE4G89C+1iGTzIYGzVx2tnRKS
 MlGd6Zyh7DqetYAVMdhBQHqly2w/ZiCKooI7407C/LH1lRAROIXiVlGSI7g9I2EwyUx3
 jWEVIdLHDUj0UU1YGsGuKUnq8YYBU2NMwWuwgNC6x1+vXLc3JOwDpwWBsCOOCmWRN4oc ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk288-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wh8j172258
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrfv42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:48 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00113luD025113
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:47 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:03:47 -0800
Subject: [PATCH v22 0/6] xfs: online repair of inode data
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:03:45 -0800
Message-ID: <157784062523.1358958.17318700801044648140.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

For the third part of the twenty-second revision of the online repair
patchset, we implement repair of extended attribute data.

Patch 1 implements a new data structure for storing arbitrary key/value
pairs, which we're going to need to reconstruct extended attribute
forks.

Patches 2-4 clean up the block unmapping code so that we will be able
to perform a mass reset of an inode's fork.  This is a key component for
salvaging extended attributes, freeing all the attr fork blocks, and
reconstructing the extended attribute data.

Patch 5 implements extended attribute salvage operations.  There is no
redundant or secondary xattr metadata, so the best we can do is trawl
through the attr leaves looking for intact entities.

Patch 6 augments scrub to rebuild extended attributes when any of the
attr blocks are fragmented.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inode-data

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inode-data
