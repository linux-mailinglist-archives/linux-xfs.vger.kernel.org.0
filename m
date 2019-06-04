Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B055D351B7
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 23:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFDVQ5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 17:16:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38050 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFDVQ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:16:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54KwQKW035349;
        Tue, 4 Jun 2019 21:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=uScVj9tK3zvBhfr4n+mPGFgt/jRHdA/h7Z0UN804Quk=;
 b=FeBF461l0HRmB9EkjQbHMRrsFfCWBB5Uj00RTY1qgeW9Dz9t4Man8b8rpnNgS+pRxxGm
 aD8J0Abe/CHocP21nSZX3HbhP6s4rVYcPVAhM9qf85A7iilz1+Kpiex98Fi7KiGAinXB
 P2xfWvTtjGiyXwT+CjJ2LPWdMc+D2UIWgOzx4jyu4nbJ39N7NWORrfRH5p0n2C2aV1C0
 6ZStBmALlyPuu1Rz2Wk+eunOYT2nUlCv7fFReV51xm4O94jIygV7h6JMo7uC/gOHcvu/
 UY6MwI4EFyEDzT5fVRu40WVyyWBMFvMWble2tvW5OJvafn2Wcgd8Vlz9tK0AN1cRssDT 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2suevdfsfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:16:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LGU5v147654;
        Tue, 4 Jun 2019 21:16:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2swnh9twft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:16:51 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54LGo2x009120;
        Tue, 4 Jun 2019 21:16:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 14:16:50 -0700
Subject: [PATCH 1/3] check: try to insulate the test framework from oom
 killer
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Jun 2019 14:16:49 -0700
Message-ID: <155968300919.1646947.15217696927864278918.stgit@magnolia>
In-Reply-To: <155968300283.1646947.2586545304045786757.stgit@magnolia>
References: <155968300283.1646947.2586545304045786757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Some of the tests in xfstests (e.g. generic/224 with 512M of memory)
consume a lot of memory, and when this happens the OOM killer will run
around stomping on processes.  Sometimes it kills the ./check process
before it kills the actual test, which means that the test run doesn't
complete.  Therefore, make the ./check process OOM-proof while bumping
up the attractiveness of the test itself, in the hopes that even if the
test OOMs we'll still be able to continue on our way.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)


diff --git a/check b/check
index 8677141b..08419811 100755
--- a/check
+++ b/check
@@ -499,6 +499,17 @@ _expunge_test()
 	return 0
 }
 
+# Make the check script unattractive to the OOM killer...
+OOM_SCORE_ADJ="/proc/self/oom_score_adj"
+test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
+
+# ...and make the tests themselves somewhat more attractive to it, so that if
+# the system runs out of memory it'll be the test that gets killed and not the
+# test framework.
+_run_seq() {
+	bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq"
+}
+
 _detect_kmemleak
 _prepare_test_list
 
@@ -740,11 +751,11 @@ for section in $HOST_OPTIONS_SECTIONS; do
 		fi
 		_try_wipe_scratch_devs > /dev/null 2>&1
 		if [ "$DUMP_OUTPUT" = true ]; then
-			./$seq 2>&1 | tee $tmp.out
+			_run_seq 2>&1 | tee $tmp.out
 			# Because $? would get tee's return code
 			sts=${PIPESTATUS[0]}
 		else
-			./$seq >$tmp.out 2>&1
+			_run_seq >$tmp.out 2>&1
 			sts=$?
 		fi
 

