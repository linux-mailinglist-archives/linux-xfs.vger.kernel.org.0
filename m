Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C191D8CBE
	for <lists+linux-xfs@lfdr.de>; Tue, 19 May 2020 02:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgESA6Z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 May 2020 20:58:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52654 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgESA6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 20:58:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0vMI6011981;
        Tue, 19 May 2020 00:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/D5RNwXf8MykUOm0HzTXNtckKacpFXo5/BSIrZNmvH8=;
 b=tVpzd8CiqyfSdznLD4UF6UkhHXNQwQ+1hooIxru78UthdhPrCfGqhXYk7M1WvoU1bdv2
 JX03aSvRS+jMBL0zIq5kLWCwH37j+wiiJw4GqQZ2U3vtT5tJeNJHihU1dUDmdPBd1TrV
 Sq7qWTdchf0S2YFutvShfSNpcE6Vzv3o9EAXfTtaVt/F5BRND1L4DVj+0L/t2T1f3E6n
 4j2tz/jpq82BCb/LxOu6kzgUuwA8d28q7WtkbO9HuX2siApsGO8SWia94D3LpZ12x+wU
 w0/IknBOJpNQUk54MYJckWb0rSPY1xqJfXt4wxToZI6DWQypo1YLT2eHgviOSlTmepZA zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tna3bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 00:58:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J0wL9N155990;
        Tue, 19 May 2020 00:58:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 312t3ws208-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 00:58:21 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04J0wBMT017819;
        Tue, 19 May 2020 00:58:11 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 17:58:11 -0700
Date:   Mon, 18 May 2020 17:58:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Leonardo Vaz <lvaz@redhat.com>
Subject: Re: [PATCH] xfs_repair: fix progress reporting
Message-ID: <20200519005809.GG17627@magnolia>
References: <c4df68a7-706b-0216-b2a0-a177789f380f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4df68a7-706b-0216-b2a0-a177789f380f@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=1 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 05:35:33PM -0500, Eric Sandeen wrote:
> Long ago, a young developer tried to fix a segfault in xfs_repair where
> a short progress reporting interval could cause a timer to go off and try
> to print a progress mesage before any had been properly set up because
> we were still busy zeroing the log, and a NULL pointer dereference
> ensued.
> 
> That young developer got it wrong, and completely broke progress
> reporting, because the change caused us to exit early from the pthread
> start routine, and not initialize the progress timer at all.
> 
> That developer is now slightly older and wiser, and finally realizes that
> the simple and correct solution here is to initialize the message format
> to the first one in the list, so that we will be ready to go with a
> progress message no matter when the first timer goes off.
> 
> Reported-by: Leonardo Vaz <lvaz@redhat.com>
> Fixes: 7f2d6b811755 ("xfs_repair: avoid segfault if reporting progre...")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> It might be nice to add progress reporting for the log zeroing, but that
> requires renumbering all these macros, and we don't/can't actually get
> any fine-grained progress at all, so probably not worth it.
> 
> diff --git a/repair/progress.c b/repair/progress.c
> index 5ee08229..d7baa606 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -125,7 +125,11 @@ init_progress_rpt (void)
>  	 */
>  
>  	pthread_mutex_init(&global_msgs.mutex, NULL);
> -	global_msgs.format = NULL;
> +	/*
> +	 * Ensure the format string is not NULL in case the first timer
> +	 * goes off before any stage calls set_progress_msg() to set it.
> +	 */
> +	global_msgs.format = &progress_rpt_reports[0];

Hmm so does that mean the first progress report could be for "scanning
freespace"?

Or could you append a new entry to progress_rpt_reports for "getting my
shit together and moving out of my parents basement" and initialize it
to that?

--D

>  	global_msgs.count = glob_agcount;
>  	global_msgs.interval = report_interval;
>  	global_msgs.done   = prog_rpt_done;
> @@ -171,10 +175,6 @@ progress_rpt_thread (void *p)
>  	msg_block_t *msgp = (msg_block_t *)p;
>  	uint64_t percent;
>  
> -	/* It's possible to get here very early w/ no progress msg set */
> -	if (!msgp->format)
> -		return NULL;
> -
>  	if ((msgbuf = (char *)malloc(DURATION_BUF_SIZE)) == NULL)
>  		do_error (_("progress_rpt: cannot malloc progress msg buffer\n"));
>  
> 
