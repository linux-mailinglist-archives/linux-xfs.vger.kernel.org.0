Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84DD673231B
	for <lists+linux-xfs@lfdr.de>; Fri, 16 Jun 2023 01:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjFOXJv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Jun 2023 19:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjFOXJu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 19:09:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F15273F
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 16:09:48 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGJhIC001345;
        Thu, 15 Jun 2023 23:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=lOIYW+0XdxvQY5i/x8eYgDHaPSHnwAyqEYgX/k+pMLU=;
 b=L3QyXH7CskWdHarWzHTrppAvuxyl2unbcg3mqxNzDgDXRErrE1iKMcp4Pv34LDkd4veH
 Y/ti9GxGsXhcBx4YLOb3lP99KnHKIsp1IZnAWLjXvUmISUedJ5HVdEdS6W3mp4oz1srP
 yMuu7BF7SynDoBzwDr9cgq0WasNvShx43R20kWFGyiiSAi1Dvjhqbqne1Uzf7mCOOOpz
 YjEEbDpt7HOQR8NAuSAnlXBV7vwhFGvM74nhIpepo27DIln4bVJ5R14XtV2X/IsZx1q+
 s9bayQctBegM1v7aiBmgGfgRjtD1tUvKUdfE9CDO+tjVQxWG9quDZrCZPUHyPO8iGePP oA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fs236y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 23:09:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35FMVhUQ009488;
        Thu, 15 Jun 2023 23:09:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm7us1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 23:09:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmbeHFMo9g8vBO9LXe+gzk0zPUJwWthUbQ+t3Zi7vD9FsbLS7h197QDg9Qf080Jc0XBOunKE6i71y0bY4/WL1u6PHWpbA4WZ+p3KtLr0SdMcRZt9X7dc9cXjf1oEFHxlgu2/+6/o4fRD0zHUdWgIKmR1ffBwjFjL7u+YruUtFhWgdvbxbGsaQDQ2owBV3nQkElAmgbw8NJrMSPbkyZ/4bAWL3lsfPaLQFv7Y3YTDZKAh+x5SevNpG7nuXhvPpTbJInNKgElaJIKwOUa51xA+iUHssOuONoc/K5z20qciza/3N172CAdDKbY3nvKeWBvh6MJTrQ3pwHP+Kx6v44W/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOIYW+0XdxvQY5i/x8eYgDHaPSHnwAyqEYgX/k+pMLU=;
 b=QgNEmeSpuzpTaS6nOcxVKPFMyx8dbyHSs+yN6OUQn+uw93/RG/dKfTzXzPx3K94eZilUc0qlGwlgwL/sW4bIuuwIPVdrLku9NahVWIW7zM81T/9HX2KLMxNesOQr/5u/b5gUitnjm5pp7aWcpEw5ClABDAWK7exG+dKOSF4R5Aa+USiY15xp7Kg1721a6/2hq8utVbIOyS1JTdvBgKxC8r/7u924ZBkQSG5aTHdmsq/AR3VnlQ3CUXYz9fYc7/FM3cLRb/ytQySqo183CI6PRs3bXqd7IxiiEvi9DW0YjQvM5B5vaw37lM3GUqdYA0D2VG0Fyh+QeKpjKq9KqgxBkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOIYW+0XdxvQY5i/x8eYgDHaPSHnwAyqEYgX/k+pMLU=;
 b=enrxBYyvORF29qT/OruL1w1VW+KKh208j1McNxdrtbeQvEAbrhftbWXowpQdX3sZUMr3SFRqmIWq3JkkCEMFZN5D6EcQoHwVt8K+owiPs1lvPY/JnmkRS1kJAnmF4wpKBT19t5VmWruU6x8JMvtYKNWg3sks4w3e65FfEaC9Q7M=
