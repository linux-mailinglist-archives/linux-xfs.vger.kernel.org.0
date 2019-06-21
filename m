Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495724EBC3
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 17:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfFUPS7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 11:18:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFUPS7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 11:18:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LF4Bxj171639;
        Fri, 21 Jun 2019 15:18:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=O/P5LBqVPcSn2E/pw6rB+ZsahJ/qXV1+6G1Frr+8j70=;
 b=aPi6mqlv/Y0BeLk3itaTVCspIJfvo3Y2zROk2RCC5Pds0l1OanAy9qBRLRZAS4TqVOPr
 xeAnx1SuuJkS6izf13u/PmDNkvUBiUWs7HwI23teRmAd5ooR+KA3/CHaaorLmSgQGLUr
 pCy/7vCJ9AagUhzWc2sV0wBBRxmC328lS5U/lJ+6P+RsWYsRAvu+XJBparUX9YoHobSQ
 iNzuINgV1PVmG24yGR5WbjmtI9ugIpv4h1MyV/tg0lKTXRYluZzNjAoKoT47//ZLPOLd
 GKMcBR6zVZnEqO0bUk+arZYxIBvVLu7GpFNVzl0t+8+b1Xc4ABKO3sbTyyGd+DYYMBmk JA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t7809q1m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 15:18:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LFIY3U113159;
        Fri, 21 Jun 2019 15:18:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t77yq0pt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 15:18:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5LFIaMs002039;
        Fri, 21 Jun 2019 15:18:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 08:18:36 -0700
Date:   Fri, 21 Jun 2019 08:18:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190621151835.GX5387@magnolia>
References: <20190522180546.17063-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 02:05:35PM -0400, Brian Foster wrote:
> Hi all,
> 
> This is v2 of the extent allocation rework series. The changes in this
> version are mostly associated with code factoring, based on feedback to
> v1. The small mode helper refactoring has been isolated and pulled to
> the start of the series. The active flag that necessitated the btree
> cursor container structure has been pushed into the xfs_btree_cur
> private area. The resulting high level allocation code in
> xfs_ag_alloc_vextent() has been cleaned up to remove an unnecessary
> level of abstraction. Finally, there are various minor cleanups and
> fixes.

Hmmm.  Just for fun I decided to apply this series to see what would
happen, and on a 1k block filesystem shook out a test failure that seems
like it could be related?

MKFS_OPTIONS='-f -m reflink=1,rmapbt=1 -i sparse=1, -b size=1024, /dev/sdf'
MOUNT_OPTIONS='-o usrquota,grpquota,prjquota /dev/sdf /opt'

--D

--- generic/223.out
+++ generic/223.out.bad
@@ -48,7 +48,7 @@
 === Testing size 1g falloc on 8k stripe ===
 SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 8k stripe ===
-SCRATCH_MNT/file-1073745920-falloc: well-aligned
+SCRATCH_MNT/file-1073745920-falloc: Start block 197673 not multiple of sunit 2
 === mkfs with su 4 blocks x 4 ===
 === Testing size 1*16k on 16k stripe ===
 SCRATCH_MNT/file-1-16384-falloc: well-aligned
@@ -98,7 +98,7 @@
 === Testing size 1g falloc on 16k stripe ===
 SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 16k stripe ===
-SCRATCH_MNT/file-1073745920-falloc: well-aligned
+SCRATCH_MNT/file-1073745920-falloc: Start block 197673 not multiple of sunit 4
 === mkfs with su 8 blocks x 4 ===
 === Testing size 1*32k on 32k stripe ===
 SCRATCH_MNT/file-1-32768-falloc: well-aligned
@@ -148,7 +148,7 @@
 === Testing size 1g falloc on 32k stripe ===
 SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 32k stripe ===
-SCRATCH_MNT/file-1073745920-falloc: well-aligned
+SCRATCH_MNT/file-1073745920-falloc: Start block 197673 not multiple of sunit 8
 === mkfs with su 16 blocks x 4 ===
 === Testing size 1*64k on 64k stripe ===
 SCRATCH_MNT/file-1-65536-falloc: well-aligned
@@ -198,7 +198,7 @@
 === Testing size 1g falloc on 64k stripe ===
 SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 64k stripe ===
-SCRATCH_MNT/file-1073745920-falloc: well-aligned
+SCRATCH_MNT/file-1073745920-falloc: Start block 197665 not multiple of sunit 16
 === mkfs with su 32 blocks x 4 ===
 === Testing size 1*128k on 128k stripe ===
 SCRATCH_MNT/file-1-131072-falloc: well-aligned
