Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F0F8AA97
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 00:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfHLWjR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 18:39:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHLWjR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:39:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMYddw062135
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=eQP4Xm4fCnXi8dDxFx0xHBzEJ9L3HPyYpQ+5ZCvLxf0=;
 b=lMHUeA4S6mxWjSTgGOox6xeLnb0L5n5RFmUgfKrTfUsVoZTkX9+fxmrTOgX/rVXYcTt9
 SHi235btBsW4lCWRKM2FNxJ7SeslIQdmZpmRbjYBocsBX/AjCLHquxSZ6wkMHVUzVG29
 EqZnRgZBx7xL2uBiKvO2Ai0FczQndOvgEAZ36QPnAAec3/lrEQr/ZlDWovsRwz9vb5gz
 LHaxunceKc226BjfEN/eqhVJ1lHeGuEgQ1DPvyNBaS5jpQExIPTSW+e8cciVgvJpPKTt
 ZX0pfZK/ooOSfjPw6B7gOAXC1uhdlbrtyQlJrkp01cG8NFmqlnwyCBFEHbWkjGKGhCnd bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=eQP4Xm4fCnXi8dDxFx0xHBzEJ9L3HPyYpQ+5ZCvLxf0=;
 b=tmXy8EbSZ9Ht9tY16jj3kf9Kq73pQye3x0PTmxNHThDTR90o5B8Jgp5s+2Qe8NSNM3fp
 KCifY40mT/a6DOyWXs68Cb70laGGWwy9bzg2mi/efhSZkTfjTwr5koGvhj2Lpy8HiD6x
 j+YiraF+D1YeylKMMH1oo/lwcylF1J7Yn7q3Ci/iOqa7J7QhSEHG+6pbPKkAGBmznxXC
 xO7W4ASNSKBZepZ7BIr7VK4x9CJCg16agSPqzIBydrbBnDPNH/GhSQ+ndTR5IL1alyZ3
 0w7kHhURYdbcnXHspp/8gztljjeb0D+yTifIhOPK01+jvQkKcaX4Zy7uij5CCNQj3uc2 SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbtagpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMcdiw062288
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u9k1vrfuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:16 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CMdFla007855
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:16 GMT
Received: from [10.39.210.209] (/10.39.210.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 15:39:15 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 17/18] xfs: Enable delayed attributes
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-18-allison.henderson@oracle.com>
 <20190812164238.GD7138@magnolia>
Message-ID: <e6b59ad8-8cd0-5347-cd03-b898552c624d@oracle.com>
Date:   Mon, 12 Aug 2019 15:39:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812164238.GD7138@magnolia>
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

On 8/12/19 9:42 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:25PM -0700, Allison Collins wrote:
>> Finally enable delayed attributes in xfs_attr_set and
>> xfs_attr_remove.  We only do this for v4 and up since we
>> cant add new log entries to old fs versions
> 
> ...you can't add new log item types to *existing* fs versions, which
> includes everything through present-day v5.
> 
> This needs a separate feature bit somewhere to prevent existing xfs
> drivers from crashing and burning on attri/attrd items.  Most of this
> deferred attr code could exist independently from the parent pointer
> feature, so I guess you could be the first person to use one of the log
> incompat feature bits?  That would be one way to get wider testing of
> deferred attrs while we work on parent pointers.

Ok, that sounds good then, I will look into plumbing in a feature bit 
for it.  Thx!

Allison

> 
> --D
> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 26 ++++++++++++++++++++++++--
>>   1 file changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 9931e50..7023734 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -506,6 +506,7 @@ xfs_attr_set(
>>   	int			valuelen)
>>   {
>>   	struct xfs_mount	*mp = dp->i_mount;
>> +	struct xfs_sb		*sbp = &mp->m_sb;
>>   	struct xfs_da_args	args;
>>   	struct xfs_trans_res	tres;
>>   	int			rsvd = (name->type & ATTR_ROOT) != 0;
>> @@ -564,7 +565,20 @@ xfs_attr_set(
>>   		goto out_trans_cancel;
>>   
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>> -	error = xfs_attr_set_args(&args);
>> +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
>> +		error = xfs_attr_set_args(&args);
>> +	else {
>> +		error = xfs_has_attr(&args);
>> +
>> +		if (error == -EEXIST && (name->type & ATTR_CREATE))
>> +			goto out_trans_cancel;
>> +
>> +		if (error == -ENOATTR && (name->type & ATTR_REPLACE))
>> +			goto out_trans_cancel;
>> +
>> +		error = xfs_attr_set_deferred(dp, args.trans, name, value,
>> +					      valuelen);
>> +	}
>>   	if (error)
>>   		goto out_trans_cancel;
>>   	if (!args.trans) {
>> @@ -649,6 +663,7 @@ xfs_attr_remove(
>>   	struct xfs_name		*name)
>>   {
>>   	struct xfs_mount	*mp = dp->i_mount;
>> +	struct xfs_sb		*sbp = &mp->m_sb;
>>   	struct xfs_da_args	args;
>>   	int			error;
>>   
>> @@ -690,7 +705,14 @@ xfs_attr_remove(
>>   	 */
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>>   
>> -	error = xfs_attr_remove_args(&args);
>> +	error = xfs_has_attr(&args);
>> +	if (error == -ENOATTR)
>> +		goto out;
>> +
>> +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
>> +		error = xfs_attr_remove_args(&args);
>> +	else
>> +		error = xfs_attr_remove_deferred(dp, args.trans, name);
>>   	if (error)
>>   		goto out;
>>   
>> -- 
>> 2.7.4
>>
