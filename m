Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F70220C5
	for <lists+linux-xfs@lfdr.de>; Sat, 18 May 2019 01:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfEQXmK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 19:42:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35104 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfEQXmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 19:42:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HNdes9115965;
        Fri, 17 May 2019 23:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=awcHDe9uhpr+N7FY4iSQY9MMUARLeNkoheOvw+Lqgfg=;
 b=itpn8hYAe5YAU8PP3exKNOTn9EBUlKuMJ7XsXRg/ijJXnaPtqB6kS5wXz0D8HBH2RCKT
 HIPBOlF5Iv3I6W0VHVZj2WrK7EjmPNgLdteAmcyqF3vPCqhfZ6gwiaf8uNv05JD4RUwI
 hPfUbw3ON+eFqjtUuFWdraZ84C1DHwtf10o+yk5V2wJ/3p0One3e0W7cQ2zQIUrKKPRc
 DFHJbi70cmHsYasmtliTUaUANswXjxqB8hxFubT1Vrvev6i4BDlSQTempzG5H6UA5p5+
 0Fg5yWa+3lEEzEmzTmjEZWsYMycNI2gUIB0KuGsd89oH6a61mMHpoP06+30+38Cqctw1 oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2sdq1r4dvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 23:42:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HNeJKW150774;
        Fri, 17 May 2019 23:42:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2sgkx4y33w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 23:42:02 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4HNg1br008722;
        Fri, 17 May 2019 23:42:01 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 May 2019 16:42:00 -0700
Subject: Re: [PATCH 5/3] libxfs: rename bli_format to avoid confusion with
 bli_formats
To:     Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <d8f37464-9d76-2b09-f458-e236ef9afd95@redhat.com>
 <aa0a48c4-2f75-7f83-eeda-f55855994bd5@oracle.com>
 <1717fd26-ba67-e5c0-c906-0b84c1970250@sandeen.net>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <cb536d8f-16d1-e456-9566-19894fb12158@oracle.com>
Date:   Fri, 17 May 2019 16:41:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1717fd26-ba67-e5c0-c906-0b84c1970250@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905170142
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905170142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/17/19 4:01 PM, Eric Sandeen wrote:
> On 5/17/19 5:29 PM, Allison Collins wrote:
>> On 5/16/19 1:39 PM, Eric Sandeen wrote:
>>> Rename the bli_format structure to __bli_format to avoid
>>> accidently confusing them with the bli_formats pointer.
>>>
>>> (nb: userspace currently has no bli_formats pointer)
>>>
>>> Source kernel commit: b94381737e9c4d014a4003e8ece9ba88670a2dd4
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>    include/xfs_trans.h | 2 +-
>>>    libxfs/logitem.c    | 6 +++---
>>>    libxfs/trans.c      | 4 ++--
>>>    3 files changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
>>> index 953da5d1..fe03ba64 100644
>>> --- a/include/xfs_trans.h
>>> +++ b/include/xfs_trans.h
>>> @@ -39,7 +39,7 @@ typedef struct xfs_buf_log_item {
>>>        struct xfs_buf        *bli_buf;    /* real buffer pointer */
>>>        unsigned int        bli_flags;    /* misc flags */
>>>        unsigned int        bli_recur;    /* recursion count */
>>> -    xfs_buf_log_format_t    bli_format;    /* in-log header */
>>> +    xfs_buf_log_format_t    __bli_format;    /* in-log header */
>>>    } xfs_buf_log_item_t;
>>>      #define XFS_BLI_DIRTY            (1<<0)
>>> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
>>> index 4da9bc1b..e862ab4f 100644
>>> --- a/libxfs/logitem.c
>>> +++ b/libxfs/logitem.c
>>> @@ -107,9 +107,9 @@ xfs_buf_item_init(
>>>        bip->bli_item.li_mountp = mp;
>>>        INIT_LIST_HEAD(&bip->bli_item.li_trans);
>>>        bip->bli_buf = bp;
>>> -    bip->bli_format.blf_type = XFS_LI_BUF;
>>> -    bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
>>> -    bip->bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
>>> +    bip->__bli_format.blf_type = XFS_LI_BUF;
>>> +    bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
>>> +    bip->__bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
>>>        bp->b_log_item = bip;
>>
>> I had a look around this area of code, and I see where the bli_format is getting referenced, but I don't see a bli_formats.  So I feel like I'm missing the motivation for the change.  Did I miss the bli_formats somewhere?  Thanks!
> 
> see above :)
> 
>> (nb: userspace currently has no bli_formats pointer)
> 
> (I guess copying the kernel commit log added confusion even w/ the note)
> 
> -Eric

Oh I see.  No I think it's ok, I overlooked it.  You can add my review  :-)

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> 
