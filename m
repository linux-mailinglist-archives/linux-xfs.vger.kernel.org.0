Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82AAA24406
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfETXRy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:17:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETXRx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:17:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNDs4O149704;
        Mon, 20 May 2019 23:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=W2eV/p3+JkXU5iHGKxvMeErqARlJQ7pOSoa1377pOSc=;
 b=nfn+oBmdU0HpT7kxfFPQknoQhACLx7ZU4mc0UYKrV3iMcPrB9RlOUlTmN8o2shetMgnx
 vKkPvcv0GRFn5nCAUadxOhQKN41Yl2seSY7SDBEpMK0oa8hG8UDZZccXkqmCRcaFkJ5i
 jX5mfBn0AltqRObshnpKVvcKMpSLTs52ExsHr7WXEhudzUUIBMKBV06xHnxpyg7rRTcT
 4FAunM51KNpnUCMCMN3Bwa/B6MiF85WhPmRFQjbsy7XbjdMmScNbzptayD6GHQPlEqwD
 KVoyP8b7P7XlIlOU+b9GI+bNcPxgrzjtRyLWaUBzeaJ7aEHjQfU308RwYhBDpjv/rGEW TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sjapq9ucm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:17:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNHpM7153438;
        Mon, 20 May 2019 23:17:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sm046n4aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:17:50 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KNHnbe022361;
        Mon, 20 May 2019 23:17:49 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:17:49 +0000
Subject: [PATCH 10/12] mkfs: allow setting dax flag on root directory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:17:48 -0700
Message-ID: <155839426866.68606.8424427245250373556.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200143
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach mkfs to set the DAX flag on the root directory so that all new
files can be created in dax mode.  This is a complement to removing the
mount option.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   11 +++++++++++
 mkfs/xfs_mkfs.c     |   11 +++++++++++
 2 files changed, 22 insertions(+)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 4b8c78c3..0137f164 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -391,6 +391,17 @@ All inodes created by
 will have this extent size hint applied.
 The value must be provided in units of filesystem blocks.
 Directories will pass on this hint to newly created children.
+.TP
+.BI dax= value
+All inodes created by
+.B mkfs.xfs
+will have the DAX flag set.
+This means that directories will pass the flag on to newly created files
+and files will use the DAX IO paths when possible.
+This value is either 1 to enable the use or 0 to disable.
+By default,
+.B mkfs.xfs
+will not enable DAX mode.
 .RE
 .TP
 .B \-f
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 09106648..5b66074d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -59,6 +59,7 @@ enum {
 	D_PROJINHERIT,
 	D_EXTSZINHERIT,
 	D_COWEXTSIZE,
+	D_DAX,
 	D_MAX_OPTS,
 };
 
@@ -253,6 +254,7 @@ static struct opt_params dopts = {
 		[D_PROJINHERIT] = "projinherit",
 		[D_EXTSZINHERIT] = "extszinherit",
 		[D_COWEXTSIZE] = "cowextsize",
+		[D_DAX] = "dax",
 	},
 	.subopt_params = {
 		{ .index = D_AGCOUNT,
@@ -368,6 +370,12 @@ static struct opt_params dopts = {
 		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = D_DAX,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -1465,6 +1473,9 @@ data_opts_parser(
 		cli->fsx.fsx_cowextsize = getnum(value, opts, subopt);
 		cli->fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
 		break;
+	case D_DAX:
+		cli->fsx.fsx_xflags |= FS_XFLAG_DAX;
+		break;
 	default:
 		return -EINVAL;
 	}

