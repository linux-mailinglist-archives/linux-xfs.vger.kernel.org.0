Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662E06EB70F
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Apr 2023 05:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDVDWf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Apr 2023 23:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjDVDWe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 23:22:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36A3E60
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 20:22:31 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33M2rYXS030372;
        Sat, 22 Apr 2023 03:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ZlMTPujmwwrHoNxmF3BX6WMEW5BH5QSK/B4SB85UfcQ=;
 b=qc022CxJZQuNqPsaAxfXro5hh2i6hPM+CRTVL57xUokXRldJb+CDKDsNlG2MEMwgRwqZ
 6oUboFSYoHpZUvQqr87SuAFOmw/iIjpnhTY0LuCdM/xvp3RmV+mmosPAcMXgsCOn8tfL
 pAcVcQFi+XZ95TDiE8UzrGPLUgtHkVes42uHPVvrOUF6fgZo8nJH7q0QQo/2YXjgYNsw
 V1TqKU6mp+GVT/cZAhApopd2C985+Uare0u7QP+3frkuxStVFPt/lC2ew/cAVl25JAQa
 XNqAxxZ/SlYmvIywKUzRGJpiGRp+j70XX39ir1CSTXWd3vXC3rUtaxECICwYJvr6iYzC xQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q476tr0ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Apr 2023 03:22:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33M1XRw3007440;
        Sat, 22 Apr 2023 03:22:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q46132k22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Apr 2023 03:22:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dA8Mu02tY+hkhRT9DxZfrxlLxrgcFKl9GKqY6DP9UIf/sDqiHjN9J4DMu90C5E6IRlHiitDH7R8MylGQdDNguZ8yKSnCnK/q9jXh14wXSKJ1+zP564MbawXF1dwIIKNDtOhe8FZI5qUOW3IqXV6NtbhaisnKyy4pODURGqd68MmNfpSTgTrVy8ze9cG2JzXBACmVCId5V3sh+BSpd6gBBSaDZdFmMQ/YKDcThZA/MyREpnUYwoSSnKUaOOugMl17ZNWbNkeal7iKqBhFS6j3xwMS5rh0Y+mUf6hJyd4PkzbCy0WdmuFRUJLehEXypQEa+3meqzSPh5S6c6HtprdCvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlMTPujmwwrHoNxmF3BX6WMEW5BH5QSK/B4SB85UfcQ=;
 b=XTs09u70hVz4vwIN1eUDhv2IOw0P0zceFAES+sERmyt2v1Bff6dKW9LJKooOYMahSb4/aGBwiJ2AI2PY+4YQ1rPRMZ58b5MSP9C5pul2nF8JdvH3Hq9MyhUTiuBFGxXtoSSDCuKZ3e06DKJY9Z9Zca07Bf74K58I6pDmZIzdkX5vc+S0SQK+TbAny9Hqo34lgwL8cH2dBZxVvLnBB5n22IzcJYArpf8z1MBK2ay/UZVF+SS4tlz8AEDdcEWn8QB1HOXy91NrmV8F3X8R2ONDDg6/zBym6XUQzD6PmlkR2BRz1WpgTHLUP4mNP35br0IaUi5GV707eMHcaAsJ7BjW7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlMTPujmwwrHoNxmF3BX6WMEW5BH5QSK/B4SB85UfcQ=;
 b=bRyPMD42KGiryIMdFqRCFCx6x1CUT8S/2plzWyPIl93F0LAf2BlpetPY5tzAN26LLLmmVabPJcPIMkroXlEUW9YkgxBXBbMUdcFrYDcNI54dI+FGFngbJLdU0CQIVcdO6WHGK/g7R8FQ5qPMSKMdCwU4MWVh8LBP5bAlSatl1X4=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by SJ0PR10MB5662.namprd10.prod.outlook.com (2603:10b6:a03:3da::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sat, 22 Apr
 2023 03:22:24 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%6]) with mapi id 15.20.6319.022; Sat, 22 Apr 2023
 03:22:24 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: IO time one extent per EFI
Thread-Topic: [PATCH 1/2] xfs: IO time one extent per EFI
Thread-Index: AQHZbySmyU5pA5JJVkmM3pjz5JBv5q8zVrCAgAEmyYCAAGIVAIAAEXkAgACZwACAAJObAIAAlpYA
Date:   Sat, 22 Apr 2023 03:22:23 +0000
Message-ID: <272E101F-8E95-470C-BF4E-7D409E44B331@oracle.com>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-2-wen.gang.wang@oracle.com>
 <20230419235559.GW3223426@dread.disaster.area>
 <71E9310C-06A6-41B9-AFE6-C8EE37CF5058@oracle.com>
 <20230420232206.GZ3223426@dread.disaster.area>
 <451AEBDF-7BBC-4C6E-BB0F-AFE18C51607C@oracle.com>
 <20230421093456.GE3223426@dread.disaster.area>
 <924EF54F-6D4E-46C8-93B9-8844EA4E8672@oracle.com>
