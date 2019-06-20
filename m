Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531484D236
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 17:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfFTPck (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 11:32:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38116 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfFTPck (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 11:32:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KFUnEG108080
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 15:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=+merp7L/P/Dqew4klUXDgr0ttfCO4QCREcyPFDHveaM=;
 b=23iSBhEgQy8jHkvOMPQMzmpV//6UL4vGQV168etH3VCvpsSrRw98HAYiD4URLn51Z1yV
 tJ/jvYhuVy9FfMt1euiBhA3+3UtJzHnb320kxzN4caFyoEi44mEZMg9XIgDItFSBD2Nc
 fM9AkLcIvx/Uw++ypNAMpOmFIAMlsDj9OyUvEoRGLo2JembEgZ/9nYnFB4NQA5Jm+w8B
 2bQzr7BtHUtGA7qCV6WcH7K1u9G1cndxzeFFkpcD+fPjtajfjbXTncQUNJJMCV3LHgLc
 OevjwBguPBxIJeczrtfLO3R4pr+tE+pCG9ZYlIFxOJd0N9RlNFA52aHsz6RtOzLQVV3R lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t7809htmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 15:32:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KFWWa1044065
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 15:32:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t77ypefup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 15:32:38 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KFWaJQ015015
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 15:32:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 08:32:36 -0700
Date:   Thu, 20 Jun 2019 08:32:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfsprogs: Fix uninitialized cfg->lsunit
Message-ID: <20190620153234.GV5387@magnolia>
References: <20190619182857.9959-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619182857.9959-1-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 19, 2019 at 11:28:57AM -0700, Allison Collins wrote:
> While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
> left uninitialized when it should not.  This is because calc_stripe_factors
> in some cases needs cfg->loginternal to be set first.  This is done in
> validate_logdev. So move calc_stripe_factors below validate_logdev while
> parsing configs.

<grumble> The cfg in main() is not (in a manner easily detectable by
toolz) uninitialized, it's zero-initialized by default and we haven't
set cfg->loginternal correctly yet...

...what we really need here is enum { FALSE, TRUE, FILENOTFOUND } to
detect that we're using incorrect garbage data. :P

(Really, someone should take a closer look at whether or not there are
other places where we do things like this...)

Anyway, this does solve a problem, so

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ddb25ec..f4a5e4b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3995,7 +3995,6 @@ main(
>  	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
>  
>  	validate_rtextsize(&cfg, &cli, &ft);
> -	calc_stripe_factors(&cfg, &cli, &ft);
>  
>  	/*
>  	 * Open and validate the device configurations
> @@ -4005,6 +4004,7 @@ main(
>  	validate_datadev(&cfg, &cli);
>  	validate_logdev(&cfg, &cli, &logfile);
>  	validate_rtdev(&cfg, &cli, &rtfile);
> +	calc_stripe_factors(&cfg, &cli, &ft);
>  
>  	/*
>  	 * At this point when know exactly what size all the devices are,
> -- 
> 2.7.4
> 
