Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6668758096A
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Jul 2022 04:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiGZCWP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Jul 2022 22:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiGZCWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 22:22:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F1C19C33;
        Mon, 25 Jul 2022 19:22:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H32LRkpEg6/QD59rCZ+DOUPbUicpVvWmLt8qMl8h73+PJM1Xi8/Ci4L3ltamb8P0GBDxZS1S9/BfCnKWvN8teaOH37qbUrfE/yqNXMujA6OTN9pCA7it0BAniyigd8b+QVY6qNdJV7R0VAmpDskFjBzAtHOx5KZ2JwSkUe/wa5lUb/Ngt9OusZx3U+CJ9nnkOg38Uwcm11IsZMNeye0o8ZWDirDmvOEAJmYc1dRxNrjCUHzBt8dHfRUyVHtoh9qevX7Lk7JWlnvJAdFn6x6X2anJ1EEqoOl5zzDsQUmdduwjz+GPKCck6rHT7qk4qq6rEfl0nVZ9rNHTBC7/wbpCgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWTrl5XdgAkDwB+tlZjsMXdlzOfjma8RzYG+M2UJxK4=;
 b=BN1tWRrcDFQf//4Hkfz47DOYbd1ZRlfVMBVTbXxBEyE3VijrcrL0UdNuqseEl4FbthaLhVwwlq+49E1j+sKH8dcdhZplXaUJ/OISJjcxuGRdyDAQ+eUvpgtFKPYbpysNKqakpqz04rClYxnfUZUTXmapuUxmruKcKpNr/Mzz/CqWtUjE1uqtYQTgHU3I/kLyOHa5kxSxmXReh1E7GNDLZ0CaQSy7Ei/Ri5Lu1vb2DKsisecLv+2Uwql2paJ35dL68L1moeLckGvqZclxz9uxpc5WEfnBfYtMve96RYn0MRNT7CP64j64insk+XD3J1R5U3aamJsk22BoUgyEUckegA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWTrl5XdgAkDwB+tlZjsMXdlzOfjma8RzYG+M2UJxK4=;
 b=4+nF6H9+Q5hd1k8n5lRbnAfQjwGaoPuXMw42k//2fl0phW04ciZ35S1MTMBBjNEu3KDkkkBHb4qyJJZ4HPXYmz+ccTBjEo/afAml/HwJpYvmeFMF7mpLj3sDlf9/q5XSBHrrgH4NSpdxXPrg5jctmcU4I03EAYEonDfF0Me0+Vc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29)
 by DM5PR12MB1481.namprd12.prod.outlook.com (2603:10b6:4:e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Tue, 26 Jul 2022 02:22:10 +0000
Received: from SN6PR12MB2717.namprd12.prod.outlook.com
 ([fe80::406d:a54b:5cd4:9b4]) by SN6PR12MB2717.namprd12.prod.outlook.com
 ([fe80::406d:a54b:5cd4:9b4%2]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 02:22:10 +0000
Message-ID: <adb2031b-774d-e645-2aec-f9de433b0a7c@amd.com>
Date:   Mon, 25 Jul 2022 21:22:06 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v9 06/14] mm/gup: migrate device coherent pages when
 pinning instead of failing
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>
Cc:     jgg@nvidia.com, Felix.Kuehling@amd.com, linux-mm@kvack.org,
        rcampbell@nvidia.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, hch@lst.de, jglisse@redhat.com,
        apopple@nvidia.com, willy@infradead.org
References: <20220715150521.18165-1-alex.sierra@amd.com>
 <20220715150521.18165-7-alex.sierra@amd.com>
 <225554c2-9174-555e-ddc0-df95c39211bc@redhat.com>
 <20220718133235.4fdbd6ec303219e5a3ba49cf@linux-foundation.org>
From:   "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>
In-Reply-To: <20220718133235.4fdbd6ec303219e5a3ba49cf@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::7) To SN6PR12MB2717.namprd12.prod.outlook.com
 (2603:10b6:805:68::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c425227-7bb6-41e7-168d-08da6eada50b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1481:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APl4tsUnoZe88ja/1+UZGwDLpDIyFZ8tNjaxf4Pl2SJ1XbeM5htVABBuwjG14DAfcluHKMZSE2oPigbPQ7vsLztT8MZYy+53n/VeTgxzsODQj9P3xRH4xhyI1V2f93/OhUSV7Ym/kUyZi/nYkusWTpQH59TCmZSTw8Y5HKC0kNMBAow0O9s9Guj+d2i34hy+vcDF+bz+Bsjvsar6EuXKd+cmGbnnNXjVeGkcTSExQkup4LuiPqtoSS0dEQs0O3SR2luswQQYEInNh7J1Pw0rvESrdtqGKcjOGn8rxfzgJ2cPA+kVBQTrnSUSp719uMxBB6w1cHFuWEI7jhI220aqM/fjAG6JpKLLvipwwR5cjeMihvZJHUkY9F/wqFx2tUSQpyqcnv8jE2XXg1kTAeBU+k4znkGFZ4HJnwMRCbEPL4DErR2+if1RjdfJPQg2MEiT/3cdLm5YtIR4U48kUcv6h+mpvAdy5Rk+DEcw570sfwWBdaG6wmqKRt3p5AVKJlJ7v6fHCrBvcXBqvTVyaFv+GZtLPXkIU85jeGsC8fBtqx/s7ScwqN1n/utu3kwacNuS5OfT3XHUk7cEMStL+9HwuY6Upps7oKf+AgQnLEpsYor0r6QWh1dv545QJ2Hgb428Ott3jzbP+GMjOBTgtw1H7bRcxESbFedmcsHEFpuVUXQuzmR3yiF2KjCAcQu5ZWBV3rHCKkV/nh4UhxQr6/twJheIAvVfbpNdw/I4Pdx0NQcT4/yFccOWfSMCP386Xn5o04HYKAS1y/LM4uSdLNpueH6wMp5t9n8om+YFsBB7QHoQNUe7S0+6AAwNpErKPhUdhwePwZfE/yLiDZFT0u2azw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2717.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(86362001)(7416002)(5660300002)(66946007)(8936002)(4326008)(8676002)(110136005)(66556008)(31696002)(66476007)(36756003)(6666004)(38100700002)(2906002)(31686004)(26005)(6486002)(478600001)(316002)(41300700001)(6512007)(6506007)(186003)(53546011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDJmTnUwL0ZNTk11czEwREg4QzhUY01wNDUvYkNFOHRIajVKdkUrN2pOWmc2?=
 =?utf-8?B?QnRTV2R2aXRxYXNBd09wZE5pbDgyc1BXZ0srRGtTZlN4cGxwQ0xOeFQ3V3I0?=
 =?utf-8?B?QU1VWlF2KzQ3TGJsRnVwK0JOVlNTamk0cURqRW5Qbys0WnF0WmttUVpjQWsr?=
 =?utf-8?B?MWI1SkxRcXBRNjkzSTd5TWt6VFIrbGZmNy9oYUxZZDkyTXNKYUJrbFhadkY0?=
 =?utf-8?B?Mk1qMGI1OFBPaWtYM1IveEFjb2VFR042eDZmdEg1UU1oVzJaTEdObFJxUGZU?=
 =?utf-8?B?K2h4TkRmTTkvOGNBL0R2WGppWHZwZ0xycUR0ZWszNE5FSDFGWEZDZ29KcEpN?=
 =?utf-8?B?Z2pyR01sQ1AwTG16N0NhdkVPSnpHMmpHay9QdEJ3YUR2TzQ3TmpxWHZjaXdw?=
 =?utf-8?B?akpud0VWVHhKcU9hV1loaHVKWnB5VFNDbStxK3BOeGFwTzJGNjFOMGgwY0Vv?=
 =?utf-8?B?VDFCdTdYcVM4RXpaeU5EckVscTJZUkQwU0Y3c3Mwamc4NHA4YkhVK1N2OE1i?=
 =?utf-8?B?RTJaMEtrSldpTmFnbm9JS1B1OGlRQmt5ckd2RWVsbndiL0p2bjAwaVRjKzBW?=
 =?utf-8?B?bVRObFdPL2NtNjhHVHRvNk4rWmxSWXRBaTNob3hjalZTNjFkWU96UEE2cmov?=
 =?utf-8?B?V242UStpUDVxaFRwVCs3SktxMWppbnhhVlJGM0Uzd3hOYldsL2tkSXFTNW5R?=
 =?utf-8?B?aGdiZHMzVHNXU0IvanoxNWUxYmxpeGx6b2ZVTE9UK2ovS0ZvOUhFbC9hYkxp?=
 =?utf-8?B?c0ZEMEU2aDZOTS9GZmdSQkhYeUF4dTc2bHNKME5oS1hCNTNMSmlnWG8vOG5C?=
 =?utf-8?B?ZTBRamFBNDByMWpOcFJiU1A3SEpTSGhQOXFBQ3lubUZvODRmNFc4MTRVcCtp?=
 =?utf-8?B?RjhMUnZWTHV4eUVMRXhFclpPOGM1NjVSdE40V2xZbzFHTGd1RXpPRXM1ZGpn?=
 =?utf-8?B?M0FjMHB4QWR0TnlKMEpMYWpvcTJXdnBDTVllWGNYU1FsV2RLSDYvWkNYbER1?=
 =?utf-8?B?VXJSVjViU3Npd2dlUXFPZzgvazdvb1lreTNQbVdSNGo2V2p2a3NTeCtDMENJ?=
 =?utf-8?B?MjRDM0FwclRWZzVCN1gxakloek5VQ3VtZ2QvbjBEMXIyOVBpeDRQRWhtU1NP?=
 =?utf-8?B?dDZGV2JxQjBUOFR4UVc4dTQ3TGlacXdtYzBRUTN6U3BscU1reDVWbnhpejUw?=
 =?utf-8?B?L0xaTFg3eTNRMDVkZkpKRHhOZTEzcGUrSVpNejQ5WCtMWlR5aC9yUHpFOHNM?=
 =?utf-8?B?bXNwZENTSUpEdkxxcCthTDRqYXZyOUFXK3VWMXQ4dDg4OS9obUthS2ZUdHl3?=
 =?utf-8?B?aFhrbjNxcWR2eE5ZQzNRWDRYbWwrVzlObnVaWWdSTktqMEJySDJ5UjA2MTdq?=
 =?utf-8?B?amUwMGNYUkhOMDNTUENoSDZyemRBYVdsa0FNMjJOVFNXaERsekNBY1ZHYnVj?=
 =?utf-8?B?bXo1bnBDSGJQVFhFcHVHNW5qM1p5QlVxalBxdFNDcUNEMHRUSlVUS0drMHJE?=
 =?utf-8?B?NDRkRkpJbmRIYUFYVGNjcm1HajBvaTJ1NnIrbm4xQzlJYm5DbE12REE2ZDNz?=
 =?utf-8?B?QjJqajZHQnVZUmxxRFgxOEFXVlBDV0JrU0tVYzBIZkNYdWU0OWdWYjg1SkRQ?=
 =?utf-8?B?bFREKy9FTFUrS0tSVFZUYVkvU01RR0xPaUQ2U3RtMExZODFybGR2dzhzUWZT?=
 =?utf-8?B?Y2I4bWQxMlFQZVVQUndhb0huaGlhY0VqamVSVkFWZWpuT1NOU2p0dGg5SVZ3?=
 =?utf-8?B?bzBSN0Y2R3ZHWEpjRWRJWW5Ma3hOLzlVYzQ4Wm83eU1BTzRaN0JyKy9hRThZ?=
 =?utf-8?B?WXhvamFFSUJieHBzOTZTR3JRMDBHR3hMTXpNbGpSdnptN2tvMW9sam96cDJn?=
 =?utf-8?B?L2JkaFU4dFl0RzJPMEI5SzBrN0d1NEI3MFBhb0NERW5FMGhFbHR1cXpGdzhN?=
 =?utf-8?B?TkRaRTZuT2kvRXd1M2tsdEFKRS9NZVJwcHdMd3l3T2tPeFcxeHRXcWpkdDN4?=
 =?utf-8?B?ZGpTeDlFL0tHVkNlNlRYdGJpbjM2NUVabFN1bGtHNnp2dEx5WThYaW1GNUVL?=
 =?utf-8?B?eWdjVEsyWCsvT2pvQzRoWE0wMGVCYlBOMU1UWjlNLzRocFFqRE5ob1A2U0Qv?=
 =?utf-8?Q?KcZ5DeuorR9JUR+u3KrogDN1D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c425227-7bb6-41e7-168d-08da6eada50b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2717.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 02:22:10.6367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5/1s3anPTCfAjzWLDj2205eYAz9oolwUU4OZ1a/TvSoazCEtQ8l1eoqYYKLU3J0j58jAPw8mYfItr2lz/eroA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1481
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 7/18/2022 3:32 PM, Andrew Morton wrote:
> On Mon, 18 Jul 2022 12:56:29 +0200 David Hildenbrand <david@redhat.com> wrote:
>
>>>   		/*
>>>   		 * Try to move out any movable page before pinning the range.
>>>   		 */
>>> @@ -1919,7 +1948,8 @@ static long check_and_migrate_movable_pages(unsigned long nr_pages,
>>>   				    folio_nr_pages(folio));
>>>   	}
>>>   
>>> -	if (!list_empty(&movable_page_list) || isolation_error_count)
>>> +	if (!list_empty(&movable_page_list) || isolation_error_count
>>> +		|| coherent_pages)
>> The common style is to
>>
>> a) add the || to the end of the previous line
>> b) indent such the we have a nice-to-read alignment
>>
>> if (!list_empty(&movable_page_list) || isolation_error_count ||
>>      coherent_pages)
>>
> I missed that.  This series is now in mm-stable so any fix will need to
> be a standalone followup patch, please.
Hi Andrew,
Just wanted to make sure nothing is missing from our side to merge this 
patch series.

Regards,
Alex Sierra
>
>> Apart from that lgtm.
>>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
> And your reviewed-by's will be lost.  Stupid git.
