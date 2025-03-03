Return-Path: <linux-xfs+bounces-20429-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A14D7A4CE9D
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Mar 2025 23:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EA251896EB4
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Mar 2025 22:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79CF235C04;
	Mon,  3 Mar 2025 22:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AHSLVOix";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XEmSg1ms"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC14C217F29;
	Mon,  3 Mar 2025 22:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741041780; cv=fail; b=PvlhDNex5O4yRsATmhEkd+Xr6gKSNu06LV+W8d6tmn7WgZtq/uuaJZsu0Ty5VXrVEzdico5Vp6ELpVZm0UbKVSAQUqUrUznVbrSxrGLdnUJBSM7UK2aH8lyer46xiUQszCr17IsQSV07+R71pgxYQFds3vBxljMvp5hBANIE25s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741041780; c=relaxed/simple;
	bh=82sdkqhXyOVrPScCfAc2KsUMnbpndAyxeSIOui19j7U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qxWw0FOzVoZm4jjv1GssUw1Z48ePGhMAEnin26O0TRuZTXss27yxN3ZH/RLQhfuZIfZxpqrTGw/bOf3tD9j87SLLwTRHGW6fs61QnF8cw53lwvBq5NKj6wxayEQzsU5rmaxyRDRm+hRY2N5s1TQvE8lRD7qJqmE/GuY5R5SJPyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AHSLVOix; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XEmSg1ms; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 523M8Mu0006879;
	Mon, 3 Mar 2025 22:42:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=82sdkqhXyOVrPScCfAc2KsUMnbpndAyxeSIOui19j7U=; b=
	AHSLVOix5gQzXn4h0UV5FsTIQnRq+a94otK7Aa1qxYxswCWr4U5aRQLyEiM3lz+t
	RNXj1DwvVkDvieOH7bLNeRSp9gKmkzbI8pttMKkUfq40bZf1vimBcnfSqFXvr2YK
	QsuwjiGYufSSbDbpP56d10x9zyF4imFjnU7QZtz+WC8XJiNDsf1L/XYZs45yMPy0
	ubFbaBp3lf+e9s3fK8VlwrD3pYtFyEeQMsnNczNL2G0IWYqWub3Rs1oq4wmVZZLG
	xf2Daol5RhWx6zA7EgmwcX/DUOAcEXPnL7KUUybAu4un6oXansGw2coYj3YnTP4W
	NlUdONoqsVQVuwQ2DSbo+A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u9qbu86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 22:42:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 523LoZBx010929;
	Mon, 3 Mar 2025 22:42:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rp9nyna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 22:42:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tP8BV3iGfaPAF83I2F7N/V/avRt/N4/1xhq31p6w92es/8yvgieJ+gQeyLq9Xs6GisGwJvBCtkcSBjz2tf17sovrloDc2uNtMAJ5GwqVJkMIuZ0Hh/kKs1SiNF93v5GUHZVUhBb5aIbyINVRT6d9nTgWNBpYL8lCVQh76pp7ometJbhBhhbuCA0FOnpQIf5n9PWHstqG0nHP/oF4PWNrFu02AIBlfxCniScreCz/ymDkNditF2G04vEkbhQniEsGZQRGKcyQCzAtkAIAXGkOlt/z+Q9FnHKjNVuRz5/VMao2FgRpZ9H9mH8qNk2Iyj4e19VXfIjFyY0Y10ihuT87Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82sdkqhXyOVrPScCfAc2KsUMnbpndAyxeSIOui19j7U=;
 b=oaRrTTsIWSeNA0B+D+tFE3OdF0i/THW02waJcqJOM9VqXSexfR2zQFlluIm/LYJjxdksMj1R/Mo3IcwaOc9P7Xq7S2WB65ep9K6IRC7v9jRcalcGEX/dT5U7C6gjO2aGRkJdHvFNl83ME/4yxf7c2BcH9DzpJW/MpuJCqiTkAtpXTLp74qyGngfk5Nuj34voTCuWo+GkRwIziuntfOwBr9sm+CA5f9j1OvLWfMFlYeGUj3P3XP2JWj85OmGDKJelHpRJd27dzAlqDzo3CREB/P/Ck5jQdAdPC5XnhYu7v4JMNIx5QQKXAnUgEpG5OVnjjoPeennBOsHbj18zOu+cWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82sdkqhXyOVrPScCfAc2KsUMnbpndAyxeSIOui19j7U=;
 b=XEmSg1msQgK7IjZl1sNpQJ4+ieaTwIppdsVgv1m6DH/nL4zD6hgS7QqM6dyT2XlRy/AaFBZ6rzjueK4Uu0L4hw4Ii6kuIWC733+fJV2Wl8y1At68stuYvK3m4fpwmLWyjSX3TYAAkrxLl1OwgZALI1/Sb5CxPn2xqC6y4lwut64=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7256.namprd10.prod.outlook.com (2603:10b6:208:3df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Mon, 3 Mar
 2025 22:42:44 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 22:42:44 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
Thread-Topic: [PATCH v3] xfs: add a test for atomic writes
Thread-Index: AQHbjI2UUf6y3d8dVUG0Qk8cyyy/Dw==
Date: Mon, 3 Mar 2025 22:42:44 +0000
Message-ID: <DABD5AF4-1711-495C-8387-CB628A2B728D@oracle.com>
References: <20250228002059.16750-1-catherine.hoang@oracle.com>
 <20250228021156.GX6242@frogsfrogsfrogs>
 <c95b0a815dc9ccfe6172b589c5d4810147dcc207.camel@gmail.com>
 <20250228154335.GZ6242@frogsfrogsfrogs>
In-Reply-To: <20250228154335.GZ6242@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.200.121)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|IA0PR10MB7256:EE_
x-ms-office365-filtering-correlation-id: 0ee29db6-a957-4c5f-31c2-08dd5aa4b694
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QnBLdzdJYWtMNzJwWEF2Ykl5SGhMTE1LQ3U0bitXclRKOWhSNGtUR2I4Vysv?=
 =?utf-8?B?dnByb0wrTHhMem45RFJYYmdvcWtEWWdNMmd2STRFZEVpMjlJb01Xd2I2RGp0?=
 =?utf-8?B?UDl2cXJ4RFpTVjljbHBoUFYxamYxWDdEbFNQQ29PV2Q5UHJzU2V1LyszakVO?=
 =?utf-8?B?aHhBaVBIejFENGdoUHc3UWR3RFBIekxIRlFPWHc1Ui9ORFZvdlNJQVZybXhO?=
 =?utf-8?B?Y0MvT295MldZREZrR0M5dFB4RlM3OFhLSnlEeGo2UVFGUVdPNDk3SzNuK29L?=
 =?utf-8?B?Nzl6Rndocyt2UWlxQzlEdkIyaFFiL0NnY3ZUSnRTTzViQmlsd3ZXaFdWSHZx?=
 =?utf-8?B?azUzT0wxMzVaT01CQ2xDTytJS0RqU0ZZWUg0czZ5SEVSWkNEdXFXZTZYcjA2?=
 =?utf-8?B?UERxZVBIZEtvZGk2MlJITEl0MDZKYXNRQ1dDak5oMlZXOXdNVUpYUURxZkFV?=
 =?utf-8?B?dUxiQ1ZhSUtjcXRYTlpxSHpFQStDakdGYTN6SS9uZnRXTm5VOVpXZ1daM2JE?=
 =?utf-8?B?MUQyMDJTVGwrQUI5clhtQWtvTXZyaVVjUVBMRVhNejVBOEI3OXZxY20xbVdD?=
 =?utf-8?B?TWZ4U00yNFovSHBUYk5XeHBRSHVWN2NhaW5pRHlrRFNtQUhxRURLenl1aWdL?=
 =?utf-8?B?RVo2MXFKMHJiYjYxMXJpWms0YjQyTWRKRm5wblVGdkRUekF0WmpTaTIvcnFV?=
 =?utf-8?B?OXZkaTBHb05YTmpDWmxCRTk2SkhhZno5OTlZMFRnVTlKZ3c2aXl0cTIyU2hz?=
 =?utf-8?B?SkIrbzc5TE5DSFdTM2ozNUNnemV5dkNCOXd4TVh3Yml1REFTUElMSXZTa0tU?=
 =?utf-8?B?TGNPVll3VHNmcnBEdEppRk1ibEF2QWJZTDVoTHJMWGYwZlk1eVJXdE15QjZW?=
 =?utf-8?B?NElKa24rRnpCai9XZ2JqR21UcHRqdTEyZ1Z4Y1ZFNmtlSGNvbFduNXExM1Fo?=
 =?utf-8?B?MFJxelBkamJ3cmQ4aWF2RFhDRS9CcTBPejJSVVlFRHA1OUJucVZnbXhTRTc3?=
 =?utf-8?B?OVdGT3h5SmpGb0c2NWowbVJTSmZ3VUNDNjFVcCtnWXNLbnZ3SGJjc0FWSlZP?=
 =?utf-8?B?MUpMOHp0NmpiN3hvL2ZFM1ZwdFQzT0hLVGJ1NWxoeml6VlA4OCtHNndLZXJZ?=
 =?utf-8?B?QkNydENmWU14Mk9ybm5HNWRSYS9xNWxtOUdSck9EaStVZVBmZWdPcWEzNUNy?=
 =?utf-8?B?d3lnL1E0bnJ4dUs0eWo4d2IyTXlGQXJxTmx3WUtEcVVQV3IwRFZDR2dIY1F6?=
 =?utf-8?B?aktDRStPckx0MGNHSit5V1lpQTBNS0VQemhFWUpBcXBnMjVRK2JIUVZlb0ZL?=
 =?utf-8?B?dUZTbzloU1pCSHhuZ1AzajY5WDVnTmZ4TDVFODlBUDZxV0R6ZWdOUExqYVlx?=
 =?utf-8?B?bFVmaUxGWk5HUGJLOHNCY1ZuSUxibXNRNUJNMllIbkpDNEQxS1ZrOG1RZkpF?=
 =?utf-8?B?b1REOXRnUytTVlJGbWVWRG9ITDR3Y0lJSldkWC84aXpQODV2V2dPZVlnNDF6?=
 =?utf-8?B?WGRISUE5LzhJWEc4NDJTb09UbDZJWGdzUDRTb2ZMQXptNzRGcFI0OU1QeUpu?=
 =?utf-8?B?VitnTjBXMEJCV283aWNuQWhvZWxPTWxINnR0TFlZQlpkNEJ0bThHNi9TMmFu?=
 =?utf-8?B?L1hGTDVRV01lV1o2anVkMVZwN0RsemFzRElPM2l3UHgzWWxyQ3k0aW9zYy81?=
 =?utf-8?B?UFFGNnErN25RUzFuVE5oUERweXJlOXVUSnNTT0NUTkFVUXcyODhaakx0eSs4?=
 =?utf-8?B?a1h5T3NNRGU2ODNrSTRFSTVxSlZEcFhqMkJONXIyU0pzU0tWbGZIZlIvWmZF?=
 =?utf-8?B?M21lY3QwN1dwR1ExbzRlQUpBUWNJVFFoRnBtWnBBTkZRTjJuYTNkbGlFclRw?=
 =?utf-8?B?ZmZEUzBMdjU3aGtmQlh2Rm9oZzJiVzR4ZHNIbHdXcDhyZDhYaGtuS2FtQ2VS?=
 =?utf-8?Q?lJzNiuPzUmPvdL+wxNsqFQ2n+mXMhNUl?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?emh5QTg3Y2RQY1RHY1RZcVJlUXRDRjh3cHZ1UEJUeUlRNWJJNDdxanhlbE9X?=
 =?utf-8?B?OXZRTUtYb1Y0SDJmUmoxMy9GcnNsV0wyOTkwQTVXK29kSlJjbjFRZ1BvdGk4?=
 =?utf-8?B?VVpEUDk4QnJJdURickpPanZFelVPVGx3eDJVcEdzY2hjV3NDdkhjS0tySXhQ?=
 =?utf-8?B?blgvYmZiY3FPTWlGdVh1UkJ6RWZselRDWnJVY2pwYTJEQis1dFNYc0VwSWRE?=
 =?utf-8?B?d1JHV2MzN3J4SkJNeHUwT3JnMlFGVU5ZZXc5aWg0bnJmNk5PZWs5YWFRajhJ?=
 =?utf-8?B?dEpxWmZGZm5nSlROb1hwZHlFd2tPZ0s4NURlb05EZEpjYUJuWWFGcldzRklO?=
 =?utf-8?B?RHRtSVBlM1Y2YjZFOW1Db1FtbCt0R3VCT2xKUy9vL2pudk83aWM4WFB1V0di?=
 =?utf-8?B?MC8vL2hqUzh4Z0JtS3BSdXIrNFFhU0hZQTdlYjA4aXJsVWQyOGNkdlJGSVFx?=
 =?utf-8?B?RlhIUmk1SFZNdi9mSzV1cUhYaElxV2JySFAzbmVDODBkL1RSdDd3VW54eHRR?=
 =?utf-8?B?b2lyd3daaGloa1piKzlVejljcW5pYWxBSkNsT1BoNXdQSVNRR0U1WHJxYThE?=
 =?utf-8?B?aWZUdUxpYXRuZm1hanRsSzJXazI0TzZSbkpWMnVaQUtsQ1htZkEzaGRqYjl1?=
 =?utf-8?B?N0lTSFpMdWFyTGx5N1Q0dXJRT1BGR3lia1AzUGJtOG9iUE4vdWYwNkg4Z2pm?=
 =?utf-8?B?OVRnNm44M3BGK0hMdXdBb1Awem1NdzBOOFBOSjJudWcvc3JGKzdHZy9EK1Yy?=
 =?utf-8?B?V3l6aENFZmgybW03bHJVUDh4d2ZsTWJjYXp4RTB0U0lINjZIZWltY3VxRU1R?=
 =?utf-8?B?M01McHM4VUUvSXRXRWc3N1A4TXBoWDRQbVMrOVBzR0R3U290V3NOZ0lNMXJv?=
 =?utf-8?B?OWw5b3FveWtPVUkzd0I2Nnl1VWwwUUsyM1ZTay9ZdVc0bGh0MFc0aG8zZ3ZO?=
 =?utf-8?B?UTRFL2grSEk2M0tCNDBrd3A2dUFEN1I5MmY5dlhvOEVlWVNRcWs3ZDNnWjE2?=
 =?utf-8?B?VnVzSHlOODRDdW1uQkNkc1FiVWErVnQvVGg3T3NkQWVJd3hYcGdySE1aM2Mz?=
 =?utf-8?B?VVMwV21nV3hBcmcyNzJtcEprZ3BoYnFsMUYvL3VnaklmeGNaTkJiSDNOeXJp?=
 =?utf-8?B?OTQ3ZGV2WDl5bEFJVFFWRjNHUnRFZlBSMXg4ZTU4L3ZVM3FtNnZQSVQ1OFhv?=
 =?utf-8?B?TlJ6azVzOHY3U2FiKzNPbkVOalE0dllrN3hvZUpQK21Pdm54SUdSL1FYb2VN?=
 =?utf-8?B?bEc1Q2hlYTZqWXFwSGhOaXBnUVI1Y1Jkbzh5TFVqVXR5OXJEREtlZnh5Nmw5?=
 =?utf-8?B?Rk92MU55WnVKbkFieEM1ZXBQU3JHZ24rcUZ0VlJLNXIrbkNYNWZycUdFZVJQ?=
 =?utf-8?B?NXluR2RUVGdmb0RzSmNtdWQ4Z01LWDZoVmZqWFUzT0trNTcwbHV5VGw5eCtP?=
 =?utf-8?B?RVNQK3hoTUUxamRDSlQ2S3BVMFdSUFpzdm5VZklzcWdFbzdKclFENll5T2g4?=
 =?utf-8?B?bkFIakpyUXl6cE1BYWpBZWlIcEErN2g4a3d1Zk84ZDRxVWUzZzlmK3U1MXZu?=
 =?utf-8?B?QVJSQU8wWmMvdHpkMEZrTUlJd2VseGcwOHFEZmE3SzA3NVRwSnkwbVdlQjVm?=
 =?utf-8?B?OGdySVJVRUZuWXdNTnJMYU5CQ0JORDZJdW9oR0dxbzFOVzBmc1c5U3VpSFJ2?=
 =?utf-8?B?bzc1dy9QVlk3cVRQK1NJaU1EMHZlZ2lFSlR2OTBWOVI2ak5aSnQ3WUlGL3ZR?=
 =?utf-8?B?bjA2UlBxTHlPMFI1VnZxRzJ6elFyb3NDazBISis3bklDZ1dtS3VNalAyZjZk?=
 =?utf-8?B?ejQzL2ZCSGg0VnRCOUR0UXg2eDZ4KzMyUEtVV3RZY0tRclo4ZzlSOTJsR0lH?=
 =?utf-8?B?VmFabnFaYW0zUEZaRzFpN1RodHdxQ0JHZlJidXBiTEtaUTdjYjExZG0xd28y?=
 =?utf-8?B?VHFlaEtuTU9PRzJKd0ZlVTdTbE5TdVh0TDJseGZjd0FBNVljN01NenJnMVow?=
 =?utf-8?B?TUxvNS9YY3BsR0hWT2Rkay9GVXY4c24xOTBFcXpaSjNHR1JESTVuODJ3YjFH?=
 =?utf-8?B?MHhWenFldU9HQ1dZMjlmTU9VMVdFU0sxOThGeFl2ZFljSUowSWVLZWhtWlhJ?=
 =?utf-8?B?ZmY2enFvbGppRVBNMklySkdYaEowbnBNMlNiN2J4WmtHK3lSenNNWEU5Vm0r?=
 =?utf-8?B?dXdCSXMrdGFaQ0w2MTdoZnErN1RtbDFMaVg2Z0xxMzJnWWVZcm9mbUFCOE5i?=
 =?utf-8?B?SGhFZlRTa29sZjlPVlNMUlAzaEhnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A30A373DA8261418EE8931EE5930F77@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s3aBq/xs+QqPRj8Xoh/2zK2fnmKVYmXW/WKiOxmreCi4RPFjid7l79mqYN4gbchNbo/lCtwgf9CluyhyR2Iqi6lqrlUdGRBM2IWnpTm2IlAs6VJxxDGrKc8gcbIRqhwDRDB21hUaQkIyv7ycaZjHdSwXFmgXh38E6GzOUxo0Q5hDhCb5LQV5LpvUV7mjOScDy+xXHr//8sbCWn18fvPKdZxxR7K8gPu37dhFfSt0V6UIPXDMPs+TfXC75QUyVhOUzgJJjBQT8tiXqkr4VkviExIvd7F9U5lsFpmRmAq6+3DOFCAuaz9WNo8Zz72uJw2ay/dEIOg5sZysW3PA+YqUQ4kV+k9RzgL+CEVPNVU7oMORg7LxCRsrLWxO7olz6Sr8d1rFN7qpYyt1wFvVrMJgE+9uS1iC3GtSswUq67jZXcVKdMEvyxrA/wdEGkxUnvrW+yMyXz03Ta9sH0JiPIfBa00GA8ZVbqJcjNxeB2yiZbbLfLRkae/lDDJUZ1MaA6RpmjdZIQKKQjRk3UAQgOKT2gDSjnUwbTkPGoRky5Exai3B5bmufavEwm/h3+vSuH1wo46nDC/NCZx5PWrgFFL5BMoxfZlBBSS5jXUx+u8Ro10=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee29db6-a957-4c5f-31c2-08dd5aa4b694
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2025 22:42:44.0664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qTh7mKwFmjtMWrgas2tMflFfTT7vH6Vt30qKYRYxDvaeJ+uvimnkc/lDEJCm3SU4G6Ry28TgO/cGfM3t00sd8yu+OZ4T8cxrklmIBXgVdFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7256
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-03_11,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503030176
X-Proofpoint-ORIG-GUID: SwaMo6NWLRAQqmKZe2uOk-j_4CjQRjMS
X-Proofpoint-GUID: SwaMo6NWLRAQqmKZe2uOk-j_4CjQRjMS

