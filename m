Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002C3676B58
	for <lists+linux-xfs@lfdr.de>; Sun, 22 Jan 2023 07:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjAVGsW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 22 Jan 2023 01:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVGsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Jan 2023 01:48:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89FF1F90E
        for <linux-xfs@vger.kernel.org>; Sat, 21 Jan 2023 22:48:18 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30M5JRBK026299;
        Sun, 22 Jan 2023 06:48:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=xLPYtrXtZY+HaFPLwcUgVz17kw0j9+tLzIOwgiCUfq8=;
 b=PetNzirlULFf/mCWM7OReQFXArLjvpJ5lc4AAIal6Kr2urIFJoV75ja50Txr578zglTe
 RmfpYobaCZemyFz8fczYW7ox+O1Jk9LOssvmMr+N2Oy3ta1VKoGe2IAY9yu8QOFDK0gS
 Hm3+eWFjAvXeBMoZPCzdInseeyJk8Ldfedmil7lbUKLfCnMLAfBVSdExlG8Zo7Tgz2fO
 P1hbQpTGsBrDr3EEsi4z+3grd9vrNSr/qd0CgN8Cz5zaaWcsnd0yV2zy86JTOUq+OgBf
 VxZQvHOC28tDQsBWMfP2QbSahC8r1Y3Ylc23rIi61pHYyRIs6LV++lWtTONMDEXmVrMD Lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fc93uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Jan 2023 06:48:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30M3qqaf020773;
        Sun, 22 Jan 2023 06:48:16 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g2c9n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Jan 2023 06:48:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCMRErqCYapILtoTxmZY2IMhEdenXT7g1EAxc4rJ+VI+hvCB6G8c1dTFCsMck3ElYrqV+oYgr0fvvmCOUeaRff5IRY0eVvCmDRGLJIQImEXeb1CMBPqOpGgiNcWFROUDl2MMTXCF8tkzUWzYDDy+MtnguIMhj7YxMsJnn/8DhDXtxc4u2/oxJeZP9xtg+UkcazCm41JsRhs1Yallvoh/PKdXkb2V0+HReuXJ779XaR56aqKR/RH/ZnFmw+b/gO1xcYhKMxk4rE64A3do/Zvpfl0n/GvHDGY2Lb2UrkdXufkXekvU/VYIK5Mzo49I/lKt7PSFrTdmM7o0t9lMcnwuRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLPYtrXtZY+HaFPLwcUgVz17kw0j9+tLzIOwgiCUfq8=;
 b=PEA4Nq4IcNeTm02l6/fiEr5dfiL8QGMd6jlnKkE4jGugLuW6bv4AC6R0L5CmIsOhGmERlcITrQ9FqtuuHAwsNC8OatEHmTd+PAGwq8CUJM6DOzN98F8vvl3rh/nFQFkYmZrOGjpf+wNGIpE1sEoJQMqZwj8E8sy6ASSQeThBWlZPMAUsxl7r5p2SxOPWi9xuV/V6j2Hf41x1KfVHGOKu/RaU6Qty5DTeT8dmjwK6ObfqhUoshFsRBKXyiv28NW3y6UZgmYAXneEsXMFAL+m5v4vlbwVsEk4+m52wYcXf59d7md4bqb103yqsuk5y1mEOYa5pmadgj2QLHhjV8O81XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLPYtrXtZY+HaFPLwcUgVz17kw0j9+tLzIOwgiCUfq8=;
 b=de+fOuOVrJHmVez5uasS7VoAkV8H4u1+rhKPphLElAkUgcgx/CFlpoTihqCA0g8uST2UqzaSdctqfFLFMhjoWViceIgZ0yN/XYseYvTlacrdR8BuqAd8ZgJMgn7IDRBJOoQFsPy5pL7KeR04gIa/8398Qa25vS6U1KyPCrelK3k=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5063.namprd10.prod.outlook.com (2603:10b6:408:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.13; Sun, 22 Jan
 2023 06:48:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%5]) with mapi id 15.20.6043.012; Sun, 22 Jan 2023
 06:48:12 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/42] xfs: use active perag references for inode
 allocation
Thread-Topic: [PATCH 10/42] xfs: use active perag references for inode
 allocation
Thread-Index: AQHZK46PV2V7PRNd9EKOxPhaaopK4q6qA9yA
Date:   Sun, 22 Jan 2023 06:48:12 +0000
Message-ID: <d85feac54c13c974af163009c2fd1297a2446419.camel@oracle.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
         <20230118224505.1964941-11-david@fromorbit.com>
