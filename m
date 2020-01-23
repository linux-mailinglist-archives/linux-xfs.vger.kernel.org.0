Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12806146D68
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Jan 2020 16:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgAWPya (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Jan 2020 10:54:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34148 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgAWPy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 10:54:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NFn7GU195019
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 15:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9xZ5nQ6SKoARTa4wmg7gA/k7zbynJeOPFGACIfdqti0=;
 b=ZnyEvygvQA+Vkh2sYGO5ro7rQyX9SvBNIxcHiOmjKcN4bKZ8NI0N3PWBULXjPjk2FLxb
 RPKnEOJIQaI21YBAizENQSRYgwNbnY5Cj3ClkOAqNJmHan2SOcCj/KgI5gdeFUc1fRpf
 SUNlEQ1ujAFNQWGVfsQf6oCav9xOyAd1t4mpkxYrCHSTH3CPoSQGktYGPNGtT+bGGmAw
 VWYT3G1cxUUMYEkPNdzfaxHgWzavywFg8DnBLNtG91b6r4kwrsDL7xTDXEhoRuAwn9Qv
 rkmSTJz62cUN7gsqhqR5RvgV0d8m66e4NtspcTHcCd7O10cpSntjbZqF2Uy9gEnVuVHg Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseuu9mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 15:54:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NFnJag126299
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 15:54:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xppq7hhvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 15:54:27 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00NFsQnP022129
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jan 2020 15:54:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 07:54:25 -0800
Date:   Thu, 23 Jan 2020 07:54:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: streamline xfs_attr3_leaf_inactive
Message-ID: <20200123155426.GT8257@magnolia>
References: <20200123045144.ue4mbfoswd4xj3ua@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123045144.ue4mbfoswd4xj3ua@kili.mountain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 07:51:44AM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> The patch 0bb9d159bd01: "xfs: streamline xfs_attr3_leaf_inactive"
> from Jan 14, 2020, leads to the following static checker warning:
> 
> 	fs/xfs/xfs_attr_inactive.c:122 xfs_attr3_leaf_inactive()
> 	error: uninitialized symbol 'error'.
> 
> fs/xfs/xfs_attr_inactive.c
>     90          struct xfs_attr_leaf_entry      *entry;
>     91          struct xfs_attr_leaf_name_remote *name_rmt;
>     92          int                             error;
>                                                 ^^^^^
> 
>     93          int                             i;
>     94  
>     95          xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
>     96  
>     97          /*
>     98           * Find the remote value extents for this leaf and invalidate their
>     99           * incore buffers.
>    100           */
>    101          entry = xfs_attr3_leaf_entryp(leaf);
>    102          for (i = 0; i < ichdr.count; entry++, i++) {
> 
> Smatch complains that we might not enter this loop or maybe we always
> hit a continue statement.

In theory there should never be an attr leaf block with zero entries,
but let's fix this anyway.  Patch soon; thanks for the bug report. :)

--D

>    103                  int             blkcnt;
>    104  
>    105                  if (!entry->nameidx || (entry->flags & XFS_ATTR_LOCAL))
>    106                          continue;
>    107  
>    108                  name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
>    109                  if (!name_rmt->valueblk)
>    110                          continue;
>    111  
>    112                  blkcnt = xfs_attr3_rmt_blocks(dp->i_mount,
>    113                                  be32_to_cpu(name_rmt->valuelen));
>    114                  error = xfs_attr3_rmt_stale(dp,
>    115                                  be32_to_cpu(name_rmt->valueblk), blkcnt);
>    116                  if (error)
>    117                          goto err;
>    118          }
>    119  
>    120          xfs_trans_brelse(*trans, bp);
>    121  err:
>    122          return error;
> 
> Possibly uninitialized
> 
>    123  }
> 
> regards,
> dan carpenter