Received: from BN7PR10MB2690.namprd10.prod.outlook.com (2603:10b6:406:c0::11)
 by PH0PR10MB6436.namprd10.prod.outlook.com (2603:10b6:510:21c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 23:09:41 +0000
Received: from BN7PR10MB2690.namprd10.prod.outlook.com
 ([fe80::a89a:86fb:feca:2699]) by BN7PR10MB2690.namprd10.prod.outlook.com
 ([fe80::a89a:86fb:feca:2699%3]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 23:09:41 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Topic: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Index: AQHZnyqiJVfvBqN/ZEat6GgWNoCKPa+MalAAgAAE8YCAAASYgIAACrOA
Date:   Thu, 15 Jun 2023 23:09:41 +0000
Message-ID: <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-2-david@fromorbit.com>
 <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
 <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
In-Reply-To: <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR10MB2690:EE_|PH0PR10MB6436:EE_
x-ms-office365-filtering-correlation-id: f79fe676-1487-49d8-2880-08db6df599b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oqZDBbn5pHZwI6M4irfZ0pCXmJnBhpvebRJJuUMIwm+YxE5vOWV45C0ODcvGhB0Lqe0xwZn3o+hMN8Af8JMg6ZeUBK91hfEv/yhdg1Kb+Ww4LdOX7K70pVjzFZnnv3ajvYDjGQ5cjtl6Je0lk9eKcoYIhQJYl2FOM3w3j9I28UXYxwlnG9zuLBysm0ih/odNswgkVNhhalsT7NP/LvwvxFbBiacTk4uwGYftlPR9UCH/H83K643giUyRUNLX6z+17UklHo/4JOdEGrcuIeAgnwkvNc9P85yIrutgOiyl0Amfrd6hXynriY/rDeZjq3Y2mJKYKhQmmogA4lGXt+5yQ1VsQzwjqKxwyR7Bi5iu3aKtWIsDmIvWKbzugCLQmeG8hWWz6C09BrxJ1a8tF5+n4Tcb95zHvkfBNqCjfYHMVkxvMasLjeSr0akcYi3PqQ5PbyUGhKACguf6MgWFqHqjd0g3eqBB5K5iuS15spU9eizEr03704SwejyZap+S12vW5u5369FCdKAK5F8vQ8CxZz24BSxUtlWJ3UERZWmSHYTDJf/f8/uZT39ZQ5kRjMcXlENbGU/hmt82hEqnKSD8BHz1liOhW99aaZSgdaBJMgli3mHBzCVIFXvq1uBj9f4tJJpfve+CsY1qzkRHQlYEUfHNfQfCmHw9/o68pUdJv5E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR10MB2690.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199021)(54906003)(41300700001)(86362001)(8676002)(66446008)(6916009)(8936002)(6486002)(66556008)(66946007)(66476007)(316002)(33656002)(64756008)(71200400001)(36756003)(76116006)(91956017)(4326008)(38070700005)(478600001)(26005)(6512007)(5660300002)(966005)(83380400001)(53546011)(6506007)(2906002)(186003)(38100700002)(2616005)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEF5c3Qzdmd0QTZrSmZxZUR0THpXdTVDcnVEVkFnT3BoQVd3Nm16dVVYNlFU?=
 =?utf-8?B?Z1d5VFd3N2ZnRmtoeCt1S3M3WVgrd0twSi83eDN3MDZkMkk3RVE5ZG0vVzRQ?=
 =?utf-8?B?cldZNEU4M1hZWmp6bnZqS0RBOEtsdXNML2Q4dDlqM1dheWdSNUlBUVJKc2F4?=
 =?utf-8?B?aGpxZjcyVUEyMGJxM2JYU1N3WnFZU1FQdzBQSUNCQUhzaUtPWmJkM0dwdmJN?=
 =?utf-8?B?em84ZWJ0U2lIRHhvMnd4bkk5Y2VKSFJEUHByL2duSDJaRzlLQkFxdHNuT3dQ?=
 =?utf-8?B?RGRpOCtyR2dWcVgzMU85NnhFSlA2WUtKazRmZXBsUjF5dS9kRHdDUUIwU2RF?=
 =?utf-8?B?NEszTmtoYUxCTm4xaUFxdU1BcklnRTcrRzJRSk10OGZqcE5ZdE9vUXpSc0ZC?=
 =?utf-8?B?MkZCcHI4bWpyRDJuY3J1UlJ6L2Y2ejBEK21PcnRXNHEvSm9Cem1FdFlGdWFp?=
 =?utf-8?B?VFNUMXluOUd1eEl0b2s3RW1FeGN4MDEvUTRRTjN6MEdXYzNJbkJnajkzTkZR?=
 =?utf-8?B?bFpNTHBxQytiOGNTTC9FL2FjNjFsNWN4em1BUTgzcVJRdkhSN3A1Ykk3WmZI?=
 =?utf-8?B?OHFNem5ibVdLR0ExTVR3dEtyWjJmeDJ0bTdZdXNnbHBubmRtRG5OSW9jWURa?=
 =?utf-8?B?OGxJWmNtNDZIWTlra2dlMWtHSmlnNktpVGR5VzFoazFnUWhQT2Y0T3I2SUN1?=
 =?utf-8?B?QWZpell6czArdkkxdnhObk9idndsWW4rNDdFckhjWFAyVFdYSTBKTkU3NTEx?=
 =?utf-8?B?UnpRZW9Pc0JVSlovcGViNmFWM0ZGN29SVnIxSW1qQU9WNXNDWEtuTmgrU1dR?=
 =?utf-8?B?amlsQlNwQTBEOEZJakJuZUkrZU4xNGdybjdFaXBVNHRoOHVoaXczbzVRdEZX?=
 =?utf-8?B?anM3Q0xISWd3QmdiT1ZMQTE1dXFxK3pSc2MxVjdrOFhYUFk3VjE4YU4zK29M?=
 =?utf-8?B?bGxiVTQ0QytNYmc5dFJxVHNiK1VSOW54b0VIMmhOMTdud2hVbG5NS1RqYVZ3?=
 =?utf-8?B?OE1mL2NITGk1ZUI0OGtkdnZCUGUyUlNBWjBTMlcwZldvRUlXdld1M0xZWW9l?=
 =?utf-8?B?WEUzN2FER2dEVlBZVzZWZ3FZUDEwMUlsS2JsRVdlakJ6dTJoUTdRbkpGYnNI?=
 =?utf-8?B?SXRycndHUHE4UTYrSzVkb2JneFBwTFBHRnNyczRzdy90VzJxbUQ1UzdQaDhT?=
 =?utf-8?B?R25BSFNNM2NJM3NzWlNIcEJ4RWE1NC9hQkZ6V0NNV1h3ZEkyZ3ljSGVsSHNS?=
 =?utf-8?B?VTQ4NnA2ZUsyNmVJK2xFMWZMV1ptVDdDL0t6OFZZM2p3N2R4NzJ4SVJwR1VR?=
 =?utf-8?B?Z1JYMGk3NVNnbEVraWxYZVNrODlqQWRjRHUwOU8wdnF0ZVdQYm9YT1VVUEs2?=
 =?utf-8?B?NGg1aHgvUmRSQVV6NzhyQTNvbi9sMGJLcXhlM2lrVmEwNWxPV04vSVlIZWZF?=
 =?utf-8?B?ZXg0UlAxRHdYOXhlV1puYVZvYlBLSGJKdUNLYmd1NkZnbk5VL0pZTm1lNjNP?=
 =?utf-8?B?Z0ROY0ZDSlFKamlDd1IreFlKbXBIT2ppOTA1YlVnOXRrSUNGallJaWhGWGdP?=
 =?utf-8?B?MERqME4xa3NraHVSMGxlVWZqTm9pUmlCV0JyY05Vd3AwaFBXdGovYkMvcnFv?=
 =?utf-8?B?b0xpYlJyTzBVUUNkRXhqcS9VS3JDT3BJdHpxZWpDLzVLR3NwMi95SGRzSVoy?=
 =?utf-8?B?dXl0S3pDWTFDRlh6RGtrUDhNNVlKbmpibmhCaFppaUM3bDV2c3RoT2g3czI0?=
 =?utf-8?B?N3ZaTVJMbmxiV1pYVWk3OC9PcVA1THFMY2RObHlrYW9IQzZyOG9yYjlyM2dR?=
 =?utf-8?B?NU1GSXlYSWVzQXVRSEs0R1ZXRHlFUUdQNW9COW5GaittenJjR0hjYkZ2UVo4?=
 =?utf-8?B?SkxFcU9JajFJQjZVa2FpZTdtSXdpVVN3aGsyeHBxanJheE9nMk8rMWIzZjF3?=
 =?utf-8?B?MUplTm5QOTV1WEloNjR2TjdSNmlkN2JEdnR2REtzZjBGSWpmWmZsSUtnb2Fw?=
 =?utf-8?B?aGRTcktmUXYrYjdMMXA2MjB2U0tlRkJLYW0wYThBSjBtUjJkdWx5Mmg5THEv?=
 =?utf-8?B?eXdqNjFFblNNNVRzVzlZODhQSjRaM2dYWk1rcE9lZEdRZ3J1ZFRiVmhOSXNp?=
 =?utf-8?B?Q0I4Zmg4WFhYR2ROeHFuQnZ2RnIvRUVLdTl0WVNqZHBHSHAzRjlIS2lBSmxP?=
 =?utf-8?B?WkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1FCF96775DD564AA491CB9982042EE9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PySNAdWHcG2jMW+J2oj2VRcHHP/AkgWnET+fAGK9dDmRLpme143Nv0BKTFZs7DcX6of831WLimnJo4RabfikRURusY3f53+hJyeU4i9pTT/HYGJDgm0/p23kOZhCj6oXyQ9i7vMqzhfRvW5I+B4kb4Uroe7XVJojrAg5aVB16n98VAi8mrW09xDUZ+qRbH7AS7cFlIqJmDjr11WjuZLNqA6mU2/I/MM7hP4mzS7kclJdDlGTzS5r09fEtGfIa9XS0tmsCZ0DHH/8GyxCU6X74NRZiC2kCLzkkwkjPjy9/nFV25hl4ymvX+z2yyXHULpZ7ij78uLGeGpg8IJFSOjw9HrGL18hIg6L1YhKbBjfvH7S8c0Nd1n7bOBCRYAhtG7MzRHGtktD2rLr++BWC+zFWaRc/jUrO0ts1bJ4TXWrI9IWvPFEYwifS3/9XK38EX3g9omCxgOR+wbONX5ZPqoRgk1yGkJuJSsu/yu/2R503Ka46YrZHmraNawFO5LvMCceRMowjPpLpu/zI7GrCkJngYRPaI6yIM4rE3nXOtiaYQTv5Wmas9RYzdgJxGHxY6NvfRvfLR7yPOWDvPFYGvAgzK6WFs5Qq6dzwkkneTnZEJuF1tyeNnw2vnhmA8HRjzRSRS+XNXKR3+y5Log7dfgyNingCj09TtFzBw/9/7wsZ2ZI3aUdQHaJ0RpsxBghg8v/hznZtLbit4L418cJz7jx8qzVjOQ9wBQI8OJungJpX9L4+Muj1FHySgY5wjSPgmEVTvwd1n9fpAcEZXEYjogwrhqTa9fd+MRHGwDUar0C/tDikU4UotEgAznd91gMWYWyMkYQbszG00/sM4WyBm775w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR10MB2690.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79fe676-1487-49d8-2880-08db6df599b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 23:09:41.6474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xJzkiDzdKao/iq8naK+SgOOC7Dmjc6d/or5mUfCNZXZr/WUPefnG0ZL/pmJ8VQ68Pjh1zWH5TSv+wBRjgZcpXWci4CAGhEK1oQhmKOQ66sU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6436
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_17,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150199
X-Proofpoint-GUID: jW8k0lPhn4zDb_dwxXgbGTELRIlL0crk
X-Proofpoint-ORIG-GUID: jW8k0lPhn4zDb_dwxXgbGTELRIlL0crk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

V2hlbiBtb3VudGluZyB0aGUgcHJvYmxlbWF0aWMgbWV0YWR1bXAgd2l0aCB0aGUgcGF0Y2hlcywg
SSBzZWUgdGhlIGZvbGxvd2luZyByZXBvcnRlZC4NCg0KRm9yIG1vcmUgaW5mb3JtYXRpb24gYWJv
dXQgdHJvdWJsZXNob290aW5nIHlvdXIgaW5zdGFuY2UgdXNpbmcgYSBjb25zb2xlIGNvbm5lY3Rp
b24sIHNlZSB0aGUgZG9jdW1lbnRhdGlvbjogaHR0cHM6Ly9kb2NzLmNsb3VkLm9yYWNsZS5jb20v
ZW4tdXMvaWFhcy9Db250ZW50L0NvbXB1dGUvUmVmZXJlbmNlcy9zZXJpYWxjb25zb2xlLmh0bSNm
b3VyDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQpb
ICAgNjcuMjEyNDk2XSBsb29wOiBtb2R1bGUgbG9hZGVkDQpbICAgNjcuMjE0NzMyXSBsb29wMDog
ZGV0ZWN0ZWQgY2FwYWNpdHkgY2hhbmdlIGZyb20gMCB0byA2MjkxMzc0MDgNClsgICA2Ny4yNDc1
NDJdIFhGUyAobG9vcDApOiBEZXByZWNhdGVkIFY0IGZvcm1hdCAoY3JjPTApIHdpbGwgbm90IGJl
IHN1cHBvcnRlZCBhZnRlciBTZXB0ZW1iZXIgMjAzMC4NClsgICA2Ny4yNDkyNTddIFhGUyAobG9v
cDApOiBNb3VudGluZyBWNCBGaWxlc3lzdGVtIGFmNzU1YTk4LTVmNjItNDIxZC1hYTgxLTJkYjdi
ZmZkMmM0MA0KWyAgIDcyLjI0MTU0Nl0gWEZTIChsb29wMCk6IFN0YXJ0aW5nIHJlY292ZXJ5IChs
b2dkZXY6IGludGVybmFsKQ0KWyAgIDkyLjIxODI1Nl0gWEZTIChsb29wMCk6IEludGVybmFsIGVy
cm9yIGx0Ym5vICsgbHRsZW4gPiBibm8gYXQgbGluZSAxOTU3IG9mIGZpbGUgZnMveGZzL2xpYnhm
cy94ZnNfYWxsb2MuYy4gIENhbGxlciB4ZnNfZnJlZV9hZ19leHRlbnQrMHgzZjYvMHg4NzAgW3hm
c10NClsgICA5Mi4yNDk4MDJdIENQVTogMSBQSUQ6IDQyMDEgQ29tbTogbW91bnQgTm90IHRhaW50
ZWQgNi40LjAtcmM2ICM4DQpbICAgOTIuMjUwODY5XSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5k
YXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyAxLjUuMSAwNi8xNi8yMDIxDQpbICAg
OTIuMjUyMzAxXSBDYWxsIFRyYWNlOg0KWyAgIDkyLjI1Mjc4NF0gIDxUQVNLPg0KWyAgIDkyLjI1
MzE2Nl0gIGR1bXBfc3RhY2tfbHZsKzB4NGMvMHg3MA0KWyAgIDkyLjI1Mzg2Nl0gIGR1bXBfc3Rh
Y2srMHgxNC8weDIwDQpbICAgOTIuMjU0NDc1XSAgeGZzX2NvcnJ1cHRpb25fZXJyb3IrMHg5NC8w
eGEwIFt4ZnNdDQpbICAgOTIuMjU1NTcxXSAgPyB4ZnNfZnJlZV9hZ19leHRlbnQrMHgzZjYvMHg4
NzAgW3hmc10NClsgICA5Mi4yNTY1OTVdICB4ZnNfZnJlZV9hZ19leHRlbnQrMHg0MjgvMHg4NzAg
W3hmc10NClsgICA5Mi4yNTc2MDldICA/IHhmc19mcmVlX2FnX2V4dGVudCsweDNmNi8weDg3MCBb
eGZzXQ0KWyAgIDkyLjI1ODYzOF0gIF9feGZzX2ZyZWVfZXh0ZW50KzB4OTUvMHgxNzAgW3hmc10N
ClsgICA5Mi4yNTk2MThdICB4ZnNfdHJhbnNfZnJlZV9leHRlbnQrMHg5Ny8weDFjMCBbeGZzXQ0K
WyAgIDkyLjI2MDY3Ml0gIHhmc19leHRlbnRfZnJlZV9maW5pc2hfaXRlbSsweDE4LzB4NTAgW3hm
c10NClsgICA5Mi4yNjE4MjNdICB4ZnNfZGVmZXJfZmluaXNoX25vcm9sbCsweDE4ZS8weDZjMCBb
eGZzXQ0KWyAgIDkyLjI2Mjg5Ml0gIF9feGZzX3RyYW5zX2NvbW1pdCsweDI0MS8weDM2MCBbeGZz
XQ0KWyAgIDkyLjI2MzkwMF0gID8ga2ZyZWUrMHg3Yy8weDEyMA0KWyAgIDkyLjI2NDUwNl0gIHhm
c190cmFuc19jb21taXQrMHgxNC8weDIwIFt4ZnNdDQpbICAgOTIuMjY1NTA2XSAgeGxvZ19yZWNv
dmVyX3Byb2Nlc3NfaW50ZW50cy5pc3JhLjI4KzB4MWRiLzB4MmQwIFt4ZnNdDQpbICAgOTIuMjY2
ODAzXSAgeGxvZ19yZWNvdmVyX2ZpbmlzaCsweDM1LzB4MzAwIFt4ZnNdDQpbICAgOTIuMjY3ODQ4
XSAgPyBfX3F1ZXVlX2RlbGF5ZWRfd29yaysweDVlLzB4OTANClsgICA5Mi4yNjg2MzRdICB4ZnNf
bG9nX21vdW50X2ZpbmlzaCsweGU4LzB4MTcwIFt4ZnNdDQpbICAgOTIuMjY5Njc3XSAgeGZzX21v
dW50ZnMrMHg1MWEvMHg5MDAgW3hmc10NClsgICA5Mi4yNzA2MDhdICB4ZnNfZnNfZmlsbF9zdXBl
cisweDRkZi8weDk4MCBbeGZzXQ0KWyAgIDkyLjI3MTY0Ml0gIGdldF90cmVlX2JkZXYrMHgxYTMv
MHgyODANClsgICA5Mi4yNzIyODddICA/IF9fcGZ4X3hmc19mc19maWxsX3N1cGVyKzB4MTAvMHgx
MCBbeGZzXQ0KWyAgIDkyLjI3MzQxNV0gIHhmc19mc19nZXRfdHJlZSsweDE5LzB4MjAgW3hmc10N
ClsgICA5Mi4yNzQzNzRdICB2ZnNfZ2V0X3RyZWUrMHgyYi8weGQwDQpbICAgOTIuMjc1MDA2XSAg
PyBjYXBhYmxlKzB4MWQvMHgzMA0KWyAgIDkyLjI3NTU5OV0gIHBhdGhfbW91bnQrMHg3MDkvMHhh
NDANClsgICA5Mi4yNzYyMDJdICA/IHB1dG5hbWUrMHg1ZC8weDcwDQpbICAgOTIuMjc2ODA4XSAg
ZG9fbW91bnQrMHg4NC8weGEwDQpbICAgOTIuMjc3MzY0XSAgX194NjRfc3lzX21vdW50KzB4ZDEv
MHhmMA0KWyAgIDkyLjI3ODEwN10gIGRvX3N5c2NhbGxfNjQrMHgzYi8weDkwDQpbICAgOTIuMjc4
Nzc5XSAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NzIvMHhkYw0KWyAgIDkyLjI3
OTcwM10gUklQOiAwMDMzOjB4N2ZkYzg2ODNhMjZlDQpbICAgOTIuMjgwODAxXSBDb2RlOiA0OCA4
YiAwZCAxZCA0YyAzOCAwMCBmNyBkOCA2NCA4OSAwMSA0OCA4MyBjOCBmZiBjMyA2NiAyZSAwZiAx
ZiA4NCAwMCAwMCAwMCAwMCAwMCA5MCBmMyAwZiAxZSBmYSA0OSA4OSBjYSBiOCBhNSAwMCAwMCAw
MCAwZiAwNSA8NDg+IDNkIDAxIGYwIGZmIGZmIDczIDAxIGMzIDQ4IDhiIDBkIGVhIDRiIDM4IDAw
IGY3IGQ4IDY0IDg5IDAxIDQ4DQpbICAgOTIuMjg0NzUyXSBSU1A6IDAwMmI6MDAwMDdmZmMyMTM3
MTFkOCBFRkxBR1M6IDAwMDAwMjQ2IE9SSUdfUkFYOiAwMDAwMDAwMDAwMDAwMGE1DQpbICAgOTIu
Mjg2NDYwXSBSQVg6IGZmZmZmZmZmZmZmZmZmZGEgUkJYOiAwMDAwNTYxNzQ4MDIzYjQwIFJDWDog
MDAwMDdmZGM4NjgzYTI2ZQ0KWyAgIDkyLjI4ODA0OF0gUkRYOiAwMDAwNTYxNzQ4MDMyZjcwIFJT
STogMDAwMDU2MTc0ODAyNWEyMCBSREk6IDAwMDA1NjE3NDgwMmIwMTANClsgICA5Mi4yODk2NjVd
IFJCUDogMDAwMDdmZGM4N2U1ODE4NCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAw
MDAwMDAwMDAwDQpbICAgOTIuMjkxMzE1XSBSMTA6IDAwMDAwMDAwYzBlZDAwMDAgUjExOiAwMDAw
MDAwMDAwMDAwMjQ2IFIxMjogMDAwMDAwMDAwMDAwMDAwMA0KWyAgIDkyLjI5Mjg5OF0gUjEzOiAw
MDAwMDAwMGMwZWQwMDAwIFIxNDogMDAwMDU2MTc0ODAyYjAxMCBSMTU6IDAwMDA1NjE3NDgwMzJm
NzANClsgICA5Mi4yOTQ1MDVdICA8L1RBU0s+DQpbICAgOTIuMjk1MzUxXSBYRlMgKGxvb3AwKTog
Q29ycnVwdGlvbiBkZXRlY3RlZC4gVW5tb3VudCBhbmQgcnVuIHhmc19yZXBhaXINClsgICA5Mi4y
OTcwNzNdIFhGUyAobG9vcDApOiBDb3JydXB0aW9uIG9mIGluLW1lbW9yeSBkYXRhICgweDgpIGRl
dGVjdGVkIGF0IHhmc19kZWZlcl9maW5pc2hfbm9yb2xsKzB4NDA2LzB4NmMwIFt4ZnNdIChmcy94
ZnMvbGlieGZzL3hmc19kZWZlci5jOjU3NSkuICBTaHV0dGluZyBkb3duIGZpbGVzeXN0ZW0uDQpb
ICAgOTIuMzAwNjg2XSBYRlMgKGxvb3AwKTogUGxlYXNlIHVubW91bnQgdGhlIGZpbGVzeXN0ZW0g
YW5kIHJlY3RpZnkgdGhlIHByb2JsZW0ocykNClsgICA5Mi4zMDIzNzJdIFhGUyAobG9vcDApOiBG
YWlsZWQgdG8gcmVjb3ZlciBpbnRlbnRzDQpbICAgOTIuMzAzNTcxXSBYRlMgKGxvb3AwKTogRW5k
aW5nIHJlY292ZXJ5IChsb2dkZXY6IGludGVybmFsKQ0KDQoNCkkgdGhpbmsgdGhhdOKAmXMgYmVj
YXVzZSB0aGF0IHRoZSBzYW1lIEVGSSByZWNvcmQgd2FzIGdvaW5nIHRvIGJlIGZyZWVkIGFnYWlu
DQpieSB4ZnNfZXh0ZW50X2ZyZWVfZmluaXNoX2l0ZW0oKSBhZnRlciBpdCBhbHJlYWR5IGdvdCBm
cmVlZCBieSB4ZnNfZWZpX2l0ZW1fcmVjb3ZlcigpLg0KSSB3YXMgdHJ5aW5nIHRvIGZpeCBhYm92
ZSBpc3N1ZSBpbiBteSBwcmV2aW91cyBwYXRjaCBieSBjaGVja2luZyB0aGUgaW50ZW50DQpsb2cg
aXRlbeKAmXMgbHNuIGFuZCBhdm9pZCBydW5uaW5nIGlvcF9yZWNvdmVyKCkgaW4geGxvZ19yZWNv
dmVyX3Byb2Nlc3NfaW50ZW50cygpLg0KDQpOb3cgSSBhbSB0aGlua2luZyBpZiB3ZSBjYW4gcGFz
cyBhIGZsYWcsIHNheSBYRlNfRUZJX1BST0NFU1NFRCwgZnJvbQ0KeGZzX2VmaV9pdGVtX3JlY292
ZXIoKSBhZnRlciBpdCBwcm9jZXNzZWQgdGhhdCByZWNvcmQgdG8gdGhlIHhmc19lZmlfbG9nX2l0
ZW0NCm1lbW9yeSBzdHJ1Y3R1cmUgc29tZWhvdy4gSW4geGZzX2V4dGVudF9mcmVlX2ZpbmlzaF9p
dGVtKCksIHdlIHNraXAgdG8gcHJvY2Vzcw0KdGhhdCB4ZnNfZWZpX2xvZ19pdGVtIG9uIHNlZWlu
ZyBYRlNfRUZJX1BST0NFU1NFRCBhbmQgcmV0dXJuIE9LLiBCeSB0aGF0DQp3ZSBjYW4gYXZvaWQg
dGhlIGRvdWJsZSBmcmVlLg0KDQp0aGFua3MsDQp3ZW5nYW5nDQoNCj4gT24gSnVuIDE1LCAyMDIz
LCBhdCAzOjMxIFBNLCBXZW5nYW5nIFdhbmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNvbT4gd3Jv
dGU6DQo+IA0KPiANCj4gDQo+PiBPbiBKdW4gMTUsIDIwMjMsIGF0IDM6MTQgUE0sIERhdmUgQ2hp
bm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+PiANCj4+IE9uIFRodSwgSnVuIDE1
LCAyMDIzIGF0IDA5OjU3OjE4UE0gKzAwMDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+PiBIaSBE
YXZlLA0KPj4+IA0KPj4+IEkgZ290IHRoaXMgZXJyb3Igd2hlbiBhcHBseWluZyB0aGlzIHBhdGNo
IHRvIHRoZSBuZXdlc3QgY29kZToNCj4+PiAoSSB0cmllZCBvbiBib3RoIE1hY09TIGFuZCBPTDgs
IGl04oCZcyB0aGUgc2FtZSByZXN1bHQpDQo+Pj4gDQo+Pj4gJCBwYXRjaCAtcDEgPH4vdG1wL0Rh
dmUxLnR4dA0KPj4+IHBhdGNoaW5nIGZpbGUgJ2ZzL3hmcy9saWJ4ZnMveGZzX2FsbG9jLmMnDQo+
Pj4gcGF0Y2g6ICoqKiogbWFsZm9ybWVkIHBhdGNoIGF0IGxpbmUgMjc6ICAqLw0KPj4gDQo+PiBX
aG9hLiBJIGhhdmVuJ3QgdXNlIHBhdGNoIGxpa2UgdGhpcyBmb3IgYSBkZWNhZGUuIDopDQo+PiAN
Cj4+IFRoZSB3YXkgYWxsIHRoZSBjb29sIGtpZHMgZG8gdGhpcyBub3cgaXMgYXBwbHkgdGhlIGVu
dGlyZSBzZXJpZXMgdG8NCj4+IGRpcmVjdGx5IHRvIGEgZ2l0IHRyZWUgYnJhbmNoIHdpdGggYjQ6
DQo+PiANCj4+ICQgYjQgYW0gLW8gLSAyMDIzMDYxNTAxNDIwMS4zMTcxMzgwLTItZGF2aWRAZnJv
bW9yYml0LmNvbSB8IGdpdCBhbQ0KPj4gDQo+PiAoYjQgc2hhemFtIG1lcmdlcyB0aGUgYjQgYW0g
YW5kIGdpdCBhbSBvcGVyYXRpb25zIGludG8gdGhlIG9uZQ0KPj4gY29tbWFuZCwgSUlSQywgYnV0
IHRoYXQgdHJpY2sgaXNuJ3QgYXV0b21hdGljIGZvciBtZSB5ZXQgOikNCj4+PiBMb29raW5nIGF0
IHRoZSBwYXRjaCB0byBzZWUgdGhlIGxpbmUgbnVtYmVyczoNCj4+PiANCj4+PiAyMiBkaWZmIC0t
Z2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfYWxsb2MuYyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2FsbG9j
LmMNCj4+PiAyMyBpbmRleCBjMjBmZTk5NDA1ZDguLjExYmQwYTE3NTZhMSAxMDA2NDQNCj4+PiAy
NCAtLS0gYS9mcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jDQo+Pj4gMjUgKysrIGIvZnMveGZzL2xp
Ynhmcy94ZnNfYWxsb2MuYw0KPj4+IDI2IEBAIC0xNTM2LDcgKzE1MzYsOCBAQCB4ZnNfYWxsb2Nf
YWdfdmV4dGVudF9sYXN0YmxvY2soDQo+Pj4gMjcgICovDQo+Pj4gMjggU1RBVElDIGludA0KPj4+
IDI5IHhmc19hbGxvY19hZ192ZXh0ZW50X25lYXIoDQo+PiANCj4+IFl1cCwgaG93ZXZlciB5b3Ug
c2F2ZWQgdGhlIHBhdGNoIHRvIGEgZmlsZSBzdHJpcHBlZCB0aGUgbGVhZGluZw0KPj4gc3BhY2Vz
IGZyb20gYWxsIHRoZSBsaW5lcyBpbiB0aGUgcGF0Y2guDQo+PiANCj4+IElmIHlvdSBsb29rIGF0
IHRoZSByYXcgZW1haWwgb24gbG9yZSBpdCBoYXMgdGhlIGNvcnJlY3QgbGVhZGluZw0KPj4gc3Bh
Y2VzIGluIHRoZSBwYXRjaC4NCj4+IA0KPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgt
eGZzLzIwMjMwNjE1MDE0MjAxLjMxNzEzODAtMi1kYXZpZEBmcm9tb3JiaXQuY29tL3Jhdw0KPj4g
DQo+PiBUaGVzZSBzb3J0cyBvZiBwYXRjaGluZyBwcm9ibGVtcyBnbyBhd2F5IHdoZW4geW91IHVz
ZSB0b29scyBsaWtlIGI0DQo+PiB0byBwdWxsIHRoZSBwYXRjaGVzIGRpcmVjdGx5IGZyb20gdGhl
IG1haWxpbmcgbGlzdC4uLg0KPj4gDQo+Pj4+IE9uIEp1biAxNCwgMjAyMywgYXQgNjo0MSBQTSwg
RGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToNCj4+Pj4gDQo+Pj4+IEZy
b206IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4NCj4+Pj4gDQo+Pj4+IFRvIGF2
b2lkIGJsb2NraW5nIGluIHhmc19leHRlbnRfYnVzeV9mbHVzaCgpIHdoZW4gZnJlZWluZyBleHRl
bnRzDQo+Pj4+IGFuZCB0aGUgb25seSBidXN5IGV4dGVudHMgYXJlIGhlbGQgYnkgdGhlIGN1cnJl
bnQgdHJhbnNhY3Rpb24sIHdlDQo+Pj4+IG5lZWQgdG8gcGFzcyB0aGUgWEZTX0FMTE9DX0ZMQUdf
RlJFRUlORyBmbGFnIGNvbnRleHQgYWxsIHRoZSB3YXkNCj4+Pj4gaW50byB4ZnNfZXh0ZW50X2J1
c3lfZmx1c2goKS4NCj4+Pj4gDQo+Pj4+IFNpZ25lZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8ZGNo
aW5uZXJAcmVkaGF0LmNvbT4NCj4+Pj4gLS0tDQo+Pj4+IGZzL3hmcy9saWJ4ZnMveGZzX2FsbG9j
LmMgfCA5NiArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0NCj4+Pj4gZnMv
eGZzL2xpYnhmcy94ZnNfYWxsb2MuaCB8ICAyICstDQo+Pj4+IGZzL3hmcy94ZnNfZXh0ZW50X2J1
c3kuYyAgfCAgMyArLQ0KPj4+PiBmcy94ZnMveGZzX2V4dGVudF9idXN5LmggIHwgIDIgKy0NCj4+
Pj4gNCBmaWxlcyBjaGFuZ2VkLCA1NiBpbnNlcnRpb25zKCspLCA0NyBkZWxldGlvbnMoLSkNCj4+
Pj4gDQo+Pj4+IGRpZmYgLS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jIGIvZnMveGZz
L2xpYnhmcy94ZnNfYWxsb2MuYw0KPj4+PiBpbmRleCBjMjBmZTk5NDA1ZDguLjExYmQwYTE3NTZh
MSAxMDA2NDQNCj4+Pj4gLS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfYWxsb2MuYw0KPj4+PiArKysg
Yi9mcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jDQo+Pj4+IEBAIC0xNTM2LDcgKzE1MzYsOCBAQCB4
ZnNfYWxsb2NfYWdfdmV4dGVudF9sYXN0YmxvY2soDQo+Pj4+ICovDQo+Pj4+IFNUQVRJQyBpbnQN
Cj4+Pj4geGZzX2FsbG9jX2FnX3ZleHRlbnRfbmVhcigNCj4+Pj4gLSBzdHJ1Y3QgeGZzX2FsbG9j
X2FyZyAqYXJncykNCj4+Pj4gKyBzdHJ1Y3QgeGZzX2FsbG9jX2FyZyAqYXJncywNCj4+Pj4gKyB1
aW50MzJfdCBhbGxvY19mbGFncykNCj4+Pj4gew0KPj4+PiBzdHJ1Y3QgeGZzX2FsbG9jX2N1ciBh
Y3VyID0ge307DQo+Pj4+IGludCBlcnJvcjsgLyogZXJyb3IgY29kZSAqLw0KPj4gDQo+PiBUaGlz
IGluZGljYXRlcyB0aGUgcHJvYmxlbSBpcyBsaWtlbHkgdG8gYmUgeW91ciBtYWlsIHByb2dyYW0s
DQo+PiBiZWNhdXNlIHRoZSBxdW90aW5nIGl0IGhhcyBkb25lIGhlcmUgaGFzIGNvbXBsZXRlbHkg
bWFuZ2xlZCBhbGwgdGhlDQo+PiB3aGl0ZXNwYWNlIGluIHRoZSBwYXRjaC4uLi4NCj4+IA0KPiAN
Cj4gUmlnaHQsIHRoZSAudHh0IHdhcyBub3QgcmF3Lg0KPiBOb3cgSSBnb3QgdGhlIHJhdyBmb3Jt
YXRzIGFuZCB0aGV5IGFwcGxpZWQgdG8gdXBzdHJlYW0gbWFzdGVyLiBMZXQgbWUgcnVuIGxvZyBy
ZWNvdmVyIHdpdGggbXkgbWV0YWR1bXAsIHdpbGwgcmVwb3J0IHJlc3VsdCBsYXRlci4NCj4gDQo+
IHRoYW5rcywNCj4gd2VuZ2FuZw0KPiANCj4+IENoZWVycywNCj4+IA0KPj4gRGF2ZS4NCj4+IC0t
IA0KPj4gRGF2ZSBDaGlubmVyDQo+PiBkYXZpZEBmcm9tb3JiaXQuY29tDQoNCg0K
