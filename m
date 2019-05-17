Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5445C2208F
	for <lists+linux-xfs@lfdr.de>; Sat, 18 May 2019 00:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfEQW5u (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 18:57:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfEQW5u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 18:57:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HMiSSc065548;
        Fri, 17 May 2019 22:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hdi1daI4SbInEMqEJd9dXm6b0RkcM64Xg3eOKXlhf40=;
 b=gmTfXJ+4Ug44BiNGpM2yqgRM8oerDmIR9QbV8hTZ+KWFBej2ZHnJKlSY8xNvxwT4sOau
 XQbH3BTGsZdGVYCl8nT18FgYCWgwh4GQ2iYFVf/9QNrsx078jLUcUNYpdEyUpOhat6/d
 m4xmSZzZpOsX5xW7RIhfxwgyHLPetRrXsbNsRT4SXZZLlMRAjRASEOtNKjrmrs/EZw+Y
 cit31EzpWeG8tVBMj+8wphdo461E5rY5TwZzaK+/oV9uDvoz3uQbeMeufOtz2r32LL7u
 b/CN+bZ5nQf7ZY16b/k7px3uO2bw1dEh8Qel47O8vOEpIrMDIswbhlGclhEXW8eOp4Fl ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sdntucdat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 22:57:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HMvPKO131617;
        Fri, 17 May 2019 22:57:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2sggeuj0mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 22:57:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4HMvaMB021059;
        Fri, 17 May 2019 22:57:36 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 May 2019 15:57:36 -0700
Subject: Re: [PATCH 7/3] libxfs: fix argument to xfs_trans_add_item
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <1bd8bba2-b884-02f6-8e49-eb2374481888@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <e473e37d-433f-9437-2dcd-b7760c70f00c@oracle.com>
Date:   Fri, 17 May 2019 15:57:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1bd8bba2-b884-02f6-8e49-eb2374481888@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905170137
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905170137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/16/19 1:40 PM, Eric Sandeen wrote:
> The hack of casting an inode_log_item or buf_log_item to a
> xfs_log_item_t is pretty gross; yes it's the first member in the
> structure, but yuk.  Pass in the correct structure member.
> 
> This was fixed in the kernel with commit e98c414f9
> ("xfs: simplify log item descriptor tracking")
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libxfs/trans.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index f78222fd..6ef4841f 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -346,7 +346,7 @@ xfs_trans_ijoin(
>   	ASSERT(iip->ili_lock_flags == 0);
>   	iip->ili_lock_flags = lock_flags;
>   
> -	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
> +	xfs_trans_add_item(tp, &iip->ili_item);
>   }
>   
>   void
> @@ -570,7 +570,7 @@ _xfs_trans_bjoin(
>   	 * Attach the item to the transaction so we can find it in
>   	 * xfs_trans_get_buf() and friends.
>   	 */
> -	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
> +	xfs_trans_add_item(tp, &bip->bli_item);
>   	bp->b_transp = tp;
>   
>   }
> 