In-Reply-To: <20230118224505.1964941-11-david@fromorbit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|BN0PR10MB5063:EE_
x-ms-office365-filtering-correlation-id: 87860ad8-6090-44ea-5edd-08dafc44a1a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PjGSiMbBHLXbB5uNkBtc7PlzQJ+hvrAxWXgIp26nfIT7AiU3UXDhxRxlAYQsZrygPwjyjH2S0QByUTnEfg6jN7XvEaHzBnsIkvbiXwW2QJwfJ5TCB9V4Z766z/VDQXzvQ9jtZoys8vwCV02eCULZFK9cVpLpmwWRdu2akzHgQhKNJroBhZ1B5omZwsUbdZ9TUXAPAvHbNvj2j9wN6uE24Tm+CZAeAB3mkto+BygQtGrWm4nmPdILshQjUA74941WHbYyPX2FEj7+lc4GlG1mahVQ/MiWPFbDVWHuSy4ptt10eMkcNzMSvnwSAVvZ3a1gNuBzqgQ4xLNfw3/SPEVD4fQ7MkdEthUrx6iMYzB19LGLaSYN1rtLf8zF07mcBS+wbLGqPQ4NLXA4xe7Bvbv6ACy9saKQEJe5gtKnuAhb3WZDY9n/8exY9p+3TCpNwEskIpmk8+NoN/d3aUCxE0ExWT+fctd4VbVkod+6hZvPFu4xsWY3PGNlijzC6Ei7+oSlJY7e/AFwEeYBUB55mw/Quk1s6ygmDN83cfopNw2zYbrCVXyR81rLPdwWw1GZBZMPaMYFG3rBvll3BhyR6R9EqeKrI8tQB6e7GZlHopEeY7Vu6Plh5T05Layzgf+nlWyhqKNdBWrK69Sm5ooAqMCARZRJ/IoZPBhKnb7xx902BQTrhJUEkvGRELC6BDrjuNtjZweCPAzY1uswsigPZacyjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(36756003)(6486002)(122000001)(478600001)(38100700002)(6506007)(71200400001)(26005)(186003)(6512007)(316002)(2616005)(64756008)(38070700005)(8676002)(66446008)(66476007)(76116006)(66946007)(66556008)(41300700001)(83380400001)(2906002)(44832011)(5660300002)(86362001)(110136005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmlMMUEzR2d0My83VjBKUmJWUDF3UkZkVGtPcDJCVXFIMHN3cHVQZ0tTN3B4?=
 =?utf-8?B?SFhPbmQrbWx1YU5TZEpZQjVNWFI4b1VTWEd4MG82OWdpZ0JWaWtkcXBNRVFV?=
 =?utf-8?B?eXBJR1RjRm94VWpoSXFOa2dhNWZNc1lkUmRKd3EwQmcrdDhEdG8wTlhDSWFr?=
 =?utf-8?B?Ymo2UW9nUW9WRlF2YUM5WUx6STlJZngxaGxzeDNrdlpqR1VtYzZ1RVUyemlI?=
 =?utf-8?B?MmFrb3ZLeFZZQXNmR3VXWU9aZ0lhNlkwdkpsR1cvcXluVU5QUUdDZjRMRkhP?=
 =?utf-8?B?bDBGeW5XSjVuTFNDTVcyczUzNnlZSFQ1TTIvZVI0VE1JSldIZGl1bmx5c0to?=
 =?utf-8?B?cm1IWGdKT29kT2I3NGFDc3B6K3lpUDhzODZhTFZkcCtkWWFKSGdMai81RVJQ?=
 =?utf-8?B?NDFJL2VCOGpOblhXOEFuM0Z1UHQvN3E4MHFpaFVTbUEvdEVQSVBNY1FDL3Vk?=
 =?utf-8?B?NnBpeXZNRWRYSlJFYzFqN1loTkY2Y3dTSDlSVU5BYm9uTHNFd24wOXViMVl2?=
 =?utf-8?B?YXJhbzQxOUJlTUFMS2h4MDBrczZXWDNMdU43TkZFZG9QOE1iVmZDRjVpdFln?=
 =?utf-8?B?RWQvZlJIN0VzZ1A3SkNzS0NLVWVxZzJ0UnhLaGJFUFNacm1SSkordC9hMGds?=
 =?utf-8?B?OFZGVVpHamFoNUdUdkFlVytBWW0xRGdhaU5NMTlHRm5ZZmszOVlXc014SnZD?=
 =?utf-8?B?ZDhrV1dmY21YeFBqZlVMVXhTbE4wdjl3ZXQzSWVzb01TblA1L1p4eG5kbmRx?=
 =?utf-8?B?L2p3SURtb1R3UjdlNkc0Z2w4Q1AxZG9DV0puN01VNTA4MUlURm51MFJhT2s4?=
 =?utf-8?B?ZmZDMzlhVC9sWlZERVVGVW9rWU5SRklSN3AvcTRWYlhIeHhBOFQvbVFMeVJh?=
 =?utf-8?B?blJzY3Q1RUNsUlhiblYva2FlL2VYSTZlcXkza1VwYStVVHd5NnVoSGVwbktl?=
 =?utf-8?B?ZWJySS82b0UrTE1zL29sWjRGM3BOYWRrRTRoN29sdjZ6T3JVdDlRRWZ0czg5?=
 =?utf-8?B?RFV1cFA3TFdRb0pLbFU0b2dLUWh5TnZKT1JFM2NObDVzSUdSbEc2WFJZZHRx?=
 =?utf-8?B?cTl0MVZYcGFFZG9QQWNiZnNrT28rR0xaR3U5SUl4WFNGNVk5bitZcXVKTlZC?=
 =?utf-8?B?TG9qUkNqVmEvankreFlmOVdFUmJZWGVxV2ZJV0g3Q3dRREw5VHpraTh3V2wx?=
 =?utf-8?B?OTloQ1Z2TkNNM2xpRnU4dFlpY1RtcFg4L0ozL3hQNm8zWVNMWHJ3Y0Ewbmd1?=
 =?utf-8?B?RmxQYU9kbHVTMmMzQTgzQXBEUnhqOThKcEVRYXlhNWNFd1FZNlZlZHh0dmI1?=
 =?utf-8?B?UGRheVBkZUN3VTIxUzVLS28wRE1GbHFhVjlpanhlUmtBZjgrUkQ0SVRMWjFu?=
 =?utf-8?B?ZGN0MjB5U0RZWGRVSyt3TDdQMUpIaDhaWHl0YU0zUEFsbFRDMDlXSzYwb2RU?=
 =?utf-8?B?YVllYnJYMEdxYnVpclFWd0ZjcjQ3WkZ4Z09lditSR2tDZTFweEszeGRFVU1L?=
 =?utf-8?B?d0VvYk1UK3djbTJKeE9DWFRub3lGVkZjSmkxOHNseGF0RWxhUGwrNDBwYml4?=
 =?utf-8?B?eXJ6STJlTVNNTnFKcS9jUXFjd1JTeTNPSmZmZTRTSWpEZ0cyc0JmNzhwNUk3?=
 =?utf-8?B?RXI4QWxqQmFKVkZNbVFoZUJHd0hGZG0rb2s3bFp5bVJrcjNCYVZCdW1TNlBw?=
 =?utf-8?B?WDY4WUlEdkJyeHBZYkVXVXN1dTZkYmlqS2ZqeHpkSEs0NXZKYUIrOElSamNm?=
 =?utf-8?B?T05hdXozOEJrcGVlSTlWdjdjY251TGVxUWJpanZnNUxDWVdIVlgvY2k3TEtk?=
 =?utf-8?B?QW50eWhPSWZXeXVWVE51WGYwdC9uTXhpWXBwcTlsMm04SEt4VERNQWxpdXg0?=
 =?utf-8?B?M29tSEFTU1V3K05ESTJjc1JybkRBeHNSeCt3VkpEUXFlTnF4MTNuY1Zib3Qy?=
 =?utf-8?B?aWlBa3daNS94TmRZTnlRcGpnU1ZDUExCNGE0aU5hc2tleWFkUTJaRXVMUlB6?=
 =?utf-8?B?RE1wLzF4SGlvRzBnbHMzcjNUK3FTc0czOVFtV0JIUzJvMkRMVVZsek01SXNQ?=
 =?utf-8?B?ZkkyN3oxWWlhMlJJQVNJYml1RTYxK3V0SWhXWDRacDJXWmNKanFEOUQwRzVs?=
 =?utf-8?B?YTdNeDg4M3dNNW80Um84V1VuVzFJRU43QVBzN1g3TmovUjFRZnN6UU5wbHE5?=
 =?utf-8?Q?+IHYcXtcP8aFwQ4CeJFIwMs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4737F6DA3973384BB7D1D310844448CE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1WGmqJ1VLyNt3qxzFo3PjCUm+maJphZe21vY1Kq+Bnx/2qWUe8FhhK33bYW/2YVfzrDwG2I3FGPdab/3QhJgIfnnt6OSDjuD54XwNyWicHdO5NTFhOqPpeXW1auNajzOsb/vCFjkvJQQqZlmsYcPrwvWUSzL0ldP89vLi0i7HMDJTZxpbzkS/WX7FmII7KsL2zIWIRsSOo8xnybxtq0i9XGmnTPvjC4cih1z+IRQQ47/k242oR9VMP7BERQ5eHMRsw9Ye3bM3/h0ECoo53wBa3TYlGDhf+GhY1KMmPN9Y6SFJkGnw4yztlykGfZVgOC2OrkkT0g0/XnnpYh0RJUsoG2M3X4WwQsFWYyy+ZamDnjv188alvn7xEvsDc1bnoblG1CvsKvFPB/MGbVn+ppAiDwnhWPcgSixMnkUDRufkN+857C+V84gIYtuQhr2C1qBCkz1G9SEvoFJbIgSygUP4c59Bes1y+QjcvZ8a2DLGiNKeOeXRuForvcjpgJ/gARkV3h8GQLIAiDUn91Go5OEU+R0tSlyxUEnC/SG8Jttdxwsqadd8CGrlOz9Oi6GOhTeerYVQb7I0gVulqzwq93TZNFH1mF2LrxuEMApfJ1errSbVxl8/HwmsdjuwciLNpLH4TcmwRBZPUu++dAJgmj2RuHriL3NCFkhwAufhg5P25PMLG2TdA7TVJAO1gC24VwG5sxSjUhljgICNOqAhdkZXV1+SWKhRNKM0kfzrIv+oYDMECbmU7pP9QV1LbbHkwtJVUZiVxQxUv7tQBrLKxFMKr7sPnhkkxQdP+wG94ziaV8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87860ad8-6090-44ea-5edd-08dafc44a1a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2023 06:48:12.6110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: slFK/QmGIUrJJ0Qu2UWO91xdq7svQR1Rx631r1Sv7Q4aLVxEmOpMcWD0a0ryQ4B41CpRSDmOb+yTcjLUIfb8uU5BbE9N9t9nrLANk0g366A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5063
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-22_03,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301220064
X-Proofpoint-GUID: NOMp3JIxem2ugwbXn1K1JP3hV3fGAYGJ
X-Proofpoint-ORIG-GUID: NOMp3JIxem2ugwbXn1K1JP3hV3fGAYGJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDA5OjQ0ICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+IENvbnZlcnQgdGhl
IGlub2RlIGFsbG9jYXRpb24gcm91dGluZXMgdG8gdXNlIGFjdGl2ZSBwZXJhZyByZWZlcmVuY2Vz
Cj4gb3IgcmVmZXJlbmNlcyBoZWxkIGJ5IGNhbGxlcnMgcmF0aGVyIHRoYW4gZ3JhYiB0aGVpciBv
d24uIEFsc28gZHJpdmUKPiB0aGUgcGVyYWcgZnVydGhlciBpbndhcmRzIHRvIHJlcGxhY2UgeGZz
X21vdW50cyB3aGVuIGRvaW5nCj4gb3BlcmF0aW9ucyBvbiBhIHNwZWNpZmljIEFHLgo+IAo+IFNp
Z25lZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KT2ssIGxvb2tz
IG9rIHRvIG1lClJldmlld2VkLWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxsaXNvbi5oZW5kZXJz
b25Ab3JhY2xlLmNvbT4KCj4gLS0tCj4gwqBmcy94ZnMvbGlieGZzL3hmc19hZy5jwqDCoMKgwqAg
fMKgIDMgKy0KPiDCoGZzL3hmcy9saWJ4ZnMveGZzX2lhbGxvYy5jIHwgNjMgKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0tCj4gLS0KPiDCoGZzL3hmcy9saWJ4ZnMveGZzX2lhbGxv
Yy5oIHzCoCAyICstCj4gwqAzIGZpbGVzIGNoYW5nZWQsIDMzIGluc2VydGlvbnMoKyksIDM1IGRl
bGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19hZy5jIGIvZnMv
eGZzL2xpYnhmcy94ZnNfYWcuYwo+IGluZGV4IDdjZmY2MTg3NTM0MC4uYTNiZGNkZTk1ODQ1IDEw
MDY0NAo+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2FnLmMKPiArKysgYi9mcy94ZnMvbGlieGZz
L3hmc19hZy5jCj4gQEAgLTkyNSw4ICs5MjUsNyBAQCB4ZnNfYWdfc2hyaW5rX3NwYWNlKAo+IMKg
wqDCoMKgwqDCoMKgwqAgKiBNYWtlIHN1cmUgdGhhdCB0aGUgbGFzdCBpbm9kZSBjbHVzdGVyIGNh
bm5vdCBvdmVybGFwIHdpdGgKPiB0aGUgbmV3Cj4gwqDCoMKgwqDCoMKgwqDCoCAqIGVuZCBvZiB0
aGUgQUcsIGV2ZW4gaWYgaXQncyBzcGFyc2UuCj4gwqDCoMKgwqDCoMKgwqDCoCAqLwo+IC3CoMKg
wqDCoMKgwqDCoGVycm9yID0geGZzX2lhbGxvY19jaGVja19zaHJpbmsoKnRwcCwgcGFnLT5wYWdf
YWdubywgYWdpYnAsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBhZ2xlbiAtIGRlbHRhKTsKPiArwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19pYWxsb2Nf
Y2hlY2tfc2hyaW5rKHBhZywgKnRwcCwgYWdpYnAsIGFnbGVuIC0KPiBkZWx0YSk7Cj4gwqDCoMKg
wqDCoMKgwqDCoGlmIChlcnJvcikKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiBlcnJvcjsKPiDCoAo+IGRpZmYgLS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19pYWxsb2Mu
YyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2lhbGxvYy5jCj4gaW5kZXggMmI0OTYxZmYyZTI0Li5hMWE0
ODJlYzMwNjUgMTAwNjQ0Cj4gLS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfaWFsbG9jLmMKPiArKysg
Yi9mcy94ZnMvbGlieGZzL3hmc19pYWxsb2MuYwo+IEBAIC0xNjksMTQgKzE2OSwxNCBAQCB4ZnNf
aW5vYnRfaW5zZXJ0X3JlYygKPiDCoCAqLwo+IMKgU1RBVElDIGludAo+IMKgeGZzX2lub2J0X2lu
c2VydCgKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX21vdW50wqDCoMKgwqDCoMKgwqDCoCpt
cCwKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3BlcmFnwqDCoMKgwqDCoMKgwqDCoCpwYWcs
Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfdHJhbnPCoMKgwqDCoMKgwqDCoMKgKnRwLAo+
IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2J1ZsKgwqDCoMKgwqDCoMKgwqDCoMKgKmFnYnAs
Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19wZXJhZ8KgwqDCoMKgwqDCoMKgwqAqcGFnLAo+
IMKgwqDCoMKgwqDCoMKgwqB4ZnNfYWdpbm9fdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbmV3
aW5vLAo+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfYWdpbm9fdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgbmV3bGVuLAo+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfYnRudW1fdMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgYnRudW0pCj4gwqB7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19tb3VudMKg
wqDCoMKgwqDCoMKgwqAqbXAgPSBwYWctPnBhZ19tb3VudDsKPiDCoMKgwqDCoMKgwqDCoMKgc3Ry
dWN0IHhmc19idHJlZV9jdXLCoMKgwqDCoCpjdXI7Cj4gwqDCoMKgwqDCoMKgwqDCoHhmc19hZ2lu
b190wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0aGlzaW5vOwo+IMKgwqDCoMKgwqDCoMKgwqBp
bnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpOwo+IEBAIC01MTQs
MTQgKzUxNCwxNCBAQCBfX3hmc19pbm9idF9yZWNfbWVyZ2UoCj4gwqAgKi8KPiDCoFNUQVRJQyBp
bnQKPiDCoHhmc19pbm9idF9pbnNlcnRfc3ByZWMoCj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhm
c19tb3VudMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKm1wLAo+ICvCoMKgwqDCoMKg
wqDCoHN0cnVjdCB4ZnNfcGVyYWfCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpwYWcs
Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfdHJhbnPCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCp0cCwKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19idWbCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqYWdicCwKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qg
eGZzX3BlcmFnwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqcGFnLAo+IMKgwqDCoMKg
wqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgYnRudW0sCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vYnRfcmVj
X2luY29yZcKgwqDCoMKgwqAqbnJlYyzCoMKgLyogaW4vb3V0OiBuZXcvbWVyZ2VkCj4gcmVjLiAq
Lwo+IMKgwqDCoMKgwqDCoMKgwqBib29swqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtZXJnZSnCoMKgLyogbWVyZ2Ugb3IgcmVwbGFjZQo+ICov
Cj4gwqB7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgKm1wID0gcGFnLT5wYWdfbW91bnQ7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0
cnVjdCB4ZnNfYnRyZWVfY3VywqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKmN1cjsKPiDCoMKgwqDC
oMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGVycm9yOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaTsKPiBAQCAtNjA5LDkg
KzYwOSw5IEBAIHhmc19pbm9idF9pbnNlcnRfc3ByZWMoCj4gwqAgKi8KPiDCoFNUQVRJQyBpbnQK
PiDCoHhmc19pYWxsb2NfYWdfYWxsb2MoCj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19wZXJh
Z8KgwqDCoMKgwqDCoMKgwqAqcGFnLAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3RyYW5z
wqDCoMKgwqDCoMKgwqDCoCp0cCwKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2J1ZsKgwqDC
oMKgwqDCoMKgwqDCoMKgKmFnYnAsCj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19wZXJhZ8Kg
wqDCoMKgwqDCoMKgwqAqcGFnKQo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfYnVmwqDCoMKg
wqDCoMKgwqDCoMKgwqAqYWdicCkKPiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19h
Z2nCoMKgwqDCoMKgwqDCoMKgwqDCoCphZ2k7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNf
YWxsb2NfYXJnwqDCoMKgwqBhcmdzOwo+IEBAIC04MzEsNyArODMxLDcgQEAgeGZzX2lhbGxvY19h
Z19hbGxvYygKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGlmIG5lY2Vzc2Fy
eS4gSWYgYSBtZXJnZSBkb2VzIG9jY3VyLCByZWMgaXMKPiB1cGRhdGVkIHRvIHRoZQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogbWVyZ2VkIHJlY29yZC4KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBlcnJvciA9IHhmc19pbm9idF9pbnNlcnRfc3ByZWMoYXJncy5tcCwgdHAsIGFnYnAsCj4gcGFn
LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19pbm9idF9pbnNl
cnRfc3ByZWMocGFnLCB0cCwgYWdicCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgWEZTX0JUTlVNX0lOTywgJnJlYywgdHJ1
ZSk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IgPT0gLUVGU0NP
UlJVUFRFRCkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHhmc19hbGVydChhcmdzLm1wLAo+IEBAIC04NTYsMjAgKzg1NiwyMCBAQCB4ZnNfaWFsbG9j
X2FnX2FsbG9jKAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogZXhpc3Rpbmcg
cmVjb3JkIHdpdGggdGhpcyBvbmUuCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Ki8KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICh4ZnNfaGFzX2Zpbm9idChh
cmdzLm1wKSkgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZXJyb3IgPSB4ZnNfaW5vYnRfaW5zZXJ0X3NwcmVjKGFyZ3MubXAsIHRwLAo+IGFnYnAsIHBh
ZywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycm9y
ID0geGZzX2lub2J0X2luc2VydF9zcHJlYyhwYWcsIHRwLCBhZ2JwLAo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgWEZTX0JUTlVNX0ZJTk8sICZyZWMsIGZhbHNlKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBl
cnJvcjsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDCoMKgwqDCoMKgwqDC
oMKgfSBlbHNlIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIGZ1bGwgY2h1
bmsgLSBpbnNlcnQgbmV3IHJlY29yZHMgdG8gYm90aCBidHJlZXMgKi8KPiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfaW5vYnRfaW5zZXJ0KGFyZ3MubXAsIHRwLCBh
Z2JwLCBwYWcsCj4gbmV3aW5vLCBuZXdsZW4sCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGVycm9yID0geGZzX2lub2J0X2luc2VydChwYWcsIHRwLCBhZ2JwLCBuZXdpbm8sCj4gbmV3
bGVuLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFhGU19CVE5VTV9JTk8pOwo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBlcnJvcjsKPiDCoAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHhmc19oYXNfZmlub2J0KGFyZ3MubXApKSB7Cj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhm
c19pbm9idF9pbnNlcnQoYXJncy5tcCwgdHAsIGFnYnAsCj4gcGFnLCBuZXdpbm8sCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19pbm9i
dF9pbnNlcnQocGFnLCB0cCwgYWdicCwKPiBuZXdpbm8sCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIG5ld2xlbiwKPiBYRlNfQlROVU1fRklOTyk7Cj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gZXJyb3I7Cj4gQEAgLTk4MSw5ICs5ODEsOSBAQCB4ZnNfaW5vYnRfZmlyc3RfZnJl
ZV9pbm9kZSgKPiDCoCAqLwo+IMKgU1RBVElDIGludAo+IMKgeGZzX2RpYWxsb2NfYWdfaW5vYnQo
Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19wZXJhZ8KgwqDCoMKgwqDCoMKgwqAqcGFnLAo+
IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3RyYW5zwqDCoMKgwqDCoMKgwqDCoCp0cCwKPiDC
oMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19idWbCoMKgwqDCoMKgwqDCoMKgwqDCoCphZ2JwLAo+
IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfcGVyYWfCoMKgwqDCoMKgwqDCoMKgKnBhZywKPiDC
oMKgwqDCoMKgwqDCoMKgeGZzX2lub190wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcGFy
ZW50LAo+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfaW5vX3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAqaW5vcCkKPiDCoHsKPiBAQCAtMTQyOSw5ICsxNDI5LDkgQEAgeGZzX2RpYWxsb2NfYWdf
dXBkYXRlX2lub2J0KAo+IMKgICovCj4gwqBzdGF0aWMgaW50Cj4gwqB4ZnNfZGlhbGxvY19hZygK
PiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3BlcmFnwqDCoMKgwqDCoMKgwqDCoCpwYWcsCj4g
wqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfdHJhbnPCoMKgwqDCoMKgwqDCoMKgKnRwLAo+IMKg
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2J1ZsKgwqDCoMKgwqDCoMKgwqDCoMKgKmFnYnAsCj4g
LcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19wZXJhZ8KgwqDCoMKgwqDCoMKgwqAqcGFnLAo+IMKg
wqDCoMKgwqDCoMKgwqB4ZnNfaW5vX3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwYXJl
bnQsCj4gwqDCoMKgwqDCoMKgwqDCoHhmc19pbm9fdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCppbm9wKQo+IMKgewo+IEBAIC0xNDQ4LDcgKzE0NDgsNyBAQCB4ZnNfZGlhbGxvY19hZygK
PiDCoMKgwqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCF4ZnNf
aGFzX2Zpbm9idChtcCkpCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiB4
ZnNfZGlhbGxvY19hZ19pbm9idCh0cCwgYWdicCwgcGFnLCBwYXJlbnQsCj4gaW5vcCk7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiB4ZnNfZGlhbGxvY19hZ19pbm9idChw
YWcsIHRwLCBhZ2JwLCBwYXJlbnQsCj4gaW5vcCk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgLyoK
PiDCoMKgwqDCoMKgwqDCoMKgICogSWYgcGFnaW5vIGlzIDAgKHRoaXMgaXMgdGhlIHJvb3QgaW5v
ZGUgYWxsb2NhdGlvbikgdXNlCj4gbmV3aW5vLgo+IEBAIC0xNTk0LDggKzE1OTQsOCBAQCB4ZnNf
aWFsbG9jX25leHRfYWcoCj4gwqAKPiDCoHN0YXRpYyBib29sCj4gwqB4ZnNfZGlhbGxvY19nb29k
X2FnKAo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfdHJhbnPCoMKgwqDCoMKgwqDCoMKgKnRw
LAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3BlcmFnwqDCoMKgwqDCoMKgwqDCoCpwYWcs
Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc190cmFuc8KgwqDCoMKgwqDCoMKgwqAqdHAsCj4g
wqDCoMKgwqDCoMKgwqDCoHVtb2RlX3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
bW9kZSwKPiDCoMKgwqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZmxhZ3MsCj4gwqDCoMKgwqDCoMKgwqDCoGJvb2zCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgb2tfYWxsb2MpCj4gQEAgLTE2MDYsNiArMTYwNiw4IEBA
IHhmc19kaWFsbG9jX2dvb2RfYWcoCj4gwqDCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5lZWRzcGFjZTsKPiDCoMKgwqDCoMKgwqDCoMKg
aW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3I7Cj4gwqAK
PiArwqDCoMKgwqDCoMKgwqBpZiAoIXBhZykKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIGZhbHNlOwo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIXBhZy0+cGFnaV9pbm9kZW9r
KQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGZhbHNlOwo+IMKgCj4g
QEAgLTE2NjUsOCArMTY2Nyw4IEBAIHhmc19kaWFsbG9jX2dvb2RfYWcoCj4gwqAKPiDCoHN0YXRp
YyBpbnQKPiDCoHhmc19kaWFsbG9jX3RyeV9hZygKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZz
X3RyYW5zwqDCoMKgwqDCoMKgwqDCoCoqdHBwLAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZz
X3BlcmFnwqDCoMKgwqDCoMKgwqDCoCpwYWcsCj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc190
cmFuc8KgwqDCoMKgwqDCoMKgwqAqKnRwcCwKPiDCoMKgwqDCoMKgwqDCoMKgeGZzX2lub190wqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcGFyZW50LAo+IMKgwqDCoMKgwqDCoMKgwqB4ZnNf
aW5vX3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqbmV3X2lubywKPiDCoMKgwqDCoMKg
wqDCoMKgYm9vbMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBva19hbGxv
YykKPiBAQCAtMTY4OSw3ICsxNjkxLDcgQEAgeGZzX2RpYWxsb2NfdHJ5X2FnKAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3JlbGVhc2U7
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqAKPiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfaWFsbG9jX2FnX2FsbG9jKCp0cHAsIGFnYnAs
IHBhZyk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycm9yID0geGZzX2lhbGxv
Y19hZ19hbGxvYyhwYWcsICp0cHAsIGFnYnApOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgaWYgKGVycm9yIDwgMCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBnb3RvIG91dF9yZWxlYXNlOwo+IMKgCj4gQEAgLTE3MDUsNyArMTcwNyw3
IEBAIHhmc19kaWFsbG9jX3RyeV9hZygKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKgCj4gwqDCoMKg
wqDCoMKgwqDCoC8qIEFsbG9jYXRlIGFuIGlub2RlIGluIHRoZSBmb3VuZCBBRyAqLwo+IC3CoMKg
wqDCoMKgwqDCoGVycm9yID0geGZzX2RpYWxsb2NfYWcoKnRwcCwgYWdicCwgcGFnLCBwYXJlbnQs
ICZpbm8pOwo+ICvCoMKgwqDCoMKgwqDCoGVycm9yID0geGZzX2RpYWxsb2NfYWcocGFnLCAqdHBw
LCBhZ2JwLCBwYXJlbnQsICZpbm8pOwo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIWVycm9yKQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKm5ld19pbm8gPSBpbm87Cj4gwqDCoMKgwqDC
oMKgwqDCoHJldHVybiBlcnJvcjsKPiBAQCAtMTc5MCw5ICsxNzkyLDkgQEAgeGZzX2RpYWxsb2Mo
Cj4gwqDCoMKgwqDCoMKgwqDCoGFnbm8gPSBzdGFydF9hZ25vOwo+IMKgwqDCoMKgwqDCoMKgwqBm
bGFncyA9IFhGU19BTExPQ19GTEFHX1RSWUxPQ0s7Cj4gwqDCoMKgwqDCoMKgwqDCoGZvciAoOzsp
IHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcGFnID0geGZzX3BlcmFnX2dldCht
cCwgYWdubyk7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICh4ZnNfZGlhbGxv
Y19nb29kX2FnKCp0cHAsIHBhZywgbW9kZSwgZmxhZ3MsCj4gb2tfYWxsb2MpKSB7Cj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19kaWFs
bG9jX3RyeV9hZyh0cHAsIHBhZywgcGFyZW50LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBwYWcgPSB4ZnNfcGVyYWdfZ3JhYihtcCwgYWdubyk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGlmICh4ZnNfZGlhbGxvY19nb29kX2FnKHBhZywgKnRwcCwgbW9kZSwgZmxh
Z3MsCj4gb2tfYWxsb2MpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBlcnJvciA9IHhmc19kaWFsbG9jX3RyeV9hZyhwYWcsIHRwcCwgcGFyZW50LAo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgJmlubywgb2tfYWxsb2MpOwo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChlcnJvciAhPSAtRUFHQUlOKQo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBicmVhazsKPiBAQCAtMTgxMywxMiArMTgxNSwxMiBAQCB4ZnNfZGlhbGxvYygKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAobG93X3Nw
YWNlKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBva19hbGxvYyA9IHRydWU7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqB9Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhmc19wZXJhZ19wdXQo
cGFnKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZzX3BlcmFnX3JlbGUocGFn
KTsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlmICghZXJyb3Ip
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqbmV3X2lubyA9IGlubzsKPiAtwqDC
oMKgwqDCoMKgwqB4ZnNfcGVyYWdfcHV0KHBhZyk7Cj4gK8KgwqDCoMKgwqDCoMKgeGZzX3BlcmFn
X3JlbGUocGFnKTsKPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGVycm9yOwo+IMKgfQo+IMKgCj4g
QEAgLTE5MDIsMTQgKzE5MDQsMTQgQEAgeGZzX2RpZnJlZV9pbm9kZV9jaHVuaygKPiDCoAo+IMKg
U1RBVElDIGludAo+IMKgeGZzX2RpZnJlZV9pbm9idCgKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qg
eGZzX21vdW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqbXAsCj4gK8KgwqDCoMKg
wqDCoMKgc3RydWN0IHhmc19wZXJhZ8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKnBh
ZywKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc190cmFuc8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgKnRwLAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2J1ZsKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCphZ2JwLAo+IC3CoMKgwqDCoMKgwqDCoHN0cnVj
dCB4ZnNfcGVyYWfCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpwYWcsCj4gwqDCoMKg
wqDCoMKgwqDCoHhmc19hZ2lub190wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgYWdpbm8sCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaWNsdXN0ZXLCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCp4aWMsCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5v
YnRfcmVjX2luY29yZcKgwqDCoMKgwqAqb3JlYykKPiDCoHsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgeGZzX21vdW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqbXAgPSBwYWctPnBh
Z19tb3VudDsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19hZ2nCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAqYWdpID0gYWdicC0+Yl9hZGRyOwo+IMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QgeGZzX2J0cmVlX2N1csKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpjdXI7Cj4gwqDC
oMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vYnRfcmVjX2luY29yZcKgwqDCoMKgwqByZWM7Cj4g
QEAgLTIwMzYsMTMgKzIwMzgsMTMgQEAgeGZzX2RpZnJlZV9pbm9idCgKPiDCoCAqLwo+IMKgU1RB
VElDIGludAo+IMKgeGZzX2RpZnJlZV9maW5vYnQoCj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhm
c19tb3VudMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKm1wLAo+ICvCoMKgwqDCoMKg
wqDCoHN0cnVjdCB4ZnNfcGVyYWfCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpwYWcs
Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfdHJhbnPCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCp0cCwKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19idWbCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqYWdicCwKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qg
eGZzX3BlcmFnwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqcGFnLAo+IMKgwqDCoMKg
wqDCoMKgwqB4ZnNfYWdpbm9fdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGFnaW5vLAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2J0X3JlY19pbmNvcmXC
oMKgwqDCoMKgKmlidHJlYykgLyogaW5vYnQgcmVjb3JkICovCj4gwqB7Cj4gK8KgwqDCoMKgwqDC
oMKgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKm1wID0g
cGFnLT5wYWdfbW91bnQ7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfYnRyZWVfY3VywqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgKmN1cjsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19p
bm9idF9yZWNfaW5jb3JlwqDCoMKgwqDCoHJlYzsKPiDCoMKgwqDCoMKgwqDCoMKgaW50wqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG9mZnNl
dCA9IGFnaW5vIC0gaWJ0cmVjLQo+ID5pcl9zdGFydGlubzsKPiBAQCAtMjE5Niw3ICsyMTk4LDcg
QEAgeGZzX2RpZnJlZSgKPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiDCoMKgwqDCoMKgwqDCoMKgICog
Rml4IHVwIHRoZSBpbm9kZSBhbGxvY2F0aW9uIGJ0cmVlLgo+IMKgwqDCoMKgwqDCoMKgwqAgKi8K
PiAtwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19kaWZyZWVfaW5vYnQobXAsIHRwLCBhZ2JwLCBw
YWcsIGFnaW5vLCB4aWMsCj4gJnJlYyk7Cj4gK8KgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfZGlm
cmVlX2lub2J0KHBhZywgdHAsIGFnYnAsIGFnaW5vLCB4aWMsICZyZWMpOwo+IMKgwqDCoMKgwqDC
oMKgwqBpZiAoZXJyb3IpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIGVy
cm9yMDsKPiDCoAo+IEBAIC0yMjA0LDcgKzIyMDYsNyBAQCB4ZnNfZGlmcmVlKAo+IMKgwqDCoMKg
wqDCoMKgwqAgKiBGaXggdXAgdGhlIGZyZWUgaW5vZGUgYnRyZWUuCj4gwqDCoMKgwqDCoMKgwqDC
oCAqLwo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoeGZzX2hhc19maW5vYnQobXApKSB7Cj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycm9yID0geGZzX2RpZnJlZV9maW5vYnQobXAsIHRw
LCBhZ2JwLCBwYWcsIGFnaW5vLAo+ICZyZWMpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBlcnJvciA9IHhmc19kaWZyZWVfZmlub2J0KHBhZywgdHAsIGFnYnAsIGFnaW5vLAo+ICZy
ZWMpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gZXJyb3IwOwo+
IMKgwqDCoMKgwqDCoMKgwqB9Cj4gQEAgLTI5MjgsMTUgKzI5MzAsMTQgQEAgeGZzX2lhbGxvY19j
YWxjX3Jvb3Rpbm8oCj4gwqAgKi8KPiDCoGludAo+IMKgeGZzX2lhbGxvY19jaGVja19zaHJpbmso
Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19wZXJhZ8KgwqDCoMKgwqDCoMKgwqAqcGFnLAo+
IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3RyYW5zwqDCoMKgwqDCoMKgwqDCoCp0cCwKPiAt
wqDCoMKgwqDCoMKgwqB4ZnNfYWdudW1iZXJfdMKgwqDCoMKgwqDCoMKgwqDCoMKgYWdubywKPiDC
oMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19idWbCoMKgwqDCoMKgwqDCoMKgwqDCoCphZ2licCwK
PiDCoMKgwqDCoMKgwqDCoMKgeGZzX2FnYmxvY2tfdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBuZXdf
bGVuZ3RoKQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2J0X3JlY19pbmNv
cmUgcmVjOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2J0cmVlX2N1csKgwqDCoMKgKmN1
cjsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKgwqAqbXAg
PSB0cC0+dF9tb3VudHA7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19wZXJhZ8KgwqDCoMKg
wqDCoMKgwqAqcGFnOwo+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfYWdpbm9fdMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgYWdpbm8gPSBYRlNfQUdCX1RPX0FHSU5PKG1wLAo+IG5ld19sZW5ndGgpOwo+
IMKgwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBoYXM7Cj4gwqDCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGVycm9yOwo+IEBAIC0yOTQ0LDcgKzI5NDUsNiBAQCB4ZnNfaWFsbG9j
X2NoZWNrX3NocmluaygKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCF4ZnNfaGFzX3NwYXJzZWlub2Rl
cyhtcCkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiDCoAo+
IC3CoMKgwqDCoMKgwqDCoHBhZyA9IHhmc19wZXJhZ19nZXQobXAsIGFnbm8pOwo+IMKgwqDCoMKg
wqDCoMKgwqBjdXIgPSB4ZnNfaW5vYnRfaW5pdF9jdXJzb3IobXAsIHRwLCBhZ2licCwgcGFnLAo+
IFhGU19CVE5VTV9JTk8pOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoC8qIExvb2sgdXAgdGhlIGlu
b2J0IHJlY29yZCB0aGF0IHdvdWxkIGNvcnJlc3BvbmQgdG8gdGhlIG5ldwo+IEVPRlMuICovCj4g
QEAgLTI5NjgsNiArMjk2OCw1IEBAIHhmc19pYWxsb2NfY2hlY2tfc2hyaW5rKAo+IMKgwqDCoMKg
wqDCoMKgwqB9Cj4gwqBvdXQ6Cj4gwqDCoMKgwqDCoMKgwqDCoHhmc19idHJlZV9kZWxfY3Vyc29y
KGN1ciwgZXJyb3IpOwo+IC3CoMKgwqDCoMKgwqDCoHhmc19wZXJhZ19wdXQocGFnKTsKPiDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIGVycm9yOwo+IMKgfQo+IGRpZmYgLS1naXQgYS9mcy94ZnMvbGli
eGZzL3hmc19pYWxsb2MuaCBiL2ZzL3hmcy9saWJ4ZnMveGZzX2lhbGxvYy5oCj4gaW5kZXggNGNm
Y2UyZWViZTdlLi5hYjhjMzBiNGVjMjIgMTAwNjQ0Cj4gLS0tIGEvZnMveGZzL2xpYnhmcy94ZnNf
aWFsbG9jLmgKPiArKysgYi9mcy94ZnMvbGlieGZzL3hmc19pYWxsb2MuaAo+IEBAIC0xMDcsNyAr
MTA3LDcgQEAgaW50IHhmc19pYWxsb2NfY2x1c3Rlcl9hbGlnbm1lbnQoc3RydWN0IHhmc19tb3Vu
dAo+ICptcCk7Cj4gwqB2b2lkIHhmc19pYWxsb2Nfc2V0dXBfZ2VvbWV0cnkoc3RydWN0IHhmc19t
b3VudCAqbXApOwo+IMKgeGZzX2lub190IHhmc19pYWxsb2NfY2FsY19yb290aW5vKHN0cnVjdCB4
ZnNfbW91bnQgKm1wLCBpbnQgc3VuaXQpOwo+IMKgCj4gLWludCB4ZnNfaWFsbG9jX2NoZWNrX3No
cmluayhzdHJ1Y3QgeGZzX3RyYW5zICp0cCwgeGZzX2FnbnVtYmVyX3QKPiBhZ25vLAo+ICtpbnQg
eGZzX2lhbGxvY19jaGVja19zaHJpbmsoc3RydWN0IHhmc19wZXJhZyAqcGFnLCBzdHJ1Y3QgeGZz
X3RyYW5zCj4gKnRwLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhm
c19idWYgKmFnaWJwLCB4ZnNfYWdibG9ja190IG5ld19sZW5ndGgpOwo+IMKgCj4gwqAjZW5kaWbC
oC8qIF9fWEZTX0lBTExPQ19IX18gKi8KCg==
