Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35882C492A
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Nov 2020 21:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgKYUi1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Nov 2020 15:38:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43156 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgKYUi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 15:38:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKOdL3035945;
        Wed, 25 Nov 2020 20:38:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WmerEUUk95AtJMnNOXCmuz8wO7Svydw4JGkxc1qW8To=;
 b=nJIYTmPShtBZ46oLiXDadP8OzT8z9UOfnL0d/WFaA33Og7elb1nUVNTDSbj3HO0cZL/4
 sm1tfFf2OqYWxVoN3Xd4C+8WN1/8NJ6IVsV7oLY8wofAgeIYKrQ/F+Vkp6MIPMXbvpO/
 bOCGxk7g4mYqSHTyS5dvr4byI5Kl1ssRlNpb2whir7EaANb7WwDC8FNvcLsBnLfMaB0K
 NNwtyG+2U1zJ/Nsmu4QEBakfdAzVTYzEao/4uOvZBWYLI0qFhcH9khbs0x5xtc2MK0ET
 DdqWNf4AO8Ll300mSi73cPSXFGePp/+4vvwvcBVqNcKsxBjeSuEvvql05MxNrCLnAdme qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 351kwhkbev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 25 Nov 2020 20:38:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKQ4iG066302;
        Wed, 25 Nov 2020 20:38:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 351n2jdypd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 20:38:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0APKcL3n015643;
        Wed, 25 Nov 2020 20:38:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Nov 2020 12:38:21 -0800
Subject: [PATCH 4/5] debian: fix version in changelog
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Nov 2020 12:38:20 -0800
Message-ID: <160633670037.634603.12898768383906866110.stgit@magnolia>
In-Reply-To: <160633667604.634603.7657982642827987317.stgit@magnolia>
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We're still at 5.10-rc0, at least according to the tags.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/changelog |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debian/changelog b/debian/changelog
index c41e3913efa4..ba6861985365 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,4 +1,4 @@
-xfsprogs (5.10.0-1) unstable; urgency=low
+xfsprogs (5.10.0-rc0-1) unstable; urgency=low
 
   * New upstream prerelease
 

