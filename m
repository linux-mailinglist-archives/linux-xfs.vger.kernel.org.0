Return-Path: <linux-xfs+bounces-10722-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42EDB935179
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Jul 2024 20:07:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEF391F239E5
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Jul 2024 18:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A553EA66;
	Thu, 18 Jul 2024 18:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i1PqxEGV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gqDPAuQx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A53C1459E8
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721326027; cv=fail; b=Ap41IR/9MDJejlWioW+B4ThL7VbtoHA4wevUq1+aN8TiknvoAUQhVUJI6T9ZnAON5zD3Lq3x1zKpVIb9XtGzVJPwlsXtySiq3wXWXO+wm2qYgVfaRGmrWMtEq8qVY7XG3WGc4BRLnHHzyv4hI4jfqAfyDVaGxgX3pHIj7mVNknY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721326027; c=relaxed/simple;
	bh=GJGhyob5NEFNmlGY4hhMlb7zg3/oth1Umd2fAuiJsVE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y69HfiRLRCnvkbrcnc8hLuSJA8hmbKTyYDSSHZtiienpXvPZJJUzHFby3T/8/z8HprgdXMxUqN5DOJ/LIV7jLLAl+7iC8Z610rMPxwiEi1i9XXPyJXw5RJhuaoZHdV1IIztGZHF00aSB46kw+PpbL/kv5qV4bPQ3uHw7fyiZeN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i1PqxEGV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gqDPAuQx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46II0CN0013547;
	Thu, 18 Jul 2024 18:07:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=GJGhyob5NEFNmlGY4hhMlb7zg3/oth1Umd2fAuiJs
	VE=; b=i1PqxEGV80cxsoyj3pCo1qTxHjEoyC017iaWah/NDupgQMn44Yso153pV
	KF8DmmZjwUa4PcDQo4ceMAGWLvW2xHQEr0HFfSiH+wFNUsufT1J13UMc8A1XZCID
	ZsNsg1d85vE6TFi0/noj/AJWkFzdW5ouvnUYilFO3SPDpvwIcTcK4DW/uvxOjP+d
	cZQ9EwxdNx/4Dwl5cs3YU1qNj9EdSxawYp1p7/MRy2X9SaJarUglfIIEt/QOKTqk
	UGNTL4j+eB6MYxni7SY9VB6HDGj18kUwuWEDrlOYTUQzzIxA5WeIOEOCPSyWM3iB
	cpwjELTZFIXELWHyUqanhIr9JQDrg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40f7xr00g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 18:07:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46IHIhJC021835;
	Thu, 18 Jul 2024 18:07:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40dweuy5pq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 18:07:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ArUUR1HtJINnJ/TivLIhpue47aBJBBou1f5rmzg6d6kjq/FusdR6Uk3LFbHYaanY+IVcM16HbAli2B2mV3zQXcend3Xb0Cl3BKTmaFH34xxBB9c6EtCSN7/VAPNG9mnBypM9LmpVygEmLolxnOGuegCoB1iaeMcAZDCVNOBh6o5W67TMCaTekLbFtvNB11bjiQWEFsvUMl0AaGgubBsSfZkc9OOQ1rFd8mYzpDYQFTyr/Am/4riBAF9LlvzQTNe+11nz7E/qFaYH8NTxIC98RucIKLRDstDrrKL6chZy5+hyAXnYEwltMUKpg+vjhni7I235gGcYgbl84Vw5aqyM0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJGhyob5NEFNmlGY4hhMlb7zg3/oth1Umd2fAuiJsVE=;
 b=Cgq0uV663o1FSpQM+JirlWtOxqZmSW6mgnSb8NqTkYghCp76D0va8xH61Wv7VkZYEIdJ1BsYyl6YmFVBZoGdfsmqoVSXVZJWxw+jrXV7tIVBISC9dwUCaDrrfcZI2PmCa+IT0XuMmg9SxdCLukvRB1H0+c4KtaaSUvUpCu7AwM+4XWKOaWJp7Vs2n38mBJsMoKqBtV9qz1naGOBSWTKWOujRwUuTbz+d6alBl9X+6EAzJxuVJQ/p5QSg1rjO5MBktiF7Yu1Bt0X6F6heHXlkKSyWMARf/NuhlKoAkBb96vU1yqy8wx+a1h35IQhKU7Qqpt1i5mARdmVk/FVZDLLGuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJGhyob5NEFNmlGY4hhMlb7zg3/oth1Umd2fAuiJsVE=;
 b=gqDPAuQxpPrCNp9UXur/st1+TJ7gfX+UzrQ+urjYCkX14B5rPNUgZKFDmieshG1IpGmoFzLCmLhgmTtTsoJ7MMTaPjil9XxlmlAaNBQRqIJYU6sAfnxWx76IOn1DftjW2jirqdLXEZbMA6KklU7fjcHfmsKTJVnse2E5iGEujMg=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by SA1PR10MB7815.namprd10.prod.outlook.com (2603:10b6:806:3ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Thu, 18 Jul
 2024 18:06:58 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7784.017; Thu, 18 Jul 2024
 18:06:58 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/9] spaceman/defrag: defrag segments
Thread-Topic: [PATCH 3/9] spaceman/defrag: defrag segments
Thread-Index: AQHa0jOuXyFSvutJ4kmLNdUbwmDQsbH4hBOAgARSCQA=
Date: Thu, 18 Jul 2024 18:06:58 +0000
Message-ID: <1CFA5FAE-9571-41B4-8205-3C585F56F574@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-4-wen.gang.wang@oracle.com>
 <ZpW56ccnA26iYI1U@dread.disaster.area>
