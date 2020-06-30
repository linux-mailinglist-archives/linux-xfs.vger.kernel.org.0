Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC7D20FF52
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jun 2020 23:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgF3VfO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jun 2020 17:35:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58266 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbgF3VfN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 17:35:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ULIDjC122799
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ThrnHnom62ejjX6wVNxwOf/QMpElFMsYCm6EcWPLC1A=;
 b=zXNTDBfNLNA491qcc+H2inRZNcC3UY+eI6o9Oz3UQr+PM6WnxSsH0ggGlNPjB6zR8Jo+
 0+KLZ1gdUldskJN5mITcjZavOVO1Ig91erv0ZJowT/ma1x8ROA9cuoafIkt4jktZEmpC
 ZQzRvsubz1qGx9Rga7oKZVnvEaCNjYlQibNwTLn0IZJZgQa7jpwp46wVyFYD7VNIuHL/
 pFwxRQLDKfkirC7ujS3i+KRIha+o5xKZPcDlM91BD/8FfNgSoHReIvdnAvEUbhSTEfSt
 PcZbS2Auf6Ce1cq/1Sk4nRG4Tk/BE7eIj04HNIXYB4wcWwNo9+mVrJOese7WQl7HJajm 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31ywrbn8gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ULCm3j186800
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg14fgcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:11 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05ULZBsf010702
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:11 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 21:35:11 +0000
Subject: Re: [PATCH 02/18] xfs: fix inode quota reservation checks
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353172261.2864738.3201442261854530990.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a66191f5-8b70-5806-c031-675ffc38b737@oracle.com>
Date:   Tue, 30 Jun 2020 14:35:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353172261.2864738.3201442261854530990.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:42 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_trans_dqresv is the function that we use to make reservations
> against resource quotas.  Each resource contains two counters: the
> q_core counter, which tracks resources allocated on disk; and the dquot
> reservation counter, which tracks how much of that resource has either
> been allocated or reserved by threads that are working on metadata
> updates.
> 
> For disk blocks, we compare the proposed reservation counter against the
> hard and soft limits to decide if we're going to fail the operation.
> However, for inodes we inexplicably compare against the q_core counter,
> not the incore reservation count.
> 
> Since the q_core counter is always lower than the reservation count and
> we unlock the dquot between reservation and transaction commit, this
> means that multiple threads can reserve the last inode count before we
> hit the hard limit, and when they commit, we'll be well over the hard
> limit.
> 
> Fix this by checking against the incore inode reservation counter, since
> we would appear to maintain that correctly (and that's what we report in
> GETQUOTA).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, makes sense
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_trans_dquot.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index c0f73b82c055..ed0ce8b301b4 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -647,7 +647,7 @@ xfs_trans_dqresv(
>   			}
>   		}
>   		if (ninos > 0) {
> -			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
> +			total_count = dqp->q_res_icount + ninos;
>   			timer = be32_to_cpu(dqp->q_core.d_itimer);
>   			warns = be16_to_cpu(dqp->q_core.d_iwarns);
>   			warnlimit = defq->iwarnlimit;
> 
