Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3513B4ED26
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 18:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfFUQ2u (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 12:28:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfFUQ2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 12:28:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LGJQDc038674;
        Fri, 21 Jun 2019 16:28:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=DRFHsWvxPCQ8WdLP+ERMFoTr5f5IuWm+42i1av5TMbs=;
 b=2tCBlJt6zaV24727PYMPcSZwEDVqV2NPmg8H0srCpjU3tfMRd3X3U9b7CKmLZfMWuWFf
 HNaY8glXtjsehX9AxZGhMbEGc5X9D/caxguUTgaeP93AdUuD7SPnrVSzIVLgo1DOA8ej
 jICwGmLSuR5llan4JU8JpPCH887Zfa1jlu0uLyLMrVTJT5pRorcOcBQ6/A0/aSvydwma
 YXGfJ3UmVEzPdqKVWBhs4TzSfGlZZiUpNO9zeNMdLO0QElL3CUExdeL0EYw82yt/r37s
 NP48tbDHd0XkzLuvSxSNjqtV2utGW0cTOoCoTICm5dMzCeTd1OeBKmJvXr6VmO+82Pah 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t7809qcv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 16:28:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LGRHYL170385;
        Fri, 21 Jun 2019 16:28:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t77yp9t35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 16:28:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LGSk6G011836;
        Fri, 21 Jun 2019 16:28:46 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 09:28:46 -0700
Subject: Re: [PATCH 4/4] xfs/119: fix MKFS_OPTIONS exporting
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089204777.345809.18314859473454869520.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <f39344a5-c0ee-f660-ac9d-c431ce3c4b0f@oracle.com>
Date:   Fri, 21 Jun 2019 09:28:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <156089204777.345809.18314859473454869520.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/18/19 2:07 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This test originally exported its own MKFS_OPTIONS to force the tested
> filesystem config to the mkfs defaults + test-specific log size options.
> This overrides whatever the test runner might have set in MKFS_OPTIONS.
> 
> In commit 2fd273886b525 ("xfs: refactor minimum log size formatting
> code") we fail to export our test-specific MKFS_OPTIONS before
> calculating the minimum log size, which leads to the wrong min log size
> being calculated once we fixed the helper to be smarter about mkfs options.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   tests/xfs/119 |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/119 b/tests/xfs/119
> index 8825a5c3..f245a0a6 100755
> --- a/tests/xfs/119
> +++ b/tests/xfs/119
> @@ -38,7 +38,8 @@ _require_scratch
>   # this may hang
>   sync
>   
> -logblks=$(_scratch_find_xfs_min_logblocks -l version=2,su=64k)
> +export MKFS_OPTIONS="-l version=2,su=64k"
> +logblks=$(_scratch_find_xfs_min_logblocks)
>   export MKFS_OPTIONS="-l version=2,size=${logblks}b,su=64k"
>   export MOUNT_OPTIONS="-o logbsize=64k"
>   _scratch_mkfs_xfs >/dev/null
> 
