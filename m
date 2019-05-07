Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9D6156D8
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 02:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfEGALf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 May 2019 20:11:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35958 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEGALe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 20:11:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4708jwH130794
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=m2+ZWJ0vSLKf89ySuUxE2tLLZ6OoVcrgYECVOLFi3ms=;
 b=OzhLFhZExz5BpBCNNeYh26X00tgZAtvsXeEHgAkWJpa3VeihjmesMvUAWr1hJ5MC/+jL
 vU6rlWy+sR9m+slcgUitsM9QYBVinLwtwyioe/yfMRYvpTI4/2Qwq8qWDnRtu5FyMZvL
 PBP3/f4sll3kCNGGTnYFPFq7odOJFcdtihSbKvaQm4PUDUNpzuWppfvBfhpGdFtgYjwU
 UxasAhAy4VAE9Rc9Yi5x48ndxemryb9Q0tJqhdsLMKlcv6IEl+xxEG5muHp15PVtmE3J
 eEtN4eFnb4cdrO7xgk1D7FNJk84uhUmR0rnjKGBNPmau04m2uhJyd1WxRc4HpU44U5Vs 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2s94bfsre8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 00:11:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4709pC2061688
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2sagytmpb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 00:11:32 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x470BVXd028075
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:31 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 May 2019 17:11:31 -0700
Subject: Re: [PATCH 2/4] xfs_restore: check return value
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
 <155085405082.5141.12150949924461780415.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <038696eb-a0ff-ea34-ebfb-4372ca38873c@oracle.com>
Date:   Mon, 6 May 2019 17:11:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <155085405082.5141.12150949924461780415.stgit@magnolia>
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

Looks ok.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

On 2/22/19 9:47 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the return value of the unlink call when creating a new file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   restore/dirattr.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/restore/dirattr.c b/restore/dirattr.c
> index 0fb2877..4257a1b 100644
> --- a/restore/dirattr.c
> +++ b/restore/dirattr.c
> @@ -67,7 +67,9 @@ create_filled_file(
>   	int		fd;
>   	int		ret;
>   
> -	(void)unlink(pathname);
> +	ret = unlink(pathname);
> +	if (ret && errno != ENOENT)
> +		return ret;
>   
>   	fd = open(pathname, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
>   	if (fd < 0)
> 
