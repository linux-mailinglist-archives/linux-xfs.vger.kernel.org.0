Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8A517444A
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Feb 2020 02:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgB2Bsq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Feb 2020 20:48:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37170 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgB2Bsq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 20:48:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1iUJe139166
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ztyW8VcmgISAA8R1plXG+cH4SULKstbokw3HklQqrKA=;
 b=w3jKhyUYOF3cNrr9cYpjEXv4uekDzvhgZWPDkrDOgJLNGoYW5XDSs0V3t5oh9QMw8W0B
 OzZO2yRDEKl6FmDODVZgDkEOcEGU5rV/BVUTLM2wDBrXB7ez5Dp4sTpTUXs7MuY++MPF
 WTG4fWShWHKJ9Y78P4dd2HDZ09KkEcYieLmRH/HS7h4KvOP58Vb/lEsUp9A3pDyNe1ee
 1I3/Y1/W1Q4QTW5BPZAI5s2m9trTk9BS2Q6wR2fEx7mn3YMoM+OERrbqpy9hmI6GAx/z
 uV1gY0pXkkChhz4xVqs6EgJlPIDs1kispHqw+1dkW8mh0JFSIYVG7I7SnrKDTG2ixtfX GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yf0dmcdwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1iwhP191263
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yfd2v5rd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:43 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01T1mhCo020308
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 17:48:43 -0800
Subject: [PATCH 1/4] xfs: fix buffer state when we reject a corrupt dir free
 block
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Feb 2020 17:48:41 -0800
Message-ID: <158294092192.1729975.12710230360219661807.stgit@magnolia>
In-Reply-To: <158294091582.1729975.287494493433729349.stgit@magnolia>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=719 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=3
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=774 adultscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix two problems in the dir3 free block read routine when we want to
reject a corrupt free block.  First, buffers should never have DONE set
at the same time that b_error is EFSCORRUPTED.  Second, don't leak a
pointer back to the caller.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index a0cc5e240306..f622ede7119e 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -227,7 +227,9 @@ __xfs_dir3_free_read(
 	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
 	if (fa) {
 		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
+		(*bpp)->b_flags &= ~XBF_DONE;
 		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
 		return -EFSCORRUPTED;
 	}
 

