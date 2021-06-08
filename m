Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD7939EBAB
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Jun 2021 03:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFHBwl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 7 Jun 2021 21:52:41 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3461 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFHBwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 21:52:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzY5r668Bz6x6Y;
        Tue,  8 Jun 2021 09:47:44 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 09:50:45 +0800
Received: from [10.67.77.175] (10.67.77.175) by dggpeml500023.china.huawei.com
 (7.185.36.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 8 Jun 2021
 09:50:45 +0800
Subject: Re: [PATCH] xfs: remove redundant initialization of variable error
To:     <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
References: <1622883170-33317-1-git-send-email-zhangshaokun@hisilicon.com>
 <20210607131355.bjdf7lovz5drofrw@omega.lan>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <ef089c4e-0fa3-733f-e8c1-03d3e9e714d9@hisilicon.com>
Date:   Tue, 8 Jun 2021 09:50:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210607131355.bjdf7lovz5drofrw@omega.lan>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.77.175]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Carlos,

On 2021/6/7 21:13, Carlos Maiolino wrote:
> Hi,
> 
> On Sat, Jun 05, 2021 at 04:52:50PM +0800, Shaokun Zhang wrote:
>> 'error' will be initialized, so clean up the redundant initialization.
>>
>> Cc: "Darrick J. Wong" <djwong@kernel.org>
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> 
> 
> This makes no difference in the resulting code.
> Particularly, I'd rather have such variables explicitly initialized. This
> function is small, so it's easy to see its initialization later in the code, but
> still, IMHO, it's way better to see the 'default error values' explicit at the
> beginning of the function. But, it's just my 'visual' preference :)

Thanks your reply, as you also said that it would be assigned later, the
initialization is unnecessary. I'm fine that Darrick will take it or not.

Cheers,
Shaokun

> 
> 
>> ---
>>  fs/xfs/xfs_buf.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index 592800c8852f..59991c8c7127 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -707,7 +707,7 @@ xfs_buf_get_map(
>>  {
>>  	struct xfs_buf		*bp;
>>  	struct xfs_buf		*new_bp;
>> -	int			error = 0;
>> +	int			error;
>>  
>>  	*bpp = NULL;
>>  	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
>> -- 
>> 2.7.4
>>
> 
