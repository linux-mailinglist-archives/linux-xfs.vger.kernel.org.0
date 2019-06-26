Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C005730B
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfFZUrO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:47:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42122 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:47:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKic2R126660
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=SJek0K9CMb1VuGRtplOiTBT2V8gj3jlk2YKfjkGwTXE=;
 b=d3LbWrxVK944IbY6n/Lcd0+YKBi93iaoxnS8DyewskINhimgbfqH5/YWUgucql7FtY2F
 D9IfAHlpxsmBbJ8DJwhMfXKsM5IgDqOF4wTgoZWfShctUrKESpDjpPkBCUU6vDO7dzs5
 f8m9FpanEmPOe2hGVip0cWZsbTleBhvoyZpftrPYT6IUU85SdtFZQvgiiV456GWrbdyK
 UR+FND5LNZ4ux4PnSS5gpgaGiSwhDaRdS60/RdMHZP6xgFTrZIesB2ZTFJo7WUUHbcQX
 mquiMalKFjckWV3XsH0ZG16qyCLdmuoC2eNny/vGXFzm0Ud9pdpBTpJ5cx8LPE4pFgYC JA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t9c9pvke4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKjYIg148267
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t9accwexd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKlBh1005358
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:47:11 -0700
Subject: [PATCH 6/6] xfs: online scrub needn't bother zeroing its temporary
 buffer
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 26 Jun 2019 13:47:10 -0700
Message-ID: <156158203074.495944.13142136337107091755.stgit@magnolia>
In-Reply-To: <156158199378.495944.4088787757066517679.stgit@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=920
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=964 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The xattr scrubber functions use the temporary memory buffer either for
storing bitmaps or for testing if attribute value extraction works.  The
bitmap code always zeroes what it needs and the value extraction merely
sets the buffer contents (we never read the contents, we just look for
return codes), so it's not necessary to waste CPU time zeroing on
allocation.

A flame graph analysis showed that we were spending 7% of a xfs_scrub
run (the whole program, not just the attr scrubber itself) allocating
and zeroing 64k segments needlessly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 09081d8ab34b..d3a6f3dacf0d 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -64,7 +64,12 @@ xchk_setup_xattr_buf(
 		sc->buf = NULL;
 	}
 
-	ab = kmem_zalloc_large(sizeof(*ab) + sz, flags);
+	/*
+	 * Allocate the big buffer.  We skip zeroing it because that added 7%
+	 * to the scrub runtime and all the users were careful never to read
+	 * uninitialized contents.
+	 */
+	ab = kmem_alloc_large(sizeof(*ab) + sz, flags);
 	if (!ab)
 		return -ENOMEM;
 

