Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C31380FB8
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 02:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfHEAey (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 4 Aug 2019 20:34:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAex (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:34:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750NvHV098415
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dfBMulgGiXetD3+vyjJft3SGyfo4qvKQmEw1t1I9mfU=;
 b=QxdbEgtJ5wzwCoZg6VtnGX3iWml6ajvEeKv+DZjBv+0zBYTZUxYcrYj7Po//fXrJrgtV
 xeqwMU2c6fUE3EhdZ4jds+BtjvrR8YDM28cvaozlWabHkZZvVZjdrUKWVUOX+7MXoUvQ
 F3l5JEq6GqMtzbVPx1zRCPNocron4b8qPMKCTZc/5GRaMcC7oaXn4imasi2qpRnaeG6F
 53QspF+YEjmDGk2vOCRILc0q3ptFi4RVESXfSnhr6HC1a0MDUJeCuq4FjeUkr8KtR7Fv
 H44+cBA9P/mg84gfU+vlbXRgu7frK1UeHsTuaRCrSCKiwg3j+wlOeBKjAqqaNxZ0PaI1 Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u527pc76k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:34:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750N0kG195553
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:34:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u51kkts7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:34:51 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750Yoqu012507
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:34:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Aug 2019 17:34:50 -0700
Subject: [PATCH 01/18] xfs: add a repair revalidation function pointer
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 04 Aug 2019 17:34:49 -0700
Message-ID: <156496528958.804304.6442207831934063382.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Allow repair functions to set a separate function pointer to validate
the metadata that they've rebuilt.  This prevents us from exiting from a
repair function that rebuilds both A and B without checking that both A
and B can pass a scrub test.  We'll need this for the free space and
inode btree repair strategies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/scrub.c |    5 ++++-
 fs/xfs/scrub/scrub.h |    8 ++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 15c8c5f3f688..0f0b64d7164b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -495,7 +495,10 @@ xfs_scrub_metadata(
 		goto out_teardown;
 
 	/* Scrub for errors. */
-	error = sc.ops->scrub(&sc);
+	if ((sc.flags & XREP_ALREADY_FIXED) && sc.ops->repair_eval != NULL)
+		error = sc.ops->repair_eval(&sc);
+	else
+		error = sc.ops->scrub(&sc);
 	if (!(sc.flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
 		/*
 		 * Scrubbers return -EDEADLOCK to mean 'try harder'.
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index ad1ceb44a628..94a30637a127 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -27,6 +27,14 @@ struct xchk_meta_ops {
 	/* Repair or optimize the metadata. */
 	int		(*repair)(struct xfs_scrub *);
 
+	/*
+	 * Re-scrub the metadata we repaired, in case there's extra work that
+	 * we need to do to check our repair work.  If this is NULL, we'll use
+	 * the ->scrub function pointer, assuming that the regular scrub is
+	 * sufficient.
+	 */
+	int		(*repair_eval)(struct xfs_scrub *sc);
+
 	/* Decide if we even have this piece of metadata. */
 	bool		(*has)(struct xfs_sb *);
 

