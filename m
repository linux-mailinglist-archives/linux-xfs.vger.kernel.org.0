Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE33939590
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfFGT3C (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:29:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45270 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:29:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JShGD101131;
        Fri, 7 Jun 2019 19:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=a4Ae/ui4mUzj5LTuy5Kzv3nR5vwNUiZsRpdH/6w0om4=;
 b=hDp/qs/T8Z1ZVRoTMxO2U2aTQCD99AEztNVOjgXTC5XLaiqqdYhEelmXfbTlKUsIvV4v
 4hVGVToo4II7LtVM/GS/IXndZWL9i3673bMgMvTGIe6sUUdpQhynscBFTjUKrXHnj08q
 scJ1Pl/BNO+wdR7pnSqpXhkR6wwMZFWNogDb8CFk1xaekIQdoXMGCIk0jSrVOQG6ny6a
 i21jrS3J9eNq4KIa+EX5UpSq4JMdI7uI6tQIq93AKUmwqlTro00fIV+J2R9JbAB1a3Tc
 WYznaviKKIv0WN4WLXysRQlmVSN/q/Vxbi2CQatN4k8EpnbAJs4KUTC5tVL/Lu62aoGu gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sueve0ecq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:29:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSxIS129578;
        Fri, 7 Jun 2019 19:28:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2swnhde792-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:28:59 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x57JSxji030886;
        Fri, 7 Jun 2019 19:28:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 12:28:59 -0700
Subject: [PATCH 6/6] libxfs-diff: try harder to find the kernel equivalent
 libxfs files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 07 Jun 2019 12:28:58 -0700
Message-ID: <155993573805.2343365.14121664229730887571.stgit@magnolia>
In-Reply-To: <155993569512.2343365.15510991248022865602.stgit@magnolia>
References: <155993569512.2343365.15510991248022865602.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we're syncing userspace libxfs/ files with kernel fs/xfs/
files, teach the diff tool to try fs/xfs/xfs_foo.c if
fs/xfs/libxfs/xfs_foo.c doesn't exist.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/libxfs-diff |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tools/libxfs-diff b/tools/libxfs-diff
index fa57c004..c18ad487 100755
--- a/tools/libxfs-diff
+++ b/tools/libxfs-diff
@@ -22,5 +22,6 @@ dir="$(readlink -m "${dir}/..")"
 
 for i in libxfs/xfs*.[ch]; do
 	kfile="${dir}/$i"
+	test -f "${kfile}" || kfile="$(echo "${kfile}" | sed -e 's|libxfs/||g')"
 	diff -Naurpw --label "$i" <(sed -e '/#include/d' "$i") --label "${kfile}" <(sed -e '/#include/d' "${kfile}")
 done