In-Reply-To: <ZpW56ccnA26iYI1U@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|SA1PR10MB7815:EE_
x-ms-office365-filtering-correlation-id: 4cdafbb7-f810-4d5f-4966-08dca7546a78
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?d0FmeHNlUVNzem9wZFRvTHV5bTVnNnZtM2pxVTFjTVZzUitXQ0cxRFpnTkpI?=
 =?utf-8?B?YkYvbW9kUXo0ZnJYZ1hoUUx4VjFHdlo5MWorV0JNMjJxb1dHdEZkbXdSbkM2?=
 =?utf-8?B?NmZMa0ZyR1A3aDRBMVphYUNhR3VybmtHeFNHTEczMWZyZjVYOXdEaVhCSUNk?=
 =?utf-8?B?MzJ4Yzg5M2F0K0VFWXEzczZxMGxqSUE4WERFWFZ6Qi9MT2tPdFdEY3VOeEdj?=
 =?utf-8?B?NXlyNDJCS0EwU0tXK3AxK3lXb3d6SjRQYU05N25EUE8zNmhjVFpYTkFEVEN0?=
 =?utf-8?B?NXdNclJSUTU5SURobHBEeVJ6MHZzS2pEeUxlQ3JNN0ZhUmZMODBqS0pWVDNQ?=
 =?utf-8?B?dUdCa1MrMCtIcFF0VktSQ3h3VG1GbkNzOTNHL3RIRlJjMVBmVGFUOVZYUU9z?=
 =?utf-8?B?cStXNEhwbW01TzNUUWY4b0s1RGRMRVMrQ3Zndm5qb0V1NStvZXd3YjFGaCtX?=
 =?utf-8?B?dU1sYnJYZUsxZi84d3VhRVQxUnhJemZ5eVRYOEdRTktyWGFFVkZORkxGQWdP?=
 =?utf-8?B?OVpUZnZ0ZzZIRjBKOXFHZHE5MGhDUWFMMnhUK3hGbytTSllJYnRDdFIva2ZW?=
 =?utf-8?B?N01aZVA0RmJIczUvMmpSUjQ1bnB4WGpxWjFLTk5aNDI0dUN5QmFCdlA5NlFO?=
 =?utf-8?B?TjdIZ1hTaXpNNWxzMm5tN1ZmUHJKWXJhVmJKZzg2ZGJmcGFpVVh4NEJGYlpk?=
 =?utf-8?B?MERUaUw5bExtN1N2cGNGTTJJbTZaaFlKT2tobWxDRk00TzNuM0tOWHdpMVlS?=
 =?utf-8?B?M2did20yR3hpL3FSRjhLUDRpU1VjNzE1T1d5K1lSUnFFVjJRa256elNHbkwr?=
 =?utf-8?B?UW9UUnc0bUNWZVpmaE9rMzBwKzFiVlY4SDRRWWN4MCtFaStzeVhkV3dSN0RL?=
 =?utf-8?B?R0pldDBzdjhGaEE5TmZmeHRTR2NyN2FaVnY1d2Z4Zi91QmF2UXJnd0QvQlFp?=
 =?utf-8?B?MDdaUGV5M0c2aFRCcDVwLzNUeTk5c0tRaTRRbll2a05pTWJJR3BPMXlQMWxw?=
 =?utf-8?B?bjdXZUJGYUxiQ1JpTW1RQTRnWVh1d2VobUREcHhNK1I1ZjZ5QnpHSml4Yk5H?=
 =?utf-8?B?VjFHbWRGaEoreE50blAyN3RvdjVBbTNsTmdmaHRyMTBJcERvSVNpM3REUTc1?=
 =?utf-8?B?NDNsd05JVUJSbDZYUVI0dW90ZW5rSGFIejhWTm83K3RuWkJ0UVdZQVNGdFF6?=
 =?utf-8?B?ZEE5WlhLSm93QzExbDFFZmVnSE1zeGMzUFJqUTRIK1pwMk9haFd4TVpSTzB0?=
 =?utf-8?B?S1pkY0hpaHdBM1hEYXYzSmg4NTBDbzdVZHVDV0FSWndRUXZISEZ1S0VjcjJy?=
 =?utf-8?B?TFBGMVhZY05qS1JwUHB5VHJRaVliRVFWQlRsaXpGY3d5dDhnYUNrWVJScEdC?=
 =?utf-8?B?RGFLUTV4ZzhZaElQSURKT3gyNU5vQnYzNXR1NDhWVkJnU0Z6b251dVB5dHZB?=
 =?utf-8?B?dTBjUjhwUkw5K0luMUxnTlRONkdOMjg3Yzc1UmJ6YUNQN1hsc0ZEYUx2aTdF?=
 =?utf-8?B?L3ZXZEdNeVNqaGswTkUwclphd2ptNVQwNGgwcWg3VG1ibkdwaGYvM2tHdHFK?=
 =?utf-8?B?UkJVQ0dUM1pnaDByR0tsVVIwVzY0bUhpQzAzTFAxcWpMK2ZISUpneHFlRHJD?=
 =?utf-8?B?bzZocmFOYnc5SHRaWkRTbndyUXAzUnhrTEJWOEV1eVFrL3F5Y2lNMGQ4L0ZJ?=
 =?utf-8?B?aE1aWjNySkh6aGcwNVZOa3Z6VU5QUE15TUFtZHVvYzNlQ0RVV290U2F5ckNh?=
 =?utf-8?B?bWtoa1hzVU1OSEI5OWVSa0tFdnpYTkc0RTFJQVFJMzlKUkdjOWpRbkRPeGo5?=
 =?utf-8?B?U2U2M2NIbzh2RzNJSUx1QmdRSG5zUzhIUU4rbENndWVwbUhDRWhMeEtHcklH?=
 =?utf-8?B?Zm93OTFEaVN3S2xoMTUwQXpOMUtUa0V6bXhFbkp4NG9XdFE9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?UmlrQkU0QlROUVIrclRsYUNHdzM1eERZZW55NDlSdWplbUZJRExLRnF2L0hv?=
 =?utf-8?B?VUV3NUlsNThGU3RwZnBrR3lhbzdwVmwwMXZpbVBSNStzRC9pMEdDQTZMdXpp?=
 =?utf-8?B?U0pVNm8wbjc5SVNQWU54cTJSa1FwSHgrZnNzYXY5S1JCMFNTQjNzc1lRckhC?=
 =?utf-8?B?UHlUTWlFQVdpd2xRTzIybllNeTVoQVhKWVVVRms3L2pjb0U1Y1ZFcENRR0Ns?=
 =?utf-8?B?N2U5YU5GU3M4VVBmTUNXU3ZmRytCbXU5OWpwRldhTlV4QjBjc3YvcDRnbitB?=
 =?utf-8?B?emdrNFQwMFZOcmw3WnFobGFJMFZQeEwzclQzM3VXNkZZZ0NQekhKQ0gxTjFC?=
 =?utf-8?B?c1luUEdUTXRSU2xUODBjMHZPNksxQ3ZMdDM2VnBqWnh5T0Q4SmJRRjNWYXM5?=
 =?utf-8?B?ckcwbEF2T0sxVjg5c1VQNWorWnZkclh5MjVZREVFY0dkZ3FWVGRPNUV6bzEr?=
 =?utf-8?B?NWVKUUkvRTY1dE4wOHhaY0VFNWUvRS9iaCtEdFUvV0svNHkxNUdaUGNHOWNm?=
 =?utf-8?B?a1JqLzlBMzlRdVdHTGZQUkFpTDRaUk9wVEhibjlqOG12L3ZhVmJwU2dqdWMv?=
 =?utf-8?B?Y3c1QnVaa0pzeVdKZTFwcUt3UlpDbFVHM054M3dWOXRlZTRwa2JHVXVXeG1P?=
 =?utf-8?B?ZHE3bmVvOU42SmNSQSsxNkczTEZ1cE4ycTYxL0p6cEN0RVJpelp2N08rR0py?=
 =?utf-8?B?WDdiSXg4clM1QmNTWjAzQTVSbDluVE1xWFNwVGVzTGNhb090ZGxXYjB3Zkcx?=
 =?utf-8?B?N0ZhYXdpRENVbW8vbjdFaVI5OExGQzVTbWliRDJkMEhJVnllYmxXU2FMWWd5?=
 =?utf-8?B?VWhLd0JsNWhHUy9FSXlKUXdWTm1NTUtCbHM5cmcvd1FCNkI4MEFmMS8wRUgw?=
 =?utf-8?B?NHNOdmVMWjBod0VrVnZFZy9obkF3NmVWLzlWQ2E3TFpxT3BBMG90Nlg5VVlU?=
 =?utf-8?B?Mk9ZRHRlWWFZSkR0UEZGWjlmM2NyMnZhODFvWExMTkh1MGdIanlhYnZGdnE2?=
 =?utf-8?B?em43YUpXV3pNWFJVSWtLT01MU3RmTkRlME15SWZGQlVTQVJ0NTlSK2tNTzBl?=
 =?utf-8?B?Sk5IejgxdEdjMG1xMXpGbG9pMS85T1ZwcmVXUHFZd21WVWw4dHNQWFJabFk3?=
 =?utf-8?B?dFVpTW1SeHpQZ1dDL3Q4YXY2TEszOVZFUjhrZXNPRFNTcE16Mkxub3JwT0R3?=
 =?utf-8?B?WnpiaitLUExvZXZVL3k2bWxON0pJQmZ5bVp3dFdUekp1bmZmSWpsd2ZYMW5J?=
 =?utf-8?B?RUovY0I0S20xcldPdVdxUmZRQnprQXBCWU5kNERGaWVvMzBCU1dQV0Y1SnlO?=
 =?utf-8?B?Z09aSzJ2eHBNRG1FQVVTQ211VFc3UTZ5OFVRTWpJK2tuQklVa2JEUVhycnVR?=
 =?utf-8?B?K2s1RTUrL0dOQmY1dWFwVS9OblMxMjB2YktxenhuNFZ0TzlSNmFUanF4SFJa?=
 =?utf-8?B?WjZMWUFOVzBQR2xYK0QrZFhIQkJLRm5GOHoxSXZsYm1MbmhFelJXaGw1bnhF?=
 =?utf-8?B?N2ZFVXVCQzBvNFhpbnhPMGJVUThNMXNuUHRZQU84aVpGRHZFUWZPc1Jsa2Uv?=
 =?utf-8?B?Q0JWT2dhOFZaa1BPK3pUbXlhYlVLQ1M1b0N3VnBsaVZwdnV5WUVrem1tZ0h3?=
 =?utf-8?B?eFc0TUljRkkzYVFzT2ROZEg2VVJwa3poTUt2QmljZEthQ3FqcFFkOThuTUgz?=
 =?utf-8?B?RXVKejMwNVZiTklyMkJMTXpCckZUdDUyMGR3QjIvcUJRMmdCYXZydkNoNVox?=
 =?utf-8?B?NGpuWVo3UUNvL3pWR3JTVjUzb3FDMkw2K3VFc0dWaUpGRVZQTHF1bHZ0ZFlJ?=
 =?utf-8?B?Yzc3Q0V5c2VvNTI5a1NzeSszczNDTUV1Y245OFJHYkt0UEp1TU44UitVd2Yy?=
 =?utf-8?B?L0doOVR0QkthbmJPaUZCQ0ozS2pGSi9nbFdnVlY3MnJwMXg0OGRRRUlkbERL?=
 =?utf-8?B?cmRXaklwNjFMNS9ueXlrZTFFbG5iMGhTOGFxRW9xWGZOa1BaRFlsVFQvNGRr?=
 =?utf-8?B?M3RqWVNnUmgyUDRlWkhpV0llUVVzdWJqWHYxNDhHQjYxMytTNlVxMVE3MU1I?=
 =?utf-8?B?T0xRaHQ5cE9ZQXJtRnE5WjVIeHBYT1JNcHpxeDZHd1Foa213cU5QcDMwalJO?=
 =?utf-8?B?NFAxSEVQblJuVEs2VTBrdWlGOEJrZWswZklsdENRTzI0N2R0SGRSTWZ4ZzI1?=
 =?utf-8?B?blJ5N3NJYzFsMFpqMXVtRTcybHlrcG9Pc05xaVU1S3Z3RE9hclNjV1J0ZHRC?=
 =?utf-8?B?c2pLUE8wR2JIa0tYZXFubzlSUVhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40572DB28EE6CC4D989DB45E3AD500D1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	WX0+qK/UG8YOBqulFJmQ5tIWhRq1ALSiCwbHhJSfAJu38h/IeRXr+h38bX9ic8mV8KWP68KdglifC+IQR+QBWDH6GwtaSWrFf7xvS/Yqa19w8JxM/WnJRbIxyovlRka9jVs2JntpNJjV4GXLmCGObrhbIlfOOpytivnUFZd4Rgfdwg0x2UiTaHYB0KLcIV1aAkEaR6KwJTOEc8k950qMwDubiChzdGplHUuO+9QdG0l/kuraAjiuHfXV4sWsLUFice9LPHfAH1gBDk/O1j5qLokvCIU7mSX7q9RP1E6/45WBoftGgwsLlqlLxGlWbmrFic7uDn/xCXt37bJJBWpzj7FA6xWGaEF/CxsR11TrYnQksa3ZAN+Jc6wOGjDHbyo/cbOxyBU8k7/NgtYvstVY+JWgUxjtCHHJJw/jY7qI1RmIcrJKODmAJ5K4uVOuonDwSYv6XwHCfDHXopbnEYeP43yeo+kp9V6lMkjqrKkf8lOhJFtKG35HxT+3HT4sqU6dwvKLSYqnAvmKO3/7qazO4CwvPRRaQl/tqzEZhj15x7L7mgL2UfIiNoUvOfX25p5HK5ZNACnX1L+TTR4zJzkrTw5IkutUazORIttknILeHrs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cdafbb7-f810-4d5f-4966-08dca7546a78
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2024 18:06:58.4854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cC1QdzxlUAe1fYxdB3T9aI3WQmYcBHOZdu8I2nnUzCuw4+eYXQHHjjwMyL+m4yl72GxB/Wy6InjZrW79d+H93olHw57K+GctyaJcAV3hHio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7815
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_12,2024-07-18_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407180118
X-Proofpoint-GUID: Gf12op0f0PfB7Bk3FISsqkMS_O2RmN0P
X-Proofpoint-ORIG-GUID: Gf12op0f0PfB7Bk3FISsqkMS_O2RmN0P

