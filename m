Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9268AA95
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 00:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfHLWjL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 18:39:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57104 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHLWjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:39:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMZ3Ku088571
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=2awbzzzBXu4c2VCkDuW7arjBG+eHM7s6HLU9dQArzXU=;
 b=T88V3bESpzR+QQ1zjjHn7T4Bml37qKS7pEuK+EZmPtNlTUiIVdfik/PJfK4V+Pm5/HDJ
 mpGBT48q9hOlQwnHRmnR6dRnCToj5ceMe47kFNsPy5ETsdlp47LZc/J3ejYKeJc9GgyW
 EKCpGBYohy5gE2RUcqZQoo6QYl3vcoqazg6debQw9j/2aacuYsgXze3MzEmp761tKHkj
 8SliD5zbQU4S/1N718oOn+qdJzMG9nDlA1BEm8tTG9OErz14beyaRi3Kc+Sm5J3dL2pj
 eRo8+KH4oPj+Y7YpUMqGHhL8KQHQbUuRb4/QIoX2pwDffOM05sVLR6fUEoQ3y7CoocEA Fw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=2awbzzzBXu4c2VCkDuW7arjBG+eHM7s6HLU9dQArzXU=;
 b=XuvtXOCmWKpGPtkLTScrIaAmBumbgBe63RNRPXxPGJzO2+DSLVFt54tBtjel+APCnW+G
 NtMpoC7tN++EzN3ebn1d/r9FNlYPn2WDsERb9QZoCQKhYrGk3J2l3pD9dzZ/88VIu4oh
 sTk+HViGVE+jGDr9JPhF/Vz+9uOjxncdVxUhfsRAiBkvPEp3rsVmFmh5/4N7qTDJJSrc
 ugk0WI9Sw4hkH/HqUhKe9/8P5rS5QNVnERM7MBpjPh2KomLDsiwWD6XgCdz7l01KFlBg
 qKCr+MbBPRsrEuloH5m6GneTdrC+r2eBBuxDCdQaRueOMZrM/wv8Rjry2PqUuB1/2frp iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u9nvp2g9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMcdS9062159
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u9k1vrfr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:08 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CMd7mf020989
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:07 GMT
Received: from [10.39.210.209] (/10.39.210.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 15:39:07 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 12/18] xfs: Factor out xfs_attr_rmtval_remove_value
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-13-allison.henderson@oracle.com>
 <20190812162704.GA7138@magnolia>
Message-ID: <65f3ab90-02c6-b290-a9bf-b40e9c05b982@oracle.com>
Date:   Mon, 12 Aug 2019 15:39:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812162704.GA7138@magnolia>
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

On 8/12/19 9:27 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:20PM -0700, Allison Collins wrote:
>> Because new delayed attribute routines cannot roll
>> transactions, we carve off the parts of
>> xfs_attr_rmtval_remove that we can use.  This will help to
>> reduce repetitive code later when we introduce delayed
>> attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>   2 files changed, 20 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index c421412..f030365 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -586,19 +586,14 @@ xfs_attr_rmtval_set_value(
>>   	return 0;
>>   }
>>   
>> -/*
>> - * Remove the value associated with an attribute by deleting the
>> - * out-of-line buffer that it is stored on.
>> - */
>>   int
>> -xfs_attr_rmtval_remove(
>> +xfs_attr_rmtval_remove_value(
> 
> This function invalidates the incore buffers, right?  Since _remove
> below still does the actual bunmapi work to unmap blocks from the attr
> fork?  Would this be better named xfs_attr_rmtval_invalidate()?

Yeah, I struggled with what to call some of these other than "yet one 
more helper function" that doesn't roll or commit something. 
xfs_attr_rmtval_invalidate sounds good, I will add that into v3.

> 
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_mount	*mp = args->dp->i_mount;
>>   	xfs_dablk_t		lblkno;
>>   	int			blkcnt;
>>   	int			error;
>> -	int			done;
>>   
>>   	trace_xfs_attr_rmtval_remove(args);
> 
> Leave this in xfs_attr_rmtval_remove.
> 

Ok, will move.  Thanks!

Allison

> --D
> 
>>   
>> @@ -642,7 +637,25 @@ xfs_attr_rmtval_remove(
>>   		lblkno += map.br_blockcount;
>>   		blkcnt -= map.br_blockcount;
>>   	}
>> +	return 0;
>> +}
>>   
>> +/*
>> + * Remove the value associated with an attribute by deleting the
>> + * out-of-line buffer that it is stored on.
>> + */
>> +int
>> +xfs_attr_rmtval_remove(
>> +	struct xfs_da_args      *args)
>> +{
>> +	xfs_dablk_t		lblkno;
>> +	int			blkcnt;
>> +	int			error = 0;
>> +	int			done = 0;
>> +
>> +	error = xfs_attr_rmtval_remove_value(args);
>> +	if (error)
>> +		return error;
>>   	/*
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 2a73cd9..9a58a23 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -11,6 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>>   int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> +int xfs_attr_rmtval_remove_value(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>>   int xfs_attr_rmt_find_hole(struct xfs_da_args *args, int *blkcnt,
>>   			   xfs_fileoff_t *lfileoff);
>> -- 
>> 2.7.4
>>
