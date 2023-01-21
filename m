Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9246763F7
	for <lists+linux-xfs@lfdr.de>; Sat, 21 Jan 2023 06:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjAUFQn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 21 Jan 2023 00:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjAUFQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2023 00:16:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD90E10C7
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2023 21:16:40 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30L5GOxE006566;
        Sat, 21 Jan 2023 05:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=/Zx4xe2gBjJMXrEuo9XSvzN6O5+W8/w1TMqGcm8NzJA=;
 b=I3frIQqI/nO8PDIBXfzqxIpAkX60SgSLzfapq8Gzw6kT1zOPvzGrQbUWochW5jStQKoS
 Oy0jtjZo2Y0EwgAQHZVFc9Kf9yIhpph9ThwJ7N6IEJFbO1IIjXKNGnTjOhjQiL6wT/MP
 Ui5CwL7J9Ox1gAKhKmG28VICTS533XSpTeLiyFB5GMRxWqhd1Et4pIgFsud90PI182cp
 E8P2Kwzob9OW76Yt7yYb4g0ipSzqSx2aql5GB3aRAAIrM63Yjbuuc5nmY48snbO19e+x
 w5YwzxlVP47bsI3o2WdSI+4pkPapvE05LebUc/HQeJvqemt3vjCWYYztOzbzJW/fc0hN Kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt03wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Jan 2023 05:16:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30L1X0VY034044;
        Sat, 21 Jan 2023 05:16:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g1km0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Jan 2023 05:16:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZ8vX11dR7lW7D3zMIiBtUggGcAtFpA1iFFIWmLkJ0pINtzX+jbNGZPH5LTHOr8iB9kg9N8umaVIbT9riJCf9op7ngXojOwYjOTK+7S3joR1p6YqLZ+gGwjb9z/1KLZiWDA08SkyZ9doC41O9RHp8QZrIhJE/weeQpwOkx3Y7y7p/kMC2mvaV6hEBhpAa4Je4qf52fHHahumfJwCLhuth5ix7FNnQInMRyKmXigYeXXw7xvUm4Hmmj/P3qR3/IdBoBH8QRvipwAeUZcEiKj7IRQhQaed95FJzupdFqmPZO+e3U94tnBJpSW/tkWqt7oEtWtAuO/0tkzqgdtNjEC/Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Zx4xe2gBjJMXrEuo9XSvzN6O5+W8/w1TMqGcm8NzJA=;
 b=Xegg575EavkKiqed2cOxMgILtqoTCavk0AotReOXSSCUZLp05iWersABbVmxef35aIslTKL5AMYnmaPoJx2EAHY59WciN/k0VE7yfS9YFKcvrfIrGllsL/XAcrEUwEDud8cqjNbS5Wun4HzeSOpqe13tBRb9Niyr5XYJno2hqXYT6IwOoRiXof20YNJQ1J2IqYl5XU6ImqrEVipO722+jCG0UNXMAmhMQ3PDGLTGRSmJ8fXI2po0RU1EgL8DYRpV1OoyA9E5ItIdwtg3s6+pxyXEFpA1qs7Kp1dyEmlyyHglwJHA1wXrib8xnFzNQk3HbuMyEAqXCWoz8m1/3xuTdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Zx4xe2gBjJMXrEuo9XSvzN6O5+W8/w1TMqGcm8NzJA=;
 b=ihtj/R7Pv0VxEQNkEjfeuEXe3XFuhTVEbufS3QK2pA3T9riAa/UsqrClWLdgvlT6VE96lJJz1XWknZp3PoK9wlGL5fKdz79QmUy0hjLr/T+9uP52G7neZw/kn0zcodKbc7jVBxPLMKBfm6miwM/o9IjBPUEMKbQdMG9qUNkXk/Y=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5561.namprd10.prod.outlook.com (2603:10b6:510:f0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Sat, 21 Jan
 2023 05:16:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%5]) with mapi id 15.20.6043.007; Sat, 21 Jan 2023
 05:16:36 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 08/42] xfs: rework the perag trace points to be perag
 centric
Thread-Topic: [PATCH 08/42] xfs: rework the perag trace points to be perag
 centric
Thread-Index: AQHZK46SihnwUwG7pEqZT5UkLJxw3q6oV/KA
Date:   Sat, 21 Jan 2023 05:16:36 +0000
Message-ID: <20e61d715da9b8b5352bc29ab7298babe9e8fea3.camel@oracle.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
         <20230118224505.1964941-9-david@fromorbit.com>
