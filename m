Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411D544F13
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 00:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfFMW2i (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 18:28:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFMW2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 18:28:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5DMO0bS006969;
        Thu, 13 Jun 2019 22:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=KBMAJtO56LXGbzUj63jJ8X0sRjVNMdXmCLcctHu28d0=;
 b=MApCfWb9wSNN6Q3oDHJmdfnjRsaSiPNfcan4bcNF901AUwfd4b9OZeCw1JynjFAbid1f
 qKBZJSTbatx/CaTB5b381M6DmhhfWYKW2zOYM0By2gvM9y+6Cuq74lIGRwUIvCEhU8Iz
 m3yTOx/cLtHq7d4d46qe1OvEQnfv1kYhNRtM2UCBNl5vtq3P/Qsemm0z1m94inI6Hrs3
 1C8UAqKb7hWD1GcgzdSjJ26FK2c5+wWsQGnVndR3f0Eh6nOv1a006ZYi1moo+NhiRaT5
 ppHLsBcA8lImvSrDl7JojAQghC0nqtWcOJ6GqQIBU9rMeKaqcMcQE2prmeeuPqEgXJaj BA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t04eu4d58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 22:28:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5DMRroA101811;
        Thu, 13 Jun 2019 22:28:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t04j0qww3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 22:28:31 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5DMSUVV001335;
        Thu, 13 Jun 2019 22:28:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Jun 2019 15:28:30 -0700
Date:   Thu, 13 Jun 2019 15:28:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Fix typos in xfs-documentation
Message-ID: <20190613222829.GI3773859@magnolia>
References: <20190613210459.52794-1-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613210459.52794-1-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9287 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906130169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9287 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906130169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 11:04:59PM +0200, Andrea Gelmini wrote:
> ---
>  .../filesystem_tunables.asciidoc                   |  6 +++---
>  .../xfs_performance_tuning.asciidoc                |  4 ++--
>  .../extended_attributes.asciidoc                   |  2 +-
>  .../journaling_log.asciidoc                        |  2 +-
>  design/XFS_Filesystem_Structure/magic.asciidoc     |  2 +-
>  .../XFS_Filesystem_Structure/refcountbt.asciidoc   |  2 +-
>  design/xfs-smr-structure.asciidoc                  | 14 +++++++-------
>  7 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc b/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
> index c12981b..c570406 100644
> --- a/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
> +++ b/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc

<snip>

> --- a/design/XFS_Filesystem_Structure/refcountbt.asciidoc
> +++ b/design/XFS_Filesystem_Structure/refcountbt.asciidoc
> @@ -6,7 +6,7 @@ This data structure is under construction!  Details may change.
>  
>  To support the sharing of file data blocks (reflink), each allocation group has
>  its own reference count B+tree, which grows in the allocated space like the
> -inode B+trees.  This data could be gleaned by performing an interval query of
> +inode B+trees.  This data could be cleaned by performing an interval query of

That one actually is correct, but since it's clearly confusing to people
(the primary definitions involve grain and produce) let's change
"gleaned" to "collected".  How does that sound?

The rest looks solid, though.

--D
