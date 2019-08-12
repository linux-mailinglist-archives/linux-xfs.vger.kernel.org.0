Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD568AA93
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 00:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfHLWjF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 18:39:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48520 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHLWjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:39:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMYFBp062058
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Yoa1tUJwA7w3iTUukUuMiUuXjYRuSrSWX8IR26sxwpQ=;
 b=LpbkssLjoUDxJk8hzgTUxKyuTX5ACaBB7VkLPXFmNhwCVB2b3n4FcNg6lNmuJZP7+PhT
 MRvXvkny79Al5BYw0rX+YoQiKAvo2i9EgQhVIUCtblhxcXV7RN9AQf9u4+lvwTeiTVBG
 Djknw8a5ANJb+uCySYg3k1roLUNkZs0K5BPuydGGPZPWSFSxkvYftIv0/EshyyrECbL9
 zLl2OzCp3CG0mjh/hXZnuGY3xSEC9Lymen7XVWWuyV7utpIpl7hl4f7v1w3ygUzROpjO
 yBB9kF53BPB8uGFhkZ2+k2yzhAmeuWQFQAO7XzULF1sXKwqcmN7ZfF6mpekUolblEto9 DA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Yoa1tUJwA7w3iTUukUuMiUuXjYRuSrSWX8IR26sxwpQ=;
 b=46gEMaRAFjR03RzDYcYamRU0xtZ+hLQs8kR7fcXjiGe85QTv1zx8ZGJ+V28cjnPJF/WT
 7E2wVEwNTqPbJeo+CAm7hEIIDB5WnteyuOKJ2VaQ+b6a4pFHiKJvau+SHzZsSvqlCs0L
 rXto4GpP9POa6JjHGgcQT53J4fdt1AZFRjEBTyXNlqrmyFhPROME+7M9iJnZwFk8I5PP
 cCDGknpq+syDs+wk+vzO4KiigXO/yEly4qr0Xo4eDk7eC5V8O1SSSVrfUXZR7SqIGz23
 KWHV97VslnrYC5pNVe4Hb4ZmX9p4wd/mkrQUnsyht103ZGMxHvw1JV+eBN7ZDeSUByzv jQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbtagn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMd3pn070618
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u9n9hdq8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:02 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CMcrWw021948
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:38:53 GMT
Received: from [10.39.210.209] (/10.39.210.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 15:38:53 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 10/18] xfs: Factor up trans roll from
 xfs_attr3_leaf_setflag
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-11-allison.henderson@oracle.com>
 <20190812161452.GY7138@magnolia>
Message-ID: <2d8baf51-f4ba-e5a7-46bf-bb7350bbc0d2@oracle.com>
Date:   Mon, 12 Aug 2019 15:38:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812161452.GY7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120220
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120220
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/19 9:14 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:18PM -0700, Allison Collins wrote:
>> New delayed allocation routines cannot be handling
>> transactions so factor them up into the calling functions
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Great!  Thanks!
Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 5 +++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 5 +----
>>   2 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 6bd87e6..7648ceb 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1239,6 +1239,11 @@ xfs_attr_node_removename(
>>   		error = xfs_attr3_leaf_setflag(args);
>>   		if (error)
>>   			goto out;
>> +
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (error)
>> +			goto out;
>> +
>>   		error = xfs_attr_rmtval_remove(args);
>>   		if (error)
>>   			goto out;
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 8a6f5df..4a22ced 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2773,10 +2773,7 @@ xfs_attr3_leaf_setflag(
>>   			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>>   	}
>>   
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	return xfs_trans_roll_inode(&args->trans, args->dp);
>> +	return error;
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
