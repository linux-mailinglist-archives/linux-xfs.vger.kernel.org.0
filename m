Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E890A381631
	for <lists+linux-xfs@lfdr.de>; Sat, 15 May 2021 07:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhEOFnF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 15 May 2021 01:43:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbhEOFnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 May 2021 01:43:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F5cwix112391;
        Sat, 15 May 2021 05:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZZKlKTiX4lzSZ+xVpd2yq/490gZOB3bFKP7RRbPCrI8=;
 b=WadaL/uLv6jEv/Ok7rJ1xebEEhFi/C/hCXXcRN7l1mWUf3A2CshCMo7N4LbbGU+o4zAN
 NYLEQszWs2oBP/p50coQxrCG7MB8TVrISl1PghdQ9NsRP2kmj2BkiLMSQe/bZJRFTIpK
 uNLFPJ3QgSU0Pe+EX3/GM691i7R0X3KcEchs4fp2PqTO5eeCnukXQs4rMyw0ZkHJ0thu
 UdYZcSOaSDY23XCVTTDUIq6Ck68RcJHJ2yf4IL6YYJjfvymy67+3Xn53Zrxw3cmLqIij
 k6ivBtFyvEnko4BzI5EN/GnUSB8/dqInB3OLBYueiwN1SMipf3/IIsGeXh880U/G+KEG gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38j5qr02yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 05:41:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F5erHI096972;
        Sat, 15 May 2021 05:41:48 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by aserp3020.oracle.com with ESMTP id 38j6415yth-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 05:41:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERyZjCQBMzf5VYs+ddCxifxpp6b/qlSt3s8FpJ41JzPoqLmwd7nvpXJAKUhUwfTxd5HqIna9Nk8GmnCAuYwv3w2XdtYUl4UWVzOW5h2eaOSqK9sXML7N0N/sPDIt7jJiRhwb6rAPRCQs5UJ2MfHV1gbO2PUgHw8dDe7V9D9Uwo4h3FFu6gHLuNsKpGxTrFrNjwvkBDtEHmx9ZadF5GS/1a4gUl3GG4A3xli9oULN12QOvUo7DEB9gQw8fyrmYNt5pyJum6LJ9nGSuRWsdjbe6ijzIlcYDpYXI3JOk7LIdkzfyS17RVw7/3JqrXYOuBl77AIJ64+ahHGplnzyk3qoXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZKlKTiX4lzSZ+xVpd2yq/490gZOB3bFKP7RRbPCrI8=;
 b=ibMKEJyWQ1aEHsWVKr+hpe2hrtSMkzlGWwx849IZQqAShDOiYuSxp1p6lX2SRD8ecwtPWoGG7JZm4F25HeaPnzUs1GCXAfFdO4kpQTSq1XcKVnVk5bZ9+MnaqGd4+6+0GD8OtiRbMOj/OkQV3cosEKNariGmB8jIMXYrLly49DWCD36+7iONa8xnoccZ/R7D5bE//grdFePrXW5yuAKIwWUhDcnhB6cwbQVZ+epbOQZ/oJsbXMiqQMJK4d8ObC9qGAxxfguQuPCs0akSGkAGfoHWGDa6TvLF0rhl26PGQup8w21G3hzxTV8L51lHHlC2S4C2v+fa8qtt8nhwmB8KEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZKlKTiX4lzSZ+xVpd2yq/490gZOB3bFKP7RRbPCrI8=;
 b=hlYKPX1XxnUQVqExZF/EwhWO2w4m4GI2TfDFq5X0nU+pT7KQtWnVT1s0d5OADOXcWzUVNW77rbi+TAq3IRmTZKCVCjZRtH6QDA93bDPEiVGM2ZSPihiYP7kNXt4dDlUzSS4Oksu0v3Qpn3mavuzz5l0UkfdC2CQu4oRiCRfvOSo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3272.namprd10.prod.outlook.com (2603:10b6:a03:157::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 05:41:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.029; Sat, 15 May 2021
 05:41:45 +0000
Subject: Re: [PATCH RESEND v18 10/11] xfs: Add delay ready attr remove
 routines
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210512161408.5516-1-allison.henderson@oracle.com>
 <20210512161408.5516-11-allison.henderson@oracle.com>
 <20210514004602.GG9675@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <1e100eee-3136-8de6-6699-d0b4df1da7d4@oracle.com>
Date:   Fri, 14 May 2021 22:41:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210514004602.GG9675@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0201.namprd03.prod.outlook.com (2603:10b6:a03:2ef::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 15 May 2021 05:41:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bda2593-ee53-42eb-1f6c-08d917642069
X-MS-TrafficTypeDiagnostic: BYAPR10MB3272:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3272D5F18AA258473623D689952F9@BYAPR10MB3272.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6yzzjNu7I96kCm1dukzZoZ4QLpJIW1zBU/5V1gdjaDyYj30RTNpelVmsYVEh4aTyI9Cc4g59V8GKpfQRZd8Dss2cP8lrSU0nilYAWk8GREd9c+v9Hf6ATw1vJuBaqO0PhxMUP5NvDR3W3yVjPos71qfZxobW/ktR4R0KPzMB891knL0tVWf8QtnZoiSFVHqgkvwvGQFXb7WUEImLBZou8PYZh5ohM0M6YKc15saWaqwQ766UhtwZ0wChMKDpPci5T6Yvbf0FcclzMDZoJeHZZRDKmPJpSEcwljk1wy/H32gegmJMj18sp0S+C2tB56XFC5Ndm5xx3Nfj/tWWCe8LSueXMbX7NKVY9lx+4sLGv8nmmQsMw4a96Pl2lqjLw9ZUPwYUATyuYq1EaVHjH5dnB99A/NJBm4ulxVHwNY/HzCAnxRdJoACVLzvAhScvakMA9oZ9eOgYhU248QoYexcLXWFzFMQNmVSdt5aPC1O7qzqroUaKRzyDJ3+XIxQEXzKn1O3ls61X4s0BAcsXSi5QC1XfKnsNz11Nt+thNPr98w4OJqTuwKvs5sUPXyExspC2f2s9c5yR8CmI6UL0oGZz3LolDE1AFqphRHDoXDTkuQ8L3DtYtXCrbKklSngBZJvnHYkDtu/5lu0QmTKnfZFso1jhmgB/cb7EssCz0ru5CBTpTLOuJZo9hD9XBSHMXTJ5dA39F6x2SBuHJy3YAO/zbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(136003)(346002)(8676002)(316002)(478600001)(83380400001)(31686004)(26005)(186003)(16576012)(53546011)(4326008)(2616005)(956004)(86362001)(6916009)(2906002)(30864003)(66556008)(66946007)(66476007)(6486002)(16526019)(44832011)(5660300002)(31696002)(52116002)(36756003)(8936002)(38100700002)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WFA4d3VaR0ZBMGlBUWZQdlk3WktYS1FFbWF3UUlEcHBPUTE3MktTeFVZWkx3?=
 =?utf-8?B?RTZkSjZqZHo0SE1uSnBwbmp1VGJRcDVTa1Q0OEhPYXYzRktvcWltR1FscmJF?=
 =?utf-8?B?T0JqYXZSbWx3ai85YURJYzBzNjU1S1plNVN2R3h4bzhmS3RxYm1zMjMwdWhR?=
 =?utf-8?B?bm42UFlZWjlLSjcrZkd3OTUwcUVGdWMwM2poeWU3Z2V4eTFXWnRXcFZzWi9H?=
 =?utf-8?B?OHFRTkJRZ09RTDA2Z2p0WjJsaHZzb0N6Z3BxYWJSS2hRK3JFRmFtODRKbEgr?=
 =?utf-8?B?aXFqVmIvZDlRRGlkT3NqT2x4MUhMa3Zuemc0eXNoUlhhNFowOGpLTkJnVVls?=
 =?utf-8?B?NU9FUGFtemZhVjg4cVZNcy94Njd1ZWh1QndOcHNxbmZoOWhHTEZXTWhqNHFv?=
 =?utf-8?B?d3FLMjh6VDlKcTRLOTdDYmtEUDU3Nkc1d2djK3ZPQUcyOEV3WkVTTFVjWDJP?=
 =?utf-8?B?emxidkI3YlNpMHAwZDV5SSttellXelJrNm5IbTNvQ3NtWXBUNnRpbkxSdmJ2?=
 =?utf-8?B?dC9zaklFbXluZHNYZlZvRVk5WDI5TmlpYStSYnBxU1c4YllxOWZWbk5zQzVh?=
 =?utf-8?B?MnFIbXRxNHNuc3NSbVVrV2RRZ0RFUzNZeUtCMGFXVjhhNGhFb3l1bGRrcG5E?=
 =?utf-8?B?bGJYL3J4MzNyRlRUdm1yekFwb3VLakszZnFxUTNGc2NaOEUrVHFjZHJDS0hu?=
 =?utf-8?B?Tk5aSWUrdVdHU2JWQThHdlM5ekgxT0xQWDRXcUx2UTBUSEJlWlRtUjd1ZEgv?=
 =?utf-8?B?ZlowcXpOeUY2eDhwOVVjUlBkbG5tVUNSV3JJdzFnWFpQY0V3cVdobjNIK29O?=
 =?utf-8?B?WU9CVWQ4NmgzcjB5S3dzWWJZUkJFMVM5SUxKNzllOVlCZHc1QnhCZG9uL0Iv?=
 =?utf-8?B?SGN2MjhMUUFteE1DR21lSzN5OW12dmdkTVJ1YVdBcC93SExINkdxQkZSTnND?=
 =?utf-8?B?VExYeTJITHZsSEdHZ0tHVG15YzNwWWtaSXB0bXZSQnJRdUxqTTM1TWl1MzMr?=
 =?utf-8?B?dFhHTFdrRFNETEZ5dUhyUnhJZzc4empqTlBsQXdqSzBRMElsaDJMYjdZRU9k?=
 =?utf-8?B?TmM0RytnVC9XZnNqd3JwU1haWnZCMjhzU2FZdHpCNEk5QTJERkFwMFRSUFRD?=
 =?utf-8?B?aHhpaU45WW04VVQwZEdHUmFaVVZ6Z1RjR0cwU0FKKzF1dDZWVXdGN2N1WmVW?=
 =?utf-8?B?dzJwQzZWZG0raHA3Rm1OdFdta2c2cWNjcytYWjhVeXpFZTNkK2FReTYvNjFQ?=
 =?utf-8?B?WEhmR2lFNTh6UGQrTzhiYnozZVRlQzczVWIvT3kxNm1PY0NpSXAzQmFkQ2E2?=
 =?utf-8?B?UHFhYkxWb250bkJ1VjRPcmhYN0VPZ3MvUGpsVGtTRk5qVFNnbEYwTno2N2s0?=
 =?utf-8?B?L0N4WWthQUdiT0F4L1RtUzhaTmlwT0lzUU5CbjJTSjJuaGZOZmF3S3NuZmdX?=
 =?utf-8?B?T1d0U1R0eFlSYXRScGExRGtpYlRxSjQ0dEdBcThxdzNFUjkyYmlHNVM3UUpz?=
 =?utf-8?B?YVBSTlJ2K1hyUXpLbnJndnp4M1dIbFVOY3IzTWhUMm5iMnd0Q1hrSWJyalNn?=
 =?utf-8?B?U1RjMjlQZHJrVURRRTN2aE9TSFF4Ny9Mb3ZXL1ZXcDVDQlFXYWUxQUNBeTgz?=
 =?utf-8?B?VmtyVTFVT3kxWWtRUytDUjlOdUlMSkJnd2RZQjdQS2dQTDJHdWZvTEQvUXRm?=
 =?utf-8?B?MXE1SmJ6Tkl6MWhYeEsyVEJSaW9nSmx5NVdFVlJYNnJvY0F6b3BZbHl0c3Zk?=
 =?utf-8?Q?INyezEdlXGKG49imKnaU0eh4YrVveWR6xmvi5mC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bda2593-ee53-42eb-1f6c-08d917642069
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 05:41:45.8171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJ6YqS4Ro6apiA4hmZbXvdSNU0uWlKy+5lG3Cu4xXDY9S5ff6PxZmuZbeRX1GrI4lEf670Gn3xhLpRf96cjbL+rvKBCwUPwT0TK5zgBvqD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3272
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150040
X-Proofpoint-GUID: o4Sc971NW4V94r-jhzYZj0RBKAz4Y2ph
X-Proofpoint-ORIG-GUID: o4Sc971NW4V94r-jhzYZj0RBKAz4Y2ph
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/13/21 5:46 PM, Darrick J. Wong wrote:
> On Wed, May 12, 2021 at 09:14:07AM -0700, Allison Henderson wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>> this series, xfs_attr_remove_args is merged with
>> xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
>> This new version uses a sort of state machine like switch to keep track
>> of where it was when EAGAIN was returned. A new version of
>> xfs_attr_remove_args consists of a simple loop to refresh the
>> transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
>> flag is used to finish the transaction where ever the existing code used
>> to.
>>
>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>> version __xfs_attr_rmtval_remove. We will rename
>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>> done.
>>
>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>> during a rename).  For reasons of preserving existing function, we
>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>> used and will be removed.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use
>> to keep track of the current state of an attribute operation. The new
>> xfs_delattr_state enum is used to track various operations that are in
>> progress so that we know not to repeat them, and resume where we left
>> off before EAGAIN was returned to cycle out the transaction. Other
>> members take the place of local variables that need to retain their
>> values across multiple function recalls.  See xfs_attr.h for a more
>> detailed diagram of the states.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 213 ++++++++++++++++++++++++++++------------
>>   fs/xfs/libxfs/xfs_attr.h        | 131 ++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
>>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>   fs/xfs/xfs_attr_inactive.c      |   2 +-
>>   6 files changed, 314 insertions(+), 84 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 21f862e..a91fff6 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>>   				 struct xfs_da_state *state);
>>   STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
>>   				 struct xfs_da_state **state);
>> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>> @@ -241,6 +240,31 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> +/*
>> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
>> + * transaction is finished or rolled as needed.
>> + */
>> +int
>> +xfs_attr_trans_roll(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error;
>> +
>> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>> +		/*
>> +		 * The caller wants us to finish all the deferred ops so that we
>> +		 * avoid pinning the log tail with a large number of deferred
>> +		 * ops.
>> +		 */
>> +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>> +		error = xfs_defer_finish(&args->trans);
>> +	} else
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +
>> +	return error;
>> +}
>> +
>>   STATIC int
>>   xfs_attr_set_fmt(
>>   	struct xfs_da_args	*args)
>> @@ -544,16 +568,25 @@ xfs_has_attr(
>>    */
>>   int
>>   xfs_attr_remove_args(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args	*args)
>>   {
>> -	if (!xfs_inode_hasattr(args->dp))
>> -		return -ENOATTR;
>> +	int				error;
>> +	struct xfs_delattr_context	dac = {
>> +		.da_args	= args,
>> +	};
>>   
>> -	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
>> -		return xfs_attr_shortform_remove(args);
>> -	if (xfs_attr_is_leaf(args->dp))
>> -		return xfs_attr_leaf_removename(args);
>> -	return xfs_attr_node_removename(args);
>> +	do {
>> +		error = xfs_attr_remove_iter(&dac);
>> +		if (error != -EAGAIN)
>> +			break;
>> +
>> +		error = xfs_attr_trans_roll(&dac);
>> +		if (error)
>> +			return error;
>> +
>> +	} while (true);
>> +
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -1197,14 +1230,16 @@ xfs_attr_leaf_mark_incomplete(
>>    */
>>   STATIC
>>   int xfs_attr_node_removename_setup(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state	**state)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		**state = &dac->da_state;
>> +	int				error;
>>   
>>   	error = xfs_attr_node_hasname(args, state);
>>   	if (error != -EEXIST)
>>   		return error;
>> +	error = 0;
>>   
>>   	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
>>   	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
>> @@ -1213,12 +1248,15 @@ int xfs_attr_node_removename_setup(
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_leaf_mark_incomplete(args, *state);
>>   		if (error)
>> -			return error;
>> +			goto out;
>>   
>> -		return xfs_attr_rmtval_invalidate(args);
>> +		error = xfs_attr_rmtval_invalidate(args);
>>   	}
>> +out:
>> +	if (error)
>> +		xfs_da_state_free(*state);
>>   
>> -	return 0;
>> +	return error;
>>   }
>>   
>>   STATIC int
>> @@ -1241,70 +1279,123 @@ xfs_attr_node_remove_name(
>>   }
>>   
>>   /*
>> - * Remove a name from a B-tree attribute list.
>> + * Remove the attribute specified in @args.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>>    * leaf nodes and even joining intermediate nodes up to and including
>>    * the root node (a special case of an intermediate node).
>> + *
>> + * This routine is meant to function as either an in-line or delayed operation,
>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>> + * functions will need to handle this, and recall the function until a
>> + * successful error code is returned.
>>    */
>> -STATIC int
>> -xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +int
>> +xfs_attr_remove_iter(
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	struct xfs_da_state	*state;
>> -	int			retval, error;
>> -	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		*state = dac->da_state;
>> +	int				retval, error;
>> +	struct xfs_inode		*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>>   
>> -	error = xfs_attr_node_removename_setup(args, &state);
>> -	if (error)
>> -		goto out;
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_UNINIT:
>> +		if (!xfs_inode_hasattr(dp))
>> +			return -ENOATTR;
>>   
>> -	/*
>> -	 * If there is an out-of-line value, de-allocate the blocks.
>> -	 * This is done before we remove the attribute so that we don't
>> -	 * overflow the maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			goto out;
>> +		/*
>> +		 * Shortform or leaf formats don't require transaction rolls and
>> +		 * thus state transitions. Call the right helper and return.
>> +		 */
>> +		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
>> +			return xfs_attr_shortform_remove(args);
>> +
>> +		if (xfs_attr_is_leaf(dp))
>> +			return xfs_attr_leaf_removename(args);
>>   
>>   		/*
>> -		 * Refill the state structure with buffers, the prior calls
>> -		 * released our buffers.
>> +		 * Node format may require transaction rolls. Set up the
>> +		 * state context and fall into the state machine.
>>   		 */
>> -		error = xfs_attr_refillstate(state);
>> -		if (error)
>> -			goto out;
>> -	}
>> -	retval = xfs_attr_node_remove_name(args, state);
>> +		if (!dac->da_state) {
>> +			error = xfs_attr_node_removename_setup(dac);
>> +			if (error)
>> +				return error;
>> +			state = dac->da_state;
>> +		}
>> +
>> +		/* fallthrough */
>> +	case XFS_DAS_RMTBLK:
>> +		dac->dela_state = XFS_DAS_RMTBLK;
>>   
>> -	/*
>> -	 * Check to see if the tree needs to be collapsed.
>> -	 */
>> -	if (retval && (state->path.active > 1)) {
>> -		error = xfs_da3_join(state);
>> -		if (error)
>> -			goto out;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			goto out;
>>   		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> +		 * If there is an out-of-line value, de-allocate the blocks.
>> +		 * This is done before we remove the attribute so that we don't
>> +		 * overflow the maximum size of a transaction and/or hit a
>> +		 * deadlock.
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			goto out;
>> -	}
>> +		if (args->rmtblkno > 0) {
>> +			/*
>> +			 * May return -EAGAIN. Roll and repeat until all remote
>> +			 * blocks are removed.
>> +			 */
>> +			error = __xfs_attr_rmtval_remove(dac);
>> +			if (error == -EAGAIN)
>> +				return error;
>> +			else if (error)
>> +				goto out;
>>   
>> -	/*
>> -	 * If the result is small enough, push it all into the inode.
>> -	 */
>> -	if (xfs_attr_is_leaf(dp))
>> -		error = xfs_attr_node_shrink(args, state);
>> +			/*
>> +			 * Refill the state structure with buffers (the prior
>> +			 * calls released our buffers) and close out this
>> +			 * transaction before proceeding.
>> +			 */
>> +			ASSERT(args->rmtblkno == 0);
>> +			error = xfs_attr_refillstate(state);
>> +			if (error)
>> +				goto out;
>> +			dac->dela_state = XFS_DAS_RM_NAME;
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		/* fallthrough */
>> +	case XFS_DAS_RM_NAME:
>> +		retval = xfs_attr_node_remove_name(args, state);
> 
> Hm.  I see a bunch of cleanup possibilities for after this series...
> 
> xfs_attr_shortform_remove
> xfs_attr_leaf_removename
> xfs_attr_node_remove_name
> 
> Can you add a patch to the end of the series renaming these to
> xfs_attr_{sf,leaf,node}_removename or something?
> 
> Also, can you refactor the chunk of code under "Remove the name and
> update the hashvals in the tree" in
> xfs_attr_node_addname_clear_incomplete to use xfs_attr_node_remove_name?
> 
> (Separate cleanup patches at the end of the series would be appreciated.)
Sure, that should be fine.  Do you want a patch for each?  Or just one 
clean up patch?

> 
>>   
>> +		/*
>> +		 * Check to see if the tree needs to be collapsed. If so, roll
>> +		 * the transacton and fall into the shrink state.
>> +		 */
>> +		if (retval && (state->path.active > 1)) {
>> +			error = xfs_da3_join(state);
>> +			if (error)
>> +				goto out;
>> +
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			dac->dela_state = XFS_DAS_RM_SHRINK;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		/* fallthrough */
>> +	case XFS_DAS_RM_SHRINK:
>> +		/*
>> +		 * If the result is small enough, push it all into the inode.
>> +		 * This is our final state so it's safe to return a dirty
>> +		 * transaction.
>> +		 */
>> +		if (xfs_attr_is_leaf(dp))
>> +			error = xfs_attr_node_shrink(args, state);
>> +		ASSERT(error != -EAGAIN);
>> +		break;
>> +	default:
>> +		ASSERT(0);
>> +		error = -EINVAL;
>> +		goto out;
>> +	}
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 2b1f619..32736d9 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -74,6 +74,133 @@ struct xfs_attr_list_context {
>>   };
>>   
>>   
>> +/*
>> + * ========================================================================
>> + * Structure used to pass context around among the delayed routines.
>> + * ========================================================================
>> + */
>> +
>> +/*
>> + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
>> + * states indicate places where the function would return -EAGAIN, and then
>> + * immediately resume from after being recalled by the calling function. States
>> + * marked as a "subroutine state" indicate that they belong to a subroutine, and
>> + * so the calling function needs to pass them back to that subroutine to allow
>> + * it to finish where it left off. But they otherwise do not have a role in the
>> + * calling function other than just passing through.
>> + *
>> + * xfs_attr_remove_iter()
>> + *              │
>> + *              v
>> + *        have attr to remove? ──n──> done
>> + *              │
>> + *              y
>> + *              │
>> + *              v
>> + *        are we short form? ──y──> xfs_attr_shortform_remove ──> done
>> + *              │
>> + *              n
>> + *              │
>> + *              V
>> + *        are we leaf form? ──y──> xfs_attr_leaf_removename ──> done
>> + *              │
>> + *              n
>> + *              │
>> + *              V
>> + *   ┌── need to setup state?
>> + *   │          │
>> + *   n          y
>> + *   │          │
>> + *   │          v
>> + *   │ find attr and get state
>> + *   │    attr has blks? ───n────┐
> 
> Nit: This should be "attr has remote blks?" since everywhere else in the
> code we call them remote value blocks.
Ok, will fix
> 
>> + *   │          │                v
>> + *   │          │         find and invalidate
>> + *   │          y         the blocks. mark
> 
> remote blocks...
will fix

> 
>> + *   │          │         attr incomplete
>> + *   │          ├────────────────┘
>> + *   └──────────┤
>> + *              │
>> + *              v
>> + *      Have blks to remove? ───y─────────┐
>> + *              │        ^          remove the blks
> 
> remote blocks...
will fix

> 
>> + *              │        │                │
>> + *              │        │                v
>> + *              │  XFS_DAS_RMTBLK <─n── done?
>> + *              │  re-enter with          │
>> + *              │  one less blk to        y
>> + *              │      remove             │
>> + *              │                         V
>> + *              │                  refill the state
>> + *              n                         │
>> + *              │                         v
>> + *              │                   XFS_DAS_RM_NAME
>> + *              │                         │
>> + *              ├─────────────────────────┘
>> + *              │
>> + *              v
>> + *       remove leaf and
>> + *       update hash with
>> + *   xfs_attr_node_remove_cleanup
>> + *              │
>> + *              v
>> + *           need to
>> + *        shrink tree? ─n─┐
>> + *              │         │
>> + *              y         │
>> + *              │         │
>> + *              v         │
>> + *          join leaf     │
>> + *              │         │
>> + *              v         │
>> + *      XFS_DAS_RM_SHRINK │
>> + *              │         │
>> + *              v         │
>> + *       do the shrink    │
>> + *              │         │
>> + *              v         │
>> + *          free state <──┘
>> + *              │
>> + *              v
>> + *            done
>> + *
>> + */
>> +
>> +/*
>> + * Enum values for xfs_delattr_context.da_state
>> + *
>> + * These values are used by delayed attribute operations to keep track  of where
>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>> + * calling function to roll the transaction, and then recall the subroutine to
> 
> nit: s/recall/call the subroutine again/
Sure, will update

> 
>> + * finish the operation.  The enum is then used by the subroutine to jump back
>> + * to where it was and resume executing where it left off.
>> + */
>> +enum xfs_delattr_state {
>> +	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>> +	XFS_DAS_RMTBLK,		      /* Removing remote blks */
>> +	XFS_DAS_RM_NAME,	      /* Remove attr name */
>> +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>> +};
>> +
>> +/*
>> + * Defines for xfs_delattr_context.flags
>> + */
>> +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>> +
>> +/*
>> + * Context used for keeping track of delayed attribute operations
>> + */
>> +struct xfs_delattr_context {
>> +	struct xfs_da_args      *da_args;
>> +
>> +	/* Used in xfs_attr_node_removename to roll through removing blocks */
>> +	struct xfs_da_state     *da_state;
>> +
>> +	/* Used to keep track of current state of delayed operation */
>> +	unsigned int            flags;
>> +	enum xfs_delattr_state  dela_state;
>> +};
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -92,6 +219,10 @@ int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>> +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>> +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>> +			      struct xfs_da_args *args);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 556184b..d97de20 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -19,8 +19,8 @@
>>   #include "xfs_bmap_btree.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_attr_sf.h"
>> -#include "xfs_attr_remote.h"
>>   #include "xfs_attr.h"
>> +#include "xfs_attr_remote.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_error.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 48d8e9c..2f3c4cc 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
>>    */
>>   int
>>   xfs_attr_rmtval_remove(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args		*args)
>>   {
>> -	int			error;
>> -	int			retval;
>> +	int				error;
>> +	struct xfs_delattr_context	dac  = {
>> +		.da_args	= args,
>> +	};
>>   
>>   	trace_xfs_attr_rmtval_remove(args);
>>   
>> @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>>   	do {
>> -		retval = __xfs_attr_rmtval_remove(args);
>> -		if (retval && retval != -EAGAIN)
>> -			return retval;
>> +		error = __xfs_attr_rmtval_remove(&dac);
>> +		if (error && error != -EAGAIN)
>> +			break;
>>   
>> -		/*
>> -		 * Close out trans and start the next one in the chain.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		error = xfs_attr_trans_roll(&dac);
>>   		if (error)
>>   			return error;
>> -	} while (retval == -EAGAIN);
>> +	} while (true);
>>   
>> -	return 0;
>> +	return error;
>>   }
>>   
>>   /*
>>    * Remove the value associated with an attribute by deleting the out-of-line
>> - * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>> + * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
>>    * transaction and re-call the function
>>    */
>>   int
>>   __xfs_attr_rmtval_remove(
>> -	struct xfs_da_args	*args)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error, done;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error, done;
>>   
>>   	/*
>>   	 * Unmap value blocks for this attr.
>> @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
>>   	if (error)
>>   		return error;
>>   
>> -	error = xfs_defer_finish(&args->trans);
>> -	if (error)
>> -		return error;
>> -
>> -	if (!done)
>> +	/*
>> +	 * We don't need an explicit state here to pick up where we left off. We
>> +	 * can figure it out using the !done return code. Calling function only
>> +	 * needs to keep recalling this routine until we indicate to stop by
> 
> "Callers should keep calling this routine until it returns something
> other than -EAGAIN."
> 
> Also, that should go in the comment above the function.
Alrighty, will update
> 
> With all those fairly minor things fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
Thanks!
Allison

> --D
> 
>> +	 * returning anything other than -EAGAIN. The actual value of
>> +	 * attr->xattri_dela_state may be some value reminiscent of the calling
>> +	 * function, but it's value is irrelevant with in the context of this
>> +	 * function. Once we are done here, the next state is set as needed
>> +	 * by the parent
>> +	 */
>> +	if (!done) {
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   		return -EAGAIN;
>> +	}
>>   
>>   	return error;
>>   }
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 9eee615..002fd30 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>> index bfad669..aaa7e66 100644
>> --- a/fs/xfs/xfs_attr_inactive.c
>> +++ b/fs/xfs/xfs_attr_inactive.c
>> @@ -15,10 +15,10 @@
>>   #include "xfs_da_format.h"
>>   #include "xfs_da_btree.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_attr.h"
>>   #include "xfs_attr_remote.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> -#include "xfs_attr.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_quota.h"
>>   #include "xfs_dir2.h"
>> -- 
>> 2.7.4
>>
