Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A2870D207
	for <lists+linux-xfs@lfdr.de>; Tue, 23 May 2023 05:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbjEWC76 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 May 2023 22:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbjEWC7v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2023 22:59:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9E2CA
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 19:59:49 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MNuJUA018508;
        Tue, 23 May 2023 02:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=XT6fWLTApDvSYTg8V+VrR5zpUVjWMPrYDByvxc+q+o4=;
 b=ffPLG7ad3kqXZwwuzvc/IePARB3NOuGjgQxeSZ9GqZI2UMjND/NGN7YDAR2gQ8NN9Qd4
 0jZ4VGdoTDiFC+u061+Jyg6ZWTqja1FaasxkmewLm++0fu2Gy7vYZ2AlQuWuAf66dt9M
 lCVn2nhWvfDt9/jBCh64h86x2onrOQjYxxT9UstzYALl2TixlTZzgK7u/62EiOodll3w
 4zGiAtMMQPFmm4Poht42b3wKAm8h7ZGrASxP9kMW2uLc1w3wWqfaAl1IUMUrn/uSTZHn
 VA9fkh/TqssTL1NEL3kTy9SWvKIgjrWYGlQP+AqSTnz19geWw2Upd/VwhDai/pR5vIT1 wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp5bm2vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 02:59:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N0jcBQ015878;
        Tue, 23 May 2023 02:59:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk6hqum7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 02:59:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVj8Jv30h5nFc/jVeESCgfp2B8nQemhcCQkFU6zXTaDSrAjAen6ZdppO1ZG0rI0iO5UQdmZdo1/CrhWrWfdgeA5mJsOTN+vkIIKdu3pMhYQuJE3/mneK7zMgzVwVR0EihlmVh57Yo6/LGTsNNIU0CBpdSayt+EJ4Xl6hxO1Yvl2jmZP5ticvRttGQ5HEVnbvRBL628PZd7wKu7sWFh+UC1HBP4dWiQPEueCRtsD/0jhRQeHOGctIomzXk7dPOGlzTllL41/aYj9zo7yn/bW+5fzq4wPV4MMWBUU4D9VSq0+Gdbrndm1fgwYtduT6EY8WAcNl5n0zzcwzfEKBGH73NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XT6fWLTApDvSYTg8V+VrR5zpUVjWMPrYDByvxc+q+o4=;
 b=lLOT2K1wilxdPRe/WrfQhE3dI6KLnlEf78XA2RkCAFIYSmBG4Ajda2JWISgigQ/5WN+TOPC7ScktTrjotqzq+6fdh23RMAY5n63iMNHcanprMaBCh6AIDs92wy6QKbu9XTuQxu5m3NjkDRKnQi5qU/pu5a46EUiPYAARrgA/z23CLNJn4/UbvN7L40en5bTfIX3zvzG+Y15CcZKaagqq9UtszJXu2xwMQTL048COs9CbbVYfKJu/yQk7V2oMmD78NU+v8hlgyJTeYsgiGdELuuL/jAZQjDoc/0UShGRm4t0OayhrXdx70WrvlwuzVMj5x64fSJck04zw4zWGm+qMNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XT6fWLTApDvSYTg8V+VrR5zpUVjWMPrYDByvxc+q+o4=;
 b=pH7wAgvNQ9LhOWJ0mT1Y9ykQrjOlDzu1jT6z0KSpg/+EskbiQDjgudlYyT2qBJSmbMrjNvuxoKEpMMxZwCMGv6fY9x95bGbhvc65zNacMyMzZ5z0czk+Wd+acDnnXRK+hJSnZXHQYVXUR3vWdkMDtU+d8/nc9tOYm72OWhDDqKU=
