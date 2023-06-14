Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DFA7111C1
	for <lists+linux-xfs@lfdr.de>; Thu, 25 May 2023 19:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbjEYRN5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 13:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjEYRN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 13:13:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0A3195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 10:13:54 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34PH5Tqk025086;
        Thu, 25 May 2023 17:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=dQ7UUt5ZQnDc5jpuyn6aymBVIKr+y+7gPWKHSnaO98g=;
 b=gx5nsGLoc/shLUBNQ2VjMyxy8Ayao7xpuhBcE6tWrBNSUGSZxeSwUMVoml1GjF9DN4Md
 Y9SeUnfWK6x/VA+xRav1ua0hwlSG+BkDEtrmpyyAp1acg7hDr5i9jAFKbG0b7Yuun/rq
 5lKkaxzB9GwgkfFF0L+fwGf5CGGAzIRHWGPnF7rtmJ4B6jpQEzZahcXgprzafRVij7Se
 GX+ILTQuqAnML1k5r6ou6EADkZmKFW9m+8zI/FQo04I2LfEDjwMZRuZ7sid1ro1frTCv
 tDV8vzfx9ytYDdSbKbzkR2dgZkgfs0V9OGW3DkINdlnjIh6cTPSHL0RV9iyWB+lTmWDx kA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtbru00r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 May 2023 17:13:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34PH4hqU028588;
        Thu, 25 May 2023 17:13:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2u5cen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 May 2023 17:13:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3ZD1hm3Ud/dKwvSOYiXEavr51UAW6g2Q7aXhgQtthqJXR4mOf94FZ9MAOVANwwqSqQbxNhEjw+p8k5U//buz8363z25zsLGqOqj5r/+xUJdIkMp7j5chHuCTUyTvMTf0twsFQO8tUSm+GCnF/+1D9fnPaM7PVKnP/hXxgO5GZjsk9uuypZ62zbHyC8jET0GHKKx+jLKivmCSBznH6YKKj5XgYzv7c4V4qHkHCxIFyPtTizFeMmu6OwbVu0C0dRoRs+4K8QOvNAXpXjc6y50pCL2YMJaGNGTOyu3XwoFz8e5maC+DVoFO9SdmlAieXkUDup4mvF56GFAG9WvH3mo6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQ7UUt5ZQnDc5jpuyn6aymBVIKr+y+7gPWKHSnaO98g=;
 b=XId3p96aI/fgTl6m164Nd62A/BBtue0eTgAO84t2mHuOKc7rI9V4iLhuGV69W9yA7W7ZciIwnyOChtBir6S4a8IEF3/VgPQSjrzXGyjJXiBG/bsgjqNmT6zX5nxJzqw/phD4IpBORN7yDyEfeza0LI8LSKo494hnGf2ojuVBEtTPTjdyemXc7agIoEpARCRZXP5/6/FpZaECWP/ZFvjDl5nhYcn2nf0WB6L2OPW1GsjFT/iWLPwpob+QsBBrYK+T4sLqT1pLS9Taqi/U/gigGjKENokFSyHjbBC9NWY0tfVM7y3/k5j6iz0pXh8sonRXn//ftVAFqH1aLbK1UER+oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQ7UUt5ZQnDc5jpuyn6aymBVIKr+y+7gPWKHSnaO98g=;
 b=lWYSAAbT3YAbjjzcHV5A1wGHt4LQ7EHh5brTHGO5nHSsyHyahsI8IrGA+SM3xWBgGPCjeMrY7Hm7GtzfuSAPDykaO55V+sMEsRdQDB7r0eU1lAbzEBzVXTsO2o1bENckMIfFzup+2IRbTCRZYRmPomTf6Qs/bhFbYRhLd9AS+Io=
