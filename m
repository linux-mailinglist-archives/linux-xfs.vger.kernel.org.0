Return-Path: <linux-xfs+bounces-20978-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA70CA6AB51
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Mar 2025 17:45:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80B8398037B
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Mar 2025 16:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37DB21D3F9;
	Thu, 20 Mar 2025 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HDBW9xA/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pwF7007J"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6581817591;
	Thu, 20 Mar 2025 16:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742489125; cv=fail; b=NoG+iVAHffMJtWQ7vbWo7CcsbcWaLFx5Femf9rvhnfb9nGJLYh2olPERyODGb5p9FH5VdGD6SmRYbGAAHWV4WgeHuhxF6i0kGBI2kZbnpY6xb9yEutYd5JjzDMqMD/EQlEONGYYV+CJtOYcAyUYgyU2qHYfVBqKHoWE7sK49h8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742489125; c=relaxed/simple;
	bh=rWRnYE3r+SJcP9jyipfnnw4JYCddCqJoebAvQ4SxkxY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CyQmLTJJtbesAayK9Pgl0p+mvZknnzyYDS/qCfzbs+O/8fHBwFRysjj8UH7JqLoQ8njle3mtLBRQEbQvFFx4LWRUKnGp76iIUFIqtJtwY3D8HA9CWggTQYIRXsQYs3g81jFCycnER8PkDUwlksYFeUO/HrrvgaVoNZuwZXGqqTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HDBW9xA/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pwF7007J; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KGisc3011233;
	Thu, 20 Mar 2025 16:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=rWRnYE3r+SJcP9jyipfnnw4JYCddCqJoebAvQ4SxkxY=; b=
	HDBW9xA/UkYaDewQtd698Lv7KYgyJxMwT02ozm+uyDYYG7kaeIk3Z7d2nEp8EuV/
	MJkuk+OotVQ2pcPB++V2im5lMguyKgNUeXiJhxszUuscj8qMVUOaFUSa5WrLkuvN
	NxadWN3dIihT618odAIiGIfSSJ7y20ycpnsNNxYRqSsvfkm0YsxCK2T8bt9PHTW4
	fMrSXFtHZHNywTBgGL+3W+EurnndaPZH5WYOvVpXkppe807ugLoIdYrfK2miCJlj
	e99zRDwiiyfqciK0cywRdcqVNaiPWSbP31vPu+59P2txBYjj2+v9esB29c2B4E+q
	E+k++GGiw6A8Ies/Le99dA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1n8pgew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 16:45:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KFWExG024449;
	Thu, 20 Mar 2025 16:45:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxbmph47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 16:45:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zIV0DD/173TaDk+weuLuR7OaGdYbIiUiaMRcOdZC1YlCHvDyZO+kMpkc0C17X884d+BuW4sVJE2G9QXc/Mwc7u3GZ0YutYYs5k7PrJXjIKgkZicWxmWgMjo4EMhSrlBCV0gO4NmTYsAxHYxivsvRR1/CdksaZ0NE/iKDJOq4bW0H/bYR64OQjEJN/u63FlbUMTzXptVG1pSRvW8c9En+rJKP7nS6gSxIPa6en4FASs6H5PG9lQJNhXp3D71hNL0v/fvE9ntBWLkMJ5t21DOSskv2rvzZMYryg6AJzvst1avFtvWS5zu3VHkMetY4p+TKutcBdAA8h/zz2SLedWRePw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWRnYE3r+SJcP9jyipfnnw4JYCddCqJoebAvQ4SxkxY=;
 b=W73uUEzWRB1BSzP89uBSvDOU2JG4PhdZQYTJxN9I6jd0DuFAwNgqD2ZSZ7U7XKypgOhPMmUp6HniWHspKY03dSBg+0n3C5SLH83hzFLiHkvdSmkcu3vK47go6SsifuKtmSEBHqz+yCZLiWXPC8pB+H/FGuJcARmJ7zBIEwLWy3VERrUXb6Poo7pz1xSU8Lxsia7OYw0yL42G8ZGWzvSkW9wxtdjSRy6FBcgO2yBrtaOr57XndUkzLPaaoV7Au+QsyYYOqWLy0EylTgu+i632qLo6Eus2iPJeL1i0SfdQYxcqeOFwUoMO6E4eJ0eZIZ88XAIPE7KhewQRaNdOkFXlWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWRnYE3r+SJcP9jyipfnnw4JYCddCqJoebAvQ4SxkxY=;
 b=pwF7007JDldVOUKk9qA4zH0UxDS93QEU+hkdAJceNj3HgtRK2b2bue43me5cUf6wKErTdY0EEVwfBrh0w6Ji3NMaJqSXMhFi7GoSZVCbrvRlsKKS7RR2bfXhd5RQyJWS9mP2TQjCErjcpQHOYQ62cwD28+k368hqlhCprhwIeVc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Thu, 20 Mar
 2025 16:45:12 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8534.036; Thu, 20 Mar 2025
 16:45:12 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: Zorro Lang <zlang@redhat.com>
CC: "Darrick J. Wong" <djwong@kernel.org>,
        "Nirjhar Roy (IBM)"
	<nirjhar.roy.lists@gmail.com>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
Thread-Topic: [PATCH v3] xfs: add a test for atomic writes
Thread-Index: AQHbmbdzUAnPHwYlXU2euo3rAPnczw==
Date: Thu, 20 Mar 2025 16:45:12 +0000
Message-ID: <62A77530-A67F-41DD-9831-E4CC7B78A36D@oracle.com>
References: <20250228002059.16750-1-catherine.hoang@oracle.com>
 <20250228021156.GX6242@frogsfrogsfrogs>
 <c95b0a815dc9ccfe6172b589c5d4810147dcc207.camel@gmail.com>
 <20250228154335.GZ6242@frogsfrogsfrogs>
 <DABD5AF4-1711-495C-8387-CB628A2B728D@oracle.com>
 <20250304084712.xmodkmfbtyf4rf73@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ED93C558-F1A4-4CAC-91C2-D0763CF1D26C@oracle.com>
