Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59193D8A3D
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jul 2021 11:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhG1JFA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Jul 2021 05:05:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62316 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231340AbhG1JE7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 05:04:59 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S92Xeg006828;
        Wed, 28 Jul 2021 09:04:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=kJCRTJvhQgavtnDPspT5VbzaCbXRCxcyCGFf5us/GG4=;
 b=bOeSeXlz94nbAEtezbkuS90r/KJX8xUAeweARvziXXI8YKVE+4DXCe2Xx+BgV8RmxRju
 BRaCocyMuKuVwVkeCejHmHfI1YnY1yp4OloL+CPJSrntEdSp+MO0TZIHNdPdvXWEoIs1
 2DpqO7/yEtvKZddgI0Yb3O14tupKwOE1rRMMjbYkqgfvRJ1hBt6yWdNfagVKUFf6e1FV
 5/Ar6i0lDYrCB/Ge8O1KbN3UzP1jRYLbHcHVTbJXuI/RX1DpqJ9x+gsVOVxH7jnnr9UT
 GU/nkLeQ56keXQLHXYXG/5dvoS5uG1W8xcaDrDdkdLh38xyDxblq2/Xd/iwARg7Zf1ji zQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kJCRTJvhQgavtnDPspT5VbzaCbXRCxcyCGFf5us/GG4=;
 b=sQBTJDUFsY/bkLoIO7BP1fcuoWgG1Pp+eE2+YR8RYMWSJFVtAGlubxlO9N0oEML9/R68
 aHW9zmcAlVpDfnGCh3tSx4EBYCktAPQIyjfQ9oBjTMv9RMmAz36wO8idbfzCN35InjAw
 MKUtvqMoHLWOZeo2hXxJzShDwx1t+zurObnYP1cScV4ZzVmdaogi9jbfQTQcLv0DfVV4
 /q0xsEfIwPPOkLN7hcMuyqM7rPRsgwnU6lxAs7yBPdbgmuRvuMZ8fl5oQLGLUKBcKmw8
 tWUNpco4lmTludAf9YBbc6AsMrtQ8bEEWba6Qxw9e1SWpQRS1LCaqvD/aky1meOIv25j Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2358by3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:04:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S8xW9R046372;
        Wed, 28 Jul 2021 09:04:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 3a2349sdsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:04:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDiNViSx7FVJqpOxs2iIvOJm6J0y3D1uTpVYm6zF91bEum2b34ghq11LzrjLlTqesM2MYQ2B7Uj1Kdl7w9fZ1uwWGXAB/LjdaeYbFFy9PX7Nys/Q3QFgOqfQyi4AiN23gUQzaxc1Gaw9OsrdAmFZ81DxV50EwhSzu+lE/nOXN1mCsFIBjDKGE1w/hFCXvOHSKK1abOQ2I1McOtmbcLSHT8a76gZxvdEeqAijrsjq10VLl1Ut8B8ZEI0HInGm/DYnZio3UEkyg24iEpUYleE/m3MQheZN4e5IuohCVS8s2jDI+lQCr7PmHY+Tl9hcYqGnE63lV+X9CK54DtaOyrqWqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJCRTJvhQgavtnDPspT5VbzaCbXRCxcyCGFf5us/GG4=;
 b=PO+se8LKz+XVqb0D+tvVvOksxdjQZ3bxUSHAkKaNw/4YgCe0jpzT7sdtooZHEJTVM2eJCcC8UhfPFfz8DQEX6IEAV62gCD3QvaKz9zfGq6TrUZ3SuFGr15bEHwwRuqt5uMJHI8C4Ux18lT62L2dxmBkUHSzZjnp39eCHNTfek1rleC49jUub+XDfaq6YYOe7W7kWHUoepWKEJ2qmCsWH85BSEzi505N6Y9pwu8sDXtLWoUo3R9rtJi9cqU/oEFRSS2wSvc/nKaSrWoS2Qqs2OTAGArkY5LNsNi02m1h+n96nCGcULHEIvkMwmjDstv7jMw64mYyx1GtMG+yD6lUURQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJCRTJvhQgavtnDPspT5VbzaCbXRCxcyCGFf5us/GG4=;
 b=FgUPHWChMpcqoc6376Gq/Qpase176aZ2K0iBC7SCDPzKY97mvwwn1MQ7exrT1E2jf9nuQVrfOTqeSEHzFlrf/MAVnJF9TrBhUaKGUGyS/oWIAim6HXfqy733q4nTh1lL2vaFIpzVesWCqOjwf436viyzN1GMTsmcgMkGcYemFmw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 09:04:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 09:04:52 +0000
Subject: Re: [PATCH v22 08/16] xfs: Set up infrastructure for deferred
 attribute operations
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-9-allison.henderson@oracle.com>
 <20210728005658.GC559212@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <bf267fdb-6244-3abf-4095-5f3607b7d590@oracle.com>
