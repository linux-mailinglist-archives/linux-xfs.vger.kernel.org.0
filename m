Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467CA61357
	for <lists+linux-xfs@lfdr.de>; Sun,  7 Jul 2019 02:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfGGAUJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 6 Jul 2019 20:20:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfGGAUJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jul 2019 20:20:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x670IcQ0104818;
        Sun, 7 Jul 2019 00:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Tvzxczd4IEbttfeFQvBRwSbH/RXkHaLrzkFd68SPf2s=;
 b=Zm3Wk5OUZa9dKam8H2NK6XTQfBM29GfXdeIFKfyxn8Yt9Mw5o6v/LGkKTSW1XC9rTBl7
 mnbo+NhXXDYM4/0Klk/Y63YVBntUqHrTFJzKXeeOaS6rw0S1iKptwawT4W4l6Lt2LzN0
 tLTZrVcmh+maDMcy8Q4UOJLA2wgsrQ08PsTPj8HJmY9AXK+ZBMOZ8my4y5FPmgHYYEaE
 l33q1e5+7CbLDlZVIuCsLAFUCOboCiuukYAHbKMX2+jQZQrJ2st86zi0BvrMBOBVfpFu
 SAZBdWt4zNDfkUtyDX12a3mKXS2AFpeoi4tp8/yukwePMQBT0pjrKnAkqcIcfBDZTGM1 zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tjk2t9sxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 00:19:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x670IT5J181795;
        Sun, 7 Jul 2019 00:19:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tjjyjqwr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 00:19:55 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x670JsNp019584;
        Sun, 7 Jul 2019 00:19:54 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jul 2019 00:19:54 +0000
Subject: Re: [PATCH] xfs: don't update lastino for FSBULKSTAT_SINGLE
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>,
        kernel test robot <rong.a.chen@intel.com>
Cc:     Brian Foster <bfoster@redhat.com>, lkp@01.org
References: <20190706212517.GH1654093@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <bdbee426-9b4e-4179-a207-c84318e5192e@oracle.com>
Date:   Sat, 6 Jul 2019 17:19:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190706212517.GH1654093@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907070003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907070003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/6/19 2:25 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The kernel test robot found a regression of xfs/054 in the conversion of
> bulkstat to use the new iwalk infrastructure -- if a caller set *lastip
> = 128 and invoked FSBULKSTAT_SINGLE, the bstat info would be for inode
> 128, but *lastip would be increased by the kernel to 129.
> 
> FSBULKSTAT_SINGLE never incremented lastip before, so it's incorrect to
> make such an update to the internal lastino value now.
> 

Looks ok to me.  Thanks!
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> Fixes: 2810bd6840e463 ("xfs: convert bulkstat to new iwalk infrastructure")
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_ioctl.c |    1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6bf04e71325b..1876461e5104 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -797,7 +797,6 @@ xfs_ioc_fsbulkstat(
>   		breq.startino = lastino;
>   		breq.icount = 1;
>   		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
> -		lastino = breq.startino;
>   	} else {	/* XFS_IOC_FSBULKSTAT */
>   		breq.startino = lastino ? lastino + 1 : 0;
>   		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
> 
