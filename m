Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C920E55F4AC
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jun 2022 06:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiF2D5K (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Jun 2022 23:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiF2D4p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 23:56:45 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2043.outbound.protection.outlook.com [40.107.96.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97FC37019;
        Tue, 28 Jun 2022 20:56:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjvE0FZith52EmgKtGs06Lr7l0W9cqEFrkvfog8a75hswfQZQ+Ef/sE/yyp8ra0tAJxjwn9d2aSgwIkTTBiCs6eIX24WYJ5/8f6ZcDfZXRmbn//jg4gE/GfKgZaJ7Y2VeIsKe6dCCYQ7Cxkb8LRy8sxrVwaeTXHmvxjigHffvz7h2slL6Gu8JZ2rcCH/DIgcNSEDcsRO2ed4LuoLJE/5j2lO6uT+rHUud7Ed1cfqmT7TiSbL7ZgpE+fk5hFxbuq+aCkPaNYb35ZG06mnJ60muBIoxdycNr7lmCkCTsUtegrHI5NiauxwpntVKNvIeAJ65EGliegkYYWMfWm314Qmyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9Sc6LYpVPfoVFE5y7D4sSctWQmL3zBIK2SZB3p/gHQ=;
 b=McOqE2TWC/w4+hff0t4LimPCcZp+V0P20BrVxCRuOUGRriXZduZr0mQeopyBh6Gpvk4UM5KY1EFKqCtGSvO/SCxWnT48OORcivEEw85MksWQ3Ob0ZO5Qq08kdEKF7MpE+Sy33Na2AScWscw+iGw2H25RPYaYOiDK2ZzUd5NxrbOk/fZIGc/eRO6R0PkqNghq2Esu4s7F9RvwJRrPOSzA2rnu1SRuOkwAKv1VqCjk4CHnyQIS6hNT1hoYJ4yM/xMOX9UZAy2siQt2hyOLGdFCJxrtxYMGjNRg0gal6EWlo6rfeRobitBIWAYtH/jKJOqZmRN+fTvFEmB2eA1phA5HGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9Sc6LYpVPfoVFE5y7D4sSctWQmL3zBIK2SZB3p/gHQ=;
 b=4GhwoRSF7OHDRieExBkZXQ5uGflV3C8jCZQfQuE+w3ph6hdb6250xsT8E//uAXpgi/HRb1MT73BUI4kLsXUDR6qFZdPnEQUSzTpby2Ey4UMmMv5Cr9ni9oFBvvYLeht4TwMvNLho8ORy557XvbcfpjhQOX7dIfOYpQ0LoCoCIK0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29)
 by DM6PR12MB3274.namprd12.prod.outlook.com (2603:10b6:5:182::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 03:56:39 +0000
Received: from SN6PR12MB2717.namprd12.prod.outlook.com
 ([fe80::4534:eee9:f4ea:e9fb]) by SN6PR12MB2717.namprd12.prod.outlook.com
 ([fe80::4534:eee9:f4ea:e9fb%6]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 03:56:38 +0000
Message-ID: <3c9345ca-7dd8-3833-e341-4f97f124b772@amd.com>
Date:   Tue, 28 Jun 2022 22:56:33 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v6 02/14] mm: handling Non-LRU pages returned by
 vm_normal_pages
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220628001454.3503-1-alex.sierra@amd.com>
 <20220628001454.3503-3-alex.sierra@amd.com>
 <79a7969c-311f-d36b-4d44-dfe2f02c9b99@redhat.com>
From:   "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>
In-Reply-To: <79a7969c-311f-d36b-4d44-dfe2f02c9b99@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:610:b1::7) To SN6PR12MB2717.namprd12.prod.outlook.com
 (2603:10b6:805:68::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebb10a27-23f7-480a-c9e5-08da59835e6b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3274:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P59XlSUBffc3QrjqssvI87XKmNYYFrr1OzQ0J43zkDtEZilmfWSqKTFWtPcDEywlTTYc1DfS/TEQDYKwycPIT3XZ6xsXkVLj4F1AnjjA8k3TyVV2Bwv+gQFx9BfFNbTlSTcD6BK030XlMt6NGdxsy86Id3zxoa62wiNRl9hgnZm6zBfG/BYaywoezGhRH20cCzZI1tqFLrymA/t+piKuW8GZ0Qs23N+DLzDx3hkS/TZd6Q6czG8xAd1QO1C1IzzYuZ/l1C0v094bOH/kodAS5LlKlfCw24Tpyr2UE0+Q8wUFbO30slE1vpdQAib+8gW3+9gkQVNAju6a1yfKAQTwSaODqRznSmLFF8u8eFIiRg08I3SWmFdyYcPfwB6ebOekFy0rQlb8chzd8GttgTEOalEsc7oDETolv8TH7zxxC4nixj1BFMCD1Lt0P4wfdhNLIdP7t2mHjMoBCFgCRYwYVSjXy2VQsBmwDPIThrHGz8jsJO3G/KlPK3rqX84XxeCL7rFGT56SOI/2V0A5nbFb89N3WkCvGgm+3QJKhotOuJeHzw/KdHayjn3D+6kWUgSGI8jh8Ws5XNAh7FeFPwo8Pry/Lw2Kc1jh8RDTF52gt9jtLWErN8YP5/lKu4UCoQtFtZ4UlM/L7ZoiLdUQgTdyDfpf/IYMrbiesst3CkscKChQ4+KYp9Ay7f7MTc+6EV46X90lolQVXp5jo+k4aHEkZIWwIXZp+I0DD3qjwwyzs7EmaCsK092O9KUKp4CweuV12nREGDLZXCccFqtuZMr5dtkdGOT9GUVNbwgyXiSZAYbiIbhoYKDM/SZx9v9+wYTg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2717.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6486002)(8676002)(66556008)(4326008)(31696002)(66946007)(86362001)(66476007)(7416002)(41300700001)(53546011)(478600001)(6512007)(6666004)(26005)(6506007)(186003)(4744005)(8936002)(2906002)(36756003)(38100700002)(2616005)(316002)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3ArR2psMVU4SDBCQSsxY1VaSURJYTJURTFsVzVISFNaYnNNSEg4V1VGcS8w?=
 =?utf-8?B?dDNVY2lZY2dvWDlDRmZUTWJGbFFFUVdacDVIMXNmN25KL0tEc3NlUmtlSW01?=
 =?utf-8?B?RCtzb1pPRGJnMFBBK0M2SWN2cmhaVjE2NG5oeDUxUFVGQ2c0bkw2T1lGTGN2?=
 =?utf-8?B?V1pRMVB2eTV4SlkwSGZoUDJ2ak1abFlacUhSMkR2SXRVUUxrTE5wM3RrRkND?=
 =?utf-8?B?cTNVcnJoa01oWm5ORlZ6dUJzSWU3VkJ3aXEwWllRblE5aThJWDZkcDZYdUt5?=
 =?utf-8?B?N1M3NHJUNldIT0IyY2tQZFgxa0dqbmNScjZXVllScTFQMmpldTNIWS9MeCs4?=
 =?utf-8?B?OUgzNkZvYkVOTVVJeWY5ZzdBTFIxN0FyMEU4cWJSZ0tXa2JmbFJSSTJsZFNX?=
 =?utf-8?B?MzVINzB4cDRZVnBvL1ZkV2lZUm9GZGRoWW1rNGZLeG9SeTJyTlJ5UlN3S1h2?=
 =?utf-8?B?Q1I1aGc1Q1ZzS1I2L3MvRTUxb0xYOEdEcTE4VjNRWTZnYnU4U3gydFlCTXk1?=
 =?utf-8?B?MGlWY0R6R013dHMzTkJ4RmNSd3J2ejl0c2x2RXRDMFZQU1J2aFdlL2ZDQlZj?=
 =?utf-8?B?c1lQZ1dlam1jdGlhYVZkOHpCQmFBKzY2aUhqeW5sK0tSa2Q3VUk5Z29BdFN5?=
 =?utf-8?B?OWFjTWRFQkdybzdZMUtqaUVBSFJINXNLalN4TGhwbG9pS1IwWG9acHQxWVVx?=
 =?utf-8?B?c1FpaUJ4aU9DNFJjUzYvMXJIM1ZQUHNVMGdrRFNBenFNYitLOFZqQ2Fjdmlt?=
 =?utf-8?B?bG55TW80aTlHcDdTbkhpdnd6cGxnOEVHL1g4aWF3bWRHRi90TEdEZG5vbGd0?=
 =?utf-8?B?WWYrM2NqbHlJMGY4MmxNUUxIeld5TzRyT3NuMWEvR3lwYkdNMFBnMDFSQ3pB?=
 =?utf-8?B?ZE1zU3ByWGF6bEFPUFExc3hMcFVlTmpBMTBWRG13WThvVS8wSDBpNUtvSXRz?=
 =?utf-8?B?ODljUDgrbGFzdjYvR0pYaEsxTitsUDgvNytlcXg1NTVxUnBkRzJBTW82NjB1?=
 =?utf-8?B?ZjJ5ME5VMTZvRVplSGcvZTFXMG1Dcy9IQmdBWDkweEk3TmI1dFl3bDkrZlh3?=
 =?utf-8?B?all2dTljYmM3d0MzNDNFV0tZb2s5WUVwMFg5STMzQXg4bzZ6Z1BlUHJZSWt2?=
 =?utf-8?B?T25FaStoUG04T29pN2J1NG1UWU5RUTFuQUcyN2UrMDdJZXlLbEJ6L0VaTVR0?=
 =?utf-8?B?ZEhBLzY0QW96MkhxK2JEZ2p4cjFkb2FLLzR1OCs4MWc4dndUdnQ1Z3Via2ZB?=
 =?utf-8?B?RFNtWXRpSG55Q2xEalJNRGpJTGxVVytCY1JpSXltWWFTSXNXTnN2bDV2bUw1?=
 =?utf-8?B?c3UrL041TkFONEpJNVIwSmRYL21qNlVyQXZrSUdYUVM1NkJ2VEozQnZXZGlu?=
 =?utf-8?B?V2J5dGovL3VBc3pydi9xQ25OMi9pWXlXMnE0N1hweTN3dHRncUY5R3VuSitZ?=
 =?utf-8?B?VkdacFpoNStNdzB3Q3B6QS9WYzlBMjZpMWZlc1lHN1dZOXBldGQzVXE0V3JE?=
 =?utf-8?B?eXdJcVZ1SzEzWXAwRE5walc2ZFN0SFhBcFppdG02S2RGeWRGdVRPUFdtZEJj?=
 =?utf-8?B?M0lDblFzR0VhRUpDRXBvZUhueEFwQ3VsVlIwODlOY1FBM0l0NU12SVBiakZL?=
 =?utf-8?B?Mkl2ZERZU3NWYndrV1RyQzY2Tm9LUlo3SjdQNnJuR3l2eHJXMnl3bEZKK3NC?=
 =?utf-8?B?bUo2UWQrMGtMby9JcjdyVDUxaFdmRmcyb2VjaVBLN0U0RThsa0ZrTnJ6Q1lN?=
 =?utf-8?B?bDI1L29wTG1ET1B2T2V2ZkkrTExzWVN3Ui9ZeXZ4b2l3b3QyK1dPNmF4Nktz?=
 =?utf-8?B?SjBKV0F3Q2pHZksvQ3RTQlowdk5qWjNsa29OOHlXRk5BQjE2T080UGJ5U0xk?=
 =?utf-8?B?QlJnRUk5ZFhWL3pWTmEvcDA4cDlYUytSdE1oSkh6UlB3VXE0cUhSUTlKU3Y2?=
 =?utf-8?B?YkxYdG9ZUUJUSDJQKysvamxiRXVpNldOcTFxenpnQjdsUm1aQ3hzV3RnSmpC?=
 =?utf-8?B?NDBpZ1kzVTQ4NGVUbGdIajhoRnpPakJXZHpiOVVTSitod3d0cHY0TndRdEVs?=
 =?utf-8?B?ZXVqZGg2VGFYWGhSSC91ZzJsck9qdEd0ZFo2U3hlWmtYcnprTmpZanB3YWg5?=
 =?utf-8?Q?IBHgHE9u7wcEPnfSXyaYJgzec?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb10a27-23f7-480a-c9e5-08da59835e6b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2717.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 03:56:38.8400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T8s2QwEeEbhVzcNh2BqkK7Z1FvQzr8jS541m7H90TQqC+XLpGZ+Lnt3Ad788+Ibl8bqQTxstgPK5NLlRWwaisA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3274
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 6/28/2022 5:42 AM, David Hildenbrand wrote:
> On 28.06.22 02:14, Alex Sierra wrote:
>> With DEVICE_COHERENT, we'll soon have vm_normal_pages() return
>> device-managed anonymous pages that are not LRU pages. Although they
>> behave like normal pages for purposes of mapping in CPU page, and for
>> COW. They do not support LRU lists, NUMA migration or THP.
>>
>> We also introduced a FOLL_LRU flag that adds the same behaviour to
>> follow_page and related APIs, to allow callers to specify that they
>> expect to put pages on an LRU list.
>>
>> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
>> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
>> Reviewed-by: Alistair Popple <apopple@nvidia.com>
>> ---
> I think my review feedback regarding FOLL_LRU has been ignored.

Sorry David, this has been addressed in v7.

Regards,
Alex Sierra

>
>
