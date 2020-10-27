Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB86D29C834
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Oct 2020 20:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502004AbgJ0TDq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Oct 2020 15:03:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56996 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444462AbgJ0TDq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:03:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItNOJ022017;
        Tue, 27 Oct 2020 19:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tCCbh4g/i0lM/N0oF6OVt3huFnrxDODn7jb+17KL0q4=;
 b=wrXV5X2cLmfjouQ1gMXVxwo3cDNBqf7qnePSB5OaheF4b91Cd5vWBAB92wHbaeRvlHC5
 WOPik4e+b1fkHJ8zOLO6XA3c/LHuW5/IZhJKewSVl895rLXte6eVNKYZHuuahR6BKc3V
 X+TxSsYCUBwGlakh1F3FN/2SpsxJtyAUPUWg1T2fwxIJnP30sB04DDHyxx8Lvn0VX5vJ
 AWl13wEAO0KmL2JNqG1A4ISAS7zAgTkUgAljHjir86Bn79zIdxWAl+E8GuO7UpWFPAUR
 a0EM/GA+3cybKj4yY5hRaRHJTrEP902nlGbTJZYrrZKW2C/++y7sQj/YqLjnQcy6LpEV +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sav0c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:03:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIu2bF133033;
        Tue, 27 Oct 2020 19:01:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5xg7kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:01:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ1hE9023031;
        Tue, 27 Oct 2020 19:01:43 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:01:43 -0700
Subject: [PATCH 2/9] xfs/520: disable external devices
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:01:42 -0700
Message-ID: <160382530205.1202316.9303713563959751852.stgit@magnolia>
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This is a regression test for a specific bug that requires a specific
configuration of the data device.  Realtime volumes and external logs
don't affect the efficacy of the test, but the test can fail mkfs if the
realtime device is very large.

Therefore, unset USE_EXTERNAL so that we always run this regression
test, even if the tester enabled realtime.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/520 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/520 b/tests/xfs/520
index 51bc4100..b99b9c6e 100755
--- a/tests/xfs/520
+++ b/tests/xfs/520
@@ -41,6 +41,9 @@ _disable_dmesg_check
 _require_check_dmesg
 _require_scratch_nocheck
 
+# Don't let the rtbitmap fill up the data device and screw up this test
+unset USE_EXTERNAL
+
 force_crafted_metadata() {
 	_scratch_mkfs_xfs -f $fsdsopt "$4" >> $seqres.full 2>&1 || _fail "mkfs failed"
 	_scratch_xfs_set_metadata_field "$1" "$2" "$3" >> $seqres.full 2>&1