Date:   Wed, 28 Jul 2021 02:04:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210728005658.GC559212@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by SJ0PR03CA0260.namprd03.prod.outlook.com (2603:10b6:a03:3a0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 09:04:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b46dbc4-4cf5-4a00-ec7d-08d951a6c2b8
X-MS-TrafficTypeDiagnostic: BYAPR10MB2966:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2966FE5CF4ECFFEFB297A00895EA9@BYAPR10MB2966.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9+l/0SUxw59X1ZFmrdlJsvff9WfZ7IhTqunG5icJZbS50XB8r5qUxt/JRjF9eESNipT9YpUxOs/Zgar+gCedidBAZvaiY76H3gmWgZthTusYnAx75kbuZMbmxKTN0A9jc9d1UBiCOXGyWrRq5KXemiN6naolRVLAI+gdvpKy75zI1pVXKqzyvEBluecZQurqDQ5O9oBgEaC9S7He7hIvw3W39nUPDVhgeq1HEd7k8dvhAp+8ZKoI6GSiq0LwlGVXrTpBgCcxsz4EWta+vITfLqGEeoODMbMc0zHVwWrDSUlfnVjKXdrM8z9XwfJNX7bXyHgeRY3XRl4re10iu59WdMWvFqFpwVTn4du4Siq6guD/qYJIBGYcrzDE2yzNCGK4vxSbr+62+aM1kwYXCbZ3Szuuvd1Sc2bWbXey9LTIjR9Ca98Fa0CaQOpFt/RQCBlLcH0swUQHpsgikUPBFb1qrIHBQM27DiP0rv0fisvX5GCR4U1hBoCXx7hqTbB0jj5txfO0BizeTKsH/lxFynDUsy6ZZ4yC+RffOX+XuI+BYmr8EVjUrIXzzw39qwMFKFuSL/PsA/YySCvthpn2jLBdV5WF6h39FZvI6pGJaGte1xMHOeEmg2Xd7llbNA10b846BC4A4OHTBZIK+YT7vkgsFGH3du8sKoYy50SOiwT+Q79SXmkt1uBgOOc5amGNl8Z1V+Psiwzq5c+87atRYL5IjINjPX4FwnzHa/wXN2a9v5CuvnfYKhIxuGv+oyHVt4jqGp4bCk9j4UfCuf2QYW4vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(6916009)(38100700002)(26005)(6486002)(52116002)(2616005)(38350700002)(316002)(66946007)(66476007)(66556008)(83380400001)(5660300002)(2906002)(508600001)(956004)(36756003)(30864003)(186003)(16576012)(44832011)(4326008)(8676002)(8936002)(53546011)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q25UMzh2aytQSnVjRTQ4K3RQOUFxOWthNk1WZkhuYXF1eHorRVJkVlBpVm1F?=
 =?utf-8?B?dW16Umk3Z3BtSlMvb0hjMjJGZnhreGpSNkI3cEpkc1FGQzRtSjRMeFFucjgx?=
 =?utf-8?B?S3Q0eHZEcm9DLzk3cFQ0NUF4aldlL0tXTVVLQnVnMXdXSlZaSzZsbXB4OWg1?=
 =?utf-8?B?WVZKRzBJNzRlbGpMa0hVMlpvWTdQb3hPZ3RPSnVteTQzSlhWMTRXeEFJOGZT?=
 =?utf-8?B?ZlRRTHNqVkxCYkZxRFdxOFdDVlFXd25yUjNmRmxLQW5CUTJsRXo5QS9qazhZ?=
 =?utf-8?B?UW1DNlFCSUxSQmpKK28xUnY1VE5JeDNXbDJKaTI0d04wN1J0MUp2VDlFYVU2?=
 =?utf-8?B?SnZVS0lHK1NhWDdZczIzUHVqbkFYRE5QQ1lQVGRvSVBzNVJmRTJ4VXlhQU4y?=
 =?utf-8?B?eU9yeGtYZWZiNU5aQ0d1M1RQNU5KZUREL0laOU1jbFhTcklzaElDT0RQOVJV?=
 =?utf-8?B?UWcxOHU3WktuYXBVSW8rZzMzVW1PRlZ5dTJqaDhDeDR4NWhIZlRuRlVXRGVs?=
 =?utf-8?B?RFpraEczU2J1eHA4V2Rrb1hLcExFZnpZL25maHVLOHdrSUxMd3lUUmhYQ3ln?=
 =?utf-8?B?bG9GUlpTL3lpZG1pSGpveEI5OU56YnlSSHhNMnZtVGpuU3JRZ2FHeUREN1ZU?=
 =?utf-8?B?blkxd2FVNW1UZUxnUWlzWE81a2UvL3ZDSkRkU0VOU0NNYTJBTXJXRmEyRlEy?=
 =?utf-8?B?Q3pIY0FtOVQ1ZzBocVBDdTdRVUJ0dlBybm50cTRDM1BxQjM0cDNkdncyQStF?=
 =?utf-8?B?b05zUjdJbXZuMlpFU0hESG5oYUZDT05ySDlHVm5jdlRsNVBhSVZCQ20xcDky?=
 =?utf-8?B?Wk03L3E5SzJhUmx5M04xZ2MrRVJMTzhzdXhkTVJRanoybHNMQmFzckZnK3VR?=
 =?utf-8?B?UnZWZWtOZG5xcHF3MjgyWm1sVzI1eEdHNjZGQndZVzZlZFdac2h0RGJrNTlX?=
 =?utf-8?B?a0NFSmh5ekRFVnpEaWE2NllPMG5WRTh5VEhwOHJhbW5wdFIxNFMzTDVoVmJx?=
 =?utf-8?B?R2hrWkhLV044SGlxck9zTW0xc2tMNDZRR3lFbkJPckdRdFh0cjNoOHdaQkpD?=
 =?utf-8?B?Wm5CTXJRbWdZUlN2b1l6MHhyMkkvcUgxYXd2NU9wY2NDSTFlRmtpMC9wTXB3?=
 =?utf-8?B?Sk1nd21zSE43bnVKdGNCTWZvRHkxend4eWVNajcrN3krQVRXbDhoNzU3SENL?=
 =?utf-8?B?cDQ0NkxDK3JCUE03Ylh4T0tCcE9iZWdydkhyczVnb2FTdzFqQWdwOWppbWM2?=
 =?utf-8?B?ZGJsTGZyY0xOL2s0N0d5SFJjN2YzUEI0djhzNjNmTDErVlMxU0FwWWUrT0cw?=
 =?utf-8?B?bmV4RmNuR1gvRDJIMndCeStTejd2TzJFWWNkWFNTSFlRQVV3ZDhoUlJSMmdR?=
 =?utf-8?B?aTdsUnBsVEw3WHJZY3czeGJkUjBCWmp4aUZrY0p6b3hZRWdGcHYwOVlNSmtU?=
 =?utf-8?B?TDlRYkovTmp1M3NPOTdoM2ZMeERhQTYrb1psVkxlUnJKQ3B1clBSTVFNb0tT?=
 =?utf-8?B?UVRqQXpsNHp2WFh3YjlWNC9LQ1ZXYmRFWG52TEl1a0g2S2xuOTJJeHBRV3dZ?=
 =?utf-8?B?cVZ6YmZBWWsyaEF5WWNUUlAvdUg5WENJNmp4NUhocEI1U3VreW5QdWw1L3lt?=
 =?utf-8?B?aGNyN2NwYks4bHFJanlyTGxkcDZIa3ViTWk1cXhwRHluNmhsaGZaaEZJcWJx?=
 =?utf-8?B?Mmx1NmFjL2poNFoyYlVrbHB6cVE0eFNtaDMvOGZlcHRlMi9FellkSUpIbXhh?=
 =?utf-8?Q?yFxgo8tzIwLYU0qXnOTEmFBayfuWfLh0mxGgUVZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b46dbc4-4cf5-4a00-ec7d-08d951a6c2b8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:04:52.4897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTr1iFWPETpafALA6YcG2+B5u6ZjeuLwimmjyBLSSnIPN3TZfTh6xjcEU1eAHPBRVIyzytR3ebsktwpMPWPIN0YcJ2dref6gFrxnzI88Cfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2966
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107280051
X-Proofpoint-GUID: EZOsJGPEzU4bJPJ_Cl3vXDPIILHDv_OT
X-Proofpoint-ORIG-GUID: EZOsJGPEzU4bJPJ_Cl3vXDPIILHDv_OT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/21 5:56 PM, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 11:20:45PM -0700, Allison Henderson wrote:
>> Currently attributes are modified directly across one or more
>> transactions. But they are not logged or replayed in the event of an
>> error. The goal of delayed attributes is to enable logging and replaying
>> of attribute operations using the existing delayed operations
>> infrastructure.  This will later enable the attributes to become part of
>> larger multi part operations that also must first be recorded to the
>> log.  This is mostly of interest in the scheme of parent pointers which
>> would need to maintain an attribute containing parent inode information
>> any time an inode is moved, created, or removed.  Parent pointers would
>> then be of interest to any feature that would need to quickly derive an
>> inode path from the mount point. Online scrub, nfs lookups and fs grow
>> or shrink operations are all features that could take advantage of this.
>>
>> This patch adds two new log item types for setting or removing
>> attributes as deferred operations.  The xfs_attri_log_item will log an
>> intent to set or remove an attribute.  The corresponding
>> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
>> freed once the transaction is done.  Both log items use a generic
>> xfs_attr_log_format structure that contains the attribute name, value,
>> flags, inode, and an op_flag that indicates if the operations is a set
>> or remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/Makefile                 |   1 +
>>   fs/xfs/libxfs/xfs_attr.c        |   5 +-
>>   fs/xfs/libxfs/xfs_attr.h        |  31 +++
>>   fs/xfs/libxfs/xfs_defer.h       |   2 +
>>   fs/xfs/libxfs/xfs_log_format.h  |  44 +++-
>>   fs/xfs/libxfs/xfs_log_recover.h |   2 +
>>   fs/xfs/scrub/common.c           |   2 +
>>   fs/xfs/xfs_attr_item.c          | 456 ++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr_item.h          |  52 +++++
>>   fs/xfs/xfs_attr_list.c          |   1 +
>>   fs/xfs/xfs_ioctl32.c            |   2 +
>>   fs/xfs/xfs_iops.c               |   2 +
>>   fs/xfs/xfs_log.c                |   4 +
>>   fs/xfs/xfs_log_recover.c        |   2 +
>>   fs/xfs/xfs_ondisk.h             |   2 +
>>   15 files changed, 603 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
>> index 04611a1..b056cfc 100644
>> --- a/fs/xfs/Makefile
>> +++ b/fs/xfs/Makefile
>> @@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
>>   				   xfs_buf_item_recover.o \
>>   				   xfs_dquot_item_recover.o \
>>   				   xfs_extfree_item.o \
>> +				   xfs_attr_item.o \
>>   				   xfs_icreate_item.o \
>>   				   xfs_inode_item.o \
>>   				   xfs_inode_item_recover.o \
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5ff0320..11d8081 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -24,6 +24,7 @@
>>   #include "xfs_quota.h"
>>   #include "xfs_trans_space.h"
>>   #include "xfs_trace.h"
>> +#include "xfs_attr_item.h"
>>   
>>   /*
>>    * xfs_attr.c
>> @@ -61,8 +62,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>> -STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> -			     struct xfs_buf **leaf_bp);
>>   STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
>>   				    struct xfs_da_state *state);
>>   
>> @@ -166,7 +165,7 @@ xfs_attr_get(
>>   /*
>>    * Calculate how many blocks we need for the new attribute,
>>    */
>> -STATIC int
>> +int
>>   xfs_attr_calc_size(
>>   	struct xfs_da_args	*args,
>>   	int			*local)
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 8de5d1d..463b2be 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -28,6 +28,11 @@ struct xfs_attr_list_context;
>>    */
>>   #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
>>   
>> +static inline bool xfs_hasdelattr(struct xfs_mount *mp)
>> +{
>> +	return false;
>> +}
>> +
>>   /*
>>    * Kernel-internal version of the attrlist cursor.
>>    */
>> @@ -454,6 +459,7 @@ enum xfs_delattr_state {
>>    */
>>   #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>>   #define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
>> +#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
>>   
>>   /*
>>    * Context used for keeping track of delayed attribute operations
>> @@ -461,6 +467,11 @@ enum xfs_delattr_state {
>>   struct xfs_delattr_context {
>>   	struct xfs_da_args      *da_args;
>>   
>> +	/*
>> +	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
>> +	 */
>> +	struct xfs_buf		*leaf_bp;
>> +
>>   	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
>>   	struct xfs_bmbt_irec	map;
>>   	xfs_dablk_t		lblkno;
>> @@ -474,6 +485,23 @@ struct xfs_delattr_context {
>>   	enum xfs_delattr_state  dela_state;
>>   };
>>   
>> +/*
>> + * List of attrs to commit later.
>> + */
>> +struct xfs_attr_item {
>> +	struct xfs_delattr_context	xattri_dac;
>> +
>> +	/*
>> +	 * Indicates if the attr operation is a set or a remove
>> +	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
>> +	 */
>> +	unsigned int			xattri_op_flags;
>> +
>> +	/* used to log this item to an intent */
>> +	struct list_head		xattri_list;
>> +};
>> +
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -490,11 +518,14 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> +		      struct xfs_buf **leaf_bp);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>> +int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 05472f7..0ed9dfa 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -63,6 +63,8 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>>   extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
>> +extern const struct xfs_defer_op_type xfs_attr_defer_type;
>> +
>>   
>>   /*
>>    * This structure enables a dfops user to detach the chain of deferred
>> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
>> index d548ea4..7ff0b57 100644
>> --- a/fs/xfs/libxfs/xfs_log_format.h
>> +++ b/fs/xfs/libxfs/xfs_log_format.h
>> @@ -114,7 +114,12 @@ struct xfs_unmount_log_format {
>>   #define XLOG_REG_TYPE_CUD_FORMAT	24
>>   #define XLOG_REG_TYPE_BUI_FORMAT	25
>>   #define XLOG_REG_TYPE_BUD_FORMAT	26
>> -#define XLOG_REG_TYPE_MAX		26
>> +#define XLOG_REG_TYPE_ATTRI_FORMAT	27
>> +#define XLOG_REG_TYPE_ATTRD_FORMAT	28
>> +#define XLOG_REG_TYPE_ATTR_NAME	29
>> +#define XLOG_REG_TYPE_ATTR_VALUE	30
>> +#define XLOG_REG_TYPE_MAX		30
>> +
>>   
>>   /*
>>    * Flags to log operation header
>> @@ -237,6 +242,8 @@ typedef struct xfs_trans_header {
>>   #define	XFS_LI_CUD		0x1243
>>   #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
>>   #define	XFS_LI_BUD		0x1245
>> +#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
>> +#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
>>   
>>   #define XFS_LI_TYPE_DESC \
>>   	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
>> @@ -252,7 +259,9 @@ typedef struct xfs_trans_header {
>>   	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
>>   	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
>>   	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
>> -	{ XFS_LI_BUD,		"XFS_LI_BUD" }
>> +	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
>> +	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
>> +	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
>>   
>>   /*
>>    * Inode Log Item Format definitions.
>> @@ -860,4 +869,35 @@ struct xfs_icreate_log {
>>   	__be32		icl_gen;	/* inode generation number to use */
>>   };
>>   
>> +/*
>> + * Flags for deferred attribute operations.
>> + * Upper bits are flags, lower byte is type code
>> + */
>> +#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
>> +#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
>> +#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>> +
>> +/*
>> + * This is the structure used to lay out an attr log item in the
>> + * log.
>> + */
>> +struct xfs_attri_log_format {
>> +	uint16_t	alfi_type;	/* attri log item type */
>> +	uint16_t	alfi_size;	/* size of this item */
>> +	uint32_t	__pad;		/* pad to 64 bit aligned */
>> +	uint64_t	alfi_id;	/* attri identifier */
>> +	uint64_t	alfi_ino;	/* the inode for this attr operation */
>> +	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
>> +	uint32_t	alfi_name_len;	/* attr name length */
>> +	uint32_t	alfi_value_len;	/* attr value length */
>> +	uint32_t	alfi_attr_flags;/* attr flags */
>> +};
>> +
>> +struct xfs_attrd_log_format {
>> +	uint16_t	alfd_type;	/* attrd log item type */
>> +	uint16_t	alfd_size;	/* size of this item */
>> +	uint32_t	__pad;		/* pad to 64 bit aligned */
>> +	uint64_t	alfd_alf_id;	/* id of corresponding attri */
>> +};
>> +
>>   #endif /* __XFS_LOG_FORMAT_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
>> index ff69a00..32e2162 100644
>> --- a/fs/xfs/libxfs/xfs_log_recover.h
>> +++ b/fs/xfs/libxfs/xfs_log_recover.h
>> @@ -72,6 +72,8 @@ extern const struct xlog_recover_item_ops xlog_rui_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_rud_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_cui_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_cud_item_ops;
>> +extern const struct xlog_recover_item_ops xlog_attri_item_ops;
>> +extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
>>   
>>   /*
>>    * Macros, structures, prototypes for internal log manager use.
>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>> index 8558ca0..7003ce3 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -23,6 +23,8 @@
>>   #include "xfs_rmap_btree.h"
>>   #include "xfs_log.h"
>>   #include "xfs_trans_priv.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_reflink.h"
>>   #include "xfs_ag.h"
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> new file mode 100644
>> index 0000000..a810c2a
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -0,0 +1,456 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
>> + */
>> +
>> +#include "xfs.h"
>> +#include "xfs_fs.h"
>> +#include "xfs_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_bit.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_mount.h"
>> +#include "xfs_defer.h"
>> +#include "xfs_log_format.h"
>> +#include "xfs_trans.h"
>> +#include "xfs_bmap_btree.h"
>> +#include "xfs_trans_priv.h"
>> +#include "xfs_buf_item.h"
>> +#include "xfs_log.h"
>> +#include "xfs_btree.h"
>> +#include "xfs_rmap.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_icache.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>> +#include "xfs_attr.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_attr_item.h"
>> +#include "xfs_alloc.h"
>> +#include "xfs_bmap.h"
>> +#include "xfs_trace.h"
>> +#include "libxfs/xfs_da_format.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_quota.h"
>> +#include "xfs_trans_space.h"
>> +#include "xfs_error.h"
>> +#include "xfs_log_priv.h"
>> +#include "xfs_log_recover.h"
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops;
>> +static const struct xfs_item_ops xfs_attrd_item_ops;
>> +
>> +/* iovec length must be 32-bit aligned */
>> +static inline size_t ATTR_NVEC_SIZE(size_t size)
>> +{
>> +	return size == sizeof(int32_t) ? size :
>> +	       sizeof(int32_t) + round_up(size, sizeof(int32_t));
>> +}
>> +
>> +static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
>> +{
>> +	return container_of(lip, struct xfs_attri_log_item, attri_item);
>> +}
>> +
>> +STATIC void
>> +xfs_attri_item_free(
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	kmem_free(attrip->attri_item.li_lv_shadow);
>> +	kmem_free(attrip);
>> +}
>> +
>> +/*
>> + * Freeing the attrip requires that we remove it from the AIL if it has already
>> + * been placed there. However, the ATTRI may not yet have been placed in the
>> + * AIL when called by xfs_attri_release() from ATTRD processing due to the
>> + * ordering of committed vs unpin operations in bulk insert operations. Hence
>> + * the reference count to ensure only the last caller frees the ATTRI.
>> + */
>> +STATIC void
>> +xfs_attri_release(
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
>> +	if (atomic_dec_and_test(&attrip->attri_refcount)) {
>> +		xfs_trans_ail_delete(&attrip->attri_item,
>> +				     SHUTDOWN_LOG_IO_ERROR);
>> +		xfs_attri_item_free(attrip);
>> +	}
>> +}
>> +
>> +STATIC void
>> +xfs_attri_item_size(
>> +	struct xfs_log_item	*lip,
>> +	int			*nvecs,
>> +	int			*nbytes)
>> +{
>> +	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
>> +
>> +	*nvecs += 1;
>> +	*nbytes += sizeof(struct xfs_attri_log_format);
>> +
>> +	/* Attr set and remove operations require a name */
>> +	ASSERT(attrip->attri_name_len > 0);
>> +
>> +	*nvecs += 1;
>> +	*nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
>> +
>> +	if (attrip->attri_value_len > 0) {
>> +		*nvecs += 1;
>> +		*nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
>> +	}
>> +}
>> +
>> +/*
>> + * This is called to fill in the log iovecs for the given attri log
>> + * item. We use  1 iovec for the attri_format_item, 1 for the name, and
>> + * another for the value if it is present
>> + */
>> +STATIC void
>> +xfs_attri_item_format(
>> +	struct xfs_log_item	*lip,
>> +	struct xfs_log_vec	*lv)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_log_iovec		*vecp = NULL;
>> +
>> +	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
>> +	attrip->attri_format.alfi_size = 1;
>> +
>> +	/*
>> +	 * This size accounting must be done before copying the attrip into the
>> +	 * iovec.  If we do it after, the wrong size will be recorded to the log
>> +	 * and we trip across assertion checks for bad region sizes later during
>> +	 * the log recovery.
>> +	 */
>> +
>> +	ASSERT(attrip->attri_name_len > 0);
>> +	attrip->attri_format.alfi_size++;
>> +
>> +	if (attrip->attri_value_len > 0)
>> +		attrip->attri_format.alfi_size++;
>> +
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
>> +			&attrip->attri_format,
>> +			sizeof(struct xfs_attri_log_format));
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
>> +			attrip->attri_name,
>> +			ATTR_NVEC_SIZE(attrip->attri_name_len));
>> +	if (attrip->attri_value_len > 0)
>> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>> +				attrip->attri_value,
>> +				ATTR_NVEC_SIZE(attrip->attri_value_len));
>> +}
>> +
>> +/*
>> + * The unpin operation is the last place an ATTRI is manipulated in the log. It
>> + * is either inserted in the AIL or aborted in the event of a log I/O error. In
>> + * either case, the ATTRI transaction has been successfully committed to make
>> + * it this far. Therefore, we expect whoever committed the ATTRI to either
>> + * construct and commit the ATTRD or drop the ATTRD's reference in the event of
>> + * error. Simply drop the log's ATTRI reference now that the log is done with
>> + * it.
>> + */
>> +STATIC void
>> +xfs_attri_item_unpin(
>> +	struct xfs_log_item	*lip,
>> +	int			remove)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(lip));
>> +}
>> +
>> +
>> +STATIC void
>> +xfs_attri_item_release(
>> +	struct xfs_log_item	*lip)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(lip));
>> +}
>> +
>> +/*
>> + * Allocate and initialize an attri item.  Caller may allocate an additional
>> + * trailing buffer of the specified size
>> + */
>> +STATIC struct xfs_attri_log_item *
>> +xfs_attri_init(
>> +	struct xfs_mount		*mp,
>> +	int				buffer_size)
>> +
>> +{
>> +	struct xfs_attri_log_item	*attrip;
>> +	uint				size;
>> +
>> +	size = sizeof(struct xfs_attri_log_item) + buffer_size;
>> +	attrip = kmem_alloc_large(size, KM_ZERO);
>> +	if (attrip == NULL)
>> +		return NULL;
>> +
>> +	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
>> +			  &xfs_attri_item_ops);
>> +	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
>> +	atomic_set(&attrip->attri_refcount, 2);
>> +
>> +	return attrip;
>> +}
>> +
>> +/*
>> + * Copy an attr format buffer from the given buf, and into the destination attr
>> + * format structure.
>> + */
>> +STATIC int
>> +xfs_attri_copy_format(
>> +	struct xfs_log_iovec		*buf,
>> +	struct xfs_attri_log_format	*dst_attr_fmt)
>> +{
>> +	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
>> +	uint				len;
>> +
>> +	len = sizeof(struct xfs_attri_log_format);
>> +	if (buf->i_len != len) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
>> +	return 0;
>> +}
>> +
>> +static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
>> +{
>> +	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
>> +}
>> +
>> +STATIC void
>> +xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
>> +{
>> +	kmem_free(attrdp->attrd_item.li_lv_shadow);
>> +	kmem_free(attrdp);
>> +}
>> +
>> +STATIC void
>> +xfs_attrd_item_size(
>> +	struct xfs_log_item		*lip,
>> +	int				*nvecs,
>> +	int				*nbytes)
>> +{
>> +	*nvecs += 1;
>> +	*nbytes += sizeof(struct xfs_attrd_log_format);
>> +}
>> +
>> +/*
>> + * This is called to fill in the log iovecs for the given attrd log item. We use
>> + * only 1 iovec for the attrd_format, and we point that at the attr_log_format
>> + * structure embedded in the attrd item.
>> + */
>> +STATIC void
>> +xfs_attrd_item_format(
>> +	struct xfs_log_item	*lip,
>> +	struct xfs_log_vec	*lv)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
>> +	struct xfs_log_iovec		*vecp = NULL;
>> +
>> +	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
>> +	attrdp->attrd_format.alfd_size = 1;
>> +
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
>> +			&attrdp->attrd_format,
>> +			sizeof(struct xfs_attrd_log_format));
>> +}
>> +
>> +/*
>> + * The ATTRD is either committed or aborted if the transaction is canceled. If
>> + * the transaction is canceled, drop our reference to the ATTRI and free the
>> + * ATTRD.
>> + */
>> +STATIC void
>> +xfs_attrd_item_release(
>> +	struct xfs_log_item		*lip)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
>> +
>> +	xfs_attri_release(attrdp->attrd_attrip);
>> +	xfs_attrd_item_free(attrdp);
>> +}
>> +
>> +STATIC xfs_lsn_t
>> +xfs_attri_item_committed(
>> +	struct xfs_log_item		*lip,
>> +	xfs_lsn_t			lsn)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +
>> +	/*
>> +	 * The attrip refers to xfs_attr_item memory to log the name and value
>> +	 * with the intent item. This already occurred when the intent was
>> +	 * committed so these fields are no longer accessed. Clear them out of
>> +	 * caution since we're about to free the xfs_attr_item.
>> +	 */
>> +	attrip->attri_name = NULL;
>> +	attrip->attri_value = NULL;
>> +
>> +	/*
>> +	 * The ATTRI is logged only once and cannot be moved in the log, so
>> +	 * simply return the lsn at which it's been logged.
>> +	 */
>> +	return lsn;
>> +}
>> +
>> +STATIC bool
>> +xfs_attri_item_match(
>> +	struct xfs_log_item	*lip,
>> +	uint64_t		intent_id)
>> +{
>> +	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>> +}
>> +
>> +static const struct xfs_item_ops xfs_attrd_item_ops = {
>> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>> +	.iop_size	= xfs_attrd_item_size,
>> +	.iop_format	= xfs_attrd_item_format,
>> +	.iop_release    = xfs_attrd_item_release,
>> +};
>> +
>> +/* Is this recovered ATTRI ok? */
>> +static inline bool
>> +xfs_attri_validate(
>> +	struct xfs_mount		*mp,
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	struct xfs_attri_log_format     *attrp = &attrip->attri_format;
>> +	unsigned int			op = attrp->alfi_op_flags &
>> +					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>> +
>> +	/* alfi_op_flags should be either a set or remove */
>> +	if (op != XFS_ATTR_OP_FLAGS_SET && op != XFS_ATTR_OP_FLAGS_REMOVE)
>> +		return false;
>> +
>> +	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
>> +		return false;
>> +
>> +	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
>> +	    (attrp->alfi_name_len == 0))
>> +		return false;
>> +
>> +	if (!xfs_verify_ino(mp, attrp->alfi_ino))
>> +		return false;
>> +
>> +	return xfs_hasdelattr(mp);
> 
> Sorry to bother you about this again, but this isn't the right place to
> be deciding that we're not going to replay a recovered xattr intent
> item.  If there are any xattri items in the log, the feature bit will be
> set on the superblock, so the place to reject them is in
> xfs_fs_fill_super where all the other EXPERIMENTAL warnings are.
> 
> IOWs, this last chunk of the function becomes:
> 
> 	return xfs_verify_ino(...);
Oh ok.  No problem, will update.