Received: from BN7PR10MB2690.namprd10.prod.outlook.com (2603:10b6:406:c0::11)
 by DM4PR10MB6887.namprd10.prod.outlook.com (2603:10b6:8:101::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 02:59:41 +0000
Received: from BN7PR10MB2690.namprd10.prod.outlook.com
 ([fe80::4e44:25bc:cd97:26db]) by BN7PR10MB2690.namprd10.prod.outlook.com
 ([fe80::4e44:25bc:cd97:26db%5]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 02:59:41 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "djwong@kernel.org" <djwong@kernel.org>
Subject: Re: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Thread-Topic: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Thread-Index: AQHZinX1nnrwqHRxhUWvKoRfYjwI669lgWmAgAEdsgCAAEjTgIAASFMA
Date:   Tue, 23 May 2023 02:59:40 +0000
Message-ID: <8DD695CE-4965-4B33-8F16-6B907D8A0884@oracle.com>
References: <20230519171829.4108-1-wen.gang.wang@oracle.com>
 <ZGrCpXoEk9achabI@dread.disaster.area>
 <E6E92519-4AD7-4115-903F-00D7633B1B3A@oracle.com>
 <ZGvvZaQWvxf2cqlz@dread.disaster.area>
In-Reply-To: <ZGvvZaQWvxf2cqlz@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR10MB2690:EE_|DM4PR10MB6887:EE_
x-ms-office365-filtering-correlation-id: b609461c-d6fa-4bf1-be44-08db5b39c0b7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rh6a4kLqBV7gn0Ng1cq2Ec0/eDqlFBhoBqRj/kXV5iPQ5jQoeR7akoeawNYxaoI0t8XPkggB7xoILNP2qb3hbSLfJI13WqszIclZS+Hl7mDd2hhGCKf8xwdProsFzNXaVZSjDev1w1eWCn49InGF7ZysFs4S2gG1rHf+ct0VojSIMpuJOhldtE7TP6xiKk8OYEf541lyHB/PUnpmEdc43A+d0sgzMcOxj2zX1zKrUpj+/h97KfAMrbGm93L8b4/81ennd7rO1/xy3t7r5yKwA6VimTewiOcLibptuuOxonxWSoCReAJcpssXr2JaNPwWHKQDTWy/tpylGiFtfrb0Iho3wPySIsdyJ10wa5gfFQYSH/McsHhT5T85Im6PCKAgsbT4QQjSJ5xZ6/3g0awkTyT575vumVoskVLo3/0K5S5k7OwKf4sDmEdfsz6NdDQ02wDvmWhcAU08KCjSKRKNVLkxkSeGNtf6VwYihkq6acvvOPLn8j4dMrklnpw5XUmTHmAKCLX6tHbiVDuMSAATWphdxBfwVc+zRqhX5FcqogPurQuQPl7PCNC5lJsF8CqTO66XAJ0hb9MiekGw1dV7zRo5mqGPpPlOjMePfStlZYMgqDq0yJ3IdPhFK/1hj7S+jZCC1MWZJDo7cxTWb34MKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR10MB2690.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199021)(54906003)(41300700001)(6486002)(478600001)(316002)(71200400001)(91956017)(4326008)(76116006)(6916009)(64756008)(66446008)(66946007)(66556008)(66476007)(86362001)(5660300002)(38070700005)(8936002)(8676002)(38100700002)(26005)(122000001)(6506007)(53546011)(6512007)(186003)(2906002)(33656002)(83380400001)(2616005)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkVqNloxRW15WkpwWTZtekVyNGxmcnVaT21DU1pEcDVEVmxoa1h1YjBaK0l0?=
 =?utf-8?B?WHNMR1BqWkN2RURCRGZvZG1XcVBTaWNwVC8rWEJRRlRxZElyQThFZWlxR2Ev?=
 =?utf-8?B?MmJSS1J0MTNpY01rQTAyNHRDT3VoV1o4Z2VoS1ZkM3BUQWltbzN6d0tUTHFl?=
 =?utf-8?B?Sy92KzdsZVhlZ2I0YmlKVEpycjJna2M2MjFtZldZSW5DT21qelp1WU5IMTNs?=
 =?utf-8?B?L3dqWkl1UmZtdjEzWnR1bDlWRVZzRGt5UXVTbjFxMHFtclB6aGQ1cFlrdC9F?=
 =?utf-8?B?VVhFZnJBWkE2NTBQTTh1YVI0VjlDL0Y1QVhmemt5b05Td25rbERjQWRCazJK?=
 =?utf-8?B?Z2Z0cXMrTWZlVlZEVU1acnhMVmFwYXV2NjcvaGlxYTdqTXhiQ0dpaTVFOEFk?=
 =?utf-8?B?UCtCOVJCWlBkS1k1OWtrWTNURDJsMWJJZ2JCVFlSR0o2aTFsdkhhTnZvdllu?=
 =?utf-8?B?UFZTdm4xL3pxQ1lOWXNYN1NrckVxaWovS2g3YmQxNmttQTRXQ1duenVzUW4x?=
 =?utf-8?B?NDNrVk5tLzZQVVRMSTlLakVsZVRCU0REZjBTZ2ZXRXhaUG9NUmR3RkJ0UmJx?=
 =?utf-8?B?ODZSQTlZa2l4VEpWbnZ0ckVHdUJQVHRudzlvTjFCQm5hNlREek9hcmZmNUFJ?=
 =?utf-8?B?OS9ra2FoWEI0TS85R1JpcWxJVjg0ZUZ2TWFnbGM1Q3pOWDYrNDZESEs2bVlz?=
 =?utf-8?B?TTRtbnFLUGVVMEtUazh1bS9xZXdIZ3g4MTVGNWt5NldXZkdUK3JhK0Jza3BM?=
 =?utf-8?B?Q0hYUnJUVDVFbTZMSXV1QldCdnA2VHhZa0ZQTW8vRXByTUJ2eUUxai9ONzFM?=
 =?utf-8?B?SnV2VzJBSk1JQi84R3grMXVzejZBL2FGVWNyR0k2dVVvR0V2U3VadEtQb1hJ?=
 =?utf-8?B?Qk9lclNzaFZMUHYzTjZES2hqVXdKTEIxbUtVQll6UmZDdDFGTkgxM013bmtw?=
 =?utf-8?B?d3RlMytGQlVMcjE0Qm9HakZydzdmMkNQb2t1bHFxZFArM0toSktlZXdQbjZ5?=
 =?utf-8?B?emRYMWpqL3hQSi9RelJ4NTBTV2FxUVNLaDFoYk91VThJZjQ4cFo5ZmZsSksz?=
 =?utf-8?B?RVhoQUJmTnQ5UnJFdTdvQ0hjMnlLOFM2UDBnMTJkdFBiTUIwM3ZObFFvZTg1?=
 =?utf-8?B?OCtnbVdkb3lYZnNLK01ybVNRU2d3dElFYitRS25Rcmx6V0NWWERLcGRHREhE?=
 =?utf-8?B?eFYwVFF0OFRRWXJwYURtK21VL2pIM0FuRnl1eWpwbGtGOEJoNEpPMlo3dzBC?=
 =?utf-8?B?dHdBczJNQnhSd1FmcFd3eTI1VUxaRWlOYUtVbWMxTG1KWjdTSnBqb1NxWXFj?=
 =?utf-8?B?VkFWY3M0YktML2gyUkc3UVNCWGFyRXpxWm1VRHY2eGlsbDBqdTR1aHB3K25a?=
 =?utf-8?B?M2FRYTZwR2Z0azE0WlJRMkVZQXVYQkhZNUxOd2kwTjZ4MlVXejVqWkRPbU40?=
 =?utf-8?B?Vzl2U3F0dkNNbE11bk5teWc0Yk15UE4yYzh4OWFoc0V3My8xajZ3Q1RpdEU2?=
 =?utf-8?B?UTU1YTRXTVM2NzdxY1F1WmlINWtRN3ZsdWx1bFVOdWRqcUg3cXdqR0RKdjRW?=
 =?utf-8?B?VFArMy91TnpYQkdDeWpaU09aVlBXWUxiYmpMQWZkQTIxcVF2QThhYzU0ZmtQ?=
 =?utf-8?B?NEdzcXdNNG5TcE16akx1ODJucENvUDRhS2tqVHdCYXR1Mkw2aDYrdFBRMlBa?=
 =?utf-8?B?WWFKbzBRTkJ3SmpqdXAwWW5TRzI4dEZjQXdZWE1wcEp4UDB1dkdrcWVicCt2?=
 =?utf-8?B?NVBDUnlEK283QXNPOVlTRW04bWczM2xxVFVITk1UMC95TjlDTVFnTzB1ZlF4?=
 =?utf-8?B?UmdHN1lkQ3NFTWF2dVdMYTRzcFJOd0tiaXo2cGFkb1FhOXh0WDNaT1pXZks5?=
 =?utf-8?B?RlprZ2tGZEJDTUZlMktTdHRDTllzSUJUOUNTWW5YenVFVm9SaTVoWGlWZEVh?=
 =?utf-8?B?TFNpTHdLaUg2R0FiN2Nja2lxSVhYSkFNeUNkL1REd25GbDVhYkFKZnhJWTM1?=
 =?utf-8?B?dW1UYWE0Q0U4U1ltVmljbm1TRjh3V21XYWNqbUY1ZVJ0d1VmMnNLT1dpcENr?=
 =?utf-8?B?Y255aEtSNzFYMk91L0ZnZDYzNFpkalZXbktjbWt2TWhWbUFXeFFJTmsrZ0Z4?=
 =?utf-8?B?L1lvMGJEL25ITHNjckRzUVVpdDAzOHIyL0JnaHl1TWppZ1dEbzBvN0owaUpi?=
 =?utf-8?B?RGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6ED5DD8F0B069D489AB69B2B87194E27@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: heHskwZHxADeHeZ+ZGP1vJ0gs6yBKF20aaUUYj19f0wun6OXx3R3JGhLKjpzAB4AttLPE3t/XQxmYacQE+553Xyazif25Jw40eYGd74jeJIcPjbWr0cxTufTU2UOUbipoatNprDMiNzCAxqLHlRV/DGyiQMOba/Kky7JCEw+tDBvniP2eD9p0XqBQ4Kth6UhVEzsnX2g5+pf158HPm8YomuG/4kfrNudXjU3COtWmZsBv8P8L/BugfTT5r099YGU9vwv0lFE2JQDUUYJJlhd+xkTMUZLnzXJ6zIRtoClpsVym0Fqs4MclV+lpleu7ys/e1tTBOsVzP+7k29ttnXOln34xJQ5ho/Xa0br9RKqCrqwvzClyBil0k/5OM+IQfRaosu/fMkIPDFdMRWDq6bBTSnmF33zSCJ9X3uLP4lZ4upZDRybZOdNQtm1Ymb6ClPO2LV9LtvlQ9qSBa4F89cWcFxPcLnZk3CJrJOG5ySZIcyzv4lNmxIO6zGCrvQiZ6VMMbsLVKF3UCs79L1xPAtvHwp6V8O1O3ZfhuWuvHOfHTJINq2NBi4x5mPlBkP8iIqdA525LN3M/EqCVlB8Zr8uijalPzYfXZWkfaxz6S9B28OFd29Vc/5FGdj7Yw9501s8JLW/4Urm6TDvpxZ0aGrJpkMvu3rnFynKjFgwPzosLc13trfYy+iHu+iOk1kp/nhuiXUOngmlkn7dTRVygiLAx4Ry0lj5IVOIIbABGsL6Mw6KL6PlI6IGJQAi1JZ19OpmYMyR1X2SdUf+sthgJHYyELjcyq0WtbVxIgOGaYiEvbDdV3+LczEjRQQ208eqTEN/rhfdN5W7wOMfgZhxF9N5Gw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR10MB2690.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b609461c-d6fa-4bf1-be44-08db5b39c0b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 02:59:40.7345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OXAEnfmnD6O275uFHJgN9XmCaLehBcuZlF6y+Fe3P+qEp1WbFXUiXZhAwtOsYQ3KP9boBdSOYB1A9SSKkR7Xsr74YGbjDoZ87l8xBjNPBD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_18,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305230023
X-Proofpoint-GUID: mEziktVaAV4xTHPuTnDLWeMNCVfyShgP
X-Proofpoint-ORIG-GUID: mEziktVaAV4xTHPuTnDLWeMNCVfyShgP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gTWF5IDIyLCAyMDIzLCBhdCAzOjQwIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBNYXkgMjIsIDIwMjMgYXQgMDY6MjA6
MTFQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+IE9uIE1heSAyMSwgMjAyMywgYXQg
NjoxNyBQTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToNCj4+PiBP
biBGcmksIE1heSAxOSwgMjAyMyBhdCAxMDoxODoyOUFNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3Jv
dGU6DQo+Pj4+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2V4dGZyZWVfaXRlbS5jIGIvZnMveGZz
L3hmc19leHRmcmVlX2l0ZW0uYw0KPj4+PiBpbmRleCAwMTFiNTA0NjkzMDEuLjNjNWE5ZTk5NTJl
YyAxMDA2NDQNCj4+Pj4gLS0tIGEvZnMveGZzL3hmc19leHRmcmVlX2l0ZW0uYw0KPj4+PiArKysg
Yi9mcy94ZnMveGZzX2V4dGZyZWVfaXRlbS5jDQo+Pj4+IEBAIC0zMzYsNiArMzM2LDI1IEBAIHhm
c190cmFuc19nZXRfZWZkKA0KPj4+PiByZXR1cm4gZWZkcDsNCj4+Pj4gfQ0KPj4+PiANCj4+Pj4g
Ky8qDQo+Pj4+ICsgKiBGaWxsIHRoZSBFRkQgd2l0aCBhbGwgZXh0ZW50cyBmcm9tIHRoZSBFRkkg
YW5kIHNldCB0aGUgY291bnRlci4NCj4+Pj4gKyAqIE5vdGU6IHRoZSBFRkQgc2hvdWxkIGNvbXRh
aW4gYXQgbGVhc3Qgb25lIGV4dGVudHMgYWxyZWFkeS4NCj4+Pj4gKyAqLw0KPj4+PiArc3RhdGlj
IHZvaWQgeGZzX2ZpbGxfZWZkX3dpdGhfZWZpKHN0cnVjdCB4ZnNfZWZkX2xvZ19pdGVtICplZmRw
KQ0KPj4+PiArew0KPj4+PiArIHN0cnVjdCB4ZnNfZWZpX2xvZ19pdGVtICplZmlwID0gZWZkcC0+
ZWZkX2VmaXA7DQo+Pj4+ICsgdWludCAgICAgICAgICAgICAgICAgICAgaTsNCj4+Pj4gKw0KPj4+
PiArIGlmIChlZmRwLT5lZmRfbmV4dF9leHRlbnQgPT0gZWZpcC0+ZWZpX2Zvcm1hdC5lZmlfbmV4
dGVudHMpDQo+Pj4+ICsgcmV0dXJuOw0KPj4+PiArDQo+Pj4+ICsgZm9yIChpID0gMDsgaSA8IGVm
aXAtPmVmaV9mb3JtYXQuZWZpX25leHRlbnRzOyBpKyspIHsNCj4+Pj4gKyAgICAgICAgZWZkcC0+
ZWZkX2Zvcm1hdC5lZmRfZXh0ZW50c1tpXSA9DQo+Pj4+ICsgICAgICAgIGVmaXAtPmVmaV9mb3Jt
YXQuZWZpX2V4dGVudHNbaV07DQo+Pj4+ICsgfQ0KPj4+PiArIGVmZHAtPmVmZF9uZXh0X2V4dGVu
dCA9IGVmaXAtPmVmaV9mb3JtYXQuZWZpX25leHRlbnRzOw0KPj4+PiArfQ0KPj4+PiArDQo+Pj4g
DQo+Pj4gT2ssIGJ1dCBpdCBkb2Vzbid0IGRpcnR5IHRoZSB0cmFuc2FjdGlvbiBvciB0aGUgRUZE
LCB3aGljaCBtZWFucy4uLi4NCj4+IA0KPj4gQWN0dWFsbHkgRUFHQUlOIHNob3VsZG7igJl0IGhh
cHBlbiB3aXRoIHRoZSBmaXJzdCByZWNvcmQgaW4gRUZJcyBiZWNhdXNlDQo+PiB0aGUgdHJhbnMt
PnRfYnVzeSBpcyBlbXB0eSBpbiBBR0ZMIGJsb2NrIGFsbG9jYXRpb24gZm9yIHRoZSBmaXJzdCBy
ZWNvcmQuDQo+PiBTbyB0aGUgZGlydHlpbmcgd29yayBzaG91bGQgYWxyZWFkeSBkb25lIHdpdGgg
dGhlIGZpcnN0IG9uZS4NCj4gDQo+IFlvdSdyZSBhc3N1bWluZyB0aGF0IHRoZSBvbmx5IHRoaW5n
IHdlIGFyZSBnb2luZyB0byB3YW50IHRvIHJldHVybg0KPiAtRUFHQUlOIGZvciBmcmVlaW5nIGF0
dGFtcHMgZm9yIGlzIGJ1c3kgZXh0ZW50cy4gQmVpbmcgYWJsZSB0bw0KPiByZXN0YXJ0IGJ0cmVl
IG9wZXJhdGlvbnMgYnkgImNvbW1pdCBhbmQgcmV0cnkiIG9wZW5zIHVwIGENCj4gYSB3aG9sZSBu
ZXcgc2V0IG9mIHBlcmZvcm1hbmNlIG9wdGltaXNhdGlvbnMgd2UgY2FuIG1ha2UgdG8gdGhlDQo+
IGJ0cmVlIGNvZGUuDQo+IA0KPiBJT1dzLCBJIHdhbnQgdGhpcyBmdW5jdGlvbmFsaXR5IHRvIGJl
IGdlbmVyaWMgaW4gbmF0dXJlLCBub3QNCj4gdGFpbG9yZWQgc3BlY2lmaWNhbGx5IHRvIG9uZSBz
aXR1YXRpb24gd2hlcmUgYW4gLUVBR0FJTiBuZWVkcyB0byBiZQ0KPiByZXR1cm5lZCB0byB0cmln
Z2VyIGEgY29tbWl0IGFuIHJldHJ5Lg0KDQpZZXMsIEkgYXNzdW1lZCB0aGF0IGJlY2F1c2UgSSBk
aWRu4oCZdCBzZWUgcmVsZXZhbnQgRUFHQUlOIGhhbmRsZXJzDQppbiBleGlzdGluZyBjb2RlLiBJ
dOKAmXMgcmVhc29uYWJsZSB0byBtYWtlIGl0IGdlbmVyaWMgZm9yIGV4aXN0aW5nIG9yIHBsYW5l
ZA0KRUFHQUlOcy4NCg0KPiANCj4+Pj4gQEAgLTM2OSw2ICszODgsMTAgQEAgeGZzX3RyYW5zX2Zy
ZWVfZXh0ZW50KA0KPj4+PiBlcnJvciA9IF9feGZzX2ZyZWVfZXh0ZW50KHRwLCB4ZWZpLT54ZWZp
X3N0YXJ0YmxvY2ssDQo+Pj4+IHhlZmktPnhlZmlfYmxvY2tjb3VudCwgJm9pbmZvLCBYRlNfQUdf
UkVTVl9OT05FLA0KPj4+PiB4ZWZpLT54ZWZpX2ZsYWdzICYgWEZTX0VGSV9TS0lQX0RJU0NBUkQp
Ow0KPj4+PiArIGlmIChlcnJvciA9PSAtRUFHQUlOKSB7DQo+Pj4+ICsgeGZzX2ZpbGxfZWZkX3dp
dGhfZWZpKGVmZHApOw0KPj4+PiArIHJldHVybiBlcnJvcjsNCj4+Pj4gKyB9DQo+Pj4gDQo+Pj4g
Li4uLiB0aGlzIGlzIGluY29ycmVjdGx5IHBsYWNlZC4NCj4+PiANCj4+PiBUaGUgdmVyeSBuZXh0
IGxpbmVzIHNheToNCj4+PiANCj4+Pj4gLyoNCj4+Pj4gKiBNYXJrIHRoZSB0cmFuc2FjdGlvbiBk
aXJ0eSwgZXZlbiBvbiBlcnJvci4gVGhpcyBlbnN1cmVzIHRoZQ0KPj4+PiAqIHRyYW5zYWN0aW9u
IGlzIGFib3J0ZWQsIHdoaWNoOg0KPj4+IA0KPj4+IGkuZS4gd2UgaGF2ZSB0byBtYWtlIHRoZSB0
cmFuc2FjdGlvbiBhbmQgRUZEIGxvZyBpdGVtIGRpcnR5IGV2ZW4gaWYNCj4+PiB3ZSBoYXZlIGFu
IGVycm9yLiBJbiB0aGlzIGNhc2UsIHRoZSBlcnJvciBpcyBub3QgZmF0YWwsIGJ1dCB3ZSBzdGls
bA0KPj4+IGhhdmUgdG8gZW5zdXJlIHRoYXQgd2UgY29tbWl0IHRoZSBFRkQgd2hlbiB3ZSByb2xs
IHRoZSB0cmFuc2FjdGlvbi4NCj4+PiBIZW5jZSB0aGUgdHJhbnNhY3Rpb24gYW5kIEVGRCBzdGls
bCBuZWVkIHRvIGJlIGRpcnRpZWQgb24gLUVBR0FJTi4uLg0KPj4gDQo+PiBzZWUgYWJvdmUuDQo+
IA0KPiBTZWUgYWJvdmUgOikNCj4gDQo+Pj4+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2xvZ19y
ZWNvdmVyLmMgYi9mcy94ZnMveGZzX2xvZ19yZWNvdmVyLmMNCj4+Pj4gaW5kZXggMzIyZWIyZWU2
YzU1Li4wMGJmZTk2ODNmYTggMTAwNjQ0DQo+Pj4+IC0tLSBhL2ZzL3hmcy94ZnNfbG9nX3JlY292
ZXIuYw0KPj4+PiArKysgYi9mcy94ZnMveGZzX2xvZ19yZWNvdmVyLmMNCj4+Pj4gQEAgLTI1NDAs
MzAgKzI1NDAsMjcgQEAgeGxvZ19yZWNvdmVyX3Byb2Nlc3NfaW50ZW50cygNCj4+Pj4gc3RydWN0
IHhmc19sb2dfaXRlbSAqbGlwOw0KPj4+PiBzdHJ1Y3QgeGZzX2FpbCAqYWlscDsNCj4+Pj4gaW50
IGVycm9yID0gMDsNCj4+Pj4gLSNpZiBkZWZpbmVkKERFQlVHKSB8fCBkZWZpbmVkKFhGU19XQVJO
KQ0KPj4+PiAtIHhmc19sc25fdCBsYXN0X2xzbjsNCj4+Pj4gLSNlbmRpZg0KPj4+PiArIHhmc19s
c25fdCB0aHJlc2hvbGRfbHNuOw0KPj4+PiANCj4+Pj4gYWlscCA9IGxvZy0+bF9haWxwOw0KPj4+
PiArIHRocmVzaG9sZF9sc24gPSB4ZnNfYWlsX21heF9sc24oYWlscCk7DQo+Pj4+IHNwaW5fbG9j
aygmYWlscC0+YWlsX2xvY2spOw0KPj4+PiAtI2lmIGRlZmluZWQoREVCVUcpIHx8IGRlZmluZWQo
WEZTX1dBUk4pDQo+Pj4+IC0gbGFzdF9sc24gPSB4bG9nX2Fzc2lnbl9sc24obG9nLT5sX2N1cnJf
Y3ljbGUsIGxvZy0+bF9jdXJyX2Jsb2NrKTsNCj4+PiANCj4+PiB4ZnNfYWlsX21heF9sc24oKSBh
bmQgbF9jdXJyX2N5Y2xlL2xfY3Vycl9ibG9jayBhcmUgbm90IHRoZSBzYW1lDQo+Pj4gdGhpbmcu
ICBtYXhfbHNuIHBvaW50cyB0byB0aGUgbHNuIG9mIHRoZSBsYXN0IGVudHJ5IGluIHRoZSBBSUwg
KGluDQo+Pj4gbWVtb3J5IHN0YXRlKSwgd2hpbHN0IGN1cnJfY3ljbGUvYmxvY2sgcG9pbnRzIHRv
IHRoZSBjdXJyZW50DQo+Pj4gcGh5c2ljYWwgbG9jYXRpb24gb2YgdGhlIGxvZyBoZWFkIGluIHRo
ZSBvbi1kaXNrIGpvdXJuYWwuDQo+Pj4gDQo+PiANCj4+IFllcywgSSBpbnRlbmRlZCB0byB1c2Ug
dGhlIGxzbiBvZiB0aGUgbGFzdCBlbnRyeSBpbiB0aGUgQUlMLg0KPiANCj4gQWdhaW4sIHRoZXkg
YXJlIG5vdCB0aGUgc2FtZSB0aGluZzogdXNpbmcgdGhlIGxhc3QgZW50cnkgaW4gdGhlDQo+IEFJ
TCBoZXJlIGlzIGluY29ycmVjdC4gV2Ugd2FudCB0byByZXBsYXkgYWxsIHRoZSBpdGVtcyBpbiB0
aGUgQUlMDQo+IHRoYXQgd2VyZSBhY3RpdmUgaW4gdGhlIGxvZywgbm90IHVwIHRvIHRoZSBsYXN0
IGl0ZW0gaW4gdGhlIEFJTC4gVGhlDQo+IGFjdGl2ZWx5IHJlY292ZXJlZCBsb2cgcmVnaW9uIGVu
ZHMgYXQgbGFzdF9sc24gYXMgcGVyIGFib3ZlLCB3aGlsc3QNCj4geGZzX2FpbF9tYXhfbHNuKCkg
aXMgbm90IGd1YXJhbnRlZWQgdG8gYmUgbGVzcyB0aGFuIGxhc3RfbHNuIGJlZm9yZQ0KPiB3ZSBz
dGFydCB3YWxraW5nIGl0Lg0KDQpPSywgZ290IGl0Lg0KDQo+IA0KPj4gRm9yIHRoZSBwcm9ibGVt
IHdpdGggeGxvZ19yZWNvdmVyX3Byb2Nlc3NfaW50ZW50cygpLCBwbGVhc2Ugc2VlIG15IHJlcGx5
IHRvDQo+PiBEYXJyaWNrLiBPbiBzZWVpbmcgdGhlIHByb2JsZW0sIG15IGZpcnN0IHRyeSB3YXMg
dG8gdXNlIOKAnGxhc3RfbHNu4oCdIHRvIHN0b3ANCj4+IHRoZSBpdGVyYXRpb24gYnV0IHRoYXQg
ZGlkbuKAmXQgaGVscC4gIGxhc3RfbHNuIHdhcyBmb3VuZCBxdWl0ZSBiaWdnZXIgdGhhbiBldmVu
DQo+PiB0aGUgbmV3IEVGSSBsc24uIFdoaWxlIHVzZSB4ZnNfYWlsX21heF9sc24oKSBpdCBzb2x2
ZWQgdGhlIHByb2JsZW0uDQo+IA0KPiBJbiB3aGF0IGNhc2UgYXJlIHdlIHF1ZXVpbmcgYSAqbmV3
KiBpbnRlbnQgaW50byB0aGUgQUlMIHRoYXQgaGFzIGENCj4gTFNOIGxlc3MgdGhhbiB4bG9nX2Fz
c2lnbl9sc24obG9nLT5sX2N1cnJfY3ljbGUsIGxvZy0+bF9jdXJyX2Jsb2NrKT8NCj4gSWYgd2Ug
YXJlIGRvaW5nIHRoYXQgKmFueXdoZXJlKiwgdGhlbiB3ZSBoYXZlIGEgbGlrZWx5IGpvdXJuYWwN
Cj4gY29ycnVwdGlvbiBidWcgaW4gdGhlIGNvZGUgYmVjYXVzZSBpdCBpbmRpY2F0ZXMgd2UgY29t
bWl0dGVkIHRoYXQNCj4gaXRlbSB0byB0aGUgam91cm5hbCBvdmVyIHNvbWV0aGluZyBpbiB0aGUg
bG9nIHdlIGFyZSBjdXJyZW50bHkNCj4gcmVwbGF5aW5nLg0KDQpJIG1hZGUgYSBtaXN0YWtlIHRv
IHNheSBsYXN0X2xzbiBpcyBxdWl0ZSBiaWdnZXIgdGhhbiB0aGUgbmV3IEVGSSBsc24sDQppdOKA
mXMgYWN0dWFsbHkgbXVjaCBiaWdnZXIgdGhhbiB0aGUgbWF4X2xzbiAoYmVjYXVzZSBjeWNsZSBp
bmNyZWFzZWQpLg0KVGhlIGxzbiBvZiB0aGUgbmV3IEVGSSBpcyBleGFjdGx5IHNhbWUgYXMgbGFz
dF9sc24uDQoNCj4gDQo+Pj4gSW4gdGhpcyBjYXNlLCB3ZSBjYW4ndCB1c2UgaW4tbWVtb3J5IHN0
YXRlIHRvIGRldGVybWluZSB3aGVyZSB0bw0KPj4+IHN0b3AgdGhlIGluaXRpYWwgaW50ZW50IHJl
cGxheSAtIHJlY292ZXJ5IG9mIG90aGVyIGl0ZW1zIG1heSBoYXZlDQo+Pj4gaW5zZXJ0ZWQgbmV3
IGludGVudHMgYmV5b25kIHRoZSBlbmQgb2YgdGhlIHBoeXNpY2FsIHJlZ2lvbiBiZWluZw0KPj4+
IHJlY292ZXJlZCwgaW4gd2hpY2ggY2FzZSB1c2luZyB4ZnNfYWlsX21heF9sc24oKSB3aWxsIHJl
c3VsdCBpbg0KPj4+IGluY29ycmVjdCBiZWhhdmlvdXIgaGVyZS4NCj4+IA0KPj4gWWVzLCB0aGlz
IHBhdGNoIGlzIG9uZSBvZiB0aG9zZSAoaWYgc29tZSBleGlzdCkgaW50cm9kdWNlIG5ldyBpbnRl
bnRzIChFRklzIGhlcmUpLg0KPj4gV2UgYWRkIHRoZSBuZXcgaW50ZW50cyB0byB0aGUgdHJhbnNh
Y3Rpb24gZmlyc3QgKHhmc19kZWZlcl9jcmVhdGVfaW50ZW50KCkpLCBhZGQNCj4+IHRoZSBkZWZl
cnJlZCBvcGVyYXRpb25zIHRvIOKAmGNhcHR1cmVfbGlzdOKAmS4gQW5kIGZpbmFsbHkgdGhlIGRl
ZmVycmVkIG9wdGlvbnMgaW4NCj4+IOKAmGNhcHR1cmVfbGlzdOKAmSBpcyBwcm9jZXNzZWQgYWZ0
ZXIgdGhlIGludGVudC1pdGVyYXRpb24gb24gdGhlIEFJTC4NCj4gDQo+IFRoZSBjaGFuZ2VzIG1h
ZGUgaW4gdGhhdCB0cmFuc2FjdGlvbiwgaW5jbHVkaW5nIHRoZSBuZXdseSBsb2dnZWQNCj4gRUZJ
LCBnZXQgY29tbWl0dGVkIGJlZm9yZSB0aGUgcmVzdCBvZiB0aGUgd29yayBnZXRzIGRlZmVycmVk
IHZpYQ0KPiB4ZnNfZGVmZXJfb3BzX2NhcHR1cmVfYW5kX2NvbW1pdCgpLiBUaGF0IGNvbW1pdHMg
dGhlIG5ldyBlZmkgKGFsb25nDQo+IHdpdGggYWxsIHRoZSBjaGFuZ2VzIHRoYXQgaGF2ZSBhbHJl
YWR5IGJlZW4gbWFkZSBpbiB0aGUgdHJhbnNhY3Rpb24pDQo+IHRvIHRoZSBDSUwsIGFuZCBldmVu
dHVhbGx5IHRoZSBqb3VybmFsIGNoZWNrcG9pbnRzIGFuZCB0aGUgbmV3IEVGSQ0KPiBnZXRzIGlu
c2VydGVkIGludG8gdGhlIEFJTCBhdCB0aGUgTFNOIG9mIHRoZSBjaGVja3BvaW50Lg0KPiANCj4g
VGhlIExTTiBvZiB0aGUgY2hlY2twb2ludCBpcyBjdXJyX2N5Y2xlL2Jsb2NrIC0gdGhlIGxvZyBo
ZWFkIC0NCj4gYmVjYXVzZSB0aGF0J3Mgd2hlcmUgdGhlIHN0YXJ0IHJlY29yZCBvZiB0aGUgY2hl
Y2twb2ludCBpcw0KPiBwaHlzaWNhbGx5IHdyaXR0ZW4uICBBcyBlYWNoIGljbG9nIGlzIGZpbGxl
ZCwgdGhlIGxvZyBoZWFkIG1vdmVzDQo+IGZvcndhcmQgLSBpdCBhbHdheXMgcG9pbnRzIGF0IHRo
ZSBsb2NhdGlvbiB0aGF0IHRoZSBuZXh0IGpvdXJuYWwNCj4gd3JpdGUgd2lsbCBiZSB3cml0dGVu
IHRvLiBBdCB0aGUgZW5kIG9mIGEgY2hlY2twb2ludCwgdGhlIExTTiBvZiB0aGUNCj4gc3RhcnQg
cmVjb3JkIGlzIHVzZWQgZm9yIEFJTCBpbnNlcnRpb24uDQo+IA0KDQpUaGFua3MgZm9yIGV4cGxh
bmF0aW9uIQ0KDQo+IEhlbmNlIGlmIGEgbmV3IGxvZyBpdGVtIGNyZWF0ZWQgYnkgcmVjb3Zlcnkg
aGFzIGEgTFNOIGxlc3MgdGhhbg0KPiBsYXN0X2xzbiwgdGhlbiB3ZSBoYXZlIGEgc2VyaW91cyBi
dWcgc29tZXdoZXJlIHRoYXQgbmVlZHMgdG8gYmUNCj4gZm91bmQgYW5kIGZpeGVkLiBUaGUgdXNl
IG9mIGxhc3RfbHNuIHRlbGxzIHVzIHNvbWV0aGluZyBoYXMgZ29uZQ0KPiBiYWRseSB3cm9uZyBk
dXJpbmcgcmVjb3ZlcnksIHRoZSB1c2Ugb2YgeGZzX2FpbF9tYXhfbHNuKCkgcmVtb3Zlcw0KPiB0
aGUgZGV0ZWN0aW9uIG9mIHRoZSBpc3N1ZSBhbmQgbm93IHdlIGRvbid0IGtub3cgdGhhdCBzb21l
dGhpbmcgaGFzDQo+IGdvbmUgYmFkbHkgd3JvbmcuLi4NCj4gDQoNCkkgbWFkZSBhIG1pc3Rha2Uu
LiB0aGUgKGZpcnN0KSBuZXcgRUZJIGxzbiBpcyB0aGUgc2FtZSBhcyBsYXN0X2xzbiwgc29ycnkN
CmZvciBjb25mdXNpbmcuDQoNCj4+IEZvciBleGlzdGluZyBvdGhlciBjYXNlcyAoaWYgdGhlcmUg
YXJlKSB3aGVyZSBuZXcgaW50ZW50cyBhcmUgYWRkZWQsDQo+PiB0aGV5IGRvbuKAmXQgdXNlIHRo
ZSBjYXB0dXJlX2xpc3QgZm9yIGRlbGF5ZWQgb3BlcmF0aW9ucz8gRG8geW91IGhhdmUgZXhhbXBs
ZSB0aGVuPyANCj4+IGlmIHNvIEkgdGhpbmsgd2Ugc2hvdWxkIGZvbGxvdyB0aGVpciB3YXkgaW5z
dGVhZCBvZiBhZGRpbmcgdGhlIGRlZmVyIG9wZXJhdGlvbnMNCj4+IChidXQgcmVwbHkgb24gdGhl
IGludGVudHMgb24gQUlMKS4NCj4gDQo+IEFsbCBvZiB0aGUgaW50ZW50IHJlY292ZXJ5IHN0dWZm
IHVzZXMNCj4geGZzX2RlZmVyX29wc19jYXB0dXJlX2FuZF9jb21taXQoKSB0byBjb21taXQgdGhl
IGludGVudCBiZWluZw0KPiByZXBsYXllZCBhbmQgY2F1c2UgYWxsIGZ1cnRoZXIgbmV3IGludGVu
dCBwcm9jZXNzaW5nIGluIHRoYXQgY2hhaW4NCj4gdG8gYmUgZGVmZXJlZCB1bnRpbCBhZnRlciBh
bGwgdGhlIGludGVudHMgcmVjb3ZlcmVkIGZyb20gdGhlIGpvdXJuYWwNCj4gaGF2ZSBiZWVuIGl0
ZXJhdGVkLiBBbGwgdGhvc2UgbmV3IGludGVudHMgZW5kIHVwIGluIHRoZSBBSUwgYXQgYSBMU04N
Cj4gaW5kZXggPj0gbGFzdF9sc24uDQoNClllcy4gU28gd2UgYnJlYWsgdGhlIEFJTCBpdGVyYXRp
b24gb24gc2VlaW5nIGFuIGludGVudCB3aXRoIGxzbiBlcXVhbCB0bw0Kb3IgYmlnZ2VyIHRoYW4g
bGFzdF9sc24gYW5kIHNraXAgdGhlIGlvcF9yZWNvdmVyKCkgZm9yIHRoYXQgaXRlbT8NCmFuZCBz
aGFsbCB3ZSBwdXQgdGhpcyBjaGFuZ2UgdG8gYW5vdGhlciBzZXBhcmF0ZWQgcGF0Y2ggYXMgaXQg
aXMgdG8gZml4DQphbiBleGlzdGluZyBwcm9ibGVtIChub3QgaW50cm9kdWNlZCBieSBteSBwYXRj
aCk/DQoNCnRoYW5rcywNCndlbmdhbmc=
