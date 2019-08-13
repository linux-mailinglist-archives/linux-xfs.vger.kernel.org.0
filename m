Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4DA8BB80
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 16:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbfHMO2h (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Aug 2019 10:28:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbfHMO2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 10:28:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DESUEw079299;
        Tue, 13 Aug 2019 14:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=bob7Vo2WgBoXxO3mOMK3HkjP+hLh76hPTXfSbf266UY=;
 b=q6mZUuIn6H75sAobZoEZSi/lM6SlLvRqmemB3toQVpynPLppzTcUrp5S4QxI0U30rnex
 arExr73HXir9YDDiDfkEW8kb8zaOwGCqCVNu5BFAWMQNFoI7u8RlrNhUXvBX5lcwGEZS
 /J/yc1//FR1T08hpxrkYH82eMxEAUNGbQ5Af8wa9ZjeLJQm6eSTB7OvR24F1nekL14hI
 IeArE9WZ5OhHt2L2hqJL3QXmk9SqkDLYIN+voJ1gMgG/sGT8WHoTCrfI6BAGdznJmGFj
 XIgez0+ac+jsrM5eHKGcbMPD6nhtdQmfweEZuklPyjkN3V7kM5XqxCa9k9Dzyeev6ST5 MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjqekk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 14:28:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DESRj3011038;
        Tue, 13 Aug 2019 14:28:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ubwrg2qcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 14:28:30 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7DES1Ux013786;
        Tue, 13 Aug 2019 14:28:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 07:28:01 -0700
Date:   Tue, 13 Aug 2019 07:28:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfsprogs: Fix --disable-static option build
Message-ID: <20190813142801.GP7138@magnolia>
References: <20190813051421.21137-1-david@fromorbit.com>
 <20190813051421.21137-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813051421.21137-3-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 03:14:20PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Internal xfsprogs libraries are linked statically to binaries as
> they are not shipped libraries. Using --disable-static prevents the
> internal static libraries from being built and this breaks dead code
> elimination and results in linker failures from link dependencies
> introduced by dead code.
> 
> We can't remove the --disable-static option that causes this as it
> is part of the libtool/autoconf generated infrastructure. We can,
> however, reliably detect whether static library building has been
> disabled after the libtool infrastructure has been configured.
> Therefore, add a check to determine the static build status and
> abort the configure script with an error if we have been configured
> not to build static libraries.

Uh... is this missing from the patch?  I don't see anything that aborts
configure.  Though I sense this might be your v2 solution that works
around --disable-static via the ld command line and leaves configure
alone...? :)

--D

> This build command now succeeds:
> 
> $ make realclean; make configure; ./configure --disable-static ; make
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libfrog/Makefile | 2 ++
>  libxcmd/Makefile | 2 ++
>  libxfs/Makefile  | 2 ++
>  libxlog/Makefile | 2 ++
>  4 files changed, 8 insertions(+)
> 
> diff --git a/libfrog/Makefile b/libfrog/Makefile
> index f5a0539b3f03..4d79983eb910 100644
> --- a/libfrog/Makefile
> +++ b/libfrog/Makefile
> @@ -9,6 +9,8 @@ LTLIBRARY = libfrog.la
>  LT_CURRENT = 0
>  LT_REVISION = 0
>  LT_AGE = 0
> +# we need a static build even if --disable-static is specified
> +LTLDFLAGS += -static
>  
>  CFILES = \
>  avl64.c \
> diff --git a/libxcmd/Makefile b/libxcmd/Makefile
> index 914bec024c46..f9bc1c5c483a 100644
> --- a/libxcmd/Makefile
> +++ b/libxcmd/Makefile
> @@ -9,6 +9,8 @@ LTLIBRARY = libxcmd.la
>  LT_CURRENT = 0
>  LT_REVISION = 0
>  LT_AGE = 0
> +# we need a static build even if --disable-static is specified
> +LTLDFLAGS += -static
>  
>  CFILES = command.c input.c help.c quit.c
>  
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 8c681e0b9083..d1688dc3853a 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -9,6 +9,8 @@ LTLIBRARY = libxfs.la
>  LT_CURRENT = 0
>  LT_REVISION = 0
>  LT_AGE = 0
> +# we need a static build even if --disable-static is specified
> +LTLDFLAGS += -static
>  
>  # headers to install in include/xfs
>  PKGHFILES = xfs_fs.h \
> diff --git a/libxlog/Makefile b/libxlog/Makefile
> index bdea6abacea4..b0f5ef154133 100644
> --- a/libxlog/Makefile
> +++ b/libxlog/Makefile
> @@ -9,6 +9,8 @@ LTLIBRARY = libxlog.la
>  LT_CURRENT = 0
>  LT_REVISION = 0
>  LT_AGE = 0
> +# we need a static build even if --disable-static is specified
> +LTLDFLAGS += -static
>  
>  CFILES = xfs_log_recover.c util.c
>  
> -- 
> 2.23.0.rc1
> 
