Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF6C65924
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jul 2019 16:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfGKOhf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Jul 2019 10:37:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47188 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728466AbfGKOhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jul 2019 10:37:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEXOr8010104;
        Thu, 11 Jul 2019 14:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=JzpjizjnfBLXtiBfnLsY16h+os1ULUfbcIPrT/PnCiQ=;
 b=siq2E4Rj+sLQJziEFbg8cDdHW64Z+rYXfGUbxJi5/lxtSH38Moxpyo4bPClfzDdTQYKC
 LveBkylX3sRx07GwiWUXZpKGp1YS7J5sqL8BxH24FKIx6GdJMQjkNq451y04U/ZoYp7x
 3TW+7bo535ebQMvsJhOoQDK74EoABA3OBEzeklhFdT29Yd87Y8HdFpQBLBp01OxTQdKR
 rSQWDsuk87+71z7WFafG1Oz2JZBbBLqAujRrXRTlWI+qZyfnX/Ab5IFdNX5BUqZb7P47
 YmYxokWU9CPMDdP6b+L2kfiP48KkZ2rMHHWjrAIxlcPww7iuMuOBUnc6k6ypyJghs5Dc +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tjk2u0g60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:37:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEWdSA021620;
        Thu, 11 Jul 2019 14:35:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tmmh46k7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:35:18 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEZHFM013801;
        Thu, 11 Jul 2019 14:35:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jul 2019 07:35:17 -0700
Date:   Thu, 11 Jul 2019 07:35:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: project quota ineritance flag test
Message-ID: <20190711143516.GG5167@magnolia>
References: <20190619101047.3149-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619101047.3149-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907110164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 19, 2019 at 06:10:47PM +0800, Zorro Lang wrote:
> This case is used to cover xfsprogs bug "b136f48b xfs_quota: fix
> false error reporting of project inheritance flag is not set" at
> first. Then test more behavior when project ineritance flag is
> set or removed.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

<skipping to the good part>

> diff --git a/tests/xfs/507.out b/tests/xfs/507.out
> new file mode 100644
> index 00000000..c8c09d3f
> --- /dev/null
> +++ b/tests/xfs/507.out
> @@ -0,0 +1,23 @@
> +QA output created by 507
> +== The parent directory has Project inheritance bit by default ==
> +Checking project test (path [SCR_MNT]/dir)...
> +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> +
> +Write SCRATCH_MNT/dir/foo, expect ENOSPC:
> +pwrite: No space left on device
> +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> +pwrite: No space left on device
> +
> +== After removing parent directory has Project inheritance bit ==
> +Checking project test (path [SCR_MNT]/dir)...
> +[SCR_MNT]/dir - project inheritance flag is not set
> +[SCR_MNT]/dir/foo - project identifier is not set (inode=0, tree=10)
> +[SCR_MNT]/dir/dir_uninherit - project identifier is not set (inode=0, tree=10)
> +[SCR_MNT]/dir/dir_uninherit - project inheritance flag is not set
> +[SCR_MNT]/dir/dir_uninherit/foo - project identifier is not set (inode=0, tree=10)
> +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> +
> +Write SCRATCH_MNT/dir/foo, expect Success:
> +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> +pwrite: No space left on device

I keep seeing this test failure:

--- a/xfs/508.out      2019-06-30 08:32:32.216174715 -0700
+++ b/xfs/508.out.bad    2019-07-11 07:32:30.488000000 -0700
@@ -19,5 +19,5 @@
 
 Write SCRATCH_MNT/dir/foo, expect Success:
 Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
-pwrite: No space left on device
+/opt/dir/dir_inherit/foo: Disk quota exceeded
 Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:

IIRC EDQUOT is the correct error code for running out of /project/
quota (and I tried with a modern V5 fs and a V4 fs too) both with
setting no quota options at all and turning on every quota type
supported by the fs.

Under what circumstances does xfs_io spit out ENOSPC?

--D

> +Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ffe4ae12..46200752 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -504,3 +504,4 @@
>  504 auto quick mkfs label
>  505 auto quick spaceman
>  506 auto quick health
> +507 auto quick quota
> -- 
> 2.17.2
> 
