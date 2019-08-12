Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86988A715
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 21:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfHLTbT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 15:31:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfHLTbT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:31:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJE3cR112969
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:31:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vZb4zqms6FE0capmMS/cigwj1dkwiKdtK960f2k93AU=;
 b=i9f4Nl32ZmNwnC+VZ1fBJkzm8v2gNXcKC/8DOEGGHD0zZxsd+P4UkElH3EH/lrb4xOVo
 b8Kg14toyHIolM2g5e+0RCdQkChMAGFhwQai3I2HmXZDFA468la/ZpVbsGXGIMRY3TcP
 6wyZ5ka0dInLWlgwlwsLegoc81CUdhCcFd+SdGCCaV77D4fLnYVoypzPzfH002vgr4iG
 5DDS+jkO+zJCDtj5KhJ95YklesWXPi0cIa2cDCHNIXQM/zXpAAZ16HXzeCBeeXc6kleS
 QWoNfNTnp1zZTFFQBgoX1PDJo9WseQqXvOo5bCUerWJy4B870STIIfjD+avMvgex/89A Og== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=vZb4zqms6FE0capmMS/cigwj1dkwiKdtK960f2k93AU=;
 b=HPdrxh2jLvKk9/CMYgCF1+43S9+zxTLZcbYEzWL8sbGT2mKpX5h/w0QaegRLUPE9cppu
 ekivO+uF+yJrWKXdJBJj8NTsen22jH7W3M0b9rp1flzyadA/2iB1nalc0tRrfz7U/rbK
 I4SNUhOjXBY/AQaEzHpIDuxeN1Pe78PrIXGIHS40NidgHOY3V5j/QoZCZ4+oYVyuhoUB
 Q/SqNvP5DbzNGvvW2aUc82fLbXVMnnLTNL1vjJJO6EjuylXF4Oh2lx/dX6S0f113u7NH
 weRAWhj2WepIX8p1TfCYRGfAH/jRxqyWkItZO0Ro71/45XtyA54OwJESN61NUA2z/l39 mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjq9ndd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:31:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJDHEQ147582
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:31:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u9n9h8bka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:31:17 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CJVGoq031279
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:31:16 GMT
Received: from [192.168.1.9] (/174.18.98.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 12:31:16 -0700
Subject: Re: [PATCH v2 07/18] xfs: Factor up trans handling in
 xfs_attr3_leaf_flipflags
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-8-allison.henderson@oracle.com>
 <20190812160252.GV7138@magnolia> <20190812163007.GC7138@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <f8a89163-f6bc-2cec-c1de-e39554914abe@oracle.com>
Date:   Mon, 12 Aug 2019 12:31:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812163007.GC7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/19 9:30 AM, Darrick J. Wong wrote:
> On Mon, Aug 12, 2019 at 09:02:52AM -0700, Darrick J. Wong wrote:
>> On Fri, Aug 09, 2019 at 02:37:15PM -0700, Allison Collins wrote:
>>> Since delayed operations cannot roll transactions, factor
>>> up the transaction handling into the calling function
>>>
>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>
>> Looks ok,
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> No, not ok!
> 
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c      | 10 ++++++++++
>>>   fs/xfs/libxfs/xfs_attr_leaf.c |  5 -----
>>>   2 files changed, 10 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index 72af8e2..f36c792 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -752,6 +752,11 @@ xfs_attr_leaf_addname(
>>>   		error = xfs_attr3_leaf_flipflags(args);
>>>   		if (error)
>>>   			return error;
>>> +		/*
>>> +		 * Commit the flag value change and start the next trans in
>>> +		 * series.
>>> +		 */
>>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> 
> Lost error value here!
> 
>>>   
>>>   		/*
>>>   		 * Dismantle the "old" attribute/value pair by removing
>>> @@ -1090,6 +1095,11 @@ xfs_attr_node_addname(
>>>   		error = xfs_attr3_leaf_flipflags(args);
>>>   		if (error)
>>>   			goto out;
>>> +		/*
>>> +		 * Commit the flag value change and start the next trans in
>>> +		 * series
>>> +		 */
>>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> 
> And here!
> 
> --D
Sorry about that!  Thanks for the catch!  Will add in the error code 
handlers.

Allison

> 
>>>   
>>>   		/*
>>>   		 * Dismantle the "old" attribute/value pair by removing
>>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>>> index 8d2e11f..8a6f5df 100644
>>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>>> @@ -2891,10 +2891,5 @@ xfs_attr3_leaf_flipflags(
>>>   			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>>>   	}
>>>   
>>> -	/*
>>> -	 * Commit the flag value change and start the next trans in series.
>>> -	 */
>>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>>> -
>>>   	return error;
>>>   }
>>> -- 
>>> 2.7.4
>>>
