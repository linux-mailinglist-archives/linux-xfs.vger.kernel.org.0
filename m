Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6109EF25AF
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 04:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfKGDBv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Nov 2019 22:01:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDBu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:01:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72xmxB049799;
        Thu, 7 Nov 2019 03:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=qb+eyMX1LsRpH6FuSg3RlPCukuTmPMjTW/BN0OpYDfI=;
 b=Wu8bMYLWAtiIthCsXrUjIyDNyb2fwVgqpkVihxXGzDm+YWCDapJJ7K3tmvaujeqxt9cH
 756YehWDqAQc6TKG6x/BWJE/5XMGyQbrcFOF2KKWsWQdqLRh2TiLPbNADkbbXl7Y/vZa
 BjINAmJIJImcn4bJkPEGipKA1E1Io0cVxqd5yF3C/RPxSRNi33VUYgGt1lLVrLOUg738
 aeA2uRyN/pNCOiUExLtX7nLeizmJehTi0vtVStrUrDXhzKjKbN4Evxv4iUiGgIo3F4iI
 WOExNjkvEYJetVr+d7pmFO5vbWL1Fj1BFw1mVqMQ13mIw0Td0m5VbA7JSkM0eFyvI6ow Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w1308k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 03:01:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wjho168757;
        Thu, 7 Nov 2019 03:01:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w41wds46u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 03:01:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA731fpc028329;
        Thu, 7 Nov 2019 03:01:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:01:41 -0800
Subject: [PATCH 0/1] xfs: fix scrub timeout warnings
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 06 Nov 2019 19:01:39 -0800
Message-ID: <157309569968.45477.14151251025953231838.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=682
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=765 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series makes scrub more responsive to the user aborting a
scrub by sending SIGTERM; and fixes a problem where the stall timeouts
trigger when the kernel isn't preemptible.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