In-Reply-To: <ED93C558-F1A4-4CAC-91C2-D0763CF1D26C@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.200.121)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|SJ0PR10MB5549:EE_
x-ms-office365-filtering-correlation-id: 669d1b1d-619e-447f-5051-08dd67ce9592
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?anNjQ0ltVWZXTnQrdlVLSzM2OEN6M2hITWZqQ0FkOU8vSzZPRkhubXFJc2lx?=
 =?utf-8?B?b1BlRDJQOU15Rm5WTEkvOUg1aXB3ckREVmhjcm52d3hDOWx4allDdlEvclAw?=
 =?utf-8?B?dXBzT3pOaUltaS9Kd3MxRFhCSzZxdVhRa2FLOCt6VzA3aTQxdFk0bE8xN3Jt?=
 =?utf-8?B?K3JZbUh3VmFjQ3VBVjNhZkVEaVFoUG8yV0NtRkdSbFdmQTRzQ29MQWx2MjMv?=
 =?utf-8?B?Z3RSaUZENm1CN1dESElvSkF6dm1qMUVqWVVzM1RrZ0NGSUdLMWJldHFNYzc3?=
 =?utf-8?B?SW9HTXRVZks0ck51TGxKZnpZeW9hRHNmUnNaeXhlNnFDdlB0bWQyazdzdFNn?=
 =?utf-8?B?UEFQOGwwaFdXQlUwWldHN0ExNlRqMXpaTTM0UXpHdGtIbWFFU0dZektrRk5J?=
 =?utf-8?B?QitFRklPeUlXWmVGTTA5aU1ZNWZkQitibTk1dzUwWXRYSTJ1THVLZkZYNkxL?=
 =?utf-8?B?QitkVDVlWHR2Qk5HOXlCR0JzWWVkbXBaOFRHRkdBUXdqZk9TYlNmMlFWaG9w?=
 =?utf-8?B?YVZSbjBhSE1TR1BrQ01LaEl2ZFkvYnV6bTFpNmladDlWejNrMHpkL29raVdh?=
 =?utf-8?B?WUdZN3QrTGZ4RHoxby9YbkM3T0NWaCs4cjZRMDRwcDNLYnZubXdrQUxRVE10?=
 =?utf-8?B?RkJ4aVAySzJJWU01NVFlRDh3Z2VPTHVHNCtTdEgxRFB6QUY2QlRmNzFONEFn?=
 =?utf-8?B?QWpValZ2SVNGaGtZQ1ZGbm43ZjFnandVZE5kUGlXY0JnQVU1TFdFcW1FMkho?=
 =?utf-8?B?OVZWQUh0eWNpcUF2cUo5VUh2YTR6WkV4Z3NWU3lUMzNhdUw4K0txelN3cEt1?=
 =?utf-8?B?V3gycFFyUHU5SzhRUmJsVTVMSXhDRENEcUdUZUN3d042MzZSdFpmTGRTSlRq?=
 =?utf-8?B?aVJxbS9qWnNoZy8zMmJpenkxRHVYbWM3OW5wMUIzaXN4VldpMlBibEpXVWMr?=
 =?utf-8?B?Nm1tM0Y2b2hGdSt6VDZPMHlDNGRWdjdQZWlRMTNCMm1uQ2s1MEpndDEyTTNJ?=
 =?utf-8?B?ai9PajFEc3VYMWtIUE5XL0ppelowbm5tN1NBemx6eWpnckhURXBHY1NXbW5G?=
 =?utf-8?B?Mnc4cFZUbFVxclNEdXEyU1FCRkNGMStYVjI2T1UxNjdWYVZYZjdSaHBORWJW?=
 =?utf-8?B?N0VBMjJNeVZ2aVdUTzVmTTdOaHlDZEVkUHpWYjBzRW50cmR0MVk0dTBoL1Iv?=
 =?utf-8?B?ZUNKNG9udmIrOFhBWldYWkpSNVdHZGFwME5UTmpmSXQwYkJCTUxFSHF1RGRa?=
 =?utf-8?B?VkpUSDRWMHRUcVhJL2VCWHMrMFNIeHpiZ25na0lSNzFQSkppelNRWEVsblBq?=
 =?utf-8?B?amk4WVd1dFozc3VNN1JtZUY1YnJMYjRhQTY4SW1Dd29xeHAxVGpvd3FIRkdF?=
 =?utf-8?B?L0w3SXlKSDRFcHpNNWZvdzNmS3VGR1FYcEdMTFIwRUpLejZ1N2YxbnN0bElh?=
 =?utf-8?B?TVUyN3hrcFZMOHJWSGZVdzdVQnNQWDNNNnQwR25KZHhvR3lKam1jY3dzVE1w?=
 =?utf-8?B?bEwyNEk0ZTV6UVZkWTVKNjZIZTRoOGtJeTFwbzlaZitJYUROZUJWeTI1RUts?=
 =?utf-8?B?QW1JeDRDaVFkRWRRV0VzZDNkN205NnZKd3VIMTR4UXFVOFBWdncwdXFYWGY4?=
 =?utf-8?B?dGJOR0tTRDJHUE00b21LbnBXMXRrd0NnaFhOK1VRc2N4ek5ZbzdRVXN2MEhX?=
 =?utf-8?B?cGZvZEdvU3BVNDRYcDBuQjNCLzBkRnpPWmNpaGg3M2VBZTFFZHAzcC8wd3JE?=
 =?utf-8?B?U3ZndVFleEJjSEJ4NGFDdTJKeEVqOXJwVVhacVF0Wk5vU2ZuUjJVUjh1MWtK?=
 =?utf-8?B?U1haSExtS3laUG4yTWs0SHlJU0xSY2w4L3MySmtWSmdWZ0hjQm1OUzFabENo?=
 =?utf-8?B?ZmdrbXFESVRlajljK1ZzQzQyWm1nNG5HWXI3WlVSZFBQZXRzaXZwWG1KQkpD?=
 =?utf-8?Q?rPcIKb9EkzjHH8/NgmfgGRGvXUb5RY4/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M3l1UkhaRjlSaWtzNExwc2FvQm4xYWFhaTc0TExVZ3VnKzdFZWxNQkpLWFhx?=
 =?utf-8?B?STNTMDB1TThSeWJOWlZrdHlvN0VUTDVSTXFveURzQVdVVXhVbjJna0JsZ2xP?=
 =?utf-8?B?aE45L09JcTJrUDlZMk9xSkpYdUIyT0tuWkw0YWRIUWFPVDZ4T2xNbkxRZHoz?=
 =?utf-8?B?ajkxSHVSanN2VXFLSWNiS3E5ejJPMzVNcjVWZFQwM0NyTGZ5RmNvQmNMdzZx?=
 =?utf-8?B?Y1l3MVA0bGVlT3cwYTdESHI3ZTdNZFBUWmMySk9KSmpndWVzZ1d3REtrdmNQ?=
 =?utf-8?B?em1vNHdpUkRwakRPaTJGQkN1ckdoYUJ6TFhrZ3hhQW9XZzk1bi9mU0l5MHA0?=
 =?utf-8?B?QTBoa0hHaExwVmh3aXVISkp5YXpoMmtRd0FTZTFVaW0zYXhOS3pRbHc5bXg3?=
 =?utf-8?B?YmRUdzRDeEFOQWh4TXU3ekQ5RGhaa2FvSkJhTkFTU1NQNVpyeEZWZ01ZUEx3?=
 =?utf-8?B?QmNrYWNBSzQxRHJEUjh0Z2RqbFBCTnBXcWZCVDE0SDUyV05kRlhDMmozdit5?=
 =?utf-8?B?MklSdUpoWGhlZi9YRVMrRDJ3a3BLcmh4L0NRTHR5ckNTZWR3Tm9nbnhqTG1x?=
 =?utf-8?B?cGFyd0VocFpjVGNrT2V0ZHdVYUIwUTZ5OXZ2TE9YUTJJQUtSWDJVNENWdXQ5?=
 =?utf-8?B?amY3RmxHeUl2NkZ6YlJRVVNNWTF5UWFVYVMxSW1BcjlrNmFlQ0o1c1RVbHdq?=
 =?utf-8?B?YkNWTDlxTXhFaTNQN0Z5VkFQYnlma2hxaEhDd1FmT2w1WXJTTlhSRFNnM1RG?=
 =?utf-8?B?MC8wVWxjZUs3Y2l6U3hUMWZLUnJDYXYxT2J5QWpJYUoxTWo3K3VOVUtkb3Fp?=
 =?utf-8?B?NjF4bzNUS1ZDU3loem9QeVJ0YWZhZjVQM1E2cmpvdW1wL1g1OWhmZVpNcUhP?=
 =?utf-8?B?bzIySlp6MHl1eFd1WWQvclBYaFZaNkcxUUhVSklXUlZ2MEd6clB0YUJtSkRG?=
 =?utf-8?B?MDFZUFBQc0wvMVhqenFOQ0RNSWN4N3NqNS9TRWdOdDFLOEZhVGlFUnE3bFNh?=
 =?utf-8?B?Zm5zck5XRmtneExoQW56ZnBHT2xuNnBHYm5WR3dMOWMyYUxEMzhFd0tMTE5s?=
 =?utf-8?B?SUZmcnV1OTBWem83bHBRSjExbVltTy8xOWNCQS9pM2JpUndHQ0N3SFFyUkpq?=
 =?utf-8?B?ZG5CWk5ITUFDaXJUZW9yeURNM25XVHdnZWZuSGVubnlnTS9JNklteDdEYXdi?=
 =?utf-8?B?MVJEMmkyTDV0R1psWWd2QXdzTXV1aUdVOFNTZ1EvUXo0TFE2QmRGQzBUUFpu?=
 =?utf-8?B?RG8wLzdQREZNQ0VBaklXV0FsSjNsNFpBRXkwMWluK0thRU5MblhSd21rUVpi?=
 =?utf-8?B?Ulp1WHFaS0UrTmRhV0FLeDU4QnpWZjBoYXBYV2RTbDFyRmhKbEtSSE9vNHBj?=
 =?utf-8?B?MzEvQ2wrOHlyOFZ1NFhtdVNzWkNIc1BLRk9yMWpHYlZUelc3RDQwUi9haC9I?=
 =?utf-8?B?RnE3S1VhaWZLbitlT0RPT00xUnE1ZUdpVEg2c0VYWWordjQ4ZGZ6TFJlZUxM?=
 =?utf-8?B?REtJci9DQnI0Tkk3VlBtcG1aQk5XbEZDNEZ3QkdHVjdpemh2bEJvQkxqbEJ2?=
 =?utf-8?B?Y01UQm83blUrOHAzYTc1QUxObkNnMTNpcGVoYUo1TGZHVHBNL1NZSVBzU1p2?=
 =?utf-8?B?SENoS0JOTXpPbGl3RFBucUtxQnBORlh5cDdSMGY0LzJXdWwzaFc1bThMSG15?=
 =?utf-8?B?QUp1dklRQmNyY0VUd1dxRG9KUnAveDZ1eU03b0JxY2lTdCtTankycHpNMCtC?=
 =?utf-8?B?b00zUEpHVE1uMm41NmJjcVR3MWN6L29ZekhoUVlUb1EweHBya3JBdU50b1VW?=
 =?utf-8?B?c0g3ZGRGenZ3U2p5bklOKzYzcHZBV1ZoTFBLckc2YmZrMzUwR20zbU80VFdn?=
 =?utf-8?B?bTF0M1pwN1FWTVI1U3VyRGRsQVhxSGx1Y1prSTE2MFFVZk9zWWRqd3Z4ZXNh?=
 =?utf-8?B?STNLZlFuVW9tT3QvNFBYd2kwdHVGYzM0YmNXcFFNMjViR1JUSEdUM0dWMVl1?=
 =?utf-8?B?aDJmVFJFbVEzL2RVWEtVUTFiSEVZOUVIUERJZWdBNEYrWkVHUmpOaWlWNFY1?=
 =?utf-8?B?MHA2c2NGbHEvUDlHcTg4WVgrdU1YQkJhcHRyMGxvdTdQVlBNMWdPSDVXcm5z?=
 =?utf-8?B?UkRjd2FqTkRubUdJL0s3Wk85ODNqdjRGU0p5eW1XaFhJSWtueUtIWjlGcTND?=
 =?utf-8?B?M0hDYXAyMnphR01Lb2h0WVFLbmlYU0xYakw4YWhMK2R4WjR5UlFSQlNxODdH?=
 =?utf-8?B?dXRsUUxZUVRzNUtQVFdQYkUzSUVnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DA0C3B40876EE4DB28DA648BAA6B065@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MP8WL9rgqAWBPjbZerOSiGpmvuBw/EvoSkbOC+5v7TKAcBNOGe+DMLhD+XXt434vlJImXlxPLt4FfsoEKAvcV7AxjrtLrgAZM6sJVPpjr5ffn/WdOzf34qYYPXQ3iOhLHuoxUg8+ycdNV873vT10Y9/EeGp/mKEsheaOr+/IpfIOBd30BXEIYKbYt5pKTAT6XoRP/xqFXScbfCX7L7KTdiSNmkgh2vlWNwRKO3snX0EjRFW+NTu5ftaAeMjFz5zVb2yPZkqNdeuPPGaEdrZwhlWmKYvMe7NwEt6IhX0Bi6wiu2/GbZnx6zYWs4XpWqot2/e8JH+I1WpP17vXeyvirZSwjwk3DvsE+BEEP7eyaTqLRKB/deuJ1QLZZ9exMPsgi90cDzKU2wmuGPN1WuBC543tzsSfsq9inHVj51RPnFkLyZD5cyJGXUIsbjYGj3QGYVM2VljpYFOJwd6lfY1C1usrUYjfofAC7npi1CzTnq9TNwBXqVYcBkzTu/hLwbZhiIX8VuRqupI8sO7dTIZ6DF9jbaH8s3rtVsWxvyzj+4M1b+JhhBZLZUb5R06gtjrB+4y4Kk/JwcQ6S2Lk/2iRfdSRZdUEValHdfoIlNI0dsM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669d1b1d-619e-447f-5051-08dd67ce9592
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2025 16:45:12.6660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3LFTs9O9wxWJLHJyoL63xN80oLSQr1Y8DUGPxeicGc0J5unkFc12EhFNa7TACJV25aZnzQrW2AA8O17UI4niT1pDCgzHEOAJqWfnBodMWl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_04,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503200106
X-Proofpoint-ORIG-GUID: FDCbJIdpv_brvKdwy5qfhZTBRfY5YSoz
X-Proofpoint-GUID: FDCbJIdpv_brvKdwy5qfhZTBRfY5YSoz

