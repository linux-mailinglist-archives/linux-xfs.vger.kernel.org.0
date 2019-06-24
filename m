Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011D650EF0
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 16:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfFXOqc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 10:46:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60004 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbfFXOqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 10:46:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OEiNNx037450;
        Mon, 24 Jun 2019 14:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=v4W2nhZHv9dhKKE36c5ZwWZ1Cas1mDjimMs+qqhFy0Y=;
 b=bZPUXHfRwnXxPd29Ft1Cqxjueoibiu0U0YBExO3sxbF1jTxWmeDf2jWXn5NFtGkE5jzK
 LqD7HjJA/4A5vfadyCUkqhdOrbY7fvIKhDvDel3Zg+2izdh8MyU44ECeXy+DKUUsm/yu
 hISm/dwrB5NRT8c9NqMv/7boE2npLtmbx4dU7hP1cBvuzEUMJj5ZImKNaDK5pFKpR49c
 A3tqH8/pWzpzvt4X1yExhTqJJ0mekEp8lkv3y4riWPdsZ8dCO/mHuKB5yXCDfbtDZzw0
 rWujFZT1p2NEjCsptJ1aoN6TaLZryqwQDyPI4oF2ScSo5Hopzr7XDfWN08q+pxhcGMyG pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brsxw49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 14:46:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OEjoa6011854;
        Mon, 24 Jun 2019 14:46:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t99f3agun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 14:46:00 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5OEjxFw002609;
        Mon, 24 Jun 2019 14:45:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 07:45:59 -0700
Date:   Mon, 24 Jun 2019 07:45:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_quota: fix built-in help for project setup
Message-ID: <20190624144558.GE5387@magnolia>
References: <8b7e8e8d-0297-caff-568e-c9d1e75eda63@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b7e8e8d-0297-caff-568e-c9d1e75eda63@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 08:55:38AM -0500, Eric Sandeen wrote:
> -s is used to set up a new project, not -c.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/quota/project.c b/quota/project.c
> index 7c22947..03ae10d 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -43,7 +43,7 @@ project_help(void)
>  " and subdirectories below it (i.e. a tree) can be restricted to using a\n"
>  " subset of the available space in the filesystem.\n"
>  "\n"
> -" A managed tree must be setup initially using the -c option with a project.\n"
> +" A managed tree must be setup initially using the -s option with a project.\n"
>  " The specified project name or identifier is matched to one or more trees\n"
>  " defined in /etc/projects, and these trees are then recursively descended\n"
>  " to mark the affected inodes as being part of that tree - which sets inode\n"
> 
