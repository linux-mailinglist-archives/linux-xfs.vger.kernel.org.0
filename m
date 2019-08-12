Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 032AF8AA96
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 00:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfHLWjO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 18:39:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57190 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHLWjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:39:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMYFhg088096
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RI4aVWS/KvCfJmvSYzx4chnLxCcGoTNLns7Gzw/HjfM=;
 b=JmRpPTHUXAWWgzs7EvofnXdBUdYbuOZyVEZR8kdlOxx55nYAkBeUVTutMfURNmVPSSYh
 R8xWd8DwfKiDLod9CeTPiJgIgkRXcYy5oYPOzbyUWGR29LvpaXHPSFXGRtHUOLnJR6n3
 f2SmZysat5ZxLZbNTQ9FCSGm+r8Uce9hskTeTo2XMz9USQdCWrgQESDEUunMFtGWRRSK
 deXvwV4JHQo4ZzDoNoTXxDn6pjf7cq5ByMqojY6kSWenPKM6u3ODlXosHIzjo2+8SCOW
 TWMxfFqb2NpRzlxjCyndjnzenBbrIx5o640LTKvQ9TERUiXRUeWmzpvKueWHKBxFqHjy Aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=RI4aVWS/KvCfJmvSYzx4chnLxCcGoTNLns7Gzw/HjfM=;
 b=fSsG/ZH/PKae/boNKYUNx2Oralkr4ioBozZhJe2cvsbYURCBNMDxNwbCeM7QgkPLh29b
 fbXPX1HkaIw8Rs4VkfGiRRmNTzHl7PobKoDg9KdjO3iQT575kKnnlLbcQ6ZnXFIQGF/f
 7qfvRFKb5tms/0s2UHO7JIBCRY52nr92xy0zbOu6IAfYMKM71WBCukyhZzXtfRAbKeA+
 VkE6FhiVepnbGyDf3wQGvGcajoWuj+ipSF0Fw9R+cEcroF89d0fjuBzXUuyUzP52tuGH
 /IpuqLOo5Gk4glE39GHeJNRK253VRQ/INZlAu3PqkI+/1q/idJarmpgpj6A34nU2CVyE Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvp2gae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMcuPR038237
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nrebsa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CMdCFe022370
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:12 GMT
Received: from [10.39.210.209] (/10.39.210.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 15:39:12 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 13/18] xfs: Factor up trans roll in
 xfs_attr3_leaf_clearflag
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-14-allison.henderson@oracle.com>
 <20190812162842.GB7138@magnolia>
Message-ID: <722156a2-8e36-30a3-78c3-26f41c81cc82@oracle.com>
Date:   Mon, 12 Aug 2019 15:39:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812162842.GB7138@magnolia>
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

On 8/12/19 9:28 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:21PM -0700, Allison Collins wrote:
>> New delayed allocation routines cannot be handling
>> transactions so factor them up into the calling functions
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 12 ++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
>>   2 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 7648ceb..ca57202 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -823,6 +823,12 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
>>   		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>>   		error = xfs_attr3_leaf_clearflag(args);
>> +
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>   	}
>>   	return error;
>>   }
>> @@ -1180,6 +1186,12 @@ xfs_attr_node_addname(
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   		if (error)
>>   			goto out;
>> +
>> +		 /*
>> +		  * Commit the flag value change and start the next trans in
>> +		  * series.
>> +		  */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>   	}
>>   	retval = error = 0;
> 
> Doesn't this cause us to lose the error code from the roll_inode above?
> 
> --D

Yes, I overlooked weird assignment in this case.  I will add a extra 
handler.  THx!

Allison

> 
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index b2d5f62..e3604b9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2722,10 +2722,7 @@ xfs_attr3_leaf_clearflag(
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
