Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0AAA12578A
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2019 00:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfLRXNg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Dec 2019 18:13:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52828 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRXNf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 18:13:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9r1b089535;
        Wed, 18 Dec 2019 23:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=haRZ12s454KvaqXDKorZmlZQJwbHEsvFeqrFmxzr/9c=;
 b=fhvgt3A8id6uTwbGRGQeqM0HeA41wEaneYnAhO771QlGiMRjUmm1nlZv7d8axQo0Ra08
 2x4Q/25DJo8/y+vYfW1AdTm8Os7jTLan0nrzHER8EOS+k/SIvMyj5nFXTWUb59rHS1dQ
 pMvY0audZbj8IFv8DWCRTYTgm3skGI/v9FLMwTzFEiyAlVhfTFklCl6lJqKfAl9rVnsq
 FQjbwZwyhwa4XFO8D8f5CiNi+4cfej3sf2FLcW5A9jo0W20dh/UWb3NTcfOpmvXdzSdl
 06TlmdBfSMj8gNeoC+nPb9NEDKD7Zfza3mDPZ7R1vdCsJvJa9bgbWJdset3of3suwjsw lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wvrcrghrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:13:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBINB0Oo116741;
        Wed, 18 Dec 2019 23:13:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wyk3bxn9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:13:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBINCLHJ023452;
        Wed, 18 Dec 2019 23:12:21 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 15:12:21 -0800
Date:   Wed, 18 Dec 2019 15:12:20 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove shadow variable in xfs_btree_lshift
Message-ID: <20191218231220.GM7489@magnolia>
References: <f0d8bd58-a46b-bf06-5439-696a2f152344@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0d8bd58-a46b-bf06-5439-696a2f152344@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 04:24:48PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Sparse warns about a shadow variable in this function after the
> Fixed: commit added another int i; with larger scope.  It's safe
> to remove the one with the smaller scope to fix this shadow,
> although the shadow itself is harmless.
> 
> Fixes: 2c813ad66a72 ("xfs: support btrees with overlapping intervals for keys")

Eesh that was a long time ago.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index e2cc98931552..b22c7e928eb1 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2389,8 +2389,6 @@ xfs_btree_lshift(
>  	XFS_BTREE_STATS_ADD(cur, moves, rrecs - 1);
>  	if (level > 0) {
>  		/* It's a nonleaf. operate on keys and ptrs */
> -		int			i;		/* loop index */
> -
>  		for (i = 0; i < rrecs; i++) {
>  			error = xfs_btree_debug_check_ptr(cur, rpp, i + 1, level);
>  			if (error)
> 