PiBPbiBNYXIgNCwgMjAyNSwgYXQgMzo0N+KAr1BNLCBDYXRoZXJpbmUgSG9hbmcgPGNhdGhlcmlu
ZS5ob2FuZ0BvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+PiANCj4+IE9uIE1hciA0LCAyMDI1LCBh
dCAxMjo0N+KAr0FNLCBab3JybyBMYW5nIDx6bGFuZ0ByZWRoYXQuY29tPiB3cm90ZToNCj4+IA0K
Pj4gT24gTW9uLCBNYXIgMDMsIDIwMjUgYXQgMTA6NDI6NDRQTSArMDAwMCwgQ2F0aGVyaW5lIEhv
YW5nIHdyb3RlOg0KPj4+IA0KPj4+IA0KPj4+PiBPbiBGZWIgMjgsIDIwMjUsIGF0IDc6NDPigK9B
TSwgRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4+IA0KPj4+
PiBPbiBGcmksIEZlYiAyOCwgMjAyNSBhdCAwNzowMTo1MFBNICswNTMwLCBOaXJqaGFyIFJveSAo
SUJNKSB3cm90ZToNCj4+Pj4+IE9uIFRodSwgMjAyNS0wMi0yNyBhdCAxODoxMSAtMDgwMCwgRGFy
cmljayBKLiBXb25nIHdyb3RlOg0KPj4+Pj4+IE9uIFRodSwgRmViIDI3LCAyMDI1IGF0IDA0OjIw
OjU5UE0gLTA4MDAsIENhdGhlcmluZSBIb2FuZyB3cm90ZToNCj4+Pj4+Pj4gQWRkIGEgdGVzdCB0
byB2YWxpZGF0ZSB0aGUgbmV3IGF0b21pYyB3cml0ZXMgZmVhdHVyZS4NCj4+Pj4+Pj4gDQo+Pj4+
Pj4+IFNpZ25lZC1vZmYtYnk6IENhdGhlcmluZSBIb2FuZyA8Y2F0aGVyaW5lLmhvYW5nQG9yYWNs
ZS5jb20+DQo+Pj4+Pj4+IFJldmlld2VkLWJ5OiBOaXJqaGFyIFJveSAoSUJNKSA8bmlyamhhci5y
b3kubGlzdHNAZ21haWwuY29tPg0KPj4+Pj4+IA0KPj4+Pj4+IEVyLi4uLiB3aGF0IGdpdCB0cmVl
IGlzIHRoaXMgYmFzZWQgdXBvbj8gIGdlbmVyaWMvNzYyIGlzIGEgcHJvamVjdA0KPj4+Pj4+IHF1
b3RhDQo+Pj4+Pj4gdGVzdC4NCj4+Pj4+IE9uIHdoaWNoIGJyYW5jaCBkbyB5b3UgaGF2ZSB0ZXN0
cy9nZW5lcmljLzc2Mj8gSSBjaGVja2VkIHRoZSBsYXRlc3QNCj4+Pj4+IG1hc3Rlcihjb21taXQg
LSA4NDY3NTUyZjA5ZTE2NzJhMDI3MTI2NTNiNTMyYTg0YmQ0NmVhMTBlKSBhbmQgdGhlIGZvci0N
Cj4+Pj4+IG5leHQoY29tbWl0IC0gNWI1NmEyZDg4ODE5MWJmYzcxMzFiMDk2ZTYxMWVhYjE4ODFk
ODQyMikgYW5kIGl0IGRvZXNuJ3QNCj4+Pj4+IHNlZW0gdG8gZXhpc3QgdGhlcmUuIEhvd2V2ZXIs
IHRlc3RzL3hmcy83NjIgZG9lcyBleGlzdC4NCj4+Pj4gDQo+Pj4+IFpvcnJvJ3MgcGF0Y2hlcy1p
bi1xdWV1ZSwgYWthIHdoYXRldmVyIGdldHMgcHVzaGVkIHRvIGZvci1uZXh0IG9uDQo+Pj4+IFN1
bmRheS4gIA0KPj4+IA0KPj4+IFRoaXMgdGVzdCB3YXMgYmFzZWQgb24gZm9yLW5leHQsIEkgd2Fz
buKAmXQgYXdhcmUgdGhlcmUgd2FzIGFub3RoZXINCj4+PiBicmFuY2guIEkgd2lsbCByZWJhc2Ug
dGhpcyBvbnRvIHBhdGNoZXMtaW4tcXVldWUuDQo+PiANCj4+IEkgY2FuIGhlbHAgdG8gZGVhbCB3
aXRoIHRoZSBjYXNlIG51bWJlciBjb25mbGljdCB0b28uIEl0J3MgZ29vZCB0byBtZSBpZg0KPj4g
eW91ciBwYXRjaCBpcyBiYXNlIG9uIGZvci1uZXh0LCBpZiB5b3UgZG9uJ3QgbmVlZCB0byBkZWFs
IHdpdGggc29tZQ0KPj4gY29uZmxpY3RzIHdpdGggb3RoZXIgImluLXF1ZXVlIiBwYXRjaGVzLCBv
ciBwcmUtdGVzdCB1bi1wdXNoZWQgcGF0Y2hlcyA6KQ0KPiANCj4gU291bmRzIGdvb2QsIHRoYW5r
cyBmb3IgbGV0dGluZyBtZSBrbm93ISBJIHdpbGwgbGVhdmUgdGhpcyBwYXRjaCBhcy1pcw0KPiB0
aGVuLCB1bmxlc3MgdGhlcmUgYXJlIGFueSBvdGhlciBjb21tZW50cyBvbiBpdC4NCg0KSGkgWm9y
cm8sDQoNCkkgd2FzIHdvbmRlcmluZyBpZiB0aGVyZeKAmXMgYSBjaGFuY2UgdGhpcyB0ZXN0IHdv
dWxkIGJlIHBpY2tlZCB1cA0Kc29vbj8gT3IgaWYgdGhlcmXigJlzIGFueSBjaGFuZ2VzIEkgbmVl
ZCB0byBtYWtlIHRvIGdldCB0aGlzIHJlYWR5DQp0byBiZSBtZXJnZWQ/DQoNClRoYW5rcywNCkNh
dGhlcmluZQ0KPj4gDQo+PiANCj4+IA0KPj4gVGhhbmtzLA0KPj4gWm9ycm8NCj4+IA0KPj4+PiBN
eSBjb25mdXNpb24gc3RlbXMgZnJvbSB0aGlzIHBhdGNoIG1vZGlmeWluZyB3aGF0IGxvb2tzIGxp
a2UgYW4NCj4+Pj4gZXhpc3RpbmcgYXRvbWljIHdyaXRlcyB0ZXN0LCBidXQgZ2VuZXJpYy83NjIg
aXNuJ3QgdGhhdCB0ZXN0IHNvIG5vdyBJDQo+Pj4+IGNhbid0IHNlZSBldmVyeXRoaW5nIHRoYXQg
dGhpcyB0ZXN0IGlzIGV4YW1pbmluZy4NCj4+PiANCj4+PiBJIGRvbuKAmXQgdGhpbmsgdGhlIGF0
b21pYyB3cml0ZXMgdGVzdCB3YXMgZXZlciBtZXJnZWQsIHVubGVzcyBJIG1pc3NlZCBpdD8NCj4+
Pj4gDQo+Pj4+IChJIHN1Z2dlc3QgZXZlcnlvbmUgcGxlYXNlIHBvc3QgdXJscyB0byBwdWJsaWMg
Z2l0IHJlcG9zIHNvIHJldmlld2Vycw0KPj4+PiBjYW4gZ2V0IGFyb3VuZCB0aGVzZSBzb3J0cyBv
ZiBpc3N1ZXMgaW4gdGhlIGZ1dHVyZS4pDQo+Pj4+IA0KPj4+PiAtLUQNCj4+Pj4gDQo+Pj4+PiAt
LU5SDQo+Pj4+Pj4gDQo+Pj4+Pj4gLS1EDQo+Pj4+Pj4gDQo+Pj4+Pj4+IC0tLQ0KPj4+Pj4+PiBj
b21tb24vcmMgICAgICAgICAgICAgfCAgNTEgKysrKysrKysrKysrKysNCj4+Pj4+Pj4gdGVzdHMv
Z2VuZXJpYy83NjIgICAgIHwgMTYwDQo+Pj4+Pj4+ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPj4+Pj4+PiB0ZXN0cy9nZW5lcmljLzc2Mi5vdXQgfCAgIDIgKw0K
Pj4+Pj4+PiAzIGZpbGVzIGNoYW5nZWQsIDIxMyBpbnNlcnRpb25zKCspDQo+Pj4+Pj4+IGNyZWF0
ZSBtb2RlIDEwMDc1NSB0ZXN0cy9nZW5lcmljLzc2Mg0KPj4+Pj4+PiBjcmVhdGUgbW9kZSAxMDA2
NDQgdGVzdHMvZ2VuZXJpYy83NjIub3V0DQo+Pj4+Pj4+IA0KPj4+Pj4+PiBkaWZmIC0tZ2l0IGEv
Y29tbW9uL3JjIGIvY29tbW9uL3JjDQo+Pj4+Pj4+IGluZGV4IDY1OTJjODM1Li4wOGE5ZDliOCAx
MDA2NDQNCj4+Pj4+Pj4gLS0tIGEvY29tbW9uL3JjDQo+Pj4+Pj4+ICsrKyBiL2NvbW1vbi9yYw0K
Pj4+Pj4+PiBAQCAtMjgzNyw2ICsyODM3LDEwIEBAIF9yZXF1aXJlX3hmc19pb19jb21tYW5kKCkN
Cj4+Pj4+Pj4gb3B0cys9IiAtZCINCj4+Pj4+Pj4gcHdyaXRlX29wdHMrPSItViAxIC1iIDRrIg0K
Pj4+Pj4+PiBmaQ0KPj4+Pj4+PiArIGlmIFsgIiRwYXJhbSIgPT0gIi1BIiBdOyB0aGVuDQo+Pj4+
Pj4+ICsgb3B0cys9IiAtZCINCj4+Pj4+Pj4gKyBwd3JpdGVfb3B0cys9Ii1EIC1WIDEgLWIgNGsi
DQo+Pj4+Pj4+ICsgZmkNCj4+Pj4+Pj4gdGVzdGlvPWAkWEZTX0lPX1BST0cgLWYgJG9wdHMgLWMg
XA0KPj4+Pj4+PiAgICAgICJwd3JpdGUgJHB3cml0ZV9vcHRzICRwYXJhbSAwIDRrIiAkdGVzdGZp
bGUNCj4+Pj4+Pj4gMj4mMWANCj4+Pj4+Pj4gcGFyYW1fY2hlY2tlZD0iJHB3cml0ZV9vcHRzICRw
YXJhbSINCj4+Pj4+Pj4gQEAgLTUxNzUsNiArNTE3OSw1MyBAQCBfcmVxdWlyZV9zY3JhdGNoX2J0
aW1lKCkNCj4+Pj4+Pj4gX3NjcmF0Y2hfdW5tb3VudA0KPj4+Pj4+PiB9DQo+Pj4+Pj4+IA0KPj4+
Pj4+PiArX2dldF9hdG9taWNfd3JpdGVfdW5pdF9taW4oKQ0KPj4+Pj4+PiArew0KPj4+Pj4+PiAr
ICRYRlNfSU9fUFJPRyAtYyAic3RhdHggLXIgLW0gJFNUQVRYX1dSSVRFX0FUT01JQyIgJDEgfCBc
DQo+Pj4+Pj4+ICsgICAgICAgIGdyZXAgYXRvbWljX3dyaXRlX3VuaXRfbWluIHwgZ3JlcCAtbyAn
WzAtOV1cKycNCj4+Pj4+Pj4gK30NCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArX2dldF9hdG9taWNfd3Jp
dGVfdW5pdF9tYXgoKQ0KPj4+Pj4+PiArew0KPj4+Pj4+PiArICRYRlNfSU9fUFJPRyAtYyAic3Rh
dHggLXIgLW0gJFNUQVRYX1dSSVRFX0FUT01JQyIgJDEgfCBcDQo+Pj4+Pj4+ICsgICAgICAgIGdy
ZXAgYXRvbWljX3dyaXRlX3VuaXRfbWF4IHwgZ3JlcCAtbyAnWzAtOV1cKycNCj4+Pj4+Pj4gK30N
Cj4+Pj4+Pj4gKw0KPj4+Pj4+PiArX2dldF9hdG9taWNfd3JpdGVfc2VnbWVudHNfbWF4KCkNCj4+
Pj4+Pj4gK3sNCj4+Pj4+Pj4gKyAkWEZTX0lPX1BST0cgLWMgInN0YXR4IC1yIC1tICRTVEFUWF9X
UklURV9BVE9NSUMiICQxIHwgXA0KPj4+Pj4+PiArICAgICAgICBncmVwIGF0b21pY193cml0ZV9z
ZWdtZW50c19tYXggfCBncmVwIC1vICdbMC05XVwrJw0KPj4+Pj4+PiArfQ0KPj4+Pj4+PiArDQo+
Pj4+Pj4+ICtfcmVxdWlyZV9zY3JhdGNoX3dyaXRlX2F0b21pYygpDQo+Pj4+Pj4+ICt7DQo+Pj4+
Pj4+ICsgX3JlcXVpcmVfc2NyYXRjaA0KPj4+Pj4+PiArDQo+Pj4+Pj4+ICsgZXhwb3J0IFNUQVRY
X1dSSVRFX0FUT01JQz0weDEwMDAwDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKyBhd3VfbWluX2JkZXY9
JChfZ2V0X2F0b21pY193cml0ZV91bml0X21pbiAkU0NSQVRDSF9ERVYpDQo+Pj4+Pj4+ICsgYXd1
X21heF9iZGV2PSQoX2dldF9hdG9taWNfd3JpdGVfdW5pdF9tYXggJFNDUkFUQ0hfREVWKQ0KPj4+
Pj4+PiArDQo+Pj4+Pj4+ICsgaWYgWyAkYXd1X21pbl9iZGV2IC1lcSAwIF0gJiYgWyAkYXd1X21h
eF9iZGV2IC1lcSAwIF07IHRoZW4NCj4+Pj4+Pj4gKyBfbm90cnVuICJ3cml0ZSBhdG9taWMgbm90
IHN1cHBvcnRlZCBieSB0aGlzIGJsb2NrDQo+Pj4+Pj4+IGRldmljZSINCj4+Pj4+Pj4gKyBmaQ0K
Pj4+Pj4+PiArDQo+Pj4+Pj4+ICsgX3NjcmF0Y2hfbWtmcyA+IC9kZXYvbnVsbCAyPiYxDQo+Pj4+
Pj4+ICsgX3NjcmF0Y2hfbW91bnQNCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArIHRlc3RmaWxlPSRTQ1JB
VENIX01OVC90ZXN0ZmlsZQ0KPj4+Pj4+PiArIHRvdWNoICR0ZXN0ZmlsZQ0KPj4+Pj4+PiArDQo+
Pj4+Pj4+ICsgYXd1X21pbl9mcz0kKF9nZXRfYXRvbWljX3dyaXRlX3VuaXRfbWluICR0ZXN0Zmls
ZSkNCj4+Pj4+Pj4gKyBhd3VfbWF4X2ZzPSQoX2dldF9hdG9taWNfd3JpdGVfdW5pdF9tYXggJHRl
c3RmaWxlKQ0KPj4+Pj4+PiArDQo+Pj4+Pj4+ICsgX3NjcmF0Y2hfdW5tb3VudA0KPj4+Pj4+PiAr
DQo+Pj4+Pj4+ICsgaWYgWyAkYXd1X21pbl9mcyAtZXEgMCBdICYmIFsgJGF3dV9tYXhfZnMgLWVx
IDAgXTsgdGhlbg0KPj4+Pj4+PiArIF9ub3RydW4gIndyaXRlIGF0b21pYyBub3Qgc3VwcG9ydGVk
IGJ5IHRoaXMgZmlsZXN5c3RlbSINCj4+Pj4+Pj4gKyBmaQ0KPj4+Pj4+PiArfQ0KPj4+Pj4+PiAr
DQo+Pj4+Pj4+IF9yZXF1aXJlX2lub2RlX2xpbWl0cygpDQo+Pj4+Pj4+IHsNCj4+Pj4+Pj4gaWYg
WyAkKF9nZXRfZnJlZV9pbm9kZSAkVEVTVF9ESVIpIC1lcSAwIF07IHRoZW4NCj4+Pj4+Pj4gZGlm
ZiAtLWdpdCBhL3Rlc3RzL2dlbmVyaWMvNzYyIGIvdGVzdHMvZ2VuZXJpYy83NjINCj4+Pj4+Pj4g
bmV3IGZpbGUgbW9kZSAxMDA3NTUNCj4+Pj4+Pj4gaW5kZXggMDAwMDAwMDAuLmQwYTgwMjE5DQo+
Pj4+Pj4+IC0tLSAvZGV2L251bGwNCj4+Pj4+Pj4gKysrIGIvdGVzdHMvZ2VuZXJpYy83NjINCj4+
Pj4+Pj4gQEAgLTAsMCArMSwxNjAgQEANCj4+Pj4+Pj4gKyMhIC9iaW4vYmFzaA0KPj4+Pj4+PiAr
IyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPj4+Pj4+PiArIyBDb3B5cmlnaHQg
KGMpIDIwMjUgT3JhY2xlLiAgQWxsIFJpZ2h0cyBSZXNlcnZlZC4NCj4+Pj4+Pj4gKyMNCj4+Pj4+
Pj4gKyMgRlMgUUEgVGVzdCA3NjINCj4+Pj4+Pj4gKyMNCj4+Pj4+Pj4gKyMgVmFsaWRhdGUgYXRv
bWljIHdyaXRlIHN1cHBvcnQNCj4+Pj4+Pj4gKyMNCj4+Pj4+Pj4gKy4gLi9jb21tb24vcHJlYW1i
bGUNCj4+Pj4+Pj4gK19iZWdpbl9mc3Rlc3QgYXV0byBxdWljayBydw0KPj4+Pj4+PiArDQo+Pj4+
Pj4+ICtfcmVxdWlyZV9zY3JhdGNoX3dyaXRlX2F0b21pYw0KPj4+Pj4+PiArX3JlcXVpcmVfeGZz
X2lvX2NvbW1hbmQgcHdyaXRlIC1BDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gK3Rlc3RfYXRvbWljX3dy
aXRlcygpDQo+Pj4+Pj4+ICt7DQo+Pj4+Pj4+ICsgICAgbG9jYWwgYnNpemU9JDENCj4+Pj4+Pj4g
Kw0KPj4+Pj4+PiArICAgIGNhc2UgIiRGU1RZUCIgaW4NCj4+Pj4+Pj4gKyAgICAieGZzIikNCj4+
Pj4+Pj4gKyAgICAgICAgbWtmc19vcHRzPSItYiBzaXplPSRic2l6ZSINCj4+Pj4+Pj4gKyAgICAg
ICAgOzsNCj4+Pj4+Pj4gKyAgICAiZXh0NCIpDQo+Pj4+Pj4+ICsgICAgICAgIG1rZnNfb3B0cz0i
LWIgJGJzaXplIg0KPj4+Pj4+PiArICAgICAgICA7Ow0KPj4+Pj4+PiArICAgICopDQo+Pj4+Pj4+
ICsgICAgICAgIDs7DQo+Pj4+Pj4+ICsgICAgZXNhYw0KPj4+Pj4+PiArDQo+Pj4+Pj4+ICsgICAg
IyBJZiBibG9jayBzaXplIGlzIG5vdCBzdXBwb3J0ZWQsIHNraXAgdGhpcyB0ZXN0DQo+Pj4+Pj4+
ICsgICAgX3NjcmF0Y2hfbWtmcyAkbWtmc19vcHRzID4+JHNlcXJlcy5mdWxsIDI+JjEgfHwgcmV0
dXJuDQo+Pj4+Pj4+ICsgICAgX3RyeV9zY3JhdGNoX21vdW50ID4+JHNlcXJlcy5mdWxsIDI+JjEg
fHwgcmV0dXJuDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKyAgICB0ZXN0ICIkRlNUWVAiID0gInhmcyIg
JiYgX3hmc19mb3JjZV9iZGV2IGRhdGEgJFNDUkFUQ0hfTU5UDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4g
KyAgICB0ZXN0ZmlsZT0kU0NSQVRDSF9NTlQvdGVzdGZpbGUNCj4+Pj4+Pj4gKyAgICB0b3VjaCAk
dGVzdGZpbGUNCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArICAgIGZpbGVfbWluX3dyaXRlPSQoX2dldF9h
dG9taWNfd3JpdGVfdW5pdF9taW4gJHRlc3RmaWxlKQ0KPj4+Pj4+PiArICAgIGZpbGVfbWF4X3dy
aXRlPSQoX2dldF9hdG9taWNfd3JpdGVfdW5pdF9tYXggJHRlc3RmaWxlKQ0KPj4+Pj4+PiArICAg
IGZpbGVfbWF4X3NlZ21lbnRzPSQoX2dldF9hdG9taWNfd3JpdGVfc2VnbWVudHNfbWF4ICR0ZXN0
ZmlsZSkNCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArICAgICMgQ2hlY2sgdGhhdCBhdG9taWMgbWluL21h
eCA9IEZTIGJsb2NrIHNpemUNCj4+Pj4+Pj4gKyAgICB0ZXN0ICRmaWxlX21pbl93cml0ZSAtZXEg
JGJzaXplIHx8IFwNCj4+Pj4+Pj4gKyAgICAgICAgZWNobyAiYXRvbWljIHdyaXRlIG1pbiAkZmls
ZV9taW5fd3JpdGUsIHNob3VsZCBiZSBmcyBibG9jaw0KPj4+Pj4+PiBzaXplICRic2l6ZSINCj4+
Pj4+Pj4gKyAgICB0ZXN0ICRmaWxlX21pbl93cml0ZSAtZXEgJGJzaXplIHx8IFwNCj4+Pj4+Pj4g
KyAgICAgICAgZWNobyAiYXRvbWljIHdyaXRlIG1heCAkZmlsZV9tYXhfd3JpdGUsIHNob3VsZCBi
ZSBmcyBibG9jaw0KPj4+Pj4+PiBzaXplICRic2l6ZSINCj4+Pj4+Pj4gKyAgICB0ZXN0ICRmaWxl
X21heF9zZWdtZW50cyAtZXEgMSB8fCBcDQo+Pj4+Pj4+ICsgICAgICAgIGVjaG8gImF0b21pYyB3
cml0ZSBtYXggc2VnbWVudHMgJGZpbGVfbWF4X3NlZ21lbnRzLCBzaG91bGQNCj4+Pj4+Pj4gYmUg
MSINCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArICAgICMgQ2hlY2sgdGhhdCB3ZSBjYW4gcGVyZm9ybSBh
biBhdG9taWMgd3JpdGUgb2YgbGVuID0gRlMgYmxvY2sNCj4+Pj4+Pj4gc2l6ZQ0KPj4+Pj4+PiAr
ICAgIGJ5dGVzX3dyaXR0ZW49JCgkWEZTX0lPX1BST0cgLWRjICJwd3JpdGUgLUEgLUQgLVYxIC1i
ICRic2l6ZSAwDQo+Pj4+Pj4+ICRic2l6ZSIgJHRlc3RmaWxlIHwgXA0KPj4+Pj4+PiArICAgICAg
ICBncmVwIHdyb3RlIHwgYXdrIC1GJ1svIF0nICd7cHJpbnQgJDJ9JykNCj4+Pj4+Pj4gKyAgICB0
ZXN0ICRieXRlc193cml0dGVuIC1lcSAkYnNpemUgfHwgZWNobyAiYXRvbWljIHdyaXRlDQo+Pj4+
Pj4+IGxlbj0kYnNpemUgZmFpbGVkIg0KPj4+Pj4+PiArDQo+Pj4+Pj4+ICsgICAgIyBDaGVjayB0
aGF0IHdlIGNhbiBwZXJmb3JtIGFuIGF0b21pYyBzaW5nbGUtYmxvY2sgY293IHdyaXRlDQo+Pj4+
Pj4+ICsgICAgaWYgWyAiJEZTVFlQIiA9PSAieGZzIiBdOyB0aGVuDQo+Pj4+Pj4+ICsgICAgICAg
IHRlc3RmaWxlX2NwPSRTQ1JBVENIX01OVC90ZXN0ZmlsZV9jb3B5DQo+Pj4+Pj4+ICsgICAgICAg
IGlmIF94ZnNfaGFzX2ZlYXR1cmUgJFNDUkFUQ0hfTU5UIHJlZmxpbms7IHRoZW4NCj4+Pj4+Pj4g
KyAgICAgICAgICAgIGNwIC0tcmVmbGluayAkdGVzdGZpbGUgJHRlc3RmaWxlX2NwDQo+Pj4+Pj4+
ICsgICAgICAgIGZpDQo+Pj4+Pj4+ICsgICAgICAgIGJ5dGVzX3dyaXR0ZW49JCgkWEZTX0lPX1BS
T0cgLWRjICJwd3JpdGUgLUEgLUQgLVYxIC1iDQo+Pj4+Pj4+ICRic2l6ZSAwICRic2l6ZSIgJHRl
c3RmaWxlX2NwIHwgXA0KPj4+Pj4+PiArICAgICAgICAgICAgZ3JlcCB3cm90ZSB8IGF3ayAtRidb
LyBdJyAne3ByaW50ICQyfScpDQo+Pj4+Pj4+ICsgICAgICAgIHRlc3QgJGJ5dGVzX3dyaXR0ZW4g
LWVxICRic2l6ZSB8fCBlY2hvICJhdG9taWMgd3JpdGUgb24NCj4+Pj4+Pj4gcmVmbGlua2VkIGZp
bGUgZmFpbGVkIg0KPj4+Pj4+PiArICAgIGZpDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKyAgICAjIENo
ZWNrIHRoYXQgd2UgY2FuIHBlcmZvcm0gYW4gYXRvbWljIHdyaXRlIG9uIGFuIHVud3JpdHRlbg0K
Pj4+Pj4+PiBibG9jaw0KPj4+Pj4+PiArICAgICRYRlNfSU9fUFJPRyAtYyAiZmFsbG9jICRic2l6
ZSAkYnNpemUiICR0ZXN0ZmlsZQ0KPj4+Pj4+PiArICAgIGJ5dGVzX3dyaXR0ZW49JCgkWEZTX0lP
X1BST0cgLWRjICJwd3JpdGUgLUEgLUQgLVYxIC1iICRic2l6ZQ0KPj4+Pj4+PiAkYnNpemUgJGJz
aXplIiAkdGVzdGZpbGUgfCBcDQo+Pj4+Pj4+ICsgICAgICAgIGdyZXAgd3JvdGUgfCBhd2sgLUYn
Wy8gXScgJ3twcmludCAkMn0nKQ0KPj4+Pj4+PiArICAgIHRlc3QgJGJ5dGVzX3dyaXR0ZW4gLWVx
ICRic2l6ZSB8fCBlY2hvICJhdG9taWMgd3JpdGUgdG8NCj4+Pj4+Pj4gdW53cml0dGVuIGJsb2Nr
IGZhaWxlZCINCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArICAgICMgQ2hlY2sgdGhhdCB3ZSBjYW4gcGVy
Zm9ybSBhbiBhdG9taWMgd3JpdGUgb24gYSBzcGFyc2UgaG9sZQ0KPj4+Pj4+PiArICAgICRYRlNf
SU9fUFJPRyAtYyAiZnB1bmNoIDAgJGJzaXplIiAkdGVzdGZpbGUNCj4+Pj4+Pj4gKyAgICBieXRl
c193cml0dGVuPSQoJFhGU19JT19QUk9HIC1kYyAicHdyaXRlIC1BIC1EIC1WMSAtYiAkYnNpemUg
MA0KPj4+Pj4+PiAkYnNpemUiICR0ZXN0ZmlsZSB8IFwNCj4+Pj4+Pj4gKyAgICAgICAgZ3JlcCB3
cm90ZSB8IGF3ayAtRidbLyBdJyAne3ByaW50ICQyfScpDQo+Pj4+Pj4+ICsgICAgdGVzdCAkYnl0
ZXNfd3JpdHRlbiAtZXEgJGJzaXplIHx8IGVjaG8gImF0b21pYyB3cml0ZSB0byBzcGFyc2UNCj4+
Pj4+Pj4gaG9sZSBmYWlsZWQiDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKyAgICAjIENoZWNrIHRoYXQg
d2UgY2FuIHBlcmZvcm0gYW4gYXRvbWljIHdyaXRlIG9uIGEgZnVsbHkgbWFwcGVkDQo+Pj4+Pj4+
IGJsb2NrDQo+Pj4+Pj4+ICsgICAgYnl0ZXNfd3JpdHRlbj0kKCRYRlNfSU9fUFJPRyAtZGMgInB3
cml0ZSAtQSAtRCAtVjEgLWIgJGJzaXplIDANCj4+Pj4+Pj4gJGJzaXplIiAkdGVzdGZpbGUgfCBc
DQo+Pj4+Pj4+ICsgICAgICAgIGdyZXAgd3JvdGUgfCBhd2sgLUYnWy8gXScgJ3twcmludCAkMn0n
KQ0KPj4+Pj4+PiArICAgIHRlc3QgJGJ5dGVzX3dyaXR0ZW4gLWVxICRic2l6ZSB8fCBlY2hvICJh
dG9taWMgd3JpdGUgdG8gbWFwcGVkDQo+Pj4+Pj4+IGJsb2NrIGZhaWxlZCINCj4+Pj4+Pj4gKw0K
Pj4+Pj4+PiArICAgICMgUmVqZWN0IGF0b21pYyB3cml0ZSBpZiBsZW4gaXMgb3V0IG9mIGJvdW5k
cw0KPj4+Pj4+PiArICAgICRYRlNfSU9fUFJPRyAtZGMgInB3cml0ZSAtQSAtRCAtVjEgLWIgJGJz
aXplIDAgJCgoYnNpemUgLSAxKSkiDQo+Pj4+Pj4+ICR0ZXN0ZmlsZSAyPj4gJHNlcXJlcy5mdWxs
ICYmIFwNCj4+Pj4+Pj4gKyAgICAgICAgZWNobyAiYXRvbWljIHdyaXRlIGxlbj0kKChic2l6ZSAt
IDEpKSBzaG91bGQgZmFpbCINCj4+Pj4+Pj4gKyAgICAkWEZTX0lPX1BST0cgLWRjICJwd3JpdGUg
LUEgLUQgLVYxIC1iICRic2l6ZSAwICQoKGJzaXplICsgMSkpIg0KPj4+Pj4+PiAkdGVzdGZpbGUg
Mj4+ICRzZXFyZXMuZnVsbCAmJiBcDQo+Pj4+Pj4+ICsgICAgICAgIGVjaG8gImF0b21pYyB3cml0
ZSBsZW49JCgoYnNpemUgKyAxKSkgc2hvdWxkIGZhaWwiDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKyAg
ICAjIFJlamVjdCBhdG9taWMgd3JpdGUgd2hlbiBpb3ZlY3MgPiAxDQo+Pj4+Pj4+ICsgICAgJFhG
U19JT19QUk9HIC1kYyAicHdyaXRlIC1BIC1EIC1WMiAtYiAkYnNpemUgMCAkYnNpemUiDQo+Pj4+
Pj4+ICR0ZXN0ZmlsZSAyPj4gJHNlcXJlcy5mdWxsICYmIFwNCj4+Pj4+Pj4gKyAgICAgICAgZWNo
byAiYXRvbWljIHdyaXRlIG9ubHkgc3VwcG9ydHMgaW92ZWMgY291bnQgb2YgMSINCj4+Pj4+Pj4g
Kw0KPj4+Pj4+PiArICAgICMgUmVqZWN0IGF0b21pYyB3cml0ZSB3aGVuIG5vdCB1c2luZyBkaXJl
Y3QgSS9PDQo+Pj4+Pj4+ICsgICAgJFhGU19JT19QUk9HIC1jICJwd3JpdGUgLUEgLVYxIC1iICRi
c2l6ZSAwICRic2l6ZSIgJHRlc3RmaWxlDQo+Pj4+Pj4+IDI+PiAkc2VxcmVzLmZ1bGwgJiYgXA0K
Pj4+Pj4+PiArICAgICAgICBlY2hvICJhdG9taWMgd3JpdGUgcmVxdWlyZXMgZGlyZWN0IEkvTyIN
Cj4+Pj4+Pj4gKw0KPj4+Pj4+PiArICAgICMgUmVqZWN0IGF0b21pYyB3cml0ZSB3aGVuIG9mZnNl
dCAlIGJzaXplICE9IDANCj4+Pj4+Pj4gKyAgICAkWEZTX0lPX1BST0cgLWRjICJwd3JpdGUgLUEg
LUQgLVYxIC1iICRic2l6ZSAxICRic2l6ZSINCj4+Pj4+Pj4gJHRlc3RmaWxlIDI+PiAkc2VxcmVz
LmZ1bGwgJiYgXA0KPj4+Pj4+PiArICAgICAgICBlY2hvICJhdG9taWMgd3JpdGUgcmVxdWlyZXMg
b2Zmc2V0IHRvIGJlIGFsaWduZWQgdG8gYnNpemUiDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKyAgICBf
c2NyYXRjaF91bm1vdW50DQo+Pj4+Pj4+ICt9DQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gK3Rlc3RfYXRv
bWljX3dyaXRlX2JvdW5kcygpDQo+Pj4+Pj4+ICt7DQo+Pj4+Pj4+ICsgICAgbG9jYWwgYnNpemU9
JDENCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArICAgIGNhc2UgIiRGU1RZUCIgaW4NCj4+Pj4+Pj4gKyAg
ICAieGZzIikNCj4+Pj4+Pj4gKyAgICAgICAgbWtmc19vcHRzPSItYiBzaXplPSRic2l6ZSINCj4+
Pj4+Pj4gKyAgICAgICAgOzsNCj4+Pj4+Pj4gKyAgICAiZXh0NCIpDQo+Pj4+Pj4+ICsgICAgICAg
IG1rZnNfb3B0cz0iLWIgJGJzaXplIg0KPj4+Pj4+PiArICAgICAgICA7Ow0KPj4+Pj4+PiArICAg
ICopDQo+Pj4+Pj4+ICsgICAgICAgIDs7DQo+Pj4+Pj4+ICsgICAgZXNhYw0KPj4+Pj4+PiArDQo+
Pj4+Pj4+ICsgICAgIyBJZiBibG9jayBzaXplIGlzIG5vdCBzdXBwb3J0ZWQsIHNraXAgdGhpcyB0
ZXN0DQo+Pj4+Pj4+ICsgICAgX3NjcmF0Y2hfbWtmcyAkbWtmc19vcHRzID4+JHNlcXJlcy5mdWxs
IDI+JjEgfHwgcmV0dXJuDQo+Pj4+Pj4+ICsgICAgX3RyeV9zY3JhdGNoX21vdW50ID4+JHNlcXJl
cy5mdWxsIDI+JjEgfHwgcmV0dXJuDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKyAgICB0ZXN0ICIkRlNU
WVAiID0gInhmcyIgJiYgX3hmc19mb3JjZV9iZGV2IGRhdGEgJFNDUkFUQ0hfTU5UDQo+Pj4+Pj4+
ICsNCj4+Pj4+Pj4gKyAgICB0ZXN0ZmlsZT0kU0NSQVRDSF9NTlQvdGVzdGZpbGUNCj4+Pj4+Pj4g
KyAgICB0b3VjaCAkdGVzdGZpbGUNCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArICAgICRYRlNfSU9fUFJP
RyAtZGMgInB3cml0ZSAtQSAtRCAtVjEgLWIgJGJzaXplIDAgJGJzaXplIg0KPj4+Pj4+PiAkdGVz
dGZpbGUgMj4+ICRzZXFyZXMuZnVsbCAmJiBcDQo+Pj4+Pj4+ICsgICAgICAgIGVjaG8gImF0b21p
YyB3cml0ZSBzaG91bGQgZmFpbCB3aGVuIGJzaXplIGlzIG91dCBvZg0KPj4+Pj4+PiBib3VuZHMi
DQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKyAgICBfc2NyYXRjaF91bm1vdW50DQo+Pj4+Pj4+ICt9DQo+
Pj4+Pj4+ICsNCj4+Pj4+Pj4gK3N5c19taW5fd3JpdGU9JChjYXQgIi9zeXMvYmxvY2svJChfc2hv
cnRfZGV2DQo+Pj4+Pj4+ICRTQ1JBVENIX0RFVikvcXVldWUvYXRvbWljX3dyaXRlX3VuaXRfbWlu
X2J5dGVzIikNCj4+Pj4+Pj4gK3N5c19tYXhfd3JpdGU9JChjYXQgIi9zeXMvYmxvY2svJChfc2hv
cnRfZGV2DQo+Pj4+Pj4+ICRTQ1JBVENIX0RFVikvcXVldWUvYXRvbWljX3dyaXRlX3VuaXRfbWF4
X2J5dGVzIikNCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArYmRldl9taW5fd3JpdGU9JChfZ2V0X2F0b21p
Y193cml0ZV91bml0X21pbiAkU0NSQVRDSF9ERVYpDQo+Pj4+Pj4+ICtiZGV2X21heF93cml0ZT0k
KF9nZXRfYXRvbWljX3dyaXRlX3VuaXRfbWF4ICRTQ1JBVENIX0RFVikNCj4+Pj4+Pj4gKw0KPj4+
Pj4+PiAraWYgWyAiJHN5c19taW5fd3JpdGUiIC1uZSAiJGJkZXZfbWluX3dyaXRlIiBdOyB0aGVu
DQo+Pj4+Pj4+ICsgICAgZWNobyAiYmRldiBtaW4gd3JpdGUgIT0gc3lzIG1pbiB3cml0ZSINCj4+
Pj4+Pj4gK2ZpDQo+Pj4+Pj4+ICtpZiBbICIkc3lzX21heF93cml0ZSIgLW5lICIkYmRldl9tYXhf
d3JpdGUiIF07IHRoZW4NCj4+Pj4+Pj4gKyAgICBlY2hvICJiZGV2IG1heCB3cml0ZSAhPSBzeXMg
bWF4IHdyaXRlIg0KPj4+Pj4+PiArZmkNCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArIyBUZXN0IGFsbCBz
dXBwb3J0ZWQgYmxvY2sgc2l6ZXMgYmV0d2VlbiBiZGV2IG1pbiBhbmQgbWF4DQo+Pj4+Pj4+ICtm
b3IgKChic2l6ZT0kYmRldl9taW5fd3JpdGU7IGJzaXplPD1iZGV2X21heF93cml0ZTsgYnNpemUq
PTIpKTsgZG8NCj4+Pj4+Pj4gKyAgICAgICAgdGVzdF9hdG9taWNfd3JpdGVzICRic2l6ZQ0KPj4+
Pj4+PiArZG9uZTsNCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArIyBDaGVjayB0aGF0IGF0b21pYyB3cml0
ZSBmYWlscyBpZiBic2l6ZSA8IGJkZXYgbWluIG9yIGJzaXplID4NCj4+Pj4+Pj4gYmRldiBtYXgN
Cj4+Pj4+Pj4gK3Rlc3RfYXRvbWljX3dyaXRlX2JvdW5kcyAkKChiZGV2X21pbl93cml0ZSAvIDIp
KQ0KPj4+Pj4+PiArdGVzdF9hdG9taWNfd3JpdGVfYm91bmRzICQoKGJkZXZfbWF4X3dyaXRlICog
MikpDQo+Pj4+Pj4+ICsNCj4+Pj4+Pj4gKyMgc3VjY2VzcywgYWxsIGRvbmUNCj4+Pj4+Pj4gK2Vj
aG8gU2lsZW5jZSBpcyBnb2xkZW4NCj4+Pj4+Pj4gK3N0YXR1cz0wDQo+Pj4+Pj4+ICtleGl0DQo+
Pj4+Pj4+IGRpZmYgLS1naXQgYS90ZXN0cy9nZW5lcmljLzc2Mi5vdXQgYi90ZXN0cy9nZW5lcmlj
Lzc2Mi5vdXQNCj4+Pj4+Pj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+Pj4+Pj4gaW5kZXggMDAw
MDAwMDAuLmZiYWViMjk3DQo+Pj4+Pj4+IC0tLSAvZGV2L251bGwNCj4+Pj4+Pj4gKysrIGIvdGVz
dHMvZ2VuZXJpYy83NjIub3V0DQo+Pj4+Pj4+IEBAIC0wLDAgKzEsMiBAQA0KPj4+Pj4+PiArUUEg
b3V0cHV0IGNyZWF0ZWQgYnkgNzYyDQo+Pj4+Pj4+ICtTaWxlbmNlIGlzIGdvbGRlbg0KPj4+Pj4+
PiAtLSANCj4+Pj4+Pj4gMi4zNC4xDQoNCg0K