In-Reply-To: <20230118224505.1964941-9-david@fromorbit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|PH0PR10MB5561:EE_
x-ms-office365-filtering-correlation-id: 366390c3-ea18-4e30-5d5e-08dafb6eab13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +ERmemLJ3NznoNwVHHFiQ6ZNul+QhFa58Yp9U5+6axZKuO22wqTC594hXHh97ictNILRz22JrBqsMH4myw6wAfc51gias9jBZS+TGqP4b17/pxOYnvkYQd9sIkuz8Du2CrU36A+RDElALd4GxTcWL5phY+48ScmgpnbA18Wl+STODIGIlBrwZkQa0tNeomp7w6Zp5pap+BmnfD/fwVJmiqzRfmNMSwEOpJ+zhvhNaDAtJ5nbM1dXJkLamX4rTxFHafLvkRg3MqBZPtS8b/KoA2YCizZXQxKqZFBE5E/q50I9n46eby9npTD7uA9sNwu6bBqz52oS0K4GG5HFWf74+WfEB5gFMcozQjCj2bpVlFJCZjZoQZ6F5tuPgJ3yq9vKHPe+zbvFBqzM6zoFMKOISHQJffX9NpsCILPit++IQ4QzIyZtg6bEu5BRoHZ0sljy9ji3ZecI+AIuuTk3tkaFE8TtL/djRnNXeMuktXZP4QOL403dCfjSz/7KhqN1crLxrZ4T5cqpWoTxMuTJnJnORnHpJmNqvaMLMTak3nK+XOFyzM9Ac1BdMhbKXAE+itOhta+Q7MB+fqN9NEeIHpudxnNvkjK58f6vcME36WC9+D8jMY+uvqDvhxox5JGiMfmRYTDAua3d4maywLdnoKLTLOHn8emH331lUAp4r2B0LlR+fQs9milk6hWQUfcLbhJafgGoFoSKn3wz99A6jm4MoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(38070700005)(122000001)(38100700002)(26005)(66446008)(86362001)(66946007)(66476007)(64756008)(76116006)(66556008)(8676002)(41300700001)(110136005)(316002)(44832011)(2906002)(5660300002)(83380400001)(8936002)(2616005)(478600001)(71200400001)(6486002)(6512007)(186003)(6506007)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3VzS2IxSGNYcUJFWVBmY013Rlc1SlBTN0FvYmNFclkvcXR3TWczNVVQYzkx?=
 =?utf-8?B?UFNJMGZEbDh6VTNqZ0pvMlhZVWlhR2ZSOUhqb09LUzRaWkNtTlN4WlF1b3Nu?=
 =?utf-8?B?Tm5IcDk2eE5xU2FWU0lzbFhEMUMxNEFaS2lJZTRvcUxLN3I3N1BPVWVvUThY?=
 =?utf-8?B?WFJOdzhxTXFFM3haNzNhQm9aWHJ0L3huMWlybDZuTFUyVUFGMmJWOFpqbzNY?=
 =?utf-8?B?bktrVHJOWGFLaFZOOTFteWUzYzVSMWlGRmJFaEltNWM5R01jTFZFamszRjBX?=
 =?utf-8?B?V2ZtYmxnM1JHZjNxL000elJtdG1tcDl2R0RKUXU2V240UDhuSXBzK3JVV3BF?=
 =?utf-8?B?U2FMRVhleEhBWVBXY0hkZXczU2dOeTM1K1VZYTNVanRwa1RqQWduMWdkSkdC?=
 =?utf-8?B?N0xDOW5FRlFtclIzQXdlcVJrNkFGbkM4TkNtSXdqcDR3MWZmdzJMWUtBRWdS?=
 =?utf-8?B?MlRkR3hEVDlkTnV0M0oyM0lMUHVTOUU2WFdZa3ZIcVMrUm9ad3BwWDY3RWt6?=
 =?utf-8?B?SWp2T3RCME1LK1MweWlhbyt2Q1ErUWxreWRnbjQ1NlBkMUl5NmVOSVBlS01n?=
 =?utf-8?B?OFhNTEtoZURhQ0dJRUN6M1ZhamdTUkNNSUJUS0V4UHcyTjJzOXB0VWFrTWs1?=
 =?utf-8?B?ZmozUGJ3WE00OFpyVHd6bjQvRlh5TWF6UVRPT3E1UkpWOXQ2U1ZUd2ozeUhu?=
 =?utf-8?B?T2dBcFc1M0lYemVzYUxNSU9vcG14UXRRQk5xYW5RL1llTXNQN3lmeGhPR2hS?=
 =?utf-8?B?aGRFZ05TZlZsdHVPblZyMDI3cUI0RFJ1UTI1V1pCTUpxYmdnNUJQNnlFUk1X?=
 =?utf-8?B?cHNzVDlmY1Q3cVhDWXJNU0ZYZExpN3p4S0F2cEpjaG1OeWdYVTg2RmUraVMr?=
 =?utf-8?B?SmhkczZHYTZZeVUwVlRZbGUyVnExQUw4TjJGSjdvSEs2MXpJVnc3REx0emxF?=
 =?utf-8?B?eDdXWEdMTlM2ZGlqRVVWMzE3Nk81RGZ6dW5DRkNpdVdaOHlhV0hldFpjL2lk?=
 =?utf-8?B?TjZCb1k2QXpQN2JMSFpSRlloUmMyeWp2OXh1RFd5dlBEVzRSQTdkRndoWGFj?=
 =?utf-8?B?eXphcFhBaWhCcTRzR2hpc3FTaFdFdG1SQkJRTUN6ZkpYNFY0SE9CdDZ2NWZv?=
 =?utf-8?B?WTAxVS94TFdzMWEyMXJCSHB3SnZ4WkdKemZjVjNwWUVXSzVkZlgwbm96Uk5z?=
 =?utf-8?B?ejNXbFFCcXJXOGF3RmRaSThEU3AxQXdPMmNRTWhhTjNSaG5JWHprNXdKbDVh?=
 =?utf-8?B?Q2ZMaFJndThoUVE3L2ZrRWNTcG1IYUFJSzJxakNkcTBpUjZvS2wvc1VSUFJq?=
 =?utf-8?B?bU1FZHdPTndzWU1TaHc3VVdzMW8vM05GRWdWUGVnTFdFRlowR2ltVHJQMW1M?=
 =?utf-8?B?UWJ0VWszM2QzT1pBVUxtcnREcEw3SlQyUXpkL2ZYUkdjU3F1Rzg4bUw0NTEx?=
 =?utf-8?B?UC9YbGF3R0h3YzBQQmJDcndCWUl5WHoya0pBUWpnTTdrckdCMkpyVi85ZUtr?=
 =?utf-8?B?Z3ViVFE2ZlVSNUJvTnljemVzdS9yM3VUS3NzK1RIMmFWM1VPaVJzN3ZTVjlB?=
 =?utf-8?B?NWlGTlA3MzRFQlRXczdBMUxlNmQwOE5HR1ZMNTVyWTBuY2gxTmFQNzF0WFcx?=
 =?utf-8?B?Z2N5dmNVclVaWHR3SW9ldk9iNmJoOEJYZ2FVWmdBdDMvaXYvQXJvTUtKOFhK?=
 =?utf-8?B?ZHJTcEp1MjJWbDhqa1EvVkpBSkVtVnY0aS8wUlpoNTlYSDk4ckVENldpVzY1?=
 =?utf-8?B?L3JibDlqZzFScWFSclFNSHdGdXoyMWpnR2tTeldlaXAwalJXNUpyUjBTYkJG?=
 =?utf-8?B?S0ZFZFdXbFNnUm1zbm9YRk9TMkppQi9RNGRtUzhRc3d2bzFBdnFVWDJ0Sk9P?=
 =?utf-8?B?R3BHVXdXWVBJcWJnZ0t6VXpBenY1Q1J1R1prM3I3dnkzaEc5SnRDVlJFakRU?=
 =?utf-8?B?SHExN3A5clBWNEM3VnpBb2gyMktYTldqTENxZGZQaDZ0Zm1yd2pPUWQ0RkV4?=
 =?utf-8?B?Yk9GREVtdktLTFVCVmE3cEJBbTNpeUtBY1JoWkJuN055K1lSbTNaaHJEUkZI?=
 =?utf-8?B?TGFaMnFhQWtwQjVXZWwzSXl1VHN1UDVYTTdoZWMrYWNic1Zza3dOWFNpZHph?=
 =?utf-8?B?ZzRjUW5WdllMUmJMWmdCTmgrdlRORDFvSFlsZWZtdWtSM2VBNnhHVXM5N0dE?=
 =?utf-8?Q?q6/jMrZaf5Ml1X5DAWTE+6Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA05577A98BF51489FD4DB4B4BB634B3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ouSWtVR+gbargZLUIqRmp3izEMtHxCTe2SMaR5iqe1r7hWvJxBg6NX86RUhVPv4gMsB6AMk5nCsma6Pt7dRwL5t2Ot6FZe65agFXJSVj1f9CuU5UhLNoIL0Q1fXahPO/ZGpIxiikAl5mOhpZSJy36Jd9gHz1LZLW6zX4mEnpCY0sqfKLW00FJCGs/lHjSEwMoRGw5tDlw8e5MNhpy4stgryY9V10dzdK5azE5QQm80H6rriziTRZlpOnjEIyH9WwaAY0MLQAYuIq6DQ80mOW1SIF6AK7aEb2g+ytw3s9Clsf83O/Y2HdwDftRdCgXisbNQtZsSTLawm+c7N/Czek+YtxCvtzQ4ELebNfflFW4YyoF1Di489Ko418KGdkfcQUYeHsJzqrszFfK5txHml/rfMB4LAf1ZrlgnjJWyL3PCu6MLHAMEB2hXSlSp84ur/7SnhWmnmGNYjzqRBnBv/ROjPR0sTP01iPbeM/T4IdQJtkylwU/s1RjOxp2ih0rZFgPYaOWOpeTtF5/bwRwiG77+U8y3vLW/Sayusv2A76k8N/qTOts9OikhT8j3SbaZws+At+dDgXX3kyxtol9JgCqztSHTsZU02ajbaG6A7ssR5zP+e+AQIoF1xQtnmw4W5k7rggsmXKXimOMoWfPgCG6Al0Hf6a2G5C/3SY7/W8An95zCRHRfihLauua2zCuzd8lqsuy+BCdPEdmNQ+J//UJ+/SPzJY4TSD0XKLKCQCfnr61mcvTdiKojlT1ofxyYpZtyaHVmlbbvMa9nQvus9wIbYu3xW4V78n8V9Gjk5sB2w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 366390c3-ea18-4e30-5d5e-08dafb6eab13
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2023 05:16:36.1181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TdlkKiqOtRMt512GT+ttii/G0OObXUPCs1tMfIb/zgvptGSDb2LK0XUbPVKHuFn+WzXVLkNY6c+J5PdlFppvklzjMPQ7YC0bMURWfY4dYfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-21_01,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301210049
X-Proofpoint-ORIG-GUID: KCpIqH6O3oLuT3VBgxrnNBFLqpr_z2LF
X-Proofpoint-GUID: KCpIqH6O3oLuT3VBgxrnNBFLqpr_z2LF
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
RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+IFNvIHRoYXQgdGhl
eSBhbGwgb3V0cHV0IHRoZSBzYW1lIGluZm9ybWF0aW9uIGluIHRoZSB0cmFjZXMgdG8gbWFrZQo+
IGRlYnVnZ2luZyByZWZjb3VudCBpc3N1ZXMgZWFzaWVyLgo+IAo+IFRoaXMgbWVhbnMgdGhhdCBh
bGwgdGhlIGxvb2t1cC9kcm9wIGZ1bmN0aW9ucyBubyBsb25nZXIgbmVlZCB0byB1c2UKPiB0aGUg
ZnVsbCBtZW1vcnkgYmFycmllciBhdG9taWMgb3BlcmF0aW9ucyAoYXRvbWljKl9yZXR1cm4oKSkg
c28KPiB3aWxsIGhhdmUgbGVzcyBvdmVyaGVhZCB3aGVuIHRyYWNpbmcgaXMgb2ZmLiBUaGUgc2V0
L2NsZWFyIHRhZwo+IHRyYWNlcG9pbnRzIG5vIGxvbmdlciBhYnVzZSB0aGUgcmVmZXJlbmNlIGNv
dW50IHRvIHBhc3MgdGhlIHRhZyAtCj4gdGhlIHRhZyBiZWluZyBjbGVhcmVkIGlzIG9idmlvdXMg
ZnJvbSB0aGUgX1JFVF9JUF8gdGhhdCBpcyByZWNvcmRlZAo+IGluIHRoZSB0cmFjZSBwb2ludC4K
PiAKPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIENoaW5uZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+Ck9r
LCBtYWtlcyBzZW5zZQpSZXZpZXdlZC1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVu
ZGVyc29uQG9yYWNsZS5jb20+Cgo+IMKgZnMveGZzL2xpYnhmcy94ZnNfYWcuYyB8IDI1ICsrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0KPiDCoGZzL3hmcy94ZnNfaWNhY2hlLmPCoMKgwqAgfMKgIDQg
KystLQo+IMKgZnMveGZzL3hmc190cmFjZS5owqDCoMKgwqAgfCAyMSArKysrKysrKysrKy0tLS0t
LS0tLS0KPiDCoDMgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25z
KC0pCj4gCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9saWJ4ZnMveGZzX2FnLmMgYi9mcy94ZnMvbGli
eGZzL3hmc19hZy5jCj4gaW5kZXggNDZlMjVjNjgyYmY0Li43Y2ZmNjE4NzUzNDAgMTAwNjQ0Cj4g
LS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfYWcuYwo+ICsrKyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2Fn
LmMKPiBAQCAtNDQsMTYgKzQ0LDE1IEBAIHhmc19wZXJhZ19nZXQoCj4gwqDCoMKgwqDCoMKgwqDC
oHhmc19hZ251bWJlcl90wqDCoMKgwqDCoMKgwqDCoMKgwqBhZ25vKQo+IMKgewo+IMKgwqDCoMKg
wqDCoMKgwqBzdHJ1Y3QgeGZzX3BlcmFnwqDCoMKgwqDCoMKgwqDCoCpwYWc7Cj4gLcKgwqDCoMKg
wqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVmID0g
MDsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqByY3VfcmVhZF9sb2NrKCk7Cj4gwqDCoMKgwqDCoMKg
wqDCoHBhZyA9IHJhZGl4X3RyZWVfbG9va3VwKCZtcC0+bV9wZXJhZ190cmVlLCBhZ25vKTsKPiDC
oMKgwqDCoMKgwqDCoMKgaWYgKHBhZykgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB0cmFjZV94ZnNfcGVyYWdfZ2V0KHBhZywgX1JFVF9JUF8pOwo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgQVNTRVJUKGF0b21pY19yZWFkKCZwYWctPnBhZ19yZWYpID49IDApOwo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZWYgPSBhdG9taWNfaW5jX3JldHVybigm
cGFnLT5wYWdfcmVmKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYXRvbWljX2lu
YygmcGFnLT5wYWdfcmVmKTsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKgwqDCoMKgwqDCoMKgwqBy
Y3VfcmVhZF91bmxvY2soKTsKPiAtwqDCoMKgwqDCoMKgwqB0cmFjZV94ZnNfcGVyYWdfZ2V0KG1w
LCBhZ25vLCByZWYsIF9SRVRfSVBfKTsKPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHBhZzsKPiDC
oH0KPiDCoAo+IEBAIC02OCw3ICs2Nyw2IEBAIHhmc19wZXJhZ19nZXRfdGFnKAo+IMKgewo+IMKg
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3BlcmFnwqDCoMKgwqDCoMKgwqDCoCpwYWc7Cj4gwqDC
oMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGZvdW5kOwo+IC3CoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJlZjsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqByY3VfcmVhZF9sb2NrKCk7
Cj4gwqDCoMKgwqDCoMKgwqDCoGZvdW5kID0gcmFkaXhfdHJlZV9nYW5nX2xvb2t1cF90YWcoJm1w
LT5tX3BlcmFnX3RyZWUsCj4gQEAgLTc3LDkgKzc1LDkgQEAgeGZzX3BlcmFnX2dldF90YWcoCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByY3VfcmVhZF91bmxvY2soKTsKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBOVUxMOwo+IMKgwqDCoMKgwqDCoMKg
wqB9Cj4gLcKgwqDCoMKgwqDCoMKgcmVmID0gYXRvbWljX2luY19yZXR1cm4oJnBhZy0+cGFnX3Jl
Zik7Cj4gK8KgwqDCoMKgwqDCoMKgdHJhY2VfeGZzX3BlcmFnX2dldF90YWcocGFnLCBfUkVUX0lQ
Xyk7Cj4gK8KgwqDCoMKgwqDCoMKgYXRvbWljX2luYygmcGFnLT5wYWdfcmVmKTsKPiDCoMKgwqDC
oMKgwqDCoMKgcmN1X3JlYWRfdW5sb2NrKCk7Cj4gLcKgwqDCoMKgwqDCoMKgdHJhY2VfeGZzX3Bl
cmFnX2dldF90YWcobXAsIHBhZy0+cGFnX2Fnbm8sIHJlZiwgX1JFVF9JUF8pOwo+IMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gcGFnOwo+IMKgfQo+IMKgCj4gQEAgLTg3LDExICs4NSw5IEBAIHZvaWQK
PiDCoHhmc19wZXJhZ19wdXQoCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfcGVyYWfCoMKg
wqDCoMKgwqDCoMKgKnBhZykKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgcmVm
Owo+IC0KPiArwqDCoMKgwqDCoMKgwqB0cmFjZV94ZnNfcGVyYWdfcHV0KHBhZywgX1JFVF9JUF8p
Owo+IMKgwqDCoMKgwqDCoMKgwqBBU1NFUlQoYXRvbWljX3JlYWQoJnBhZy0+cGFnX3JlZikgPiAw
KTsKPiAtwqDCoMKgwqDCoMKgwqByZWYgPSBhdG9taWNfZGVjX3JldHVybigmcGFnLT5wYWdfcmVm
KTsKPiAtwqDCoMKgwqDCoMKgwqB0cmFjZV94ZnNfcGVyYWdfcHV0KHBhZy0+cGFnX21vdW50LCBw
YWctPnBhZ19hZ25vLCByZWYsCj4gX1JFVF9JUF8pOwo+ICvCoMKgwqDCoMKgwqDCoGF0b21pY19k
ZWMoJnBhZy0+cGFnX3JlZik7Cj4gwqB9Cj4gwqAKPiDCoC8qCj4gQEAgLTExMCw4ICsxMDYsNyBA
QCB4ZnNfcGVyYWdfZ3JhYigKPiDCoMKgwqDCoMKgwqDCoMKgcmN1X3JlYWRfbG9jaygpOwo+IMKg
wqDCoMKgwqDCoMKgwqBwYWcgPSByYWRpeF90cmVlX2xvb2t1cCgmbXAtPm1fcGVyYWdfdHJlZSwg
YWdubyk7Cj4gwqDCoMKgwqDCoMKgwqDCoGlmIChwYWcpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgdHJhY2VfeGZzX3BlcmFnX2dyYWIobXAsIHBhZy0+cGFnX2Fnbm8sCj4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgYXRvbWljX3JlYWQoJnBhZy0+cGFnX2FjdGl2ZV9yZWYpLAo+IF9SRVRfSVBfKTsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdHJhY2VfeGZzX3BlcmFnX2dyYWIocGFnLCBfUkVU
X0lQXyk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIWF0b21pY19pbmNf
bm90X3plcm8oJnBhZy0+cGFnX2FjdGl2ZV9yZWYpKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhZyA9IE5VTEw7Cj4gwqDCoMKgwqDCoMKgwqDCoH0K
PiBAQCAtMTM4LDggKzEzMyw3IEBAIHhmc19wZXJhZ19ncmFiX3RhZygKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHJjdV9yZWFkX3VubG9jaygpOwo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuIE5VTEw7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiAtwqDCoMKg
wqDCoMKgwqB0cmFjZV94ZnNfcGVyYWdfZ3JhYl90YWcobXAsIHBhZy0+cGFnX2Fnbm8sCj4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBhdG9taWNfcmVhZCgm
cGFnLT5wYWdfYWN0aXZlX3JlZiksIF9SRVRfSVBfKTsKPiArwqDCoMKgwqDCoMKgwqB0cmFjZV94
ZnNfcGVyYWdfZ3JhYl90YWcocGFnLCBfUkVUX0lQXyk7Cj4gwqDCoMKgwqDCoMKgwqDCoGlmICgh
YXRvbWljX2luY19ub3RfemVybygmcGFnLT5wYWdfYWN0aXZlX3JlZikpCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBwYWcgPSBOVUxMOwo+IMKgwqDCoMKgwqDCoMKgwqByY3VfcmVh
ZF91bmxvY2soKTsKPiBAQCAtMTUwLDggKzE0NCw3IEBAIHZvaWQKPiDCoHhmc19wZXJhZ19yZWxl
KAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3BlcmFnwqDCoMKgwqDCoMKgwqDCoCpwYWcp
Cj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgdHJhY2VfeGZzX3BlcmFnX3JlbGUocGFnLT5wYWdfbW91
bnQsIHBhZy0+cGFnX2Fnbm8sCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBhdG9taWNfcmVhZCgmcGFnLT5wYWdfYWN0aXZlX3JlZiksIF9SRVRfSVBfKTsK
PiArwqDCoMKgwqDCoMKgwqB0cmFjZV94ZnNfcGVyYWdfcmVsZShwYWcsIF9SRVRfSVBfKTsKPiDC
oMKgwqDCoMKgwqDCoMKgaWYgKGF0b21pY19kZWNfYW5kX3Rlc3QoJnBhZy0+cGFnX2FjdGl2ZV9y
ZWYpKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgd2FrZV91cCgmcGFnLT5wYWdf
YWN0aXZlX3dxKTsKPiDCoH0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19pY2FjaGUuYyBiL2Zz
L3hmcy94ZnNfaWNhY2hlLmMKPiBpbmRleCAwZjRhMDE0ZGRlZDMuLjhiMjgyM2Q4NWE2OCAxMDA2
NDQKPiAtLS0gYS9mcy94ZnMveGZzX2ljYWNoZS5jCj4gKysrIGIvZnMveGZzL3hmc19pY2FjaGUu
Ywo+IEBAIC0yNTUsNyArMjU1LDcgQEAgeGZzX3BlcmFnX3NldF9pbm9kZV90YWcoCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBicmVhazsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKg
Cj4gLcKgwqDCoMKgwqDCoMKgdHJhY2VfeGZzX3BlcmFnX3NldF9pbm9kZV90YWcobXAsIHBhZy0+
cGFnX2Fnbm8sIHRhZywKPiBfUkVUX0lQXyk7Cj4gK8KgwqDCoMKgwqDCoMKgdHJhY2VfeGZzX3Bl
cmFnX3NldF9pbm9kZV90YWcocGFnLCBfUkVUX0lQXyk7Cj4gwqB9Cj4gwqAKPiDCoC8qIENsZWFy
IGEgdGFnIG9uIGJvdGggdGhlIEFHIGluY29yZSBpbm9kZSB0cmVlIGFuZCB0aGUgQUcgcmFkaXgK
PiB0cmVlLiAqLwo+IEBAIC0yODksNyArMjg5LDcgQEAgeGZzX3BlcmFnX2NsZWFyX2lub2RlX3Rh
ZygKPiDCoMKgwqDCoMKgwqDCoMKgcmFkaXhfdHJlZV90YWdfY2xlYXIoJm1wLT5tX3BlcmFnX3Ry
ZWUsIHBhZy0+cGFnX2Fnbm8sIHRhZyk7Cj4gwqDCoMKgwqDCoMKgwqDCoHNwaW5fdW5sb2NrKCZt
cC0+bV9wZXJhZ19sb2NrKTsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoHRyYWNlX3hmc19wZXJhZ19j
bGVhcl9pbm9kZV90YWcobXAsIHBhZy0+cGFnX2Fnbm8sIHRhZywKPiBfUkVUX0lQXyk7Cj4gK8Kg
wqDCoMKgwqDCoMKgdHJhY2VfeGZzX3BlcmFnX2NsZWFyX2lub2RlX3RhZyhwYWcsIF9SRVRfSVBf
KTsKPiDCoH0KPiDCoAo+IMKgLyoKPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc190cmFjZS5oIGIv
ZnMveGZzL3hmc190cmFjZS5oCj4gaW5kZXggZjBiNjIwNTRlYTY4Li5jOTIxZTlhNTI1NmQgMTAw
NjQ0Cj4gLS0tIGEvZnMveGZzL3hmc190cmFjZS5oCj4gKysrIGIvZnMveGZzL3hmc190cmFjZS5o
Cj4gQEAgLTE1OSwzMyArMTU5LDM0IEBAIFRSQUNFX0VWRU5UKHhsb2dfaW50ZW50X3JlY292ZXJ5
X2ZhaWxlZCwKPiDCoCk7Cj4gwqAKPiDCoERFQ0xBUkVfRVZFTlRfQ0xBU1MoeGZzX3BlcmFnX2Ns
YXNzLAo+IC3CoMKgwqDCoMKgwqDCoFRQX1BST1RPKHN0cnVjdCB4ZnNfbW91bnQgKm1wLCB4ZnNf
YWdudW1iZXJfdCBhZ25vLCBpbnQKPiByZWZjb3VudCwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgY2FsbGVyX2lwKSwKPiAtwqDCoMKgwqDCoMKgwqBUUF9B
UkdTKG1wLCBhZ25vLCByZWZjb3VudCwgY2FsbGVyX2lwKSwKPiArwqDCoMKgwqDCoMKgwqBUUF9Q
Uk9UTyhzdHJ1Y3QgeGZzX3BlcmFnICpwYWcsIHVuc2lnbmVkIGxvbmcgY2FsbGVyX2lwKSwKPiAr
wqDCoMKgwqDCoMKgwqBUUF9BUkdTKHBhZywgY2FsbGVyX2lwKSwKPiDCoMKgwqDCoMKgwqDCoMKg
VFBfU1RSVUNUX19lbnRyeSgKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9fZmll
bGQoZGV2X3QsIGRldikKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9fZmllbGQo
eGZzX2FnbnVtYmVyX3QsIGFnbm8pCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBf
X2ZpZWxkKGludCwgcmVmY291bnQpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9f
ZmllbGQoaW50LCBhY3RpdmVfcmVmY291bnQpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBfX2ZpZWxkKHVuc2lnbmVkIGxvbmcsIGNhbGxlcl9pcCkKPiDCoMKgwqDCoMKgwqDCoMKg
KSwKPiDCoMKgwqDCoMKgwqDCoMKgVFBfZmFzdF9hc3NpZ24oCj4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoF9fZW50cnktPmRldiA9IG1wLT5tX3N1cGVyLT5zX2RldjsKPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgX19lbnRyeS0+YWdubyA9IGFnbm87Cj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9fZW50cnktPnJlZmNvdW50ID0gcmVmY291bnQ7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9fZW50cnktPmRldiA9IHBhZy0+cGFnX21vdW50
LT5tX3N1cGVyLT5zX2RldjsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgX19lbnRy
eS0+YWdubyA9IHBhZy0+cGFnX2Fnbm87Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oF9fZW50cnktPnJlZmNvdW50ID0gYXRvbWljX3JlYWQoJnBhZy0+cGFnX3JlZik7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9fZW50cnktPmFjdGl2ZV9yZWZjb3VudCA9IGF0b21p
Y19yZWFkKCZwYWctCj4gPnBhZ19hY3RpdmVfcmVmKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoF9fZW50cnktPmNhbGxlcl9pcCA9IGNhbGxlcl9pcDsKPiDCoMKgwqDCoMKgwqDC
oMKgKSwKPiAtwqDCoMKgwqDCoMKgwqBUUF9wcmludGsoImRldiAlZDolZCBhZ25vIDB4JXggcmVm
Y291bnQgJWQgY2FsbGVyICVwUyIsCj4gK8KgwqDCoMKgwqDCoMKgVFBfcHJpbnRrKCJkZXYgJWQ6
JWQgYWdubyAweCV4IHBhc3NpdmUgcmVmcyAlZCBhY3RpdmUgcmVmcyAlZAo+IGNhbGxlciAlcFMi
LAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTUFKT1IoX19lbnRyeS0+ZGV2
KSwgTUlOT1IoX19lbnRyeS0+ZGV2KSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIF9fZW50cnktPmFnbm8sCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBf
X2VudHJ5LT5yZWZjb3VudCwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX19l
bnRyeS0+YWN0aXZlX3JlZmNvdW50LAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKGNoYXIgKilfX2VudHJ5LT5jYWxsZXJfaXApCj4gwqApOwo+IMKgCj4gwqAjZGVmaW5lIERF
RklORV9QRVJBR19SRUZfRVZFTlQobmFtZSnCoMKgwqBcCj4gwqBERUZJTkVfRVZFTlQoeGZzX3Bl
cmFnX2NsYXNzLCBuYW1lLMKgwqDCoMKgXAo+IC3CoMKgwqDCoMKgwqDCoFRQX1BST1RPKHN0cnVj
dCB4ZnNfbW91bnQgKm1wLCB4ZnNfYWdudW1iZXJfdCBhZ25vLCBpbnQKPiByZWZjb3VudCzCoMKg
wqDCoMKgwqDCoFwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxv
bmcKPiBjYWxsZXJfaXApLMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBcCj4gLcKgwqDCoMKgwqDCoMKgVFBf
QVJHUyhtcCwgYWdubywgcmVmY291bnQsIGNhbGxlcl9pcCkpCj4gK8KgwqDCoMKgwqDCoMKgVFBf
UFJPVE8oc3RydWN0IHhmc19wZXJhZyAqcGFnLCB1bnNpZ25lZCBsb25nIGNhbGxlcl9pcCksIFwK
PiArwqDCoMKgwqDCoMKgwqBUUF9BUkdTKHBhZywgY2FsbGVyX2lwKSkKPiDCoERFRklORV9QRVJB
R19SRUZfRVZFTlQoeGZzX3BlcmFnX2dldCk7Cj4gwqBERUZJTkVfUEVSQUdfUkVGX0VWRU5UKHhm
c19wZXJhZ19nZXRfdGFnKTsKPiDCoERFRklORV9QRVJBR19SRUZfRVZFTlQoeGZzX3BlcmFnX3B1
dCk7Cgo=
