Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04854156D9
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 02:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfEGALr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 May 2019 20:11:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36148 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEGALr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 20:11:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4709Mg2131220
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=RpZ1J5MDa/JodzmBMm0hscXWMrLAcOidONnTb7mOihw=;
 b=R25vIBgvZnPhd0sc1I0TCemCCloa0i34L67UQEu5Z3JNAesRa5/SPJ/eE0xVOP0i22CE
 omO+uc2w1ngt+JmsLebQdcXUOIB3DwDyocPBXV+sLViU8tB8QD6ZOuCtEsi/3luMTtrS
 O7MQjvp99pWvHEPC2u1Ts7xqBylQtdCHPhB3RBX5DjUfLLOHO0sRBHLrYO3QVqJ0FHvZ
 bJlpd0Y32oRHuBN+9bP6Fa0KHfbK+O5eES0B3H1NUH0Frcf+XYitWvwY3SYxgMU8b5mJ
 4c3lOw+OSqILOtUMDde9wqSuzfB1vAo68ZJbYLlW4tTV3sapwRziyXPSc78PIcdSBbRt 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2s94bfsreh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 00:11:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x470BG6l030665
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2s94af61ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 00:11:45 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x470BiHD003598
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:44 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 May 2019 17:11:44 -0700
Subject: Re: [PATCH 3/4] xfs_restore: fix unsupported ioctl detection
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
 <155085405698.5141.702624754882653044.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <22064519-5134-91e3-d5c7-701ded9d69de@oracle.com>
Date:   Mon, 6 May 2019 17:11:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <155085405698.5141.702624754882653044.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905070000
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905070000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

On 2/22/19 9:47 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Linux ioctls can return ENOTTY or EOPNOTSUPP, so filter both of them
> when logging reservation failure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   restore/dirattr.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/restore/dirattr.c b/restore/dirattr.c
> index 4257a1b..3fa8fb6 100644
> --- a/restore/dirattr.c
> +++ b/restore/dirattr.c
> @@ -76,7 +76,7 @@ create_filled_file(
>   		return fd;
>   
>   	ret = ioctl(fd, XFS_IOC_RESVSP64, &fl);
> -	if (ret && errno != ENOTTY)
> +	if (ret && (errno != EOPNOTSUPP && errno != ENOTTY))
>   		mlog(MLOG_VERBOSE | MLOG_NOTE,
>   _("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
>   				size, pathname, "XFS_IOC_RESVSP64",
> 
