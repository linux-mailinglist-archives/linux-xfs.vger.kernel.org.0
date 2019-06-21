Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7291D4ECCB
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 18:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfFUQGr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 12:06:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57882 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFUQGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 12:06:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LFx40l120527;
        Fri, 21 Jun 2019 16:06:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=uOx+MiilIc8DDBMEN6u1y4P/2GPyPWhucwl/g8yFync=;
 b=Pa2OtgKWrtofF47BYtfYgBHi/bI4UOAFhsKxHOFz+WlhGGz8jYRXqeATzcC1sMHfSigN
 TlKwiLm1bnS0F5EvwZiCtCH9jLGd/kHSICoI6ivFZN9nXMgO2OhV1rq6IL43YwxSpE4F
 KFqPq5b4ufX8uF78bDTiwUSVrFxtvOpAx8aFw9U97LbOxvm1ZMn3JZlW2fBFeO728gEx
 FzrVJwczOF37K+U0hqC27lVRYKrc2NrlTRX2byeL4ZxVvXsaa4LRevjYhrKztfEcOpDn
 1Jb65vNziFGF0MSrtfpiz4pDW3PNAmgG4L4Ha+DzkzeOyxsqFKzZjnjfzfM7qKpIRfPn PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t7809qagf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 16:06:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LG4YXj041026;
        Fri, 21 Jun 2019 16:06:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t77yq1fuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 16:06:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5LG6CRm025346;
        Fri, 21 Jun 2019 16:06:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 09:06:11 -0700
Date:   Fri, 21 Jun 2019 09:06:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: don't search for libxfs.h in system headers
Message-ID: <20190621160610.GY5387@magnolia>
References: <b1265852-70ea-5402-191d-b3843996fc89@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1265852-70ea-5402-191d-b3843996fc89@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 10:28:03AM -0500, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> And now for something completely different: a noncontroversial,
> trivially reviewable #include change!
> 
> (right?)
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 47828a06..019df71c 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -3,7 +3,7 @@
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
>   */
> -#include <libxfs.h>
> +#include "libxfs.h"
>  #include "btree.h"
>  #include "err_protos.h"
>  #include "libxlog.h"
> diff --git a/repair/slab.c b/repair/slab.c
> index ba5c2327..d5947a5a 100644
> --- a/repair/slab.c
> +++ b/repair/slab.c
> @@ -3,7 +3,7 @@
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
>   */
> -#include <libxfs.h>
> +#include "libxfs.h"
>  #include "slab.h"
>  
>  #undef SLAB_DEBUG
> 
