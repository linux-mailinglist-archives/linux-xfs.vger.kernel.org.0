Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CE560D5EB
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Oct 2022 22:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiJYU4l (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Oct 2022 16:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJYU4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 16:56:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ACDB516F
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 13:56:39 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PKhva9019289;
        Tue, 25 Oct 2022 20:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Lg0HWiVX4ORjxuO3cjAVgDZztd9ZPxAdHLjHGfNLrOo=;
 b=u+ktbRY6tGnlyyEDSNJufCusvjWtmgXvCRS5NP2ekU1TTnmgvT/OPYKFNlwdBuAjwyx2
 wUDDDu2dWXeBxtKRoOQvEaLxdFHRVv9DSez096FSG4I6aWlCF4hXvr4lZZgIU2htcuxa
 thtRu2CWk4sutaghm2Hhki150mASCzrmU1H5MOxAT4iTYEkZxA3x+G/ANVJ/30h3vQc8
 HCMToJlXHZx1d2Lrt9Y+pc2LIY0cAIiWGzKOHgTnl3BdUMjLwoHt+nfxk9JwFMjLOY6l
 xH3nQDCAVpj7WZVHh3V9Xo1jv4XyjP+bCwLl8oY1f1lp7kZcXsHE7I5GbNIUFwJFxRT4 Pw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939dc77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:56:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PIj9RO017226;
        Tue, 25 Oct 2022 20:56:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y58ujg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 20:56:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeakaH4FBSKgxIEOkgMKQFO0p7V+VYBfTSRYOxAy5IAoK8j89q4xFk7FM+ynvVyE5sE0A1wr4xB1JCK758FhRn+sKZ5U5cR1Ls6LZMqLVyaf2IZBZF33mDJhciKAco5hgspvxD4bS4Te+GjYcoUxM4oCaoK22vzU6fX+vJi4in38p8ir5/zokcogW/c9ZgacOz3NEngTBHYKFgh9vbwr8wFPvZkdY6GcxRiNCxzdoZm5wOYJKtl3cURJI6yU9D2FUW8OkxPM+iXiq0+YbM+6bEduLVAWAeBn5BkrDqd1gWRiJdyxSuZDAFOIy9kclQoUJmwfwyICAqVhWSP3woAo6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lg0HWiVX4ORjxuO3cjAVgDZztd9ZPxAdHLjHGfNLrOo=;
 b=Ua5CFm1ObiF9ifj+mxS6rb82EJF7ko/tO38UdYK4zZaHCOhCGzjjIC1GWxortmGIwaYhBGUaROdRxUQmgvFLjJXzuSAeoJp15KEW4mkq+ztNER53ZqHqQMMh2c36wiKBp6XFckNRgAZy9HYS6fty4iYoiy9VHQpN5IMCdmoBvzFdFA3g65jqMiCLML4yu2TRYYRFz1cyITtD9xNVMwVQK4OmQY6QyQ6v37hca0pDXIxCVEfRFY3sdfvR0H9IYeWrrWoPpqW4ve1RZ3GT+gVFuDVM6sJUwCNHm3sWy+P92I2qX3WKgHEYtYgJ+agC9A+EnpYV9yj8bIm7DCLGvPTShA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lg0HWiVX4ORjxuO3cjAVgDZztd9ZPxAdHLjHGfNLrOo=;
 b=rD6XAX1B4x19sDF3617MAJVG0sHCE5ic/PNWaNHmN2vmLrI4GUuyo4mSvhhq7sEYz8ZAmMnr8AiYbZ2bhabxo6lX+0T5oDq9trJCBNV2dMWzQMXJbyUzHjjtKIzlqqFPnfmerpbuwr4Ge+YapaetWWyRjHbajfrpLV1ccn+Mtlo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW4PR10MB5884.namprd10.prod.outlook.com (2603:10b6:303:180::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.27; Tue, 25 Oct
 2022 20:56:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Tue, 25 Oct 2022
 20:56:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 6/6] xfs: refactor all the EFI/EFD log item sizeof logic
Thread-Topic: [PATCH 6/6] xfs: refactor all the EFI/EFD log item sizeof logic
Thread-Index: AQHY5/46dy9/Ys7tZUOb/l7jI+hmKq4fmIYA
Date:   Tue, 25 Oct 2022 20:56:31 +0000
Message-ID: <fe414a035c8cf9a7934d068a0190af2dee983fd5.camel@oracle.com>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
         <166664718541.2688790.5847203715269286943.stgit@magnolia>
In-Reply-To: <166664718541.2688790.5847203715269286943.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|MW4PR10MB5884:EE_
x-ms-office365-filtering-correlation-id: f78a6b2d-b16a-4515-a1a8-08dab6cb64da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cD4m+PV0nNT8wWy1E8A2CXiMYukVN1VRO9bu7nw/ADTa937fagrhUwma3WF1gXziECTfzpWG3YJ/tbJGI/2pwB7HFziqc2FQIDvmQ6UVzuptjCijSLR8tampZ0qD5/PY0chDnQhAYcLTWyrB0+8w7tc5nDFPvI7o/4XH2747DYpRFeW0utrlKP3eiNrTOPtowrzGQWqkrDUgJ7xrTmOv1qapzwTMeldOc2pU4N6/i6CjxpVgJk+OJirtHWsMLUP9ql5ffcxt1Zi645nxiP5aaSco3//161jkBQHF7IUg/qUSo+OjkX52rUHVHCbZBsjK9BvVUcgGoiXb3JhZ8Ap2FVIZ50lCcq0EsSTthVwR0En7nb1qxDdE9KFpgUvEyVzdEKABWmPv6NS5IPiTUq84TBieQjNHZLW17GQkb8GQqo4gZCQho8kM/GckJXZytoCA5R+iKWH9YNsPL+Krp2Fsd9HLZVCtzmvwxTHAl1mgGPkOjk0t8kDZj1LGqpyJjNSxZXsrWV7ywm2tJBXTAJB8qu+ByITrnoLEubOJSp87XEfcDbKY4+jYqh0g2q0SJ0IzBxbIvBm9o5VRp3HRL1Wh/OgJ1JuQj8px+c4TvySItHp5J6dS2d998UqnHx5IVhnaL+6oDjq5Jq3+oNCa90Z3cou8JChCs/+tas5eR7hVxNgCuhSObokMGbZ8SQK0DrdONvrptE5hRoDhLNaFC9SvDurtRtl71KbjL7bkV2VqF+2Lyi9FYlMinyCx3PkYKsniY8htZgPHnY7zzZ0Pbyw4fA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(36756003)(64756008)(76116006)(122000001)(8936002)(30864003)(44832011)(2906002)(5660300002)(38100700002)(38070700005)(83380400001)(86362001)(186003)(6512007)(26005)(6486002)(316002)(2616005)(54906003)(66946007)(478600001)(71200400001)(6916009)(4326008)(66476007)(41300700001)(8676002)(4001150100001)(66446008)(66556008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHc2TEdpRzY4QjlyYVpZenRXdUhxNFd2bHU3WkRhUEgrV2s5MGFmRW9ReVNX?=
 =?utf-8?B?aXRuYUdhYi9lYUVRdFR4OFJaeExwbnNNTWZXNzN5MVpkUVZFcGZ3blR1a0ow?=
 =?utf-8?B?SlNsc0JuaXA3N0VWR3VnRXBJMzA5SmMzRHZXRkJKYTBXV3hzR2puRkZEYklG?=
 =?utf-8?B?MlFGU1J6VlA0bFVTeGF6dnl1anp2M1RWOG5LSVlWckg1WTM4SGhLNUFaUVFG?=
 =?utf-8?B?R3p2a0tQODc1UTV4VWtrcDdpUUYrdDlmSk41R0Y3NEpEMVVtZGxTUUFZOHFu?=
 =?utf-8?B?S3h3K1pKNTNsSGZwTWF5K25LWTBZNFliZmVORGp0Q1Z0NS9najNvaXhmQkhM?=
 =?utf-8?B?K3JKWDdkMnVuSVB4SmoraEtTVDFOTlJQMFZ2Z0xSL1N1MW9wV1NxeVZGTmV0?=
 =?utf-8?B?bXV4UW10OWV1RDVFK3B6cEljR2lic1VMNUJwc2NndGVGYldBVEVrRlBNamVD?=
 =?utf-8?B?b0grdmtrOEl3MTdEb3RhZnpGd2YwUWhGTEFqUFpyZXFjK0lid0w3Y29UQmFD?=
 =?utf-8?B?eFM1TUhvTFk5U1BaOC9sblBNUUhJSXo5ZWJ6N1BuenNWbDZ6TXIzcXdMclZF?=
 =?utf-8?B?QmVWYjdPVmRvOUx1L0MrYWRWTW5LRVp4N25uVUI3SGZGUW0zMm95dzJ5TWti?=
 =?utf-8?B?cWhMVVI4OEtCdlM2eXI1UDBiTVRPQnFZWFp0UXI3MmRGbmhTbDZLSFNyZFNp?=
 =?utf-8?B?aElpZVk3R1JmSUFhY0M0STFMeFNBWDMyUVE2U0pOay9vTHE1eVBOdDB1Nnpk?=
 =?utf-8?B?S1lFcEo4SHJKNCtiWUZpYktxUTFRWHNNZVFXdVZoYURZVUJwd3JTZUp1RTE1?=
 =?utf-8?B?K3A0Mm1BOTJpMUNUQUpTUzc0TGlNSDhpVGc4eWprbjRva1hCODhNekNxNTBy?=
 =?utf-8?B?MVMyV1hCZC9DbTR1T2Z2MHVFU25MeVZ1aWtxK05iMkVMbVNRWUNpV2RydGxX?=
 =?utf-8?B?dks3OU5aeWp5K1ZXb0dVWGxFbElqSG5BL3E1dW1JVVhXb2hDL2kvT2tJUjB4?=
 =?utf-8?B?LzRsYjRLNmMrR1Q5Wmordm4xblFBUmo1eStEYUFvS1RSd2Z1NnU1MnVJREds?=
 =?utf-8?B?NmIyMHVZNjFiMDVUcVovOUN5eGFvTC9QK2NQcXcxY0s3MWZ6dE1YaS9vaUZm?=
 =?utf-8?B?eVozZUVSWHlWYU5ndWRNc3JaMVNvb2pHWS9KT29OSEFHR1N3TFppSnN6bTNt?=
 =?utf-8?B?ZHFDVHRoV3pDN0ErYTNLVFpMUUdMUmkrZ1U5K20xYktNNlo5ZUlYMVA1SW90?=
 =?utf-8?B?blFtMEFtUTg5RGs5eC9TcG0zK3pVUnVXTzBIS001WEJUSGU0UFF3ZGZZc0RW?=
 =?utf-8?B?TVRTbUdNd3A3Zyt3aWc5Wm9GakZxcUsyZytKa29YWXhBZ3hjYUc1MFJjMVNw?=
 =?utf-8?B?TnhJenhMUUZUREZ6TCt4T0hteWFhdStCWm40ajZsVFpOUmN0S3lCZFNQY3dY?=
 =?utf-8?B?U0s4Zm9QbjVYa3ZmS084emxhNlR5dzZQdFFuaGdselZsSmJSRWdQRFpwMHZk?=
 =?utf-8?B?TDBHMEVuMDd6dXBzM3oyazVDdUNaTk1Qek1TWGFKS3NvMk9DL25TSmpDVXRW?=
 =?utf-8?B?U0ZsME1IQVZBeHRtTGgzY3o0WlNpS3pod2c3ZUhKSXRUcGd0QVMxdElnZ25B?=
 =?utf-8?B?V3BhWTdqdEdTVitHcUUxcEUxYktRZTMydDZBdFBxTWlMUmJxUkdiR3BXemFu?=
 =?utf-8?B?RkV5RzlFc09lZlVlZmFTeWZlOGMwakkwbWhqOEhwN1V1V1c1VmJUeGVOdDB4?=
 =?utf-8?B?SUhzZGNQeTdEMWdXNk5vVktQMEV4c0pKT2UzSEhpanNPMEpySjhXZE81clNw?=
 =?utf-8?B?WURuR1U1K2JpcnNaVERsV2x5TkI2d3hyakNBWTFlVS9IOXp4Vjc2SmZETXRo?=
 =?utf-8?B?NFFWZ0RCRzJiOE5qQXdELzlyMjBaQjZHZFplalNGSTFjQkdMQ1RVZjl4a25l?=
 =?utf-8?B?a2E3WFIxa25peHBlbWI1WlFQWkxkeExsODBraWVXMmpGc2RmVC90cnJndW1k?=
 =?utf-8?B?OXJRcUcyS1B5MUZkbis3TjYvSk1FTWpCRkRWY2FJbXpTUWZDUk1QbVRjTUpz?=
 =?utf-8?B?ZjVVYjlFZE1LcTdIU2ltZHplNmVQUnRKMVh4R1V0UUtRckZoYTd5OWN3ejhF?=
 =?utf-8?B?eHZQOGtOajRyKzdtWDFqdXBQNlFFTzdkY3E4TC9wNWJiRTNNMElUNjVEb2hW?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D4DC9AA5717D949B2155A19304F36ED@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f78a6b2d-b16a-4515-a1a8-08dab6cb64da
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 20:56:31.2543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y9RJtmCLMefFiCb9mjVjSIK9CGLqaDGVQxw3ewczLJNHEAtS6R+DcCvAZJ91ktFhOKg/CkGLxzEpNkvvviKYl/rzNlbkHGb8oq7YYQj9m8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5884
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250117
X-Proofpoint-GUID: J4Wvz9a6qrcxZXlnYCZOrPdeasH1snaW
X-Proofpoint-ORIG-GUID: J4Wvz9a6qrcxZXlnYCZOrPdeasH1snaW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTI0IGF0IDE0OjMzIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gRnJvbTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KPiAKPiBSZWZhY3Rv
ciBhbGwgdGhlIG9wZW4tY29kZWQgc2l6ZW9mIGxvZ2ljIGZvciBFRkkvRUZEIGxvZyBpdGVtIGFu
ZCBsb2cKPiBmb3JtYXQgc3RydWN0dXJlcyBpbnRvIGNvbW1vbiBoZWxwZXIgZnVuY3Rpb25zIHdo
b3NlIG5hbWVzIHJlZmxlY3QKPiB0aGUKPiBzdHJ1Y3QgbmFtZXMuCj4gCj4gU2lnbmVkLW9mZi1i
eTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4KTG9va3Mgb2sgdG8gbWUKUmV2
aWV3ZWQtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29t
Pgo+IC0tLQo+IMKgZnMveGZzL2xpYnhmcy94ZnNfbG9nX2Zvcm1hdC5oIHzCoMKgIDQ4ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysKPiDCoGZzL3hmcy94ZnNfZXh0ZnJlZV9pdGVtLmPCoMKg
wqDCoMKgIHzCoMKgIDY5ICsrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQo+IC0tLS0tLS0t
LS0KPiDCoGZzL3hmcy94ZnNfZXh0ZnJlZV9pdGVtLmjCoMKgwqDCoMKgIHzCoMKgIDE2ICsrKysr
KysrKwo+IMKgZnMveGZzL3hmc19zdXBlci5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKg
IDEyICsrLS0tLS0KPiDCoDQgZmlsZXMgY2hhbmdlZCwgODggaW5zZXJ0aW9ucygrKSwgNTcgZGVs
ZXRpb25zKC0pCj4gCj4gCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9saWJ4ZnMveGZzX2xvZ19mb3Jt
YXQuaAo+IGIvZnMveGZzL2xpYnhmcy94ZnNfbG9nX2Zvcm1hdC5oCj4gaW5kZXggMmY0MWZhODQ3
N2M5Li5mMTNlMDgwOWRjNjMgMTAwNjQ0Cj4gLS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfbG9nX2Zv
cm1hdC5oCj4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNfbG9nX2Zvcm1hdC5oCj4gQEAgLTYxNiw2
ICs2MTYsMTQgQEAgdHlwZWRlZiBzdHJ1Y3QgeGZzX2VmaV9sb2dfZm9ybWF0IHsKPiDCoMKgwqDC
oMKgwqDCoMKgeGZzX2V4dGVudF90wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZWZpX2V4dGVudHNb
XTvCoMKgLyogYXJyYXkgb2YgZXh0ZW50cwo+IHRvIGZyZWUgKi8KPiDCoH0geGZzX2VmaV9sb2df
Zm9ybWF0X3Q7Cj4gwqAKPiArc3RhdGljIGlubGluZSBzaXplX3QKPiAreGZzX2VmaV9sb2dfZm9y
bWF0X3NpemVvZigKPiArwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnTCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBucikKPiArewo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBzaXplb2Yoc3RydWN0IHhm
c19lZmlfbG9nX2Zvcm1hdCkgKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgbnIgKiBzaXplb2Yoc3RydWN0IHhmc19leHRlbnQpOwo+ICt9Cj4gKwo+IMKg
dHlwZWRlZiBzdHJ1Y3QgeGZzX2VmaV9sb2dfZm9ybWF0XzMyIHsKPiDCoMKgwqDCoMKgwqDCoMKg
dWludDE2X3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVmaV90eXBlO8KgwqDCoMKg
wqDCoMKgLyogZWZpIGxvZyBpdGVtIHR5cGUKPiAqLwo+IMKgwqDCoMKgwqDCoMKgwqB1aW50MTZf
dMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZWZpX3NpemU7wqDCoMKgwqDCoMKgwqAv
KiBzaXplIG9mIHRoaXMgaXRlbQo+ICovCj4gQEAgLTYyNCw2ICs2MzIsMTQgQEAgdHlwZWRlZiBz
dHJ1Y3QgeGZzX2VmaV9sb2dfZm9ybWF0XzMyIHsKPiDCoMKgwqDCoMKgwqDCoMKgeGZzX2V4dGVu
dF8zMl90wqDCoMKgwqDCoMKgwqDCoMKgZWZpX2V4dGVudHNbXTvCoMKgLyogYXJyYXkgb2YgZXh0
ZW50cwo+IHRvIGZyZWUgKi8KPiDCoH0gX19hdHRyaWJ1dGVfXygocGFja2VkKSkgeGZzX2VmaV9s
b2dfZm9ybWF0XzMyX3Q7Cj4gwqAKPiArc3RhdGljIGlubGluZSBzaXplX3QKPiAreGZzX2VmaV9s
b2dfZm9ybWF0MzJfc2l6ZW9mKAo+ICvCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoG5yKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIHNpemVvZihz
dHJ1Y3QgeGZzX2VmaV9sb2dfZm9ybWF0XzMyKSArCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBuciAqIHNpemVvZihzdHJ1Y3QgeGZzX2V4dGVudF8zMik7
Cj4gK30KPiArCj4gwqB0eXBlZGVmIHN0cnVjdCB4ZnNfZWZpX2xvZ19mb3JtYXRfNjQgewo+IMKg
wqDCoMKgwqDCoMKgwqB1aW50MTZfdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZWZp
X3R5cGU7wqDCoMKgwqDCoMKgwqAvKiBlZmkgbG9nIGl0ZW0gdHlwZQo+ICovCj4gwqDCoMKgwqDC
oMKgwqDCoHVpbnQxNl90wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlZmlfc2l6ZTvC
oMKgwqDCoMKgwqDCoC8qIHNpemUgb2YgdGhpcyBpdGVtCj4gKi8KPiBAQCAtNjMyLDYgKzY0OCwx
NCBAQCB0eXBlZGVmIHN0cnVjdCB4ZnNfZWZpX2xvZ19mb3JtYXRfNjQgewo+IMKgwqDCoMKgwqDC
oMKgwqB4ZnNfZXh0ZW50XzY0X3TCoMKgwqDCoMKgwqDCoMKgwqBlZmlfZXh0ZW50c1tdO8KgwqAv
KiBhcnJheSBvZiBleHRlbnRzCj4gdG8gZnJlZSAqLwo+IMKgfSB4ZnNfZWZpX2xvZ19mb3JtYXRf
NjRfdDsKPiDCoAo+ICtzdGF0aWMgaW5saW5lIHNpemVfdAo+ICt4ZnNfZWZpX2xvZ19mb3JtYXQ2
NF9zaXplb2YoCj4gK8KgwqDCoMKgwqDCoMKgdW5zaWduZWQgaW50wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgbnIpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gc2l6ZW9mKHN0cnVjdCB4ZnNf
ZWZpX2xvZ19mb3JtYXRfNjQpICsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoG5yICogc2l6ZW9mKHN0cnVjdCB4ZnNfZXh0ZW50XzY0KTsKPiArfQo+ICsK
PiDCoC8qCj4gwqAgKiBUaGlzIGlzIHRoZSBzdHJ1Y3R1cmUgdXNlZCB0byBsYXkgb3V0IGFuIGVm
ZCBsb2cgaXRlbSBpbiB0aGUKPiDCoCAqIGxvZy7CoCBUaGUgZWZkX2V4dGVudHMgYXJyYXkgaXMg
YSB2YXJpYWJsZSBzaXplIGFycmF5IHdob3NlCj4gQEAgLTY0NSw2ICs2NjksMTQgQEAgdHlwZWRl
ZiBzdHJ1Y3QgeGZzX2VmZF9sb2dfZm9ybWF0IHsKPiDCoMKgwqDCoMKgwqDCoMKgeGZzX2V4dGVu
dF90wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZWZkX2V4dGVudHNbXTvCoMKgLyogYXJyYXkgb2Yg
ZXh0ZW50cwo+IGZyZWVkICovCj4gwqB9IHhmc19lZmRfbG9nX2Zvcm1hdF90Owo+IMKgCj4gK3N0
YXRpYyBpbmxpbmUgc2l6ZV90Cj4gK3hmc19lZmRfbG9nX2Zvcm1hdF9zaXplb2YoCj4gK8KgwqDC
oMKgwqDCoMKgdW5zaWduZWQgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbnIpCj4gK3sKPiAr
wqDCoMKgwqDCoMKgwqByZXR1cm4gc2l6ZW9mKHN0cnVjdCB4ZnNfZWZkX2xvZ19mb3JtYXQpICsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5yICogc2l6
ZW9mKHN0cnVjdCB4ZnNfZXh0ZW50KTsKPiArfQo+ICsKPiDCoHR5cGVkZWYgc3RydWN0IHhmc19l
ZmRfbG9nX2Zvcm1hdF8zMiB7Cj4gwqDCoMKgwqDCoMKgwqDCoHVpbnQxNl90wqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBlZmRfdHlwZTvCoMKgwqDCoMKgwqDCoC8qIGVmZCBsb2cgaXRl
bSB0eXBlCj4gKi8KPiDCoMKgwqDCoMKgwqDCoMKgdWludDE2X3TCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGVmZF9zaXplO8KgwqDCoMKgwqDCoMKgLyogc2l6ZSBvZiB0aGlzIGl0ZW0K
PiAqLwo+IEBAIC02NTMsNiArNjg1LDE0IEBAIHR5cGVkZWYgc3RydWN0IHhmc19lZmRfbG9nX2Zv
cm1hdF8zMiB7Cj4gwqDCoMKgwqDCoMKgwqDCoHhmc19leHRlbnRfMzJfdMKgwqDCoMKgwqDCoMKg
wqDCoGVmZF9leHRlbnRzW107wqDCoC8qIGFycmF5IG9mIGV4dGVudHMKPiBmcmVlZCAqLwo+IMKg
fSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKSB4ZnNfZWZkX2xvZ19mb3JtYXRfMzJfdDsKPiDCoAo+
ICtzdGF0aWMgaW5saW5lIHNpemVfdAo+ICt4ZnNfZWZkX2xvZ19mb3JtYXQzMl9zaXplb2YoCj4g
K8KgwqDCoMKgwqDCoMKgdW5zaWduZWQgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbnIpCj4g
K3sKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gc2l6ZW9mKHN0cnVjdCB4ZnNfZWZkX2xvZ19mb3Jt
YXRfMzIpICsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oG5yICogc2l6ZW9mKHN0cnVjdCB4ZnNfZXh0ZW50XzMyKTsKPiArfQo+ICsKPiDCoHR5cGVkZWYg
c3RydWN0IHhmc19lZmRfbG9nX2Zvcm1hdF82NCB7Cj4gwqDCoMKgwqDCoMKgwqDCoHVpbnQxNl90
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlZmRfdHlwZTvCoMKgwqDCoMKgwqDCoC8q
IGVmZCBsb2cgaXRlbSB0eXBlCj4gKi8KPiDCoMKgwqDCoMKgwqDCoMKgdWludDE2X3TCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVmZF9zaXplO8KgwqDCoMKgwqDCoMKgLyogc2l6ZSBv
ZiB0aGlzIGl0ZW0KPiAqLwo+IEBAIC02NjEsNiArNzAxLDE0IEBAIHR5cGVkZWYgc3RydWN0IHhm
c19lZmRfbG9nX2Zvcm1hdF82NCB7Cj4gwqDCoMKgwqDCoMKgwqDCoHhmc19leHRlbnRfNjRfdMKg
wqDCoMKgwqDCoMKgwqDCoGVmZF9leHRlbnRzW107wqDCoC8qIGFycmF5IG9mIGV4dGVudHMKPiBm
cmVlZCAqLwo+IMKgfSB4ZnNfZWZkX2xvZ19mb3JtYXRfNjRfdDsKPiDCoAo+ICtzdGF0aWMgaW5s
aW5lIHNpemVfdAo+ICt4ZnNfZWZkX2xvZ19mb3JtYXQ2NF9zaXplb2YoCj4gK8KgwqDCoMKgwqDC
oMKgdW5zaWduZWQgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbnIpCj4gK3sKPiArwqDCoMKg
wqDCoMKgwqByZXR1cm4gc2l6ZW9mKHN0cnVjdCB4ZnNfZWZkX2xvZ19mb3JtYXRfNjQpICsKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5yICogc2l6ZW9m
KHN0cnVjdCB4ZnNfZXh0ZW50XzY0KTsKPiArfQo+ICsKPiDCoC8qCj4gwqAgKiBSVUkvUlVEIChy
ZXZlcnNlIG1hcHBpbmcpIGxvZyBmb3JtYXQgZGVmaW5pdGlvbnMKPiDCoCAqLwo+IGRpZmYgLS1n
aXQgYS9mcy94ZnMveGZzX2V4dGZyZWVfaXRlbS5jIGIvZnMveGZzL3hmc19leHRmcmVlX2l0ZW0u
Ywo+IGluZGV4IDQ2NmNjNWM1Y2QzMy4uYmZmYjJiOTFlMzlhIDEwMDY0NAo+IC0tLSBhL2ZzL3hm
cy94ZnNfZXh0ZnJlZV9pdGVtLmMKPiArKysgYi9mcy94ZnMveGZzX2V4dGZyZWVfaXRlbS5jCj4g
QEAgLTY2LDI3ICs2NiwxNiBAQCB4ZnNfZWZpX3JlbGVhc2UoCj4gwqDCoMKgwqDCoMKgwqDCoHhm
c19lZmlfaXRlbV9mcmVlKGVmaXApOwo+IMKgfQo+IMKgCj4gLS8qCj4gLSAqIFRoaXMgcmV0dXJu
cyB0aGUgbnVtYmVyIG9mIGlvdmVjcyBuZWVkZWQgdG8gbG9nIHRoZSBnaXZlbiBlZmkKPiBpdGVt
Lgo+IC0gKiBXZSBvbmx5IG5lZWQgMSBpb3ZlYyBmb3IgYW4gZWZpIGl0ZW0uwqAgSXQganVzdCBs
b2dzIHRoZQo+IGVmaV9sb2dfZm9ybWF0Cj4gLSAqIHN0cnVjdHVyZS4KPiAtICovCj4gLXN0YXRp
YyBpbmxpbmUgaW50Cj4gLXhmc19lZmlfaXRlbV9zaXplb2YoCj4gLcKgwqDCoMKgwqDCoMKgc3Ry
dWN0IHhmc19lZmlfbG9nX2l0ZW0gKmVmaXApCj4gLXsKPiAtwqDCoMKgwqDCoMKgwqByZXR1cm4g
c2l6ZW9mKHN0cnVjdCB4ZnNfZWZpX2xvZ19mb3JtYXQpICsKPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZWZpcC0+ZWZpX2Zvcm1hdC5lZmlfbmV4dGVudHMgKiBzaXplb2YoeGZzX2V4dGVu
dF90KTsKPiAtfQo+IC0KPiDCoFNUQVRJQyB2b2lkCj4gwqB4ZnNfZWZpX2l0ZW1fc2l6ZSgKPiDC
oMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19sb2dfaXRlbcKgwqDCoMKgwqAqbGlwLAo+IMKgwqDC
oMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAq
bnZlY3MsCj4gwqDCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCpuYnl0ZXMpCj4gwqB7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19l
ZmlfbG9nX2l0ZW3CoCplZmlwID0gRUZJX0lURU0obGlwKTsKPiArCj4gwqDCoMKgwqDCoMKgwqDC
oCpudmVjcyArPSAxOwo+IC3CoMKgwqDCoMKgwqDCoCpuYnl0ZXMgKz0geGZzX2VmaV9pdGVtX3Np
emVvZihFRklfSVRFTShsaXApKTsKPiArwqDCoMKgwqDCoMKgwqAqbmJ5dGVzICs9IHhmc19lZmlf
bG9nX2Zvcm1hdF9zaXplb2YoZWZpcC0KPiA+ZWZpX2Zvcm1hdC5lZmlfbmV4dGVudHMpOwo+IMKg
fQo+IMKgCj4gwqAvKgo+IEBAIC0xMTIsNyArMTAxLDcgQEAgeGZzX2VmaV9pdGVtX2Zvcm1hdCgK
PiDCoAo+IMKgwqDCoMKgwqDCoMKgwqB4bG9nX2NvcHlfaW92ZWMobHYsICZ2ZWNwLCBYTE9HX1JF
R19UWVBFX0VGSV9GT1JNQVQsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgJmVmaXAtPmVmaV9mb3JtYXQsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfZWZpX2l0ZW1fc2l6ZW9mKGVmaXApKTsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhmc19lZmlfbG9nX2Zv
cm1hdF9zaXplb2YoZWZpcC0KPiA+ZWZpX2Zvcm1hdC5lZmlfbmV4dGVudHMpKTsKPiDCoH0KPiDC
oAo+IMKgCj4gQEAgLTE1NSwxMyArMTQ0LDExIEBAIHhmc19lZmlfaW5pdCgKPiDCoAo+IMKgewo+
IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2VmaV9sb2dfaXRlbcKgKmVmaXA7Cj4gLcKgwqDC
oMKgwqDCoMKgdWludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzaXpl
Owo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoEFTU0VSVChuZXh0ZW50cyA+IDApOwo+IMKgwqDCoMKg
wqDCoMKgwqBpZiAobmV4dGVudHMgPiBYRlNfRUZJX01BWF9GQVNUX0VYVEVOVFMpIHsKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc2l6ZSA9ICh1aW50KShzaXplb2Yoc3RydWN0IHhm
c19lZmlfbG9nX2l0ZW0pICsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoChuZXh0ZW50cyAqIHNpemVvZih4ZnNfZXh0ZW50X3QpKSk7Cj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVmaXAgPSBrbWVtX3phbGxvYyhzaXplLCAwKTsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZWZpcCA9IGttZW1femFsbG9jKHhmc19lZmlfbG9n
X2l0ZW1fc2l6ZW9mKG5leHRlbnRzKSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBHRlBfS0VSTkVMIHwgX19HRlBfTk9GQUlM
KTsKPiDCoMKgwqDCoMKgwqDCoMKgfSBlbHNlIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGVmaXAgPSBrbWVtX2NhY2hlX3phbGxvYyh4ZnNfZWZpX2NhY2hlLAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIEdGUF9LRVJORUwgfCBfX0dGUF9OT0ZBSUwpOwo+IEBAIC0xODgsMTIg
KzE3NSw5IEBAIHhmc19lZmlfY29weV9mb3JtYXQoeGZzX2xvZ19pb3ZlY190ICpidWYsCj4geGZz
X2VmaV9sb2dfZm9ybWF0X3QgKmRzdF9lZmlfZm10KQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqB4
ZnNfZWZpX2xvZ19mb3JtYXRfdCAqc3JjX2VmaV9mbXQgPSBidWYtPmlfYWRkcjsKPiDCoMKgwqDC
oMKgwqDCoMKgdWludCBpOwo+IC3CoMKgwqDCoMKgwqDCoHVpbnQgbGVuID0gc2l6ZW9mKHhmc19l
ZmlfbG9nX2Zvcm1hdF90KSArCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNyY19l
ZmlfZm10LT5lZmlfbmV4dGVudHMgKiBzaXplb2YoeGZzX2V4dGVudF90KTsKPiAtwqDCoMKgwqDC
oMKgwqB1aW50IGxlbjMyID0gc2l6ZW9mKHhmc19lZmlfbG9nX2Zvcm1hdF8zMl90KSArCj4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNyY19lZmlfZm10LT5lZmlfbmV4dGVudHMgKiBz
aXplb2YoeGZzX2V4dGVudF8zMl90KTsKPiAtwqDCoMKgwqDCoMKgwqB1aW50IGxlbjY0ID0gc2l6
ZW9mKHhmc19lZmlfbG9nX2Zvcm1hdF82NF90KSArCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHNyY19lZmlfZm10LT5lZmlfbmV4dGVudHMgKiBzaXplb2YoeGZzX2V4dGVudF82NF90
KTsKPiArwqDCoMKgwqDCoMKgwqB1aW50IGxlbiA9IHhmc19lZmlfbG9nX2Zvcm1hdF9zaXplb2Yo
c3JjX2VmaV9mbXQtCj4gPmVmaV9uZXh0ZW50cyk7Cj4gK8KgwqDCoMKgwqDCoMKgdWludCBsZW4z
MiA9IHhmc19lZmlfbG9nX2Zvcm1hdDMyX3NpemVvZihzcmNfZWZpX2ZtdC0KPiA+ZWZpX25leHRl
bnRzKTsKPiArwqDCoMKgwqDCoMKgwqB1aW50IGxlbjY0ID0geGZzX2VmaV9sb2dfZm9ybWF0NjRf
c2l6ZW9mKHNyY19lZmlfZm10LQo+ID5lZmlfbmV4dGVudHMpOwo+IMKgCj4gwqDCoMKgwqDCoMKg
wqDCoGlmIChidWYtPmlfbGVuID09IGxlbikgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgbWVtY3B5KGRzdF9lZmlfZm10LCBzcmNfZWZpX2ZtdCwKPiBAQCAtMjUxLDI3ICsyMzUs
MTYgQEAgeGZzX2VmZF9pdGVtX2ZyZWUoc3RydWN0IHhmc19lZmRfbG9nX2l0ZW0KPiAqZWZkcCkK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGttZW1fY2FjaGVfZnJlZSh4ZnNfZWZk
X2NhY2hlLCBlZmRwKTsKPiDCoH0KPiDCoAo+IC0vKgo+IC0gKiBUaGlzIHJldHVybnMgdGhlIG51
bWJlciBvZiBpb3ZlY3MgbmVlZGVkIHRvIGxvZyB0aGUgZ2l2ZW4gZWZkCj4gaXRlbS4KPiAtICog
V2Ugb25seSBuZWVkIDEgaW92ZWMgZm9yIGFuIGVmZCBpdGVtLsKgIEl0IGp1c3QgbG9ncyB0aGUK
PiBlZmRfbG9nX2Zvcm1hdAo+IC0gKiBzdHJ1Y3R1cmUuCj4gLSAqLwo+IC1zdGF0aWMgaW5saW5l
IGludAo+IC14ZnNfZWZkX2l0ZW1fc2l6ZW9mKAo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNf
ZWZkX2xvZ19pdGVtICplZmRwKQo+IC17Cj4gLcKgwqDCoMKgwqDCoMKgcmV0dXJuIHNpemVvZih4
ZnNfZWZkX2xvZ19mb3JtYXRfdCkgKwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlZmRw
LT5lZmRfZm9ybWF0LmVmZF9uZXh0ZW50cyAqIHNpemVvZih4ZnNfZXh0ZW50X3QpOwo+IC19Cj4g
LQo+IMKgU1RBVElDIHZvaWQKPiDCoHhmc19lZmRfaXRlbV9zaXplKAo+IMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QgeGZzX2xvZ19pdGVtwqDCoMKgwqDCoCpsaXAsCj4gwqDCoMKgwqDCoMKgwqDCoGlu
dMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpudmVjcywKPiDCoMKg
wqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
Km5ieXRlcykKPiDCoHsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2VmZF9sb2dfaXRlbcKg
KmVmZHAgPSBFRkRfSVRFTShsaXApOwo+ICsKPiDCoMKgwqDCoMKgwqDCoMKgKm52ZWNzICs9IDE7
Cj4gLcKgwqDCoMKgwqDCoMKgKm5ieXRlcyArPSB4ZnNfZWZkX2l0ZW1fc2l6ZW9mKEVGRF9JVEVN
KGxpcCkpOwo+ICvCoMKgwqDCoMKgwqDCoCpuYnl0ZXMgKz0geGZzX2VmZF9sb2dfZm9ybWF0X3Np
emVvZihlZmRwLQo+ID5lZmRfZm9ybWF0LmVmZF9uZXh0ZW50cyk7Cj4gwqB9Cj4gwqAKPiDCoC8q
Cj4gQEAgLTI5Niw3ICsyNjksNyBAQCB4ZnNfZWZkX2l0ZW1fZm9ybWF0KAo+IMKgCj4gwqDCoMKg
wqDCoMKgwqDCoHhsb2dfY29weV9pb3ZlYyhsdiwgJnZlY3AsIFhMT0dfUkVHX1RZUEVfRUZEX0ZP
Uk1BVCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAm
ZWZkcC0+ZWZkX2Zvcm1hdCwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHhmc19lZmRfaXRlbV9zaXplb2YoZWZkcCkpOwo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZzX2VmZF9sb2dfZm9ybWF0X3NpemVvZihl
ZmRwLQo+ID5lZmRfZm9ybWF0LmVmZF9uZXh0ZW50cykpOwo+IMKgfQo+IMKgCj4gwqAvKgo+IEBA
IC0zNDUsOSArMzE4LDggQEAgeGZzX3RyYW5zX2dldF9lZmQoCj4gwqDCoMKgwqDCoMKgwqDCoEFT
U0VSVChuZXh0ZW50cyA+IDApOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChuZXh0ZW50cyA+
IFhGU19FRkRfTUFYX0ZBU1RfRVhURU5UUykgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBlZmRwID0ga21lbV96YWxsb2Moc2l6ZW9mKHN0cnVjdCB4ZnNfZWZkX2xvZ19pdGVtKSAr
Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgbmV4dGVudHMgKiBzaXplb2Yoc3RydWN0IHhmc19leHRlbnQpLAo+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDAp
Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlZmRwID0ga21lbV96YWxsb2MoeGZz
X2VmZF9sb2dfaXRlbV9zaXplb2YobmV4dGVudHMpLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoEdGUF9LRVJORUwgfCBfX0dG
UF9OT0ZBSUwpOwo+IMKgwqDCoMKgwqDCoMKgwqB9IGVsc2Ugewo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgZWZkcCA9IGttZW1fY2FjaGVfemFsbG9jKHhmc19lZmRfY2FjaGUsCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBHRlBfS0VSTkVMIHwgX19HRlBfTk9GQUlMKTsKPiBAQCAt
NzM4LDggKzcxMCw3IEBAIHhsb2dfcmVjb3Zlcl9lZmlfY29tbWl0X3Bhc3MyKAo+IMKgCj4gwqDC
oMKgwqDCoMKgwqDCoGVmaV9mb3JtYXRwID0gaXRlbS0+cmlfYnVmWzBdLmlfYWRkcjsKPiDCoAo+
IC3CoMKgwqDCoMKgwqDCoGlmIChpdGVtLT5yaV9idWZbMF0uaV9sZW4gPAo+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgb2Zmc2V0b2Yoc3RydWN0IHhmc19l
ZmlfbG9nX2Zvcm1hdCwKPiBlZmlfZXh0ZW50cykpIHsKPiArwqDCoMKgwqDCoMKgwqBpZiAoaXRl
bS0+cmlfYnVmWzBdLmlfbGVuIDwgeGZzX2VmaV9sb2dfZm9ybWF0X3NpemVvZigwKSkgewo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgWEZTX0VSUk9SX1JFUE9SVChfX2Z1bmNfXywg
WEZTX0VSUkxFVkVMX0xPVywgbG9nLQo+ID5sX21wKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiAtRUZTQ09SUlVQVEVEOwo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gQEAg
LTc4MiwxMCArNzUzLDEwIEBAIHhsb2dfcmVjb3Zlcl9lZmRfY29tbWl0X3Bhc3MyKAo+IMKgwqDC
oMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2VmZF9sb2dfZm9ybWF0wqDCoMKgwqDCoMKgwqAqZWZkX2Zv
cm1hdHA7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgZWZkX2Zvcm1hdHAgPSBpdGVtLT5yaV9idWZb
MF0uaV9hZGRyOwo+IC3CoMKgwqDCoMKgwqDCoEFTU0VSVCgoaXRlbS0+cmlfYnVmWzBdLmlfbGVu
ID09Cj4gKHNpemVvZih4ZnNfZWZkX2xvZ19mb3JtYXRfMzJfdCkgKwo+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAoZWZkX2Zvcm1hdHAtPmVmZF9uZXh0ZW50cyAqCj4gc2l6ZW9mKHhm
c19leHRlbnRfMzJfdCkpKSkgfHwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKGl0ZW0t
PnJpX2J1ZlswXS5pX2xlbiA9PQo+IChzaXplb2YoeGZzX2VmZF9sb2dfZm9ybWF0XzY0X3QpICsK
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKGVmZF9mb3JtYXRwLT5lZmRfbmV4dGVu
dHMgKgo+IHNpemVvZih4ZnNfZXh0ZW50XzY0X3QpKSkpKTsKPiArwqDCoMKgwqDCoMKgwqBBU1NF
UlQoaXRlbS0+cmlfYnVmWzBdLmlfbGVuID09IHhmc19lZmRfbG9nX2Zvcm1hdDMyX3NpemVvZigK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVmZF9mb3JtYXRwLQo+ID5l
ZmRfbmV4dGVudHMpIHx8Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGl0ZW0tPnJpX2J1
ZlswXS5pX2xlbiA9PSB4ZnNfZWZkX2xvZ19mb3JtYXQ2NF9zaXplb2YoCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlZmRfZm9ybWF0cC0KPiA+ZWZkX25leHRlbnRzKSk7
Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgeGxvZ19yZWNvdmVyX3JlbGVhc2VfaW50ZW50KGxvZywg
WEZTX0xJX0VGSSwgZWZkX2Zvcm1hdHAtCj4gPmVmZF9lZmlfaWQpOwo+IMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gMDsKPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19leHRmcmVlX2l0ZW0uaCBiL2Zz
L3hmcy94ZnNfZXh0ZnJlZV9pdGVtLmgKPiBpbmRleCAxODZkMGYyMTM3ZjEuLmRhNmE1YWZhNjA3
YyAxMDA2NDQKPiAtLS0gYS9mcy94ZnMveGZzX2V4dGZyZWVfaXRlbS5oCj4gKysrIGIvZnMveGZz
L3hmc19leHRmcmVlX2l0ZW0uaAo+IEBAIC01Miw2ICs1MiwxNCBAQCBzdHJ1Y3QgeGZzX2VmaV9s
b2dfaXRlbSB7Cj4gwqDCoMKgwqDCoMKgwqDCoHhmc19lZmlfbG9nX2Zvcm1hdF90wqDCoMKgwqBl
ZmlfZm9ybWF0Owo+IMKgfTsKPiDCoAo+ICtzdGF0aWMgaW5saW5lIHNpemVfdAo+ICt4ZnNfZWZp
X2xvZ19pdGVtX3NpemVvZigKPiArwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnTCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBucikKPiArewo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBvZmZzZXRvZihz
dHJ1Y3QgeGZzX2VmaV9sb2dfaXRlbSwgZWZpX2Zvcm1hdCkgKwo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZzX2VmaV9sb2dfZm9ybWF0X3NpemVvZihu
cik7Cj4gK30KPiArCj4gwqAvKgo+IMKgICogVGhpcyBpcyB0aGUgImV4dGVudCBmcmVlIGRvbmUi
IGxvZyBpdGVtLsKgIEl0IGlzIHVzZWQgdG8gbG9nCj4gwqAgKiB0aGUgZmFjdCB0aGF0IHNvbWUg
ZXh0ZW50cyBlYXJsaWVyIG1lbnRpb25lZCBpbiBhbiBlZmkgaXRlbQo+IEBAIC02NCw2ICs3Miwx
NCBAQCBzdHJ1Y3QgeGZzX2VmZF9sb2dfaXRlbSB7Cj4gwqDCoMKgwqDCoMKgwqDCoHhmc19lZmRf
bG9nX2Zvcm1hdF90wqDCoMKgwqBlZmRfZm9ybWF0Owo+IMKgfTsKPiDCoAo+ICtzdGF0aWMgaW5s
aW5lIHNpemVfdAo+ICt4ZnNfZWZkX2xvZ19pdGVtX3NpemVvZigKPiArwqDCoMKgwqDCoMKgwqB1
bnNpZ25lZCBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBucikKPiArewo+ICvCoMKgwqDCoMKg
wqDCoHJldHVybiBvZmZzZXRvZihzdHJ1Y3QgeGZzX2VmZF9sb2dfaXRlbSwgZWZkX2Zvcm1hdCkg
Kwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZzX2Vm
ZF9sb2dfZm9ybWF0X3NpemVvZihucik7Cj4gK30KPiArCj4gwqAvKgo+IMKgICogTWF4IG51bWJl
ciBvZiBleHRlbnRzIGluIGZhc3QgYWxsb2NhdGlvbiBwYXRoLgo+IMKgICovCj4gZGlmZiAtLWdp
dCBhL2ZzL3hmcy94ZnNfc3VwZXIuYyBiL2ZzL3hmcy94ZnNfc3VwZXIuYwo+IGluZGV4IDg0ODVl
M2IzN2NhMC4uZWU0YjQyOWEyZjJjIDEwMDY0NAo+IC0tLSBhL2ZzL3hmcy94ZnNfc3VwZXIuYwo+
ICsrKyBiL2ZzL3hmcy94ZnNfc3VwZXIuYwo+IEBAIC0yMDI4LDE4ICsyMDI4LDE0IEBAIHhmc19p
bml0X2NhY2hlcyh2b2lkKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBv
dXRfZGVzdHJveV90cmFuc19jYWNoZTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfZWZkX2Nh
Y2hlID0ga21lbV9jYWNoZV9jcmVhdGUoInhmc19lZmRfaXRlbSIsCj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoChzaXplb2Yoc3RydWN0Cj4geGZzX2VmZF9sb2dfaXRlbSkgKwo+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBYRlNfRUZEX01BWF9GQVNUX0VYVEVOVFMgKgo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBzaXplb2Yoc3RydWN0IHhmc19leHRlbnQpKSwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
MCwgMCwgTlVMTCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqB4ZnNfZWZkX2xvZ19pdGVtX3NpemVvZihYRlNfRUZEX01BWF9GQVNUX0VYVEUKPiBOVFMp
LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMCwgMCwg
TlVMTCk7Cj4gwqDCoMKgwqDCoMKgwqDCoGlmICgheGZzX2VmZF9jYWNoZSkKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X2Rlc3Ryb3lfYnVmX2l0ZW1fY2FjaGU7Cj4g
wqAKPiDCoMKgwqDCoMKgwqDCoMKgeGZzX2VmaV9jYWNoZSA9IGttZW1fY2FjaGVfY3JlYXRlKCJ4
ZnNfZWZpX2l0ZW0iLAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKHNpemVvZihzdHJ1Y3QKPiB4
ZnNfZWZpX2xvZ19pdGVtKSArCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBYRlNfRUZJX01BWF9G
QVNUX0VYVEVOVFMgKgo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZW9mKHN0cnVjdCB4ZnNf
ZXh0ZW50KSksCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAwLCAwLCBOVUxMKTsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhmc19lZmlfbG9nX2l0ZW1f
c2l6ZW9mKFhGU19FRklfTUFYX0ZBU1RfRVhURQo+IE5UUyksCj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAwLCAwLCBOVUxMKTsKPiDCoMKgwqDCoMKgwqDC
oMKgaWYgKCF4ZnNfZWZpX2NhY2hlKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
Z290byBvdXRfZGVzdHJveV9lZmRfY2FjaGU7Cj4gwqAKPiAKCg==
