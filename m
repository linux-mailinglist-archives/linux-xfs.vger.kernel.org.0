Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97287100A6
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2019 22:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfD3UPx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Apr 2019 16:15:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51574 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfD3UPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Apr 2019 16:15:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3UK8olV174823;
        Tue, 30 Apr 2019 20:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=y2BukBgwCKOGxJ4TqObPbmsOa5epe+8Dz29Jjw29i+8=;
 b=u1i9qsAhSVkGLRrS7FGCZI6ZEAR4Onl3AEgQ/V3WvbdKu83cnpp1v5x/idZkYoJlhAZy
 7kpaGmmmM+mrfNB0Kx4vidvxeNd6D40cyi2uEtil+3fw+fdQv1rSYzgWPlRFy8oAsGUQ
 nYOWFkXibYYD/8r5pHR6eLmnPMWXrpaeyCK1SA+vWAWtcNjhAagc2P6rHKuu+CnxJZDJ
 pgwk8Sbp/1LsYo+wIBBsqtU4CF3wDs1ghP8OkusLdU09E2gNwJvjZ8zVnd8zQ4YMH5WZ
 k4J8YjRg3wtyrs5/P5ACMz9xBcn0dXc9lfOp88vms9Zg4ScGKU5mEJhhjDlwKhK7WcIe jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2s4fqq6q6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 20:15:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3UKErx2068239;
        Tue, 30 Apr 2019 20:15:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2s4ew1estb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 20:15:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3UKFZCJ016239;
        Tue, 30 Apr 2019 20:15:35 GMT
Received: from localhost (/10.145.178.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Apr 2019 13:15:34 -0700
Date:   Tue, 30 Apr 2019 13:15:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: rework includes for statx structures
Message-ID: <20190430201533.GI5207@magnolia>
References: <cec15436-c098-c59f-2663-a6a189e46a0c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cec15436-c098-c59f-2663-a6a189e46a0c@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9243 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904300120
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9243 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904300120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 30, 2019 at 03:02:56PM -0500, Eric Sandeen wrote:
> Only include the kernel's linux/stat.h headers if we haven't
> already picked up statx bits from glibc, to avoid redefinition.
> 
> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> Tested-by: Bill O'Donnell <billodo@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

We'll never have problems again!! :D

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(I built it on Ubuntu 18.04 LTS if anyone cares)

--D

> ---
> 
> diff --git a/io/stat.c b/io/stat.c
> index 517be66..37c0b2e 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -6,9 +6,6 @@
>   * Portions of statx support written by David Howells (dhowells@redhat.com)
>   */
>  
> -/* Try to pick up statx definitions from the system headers. */
> -#include <linux/stat.h>
> -
>  #include "command.h"
>  #include "input.h"
>  #include "init.h"
> diff --git a/io/statx.h b/io/statx.h
> index 4f40eaa..c6625ac 100644
> --- a/io/statx.h
> +++ b/io/statx.h
> @@ -33,7 +33,14 @@
>  # endif
>  #endif
>  
> +
> +#ifndef STATX_TYPE
> +/* Pick up kernel definitions if glibc didn't already provide them */
> +#include <linux/stat.h>
> +#endif
> +
>  #ifndef STATX_TYPE
> +/* Local definitions if glibc & kernel headers didn't already provide them */
>  
>  /*
>   * Timestamp structure for the timestamps in struct statx.
> 