DQoNCj4gT24gRmViIDI4LCAyMDI1LCBhdCA3OjQz4oCvQU0sIERhcnJpY2sgSi4gV29uZyA8ZGp3
b25nQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBGZWIgMjgsIDIwMjUgYXQgMDc6
MDE6NTBQTSArMDUzMCwgTmlyamhhciBSb3kgKElCTSkgd3JvdGU6DQo+PiBPbiBUaHUsIDIwMjUt
MDItMjcgYXQgMTg6MTEgLTA4MDAsIERhcnJpY2sgSi4gV29uZyB3cm90ZToNCj4+PiBPbiBUaHUs
IEZlYiAyNywgMjAyNSBhdCAwNDoyMDo1OVBNIC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
DQo+Pj4+IEFkZCBhIHRlc3QgdG8gdmFsaWRhdGUgdGhlIG5ldyBhdG9taWMgd3JpdGVzIGZlYXR1
cmUuDQo+Pj4+IA0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBDYXRoZXJpbmUgSG9hbmcgPGNhdGhlcmlu
ZS5ob2FuZ0BvcmFjbGUuY29tPg0KPj4+PiBSZXZpZXdlZC1ieTogTmlyamhhciBSb3kgKElCTSkg
PG5pcmpoYXIucm95Lmxpc3RzQGdtYWlsLmNvbT4NCj4+PiANCj4+PiBFci4uLi4gd2hhdCBnaXQg
dHJlZSBpcyB0aGlzIGJhc2VkIHVwb24/ICBnZW5lcmljLzc2MiBpcyBhIHByb2plY3QNCj4+PiBx
dW90YQ0KPj4+IHRlc3QuDQo+PiBPbiB3aGljaCBicmFuY2ggZG8geW91IGhhdmUgdGVzdHMvZ2Vu
ZXJpYy83NjI/IEkgY2hlY2tlZCB0aGUgbGF0ZXN0DQo+PiBtYXN0ZXIoY29tbWl0IC0gODQ2NzU1
MmYwOWUxNjcyYTAyNzEyNjUzYjUzMmE4NGJkNDZlYTEwZSkgYW5kIHRoZSBmb3ItDQo+PiBuZXh0
KGNvbW1pdCAtIDViNTZhMmQ4ODgxOTFiZmM3MTMxYjA5NmU2MTFlYWIxODgxZDg0MjIpIGFuZCBp
dCBkb2Vzbid0DQo+PiBzZWVtIHRvIGV4aXN0IHRoZXJlLiBIb3dldmVyLCB0ZXN0cy94ZnMvNzYy
IGRvZXMgZXhpc3QuDQo+IA0KPiBab3JybydzIHBhdGNoZXMtaW4tcXVldWUsIGFrYSB3aGF0ZXZl
ciBnZXRzIHB1c2hlZCB0byBmb3ItbmV4dCBvbg0KPiBTdW5kYXkuICANCg0KVGhpcyB0ZXN0IHdh
cyBiYXNlZCBvbiBmb3ItbmV4dCwgSSB3YXNu4oCZdCBhd2FyZSB0aGVyZSB3YXMgYW5vdGhlcg0K
YnJhbmNoLiBJIHdpbGwgcmViYXNlIHRoaXMgb250byBwYXRjaGVzLWluLXF1ZXVlLg0KPiBNeSBj
b25mdXNpb24gc3RlbXMgZnJvbSB0aGlzIHBhdGNoIG1vZGlmeWluZyB3aGF0IGxvb2tzIGxpa2Ug
YW4NCj4gZXhpc3RpbmcgYXRvbWljIHdyaXRlcyB0ZXN0LCBidXQgZ2VuZXJpYy83NjIgaXNuJ3Qg
dGhhdCB0ZXN0IHNvIG5vdyBJDQo+IGNhbid0IHNlZSBldmVyeXRoaW5nIHRoYXQgdGhpcyB0ZXN0
IGlzIGV4YW1pbmluZy4NCg0KSSBkb27igJl0IHRoaW5rIHRoZSBhdG9taWMgd3JpdGVzIHRlc3Qg
d2FzIGV2ZXIgbWVyZ2VkLCB1bmxlc3MgSSBtaXNzZWQgaXQ/DQo+IA0KPiAoSSBzdWdnZXN0IGV2
ZXJ5b25lIHBsZWFzZSBwb3N0IHVybHMgdG8gcHVibGljIGdpdCByZXBvcyBzbyByZXZpZXdlcnMN
Cj4gY2FuIGdldCBhcm91bmQgdGhlc2Ugc29ydHMgb2YgaXNzdWVzIGluIHRoZSBmdXR1cmUuKQ0K
PiANCj4gLS1EDQo+IA0KPj4gLS1OUg0KPj4+IA0KPj4+IC0tRA0KPj4+IA0KPj4+PiAtLS0NCj4+
Pj4gY29tbW9uL3JjICAgICAgICAgICAgIHwgIDUxICsrKysrKysrKysrKysrDQo+Pj4+IHRlc3Rz
L2dlbmVyaWMvNzYyICAgICB8IDE2MA0KPj4+PiArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4+Pj4gdGVzdHMvZ2VuZXJpYy83NjIub3V0IHwgICAyICsNCj4+Pj4g
MyBmaWxlcyBjaGFuZ2VkLCAyMTMgaW5zZXJ0aW9ucygrKQ0KPj4+PiBjcmVhdGUgbW9kZSAxMDA3
NTUgdGVzdHMvZ2VuZXJpYy83NjINCj4+Pj4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRlc3RzL2dlbmVy
aWMvNzYyLm91dA0KPj4+PiANCj4+Pj4gZGlmZiAtLWdpdCBhL2NvbW1vbi9yYyBiL2NvbW1vbi9y
Yw0KPj4+PiBpbmRleCA2NTkyYzgzNS4uMDhhOWQ5YjggMTAwNjQ0DQo+Pj4+IC0tLSBhL2NvbW1v
bi9yYw0KPj4+PiArKysgYi9jb21tb24vcmMNCj4+Pj4gQEAgLTI4MzcsNiArMjgzNywxMCBAQCBf
cmVxdWlyZV94ZnNfaW9fY29tbWFuZCgpDQo+Pj4+IG9wdHMrPSIgLWQiDQo+Pj4+IHB3cml0ZV9v
cHRzKz0iLVYgMSAtYiA0ayINCj4+Pj4gZmkNCj4+Pj4gKyBpZiBbICIkcGFyYW0iID09ICItQSIg
XTsgdGhlbg0KPj4+PiArIG9wdHMrPSIgLWQiDQo+Pj4+ICsgcHdyaXRlX29wdHMrPSItRCAtViAx
IC1iIDRrIg0KPj4+PiArIGZpDQo+Pj4+IHRlc3Rpbz1gJFhGU19JT19QUk9HIC1mICRvcHRzIC1j
IFwNCj4+Pj4gICAgICAgICJwd3JpdGUgJHB3cml0ZV9vcHRzICRwYXJhbSAwIDRrIiAkdGVzdGZp
bGUNCj4+Pj4gMj4mMWANCj4+Pj4gcGFyYW1fY2hlY2tlZD0iJHB3cml0ZV9vcHRzICRwYXJhbSIN
Cj4+Pj4gQEAgLTUxNzUsNiArNTE3OSw1MyBAQCBfcmVxdWlyZV9zY3JhdGNoX2J0aW1lKCkNCj4+
Pj4gX3NjcmF0Y2hfdW5tb3VudA0KPj4+PiB9DQo+Pj4+IA0KPj4+PiArX2dldF9hdG9taWNfd3Jp
dGVfdW5pdF9taW4oKQ0KPj4+PiArew0KPj4+PiArICRYRlNfSU9fUFJPRyAtYyAic3RhdHggLXIg
LW0gJFNUQVRYX1dSSVRFX0FUT01JQyIgJDEgfCBcDQo+Pj4+ICsgICAgICAgIGdyZXAgYXRvbWlj
X3dyaXRlX3VuaXRfbWluIHwgZ3JlcCAtbyAnWzAtOV1cKycNCj4+Pj4gK30NCj4+Pj4gKw0KPj4+
PiArX2dldF9hdG9taWNfd3JpdGVfdW5pdF9tYXgoKQ0KPj4+PiArew0KPj4+PiArICRYRlNfSU9f
UFJPRyAtYyAic3RhdHggLXIgLW0gJFNUQVRYX1dSSVRFX0FUT01JQyIgJDEgfCBcDQo+Pj4+ICsg
ICAgICAgIGdyZXAgYXRvbWljX3dyaXRlX3VuaXRfbWF4IHwgZ3JlcCAtbyAnWzAtOV1cKycNCj4+
Pj4gK30NCj4+Pj4gKw0KPj4+PiArX2dldF9hdG9taWNfd3JpdGVfc2VnbWVudHNfbWF4KCkNCj4+
Pj4gK3sNCj4+Pj4gKyAkWEZTX0lPX1BST0cgLWMgInN0YXR4IC1yIC1tICRTVEFUWF9XUklURV9B
VE9NSUMiICQxIHwgXA0KPj4+PiArICAgICAgICBncmVwIGF0b21pY193cml0ZV9zZWdtZW50c19t
YXggfCBncmVwIC1vICdbMC05XVwrJw0KPj4+PiArfQ0KPj4+PiArDQo+Pj4+ICtfcmVxdWlyZV9z
Y3JhdGNoX3dyaXRlX2F0b21pYygpDQo+Pj4+ICt7DQo+Pj4+ICsgX3JlcXVpcmVfc2NyYXRjaA0K
Pj4+PiArDQo+Pj4+ICsgZXhwb3J0IFNUQVRYX1dSSVRFX0FUT01JQz0weDEwMDAwDQo+Pj4+ICsN
Cj4+Pj4gKyBhd3VfbWluX2JkZXY9JChfZ2V0X2F0b21pY193cml0ZV91bml0X21pbiAkU0NSQVRD
SF9ERVYpDQo+Pj4+ICsgYXd1X21heF9iZGV2PSQoX2dldF9hdG9taWNfd3JpdGVfdW5pdF9tYXgg
JFNDUkFUQ0hfREVWKQ0KPj4+PiArDQo+Pj4+ICsgaWYgWyAkYXd1X21pbl9iZGV2IC1lcSAwIF0g
JiYgWyAkYXd1X21heF9iZGV2IC1lcSAwIF07IHRoZW4NCj4+Pj4gKyBfbm90cnVuICJ3cml0ZSBh
dG9taWMgbm90IHN1cHBvcnRlZCBieSB0aGlzIGJsb2NrDQo+Pj4+IGRldmljZSINCj4+Pj4gKyBm
aQ0KPj4+PiArDQo+Pj4+ICsgX3NjcmF0Y2hfbWtmcyA+IC9kZXYvbnVsbCAyPiYxDQo+Pj4+ICsg
X3NjcmF0Y2hfbW91bnQNCj4+Pj4gKw0KPj4+PiArIHRlc3RmaWxlPSRTQ1JBVENIX01OVC90ZXN0
ZmlsZQ0KPj4+PiArIHRvdWNoICR0ZXN0ZmlsZQ0KPj4+PiArDQo+Pj4+ICsgYXd1X21pbl9mcz0k
KF9nZXRfYXRvbWljX3dyaXRlX3VuaXRfbWluICR0ZXN0ZmlsZSkNCj4+Pj4gKyBhd3VfbWF4X2Zz
PSQoX2dldF9hdG9taWNfd3JpdGVfdW5pdF9tYXggJHRlc3RmaWxlKQ0KPj4+PiArDQo+Pj4+ICsg
X3NjcmF0Y2hfdW5tb3VudA0KPj4+PiArDQo+Pj4+ICsgaWYgWyAkYXd1X21pbl9mcyAtZXEgMCBd
ICYmIFsgJGF3dV9tYXhfZnMgLWVxIDAgXTsgdGhlbg0KPj4+PiArIF9ub3RydW4gIndyaXRlIGF0
b21pYyBub3Qgc3VwcG9ydGVkIGJ5IHRoaXMgZmlsZXN5c3RlbSINCj4+Pj4gKyBmaQ0KPj4+PiAr
fQ0KPj4+PiArDQo+Pj4+IF9yZXF1aXJlX2lub2RlX2xpbWl0cygpDQo+Pj4+IHsNCj4+Pj4gaWYg
WyAkKF9nZXRfZnJlZV9pbm9kZSAkVEVTVF9ESVIpIC1lcSAwIF07IHRoZW4NCj4+Pj4gZGlmZiAt
LWdpdCBhL3Rlc3RzL2dlbmVyaWMvNzYyIGIvdGVzdHMvZ2VuZXJpYy83NjINCj4+Pj4gbmV3IGZp
bGUgbW9kZSAxMDA3NTUNCj4+Pj4gaW5kZXggMDAwMDAwMDAuLmQwYTgwMjE5DQo+Pj4+IC0tLSAv
ZGV2L251bGwNCj4+Pj4gKysrIGIvdGVzdHMvZ2VuZXJpYy83NjINCj4+Pj4gQEAgLTAsMCArMSwx
NjAgQEANCj4+Pj4gKyMhIC9iaW4vYmFzaA0KPj4+PiArIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmll
cjogR1BMLTIuMA0KPj4+PiArIyBDb3B5cmlnaHQgKGMpIDIwMjUgT3JhY2xlLiAgQWxsIFJpZ2h0
cyBSZXNlcnZlZC4NCj4+Pj4gKyMNCj4+Pj4gKyMgRlMgUUEgVGVzdCA3NjINCj4+Pj4gKyMNCj4+
Pj4gKyMgVmFsaWRhdGUgYXRvbWljIHdyaXRlIHN1cHBvcnQNCj4+Pj4gKyMNCj4+Pj4gKy4gLi9j
b21tb24vcHJlYW1ibGUNCj4+Pj4gK19iZWdpbl9mc3Rlc3QgYXV0byBxdWljayBydw0KPj4+PiAr
DQo+Pj4+ICtfcmVxdWlyZV9zY3JhdGNoX3dyaXRlX2F0b21pYw0KPj4+PiArX3JlcXVpcmVfeGZz
X2lvX2NvbW1hbmQgcHdyaXRlIC1BDQo+Pj4+ICsNCj4+Pj4gK3Rlc3RfYXRvbWljX3dyaXRlcygp
DQo+Pj4+ICt7DQo+Pj4+ICsgICAgbG9jYWwgYnNpemU9JDENCj4+Pj4gKw0KPj4+PiArICAgIGNh
c2UgIiRGU1RZUCIgaW4NCj4+Pj4gKyAgICAieGZzIikNCj4+Pj4gKyAgICAgICAgbWtmc19vcHRz
PSItYiBzaXplPSRic2l6ZSINCj4+Pj4gKyAgICAgICAgOzsNCj4+Pj4gKyAgICAiZXh0NCIpDQo+
Pj4+ICsgICAgICAgIG1rZnNfb3B0cz0iLWIgJGJzaXplIg0KPj4+PiArICAgICAgICA7Ow0KPj4+
PiArICAgICopDQo+Pj4+ICsgICAgICAgIDs7DQo+Pj4+ICsgICAgZXNhYw0KPj4+PiArDQo+Pj4+
ICsgICAgIyBJZiBibG9jayBzaXplIGlzIG5vdCBzdXBwb3J0ZWQsIHNraXAgdGhpcyB0ZXN0DQo+
Pj4+ICsgICAgX3NjcmF0Y2hfbWtmcyAkbWtmc19vcHRzID4+JHNlcXJlcy5mdWxsIDI+JjEgfHwg
cmV0dXJuDQo+Pj4+ICsgICAgX3RyeV9zY3JhdGNoX21vdW50ID4+JHNlcXJlcy5mdWxsIDI+JjEg
fHwgcmV0dXJuDQo+Pj4+ICsNCj4+Pj4gKyAgICB0ZXN0ICIkRlNUWVAiID0gInhmcyIgJiYgX3hm
c19mb3JjZV9iZGV2IGRhdGEgJFNDUkFUQ0hfTU5UDQo+Pj4+ICsNCj4+Pj4gKyAgICB0ZXN0Zmls
ZT0kU0NSQVRDSF9NTlQvdGVzdGZpbGUNCj4+Pj4gKyAgICB0b3VjaCAkdGVzdGZpbGUNCj4+Pj4g
Kw0KPj4+PiArICAgIGZpbGVfbWluX3dyaXRlPSQoX2dldF9hdG9taWNfd3JpdGVfdW5pdF9taW4g
JHRlc3RmaWxlKQ0KPj4+PiArICAgIGZpbGVfbWF4X3dyaXRlPSQoX2dldF9hdG9taWNfd3JpdGVf
dW5pdF9tYXggJHRlc3RmaWxlKQ0KPj4+PiArICAgIGZpbGVfbWF4X3NlZ21lbnRzPSQoX2dldF9h
dG9taWNfd3JpdGVfc2VnbWVudHNfbWF4ICR0ZXN0ZmlsZSkNCj4+Pj4gKw0KPj4+PiArICAgICMg
Q2hlY2sgdGhhdCBhdG9taWMgbWluL21heCA9IEZTIGJsb2NrIHNpemUNCj4+Pj4gKyAgICB0ZXN0
ICRmaWxlX21pbl93cml0ZSAtZXEgJGJzaXplIHx8IFwNCj4+Pj4gKyAgICAgICAgZWNobyAiYXRv
bWljIHdyaXRlIG1pbiAkZmlsZV9taW5fd3JpdGUsIHNob3VsZCBiZSBmcyBibG9jaw0KPj4+PiBz
aXplICRic2l6ZSINCj4+Pj4gKyAgICB0ZXN0ICRmaWxlX21pbl93cml0ZSAtZXEgJGJzaXplIHx8
IFwNCj4+Pj4gKyAgICAgICAgZWNobyAiYXRvbWljIHdyaXRlIG1heCAkZmlsZV9tYXhfd3JpdGUs
IHNob3VsZCBiZSBmcyBibG9jaw0KPj4+PiBzaXplICRic2l6ZSINCj4+Pj4gKyAgICB0ZXN0ICRm
aWxlX21heF9zZWdtZW50cyAtZXEgMSB8fCBcDQo+Pj4+ICsgICAgICAgIGVjaG8gImF0b21pYyB3
cml0ZSBtYXggc2VnbWVudHMgJGZpbGVfbWF4X3NlZ21lbnRzLCBzaG91bGQNCj4+Pj4gYmUgMSIN
Cj4+Pj4gKw0KPj4+PiArICAgICMgQ2hlY2sgdGhhdCB3ZSBjYW4gcGVyZm9ybSBhbiBhdG9taWMg
d3JpdGUgb2YgbGVuID0gRlMgYmxvY2sNCj4+Pj4gc2l6ZQ0KPj4+PiArICAgIGJ5dGVzX3dyaXR0
ZW49JCgkWEZTX0lPX1BST0cgLWRjICJwd3JpdGUgLUEgLUQgLVYxIC1iICRic2l6ZSAwDQo+Pj4+
ICRic2l6ZSIgJHRlc3RmaWxlIHwgXA0KPj4+PiArICAgICAgICBncmVwIHdyb3RlIHwgYXdrIC1G
J1svIF0nICd7cHJpbnQgJDJ9JykNCj4+Pj4gKyAgICB0ZXN0ICRieXRlc193cml0dGVuIC1lcSAk
YnNpemUgfHwgZWNobyAiYXRvbWljIHdyaXRlDQo+Pj4+IGxlbj0kYnNpemUgZmFpbGVkIg0KPj4+
PiArDQo+Pj4+ICsgICAgIyBDaGVjayB0aGF0IHdlIGNhbiBwZXJmb3JtIGFuIGF0b21pYyBzaW5n
bGUtYmxvY2sgY293IHdyaXRlDQo+Pj4+ICsgICAgaWYgWyAiJEZTVFlQIiA9PSAieGZzIiBdOyB0
aGVuDQo+Pj4+ICsgICAgICAgIHRlc3RmaWxlX2NwPSRTQ1JBVENIX01OVC90ZXN0ZmlsZV9jb3B5
DQo+Pj4+ICsgICAgICAgIGlmIF94ZnNfaGFzX2ZlYXR1cmUgJFNDUkFUQ0hfTU5UIHJlZmxpbms7
IHRoZW4NCj4+Pj4gKyAgICAgICAgICAgIGNwIC0tcmVmbGluayAkdGVzdGZpbGUgJHRlc3RmaWxl
X2NwDQo+Pj4+ICsgICAgICAgIGZpDQo+Pj4+ICsgICAgICAgIGJ5dGVzX3dyaXR0ZW49JCgkWEZT
X0lPX1BST0cgLWRjICJwd3JpdGUgLUEgLUQgLVYxIC1iDQo+Pj4+ICRic2l6ZSAwICRic2l6ZSIg
JHRlc3RmaWxlX2NwIHwgXA0KPj4+PiArICAgICAgICAgICAgZ3JlcCB3cm90ZSB8IGF3ayAtRidb
LyBdJyAne3ByaW50ICQyfScpDQo+Pj4+ICsgICAgICAgIHRlc3QgJGJ5dGVzX3dyaXR0ZW4gLWVx
ICRic2l6ZSB8fCBlY2hvICJhdG9taWMgd3JpdGUgb24NCj4+Pj4gcmVmbGlua2VkIGZpbGUgZmFp
bGVkIg0KPj4+PiArICAgIGZpDQo+Pj4+ICsNCj4+Pj4gKyAgICAjIENoZWNrIHRoYXQgd2UgY2Fu
IHBlcmZvcm0gYW4gYXRvbWljIHdyaXRlIG9uIGFuIHVud3JpdHRlbg0KPj4+PiBibG9jaw0KPj4+
PiArICAgICRYRlNfSU9fUFJPRyAtYyAiZmFsbG9jICRic2l6ZSAkYnNpemUiICR0ZXN0ZmlsZQ0K
Pj4+PiArICAgIGJ5dGVzX3dyaXR0ZW49JCgkWEZTX0lPX1BST0cgLWRjICJwd3JpdGUgLUEgLUQg
LVYxIC1iICRic2l6ZQ0KPj4+PiAkYnNpemUgJGJzaXplIiAkdGVzdGZpbGUgfCBcDQo+Pj4+ICsg
ICAgICAgIGdyZXAgd3JvdGUgfCBhd2sgLUYnWy8gXScgJ3twcmludCAkMn0nKQ0KPj4+PiArICAg
IHRlc3QgJGJ5dGVzX3dyaXR0ZW4gLWVxICRic2l6ZSB8fCBlY2hvICJhdG9taWMgd3JpdGUgdG8N
Cj4+Pj4gdW53cml0dGVuIGJsb2NrIGZhaWxlZCINCj4+Pj4gKw0KPj4+PiArICAgICMgQ2hlY2sg
dGhhdCB3ZSBjYW4gcGVyZm9ybSBhbiBhdG9taWMgd3JpdGUgb24gYSBzcGFyc2UgaG9sZQ0KPj4+
PiArICAgICRYRlNfSU9fUFJPRyAtYyAiZnB1bmNoIDAgJGJzaXplIiAkdGVzdGZpbGUNCj4+Pj4g
KyAgICBieXRlc193cml0dGVuPSQoJFhGU19JT19QUk9HIC1kYyAicHdyaXRlIC1BIC1EIC1WMSAt
YiAkYnNpemUgMA0KPj4+PiAkYnNpemUiICR0ZXN0ZmlsZSB8IFwNCj4+Pj4gKyAgICAgICAgZ3Jl
cCB3cm90ZSB8IGF3ayAtRidbLyBdJyAne3ByaW50ICQyfScpDQo+Pj4+ICsgICAgdGVzdCAkYnl0
ZXNfd3JpdHRlbiAtZXEgJGJzaXplIHx8IGVjaG8gImF0b21pYyB3cml0ZSB0byBzcGFyc2UNCj4+
Pj4gaG9sZSBmYWlsZWQiDQo+Pj4+ICsNCj4+Pj4gKyAgICAjIENoZWNrIHRoYXQgd2UgY2FuIHBl
cmZvcm0gYW4gYXRvbWljIHdyaXRlIG9uIGEgZnVsbHkgbWFwcGVkDQo+Pj4+IGJsb2NrDQo+Pj4+
ICsgICAgYnl0ZXNfd3JpdHRlbj0kKCRYRlNfSU9fUFJPRyAtZGMgInB3cml0ZSAtQSAtRCAtVjEg
LWIgJGJzaXplIDANCj4+Pj4gJGJzaXplIiAkdGVzdGZpbGUgfCBcDQo+Pj4+ICsgICAgICAgIGdy
ZXAgd3JvdGUgfCBhd2sgLUYnWy8gXScgJ3twcmludCAkMn0nKQ0KPj4+PiArICAgIHRlc3QgJGJ5
dGVzX3dyaXR0ZW4gLWVxICRic2l6ZSB8fCBlY2hvICJhdG9taWMgd3JpdGUgdG8gbWFwcGVkDQo+
Pj4+IGJsb2NrIGZhaWxlZCINCj4+Pj4gKw0KPj4+PiArICAgICMgUmVqZWN0IGF0b21pYyB3cml0
ZSBpZiBsZW4gaXMgb3V0IG9mIGJvdW5kcw0KPj4+PiArICAgICRYRlNfSU9fUFJPRyAtZGMgInB3
cml0ZSAtQSAtRCAtVjEgLWIgJGJzaXplIDAgJCgoYnNpemUgLSAxKSkiDQo+Pj4+ICR0ZXN0Zmls
ZSAyPj4gJHNlcXJlcy5mdWxsICYmIFwNCj4+Pj4gKyAgICAgICAgZWNobyAiYXRvbWljIHdyaXRl
IGxlbj0kKChic2l6ZSAtIDEpKSBzaG91bGQgZmFpbCINCj4+Pj4gKyAgICAkWEZTX0lPX1BST0cg
LWRjICJwd3JpdGUgLUEgLUQgLVYxIC1iICRic2l6ZSAwICQoKGJzaXplICsgMSkpIg0KPj4+PiAk
dGVzdGZpbGUgMj4+ICRzZXFyZXMuZnVsbCAmJiBcDQo+Pj4+ICsgICAgICAgIGVjaG8gImF0b21p
YyB3cml0ZSBsZW49JCgoYnNpemUgKyAxKSkgc2hvdWxkIGZhaWwiDQo+Pj4+ICsNCj4+Pj4gKyAg
ICAjIFJlamVjdCBhdG9taWMgd3JpdGUgd2hlbiBpb3ZlY3MgPiAxDQo+Pj4+ICsgICAgJFhGU19J
T19QUk9HIC1kYyAicHdyaXRlIC1BIC1EIC1WMiAtYiAkYnNpemUgMCAkYnNpemUiDQo+Pj4+ICR0
ZXN0ZmlsZSAyPj4gJHNlcXJlcy5mdWxsICYmIFwNCj4+Pj4gKyAgICAgICAgZWNobyAiYXRvbWlj
IHdyaXRlIG9ubHkgc3VwcG9ydHMgaW92ZWMgY291bnQgb2YgMSINCj4+Pj4gKw0KPj4+PiArICAg
ICMgUmVqZWN0IGF0b21pYyB3cml0ZSB3aGVuIG5vdCB1c2luZyBkaXJlY3QgSS9PDQo+Pj4+ICsg
ICAgJFhGU19JT19QUk9HIC1jICJwd3JpdGUgLUEgLVYxIC1iICRic2l6ZSAwICRic2l6ZSIgJHRl
c3RmaWxlDQo+Pj4+IDI+PiAkc2VxcmVzLmZ1bGwgJiYgXA0KPj4+PiArICAgICAgICBlY2hvICJh
dG9taWMgd3JpdGUgcmVxdWlyZXMgZGlyZWN0IEkvTyINCj4+Pj4gKw0KPj4+PiArICAgICMgUmVq
ZWN0IGF0b21pYyB3cml0ZSB3aGVuIG9mZnNldCAlIGJzaXplICE9IDANCj4+Pj4gKyAgICAkWEZT
X0lPX1BST0cgLWRjICJwd3JpdGUgLUEgLUQgLVYxIC1iICRic2l6ZSAxICRic2l6ZSINCj4+Pj4g
JHRlc3RmaWxlIDI+PiAkc2VxcmVzLmZ1bGwgJiYgXA0KPj4+PiArICAgICAgICBlY2hvICJhdG9t
aWMgd3JpdGUgcmVxdWlyZXMgb2Zmc2V0IHRvIGJlIGFsaWduZWQgdG8gYnNpemUiDQo+Pj4+ICsN
Cj4+Pj4gKyAgICBfc2NyYXRjaF91bm1vdW50DQo+Pj4+ICt9DQo+Pj4+ICsNCj4+Pj4gK3Rlc3Rf
YXRvbWljX3dyaXRlX2JvdW5kcygpDQo+Pj4+ICt7DQo+Pj4+ICsgICAgbG9jYWwgYnNpemU9JDEN
Cj4+Pj4gKw0KPj4+PiArICAgIGNhc2UgIiRGU1RZUCIgaW4NCj4+Pj4gKyAgICAieGZzIikNCj4+
Pj4gKyAgICAgICAgbWtmc19vcHRzPSItYiBzaXplPSRic2l6ZSINCj4+Pj4gKyAgICAgICAgOzsN
Cj4+Pj4gKyAgICAiZXh0NCIpDQo+Pj4+ICsgICAgICAgIG1rZnNfb3B0cz0iLWIgJGJzaXplIg0K
Pj4+PiArICAgICAgICA7Ow0KPj4+PiArICAgICopDQo+Pj4+ICsgICAgICAgIDs7DQo+Pj4+ICsg
ICAgZXNhYw0KPj4+PiArDQo+Pj4+ICsgICAgIyBJZiBibG9jayBzaXplIGlzIG5vdCBzdXBwb3J0
ZWQsIHNraXAgdGhpcyB0ZXN0DQo+Pj4+ICsgICAgX3NjcmF0Y2hfbWtmcyAkbWtmc19vcHRzID4+
JHNlcXJlcy5mdWxsIDI+JjEgfHwgcmV0dXJuDQo+Pj4+ICsgICAgX3RyeV9zY3JhdGNoX21vdW50
ID4+JHNlcXJlcy5mdWxsIDI+JjEgfHwgcmV0dXJuDQo+Pj4+ICsNCj4+Pj4gKyAgICB0ZXN0ICIk
RlNUWVAiID0gInhmcyIgJiYgX3hmc19mb3JjZV9iZGV2IGRhdGEgJFNDUkFUQ0hfTU5UDQo+Pj4+
ICsNCj4+Pj4gKyAgICB0ZXN0ZmlsZT0kU0NSQVRDSF9NTlQvdGVzdGZpbGUNCj4+Pj4gKyAgICB0
b3VjaCAkdGVzdGZpbGUNCj4+Pj4gKw0KPj4+PiArICAgICRYRlNfSU9fUFJPRyAtZGMgInB3cml0
ZSAtQSAtRCAtVjEgLWIgJGJzaXplIDAgJGJzaXplIg0KPj4+PiAkdGVzdGZpbGUgMj4+ICRzZXFy
ZXMuZnVsbCAmJiBcDQo+Pj4+ICsgICAgICAgIGVjaG8gImF0b21pYyB3cml0ZSBzaG91bGQgZmFp
bCB3aGVuIGJzaXplIGlzIG91dCBvZg0KPj4+PiBib3VuZHMiDQo+Pj4+ICsNCj4+Pj4gKyAgICBf
c2NyYXRjaF91bm1vdW50DQo+Pj4+ICt9DQo+Pj4+ICsNCj4+Pj4gK3N5c19taW5fd3JpdGU9JChj
YXQgIi9zeXMvYmxvY2svJChfc2hvcnRfZGV2DQo+Pj4+ICRTQ1JBVENIX0RFVikvcXVldWUvYXRv
bWljX3dyaXRlX3VuaXRfbWluX2J5dGVzIikNCj4+Pj4gK3N5c19tYXhfd3JpdGU9JChjYXQgIi9z
eXMvYmxvY2svJChfc2hvcnRfZGV2DQo+Pj4+ICRTQ1JBVENIX0RFVikvcXVldWUvYXRvbWljX3dy
aXRlX3VuaXRfbWF4X2J5dGVzIikNCj4+Pj4gKw0KPj4+PiArYmRldl9taW5fd3JpdGU9JChfZ2V0
X2F0b21pY193cml0ZV91bml0X21pbiAkU0NSQVRDSF9ERVYpDQo+Pj4+ICtiZGV2X21heF93cml0
ZT0kKF9nZXRfYXRvbWljX3dyaXRlX3VuaXRfbWF4ICRTQ1JBVENIX0RFVikNCj4+Pj4gKw0KPj4+
PiAraWYgWyAiJHN5c19taW5fd3JpdGUiIC1uZSAiJGJkZXZfbWluX3dyaXRlIiBdOyB0aGVuDQo+
Pj4+ICsgICAgZWNobyAiYmRldiBtaW4gd3JpdGUgIT0gc3lzIG1pbiB3cml0ZSINCj4+Pj4gK2Zp
DQo+Pj4+ICtpZiBbICIkc3lzX21heF93cml0ZSIgLW5lICIkYmRldl9tYXhfd3JpdGUiIF07IHRo
ZW4NCj4+Pj4gKyAgICBlY2hvICJiZGV2IG1heCB3cml0ZSAhPSBzeXMgbWF4IHdyaXRlIg0KPj4+
PiArZmkNCj4+Pj4gKw0KPj4+PiArIyBUZXN0IGFsbCBzdXBwb3J0ZWQgYmxvY2sgc2l6ZXMgYmV0
d2VlbiBiZGV2IG1pbiBhbmQgbWF4DQo+Pj4+ICtmb3IgKChic2l6ZT0kYmRldl9taW5fd3JpdGU7
IGJzaXplPD1iZGV2X21heF93cml0ZTsgYnNpemUqPTIpKTsgZG8NCj4+Pj4gKyAgICAgICAgdGVz
dF9hdG9taWNfd3JpdGVzICRic2l6ZQ0KPj4+PiArZG9uZTsNCj4+Pj4gKw0KPj4+PiArIyBDaGVj
ayB0aGF0IGF0b21pYyB3cml0ZSBmYWlscyBpZiBic2l6ZSA8IGJkZXYgbWluIG9yIGJzaXplID4N
Cj4+Pj4gYmRldiBtYXgNCj4+Pj4gK3Rlc3RfYXRvbWljX3dyaXRlX2JvdW5kcyAkKChiZGV2X21p
bl93cml0ZSAvIDIpKQ0KPj4+PiArdGVzdF9hdG9taWNfd3JpdGVfYm91bmRzICQoKGJkZXZfbWF4
X3dyaXRlICogMikpDQo+Pj4+ICsNCj4+Pj4gKyMgc3VjY2VzcywgYWxsIGRvbmUNCj4+Pj4gK2Vj
aG8gU2lsZW5jZSBpcyBnb2xkZW4NCj4+Pj4gK3N0YXR1cz0wDQo+Pj4+ICtleGl0DQo+Pj4+IGRp
ZmYgLS1naXQgYS90ZXN0cy9nZW5lcmljLzc2Mi5vdXQgYi90ZXN0cy9nZW5lcmljLzc2Mi5vdXQN
Cj4+Pj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+Pj4gaW5kZXggMDAwMDAwMDAuLmZiYWViMjk3
DQo+Pj4+IC0tLSAvZGV2L251bGwNCj4+Pj4gKysrIGIvdGVzdHMvZ2VuZXJpYy83NjIub3V0DQo+
Pj4+IEBAIC0wLDAgKzEsMiBAQA0KPj4+PiArUUEgb3V0cHV0IGNyZWF0ZWQgYnkgNzYyDQo+Pj4+
ICtTaWxlbmNlIGlzIGdvbGRlbg0KPj4+PiAtLSANCj4+Pj4gMi4zNC4xDQo+Pj4+IA0KPj4+PiAN
Cj4+IA0KPj4gDQoNCg==