DQoNCj4gT24gSnVsIDE1LCAyMDI0LCBhdCA1OjA44oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyMlBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBGb3IgZWFjaCBzZWdtZW50LCB0
aGUgZm9sbG93aW5nIHN0ZXBzIGFyZSBkb25lIHRyeWluZyB0byBkZWZyYWcgaXQ6DQo+PiANCj4+
IDEuIHNoYXJlIHRoZSBzZWdtZW50IHdpdGggYSB0ZW1wb3JhcnkgZmlsZQ0KPj4gMi4gdW5zaGFy
ZSB0aGUgc2VnbWVudCBpbiB0aGUgdGFyZ2V0IGZpbGUuIGtlcm5lbCBzaW11bGF0ZXMgQ293IG9u
IHRoZSB3aG9sZQ0KPj4gICBzZWdtZW50IGNvbXBsZXRlIHRoZSB1bnNoYXJlIChkZWZyYWcpLg0K
Pj4gMy4gcmVsZWFzZSBibG9ja3MgZnJvbSB0aGUgdGVtcG9hcnkgZmlsZS4NCj4+IA0KPj4gU2ln
bmVkLW9mZi1ieTogV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5nQG9yYWNsZS5jb20+DQo+PiAt
LS0NCj4+IHNwYWNlbWFuL2RlZnJhZy5jIHwgMTE0ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4+IDEgZmlsZSBjaGFuZ2VkLCAxMTQgaW5zZXJ0aW9ucygr
KQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvc3BhY2VtYW4vZGVmcmFnLmMgYi9zcGFjZW1hbi9kZWZy
YWcuYw0KPj4gaW5kZXggMTc1Y2Y0NjEuLjlmMTFlMzZiIDEwMDY0NA0KPj4gLS0tIGEvc3BhY2Vt
YW4vZGVmcmFnLmMNCj4+ICsrKyBiL3NwYWNlbWFuL2RlZnJhZy5jDQo+PiBAQCAtMjYzLDYgKzI2
Myw0MCBAQCBhZGRfZXh0Og0KPj4gcmV0dXJuIHJldDsNCj4+IH0NCj4+IA0KPj4gKy8qDQo+PiAr
ICogY2hlY2sgaWYgdGhlIHNlZ21lbnQgZXhjZWVkcyBFb0YuDQo+PiArICogZml4IHVwIHRoZSBj
bG9uZSByYW5nZSBhbmQgcmV0dXJuIHRydWUgaWYgRW9GIGhhcHBlbnMsDQo+PiArICogcmV0dXJu
IGZhbHNlIG90aGVyd2lzZS4NCj4+ICsgKi8NCj4+ICtzdGF0aWMgYm9vbA0KPj4gK2RlZnJhZ19j
bG9uZV9lb2Yoc3RydWN0IGZpbGVfY2xvbmVfcmFuZ2UgKmNsb25lKQ0KPj4gK3sNCj4+ICsgb2Zm
X3QgZGVsdGE7DQo+PiArDQo+PiArIGRlbHRhID0gY2xvbmUtPnNyY19vZmZzZXQgKyBjbG9uZS0+
c3JjX2xlbmd0aCAtIGdfZGVmcmFnX2ZpbGVfc2l6ZTsNCj4+ICsgaWYgKGRlbHRhID4gMCkgew0K
Pj4gKyBjbG9uZS0+c3JjX2xlbmd0aCA9IDA7IC8vIHRvIHRoZSBlbmQNCj4+ICsgcmV0dXJuIHRy
dWU7DQo+PiArIH0NCj4+ICsgcmV0dXJuIGZhbHNlOw0KPj4gK30NCj4+ICsNCj4+ICsvKg0KPj4g
KyAqIGdldCB0aGUgdGltZSBkZWx0YSBzaW5jZSBwcmVfdGltZSBpbiBtcy4NCj4+ICsgKiBwcmVf
dGltZSBzaG91bGQgY29udGFpbnMgdmFsdWVzIGZldGNoZWQgYnkgZ2V0dGltZW9mZGF5KCkNCj4+
ICsgKiBjdXJfdGltZSBpcyB1c2VkIHRvIHN0b3JlIGN1cnJlbnQgdGltZSBieSBnZXR0aW1lb2Zk
YXkoKQ0KPj4gKyAqLw0KPj4gK3N0YXRpYyBsb25nIGxvbmcNCj4+ICtnZXRfdGltZV9kZWx0YV91
cyhzdHJ1Y3QgdGltZXZhbCAqcHJlX3RpbWUsIHN0cnVjdCB0aW1ldmFsICpjdXJfdGltZSkNCj4+
ICt7DQo+PiArIGxvbmcgbG9uZyB1czsNCj4+ICsNCj4+ICsgZ2V0dGltZW9mZGF5KGN1cl90aW1l
LCBOVUxMKTsNCj4+ICsgdXMgPSAoY3VyX3RpbWUtPnR2X3NlYyAtIHByZV90aW1lLT50dl9zZWMp
ICogMTAwMDAwMDsNCj4+ICsgdXMgKz0gKGN1cl90aW1lLT50dl91c2VjIC0gcHJlX3RpbWUtPnR2
X3VzZWMpOw0KPj4gKyByZXR1cm4gdXM7DQo+PiArfQ0KPj4gKw0KPj4gLyoNCj4+ICAqIGRlZnJh
Z21lbnQgYSBmaWxlDQo+PiAgKiByZXR1cm4gMCBpZiBzdWNjZXNzZnVsbHkgZG9uZSwgMSBvdGhl
cndpc2UNCj4+IEBAIC0yNzMsNiArMzA3LDcgQEAgZGVmcmFnX3hmc19kZWZyYWcoY2hhciAqZmls
ZV9wYXRoKSB7DQo+PiBsb25nIG5yX3NlZ19kZWZyYWcgPSAwLCBucl9leHRfZGVmcmFnID0gMDsN
Cj4+IGludCBzY3JhdGNoX2ZkID0gLTEsIGRlZnJhZ19mZCA9IC0xOw0KPj4gY2hhciB0bXBfZmls
ZV9wYXRoW1BBVEhfTUFYKzFdOw0KPj4gKyBzdHJ1Y3QgZmlsZV9jbG9uZV9yYW5nZSBjbG9uZTsN
Cj4+IGNoYXIgKmRlZnJhZ19kaXI7DQo+PiBzdHJ1Y3QgZnN4YXR0ciBmc3g7DQo+PiBpbnQgcmV0
ID0gMDsNCj4+IEBAIC0yOTYsNiArMzMxLDggQEAgZGVmcmFnX3hmc19kZWZyYWcoY2hhciAqZmls
ZV9wYXRoKSB7DQo+PiBnb3RvIG91dDsNCj4+IH0NCj4+IA0KPj4gKyBjbG9uZS5zcmNfZmQgPSBk
ZWZyYWdfZmQ7DQo+PiArDQo+PiBkZWZyYWdfZGlyID0gZGlybmFtZShmaWxlX3BhdGgpOw0KPiAN
Cj4gSnVzdCBhIG5vdGU6IGNhbiB5b3UgcGxlYXNlIGNhbGwgdGhpcyB0aGUgInNvdXJjZSBmZCIs
IG5vdCB0aGUNCj4gImRlZnJhZ19mZCI/IGRlZnJhZ19mZCBjb3VsZCBtZWFuIGVpdGhlciB0aGUg
c291cmNlIG9yIHRoZQ0KPiB0ZW1wb3Jhcnkgc2NyYXRjaCBmaWxlIHdlIHVzZSBhcyB0aGUgZGVm
cmFnIGRlc3RpbmF0aW9uLg0KDQpJIGhhdmUgbm8gcHJvYmxlbSB0byBjaGFuZ2UgdGhhdC4gSnVz
dCBJIHdhcyB0aGlua2luZyB0aGVyZSBpcyBubyBkYXRhIG1vdmluZyBoYXBwZW5pbmcNCmZyb20g
YSBmaWxlIHRvIGFub3RoZXIuIFRoZSBkZWZyYWdfZmQgbWVhbnMgdGhlIGZpbGUgdW5kZXIgZGVm
cmFnIGFuZCB0aGUgdGVtcCBmaWxlIGlzIHdpdGgNCnNjcmF0Y2hfZmQuDQoNCj4gDQo+PiBzbnBy
aW50Zih0bXBfZmlsZV9wYXRoLCBQQVRIX01BWCwgIiVzLy54ZnNkZWZyYWdfJWQiLCBkZWZyYWdf
ZGlyLA0KPj4gZ2V0cGlkKCkpOw0KPj4gQEAgLTMwOSw3ICszNDYsMTEgQEAgZGVmcmFnX3hmc19k
ZWZyYWcoY2hhciAqZmlsZV9wYXRoKSB7DQo+PiB9DQo+PiANCj4+IGRvIHsNCj4+ICsgc3RydWN0
IHRpbWV2YWwgdF9jbG9uZSwgdF91bnNoYXJlLCB0X3B1bmNoX2hvbGU7DQo+PiBzdHJ1Y3QgZGVm
cmFnX3NlZ21lbnQgc2VnbWVudDsNCj4+ICsgbG9uZyBsb25nIHNlZ19zaXplLCBzZWdfb2ZmOw0K
Pj4gKyBpbnQgdGltZV9kZWx0YTsNCj4+ICsgYm9vbCBzdG9wOw0KPj4gDQo+PiByZXQgPSBkZWZy
YWdfZ2V0X25leHRfc2VnbWVudChkZWZyYWdfZmQsICZzZWdtZW50KTsNCj4+IC8qIG5vIG1vcmUg
c2VnbWVudHMsIHdlIGFyZSBkb25lICovDQo+PiBAQCAtMzIyLDYgKzM2Myw3OSBAQCBkZWZyYWdf
eGZzX2RlZnJhZyhjaGFyICpmaWxlX3BhdGgpIHsNCj4+IHJldCA9IDE7DQo+PiBicmVhazsNCj4+
IH0NCj4+ICsNCj4+ICsgLyogd2UgYXJlIGRvbmUgaWYgdGhlIHNlZ21lbnQgY29udGFpbnMgb25s
eSAxIGV4dGVudCAqLw0KPj4gKyBpZiAoc2VnbWVudC5kc19uciA8IDIpDQo+PiArIGNvbnRpbnVl
Ow0KPj4gKw0KPj4gKyAvKiB0byBieXRlcyAqLw0KPj4gKyBzZWdfb2ZmID0gc2VnbWVudC5kc19v
ZmZzZXQgKiA1MTI7DQo+PiArIHNlZ19zaXplID0gc2VnbWVudC5kc19sZW5ndGggKiA1MTI7DQo+
IA0KPiBVZ2guIERvIHRoaXMgaW4gdGhlIG1hcHBpbmcgY29kZSB0aGF0IGdldHMgdGhlIGV4dGVu
dCBpbmZvLiBIYXZlIGl0DQo+IHJldHVybiBieXRlcy4gT3IganVzdCB1c2UgRklFTUFQIGJlY2F1
c2UgaXQgdXNlcyBieXRlIHJhbmdlcyB0bw0KPiBiZWdpbiB3aXRoLg0KDQpPSy4NCg0KPiANCj4+
ICsNCj4+ICsgY2xvbmUuc3JjX29mZnNldCA9IHNlZ19vZmY7DQo+PiArIGNsb25lLnNyY19sZW5n
dGggPSBzZWdfc2l6ZTsNCj4+ICsgY2xvbmUuZGVzdF9vZmZzZXQgPSBzZWdfb2ZmOw0KPj4gKw0K
Pj4gKyAvKiBjaGVja3MgZm9yIEVvRiBhbmQgZml4IHVwIGNsb25lICovDQo+PiArIHN0b3AgPSBk
ZWZyYWdfY2xvbmVfZW9mKCZjbG9uZSk7DQo+IA0KPiBPaywgc28gd2UgY29weSB0aGUgc2VnbWVu
dCBtYXAgaW50byBjbG9uZSBhcmdzLCBhbmQgLi4uDQo+IA0KPj4gKyBnZXR0aW1lb2ZkYXkoJnRf
Y2xvbmUsIE5VTEwpOw0KPj4gKyByZXQgPSBpb2N0bChzY3JhdGNoX2ZkLCBGSUNMT05FUkFOR0Us
ICZjbG9uZSk7DQo+PiArIGlmIChyZXQgIT0gMCkgew0KPj4gKyBmcHJpbnRmKHN0ZGVyciwgIkZJ
Q0xPTkVSQU5HRSBmYWlsZWQgJXNcbiIsDQo+PiArIHN0cmVycm9yKGVycm5vKSk7DQo+PiArIGJy
ZWFrOw0KPj4gKyB9DQo+IA0KPiBjbG9uZSB0aGUgc291cmNlIHRvIHRoZSBzY3JhdGNoIGZpbGUu
IFRoaXMgYmxvY2tzIHdyaXRlcyB0byB0aGUNCj4gc291cmNlIGZpbGUgd2hpbGUgaXQgaXMgaW4g
cHJvZ3Jlc3MsIGJ1dCBhbGxvd3MgcmVhZHMgdG8gcGFzcw0KPiB0aHJvdWdoIHRoZSBzb3VyY2Ug
ZmlsZSBhcyBkYXRhIGlzIG5vdCBjaGFuZ2luZy4NCj4gDQo+IA0KPj4gKyAvKiBmb3IgdGltZSBz
dGF0cyAqLw0KPj4gKyB0aW1lX2RlbHRhID0gZ2V0X3RpbWVfZGVsdGFfdXMoJnRfY2xvbmUsICZ0
X3Vuc2hhcmUpOw0KPj4gKyBpZiAodGltZV9kZWx0YSA+IG1heF9jbG9uZV91cykNCj4+ICsgbWF4
X2Nsb25lX3VzID0gdGltZV9kZWx0YTsNCj4+ICsNCj4+ICsgLyogZm9yIGRlZnJhZyBzdGF0cyAq
Lw0KPj4gKyBucl9leHRfZGVmcmFnICs9IHNlZ21lbnQuZHNfbnI7DQo+PiArDQo+PiArIC8qDQo+
PiArICAqIEZvciB0aGUgc2hhcmVkIHJhbmdlIHRvIGJlIHVuc2hhcmVkIHZpYSBhIGNvcHktb24t
d3JpdGUNCj4+ICsgICogb3BlcmF0aW9uIGluIHRoZSBmaWxlIHRvIGJlIGRlZnJhZ2dlZC4gVGhp
cyBjYXVzZXMgdGhlDQo+PiArICAqIGZpbGUgbmVlZGluZyB0byBiZSBkZWZyYWdnZWQgdG8gaGF2
ZSBuZXcgZXh0ZW50cyBhbGxvY2F0ZWQNCj4+ICsgICogYW5kIHRoZSBkYXRhIHRvIGJlIGNvcGll
ZCBvdmVyIGFuZCB3cml0dGVuIG91dC4NCj4+ICsgICovDQo+PiArIHJldCA9IGZhbGxvY2F0ZShk
ZWZyYWdfZmQsIEZBTExPQ19GTF9VTlNIQVJFX1JBTkdFLCBzZWdfb2ZmLA0KPj4gKyBzZWdfc2l6
ZSk7DQo+PiArIGlmIChyZXQgIT0gMCkgew0KPj4gKyBmcHJpbnRmKHN0ZGVyciwgIlVOU0hBUkVf
UkFOR0UgZmFpbGVkICVzXG4iLA0KPj4gKyBzdHJlcnJvcihlcnJubykpOw0KPj4gKyBicmVhazsN
Cj4+ICsgfQ0KPiANCj4gQW5kIG5vdyB3ZSB1bnNoYXJlIHRoZSBzb3VyY2UgZmlsZS4gVGhpcyBi
bG9ja3MgYWxsIElPIHRvIHRoZSBzb3VyY2UNCj4gZmlsZS4NCg0KWWVzLCBldmVuIGZldGNoaW5n
IGRhdGEgZnJvbSBkaXNrIGlzIGRvbmUgd2hpbGUgSU8gaXMgbG9ja2VkLg0KSSBhbSB3b25kZXJp
bmcgaWYgd2UgY2FuIGZldGNoIGRhdGEgd2l0aG91dCBsb2NraW5nIElPLiBUaGF04oCZcyBhbHNv
IHdoeQ0KSSBhZGRlZCByZWFkYWhlYWQgaW4gYSBsYXRlciBwYXRjaC4NCg0KPiANCj4gT2ssIHNv
IHRoaXMgaXMgdGhlIGZ1bmRhbWVudGFsIHByb2JsZW0gdGhpcyB3aG9sZSAic2VnbWVudGVkDQo+
IGRlZnJhZyIgaXMgdHJ5aW5nIHRvIHdvcmsgYXJvdW5kOiBGQUxMT0NfRkxfVU5TSEFSRV9SQU5H
RSBibG9ja3MNCj4gYWxsIHJlYWQgYW5kIHdyaXRlIElPIHdoaWxzdCBpdCBpcyBpbiBwcm9ncmVz
cy4NCj4gDQo+IFdlIGhhZCB0aGlzIHNhbWUgcHJvYmxlbSB3aXRoIEZJQ0xPTkVSQU5HRSB0YWtp
bmcgc25hcHNob3RzIG9mIFZNDQo+IGZpbGVzIC0gd2UgY2hhbmdlZCB0aGUgbG9ja2luZyB0byB0
YWtlIHNoYXJlZCBJTyBsb2NrcyB0byBhbGxvdw0KPiByZWFkcyB0byBydW4gd2hpbGUgdGhlIGNs
b25lIHdhcyBpbiBwcm9ncmVzcy4gQmVjYXVzZSB0aGUgT3JhY2xlIFZtDQo+IGluZnJhc3RydWN0
dXJlIHVzZXMgYSBzaWRlY2FyIHRvIHJlZGlyZWN0IHdyaXRlcyB3aGlsZSBhIHNuYXBzaG90DQo+
IChjbG9uZSkgd2FzIGluIHByb2dyZXNzLCBubyBWTSBJTyBnb3QgYmxvY2tlZCB3aGlsZSB0aGUg
Y2xvbmUgd2FzIGluDQo+IHByb2dyZXNzIGFuZCBzbyB0aGUgYXBwbGljYXRpb25zIGluc2lkZSB0
aGUgVk0gbmV2ZXIgZXZlbiBub3RpY2VkIGENCj4gY2xvbmUgd2FzIHRha2luZyBwbGFjZS4NCj4g
DQo+IFdoeSBpc24ndCB0aGUgc2FtZSBpbmZyYXN0cnVjdHVyZSBiZWluZyB1c2VkIGhlcmU/DQo+
IA0KPiBGQUxMT0NfRkxfVU5TSEFSRV9SQU5HRSBpcyBub3QgY2hhbmdpbmcgZGF0YSwgbm9yIGlz
IGl0IGZyZWVpbmcgYW55DQo+IGRhdGEgYmxvY2tzLiBZZXMsIHdlIGFyZSByZS13cml0aW5nIHRo
ZSBkYXRhIHNvbWV3aGVyZSBlbHNlLCBidXQNCj4gaW4gdGhhdCBjYXNlIHRoZSBvcmlnaW5hbCBk
YXRhIGlzIHN0aWxsIGludGFjdCBpbiBpdCdzIG9yaWdpbmFsDQo+IGxvY2F0aW9uIG9uIGRpc2sg
YW5kIG5vdCBiZWluZyBmcmVlZC4NCj4gDQo+IEhlbmNlIGlmIGEgcmVhZCByYWNlcyB3aXRoIFVO
U0hBUkUsIGl0IHdpbGwgaGl0IGEgcmVmZXJlbmNlZCBleHRlbnQNCj4gY29udGFpbmluZyB0aGUg
Y29ycmVjdCBkYXRhIHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciBpdCBpcyBpbiB0aGUgb2xkDQo+IG9y
IG5ldyBmaWxlLiBIZW5jZSB3ZSBjYW4gbGlrZWx5IHVzZSBzaGFyZWQgSU8gbG9ja2luZyBmb3Ig
VU5TSEFSRSwNCj4ganVzdCBsaWtlIHdlIGRvIGZvciBGSUNMT05FUkFOR0UuDQo+IA0KPiBBdCB0
aGlzIHBvaW50LCBpZiB0aGUgT3JhY2xlIFZNIGluZnJhc3RydWN0dXJlIHVzZXMgdGhlIHNpZGVj
YXINCj4gd3JpdGUgY2hhbm5lbCB3aGlsc3QgdGhlIGRlZnJhZyBpcyBpbiBwcm9ncmVzcywgdGhp
cyB3aG9sZSBhbGdvcml0aG0NCj4gc2ltcGx5IGJlY29tZXMgImZvciByZWdpb25zIHdpdGggZXh0
ZW50cyBzbWFsbGVyIHRoYW4gWCwgY2xvbmUgYW5kDQo+IHVuc2hhcmUgdGhlIHJlZ2lvbiIuDQo+
IA0KPiBUaGUgd2hvbGUgbmVlZCBmb3IgImlkbGUgdGltZSIgZ29lcyBhd2F5LiBUaGUgbmVlZCBm
b3Igc2VnbWVudCBzaXplDQo+IGNvbnRyb2wgbGFyZ2VseSBnb2VzIGF3YXkuIFRoZSBuZWVkIHRv
IHR1bmUgdGhlIGRlZnJhZyBhbGdvcml0aG0gdG8NCj4gYXZvaWQgSU8gbGF0ZW5jeSBhbmQvb3Ig
dGhyb3VnaHB1dCBpc3N1ZXMgZ29lcyBhd2F5Lg0KPiANCg0KQXMgd2UgdGVzdGVkLCB0aGUgd3Jp
dGUtcmVkaXJlY3RpbmcgZG9lc27igJl0IHdvcmsgd2VsbC4NCg0KDQo+PiArDQo+PiArIC8qIGZv
ciB0aW1lIHN0YXRzICovDQo+PiArIHRpbWVfZGVsdGEgPSBnZXRfdGltZV9kZWx0YV91cygmdF91
bnNoYXJlLCAmdF9wdW5jaF9ob2xlKTsNCj4+ICsgaWYgKHRpbWVfZGVsdGEgPiBtYXhfdW5zaGFy
ZV91cykNCj4+ICsgbWF4X3Vuc2hhcmVfdXMgPSB0aW1lX2RlbHRhOw0KPj4gKw0KPj4gKyAvKg0K
Pj4gKyAgKiBQdW5jaCBvdXQgdGhlIG9yaWdpbmFsIGV4dGVudHMgd2Ugc2hhcmVkIHRvIHRoZQ0K
Pj4gKyAgKiBzY3JhdGNoIGZpbGUgc28gdGhleSBhcmUgcmV0dXJuZWQgdG8gZnJlZSBzcGFjZS4N
Cj4+ICsgICovDQo+PiArIHJldCA9IGZhbGxvY2F0ZShzY3JhdGNoX2ZkLA0KPj4gKyBGQUxMT0Nf
RkxfUFVOQ0hfSE9MRXxGQUxMT0NfRkxfS0VFUF9TSVpFLCBzZWdfb2ZmLA0KPj4gKyBzZWdfc2l6
ZSk7DQo+PiArIGlmIChyZXQgIT0gMCkgew0KPj4gKyBmcHJpbnRmKHN0ZGVyciwgIlBVTkNIX0hP
TEUgZmFpbGVkICVzXG4iLA0KPj4gKyBzdHJlcnJvcihlcnJubykpOw0KPj4gKyBicmVhazsNCj4+
ICsgfQ0KPiANCj4gVGhpcyBpcyB1bm5lY2Vzc2FyeSBpZiB0aGVyZSBpcyBsb3RzIG9mIGZyZWUg
c3BhY2UuIFlvdSBjYW4gbGVhdmUNCj4gdGhpcyB0byB0aGUgdmVyeSBlbmQgb2YgZGVmcmFnIHNv
IHRoYXQgdGhlIHNvdXJjZSBmaWxlIGRlZnJhZw0KPiBvcGVyYXRpb24gaXNuJ3Qgc2xvd2VkIGRv
d24gYnkgY2xlYW5pbmcgdXAgYWxsIHRoZSBmcmFnbWVudGVkDQo+IGV4dGVudHMuLi4uDQoNClll
cy4gVHdvIGNvbnNpZGVyYXRpb25zIGhlcmU6DQoxLiBUaGUgc3BhY2UgdXNlIGFzIHlvdSBtZW50
aW9uZWQsIHRoZSB0ZW1wIGZpbGUgbWlnaHQgZ3JvdyBodWdlIG9uIGEgbG93IHNwYWNlIHN5c3Rl
bS4NCjIuIFB1bmNoaW5nIGhvbGVzIG9uIHRoZSB0ZW1wIGZpbGUgZG9lc27igJl0IGxvY2sgdGhl
IGZpbGUgdW5kZXIgZGVmcmFnLCBzbyB3aXRoIHRoZSBQVU5DSF9IT0xFLA0Kd2UgbmVlZCBhIGxp
dHRsZSBiaXQgbGVzcyBzbGVlcCB0aW1lIGZvciBlYWNoIHNlZ21lbnQuDQoNClRoYW5rcywNCldl
bmdhbmcNCg0K