> }
> 
> and you can drop xfs_hasdelattr() completely.  In the patch that
> actually adds the mount option, please add to xfs_fs_fill_super right
> before the xfs_mountfs call:
> 
> 	if (!(mp->m_flags & XFS_MOUNT_LARP) &&
> 	    xfs_sb_version_haslogxattrs(&mp->m_sb)) {
> 		xfs_err(mp, "cannot recover unsupported attr log items");
> 		return -EINVAL;
> 	}
Sure, but this may be translated to use the debug option if we go that 
route.

> 
> --D
Thanks for the reviews!
Allison

> 
>> +}
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops = {
>> +	.iop_size	= xfs_attri_item_size,
>> +	.iop_format	= xfs_attri_item_format,
>> +	.iop_unpin	= xfs_attri_item_unpin,
>> +	.iop_committed	= xfs_attri_item_committed,
>> +	.iop_release    = xfs_attri_item_release,
>> +	.iop_match	= xfs_attri_item_match,
>> +};
>> +
>> +
>> +
>> +STATIC int
>> +xlog_recover_attri_commit_pass2(
>> +	struct xlog                     *log,
>> +	struct list_head		*buffer_list,
>> +	struct xlog_recover_item        *item,
>> +	xfs_lsn_t                       lsn)
>> +{
>> +	int                             error;
>> +	struct xfs_mount                *mp = log->l_mp;
>> +	struct xfs_attri_log_item       *attrip;
>> +	struct xfs_attri_log_format     *attri_formatp;
>> +	char				*name = NULL;
>> +	char				*value = NULL;
>> +	int				region = 0;
>> +	int				buffer_size;
>> +
>> +	attri_formatp = item->ri_buf[region].i_addr;
>> +
>> +	/* Validate xfs_attri_log_format */
>> +	if (attri_formatp->__pad != 0 || attri_formatp->alfi_name_len == 0 ||
>> +	    (attri_formatp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE &&
>> +	    attri_formatp->alfi_value_len != 0)) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	buffer_size = attri_formatp->alfi_name_len +
>> +		      attri_formatp->alfi_value_len;
>> +
>> +	attrip = xfs_attri_init(mp, buffer_size);
>> +	if (attrip == NULL)
>> +		return -ENOMEM;
>> +
>> +	error = xfs_attri_copy_format(&item->ri_buf[region],
>> +				      &attrip->attri_format);
>> +	if (error) {
>> +		xfs_attri_item_free(attrip);
>> +		return error;
>> +	}
>> +
>> +	attrip->attri_name_len = attri_formatp->alfi_name_len;
>> +	attrip->attri_value_len = attri_formatp->alfi_value_len;
>> +	region++;
>> +	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
>> +	memcpy(name, item->ri_buf[region].i_addr, attrip->attri_name_len);
>> +	attrip->attri_name = name;
>> +
>> +	if (attrip->attri_value_len > 0) {
>> +		region++;
>> +		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
>> +			attrip->attri_name_len;
>> +		memcpy(value, item->ri_buf[region].i_addr,
>> +			attrip->attri_value_len);
>> +		attrip->attri_value = value;
>> +	}
>> +
>> +	/*
>> +	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
>> +	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
>> +	 * directly and drop the ATTRI reference. Note that
>> +	 * xfs_trans_ail_update() drops the AIL lock.
>> +	 */
>> +	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
>> +	xfs_attri_release(attrip);
>> +	return 0;
>> +}
>> +
>> +const struct xlog_recover_item_ops xlog_attri_item_ops = {
>> +	.item_type	= XFS_LI_ATTRI,
>> +	.commit_pass2	= xlog_recover_attri_commit_pass2,
>> +};
>> +
>> +/*
>> + * This routine is called when an ATTRD format structure is found in a committed
>> + * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
>> + * it was still in the log. To do this it searches the AIL for the ATTRI with
>> + * an id equal to that in the ATTRD format structure. If we find it we drop
>> + * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
>> + */
>> +STATIC int
>> +xlog_recover_attrd_commit_pass2(
>> +	struct xlog			*log,
>> +	struct list_head		*buffer_list,
>> +	struct xlog_recover_item	*item,
>> +	xfs_lsn_t			lsn)
>> +{
>> +	struct xfs_attrd_log_format	*attrd_formatp;
>> +
>> +	attrd_formatp = item->ri_buf[0].i_addr;
>> +	if (item->ri_buf[0].i_len != sizeof(struct xfs_attrd_log_format)) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	xlog_recover_release_intent(log, XFS_LI_ATTRI,
>> +				    attrd_formatp->alfd_alf_id);
>> +	return 0;
>> +}
>> +
>> +const struct xlog_recover_item_ops xlog_attrd_item_ops = {
>> +	.item_type	= XFS_LI_ATTRD,
>> +	.commit_pass2	= xlog_recover_attrd_commit_pass2,
>> +};
>> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
>> new file mode 100644
>> index 0000000..ce33e9b
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.h
>> @@ -0,0 +1,52 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later
>> + *
>> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
>> + */
>> +#ifndef	__XFS_ATTR_ITEM_H__
>> +#define	__XFS_ATTR_ITEM_H__
>> +
>> +/* kernel only ATTRI/ATTRD definitions */
>> +
>> +struct xfs_mount;
>> +struct kmem_zone;
>> +
>> +/*
>> + * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
>> + */
>> +#define	XFS_ATTRI_RECOVERED	1
>> +
>> +
>> +/*
>> + * This is the "attr intention" log item.  It is used to log the fact that some
>> + * attribute operations need to be processed.  An operation is currently either
>> + * a set or remove.  Set or remove operations are described by the xfs_attr_item
>> + * which may be logged to this intent.
>> + *
>> + * During a normal attr operation, name and value point to the name and value
>> + * fields of the calling functions xfs_da_args.  During a recovery, the name
>> + * and value buffers are copied from the log, and stored in a trailing buffer
>> + * attached to the xfs_attr_item until they are committed.  They are freed when
>> + * the xfs_attr_item itself is freed when the work is done.
>> + */
>> +struct xfs_attri_log_item {
>> +	struct xfs_log_item		attri_item;
>> +	atomic_t			attri_refcount;
>> +	int				attri_name_len;
>> +	int				attri_value_len;
>> +	void				*attri_name;
>> +	void				*attri_value;
>> +	struct xfs_attri_log_format	attri_format;
>> +};
>> +
>> +/*
>> + * This is the "attr done" log item.  It is used to log the fact that some attrs
>> + * earlier mentioned in an attri item have been freed.
>> + */
>> +struct xfs_attrd_log_item {
>> +	struct xfs_attri_log_item	*attrd_attrip;
>> +	struct xfs_log_item		attrd_item;
>> +	struct xfs_attrd_log_format	attrd_format;
>> +};
>> +
>> +#endif	/* __XFS_ATTR_ITEM_H__ */
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 25dcc98..81e167a 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -15,6 +15,7 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_attr_sf.h"
>>   #include "xfs_attr_leaf.h"
>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>> index e650677..cb9f036 100644
>> --- a/fs/xfs/xfs_ioctl32.c
>> +++ b/fs/xfs/xfs_ioctl32.c
>> @@ -17,6 +17,8 @@
>>   #include "xfs_itable.h"
>>   #include "xfs_fsops.h"
>>   #include "xfs_rtalloc.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_ioctl.h"
>>   #include "xfs_ioctl32.h"
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 93c082d..6f15cad 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -13,6 +13,8 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_acl.h"
>>   #include "xfs_quota.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index c58a0d7..7c593d9 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -2090,6 +2090,10 @@ xlog_print_tic_res(
>>   	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>>   	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>>   	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
>> +	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
>> +	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
>> +	    REG_TYPE_STR(ATTR_NAME, "attr name"),
>> +	    REG_TYPE_STR(ATTR_VALUE, "attr value"),
>>   	};
>>   	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>>   #undef REG_TYPE_STR
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 1212fa1..d2098e92 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -1802,6 +1802,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
>>   	&xlog_cud_item_ops,
>>   	&xlog_bui_item_ops,
>>   	&xlog_bud_item_ops,
>> +	&xlog_attri_item_ops,
>> +	&xlog_attrd_item_ops,
>>   };
>>   
>>   static const struct xlog_recover_item_ops *
>> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
>> index 2599192..758702b 100644
>> --- a/fs/xfs/xfs_ondisk.h
>> +++ b/fs/xfs/xfs_ondisk.h
>> @@ -132,6 +132,8 @@ xfs_check_ondisk_structs(void)
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
>> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
>> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
>>   
>>   	/*
>>   	 * The v5 superblock format extended several v4 header structures with
>> -- 
>> 2.7.4
>>
