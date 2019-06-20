Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B114D430
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfFTQup (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:50:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43534 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:50:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnGaO069756;
        Thu, 20 Jun 2019 16:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=a4Ae/ui4mUzj5LTuy5Kzv3nR5vwNUiZsRpdH/6w0om4=;
 b=23OoqtocLo6iPLE9ZChONQFnaZdhFUVhdvPRUqrOIc+GJENj0gaA1C51uklu+1fnkukO
 nbqKgfxAu0FWn4ZL+VZJrdZUk/928vq4qG6w5dStDo4OSXJ5TgXpo8LRH4a5DxYNJjpw
 TL0kGPtc/MugxsYwnIz7TUiJCy61s0oCatbnpF49g+dNwJiiSjoWdhR5IxyKNfwrT1sV
 88NhLGo6tRNeGG8Uk7ODlIPfj6VAfRpngFVfGpLMGuaSsYFKZw/9IaejNcf50n9S0N2O
 WG50elZ0SxITGi920EiWuP5bJ3caOC56IITL/Ar/s0uMv5P5nO7G57YXaR/GlZSRGNXx XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t7809j9qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGne1I057760;
        Thu, 20 Jun 2019 16:50:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t77ynqpjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:42 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KGofOd020156;
        Thu, 20 Jun 2019 16:50:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:50:41 -0700
Subject: [PATCH 11/12] libxfs-diff: try harder to find the kernel equivalent
 libxfs files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:50:40 -0700
Message-ID: <156104944022.1172531.15814499652713220817.stgit@magnolia>
In-Reply-To: <156104936953.1172531.2121427277342917243.stgit@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200122
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