Received: from BN7PR10MB2690.namprd10.prod.outlook.com (2603:10b6:406:c0::11)
 by MN6PR10MB7491.namprd10.prod.outlook.com (2603:10b6:208:47c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Thu, 25 May
 2023 17:13:41 +0000
Received: from BN7PR10MB2690.namprd10.prod.outlook.com
 ([fe80::651c:d997:8dc4:e9fa]) by BN7PR10MB2690.namprd10.prod.outlook.com
 ([fe80::651c:d997:8dc4:e9fa%4]) with mapi id 15.20.6433.017; Thu, 25 May 2023
 17:13:41 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Thread-Topic: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Thread-Index: AQHZinX1nnrwqHRxhUWvKoRfYjwI669lgWmAgAEdsgCAAEjTgIAASFMAgAFn74CAAQwNgIAApceAgAD5g4A=
Date:   Thu, 25 May 2023 17:13:41 +0000
Message-ID: <83930F11-431B-4E32-85EB-4B83DC623543@oracle.com>
References: <20230519171829.4108-1-wen.gang.wang@oracle.com>
 <ZGrCpXoEk9achabI@dread.disaster.area>
 <E6E92519-4AD7-4115-903F-00D7633B1B3A@oracle.com>
 <ZGvvZaQWvxf2cqlz@dread.disaster.area>
 <8DD695CE-4965-4B33-8F16-6B907D8A0884@oracle.com>
 <20230524002743.GF11620@frogsfrogsfrogs>
 <7D3E40A7-4D94-4EF0-8BED-FE11C76B8A84@oracle.com>
 <ZG7F6xj5N/ahwOMH@dread.disaster.area>
In-Reply-To: <ZG7F6xj5N/ahwOMH@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR10MB2690:EE_|MN6PR10MB7491:EE_
x-ms-office365-filtering-correlation-id: eef4267f-f31d-48db-11c1-08db5d436374
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rv66yIt8M9h0q1C7s7NNElKNV3WOddz5kXiaYjlvpjnA3xVRCAhXFZ+4r5WDsoRKrqeOaTu/Sq+H16r4fnnkDz/w9DsRIWYA9f2etqwpcZatRrLWeiyrEnpnvrtWs5FSq4q5yDBbRFsxrluu8Q50SZodbmKWKr7LYWWetDlntZF0/A2ZoI9bmWN+1hHOC96myoH2670jfPba0DRmIRDhMG4YonlF7avu0rb5KdIlYh6cDjp2nhFzFd3aig0epM/lZB6pPebuE1bZ5pJzgaW5vhaSS9VKrEW58b4NUWURQ8iYuRTfuzRSrWpPbcHqw9UsxQhAXgblN0Lv2wtW5c5V9nGznbAtW7PvHrA48n+v/9msyz7mp+Z5sRvjJALTQeV0DSgavIzjIgRDQhX/OFzUqQX4baGFoOStvBenvfaPAra6Fjf4Q9f6yG4KXyu5lVyNQN1VDiDlneraFVWgnauObkqle/9sa3DH9xJo2Nzz44lxjIumZHzNv/XbcxM1LbIAeficouaq7Mk8JbBLX4u7O/pdQb30kp1F/9fRKy5yxMufBXIfyRjlquRJa0XV0wlesqy7Yk4CB0IHYD7O/dWvdoNEx1zNJQ0WaMz18mJlpUdD2A4902iQ4SIiYMcCSkTY0OUbNhzRR/TncQaqp/jBFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR10MB2690.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199021)(36756003)(38070700005)(33656002)(86362001)(4326008)(316002)(54906003)(91956017)(64756008)(6916009)(66946007)(66556008)(66476007)(66446008)(76116006)(478600001)(6486002)(71200400001)(8936002)(8676002)(5660300002)(41300700001)(2906002)(38100700002)(2616005)(53546011)(6512007)(6506007)(26005)(186003)(83380400001)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0ZoSnR3aXBvdWxlVktsR05iZGtvejlvT25yVUpJUmpoTzlYazZTWFRBVFZz?=
 =?utf-8?B?ZHBVcnFiTFVXOWZFYnJLZ3dsRVJmOTVxajhQREtPZFA2Z2tHU3JIS3lSdjh3?=
 =?utf-8?B?UVJPbDEyY1ZBK1dZQUs3SjF2MU9DTHFKWXpCSjhObFE3N2lNSUtpRkdtWDdv?=
 =?utf-8?B?RVBpOWRidWV1VlE2MzFjVmc1TzZsU2o2ZVhCbkJ0L00yTGRPb3ZUQnVsc0Rk?=
 =?utf-8?B?R2JkWGlqek9JVmVGY2YzQjRoRmNsOXE5dEdjN3VmUzB6NW8wNzhIeVpCN0Qv?=
 =?utf-8?B?QTlGejBDanpyLzJKUUlVNnZXTnVVckM5VnhXYW5MZlh1SjN5dlFjQlFpYytu?=
 =?utf-8?B?RDFyTjQxYXlNWUNyaTgzRGpjZ1BaRFJQZncyeGswSmUzL09qWnZsUnlTdlUx?=
 =?utf-8?B?VE1CY1NwQzdtL1FkRjhiOW94dEQrakFvbit5TlJjejErUWdjb2d2L1FIUDdB?=
 =?utf-8?B?TnM4QTVJRUEzdzZwVE5saFFib0NRRmVRbFg2UEtyRDVhYk54Vmc2QUhFZENu?=
 =?utf-8?B?RC85Tm9YUTlYakJUWDNOeHdzQm9KcXRkSzRHa3RsMnZveDNMYVVBVmxBa0lr?=
 =?utf-8?B?bXJFejZXV3ZQU2JpMUhudjY4cmYvK1hORFRrRnRsOTc5VjFIRStOMEZObXFP?=
 =?utf-8?B?dFBpcE5TYUVmK3VUZEYrTGRoY2lMdy9HVE5HcUttaXdxa2NXODNrb0cxMWRJ?=
 =?utf-8?B?R3hIK05VUFFBd0ZwamRsL1g2UVdaOEtBblBqdlJBNGVnYnE4NGliWUl0U1Nh?=
 =?utf-8?B?VkFhRTRLSjk0S2RJWERjekxXVjdKNWU0U01JZEVKWVdmK1JkNm1haEdIdnVT?=
 =?utf-8?B?d3JpK2RBZnNxUktyN0NjaEJ6UGtYNi9iZG1pOG45WEd3dVNKcFk3Tk0wMGE1?=
 =?utf-8?B?REgxSm1ra3I2WjlCRG1YRHp4amZpdmE2SzRuUzJ4a1pXT3dUUUR4SllIbjRn?=
 =?utf-8?B?WTRhRG84a2xnMVBEUG4wNHZ6YVZrYWdCTTNXQmRGNnNLN3Zmd0RjdERpVUo0?=
 =?utf-8?B?U3Y0TjNxQk1hMkNoM0tRa3JhZVhnWUFtREVkS29Qc1Zrbm10ZHNQa0wrS3Zv?=
 =?utf-8?B?QytIakMvTWNROTVPdzQ0YytFOGxNRk5kVGUvbFIwNTZnVkl2Nmh4Qkk0REdK?=
 =?utf-8?B?UDFZSWo0L0FaWVZ0cFlkeEJDTE1KcUY0dkRDMGlnaWNRUEtrVElmUERRaWZK?=
 =?utf-8?B?RkNrUDFXay9VSng3Q1VqdVJDd2h2aFoxTFI5N3ZTWHpKYll4YVdaajdzeHpz?=
 =?utf-8?B?NVdsbmJmQmtGRmlnQ1ZoUStRZFErZHV1QWFzRTY5QjgxazUyaWVpSWx2NDZG?=
 =?utf-8?B?YTRrYWxKc1gwakdMVXJRQThuWlkwSitZc2ZCekgrVU0rbDRNSUEzNVo2VStP?=
 =?utf-8?B?UG1tSWtJNXVBdTNPYnBxeHlrN0trU01GMjlJWXlJclFEUm5LcHRJeEliNkQ3?=
 =?utf-8?B?KzhyaU9lanNUdXBBVU5wYnAwRUVnV1VYTlI3L1c0dkVZVEM1NkxMVEVxSnZu?=
 =?utf-8?B?aTR2bzd3MDBBdjNGRWVaVEIyRXVmVVh4RWdCbU1ITWlTQUdERVpHVm9kaElw?=
 =?utf-8?B?Q1ZFMEdjNXI0eDRTQWpjd0dXTEF4MzJNL3J3dlVWREFOYXdrSFB0clFZME9h?=
 =?utf-8?B?VVVoZlh3Z1V6bnN6T0tYWjI2OE9rRDd4WkQ2Yml0SlVDQXhBTVljWTFlZGx4?=
 =?utf-8?B?bEQyMTlZRlZaZkJmN1VvUnRCU2h0by82Nmp2YlB1cTZxbXJ3cDU4YkhYQ2F6?=
 =?utf-8?B?Nk84TnVBa0JGcm81ZTVpQ0RtWUt5Zi9kNWd5Tjg5NkIxVmt6d0N1eTlyd0Rq?=
 =?utf-8?B?ZU1XODBxZUYveFJyVVc0KzUyOXM4SWgvMUt6NTVjb2FpZVV2aUc2TmlhVTNM?=
 =?utf-8?B?cnY4NEU5ekpBYU9UMGNSOGxIQXBMOGMvdzRhUjYrOEZLZ0ZobElmWi9Sc0hh?=
 =?utf-8?B?NVVkL2tWbzRDbExBY0dZNHl0QmJHOHRWdGZ5VUtmWldVc3FRdEdMK0FXbkpk?=
 =?utf-8?B?WWcxUk4yODh4OWlFZ3JOT0dBcWZ3NjBKcG0wODJUNmJLTk5wNllBdlVrUFBB?=
 =?utf-8?B?dm0wZWZkSno0enpkc0xtbmxYYUs5NHdDci9JVk95UjdDblQvSmt5anpsVzhD?=
 =?utf-8?B?Zkc3YldYRnhlZDF4M0FjQTVNMG9LYi9qdVBtTGVWRWd2alFoS1FSQlRleTZ1?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07532E9FB08D6B4687A1E780BF6FD689@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: deyC0GFRhLkFI3HYp5B2kDYJkDh7d3xhBhsIXPJUj+iNvT5AvYrZhyoKatr3zVriN/ALB9h55buy623K+PDp9B772iLcHS8rcrLEKXwdRCG48J8KgqrF95CJvL86ytGNm/JoSFA5exVzlDZcmuWbmJASSlusFxY+tbxHMVH15x7+MGJOiotE3UXpnv8U0S4CtUYeJY/OT0Ox0ckSqCn22L4wHXle3T5bPT3fdzZvpu8krh3GfXd1ud7Iwux7OURLIEsGRXCrj0d+bOI1bx+WP1xmjK5px4Ed0v9C/4+VA5ZoQTgfPBlZOadiP+B/ahWAiFF/oUsVMGNg092g8YhUm7+GPuQUFnzhuY8ONpLKysKWvVJU9oO/Hqw8qbwpXAxgtL/uKz2OmGptTwLCGE0viap0LUl2J/l7x8EhYLKNHSbOZpfI4BSELc98IfKJGLJf6XopHOLwxKXFapfIBrp5J14SPNyNfd6qsmwGO7zsFY4MLJZ0/GVflB0rmnkeiGeNg1MAfijLrMePoO0YcX/8q7WyHTMyhLNomqTeYu/NHPoCtBFeq3pKcxfK3MDX/366hsLD05J38uoyzD4Ijy4NVp/W8q7NK4m7xz5TuCd79zDSkfYpvo0OfWMJEQiN2ZZJghH0R35HMbx42q/leSAAq3lg/ziZLSWy6KsEszIulDEf5yArkxf/V4QxODJJ65xASfraNJuX9QdJbvQO/B8GQymwn+ZkKMzNq1JfP8dcP7p0apc32xqj6epZaDlm6Wx5qrTP/8uvrGQ0O0+Z61fFT5nHZSoMCo4/P2BwVL8f/pD/uEpZzzwTLN5i7/cq5Zb+2Ex9DnCjxisrGJgk70ZUUA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR10MB2690.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef4267f-f31d-48db-11c1-08db5d436374
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 17:13:41.5647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uOfo9cq6vLuukqZCdUCcPMZ4cfwgqBeyh7eI5m/Ho4FRxWL6dmimjl6vfuiuzg5mvthoXZ3ZGwyqm4lDNmadGYvjnOGUoR+JY3UCQJIwmGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7491
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-25_10,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305250143
X-Proofpoint-GUID: FLciZ2iD8_kRConppbjZEiaSG6IwAndI
X-Proofpoint-ORIG-GUID: FLciZ2iD8_kRConppbjZEiaSG6IwAndI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gTWF5IDI0LCAyMDIzLCBhdCA3OjIwIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXkgMjQsIDIwMjMgYXQgMDQ6Mjc6
MTlQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+IE9uIE1heSAyMywgMjAyMywgYXQg
NToyNyBQTSwgRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4g
T24gVHVlLCBNYXkgMjMsIDIwMjMgYXQgMDI6NTk6NDBBTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdy
b3RlOg0KPj4+Pj4gT24gTWF5IDIyLCAyMDIzLCBhdCAzOjQwIFBNLCBEYXZlIENoaW5uZXIgPGRh
dmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOg0KPj4+Pj4gT24gTW9uLCBNYXkgMjIsIDIwMjMgYXQg
MDY6MjA6MTFQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+Pj4+PiBPbiBNYXkgMjEs
IDIwMjMsIGF0IDY6MTcgUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3Jv
dGU6DQo+Pj4+Pj4+IE9uIEZyaSwgTWF5IDE5LCAyMDIzIGF0IDEwOjE4OjI5QU0gLTA3MDAsIFdl
bmdhbmcgV2FuZyB3cm90ZToNCj4+Pj4+Pj4+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2V4dGZy
ZWVfaXRlbS5jIGIvZnMveGZzL3hmc19leHRmcmVlX2l0ZW0uYw0KPj4+Pj4+IEZvciBleGlzdGlu
ZyBvdGhlciBjYXNlcyAoaWYgdGhlcmUgYXJlKSB3aGVyZSBuZXcgaW50ZW50cyBhcmUgYWRkZWQs
DQo+Pj4+Pj4gdGhleSBkb27igJl0IHVzZSB0aGUgY2FwdHVyZV9saXN0IGZvciBkZWxheWVkIG9w
ZXJhdGlvbnM/IERvIHlvdSBoYXZlIGV4YW1wbGUgdGhlbj8gDQo+Pj4+Pj4gaWYgc28gSSB0aGlu
ayB3ZSBzaG91bGQgZm9sbG93IHRoZWlyIHdheSBpbnN0ZWFkIG9mIGFkZGluZyB0aGUgZGVmZXIg
b3BlcmF0aW9ucw0KPj4+Pj4+IChidXQgcmVwbHkgb24gdGhlIGludGVudHMgb24gQUlMKS4NCj4+
Pj4+IA0KPj4+Pj4gQWxsIG9mIHRoZSBpbnRlbnQgcmVjb3Zlcnkgc3R1ZmYgdXNlcw0KPj4+Pj4g
eGZzX2RlZmVyX29wc19jYXB0dXJlX2FuZF9jb21taXQoKSB0byBjb21taXQgdGhlIGludGVudCBi
ZWluZw0KPj4+Pj4gcmVwbGF5ZWQgYW5kIGNhdXNlIGFsbCBmdXJ0aGVyIG5ldyBpbnRlbnQgcHJv
Y2Vzc2luZyBpbiB0aGF0IGNoYWluDQo+Pj4+PiB0byBiZSBkZWZlcmVkIHVudGlsIGFmdGVyIGFs
bCB0aGUgaW50ZW50cyByZWNvdmVyZWQgZnJvbSB0aGUgam91cm5hbA0KPj4+Pj4gaGF2ZSBiZWVu
IGl0ZXJhdGVkLiBBbGwgdGhvc2UgbmV3IGludGVudHMgZW5kIHVwIGluIHRoZSBBSUwgYXQgYSBM
U04NCj4+Pj4+IGluZGV4ID49IGxhc3RfbHNuLg0KPj4+PiANCj4+Pj4gWWVzLiBTbyB3ZSBicmVh
ayB0aGUgQUlMIGl0ZXJhdGlvbiBvbiBzZWVpbmcgYW4gaW50ZW50IHdpdGggbHNuIGVxdWFsIHRv
DQo+Pj4+IG9yIGJpZ2dlciB0aGFuIGxhc3RfbHNuIGFuZCBza2lwIHRoZSBpb3BfcmVjb3Zlcigp
IGZvciB0aGF0IGl0ZW0/DQo+Pj4+IGFuZCBzaGFsbCB3ZSBwdXQgdGhpcyBjaGFuZ2UgdG8gYW5v
dGhlciBzZXBhcmF0ZWQgcGF0Y2ggYXMgaXQgaXMgdG8gZml4DQo+Pj4+IGFuIGV4aXN0aW5nIHBy
b2JsZW0gKG5vdCBpbnRyb2R1Y2VkIGJ5IG15IHBhdGNoKT8NCj4+PiANCj4+PiBJbnRlbnQgcmVw
bGF5IGNyZWF0ZXMgbm9uLWludGVudCBsb2cgaXRlbXMgKGxpa2UgYnVmZmVycyBvciBpbm9kZXMp
IHRoYXQNCj4+PiBhcmUgYWRkZWQgdG8gdGhlIEFJTCB3aXRoIGFuIExTTiBoaWdoZXIgdGhhbiBs
YXN0X2xzbi4gIEkgc3VwcG9zZSBpdA0KPj4+IHdvdWxkIGJlIHBvc3NpYmxlIHRvIGJyZWFrIGxv
ZyByZWNvdmVyeSBpZiBhbiBpbnRlbnQncyBpb3BfcmVjb3Zlcg0KPj4+IG1ldGhvZCBpbW1lZGlh
dGVseSBsb2dnZWQgYSBuZXcgaW50ZW50IGFuZCByZXR1cm5lZCBFQUdBSU4gdG8gcm9sbCB0aGUN
Cj4+PiB0cmFuc2FjdGlvbiwgYnV0IG5vbmUgb2YgdGhlbSBkbyB0aGF0Ow0KPj4gDQo+PiBJIGFt
IG5vdCBxdWl0ZSBzdXJlIGZvciBhYm92ZS4gVGhlcmUgYXJlIGNhc2VzIHRoYXQgbmV3IGludGVu
dHMgYXJlIGFkZGVkDQo+PiBpbiBpb3BfcmVjb3ZlcigpLCBmb3IgZXhhbXBsZSB4ZnNfYXR0cmlf
aXRlbV9yZWNvdmVyKCk6DQo+PiANCj4+IDYzMiAgICAgICAgIGVycm9yID0geGZzX3hhdHRyaV9m
aW5pc2hfdXBkYXRlKGF0dHIsIGRvbmVfaXRlbSk7DQo+PiA2MzMgICAgICAgICBpZiAoZXJyb3Ig
PT0gLUVBR0FJTikgew0KPj4gNjM0ICAgICAgICAgICAgICAgICAvKg0KPj4gNjM1ICAgICAgICAg
ICAgICAgICAgKiBUaGVyZSdzIG1vcmUgd29yayB0byBkbywgc28gYWRkIHRoZSBpbnRlbnQgaXRl
bSB0byB0aGlzDQo+PiA2MzYgICAgICAgICAgICAgICAgICAqIHRyYW5zYWN0aW9uIHNvIHRoYXQg
d2UgY2FuIGNvbnRpbnVlIGl0IGxhdGVyLg0KPj4gNjM3ICAgICAgICAgICAgICAgICAgKi8NCj4+
IDYzOCAgICAgICAgICAgICAgICAgeGZzX2RlZmVyX2FkZCh0cCwgWEZTX0RFRkVSX09QU19UWVBF
X0FUVFIsICZhdHRyLT54YXR0cmlfbGlzdCk7DQo+PiA2MzkgICAgICAgICAgICAgICAgIGVycm9y
ID0geGZzX2RlZmVyX29wc19jYXB0dXJlX2FuZF9jb21taXQodHAsIGNhcHR1cmVfbGlzdCk7DQo+
PiA2NDAgICAgICAgICAgICAgICAgIGlmIChlcnJvcikNCj4+IDY0MSAgICAgICAgICAgICAgICAg
ICAgICAgICBnb3RvIG91dF91bmxvY2s7DQo+PiA2NDINCj4+IDY0MyAgICAgICAgICAgICAgICAg
eGZzX2l1bmxvY2soaXAsIFhGU19JTE9DS19FWENMKTsNCj4+IDY0NCAgICAgICAgICAgICAgICAg
eGZzX2lyZWxlKGlwKTsNCj4+IDY0NSAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+PiA2NDYg
ICAgICAgICB9DQo+PiANCj4+IEkgYW0gdGhpbmtpbmcgbGluZSA2MzggYW5kIDYzOSBhcmUgZG9p
bmcgc28uDQo+IA0KPiBJIGRvbid0IHRoaW5rIHNvLiBAYXR0cmlwIGlzIHRoZSBhdHRyaWJ1dGUg
aW5mb3JtYXRpb24gcmVjb3ZlcmVkDQo+IGZyb20gdGhlIG9yaWdpbmFsIGludGVudCAtIHdlIGFs
bG9jYXRlZCBAYXR0ciBpbg0KPiB4ZnNfYXR0cmlfaXRlbV9yZWNvdmVyKCkgdG8gZW5hYmxlIHRo
ZSBvcGVyYXRpb24gaW5kaWNhdGVkIGJ5DQo+IEBhdHRyaXAgdG8gYmUgZXhlY3V0ZWQuICBXZSBj
b3B5IHN0dWZmIGZyb20gQGF0dHJpcCAodGhlIGl0ZW0gd2UgYXJlDQo+IHJlY292ZXJpbmcpIHRv
IHRoZSBuZXcgQGF0dHIgc3RydWN0dXJlICh0aGUgd29yayB3ZSBuZWVkIHRvIGRvKSBhbmQNCj4g
cnVuIGl0IHRocm91Z2ggdGhlIGF0dHIgbW9kaWZpY2F0aW9uIHN0YXRlIG1hY2hpbmUuIElmIHRo
ZXJlJ3MgbW9yZQ0KPiB3b3JrIHRvIGJlIGRvbmUsIHdlIHRoZW4gYWRkIEBhdHRyIHRvIHRoZSBk
ZWZlciBsaXN0Lg0KDQpBc3N1bWluZyDigJxpZiB0aGVyZeKAmXMgbW9yZSB3b3JrIHRvIGJlIGRv
bmXigJ0gaXMgdGhlIC1FQUdBSU4gY2FzZS4uLg0KDQo+IA0KPiBJZiB0aGVyZSBpcyBkZWZlcnJl
ZCB3b3JrIHRvIGJlIGNvbnRpbnVlZCwgd2Ugc3RpbGwgbmVlZCBhIG5ldw0KPiBpbnRlbnQgdG8g
aW5kaWNhdGUgd2hhdCBhdHRyIG9wZXJhdGlvbiBuZWVkcyB0byBiZSBwZXJmb3JtZWQgbmV4dCBp
bg0KPiB0aGUgY2hhaW4uICBXaGVuIHdlIGNvbW1pdCB0aGUgdHJhbnNhY3Rpb24gKDYzOSksIGl0
IHdpbGwgY3JlYXRlIGENCj4gbmV3IGludGVudCBsb2cgaXRlbSBmb3IgdGhlIGRlZmVycmVkIGF0
dHJpYnV0ZSBvcGVyYXRpb24gaW4gdGhlDQo+IC0+Y3JlYXRlX2ludGVudCBjYWxsYmFjayBiZWZv
cmUgdGhlIHRyYW5zYWN0aW9uIGlzIGNvbW1pdHRlZC4NCg0KWWVzLCB0aGF04oCZcyB0cnVlLiBC
dXQgaXQgaGFzIG5vIGNvbmZsaWN0IHdpdGggd2hhdCBJIHdhcyBzYXlpbmcuIFRoZSB0aGluZyBJ
IHdhbnRlZA0KdG8gc2F5IGlzIHRoYXQ6DQpUaGUgbmV3IGludGVudCBsb2cgaXRlbSAoaW50cm9k
dWNlZCBieSB4ZnNfYXR0cmlfaXRlbV9yZWNvdmVyKCkpIGNvdWxkIGFwcGVhciBvbg0KQUlMIGJl
Zm9yZSB0aGUgQUlMIGl0ZXJhdGlvbiBlbmRzIGluIHhsb2dfcmVjb3Zlcl9wcm9jZXNzX2ludGVu
dHMoKS4gDQpEbyB5b3UgYWdyZWUgd2l0aCBhYm92ZT8NCg0KSW4gdGhlIGZvbGxvd2luZyBJIHdp
bGwgdGFsayBhYm91dCB0aGUgbmV3IGludGVudCBsb2cgaXRlbS4gDQoNClRoZSBpb3BfcmVjb3Zl
cigpIGlzIHRoZW4gZXhlY3V0ZWQgb24gdGhlIG5ldyBpbnRlbnQgZHVyaW5nIHRoZSBBSUwgaW50
ZW50cyBpdGVyYXRpb24uDQpJIG1lYW50IHRoaXMgbG9vcDoNCg0KMjU0OCAgICAgICAgIGZvciAo
bGlwID0geGZzX3RyYW5zX2FpbF9jdXJzb3JfZmlyc3QoYWlscCwgJmN1ciwgMCk7DQoyNTQ5ICAg
ICAgICAgICAgICBsaXAgIT0gTlVMTDsNCjI1NTAgICAgICAgICAgICAgIGxpcCA9IHhmc190cmFu
c19haWxfY3Vyc29yX25leHQoYWlscCwgJmN1cikpIHsNCuKApi4NCjI1ODQgICAgICAgICB9DQpE
byB5b3UgYWdyZWUgd2l0aCBhYm92ZT8NCg0KQW5kIHRoZSBsc24gZm9yIHRoZSBuZXcgaW50ZW50
IGlzIGVxdWFsIHRvIG9yIGJpZ2dlciB0aGFuIGxhc3RfbHNuLg0KRG8geW91IGFncmVlIHdpdGgg
YWJvdmU/DQoNCkluIGFib3ZlIGNhc2UgdGhlIGlvcF9yZWNvdmVyKCkgaXMgeGZzX2F0dHJpX2l0
ZW1fcmVjb3ZlcigpLiBUaGUgbGF0ZXINCmNyZWF0ZXMgYSB4ZnNfYXR0cl9pbnRlbnQsIGF0dHIx
LCBjb3B5aW5nIHRoaW5ncyBmcm9tIHRoZSBuZXcgQVRUUkkgdG8gYXR0cjENCmFuZCBwcm9jZXNz
IGF0dHIxLg0KRG8geW91IGFncmVlIHdpdGggYWJvdmU/DQoNCkFib3ZlIHhmc19hdHRyaV9pdGVt
X3JlY292ZXIoKSBydW5zIHN1Y2Nlc3NmdWxseSBhbmQgdGhlIEFJTCBpbnRlbnQgaXRlcmF0aW9u
IGVuZHMuDQpOb3cgaXTigJlzIHRpbWUgdG8gcHJvY2VzcyB0aGUgY2FwdHVyZV9saXN0IHdpdGgg
eGxvZ19maW5pc2hfZGVmZXJfb3BzKCkuIFRoZQ0KY2FwdHVyZV9saXN0IGNvbnRhaW5zIHRoZSBk
ZWZlcnJlZCBvcGVyYXRpb24gd2hpY2ggd2FzIGFkZGVkIGF0IGxpbmUgNjM5IHdpdGggdHlwZQ0K
WEZTX0RFRkVSX09QU19UWVBFX0FUVFIuIA0KRG8geW91IGFncmVlIHdpdGggYWJvdmU/DQoNCklu
IHhsb2dfZmluaXNoX2RlZmVyX29wcygpLCBhIG5ldyB0cmFuc2FjdGlvbiBpcyBjcmVhdGVkIGJ5
IHhmc190cmFuc19hbGxvYygpLg0KdGhlIGRlZmVycmVkIFhGU19ERUZFUl9PUFNfVFlQRV9BVFRS
IG9wZXJhdGlvbiBpcyBhdHRhY2hlZCB0byB0aGF0IG5ldw0KdHJhbnNhY3Rpb24gYnkgeGZzX2Rl
ZmVyX29wc19jb250aW51ZSgpLiBUaGVuIHRoZSBuZXcgdHJhbnNhY3Rpb24gaXMgY29tbWl0dGVk
IGJ5DQp4ZnNfdHJhbnNfY29tbWl0KCkuDQpEbyB5b3UgYWdyZWUgd2l0aCBhYm92ZT8NCg0KRHVy
aW5nIHRoZSB4ZnNfdHJhbnNfY29tbWl0KCksIHhmc19kZWZlcl9maW5pc2hfbm9yb2xsKCkgaXMg
Y2FsbGVkLiBhbmQNCnhmc19kZWZlcl9maW5pc2hfb25lKCkgaXMgY2FsbGVkIGluc2lkZSB4ZnNf
ZGVmZXJfZmluaXNoX25vcm9sbCgpLiBGb3IgdGhlDQpkZWZlcnJlZCBYRlNfREVGRVJfT1BTX1RZ
UEVfQVRUUiBvcGVyYXRpb24sIHhmc19hdHRyX2ZpbmlzaF9pdGVtKCkNCmlzIGNhbGxlZC4NCkRv
IHlvdSBhZ3JlZSB3aXRoIGFib3ZlPw0KDQpJbiB4ZnNfYXR0cl9maW5pc2hfaXRlbSgpLCB4ZnNf
YXR0cl9pbnRlbnQgKGF0dHIyKSBpcyB0YWtlbiBvdXQgZnJvbSBhYm92ZSBuZXcgQVRUUkkNCmFu
ZCBpcyBwcm9jZXNzZWQuICBhdHRyMiBhbmQgYXR0cjEgY29udGFpbiBleGFjdGx5IHNhbWUgdGhp
bmcgYmVjYXVzZSB0aGV5IGFyZSBib3RoDQpmcm9tIHRoZSBuZXcgQVRUUkkuICBTbyB0aGUgcHJv
Y2Vzc2luZyBvbiBhdHRyMiBpcyBwdXJlIGEgZHVwbGljYXRpb24gb2YgdGhlIHByb2Nlc3NpbmcN
Cm9uIGF0dHIxLiAgU28gYWN0dWFsbHkgdGhlIG5ldyBBVFRSSSBhcmUgZG91YmxlLXByb2Nlc3Nl
ZC4NCkRvIHlvdSBhZ3JlZSB3aXRoIGFib3ZlPyANCg0KDQo+IA0KPiBJT1dzLCB3ZSBuZXZlciBy
ZS11c2UgdGhlIGluY29taW5nIGludGVudCBpdGVtIHRoYXQgd2UgYXJlDQo+IHJlY292ZXJpbmcu
IFRoZSBuZXcgbG9nIGl0ZW0gd2lsbCBlbmQgdXAgaW4gdGhlIEFJTCBhdC9iZXlvbmQNCj4gbGFz
dF9sc24gd2hlbiB0aGUgQ0lMIGlzIGNvbW1pdHRlZC4gSXQgZG9lcyBub3QgZ2V0IGZ1cnRoZXIN
Cj4gcHJvY2Vzc2luZyB3b3JrIGRvbmUgdW50aWwgYWxsIHRoZSBpbnRlbnRzIGluIHRoZSBsb2cg
dGhhdCBuZWVkDQo+IHJlY292ZXJ5IGhhdmUgaGFkIHRoZWlyIGluaXRpYWwgcHJvY2Vzc2luZyBw
ZXJmb3JtZWQgYW5kIHRoZSBsb2cNCj4gc3BhY2UgdGhleSBjb25zdW1lIGhhcyBiZWVuIGZyZWVk
IHVwLg0KPiANCj4+PiBhbmQgSSB0aGluayB0aGUgQVNTRVJUIHlvdSBtb3ZlZCB3b3VsZCBkZXRl
Y3Qgc3VjaCBhIHRoaW5nLg0KPj4gDQo+PiBBU1NFUlQgaXMgbm90aGluZyBpbiBwcm9kdWN0aW9u
IGtlcm5lbCwgc28gaXQgaGFzIGxlc3MgY2hhbmNlIHRvDQo+PiBkZXRlY3QgdGhpbmdzLg0KPiAN
Cj4gUGxlYXNlIHVuZGVyc3RhbmQgdGhhdCB3ZSBkbyBhY3R1YWxseSBrbm93IGhvdyB0aGUgQVNT
RVJUDQo+IGluZnJhc3RydWN0dXJlIHdvcmtzIGFuZCB3ZSB1dGlsaXNlIGl0IHRvIG91ciBhZHZh
bnRhZ2UgaW4gbWFueQ0KPiB3YXlzLiAgV2Ugb2Z0ZW4gdXNlIGFzc2VydHMgdG8gZG9jdW1lbnQg
ZGVzaWduL2NvZGUgY29uc3RyYWludHMgYW5kDQo+IHVzZSBkZWJ1ZyBrZXJuZWxzIHRvIHBlcmZv
cm0gcnVudGltZSBkZXNpZ24gcnVsZSB2aW9sYXRpb24NCj4gZGV0ZWN0aW9uLg0KPiANCj4gSW5k
ZWVkLCB3ZSByZWFsbHkgZG9uJ3Qgd2FudCBkZXNpZ24vY29kZSBjb25zdHJhaW50cyBiZWluZyBj
aGVja2VkIG9uDQo+IHByb2R1Y3Rpb24ga2VybmVscywgbGFyZ2VseSBiZWNhdXNlIHdlIGtub3cg
dGhleSBhcmUgbmV2ZXIgZ29pbmcgdG8NCj4gYmUgdHJpcHBlZCBpbiBub3JtYWwgcHJvZHVjdGlv
biBzeXN0ZW0gb3BlcmF0aW9uLiBJT1dzLCB0aGVzZSBjaGVja3MNCj4gYXJlIHVubmVjZXNzYXJ5
IGluIHByb2R1Y3Rpb24gc3lzdGVtcyBiZWNhdXNlIHdlJ3ZlIGFscmVhZHkgZG9uZSBhbGwNCj4g
dGhlIGNvbnN0cmFpbnQvY29ycmVjdG5lc3MgY2hlY2tpbmcgb2YgdGhlIGNvZGUgb24gZGVidWcg
a2VybmVscw0KPiBiZWZvcmUgd2UgcmVsZWFzZSB0aGUgc29mdHdhcmUgdG8gcHJvZHVjdGlvbi4N
Cj4gDQo+IElmIGEgcGFydGljdWxhciBzaXR1YXRpb24gaXMgYSBwcm9kdWN0aW9uIGNvbmNlcm4s
IHdlIGNvZGUgaXQgYXMgYW4NCj4gZXJyb3IgY2hlY2ssIG5vdCBhbiBBU1NFUlQuIElmIGl0J3Mg
YSBkZXNpZ24gb3IgaW1wbGVtZW50YXRpb24NCj4gY29uc3RyYWludCBjaGVjaywgaXQncyBhbiBB
U1NFUlQuIFRoZSBsYXN0X2xzbiBBU1NFUlQgaXMgY2hlY2tpbmcNCj4gdGhhdCB0aGUgY29kZSBp
cyBiZWhhdmluZyBhY2NvcmRpbmcgdG8gZGVzaWduIGNvbnN0cmFpbnRzIChpLmUuDQo+IENJTC9B
SUwgb3JkZXJpbmcgaGFzIG5vdCBiZWVuIHNjcmV3ZWQgdXAsIGludGVudCByZWNvdmVyeSBoYXMg
bm90DQo+IGNoYW5nZWQgYmVoYXZpb3VyLCBhbmQgbmV3IG9iamVjdHMgYWx3YXlzIGFwcGVhciBh
dCA+PSBsYXN0X2xzbikuDQo+IE5vbmUgb2YgdGhlc2UgdGhpbmdzIHNob3VsZCBldmVyIG9jY3Vy
IGluIGEgcHJvZHVjdGlvbiBzeXN0ZW0gLSBpZg0KPiBhbnkgb2YgdGhlbSBvY2N1ciBkbyB0aGVu
IHdlJ2xsIGhhdmUgbXVjaCwgbXVjaCB3b3JzZSBwcm9ibGVtcyB0bw0KPiBhZGRyZXNzIHRoYW4g
bG9nIHJlY292ZXJ5IG1heWJlIHJ1bm5pbmcgYW4gaW50ZW50IHRvbyBlYXJseS4NCg0KVGhhbmtz
IGZvciB0aGUgZXhwbGFpbiBvbiB0aGUgQVNTRVJULCBJIGhhdmUgbm8gZG91YmxlIG9uIGl0LiBJ
IHdhcyB0cnlpbmcgdG8gdG8gc2F5DQp3aHkgaXQgZGlkbuKAmXQgY2FwdHVyZSB0aGUgcHJvYmxl
bSBpbiB4bG9nX3JlY292ZXJfcHJvY2Vzc19pbnRlbnRzKCkuDQoNCnRoYW5rcywNCndlbmdhbmc=