In-Reply-To: <924EF54F-6D4E-46C8-93B9-8844EA4E8672@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|SJ0PR10MB5662:EE_
x-ms-office365-filtering-correlation-id: d3a68053-82b0-474f-3328-08db42e0ca49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +WCrdel44+Pl8twMS/Lbad/kpSi3RppyjuCHmGwyaVQRq0VBkpxENtIii9qnCw22KK7/+t0eArDsAfYM2PKasd5KuJRfHxK0I0tqOf46kMQ53oFetcT2khRABrfOM/3llyCnBxPJ7FQX0uAGbhspYa4sNO2NuIC7G5qX8+C2n1ovRzDYvzBRITWRaNX1OupAqf+vmEpPOIMZ0+7hiVRsFjucCXL4KmpfqKgVKb0EDT2XLUMZH0CiRvHfxdi4dgwEvVp8qa09bjDWtByQHgZsv/rb3aCfnCHiSVTZAYG8j3QQSYoTxbh8wnOcBn9LegjkfcVISMDSFVFM8y8nSGNXf6FYGWRAtCMQ0IXYEdIWHN0Egqwx3Y8+eSTqkWtyj20xghBJ36EU4i/xSLRJyGZ4SLCUD2Xzug5Wed3MoTn93lqh/6huAUK3Cjsh8sINUpk8PJGgxnMB9VeZDDZCzpRy+/qaYOcusxFBmLQ8frnq9/sHYebtcCX81MeMvoXGssXuvDV3lciJDLOo1SasHgfO8UObmaXWRwjb33yRhMjOwVrar+1vugfs83nK4384gieWyhXSJLrOlSYeLVUrmTXIZTRRAZzlKbCmTQPKvzH0HAZ5aeVtcMG+s1cH7x6+0GbLVK2nMQ7KOTJuqvWWTG0Hug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199021)(2616005)(83380400001)(478600001)(6486002)(6512007)(6506007)(71200400001)(76116006)(91956017)(66476007)(66946007)(6916009)(66556008)(64756008)(66446008)(122000001)(41300700001)(4326008)(53546011)(316002)(186003)(5660300002)(38070700005)(38100700002)(8676002)(2906002)(30864003)(8936002)(66899021)(33656002)(86362001)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzlrS25iM2xOS1EwTzBPN2NLbzVEL2pwdTFFWlprbms1NmFNWEhubzVnZ1Fi?=
 =?utf-8?B?ODdQNXloZFpHanduVzlaK0FERUdMd0NkVnRRR1dIMTY5cW9uSjdILzlUUGRk?=
 =?utf-8?B?aU01OFZJLzlIbUVNMU95bG1HZ2htZkVzT1dyb0lLTHRHS0J5c05oSVgxQjh5?=
 =?utf-8?B?bjYvQk54SFkvdjB4VFJiRlZyYlRpeVlJQU5qZGZqdUJxY2Z2RXpndmRjN1lq?=
 =?utf-8?B?aURFcmNuRG01Y2xtYzRQbmNNcXpZbklYQXIvMStpUVgyVEh1ZkduZk1JSW8v?=
 =?utf-8?B?WWdWci9zOFJBbDJVTXNqSEQwdUV2QXRZdU1TaXBmQzUzV2hCd1RWYld0cGlQ?=
 =?utf-8?B?K3JPeGJrVHhDWDlmTDVxM3d6TFgxTEdzdjVrMU01VndSblVSR1pMZEVhanpv?=
 =?utf-8?B?eDhWZEY4VkhXRWVFcUw1TWltYkwwd1NJZGVpTVN1aENxMk9sMXA1aDZHTG5h?=
 =?utf-8?B?b0psb3JQZFUvbUVtUnpja2tOQ0JCN0RRbUJGeUt0SUk0SUlOTXlRcjhtT1BJ?=
 =?utf-8?B?UFlTeVY1VlliVEVWV0wrUWhSbE5uTTh3a1o3OUhvWC9jQS9id1VIT1l4UStm?=
 =?utf-8?B?dU1pb0hyQjRFcVNwbnFCU0ttR2NvMWJLUmhxZ29qS2NIbG54azVNYWhmMUtu?=
 =?utf-8?B?a0U0Q2FHR1hUYTE4anMvZXlydnMyMEF0dnVKUmlDUzE3S0ZkMlpLL2l4Vlc0?=
 =?utf-8?B?aXd6WURodzgxQ3lyVVhhbXRkVVQxVkNmTVpCOEwxZ0YyelF0UFdEb0NweDhy?=
 =?utf-8?B?OGNCRHh1eWQ5bFU3SUV3cENoeGlJUitlUGJIQU1OTGNhV1Z3TVVUdjV5bjdz?=
 =?utf-8?B?SXQ0VEFzKzVnYkRIVHhNNzRIYUdZVGVuaTBVV254T0l0aE1leHVoYnN1YU8z?=
 =?utf-8?B?THR3TnhqOTR6TmtxR2VmNTBnMFZEOEpBblI5TDZLa2JLU1NzbUM0cFkwZm5i?=
 =?utf-8?B?Z1J4aEJ2WGdwNWpiT25zM3lEV1NIMHp5S2NFcURFbDJuVExoWWlRL0kzN1pK?=
 =?utf-8?B?RWdFczR6YWtDN1ZWUDhvbkNPMk1tSjlFb0JGa2J3Mkh0d3N3WFFIcnVPTG5S?=
 =?utf-8?B?VFlTWG1mUDZ6eGVWY1Y5eC9kNGIwUklmRnRYK0ZCSFZRM1RtM2lsU2REOWFF?=
 =?utf-8?B?SGdTOVUzR0JlcHdEZ3dXcmVNS21mTTN3NHdNU2h5U1VGWTg0Ui83dENUTWVT?=
 =?utf-8?B?bkF6Y2hLTVQ3Sm9UNXBVUm9kdTN4SjRxckJXcVJCNG9HMUdyQm01dXFzbVdu?=
 =?utf-8?B?dlpJMG9nZE9pc2NKWXI4dFhEb2RNUjU2bmt0VTFJTE1EZTRxVjVKL1c0dWJT?=
 =?utf-8?B?Q05iWDFZeTMxQVhhdUNOUjY0ZC9JYUdINFJlNGtPUVdVSmliWkdXTU5ybndk?=
 =?utf-8?B?anNXRlFmanFmUXJ5ZXJENTFER0daTFBiYmdOdmZObUg0eTM2UXJRK0szWkVU?=
 =?utf-8?B?eFNML1lJckdmalNHKzJGS1lJR3F1TURQSS9XRTdqeFBRN2FKaTdETjFzZmZ1?=
 =?utf-8?B?cmRJc0JzK2NMeHhHa1NYSEI2aHpiK0N6Q3RsL3MxbkxaR3k1RitNR1QzaUFC?=
 =?utf-8?B?djBud1dUYVhWTWVybWZPWnF5S1lIUzN5aHo4TGk1NU5pdGlHME5ZVnJUUlg4?=
 =?utf-8?B?aS9aeUVHWUpMcUNhYU1jQU9ZZXhFQm8vdWJpWUJHamZ4T0ZpeXo5dkpKVWtX?=
 =?utf-8?B?M0tTY1J2N1pwYVBROVRhSUIyMlplSDBUMmpmL1dqcnNOWE5YQTEvSm5WQVl0?=
 =?utf-8?B?aEpJek9ublhJWVVZMzVPSEgxY0xQUWVPaks0QUZHbTUxcUhBb0wra0xzYWtY?=
 =?utf-8?B?ekNFcCtBRVhYVUpRM2oyU21HbTJabmNXWllXZGpBT0NHT3IwNUh4VlJUSDhU?=
 =?utf-8?B?aENRQUZtOU9XcVR6aHgxcXY5VlVGTCt5bW4yTmJtRmdiSStrUU53bE9EV21O?=
 =?utf-8?B?dksyT3ZGeVhsSmtEcHJxcWpZeUpRWXd0T1dCU2hqcjdlT0NiYU5kK0hVQjl0?=
 =?utf-8?B?akt1YVZTUzNaMi9Vd2xFYnVoZWZ4bFhVby9jVGF2Ty92b3BiTDFZSGxidWRn?=
 =?utf-8?B?cUtlL3NSeDRoalFoUllOYllpLzIyTGpIeW93K2RhSE9YY1hrZkFyWDNNcVZN?=
 =?utf-8?B?c1BCRGtJb3NUaXdVQWlBbHY4bTlCNGdpVlJ6QStaaThLcG9SYTZaekFvc00z?=
 =?utf-8?Q?BxSUvSvo/JunYRG7+KTCOCyE2bJAv7MhlLIomstlN3zY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E73F8CA2CD59C6478E6D722232B1A868@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1vgoSz04qGCtr2jK7EcsuvapMv9Qv1YaEaVHuAeYRV5bFOOH7dNAFZWosTVDqDoI/HeidO18ycWdPlcd+x1D6qmlZ/WEujVB0wsYYuyfWB0JH4DOuSJ+7w7DdMdibvUEAAhTtmRlCHipzBaIJnN/QNdJ+enakfqiRwqiJVAeqGo5jRs7T85Oajc5h7WYeY7xZG/+wTeKiFWhhE1EinGw1Er3DBXGud3NX/GcEwPxOEOGOPQmiUuExYzkIRR00IWMt0Qte6IMg3+JXIc5krXaWRycEBK6sTVGeBHKVIiTLcpOK42JYucBYnRu7AF3E4NLBPq+qDRNQkg4jSufvUk9b7vdycRlY/0+hZLdAjYZ8D+40Wsr46JEFSCLGIZAFixDANVazX0AbPvDeS3xx+EasdW1Rb+MbstwNQZQZqimq2z4n3NR9UbLF886lh64O/izGF/A7j1UARPxOU2axCV0TtEEJIqz4bAA4NTZHOl6rP8UvxuwEVlFi7OzPCsKSZMT0e2ZYh1muhsNX489fLffVLosBT2xrRX5Ej7QsrW0TicZ7cnhbZwDXCZ4C2mo4pXA3RoBcma3ZF2SO8RlI4Vpv35wWmoBjkBXJ0laYvfZNJQKbkHXLS6IaWdL/1yF9hEzuHMxrf0oRipOKmiRkyFHQ7qWJET6HlvEzShl1WifjH4RYxJyTdI6sPEPFp0TB5OLeZ3mNE9ilrffoBKreYuS6VDx4XfJdm2zqfyowLF8as8vvXuHlQ9uopXWtUIQNLHZ9kaUIpZU624+Zm5M9QmTQaNrjkB4H1g7zv+EPejJI4s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a68053-82b0-474f-3328-08db42e0ca49
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2023 03:22:23.6727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NBJlzeg4UThzpomhZ/BRHNQl2hVu8lTnUmNrJZWIWMTBs7Rhoy3tpM/jMpZLYqqcJDEr64UOu/7sSoBhCWftZe3X05kPN9QjetmHO7s8PJI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_08,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304220029
X-Proofpoint-GUID: V87pRiFrRmi5oVAMn_i67y8aLYgivQXy
X-Proofpoint-ORIG-GUID: V87pRiFrRmi5oVAMn_i67y8aLYgivQXy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gQXByIDIxLCAyMDIzLCBhdCAxMToyMyBBTSwgV2VuZ2FuZyBXYW5nIDx3ZW4uZ2Fu
Zy53YW5nQG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gDQo+IA0KPj4gT24gQXByIDIxLCAyMDIz
LCBhdCAyOjM0IEFNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOg0K
Pj4gDQo+PiBPbiBGcmksIEFwciAyMSwgMjAyMyBhdCAxMjoyNDo0OUFNICswMDAwLCBXZW5nYW5n
IFdhbmcgd3JvdGU6DQo+Pj4+IE9uIEFwciAyMCwgMjAyMywgYXQgNDoyMiBQTSwgRGF2ZSBDaGlu
bmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToNCj4+Pj4gV2UgZG9uJ3QgZG8gdGhhdCBh
bnltb3JlIGZvciBwYXJ0aWFsbHkgcHJvY2Vzc2VkIG11bHRpLWV4dGVudA0KPj4+PiBpbnRlbnRz
IGFueW1vcmUuIEluc3RlYWQsIHdlIHVzZSBkZWZlcnJlZCBvcHMgdG8gY2hhaW4gdXBkYXRlcy4g
aS5lLg0KPj4+PiB3ZSBsb2cgYSBjb21wbGV0ZSBpbnRlbnQgZG9uZSBpdGVtcyBhbG9uZ3NpZGUg
YSBuZXcgaW50ZW50DQo+Pj4+IGNvbnRhaW5pbmcgdGhlIHJlbWFpbmluZyB3b3JrIHRvIGJlIGRv
bmUgaW4gdGhlIHNhbWUgdHJhbnNhY3Rpb24uDQo+Pj4+IFRoaXMgY2FuY2VscyB0aGUgb3JpZ2lu
YWwgaW50ZW50IGFuZCBhdG9taWNhbGx5IHJlcGxhY2VzIGl0IHdpdGggYQ0KPj4+PiBuZXcgaW50
ZW50IGNvbnRhaW5pbmcgdGhlIHJlbWFpbmluZyB3b3JrIHRvIGJlIGRvbmUuDQo+Pj4+IA0KPj4+
PiBTbyB3aGVuIEkgc2F5ICJ1cGRhdGUgdGhlIEVGRCIgSSdtIHVzaW5nIGhpc3RvcmljIHRlcm1p
bm9sb2d5IGZvcg0KPj4+PiBwcm9jZXNzaW5nIGFuZCByZWNvdmVyaW5nIG11bHRpLWV4dGVudCBp
bnRlbnRzLiBJbiBtb2Rlcm4gdGVybXMsDQo+Pj4+IHdoYXQgSSBtZWFuIGlzICJ1cGRhdGUgdGhl
IGRlZmVycmVkIHdvcmsgaW50ZW50IGNoYWluIHRvIHJlZmxlY3QgdGhlDQo+Pj4+IHdvcmsgcmVt
YWluaW5nIHRvIGJlIGRvbmUiLg0KPj4+IA0KPj4+IE9LLiBzbyBsZXTigJlzIHNlZSB0aGUgZGlm
ZmVyZW5jZSBiZXR3ZWVuIHlvdXIgaW1wbGVtZW50YXRpb24gZnJvbSBtaW5lLg0KPj4+IFNheSwg
dGhlcmUgYXJlIHRocmVlIGV4dGVudHMgdG8gZnJlZS4NCj4+PiANCj4+PiBNeSBwYXRjaCB3b3Vs
ZCByZXN1bHQgaW46DQo+Pj4gDQo+Pj4gRUZJIDEgIHdpdGggZXh0ZW50MQ0KPj4+IGZyZWUgZXh0
ZW50MQ0KPj4+IEVGRCAxIHdpdGggZXh0ZW50MQ0KPj4+IHRyYW5zYWN0aW9uIHJvbGwNCj4+PiBF
RkkgMiB3aXRoIGV4dGVudDINCj4+PiBmcmVlIGV4dGVudDINCj4+PiBFRkQgMiB3aXRoIGV4dGVu
dDINCj4+PiB0cmFuc2FjdGlvbiByb2xsDQo+Pj4gRUZJIDMgd2l0aCBleHRlbnQzDQo+Pj4gZnJl
ZSBleHRlbnQzDQo+Pj4gRUZEMyB3aXRoIGV4dGVudDMNCj4+PiB0cmFuc2FjdGlvbiBjb21taXQN
Cj4+IA0KPj4gTm8sIGl0IHdvdWxkbid0LiBUaGlzIGlzbid0IGhvdyB0aGUgZGVmZXJyZWQgd29y
ayBwcm9jZXNzZXMgd29yaw0KPj4gaXRlbXMgb24gdGhlIHRyYW5zYWN0aW9uLiBBIHdvcmsgaXRl
bSB3aXRoIG11bHRpcGxlIGV4dGVudHMgb24gaXQNCj4+IHdvdWxkIHJlc3VsdCBpbiB0aGlzOg0K
Pj4gDQo+PiB4ZnNfZGVmZXJfZmluaXNoKHRwKSAgIyB0cCBjb250YWlucyB0aHJlZSB4ZWZpIHdv
cmsgaXRlbXMgDQo+PiB4ZnNfZGVmZXJfZmluaXNoX25vcm9sbA0KPj4gICB4ZnNfZGVmZXJfY3Jl
YXRlX2ludGVudHMoKQ0KPj4gICAgIGxpc3RfZm9yX2VhY2hfZGVmZXJfcGVuZGluZw0KPj4gICAg
ICAgeGZzX2RlZmVyX2NyZWF0ZV9pbnRlbnQoZGZwKQ0KPj4gb3BzLT5jcmVhdGVfaW50ZW50KHRw
LCAmZGZwLT5kZnBfd29yaywgZGZwLT5kZnBfY291bnQsIHNvcnQpOw0KPj4gICB4ZnNfZXh0ZW50
X2ZyZWVfY3JlYXRlX2ludGVudCgpDQo+PiAgICAgPGNyZWF0ZSBFRkk+DQo+PiAgICAgbGlzdF9m
b3JfZWFjaF94ZWZpDQo+PiAgICAgICB4ZnNfZXh0ZW50X2ZyZWVfbG9nX2l0ZW0oeGVmaSkNCj4+
IDxhZGRzIGV4dGVudCB0byBjdXJyZW50IEVGST4NCj4+IA0KPj4geGZzX2RlZmVyX3RyYW5zX3Jv
bGwoKQ0KPj4gICA8c2F2ZT4NCj4+ICAgeGZzX3RyYW5zX3JvbGwoKQ0KPj4gICAgIHhmc190cmFu
c19kdXAoKQ0KPj4gICAgIHhmc190cmFuc19jb21taXQoKQ0KPj4gICA8cmVzdG9yZT4NCj4+IA0K
Pj4gQXQgdGhpcyBwb2ludCB3ZSBoYXZlIHRoaXMgY29tbWl0dGVkIHRvIHRoZSBDSUwNCj4+IA0K
Pj4gRUZJIDEgd2l0aCBleHRlbnQxDQo+PiBFRkkgMiB3aXRoIGV4dGVudDINCj4+IEVGSSAzIHdp
dGggZXh0ZW50Mw0KPj4gDQo+PiBBbmQgeGZzX2RlZmVyX2ZpbmlzaF9ub3JvbGwoKSBjb250aW51
ZXMgd2l0aA0KPj4gDQo+PiA8Z3JhYnMgZmlyc3Qgd29yayBpdGVtPg0KPj4geGZzX2RlZmVyX2Zp
bmlzaF9vbmUoZGZwKQ0KPj4gICAtPmNyZWF0ZV9kb25lKEVGSSAxKQ0KPj4gICAgIHhmc19leHRl
bnRfZnJlZV9jcmVhdGVfZG9uZQ0KPj4gPGNyZWF0ZSBFRkQ+DQo+PiAgIGxpc3RfZm9yX2VhY2hf
eGVmaQ0KPj4gICAgIG9wcy0+ZmluaXNoX2l0ZW0odHAsIGRmcC0+ZGZwX2RvbmUsIGxpLCAmc3Rh
dGUpOw0KPj4gICAgICAgeGZzX2V4dGVudF9mcmVlX2ZpbmlzaF9pdGVtKCkNCj4+IHhmc190cmFu
c19mcmVlX2V4dGVudA0KPj4gICBfX3hmc19mcmVlX2V4dGVudA0KPj4gICAgIDxhZGRzIGV4dGVu
dCB0byBFRkQ+DQo+PiANCj4+IEFuZCBvbmNlIHRoZSBwcm9jZXNzaW5nIG9mIHRoZSBzaW5nbGUg
d29yayBpdGVtIGlzIGRvbmUgd2UgbG9vcA0KPj4gYmFjayB0byB0aGUgc3RhcnQgb2YgdGhlIHhm
c19kZWZlcl9maW5pc2hfbm9yb2xsKCkgbG9vcC4gV2UgZG9uJ3QNCj4+IGhhdmUgYW55IG5ldyBp
bnRlbnRzLCBzbyB4ZnNfZGVmZXJfY3JlYXRlX2ludGVudHMoKSByZXR1cm5zIGZhbHNlLA0KPj4g
YnV0IHdlIGNvbXBsZXRlZCBhIGRmcCB3b3JrIGl0ZW0sIHNvIHdlIHJ1bjoNCj4+IA0KPj4geGZz
X2RlZmVyX3RyYW5zX3JvbGwoKQ0KPj4gICA8c2F2ZT4NCj4+ICAgeGZzX3RyYW5zX3JvbGwoKQ0K
Pj4gICAgIHhmc190cmFuc19kdXAoKQ0KPj4gICAgIHhmc190cmFuc19jb21taXQoKQ0KPj4gICA8
cmVzdG9yZT4NCj4+IA0KPj4gQXQgdGhpcyBwb2ludCB3ZSBoYXZlIHRoaXMgY29tbWl0dGVkIHRv
IHRoZSBDSUwNCj4+IA0KPj4gRUZJIDEgd2l0aCBleHRlbnQxDQo+PiBFRkkgMiB3aXRoIGV4dGVu
dDINCj4+IEVGSSAzIHdpdGggZXh0ZW50Mw0KPj4gPEFHRiwgQUdGTCwgZnJlZSBzcGFjZSBidHJl
ZSBibG9jayBtb2RzPg0KPj4gRUZEIDEgd2l0aCBleHRlbnQxDQo+PiANCj4+IFRoZW4gd2UgcnVu
IHhmc19kZWZlcl9maW5pc2hfb25lKCkgb24gRUZJIDIsIGNvbW1pdCwgdGhlbiBydW4NCj4+IHhm
c19kZWZlcl9maW5pc2hfb25lKCkgb24gRUZJIDMuIEF0IHRoaXMgcG9pbnQsIHdlIGhhdmUgaW4g
dGhlIGxvZzoNCj4+IA0KPj4gRUZJIDEgd2l0aCBleHRlbnQxDQo+PiBFRkkgMiB3aXRoIGV4dGVu
dDINCj4+IEVGSSAzIHdpdGggZXh0ZW50Mw0KPj4gPEFHRiwgQUdGTCwgZnJlZSBzcGFjZSBidHJl
ZSBibG9jayBtb2RzPg0KPj4gRUZEIDEgd2l0aCBleHRlbnQxDQo+PiA8QUdGLCBBR0ZMLCBmcmVl
IHNwYWNlIGJ0cmVlIGJsb2NrIG1vZHM+DQo+PiBFRkQgMiB3aXRoIGV4dGVudDINCj4+IA0KPj4g
QnV0IHdlIGhhdmUgbm90IGNvbW1pdHRlZCB0aGUgZmluYWwgZXh0ZW50IGZyZWUgb3IgRUZEIDMg
LSB0aGF0J3MgaW4NCj4+IHRoZSBsYXN0IHRyYW5zYWN0aW9uIGNvbnRleHQgd2UgcGFzcyBiYWNr
IHRvIHRoZSBfeGZzX3RyYW5zX2NvbW1pdCgpDQo+PiBjb250ZXh0IGZvciBpdCB0byBmaW5hbGlz
ZSBhbmQgY2xvc2Ugb2ZmIHRoZSByb2xsaW5nIHRyYW5zYWN0aW9uDQo+PiBjaGFpbi4gQXQgdGhp
cyBwb2ludCwgd2UgZmluYWxseSBoYXZlIHRoaXMgaW4gdGhlIENJTDoNCj4+IA0KPj4gRUZJIDEg
d2l0aCBleHRlbnQxDQo+PiBFRkkgMiB3aXRoIGV4dGVudDINCj4+IEVGSSAzIHdpdGggZXh0ZW50
Mw0KPj4gPEFHRiwgQUdGTCwgZnJlZSBzcGFjZSBidHJlZSBibG9jayBtb2RzPg0KPj4gRUZEIDEg
d2l0aCBleHRlbnQxDQo+PiA8QUdGLCBBR0ZMLCBmcmVlIHNwYWNlIGJ0cmVlIGJsb2NrIG1vZHM+
DQo+PiBFRkQgMiB3aXRoIGV4dGVudDINCj4+IDxBR0YsIEFHRkwsIGZyZWUgc3BhY2UgYnRyZWUg
YmxvY2sgbW9kcz4NCj4+IEVGRCAzIHdpdGggZXh0ZW50Mw0KPiANCj4gDQo+IFllcywgY29ycmVj
dC4gdGhhbmtzIGZvciBzbyBtdWNoIGRldGFpbHMhIEkgbWlzLXJlYWQgeGZzX2RlZmVyX2NyZWF0
ZV9pbnRlbnRzKCkNCj4gdGhpbmtpbmcgaXQgb25seSBjcmVhdGUgaW50ZW50IGZvciB0aGUgZmly
c3QgaW4gdHAtPnRfZGZvcHMuDQo+IA0KPj4gDQo+Pj4gVGhlIEVGSS9FRkQgbG9nIGl0ZW0gcGFp
cnMgc2hvdWxkIG5vdCBiZSB3cml0dGVuIHRvIGxvZyBhcyB0aGV5IGFwcGVhciBpbiBzYW1lIGNo
ZWNrcG9pbnQuDQo+PiANCj4+IEkgKmFsd2F5cyogaWdub3JlIENJTCBpbnRlbnQgd2hpdGVvdXRz
IHdoZW4gdGhpbmtpbmcgYWJvdXQNCj4+IHRyYW5zYWN0aW9uIGNoYWlucyBhbmQgaW50ZW50cy4g
VGhhdCBpcyBwdXJlbHkgYSBqb3VybmFsIGVmZmljaWVuY3kNCj4+IG9wdGltaXNhdGlvbiwgbm90
IHNvbWV0aGluZyB0aGF0IGlzIG5lY2Vzc2FyeSBmb3IgY29ycmVjdCBvcGVyYXRpb24uDQo+IA0K
PiBPSy4NCj4gDQo+PiANCj4+PiBZb3VyIGlkZWEgeWllbGRzIHRoaXM6DQo+Pj4gDQo+Pj4gRUZJ
IDEgd2l0aCBleHRlbnQxIGV4dGVudDIgZXh0ZW50Mw0KPj4+IGZyZWUgZXh0ZW50MQ0KPj4+IEVG
SSAyIHdpdGggZXh0ZW50MiBleHRlbnQzDQo+Pj4gRUZEIDEgd2l0aCBleHRlbnQxIGV4dGVudDIg
ZXh0ZW50Mw0KPj4+IHRyYW5zYWN0aW9uIGNvbW1pdA0KPj4+IGNyZWF0ZSB0cmFuc2FjdGlvbg0K
Pj4+IGZyZWUgZXh0ZW50Mg0KPj4+IEVGSSAzIHdpdGggZXh0ZW50Mw0KPj4+IEVGRCAyIHdpdGgg
ZXh0ZW50IGV4dGVudDIgZXh0ZW50Mw0KPj4+IHRyYW5zYWN0aW9uIGNvbW1pdA0KPj4+IGNyZWF0
ZSB0cmFuc2FjdGlvbg0KPj4+IGZyZWUgZXh0ZW50Mw0KPj4+IEVGRCAzIHdpdGggZXh0ZW50Mw0K
Pj4+IHRyYW5zYWN0aW9uIGNvbW1pdC4NCj4+IA0KPj4gVGhlIEVGSS9FRkQgY29udGVudHMgYXJl
IGNvcnJlY3QsIGJ1dCB0aGUgcmVzdCBvZiBpdCBpcyBub3QgLSBJIGFtDQo+PiBub3Qgc3VnZ2Vz
dGluZyBvcGVuIGNvZGluZyB0cmFuc2FjdGlvbiByb2xsaW5nIGxpa2UgdGhhdC4gRXZlcnl0aGlu
Zw0KPj4gSSBhbSBzdWdnZXN0aW5nIHdvcmtzIHRocm91Z2ggdGhlIHNhbWUgZGVmZXIgb3BzIG1l
Y2hhbmlzbSBhcyB5b3UNCj4+IGFyZSBkZXNjcmliaW5nLiBTbyBpZiB3ZSBzdGFydCB3aXRoIHRo
ZSBpbml0aWFsIGpvdXJuYWwgY29udGVudHMNCj4+IGxvb2tzIGxpa2UgdGhpczoNCj4+IA0KPj4g
RUZJIDEgd2l0aCBleHRlbnQxIGV4dGVudDIgZXh0ZW50My4NCj4+IA0KPj4gVGhlbiB3ZSBydW4g
eGZzX2RlZmVyX2ZpbmlzaF9vbmUoKSBvbiB0aGF0IHdvcmssIA0KPj4gDQo+PiB4ZnNfZGVmZXJf
ZmluaXNoX29uZShkZnApDQo+PiAgIC0+Y3JlYXRlX2RvbmUoRUZJIDEpDQo+PiAgICAgeGZzX2V4
dGVudF9mcmVlX2NyZWF0ZV9kb25lDQo+PiA8Y3JlYXRlIEVGRD4NCj4+ICAgbGlzdF9mb3JfZWFj
aF94ZWZpDQo+PiAgICAgb3BzLT5maW5pc2hfaXRlbSh0cCwgZGZwLT5kZnBfZG9uZSwgbGksICZz
dGF0ZSk7DQo+PiAgICAgICB4ZnNfZXh0ZW50X2ZyZWVfZmluaXNoX2l0ZW0oKQ0KPj4geGZzX3Ry
YW5zX2ZyZWVfZXh0ZW50DQo+PiAgIF9feGZzX2ZyZWVfZXh0ZW50DQo+PiAgICAgPGFkZHMgZXh0
ZW50IHRvIEVGRD4NCj4+IA0KPj4gQnV0IG5vdyB3ZSBoYXZlIDMgeGVmaXMgb24gdGhlIHdvcmsg
dG8gcHJvY2Vzcy4gU28gb24gc3VjY2VzcyBvZg0KPj4gdGhlIGZpcnN0IGNhbGwgdG8geGZzX3Ry
YW5zX2ZyZWVfZXh0ZW50KCksIHdlIHdhbnQgaXQgdG8gcmV0dXJuDQo+PiAtRUFHQUlOIHRvIHRy
aWdnZXIgdGhlIGV4aXN0aW5nIHJlbG9nZ2luZyBjb2RlIHRvIGNyZWF0ZSB0aGUgbmV3DQo+PiBF
RkkuIEhvdyB0aGlzIHdvcmtzIGlzIGRlc2NyaWJlIGluIHRoZSBzZWN0aW9uICJSZXF1ZXN0aW5n
IGENCj4+IEZyZXNoIFRyYW5zYWN0aW9uIHdoaWxlIEZpbmlzaGluZyBEZWZlcnJlZCBXb3JrIiBp
bg0KPj4gZnMveGZzL2xpYnhmcy94ZnNfZGVmZXIuYywgbm8gcG9pbnQgbWUgZHVwbGljYXRpbmcg
dGhhdCBoZXJlLg0KPj4gDQo+PiBUaGUgcmVzdWx0IGlzIHRoYXQgdGhlIGRlZmVycmVkIHdvcmsg
aW5mcmFzdHJ1Y3R1cmUgZG9lcyB0aGUgd29yaw0KPj4gb2YgdXBkYWluZyB0aGUgZG9uZSBpbnRl
bnQgYW5kIGNyZWF0aW5nIHRoZSBuZXcgaW50ZW50cyBmb3IgdGhlIHdvcmsNCj4+IHJlbWFpbmlu
Zy4gSGVuY2UgYWZ0ZXIgdGhlIG5leHQgdHJhbnNhY3Rpb24gcm9sbCwgd2UgaGF2ZSBpbiB0aGUg
Q0lMDQo+PiANCj4+IEVGSSAxIHdpdGggZXh0ZW50MSBleHRlbnQyIGV4dGVudDMuDQo+PiA8QUdG
LCBBR0ZMLCBmcmVlIHNwYWNlIGJ0cmVlIGJsb2NrIG1vZHM+DQo+PiBFRkQgMSB3aXRoIGV4dGVu
dDEgZXh0ZW50MiBleHRlbnQzLg0KPj4gRUZJIDIgd2l0aCBleHRlbnQyIGV4dGVudDMuDQo+PiAN
Cj4gDQo+IFRha2luZyB0cmFuc2FjdGlvbiByb2xscyBpbnRvIGFjY291bnQgKGFsc28gYWRkaW5n
IHVwIHRvIEVGRDMpLCBhYm92ZSB3b3VsZCBiZToNCj4gDQo+IEVGSSAxIHdpdGggZXh0ZW50MSBl
eHRlbnQyIGV4dGVudDMuDQo+IHRyYW5zYWN0aW9uIHJvbGwNCj4gPEFHRiwgQUdGTCwgZnJlZSBz
cGFjZSBidHJlZSBibG9jayBtb2RzPiAgZm9yIGV4dGVudCAxDQo+IEVGRCAxIHdpdGggZXh0ZW50
MSBleHRlbnQyIGV4dGVudDMuDQo+IEVGSSAyIHdpdGggZXh0ZW50MiBleHRlbnQzLg0KPiB0cmFu
c2FjdGlvbiByb2xsDQo+IGZyZWUgZXh0ZW50IDINCj4gRUZEIDIgd2l0aCBleHRlbnQyIGV4dGVu
dDMNCj4gRUZJIDMgd2l0aCBleHRlbnQzDQo+IHRyYW5zYWN0aW9uIHJvbGwNCj4gZnJlZSBleHRl
bnQgMw0KPiBFRkQgMyB3aXRoIGV4dGVudDMNCj4gDQo+IEJlY2F1c2UgRUZEIE4gaXMgYWx3YXlz
IGJlIHdpdGggRUZJIE4rMSBpbiB0aGUgU0FNRSB0cmFuc2FjdGlvbiwgc28gRUZJIE4rMSBkb2Vz
buKAmXQgaGF2ZSB0byBiZSBwbGFjZWQgYmVmb3JlIEVGRCBOLg0KPiBJIGdvdCBpdC4NCj4gDQo+
PiBBbmQgc28gdGhlIGxvb3AgZ29lcyB1bnRpbCB0aGVyZSBpcyBubyBtb3JlIHdvcmsgcmVtYWlu
aW5nLg0KPj4gDQo+Pj4gWW91ciBpbXBsZW1lbnRhdGlvbiBhbHNvIGluY2x1ZGVzIHRocmVlIEVG
SS9FRkQgcGFpcnMsIHRoYXTigJlzIHRoZSBzYW1lIGFzIG1pbmUuDQo+Pj4gU28gYWN0dWFsbHkg
aXTigJlzIHN0aWxsIG9uZSBleHRlbnQgcGVyIEVGSSBwZXIgdHJhbnNhY3Rpb24uIFRob3VnaCB5
b3UgYXJlIG5vdCBjaGFuZ2luZw0KPj4+IFhGU19FRklfTUFYX0ZBU1RfRVhURU5UUy4NCj4+IA0K
Pj4gVGhlIGRpZmZlcmVuY2UgaXMgdGhhdCB3aGF0IEknbSBzdWdnZXN0aW5nIGlzIHRoYXQgdGhl
IGV4dGVudCBmcmVlDQo+PiBjb2RlIGNhbiBkZWNpZGUgd2hlbiBpdCBuZWVkcyBhIHRyYW5zYWN0
aW9uIHRvIGJlIHJvbGxlZC4gSXQgaXNuJ3QNCj4+IGZvcmNlZCB0byBhbHdheXMgcnVuIGEgc2lu
Z2xlIGZyZWUgcGVyIHRyYW5zYWN0aW9uLCBpdCBjYW4gZGVjaWRlDQo+PiB0aGF0IGl0IGNhbiBm
cmVlIG11bHRpcGxlIGV4dGVudHMgcGVyIHRyYW5zYWN0aW9uIGlmIHRoZXJlIGlzIG5vDQo+PiBy
aXNrIG9mIGRlYWRsb2NrcyAoZS5nLiBleHRlbnRzIGFyZSBpbiBkaWZmZXJlbnQgQUdzKS4gIEZv
cmNpbmcNCj4+IGV2ZXJ5dGhpbmcgdG8gYmUgbGltaXRlZCB0byBhIHRyYW5zYWN0aW9uIHBlciBl
eHRlbnQgZnJlZSBldmVuIHdoZW4NCj4+IHRoZXJlIGlzIG5vIHJpc2sgb2YgZGVhZGxvY2tzIGZy
ZWVpbmcgbXVsdGlwbGUgZXh0ZW50cyBpbiBhIHNpbmdsZQ0KPj4gdHJhbnNhY3Rpb24gaXMgdW5u
ZWNlc3NhcnkuDQo+PiANCj4+IEluZGVlZCwgaWYgdGhlIHNlY29uZCBleHRlbnQgaXMgaW4gYSBk
aWZmZXJlbnQgQUcsIHdlIGRvbid0IHJpc2sNCj4+IGJ1c3kgZXh0ZW50cyBjYXVzaW5nIHVzIGlz
c3Vlcywgc28gd2UgY291bGQgZG86DQo+PiANCj4+IEVGSSAxIHdpdGggZXh0ZW50MSBleHRlbnQy
IGV4dGVudDMuDQo+PiA8QUdGIDEsIEFHRkwgMSwgZnJlZSBzcGFjZSBidHJlZSBibG9jayBtb2Rz
Pg0KPj4gPEFHRiAyLCBBR0ZMIDIsIGZyZWUgc3BhY2UgYnRyZWUgYmxvY2sgbW9kcz4NCj4+IEVG
RCAxIHdpdGggZXh0ZW50MSBleHRlbnQyIGV4dGVudDMuDQo+PiBFRkkgMiB3aXRoIGV4dGVudDMu
DQo+PiAuLi4uLg0KPj4gDQo+IA0KPiBNeSB0aHVtYiBpcyB1cC4NCg0KV2VsbCwgSSBhbSB3b25k
ZXJpbmcgaWYgdGhlcmUgaXMgQUJCQSBkZWFkbG9jayBpbnN0ZWFkIG9mIHNlbGYgZGVhZGxvY2sg
dGhlbi4NClNheSBwcm9jZXNzIDEgcHJvZHVjZWQgYnVzeSBleHRlbnQgMSBvbiBBRyAwIGFuZCBu
b3cgYmxvY2tpbmcgYXQgQUdGTA0KYWxsb2NhdGlvbiBvbiBBRyAxLiBBbmQgYXQgdGhlIHNhbWUg
dGltZSwgcHJvY2VzcyAyIHByb2R1Y2VkIGJ1c3kgZXh0ZW50IDIgb24gQUcgMQ0KYW5kIG5vdyBi
bG9ja2luZyBhdCBBR0ZMIGFsbG9jYXRpb24gb24gQUcgMC4gQW55dGhpbmcgcHJldmVudHMgdGhh
dCBmcm9tIGhhcHBlbmluZz8NCg0KU2hhbGwgd2UgaW50cm9kdWNlIGEgcGVyIEZTIGxpc3QsIHNh
eSBuYW1lZCDigJxwZW5kaW5nX2J1c3lfQUdzIiwgd2hlcmUgdGhlIEFHIG51bWJlcg0KYXJlIHN0
b3JlZCB0aGVyZS4gRm9yIHRob3NlIEFHcw0KdGhleSBoYXZlIHBlbmRpbmcgYnVzeSBleHRlbnRz
IGluIGluLW1lbW9yeSB0cmFuc2FjdGlvbnMgKG5vdCBjb21taXR0ZWQgdG8gQ0lMKS4NCldlIGFk
ZCB0aGUgQUcgbnVtYmVyIHRvIHBlbmRpbmdfYnVzeV9BR3MgYXQgdGhlIHN0YXJ0IG9mIHhmc190
cmFuc19mcmVlX2V4dGVudCgpDQppZiBpdOKAmXMgbm90IHRoZXJlLCBhbmQgY29udGludWUgdG8g
ZnJlZSB0aGUgZXh0ZW50LiBPdGhlcndpc2UgaWYgdGhlIEFHIG51bWJlciBpcyBhbHJlYWR5DQp0
aGVyZSBpbiBwZW5kaW5nX2J1c3lfQUdzLCB3ZSByZXR1cm4gLUVBR0FJTi4gVGhlIEFHIG51bWJl
ciBpcyByZW1vdmVkIHdoZW4NCnRoZSBidXN5IGV4dGVudHMgYXJlIGNvbW1pdHRlZCB0byB0aGUg
eGZzX2NpbF9jdHguDQpXZWxsLCB3b25kZXJpbmcgaWYgdGhlIHBlbmRpbmcgYnVzeSBleHRlbnRz
IHdvdWxkIHJlbWFpbiBpbiBwZW5kaW5nIHN0YXRlIGxvbmcgYmVmb3JlDQpjb21taXR0ZWQgdG8g
Q0lMIGFuZCB0aGF0IGJlY29tZSBhIGJvdHRsZSBuZWNrIGZvciBmcmVlaW5nIGV4dGVudHMuICAN
Cg0KdGhhbmtzLA0Kd2VuZ2FuZw0KDQo+IA0KPj4gVGhlIGRpZmZlcmVuY2UgaXMgdGhhdCBsaW1p
dGluZyB0aGUgbnVtYmVyIG9mIHhlZmkgaXRlbXMgcGVyDQo+PiBkZWZlcnJlZCB3b3JrIGl0ZW0g
bWVhbnMgd2UgY2FuIG9ubHkgcHJvY2VzcyBhIHNpbmdsZSBleHRlbnQgcGVyDQo+PiB3b3JrIGl0
ZW0gcmVnYXJkbGVzcyBvZiB0aGUgY3VycmVudCBjb250ZXh0Lg0KPj4gDQo+PiBVc2luZyB0aGUg
ZXhpc3RpbmcgZGVmZXJlZCB3b3JrICJvbiBkZW1hbmQgdHJhbnNhY3Rpb24gcm9sbGluZyINCj4+
IG1lY2hhbmlzbSBJJ20gc3VnZ2VzdGluZyB3ZSB1c2UgZG9lc24ndCBwdXQgYW55IGFydGlmaWNp
YWwNCj4+IGNvbnN0cmFpbnMgb24gaG93IHdlIGxvZyBhbmQgcHJvY2VzcyB0aGUgaW50ZW50cy4g
VGhpcyBhbGxvd3MgdXMgdG8NCj4+IGFnZ3JlZ2F0ZSBtdWx0aXBsZSBleHRlbnQgZnJlZXMgaW50
byBhIHNpbmdsZSB0cmFuc2FjdGlvbiB3aGVuIHRoZXJlDQo+PiBpcyBubyByaXNrIGFzc29jaWF0
ZWQgd2l0aCBkb2luZyBzbyBhbmQgd2UgaGF2ZSBzdWZmaWNpZW50DQo+PiB0cmFuc2FjdGlvbiBy
ZXNlcnZhdGlvbnMgcmVtYWluaW5nIHRvIGd1YXJhbnRlZSB3ZSBjYW4gZnJlZSB0aGUNCj4+IGV4
dGVudC4gSXQncyBmYXIgbW9yZSBlZmZpY2llbnQsIGFuZCB0aGUgaW5mcmFzdHJ1Y3R1cmUgd2Ug
aGF2ZSBpbg0KPj4gcGxhY2UgYWxyZWFkeSBzdXBwb3J0cyB0aGlzIHNvcnQgb2YgZnVuY3Rpb25h
bGl0eS4uLi4NCj4+IA0KPj4gV2hlbiB3ZSBnbyBiYWNrIHRvIHRoZSBvcmlnaW5hbCBwcm9ibGVt
IG9mIHRoZSBBR0ZMIGFsbG9jYXRpb24NCj4+IG5lZWRpbmcgdG8gcm9sbCB0aGUgdHJhbnNhY3Rp
b24gdG8gZ2V0IGJ1c3kgZXh0ZW50cyBwcm9jZXNzZWQsIHRoZW4NCj4+IHdlIGNvdWxkIGhhdmUg
aXQgcmV0dXJuIC1FQUdBSU4gYWxsIHRoZSB3YXkgYmFjayB1cCB0byB0aGUgZGVmZXItb3BzDQo+
PiBsZXZlbCBhbmQgd2Ugc2ltcGx5IHRoZW4gcm9sbCB0aGUgdHJhbnNhY3Rpb24gYW5kIHJldHJ5
IHRoZSBzYW1lDQo+PiBleHRlbnQgZnJlZSBvcGVyYXRpb24gYWdhaW4uIGkuZS4gd2hlcmUgZXh0
ZW50IGZyZWVpbmcgbmVlZHMgdG8NCj4+IGJsb2NrIHdhaXRpbmcgb24gc3R1ZmYgbGlrZSBidXN5
IGV4dGVudHMsIHdlIGNvdWxkIG5vdyBoYXZlIHRoZXNlDQo+PiBjb21taXQgdGhlIGN1cnJlbnQg
dHJhbnNhY3Rpb24sIHB1c2ggdGhlIGN1cnJlbnQgd29yayBpdGVtIHRvIHRoZQ0KPj4gYmFjayBv
ZiB0aGUgY3VycmVudCBjb250ZXh0J3MgcXVldWUgYW5kIGNvbWUgYmFjayB0byBpdCBsYXRlci4N
Cj4+IA0KPj4gQXQgdGhpcyBwb2ludCwgSSB0aGluayB0aGUgInNpbmdsZSBleHRlbnQgcGVyIHRy
YW5zYWN0aW9uIg0KPj4gY29uc3RyYWludCB0aGF0IGlzIG5lZWRlZCB0byBhdm9pZCB0aGUgYnVz
eSBleHRlbnQgZGVhZGxvY2sgZ29lcw0KPj4gYXdheSwgYW5kIHdpdGggaXQgdGhlIG5lZWQgZm9y
IGxpbWl0aW5nIEVGSSBwcm9jZXNzaW5nIHRvIGEgc2luZ2xlDQo+PiBleHRlbnQgZ29lcyBhd2F5
IHRvby4uLi4NCj4gDQo+IEkgYW0gcHJldHR5IGNsZWFyIG5vdy4NCj4+IA0KPj4+IEFuZCB5b3Vy
IGltcGxlbWVudGF0aW9uIG1heSB1c2UgbW9yZSBsb2cgc3BhY2UgdGhhbiBtaW5lIGluIGNhc2Ug
dGhlIEVGSQ0KPj4+IChhbmQgRUZEIHBhaXIpIGNhbuKAmXQgYmUgY2FuY2VsbGVkLiAgOkQNCj4+
IA0KPj4gVHJ1ZSwgYnV0IGl0J3MgcmVhbGx5IG5vdCBhIGNvbmNlcm4uICBEb24ndCBjb25mbGF0
ZSAiaW50ZW50DQo+PiByZWNvdmVyeSBpbnRlbnQgYW1wbGlmaWNhdGlvbiBjYW4gY2F1c2UgbG9n
IHNwYWNlIGRlYWRsb2NrcyIgd2l0aA0KPj4gImludGVudCBzaXplIGlzIGEgcHJvYmxlbSIuIDop
DQo+PiANCj4gDQo+IEdvdCBpdC4NCj4+PiBUaGUgb25seSBkaWZmZXJlbmNlIGlmIHRoYXQgeW91
IHVzZSB0cmFuc2FjdGlvbiBjb21taXQgYW5kIEkgYW0gdXNpbmcgdHJhbnNhY3Rpb24gcm9sbA0K
Pj4+IHdoaWNoIGlzIG5vdCBzYWZlIGFzIHlvdSBzYWlkLiANCj4+PiANCj4+PiBJcyBteSB1bmRl
cnN0YW5kaW5nIGNvcnJlY3Q/DQo+PiANCj4+IEkgdGhpbmsgSSB1bmRlcnN0YW5kIHdoZXJlIHdl
IGFyZSBtaXN1bmRlcnN0YW5kaW5nIGVhY2ggb3RoZXIgOikNCj4+IFBlcmhhcHMgaXQgaXMgbm93
IG9idmlvdXMgdG8geW91IGFzIHdlbGwgZnJvbSB0aGUgYW5hbHlzaXMgYWJvdmUuDQo+PiBJZiBz
bywgaWdub3JlIHRoZSByZXN0IG9mIHRoaXMgOikNCj4+IA0KPj4gV2hhdCBkb2VzICJ0cmFuc2Fj
dGlvbiByb2xsIiBhY3R1YWxseSBtZWFuPw0KPj4gDQo+PiBYRlMgaGFzIGEgY29uY2VwdCBvZiAi
cm9sbGluZyB0cmFuc2FjdGlvbnMiLiBUaGVzZSBhcmUgbWFkZSB1cCBvZiBhDQo+PiBzZXJpZXMg
b2YgaW5kaXZpZHVhbCB0cmFuc2FjdGlvbiBjb250ZXh0cyB0aGF0IGFyZSBsaW5rZWQgdG9nZXRo
ZXINCj4+IGJ5IHBhc3NpbmcgYSBzaW5nbGUgbG9nIHJlc2VydmF0aW9uIHRpY2tldCBiZXR3ZWVu
IHRyYW5zYWN0aW9uDQo+PiBjb250ZXh0cy4NCj4+IA0KPj4geGZzX3RyYW5zX3JvbGwoKSBlZmZl
Y3RpdmVseSBkb2VzOg0KPj4gDQo+PiBudHAgPSB4ZnNfdHJhbnNfZHVwKHRwKQ0KPj4gLi4uLg0K
Pj4geGZzX3RyYW5zX2NvbW1pdCh0cCkNCj4+IA0KPj4gcmV0dXJuIG50cDsNCj4+IA0KPj4gaS5l
LiBpdCBkdXBsaWNhdGVzIHRoZSBjdXJyZW50IHRyYW5zYWN0aW9uIGhhbmRsZSwgdGFrZXMgdGhl
IHVudXNlZA0KPj4gYmxvY2sgcmVzZXJ2YXRpb24gZnJvbSBpdCwgZ3JhYnMgdGhlIGxvZyByZXNl
cnZhdGlvbiB0aWNrZXQgZnJvbSBpdCwNCj4+IG1vdmVzIHRoZSBkZWZlcmVkIG9wcyBmcm9tIHRo
ZSBvbGQgdG8gdGhlIG5ldyB0cmFuc2FjdGlvbiBjb250ZXh0LA0KPj4gdGhlbiBjb21taXRzIHRo
ZSBvbGQgdHJhbnNhY3Rpb24gY29udGV4dCBhbmQgcmV0dXJucyB0aGUgbmV3IG9uZS4NCj4+IA0K
Pj4gdGw7ZHI6IGEgcm9sbGluZyB0cmFuc2FjdGlvbiBpcyBhIHNlcmllcyBvZiBsaW5rZWQgaW5k
ZXBlbmRlbnQNCj4+IHRyYW5zYWN0aW9ucyB0aGF0IHNoYXJlIGEgY29tbW9uIHNldCBvZiBibG9j
ayBhbmQgbG9nIHJlc2VydmF0aW9ucy4NCj4+IA0KPj4gVG8gbWFrZSBhIHJvbGxpbmcgdHJhbnNh
Y3Rpb24gY2hhaW4gYW4gYXRvbWljIG9wZXJhdGlvbiBvbiBhDQo+PiBzcGVjaWZpYyBvYmplY3Qg
KGUuZy4gYW4gaW5vZGUpIHRoYXQgb2JqZWN0IGhhcyB0byByZW1haW4gbG9ja2VkIGFuZA0KPj4g
YmUgbG9nZ2VkIGluIGV2ZXJ5IHRyYW5zYWN0aW9uIGluIHRoZSBjaGFpbiBvZiByb2xsaW5nIHRy
YW5zYWN0aW9ucy4NCj4+IFRoaXMga2VlcHMgaXQgbW92aW5nIGZvcndhcmQgaW4gdGhlIGxvZyBh
bmQgcHJldmVudHMgaXQgZnJvbSBwaW5uaW5nDQo+PiB0aGUgdGFpbCBvZiB0aGUgbG9nIGFuZCBj
YXVzaW5nIGxvZyBzcGFjZSBkZWFkbG9ja3MuDQo+PiANCj4+IEZ1bmRhbWVudGFsbHksIHRob3Vn
aCwgZWFjaCBpbmRpdmlkdWFsIHRyYW5zYWN0aW9uIGluIGEgcm9sbGluZw0KPj4gdHJhbnNhY3Rp
b24gaXMgYW4gaW5kZXBlbmRlbnQgYXRvbWljIGNoYW5nZSBzZXQuIFNvIHdoZW4geW91IHNheQ0K
Pj4gInJvbGwgdGhlIHRyYW5zYWN0aW9uIiwgd2hhdCB5b3UgYXJlIGFjdHVhbGx5IHNheWluZyBp
cyAiY29tbWl0IHRoZQ0KPj4gY3VycmVudCB0cmFuc2FjdGlvbiBhbmQgc3RhcnQgYSBuZXcgdHJh
bnNhY3Rpb24gdXNpbmcgdGhlDQo+PiByZXNlcnZhdGlvbnMgdGhlIGN1cnJlbnQgdHJhbnNhY3Rp
b24gYWxyZWFkeSBob2xkcy4iDQo+PiANCj4+IFdoZW4gSSBzYXkgInRyYW5zYWN0aW9uIGNvbW1p
dCIgSSBhbSBvbmx5IHJlZmVyaW5nIHRvIHRoZSBwcm9jZXNzDQo+PiB0aGF0IGNsb3NlcyBvZmYg
dGhlIGN1cnJlbnQgdHJhbnNhY3Rpb24uIElmIHRoaXMgaXMgaW4gdGhlIG1pZGRsZSBvZg0KPj4g
YSByb2xsaW5nIHRyYW5zYWN0aW9uLCB0aGVuIHdoYXQgSSBhbSB0YWxraW5nIGFib3V0IGlzDQo+
PiB4ZnNfdHJhbnNfcm9sbCgpIGNhbGxpbmcgeGZzX3RyYW5zX2NvbW1pdCgpIGFmdGVyIGl0IGhh
cyBkdXBsaWNhdGVkDQo+PiB0aGUgY3VycmVudCB0cmFuc2FjdGlvbiBjb250ZXh0Lg0KPj4gDQo+
PiBUcmFuc2FjdGlvbiBjb250ZXh0cyBydW5uaW5nIGRlZmVyZWQgb3BlcmF0aW9ucywgaW50ZW50
IGNoYWlucywgZXRjDQo+PiBhcmUgKmFsd2F5cyogcm9sbGluZyB0cmFuc2FjdGlvbnMsIGFuZCBl
YWNoIHRpbWUgd2Ugcm9sbCB0aGUNCj4+IHRyYW5zYWN0aW9uIHdlIGNvbW1pdCBpdC4NCj4+IA0K
Pj4gSU9XUywgd2hlbiBJIHNheSAidHJhbnNhY3Rpb24gY29tbWl0IiBhbmQgeW91IHNheSAidHJh
bnNhY3Rpb24gcm9sbCINCj4+IHdlIGFyZSB0YWxraW5nIGFib3V0IGV4YWN0bHkgdGhlIHNhbWUg
dGhpbmcgLSB0cmFuc2FjdGlvbiBjb21taXQgaXMNCj4+IHRoZSBvcGVyYXRpb24gdGhhdCByb2xs
IHBlcmZvcm1zIHRvIGZpbmlzaCBvZmYgdGhlIGN1cnJlbnQgY2hhbmdlDQo+PiBzZXQuLi4NCj4+
IA0KPj4gSWRlYWxseSwgbm9ib2R5IHNob3VsZCBiZSBjYWxsaW5nIHhmc190cmFuc19yb2xsKCkg
ZGlyZWN0bHkgYW55bW9yZS4NCj4+IEFsbCByb2xsaW5nIHRyYW5zYWN0aW9ucyBzaG91bGQgYmUg
aW1wbGVtZW50ZWQgdXNpbmcgZGVmZXJyZWQgb3BzDQo+PiBub3dkYXlzIC0geGZzX3RyYW5zX3Jv
bGwoKSBpcyB0aGUgaGlzdG9yaWMgbWV0aG9kIG9mIHJ1bm5pbmcgcm9sbGluZw0KPj4gdHJhbnNh
Y3Rpb25zLiBlLmcuIHNlZSB0aGUgcmVjZW50IHJld29yayBvZiB0aGUgYXR0cmlidXRlIGNvZGUg
dG8NCj4+IHVzZSBkZWZlcnJlZCBvcHMgcmF0aGVyIHRoYW4gZXhwbGljaXQgY2FsbHMgdG8geGZz
X3RyYW5zX3JvbGwoKSBzbw0KPj4gd2UgY2FuIHVzZSBpbnRlbnRzIGZvciBydW5uaW5nIGF0dHIg
b3BlcmF0aW9ucy4NCj4+IA0KPj4gVGhlc2UgZGF5cyB0aGUgdHJhbnNhY3Rpb24gbW9kZWwgaXMg
YmFzZWQgYXJvdW5kIGNoYWlucyBvZiBkZWZlcnJlZA0KPj4gb3BlcmF0aW9ucy4gV2UgYXR0YWNo
IGRlZmVycmVkIHdvcmsgdG8gdGhlIHRyYW5zYWN0aW9uLCBhbmQgdGhlbg0KPj4gd2hlbiB3ZSBj
YWxsIHhmc190cmFuc19jb21taXQoKSBpdCBnb2VzIG9mZiBpbnRvIHRoZSBkZWZlcnJlZCB3b3Jr
DQo+PiBpbmZyYXN0cnVjdHVyZSB0aGF0IGNyZWF0ZXMgaW50ZW50cyBhbmQgbWFuYWdlcyB0aGUg
dHJhbnNhY3Rpb24NCj4+IGNvbnRleHQgZm9yIHByb2Nlc3NpbmcgdGhlIGludGVudHMgaXRzZWxm
Lg0KPj4gDQo+PiBUaGlzIGlzIHRoZSBwcmltYXJ5IHJlYXNvbiB3ZSBhcmUgdHJ5aW5nIHRvIG1v
dmUgYXdheSBmcm9tIGhpZ2gNCj4+IGxldmVsIGNvZGUgdXNpbmcgdHJhbnNhY3Rpb24gcm9sbGlu
ZyAtIHdlIGNhbid0IGVhc2lseSBjaGFuZ2UgdGhlDQo+PiB3YXkgd2UgcHJvY2VzcyBvcGVyYXRp
b25zIHdoZW4gdGhlIGhpZ2ggbGV2ZWwgY29kZSBjb250cm9scw0KPj4gdHJhbnNhY3Rpb24gY29u
dGV4dHMuIFVzaW5nIGRlZmVycmVkIGludGVudCBjaGFpbnMgZ2l2ZXMgdXMgZmluZQ0KPj4gZ3Jh
aW5lZCBjb250cm9sIG92ZXIgdHJhbnNhY3Rpb24gY29udGV4dCBpbiB0aGUgZGVmZXJyZWQgb3Bz
DQo+PiBwcm9jZXNzaW5nIGNvZGUgLSB3ZSBjYW4gcm9sbCB0byBhIG5ldyB0cmFuc2FjdGlvbiB3
aGVuZXZlciB3ZSBuZWVkDQo+PiB0by4uLi4NCj4+IA0KPiANCj4gQWJvdmUgaXMgcmVhbGx5IGhl
bHBmdWwuDQo+IEkgd2hlbiBJIG1lbnRpb24gdHJhbnNhY3Rpb24gcm9sbCwgSSBtZWFudA0KPiAx
KSBhIG5ldyB0cmFuc2FjdGlvbiBpcyBjcmVhdGVkLCBidXQgaXRzIHNlbGYgZG9lc+KAmXQgcmVz
ZXJ2ZSBhbnkgcmVzb3VyY2UuDQo+IEluc3RlYWQsIGl0IGluaGVyaXRzIGFsbCB0aGUgdW51c2Vk
IHJlc291cmNlcyBmcm9tIHRoZSBvbGQgdHJhbnNhY3Rpb24uDQo+IDIpIGNvbW1pdCB0aGUgb2xk
IHRyYW5zYWN0aW9uLg0KPiAzKSBkb27igJl0IHVuLXJlc2VydmUgdW51c2VkIHJlc291cmNlcyBm
cm9tIG9sZCB0cmFuc2FjdGlvbiwgdGhlIG5ldyB0cmFuc2FjdGlvbg0KPiB3aWxsIGluaGVyaXRz
IHRoZW0uDQo+IDQpIHVzZSB0aGUgbmV3IHRyYW5zYWN0aW9uIGZvciBmdXJ0aGVyIGxvZyBpdGVt
cy4NCj4gDQo+IEFzIEkgdW5kZXJzdGFuZCwgdGhlIGtleSBpcyB0aGF0IHRoZSBuZXcgdHJhbnNh
Y3Rpb24gaXRzIHNlbGYgZG9lc27igJl0IHJlc2VydmUgbmV3IHJlc291cmNlcy4NCj4gDQo+IEFu
ZCB3aGVuIEkgcmVhZCB5b3VyIOKAnHRyYW5zYWN0aW9uIGNvbW1pdOKAnSBJIHVuZGVyc3Rvb2Qg
aXQgYXMgdGhpczoNCj4gMSkuIGNvbW1pdCBvbGQgdHJhbnNhY3Rpb24NCj4gMikgdW4tcmVzZXJ2
ZSB1bnVzZWQgcmVzb3VyY2VzIGZyb20gb2xkIHRyYW5zYWN0aW9uDQo+IDMpIGNyZWF0ZSBuZXcg
dHJhbnNhY3Rpb24gd2l0aCBhbGwgcmVzb3VyY2VzIHJlc2VydmVkLg0KPiANCj4gVGh1cyBpbiBt
eSB1bmRlcnN0YW5kIHlvdXIg4oCcdHJhbnNhY3Rpb24gY29tbWl04oCdIHdvdWxkIGhhdmUgbm8g
cmlzayBvZiBsYWNrIG9mIGxvZyBzcGFjZSB0byBwdXQNCj4gdGhlIGV4dHJhIEVGSS9FRkRzLiAg
QnV0IHJlYWRpbmcgYWJvdmUsIEnigJlkIHRoaW5rIHlvdSBtZWFudCDigJx0cmFuc2FjdGlvbiBy
b2xs4oCdIGFjdHVhbGx5Lg0KPiANCj4+PiBPbmUgcXVlc3Rpb24gaXMgdGhhdCBpZiBvbmx5IG9u
ZSBFRkkgaXMgc2FmZSBwZXIgdHJhbnNhY3Rpb24sIGhvdw0KPj4+IHdlIGVuc3VyZSB0aGF0IHRo
ZXJlIGlzIG9ubHkgb25lIEVGSSBwZXIgdHJhbnNhY3Rpb24gaW4gY2FzZSB0aGVyZQ0KPj4+IGFy
ZSBtb3JlIHRoYW4gMTYgKGN1cnJlbnQgWEZTX0VGSV9NQVhfRkFTVF9FWFRFTlRTKSBleHRlbnRz
IHRvDQo+Pj4gZnJlZSBpbiBjdXJyZW50IGNvZGU/DQo+PiANCj4+IFRoYXQgd2lsbCBoYW5kbGVk
IGV4YWN0bHkgdGhlIHNhbWUgd2F5IGl0IGRvZXMgd2l0aCB5b3VyIGNoYW5nZSAtIGl0DQo+PiB3
aWxsIHNpbXBseSBzcGxpdCB1cCB0aGUgd29yayBpdGVtcyBzbyB0aGVyZSBhcmUgbXVsdGlwbGUg
aW50ZW50cw0KPj4gbG9nZ2VkLg0KPiANCj4gSeKAmWQgbGlrZSB0byBtYWtlIGl0IG1vcmUgY2xl
YXIuIFlvdSB3ZXJlIHNheWluZyB0aGF0IGR1cmluZyBsb2cgcmVjb3ZlciBzdGFnZSwgdGhlcmUg
bWF5IGJlIG5vIGVub3VnaA0KPiBsb2cgc3BhY2UgZm9yIHRoZSBleHRyYSBFRkkvRUZEIChzcGxp
dHRlZCBmcm9tIG9yaWdpbmFsIG11bHRpcGxlIGV4dGVudHMgRUZJKS4gQnV0IGhlcmUgKG5vbi1y
ZWNvdmVyeSBzdGFnZSksDQo+IHNlZW1zIHlvdSBoYXZlIG5vIGNvbmNlcm4gbG9nZ2luZyBtb3Jl
IEVGSS9FRkRzLiAgU28gd2h5IHRoZXkgYXJlIGRpZmZlcmVudD8NCj4gDQo+IHRoYW5rcywNCj4g
d2VuZ2FuZw0KDQoNCg==
