Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269A460DC47
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Oct 2022 09:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbiJZHko (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Oct 2022 03:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbiJZHke (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 03:40:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF0833859
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 00:40:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1na6j024715;
        Wed, 26 Oct 2022 07:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ww2IWD63Q2urcuMvWRe3OB1q8WIOYQzRhLuPcisgNKc=;
 b=YvWO4U3Xl6/tEJ63F5eJVK9o6DrUWLuyftBVctZI012MT7LGQuH4Nd4nohUPt1P3RPS6
 0sO+LN9shkxYicFmqV1kV3mNs9jSOovAr3mWtjvIeU50nH/1L2Gbt/a+RaxYNWcxubSV
 nZ4WZ2RHFJQrDyTQN9bfq+3kfsi8xaaSVY8FsRHj/PiEzxIwOrmj3Rpm+nthXqDzeHYy
 v74l7H93XPuXI9LBAI5kmNDJPngzmf0cZMMQIDLX5nFhlGz5v+X0mNHyzAsYRy/Ki5FM
 IjNPhhoc4UyG3sT2aWZLJpawW33FNbaetf4fNyT4CMm+K4tr6Un/XW4lJgatXmQ4dOWU jg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbnfq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q6OKdp017574;
        Wed, 26 Oct 2022 07:40:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5py2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lytp5BfkXQsGeAZvYUHcnE483Dfcx9cKPVCyQzYxGdPoOp4zjKh9gHVlClGomI3IwlatFwG+X0PSIp51p/zsPtq3SJWp8QxR/O9QUOdHlOnMnngYqMISlmfsvlGBnz/sjfKDVmyw1jBdScSuhyNBmhM3zEvp/Rl7xlbsIcifXKTcECuZHljV5v3EDQmAj9olSDGvOUY678u+r+QT6BpvBQMQjPOgazWgdlmYxsIcARSV8Xw7C5eQOwXgLyRfzvH3cUrNH0UhqrMiFifL2K2dIv8L/UDq9K/T/w/WWiGaASfvNIhjwm0xuhJ3Xc0a11VyIllSVCCTc1n9SEOmDLbeEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ww2IWD63Q2urcuMvWRe3OB1q8WIOYQzRhLuPcisgNKc=;
 b=Pvkhnbw4bBJeGuMXNBxMQS998kRtcgMPA7/4184JQYL2QWqIxop3D2N2DmU8y3hvVwCMZi6/GsIrBqYxMxumjf9SvVLXuWJL2BVcwqkawHtS7yCkj2R0dU+mFFRpQVGEdWufKMpMZB64VMprRFYwVOnT43Eu8gEC6l4BW4wQ8Sonuc6+az6tKBoe5kYUUf5VotAvY59lOK+QuWc5kasvxT30gstH/Fivl74lnyY2QtD5TzFLJ0LL+ocAX7AV6SEJkYlpVf5+aznsVbYIaFrB+stid2HMYkhbXwwbKmLcId0UaLyZxx3OQ4o91bwtlbT8gIWDYb7/qNfN6Q/JXsHotg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ww2IWD63Q2urcuMvWRe3OB1q8WIOYQzRhLuPcisgNKc=;
 b=oPf2w1lJFhHaZDhTAuw5j1eL7y7ISwNGAoBSnOFb+12w60FOmzMPfZElzoqCJ5o+IfwCrcwYk79m8SLZu3e7YetSfaTfBqrAd9BzzRa6T2g2vcuyb5yXJHsSkq+9IbNLSC7fNVG1cyIwynNKYY8p28+o15/Ke2FT8YLeKoLHwsk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB5991.namprd10.prod.outlook.com (2603:10b6:8:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 26 Oct
 2022 07:40:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Wed, 26 Oct 2022
 07:40:18 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 18/27] xfs: remove parent pointers in unlink
Thread-Topic: [PATCH v4 18/27] xfs: remove parent pointers in unlink
Thread-Index: AQHY5Zysc6DMRwAgs0KGDCFgk5B5iK4fonIAgACutoA=
Date:   Wed, 26 Oct 2022 07:40:17 +0000
Message-ID: <7df70f44c871c6accc8f2bc7fb37c6de2a8f8636.camel@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
         <20221021222936.934426-19-allison.henderson@oracle.com>
         <Y1hR0kBgpscTNzLK@magnolia>
In-Reply-To: <Y1hR0kBgpscTNzLK@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DM4PR10MB5991:EE_
x-ms-office365-filtering-correlation-id: 585435f3-2129-4bdf-2ad2-08dab7255437
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a7RAKcCEVpeoG3ET2RjZ4AUiM6W6pc6xoJ69CoZzXed5D1EkIIimFRjXhRemI/cy9K82hH36Gf5RcWF53jteiurCRDypgnIryxNui1kQUZDPOGCBcvsY8+KBL7FaZLR94FCHw+ru/pv23m4qNfVZkKo+a/vYPoQ/EKw940gSEZRDjSlm4+YO3345cHBZsUQTTRKZxjJvvkUQkdBNNpDQWGxyt9jFvyZqtRQ0IbaJBSa8hYgVp39Ov8HT88Qq+LZyzezStULpV5onGqeSnQLwBuQuEmDw/Cjy8lCwShWAeZs3FsqozaAUIRZY9WC0ccXvMuHCHgqTZ/Gblpa1nzmPeIlW7yp9Y4iBtiEpzD8rh4zosCA9ElPiaBOn59xaPloAz8+Ao39Jcfuwf+t2+q+4iTYZ9RC8F4ghXCANRDJ+IQsI0ofd5nMG/BbEugYp8rziVZJIIDFpOpK1K6oleDQ/tg3I2tBD0Rf5+nNW7YFaH9li19iN3Zh5iDGleJbAM6m3qJsWt5ac7NMnuJjXwjKHIBVe8zf2Et4Lzig3L04BEwVzBAflQdR0+Da3XQFoT1OQGze66LjVN6SLhuHK9voc2wYtbttbLFm0zFZY58AuGC6IeOIIVXmXOucwCQ7ups13fWpzqwZQTaF5dncwEfvZM5Hs454540V/gjeIfHcNGfdjl0aEscUtPZmrtnMwKOYkpMxqVOlFgPSpHMuvFyPxqlZMXk2o4ySi3ZDFmCTMKpVQqZwIjuyUifpMD6j2UzYZUbLWE6qIgA5KZJbEUQO/HA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(316002)(66556008)(44832011)(86362001)(66476007)(66446008)(4326008)(6916009)(76116006)(83380400001)(66946007)(2906002)(2616005)(186003)(64756008)(41300700001)(8676002)(8936002)(6512007)(478600001)(26005)(71200400001)(38070700005)(4001150100001)(38100700002)(6506007)(122000001)(36756003)(5660300002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0dZYjZsZjlhYm82MmErUURSQnl1WEN3Tnh6anJ4aTJlYkl2Sk0zSU1NZ05z?=
 =?utf-8?B?WHNUY0trZ2owV2hLcGVqVEo2SVlGRklrRHQ0cjk4U0hvUkIrR2hGdHQ4ak1K?=
 =?utf-8?B?ZXVIL3cyQWJmZXdoTmxYbmIwU3Q2QWpveU52UmdKejg2QVNpLzRNOWRrQWVo?=
 =?utf-8?B?M2kzRDBUWjc2ck15WWpNT1pzelpncjg0TytRa2dXRFRRL3Y5amZuTE8zZWZ1?=
 =?utf-8?B?eUhIUDdtR0toeS9oZy9qSTVmLzV1b2NKczVPZWVGSXFmMDBob09HU2tHSVZa?=
 =?utf-8?B?ZU43aUkyR3I5eEdXQ2NJZnA3ZHNGSkdVbUV0SnZROGcyQ2hWVWkyZDYxUHV3?=
 =?utf-8?B?MmF6UStqS1QvSE5wTUZUZU5JZmRYUzlkWTc3ZFlNQjVNMWx5OHRqQnVtd2dh?=
 =?utf-8?B?SHdJNUw2K282ZHgxTUdnS2JDZWVkMDZ4UGFIamx0VXM0RlJyblEwRHhNVndP?=
 =?utf-8?B?RDNONXZ6Mll2TzJ2MG1mUmswNFZ5Z0I5MVRtc3U5ZWNicmN6R0psUmEySWFp?=
 =?utf-8?B?ak0vcUd6VmFpb0hGZ2FNM3pXQTY1dXpQSy9oek5WT3hxNVZjMVFTTHVrc3Bx?=
 =?utf-8?B?dzdTU3QzcE54eVlwOFBmU2h4UDk2SU53OEowbk1Ec3RzZmQzSjB1VG0wM3BJ?=
 =?utf-8?B?RkY1SzVDMXN3eUV5VGlUenZOZk04VG5CaDBJdUd4bnVUSnJqOHlTamJxS0po?=
 =?utf-8?B?U3N2ejI5K0NDVXlyQjNsdGwzRmo0UkZRdWZoNlNYSXJ5SmQ5bzRqaXQ0T3pp?=
 =?utf-8?B?QjBjK29Bb1RJWUZSQ0tLSEJwRU92SEZqYlV4MmNCY0g3NjdONElxQUx6UTZI?=
 =?utf-8?B?bzhmVzlXa1d5Yjl3bkhzYnFIUmJNclg2R051cStpVXVDNHFmWitENTM0blMr?=
 =?utf-8?B?VTFwb3N6cGY3N1laWG5iYUZQM2JTRzlKYTR6RUt6Yllya3JEQzB4d1lzTDVK?=
 =?utf-8?B?UDlxem1raU5DeURCM202L0VCZExSRXM2SzI2OXRjVXRrZEJ0R2NTVXEvZHF3?=
 =?utf-8?B?OXJXcG0xc3VGMWM2UmMxVUFZYUZGRzlLZ2Vxa0NKcU1icWowNTlCUVBOc09v?=
 =?utf-8?B?ZkhNdXdpOUo3Y1FQN28veXZDMWo5OE1rVHoxTCtkak8xcWg5a3pNc1BoU0dO?=
 =?utf-8?B?WGp0N0FTSmR6TGIxOVJYSlFnaU5uN0lPVWROL0U1ZDl3NXZ4dEVLb0FINlJq?=
 =?utf-8?B?QTRuMnJEa05wK3U5Y05QcGtTdDlHMVpUNU42WnBRQmt6UTVrcEdla2dlcGlL?=
 =?utf-8?B?TS82ak93dFJWVVcrbnUzR1czZG1KeC9wZEtONTFzd1c2d1F4TDJ2ZUw3eEJa?=
 =?utf-8?B?Nm54R25ZQUc0ekVqQlkyUTczU2dYeHFWRC9jVFVvVld1R29wQzg2RzF4S2d2?=
 =?utf-8?B?UFEyeTRDc2NBSVZBRGUrNExGdUhjdmJGS1FyMUJ1VWxldXNwbFhKam9Bbnk0?=
 =?utf-8?B?VVpObWhpOTFpOEZxNkZoSXhRek9OVXB3OFhZZStDMDBNSVNqRjBBQ0E1c0NN?=
 =?utf-8?B?OFB1eWVYMXNBV2FSNFRNZENMUXJOWDExNksvUElNdU5tclhYY2FLN1V2SlNQ?=
 =?utf-8?B?djc2SlhNTVViOUNGTHNkYkNtOVBjZmZoNEhQL1ZGcnRkRmpOQUlrNFpiaEV3?=
 =?utf-8?B?UmVSSUJ5UG1ZWXpiU3NEWS92ZSs1TE1SWTl5VFAvVEJwai8rV2JrYkFLZ2xn?=
 =?utf-8?B?YmRZcnpRMkI1WnE4dVg5K1Q5a3ptR3J0OHkyQ2JDdm9vZTgzQjlIckpDMDB5?=
 =?utf-8?B?MVNVeTI1dUE0dnN2MEV1aUFHTWh3TlQ4UG00WUhWU1hUNTZrSk1IWVVQTE1r?=
 =?utf-8?B?U1FwV0ZMK2xOQUp3Q2UvT1c0Rmx0Ym5Bbkl6dVgvcmxkWDJ1cmdOZmpTRWtG?=
 =?utf-8?B?dFU2cEJnZVdKeEhoUHVjVFZCNGNncFBpY3VRMkEvb2Exdm05Zi9tSkl3dktz?=
 =?utf-8?B?QjhIcCtZanR0ZXFIQW9zZVY4YmNNaTV2bGx6NzF2b0pDK3k2cXBremNTNnJs?=
 =?utf-8?B?c2hFMkFQdkU0dHZOVGNDTElpNnpHN2grR2FGNm5tMmtUVjB4NFp0ck9ad1lM?=
 =?utf-8?B?TDc1Q0JrelB4QXFScW5zZzZFckxtQThXNVJnNFVMd3c1SjF5ZXVYa1pHampx?=
 =?utf-8?B?WFlWK0xrS1haeW9aajk3elF5bkp3cUJuRS9WMGtRWTJYSUtjZXNrYmIwb3Nk?=
 =?utf-8?B?cmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E90B2C9427221469ADEFB333E9E790A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585435f3-2129-4bdf-2ad2-08dab7255437
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 07:40:18.0452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uO/Ce89Ps0nFMX/izoOTadI7BO84yxBUWXYVWfLLoKsYRb2Fw/otFyjueeLyRePNYUyeXnf5LtQnMPLPdVIVOszbWGH9o1ObbjQTHHqzrAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_04,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210260042
X-Proofpoint-ORIG-GUID: vhcIBAO58IilhevXo4HZkGYo7JV_XbZs
X-Proofpoint-GUID: vhcIBAO58IilhevXo4HZkGYo7JV_XbZs
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVHVlLCAyMDIyLTEwLTI1IGF0IDE0OjE0IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gRnJpLCBPY3QgMjEsIDIwMjIgYXQgMDM6Mjk6MjdQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBUaGlzIHBhdGNoIHJlbW92ZXMg
dGhlIHBhcmVudCBwb2ludGVyIGF0dHJpYnV0ZSBkdXJpbmcgdW5saW5rCj4gPiAKPiA+IFNpZ25l
ZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KPiA+IFNpZ25lZC1v
ZmYtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+
ID4gLS0tCj4gPiDCoGZzL3hmcy9saWJ4ZnMveGZzX2F0dHIuY8KgwqAgfMKgIDIgKy0KPiA+IMKg
ZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5owqDCoCB8wqAgMSArCj4gPiDCoGZzL3hmcy9saWJ4ZnMv
eGZzX3BhcmVudC5jIHwgMTcgKysrKysrKysrKysrKysrCj4gPiDCoGZzL3hmcy9saWJ4ZnMveGZz
X3BhcmVudC5oIHzCoCA0ICsrKysKPiA+IMKgZnMveGZzL3hmc19pbm9kZS5jwqDCoMKgwqDCoMKg
wqDCoCB8IDQ0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0KPiA+IC0tLS0KPiA+
IMKgNSBmaWxlcyBjaGFuZ2VkLCA2MCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQo+ID4g
Cj4gPiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5jIGIvZnMveGZzL2xpYnhm
cy94ZnNfYXR0ci5jCj4gPiBpbmRleCA4MDVhYWE1NjM5ZDIuLmU5Njc3MjhkMWVlNyAxMDA2NDQK
PiA+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2F0dHIuYwo+ID4gKysrIGIvZnMveGZzL2xpYnhm
cy94ZnNfYXR0ci5jCj4gPiBAQCAtOTQ2LDcgKzk0Niw3IEBAIHhmc19hdHRyX2RlZmVyX3JlcGxh
Y2UoCj4gPiDCoH0KPiA+IMKgCj4gPiDCoC8qIFJlbW92ZXMgYW4gYXR0cmlidXRlIGZvciBhbiBp
bm9kZSBhcyBhIGRlZmVycmVkIG9wZXJhdGlvbiAqLwo+ID4gLXN0YXRpYyBpbnQKPiA+ICtpbnQK
PiA+IMKgeGZzX2F0dHJfZGVmZXJfcmVtb3ZlKAo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4
ZnNfZGFfYXJnc8KgwqDCoMKgwqDCoCphcmdzKQo+ID4gwqB7Cj4gPiBkaWZmIC0tZ2l0IGEvZnMv
eGZzL2xpYnhmcy94ZnNfYXR0ci5oIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5oCj4gPiBpbmRl
eCAwY2YyM2Y1MTE3YWQuLjAzMzAwNTU0MmI5ZSAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy9saWJ4
ZnMveGZzX2F0dHIuaAo+ID4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5oCj4gPiBAQCAt
NTQ1LDYgKzU0NSw3IEBAIGJvb2wgeGZzX2F0dHJfaXNfbGVhZihzdHJ1Y3QgeGZzX2lub2RlICpp
cCk7Cj4gPiDCoGludCB4ZnNfYXR0cl9nZXRfaWxvY2tlZChzdHJ1Y3QgeGZzX2RhX2FyZ3MgKmFy
Z3MpOwo+ID4gwqBpbnQgeGZzX2F0dHJfZ2V0KHN0cnVjdCB4ZnNfZGFfYXJncyAqYXJncyk7Cj4g
PiDCoGludCB4ZnNfYXR0cl9kZWZlcl9hZGQoc3RydWN0IHhmc19kYV9hcmdzICphcmdzKTsKPiA+
ICtpbnQgeGZzX2F0dHJfZGVmZXJfcmVtb3ZlKHN0cnVjdCB4ZnNfZGFfYXJncyAqYXJncyk7Cj4g
PiDCoGludCB4ZnNfYXR0cl9zZXQoc3RydWN0IHhmc19kYV9hcmdzICphcmdzKTsKPiA+IMKgaW50
IHhmc19hdHRyX3NldF9pdGVyKHN0cnVjdCB4ZnNfYXR0cl9pbnRlbnQgKmF0dHIpOwo+ID4gwqBp
bnQgeGZzX2F0dHJfcmVtb3ZlX2l0ZXIoc3RydWN0IHhmc19hdHRyX2ludGVudCAqYXR0cik7Cj4g
PiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfcGFyZW50LmMKPiA+IGIvZnMveGZzL2xp
Ynhmcy94ZnNfcGFyZW50LmMKPiA+IGluZGV4IGNmNWVhOGNlOGJkMy4uYzA5ZjQ5YjdjMjQxIDEw
MDY0NAo+ID4gLS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfcGFyZW50LmMKPiA+ICsrKyBiL2ZzL3hm
cy9saWJ4ZnMveGZzX3BhcmVudC5jCj4gPiBAQCAtMTI1LDYgKzEyNSwyMyBAQCB4ZnNfcGFyZW50
X2RlZmVyX2FkZCgKPiA+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4geGZzX2F0dHJfZGVmZXJfYWRk
KGFyZ3MpOwo+ID4gwqB9Cj4gPiDCoAo+ID4gK2ludAo+ID4gK3hmc19wYXJlbnRfZGVmZXJfcmVt
b3ZlKAo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc190cmFuc8KgwqDCoMKgwqDCoMKgwqAq
dHAsCj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2RlwqDCoMKgwqDCoMKgwqDCoCpk
cCwKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfcGFyZW50X2RlZmVywqAqcGFyZW50LAo+
ID4gK8KgwqDCoMKgwqDCoMKgeGZzX2RpcjJfZGF0YXB0cl90wqDCoMKgwqDCoMKgZGlyb2Zmc2V0
LAo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19pbm9kZcKgwqDCoMKgwqDCoMKgwqAqY2hp
bGQpCj4gPiArewo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19kYV9hcmdzwqDCoMKgwqDC
oMKgKmFyZ3MgPSAmcGFyZW50LT5hcmdzOwo+ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgeGZzX2lu
aXRfcGFyZW50X25hbWVfcmVjKCZwYXJlbnQtPnJlYywgZHAsIGRpcm9mZnNldCk7Cj4gPiArwqDC
oMKgwqDCoMKgwqBhcmdzLT50cmFucyA9IHRwOwo+ID4gK8KgwqDCoMKgwqDCoMKgYXJncy0+ZHAg
PSBjaGlsZDsKPiA+ICvCoMKgwqDCoMKgwqDCoGFyZ3MtPmhhc2h2YWwgPSB4ZnNfZGFfaGFzaG5h
bWUoYXJncy0+bmFtZSwgYXJncy0+bmFtZWxlbik7Cj4gPiArwqDCoMKgwqDCoMKgwqByZXR1cm4g
eGZzX2F0dHJfZGVmZXJfcmVtb3ZlKGFyZ3MpOwo+ID4gK30KPiA+ICsKPiA+IMKgdm9pZAo+ID4g
wqB4ZnNfcGFyZW50X2NhbmNlbCgKPiA+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfbW91bnRfdMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgKm1wLAo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9saWJ4ZnMv
eGZzX3BhcmVudC5oCj4gPiBiL2ZzL3hmcy9saWJ4ZnMveGZzX3BhcmVudC5oCj4gPiBpbmRleCA5
YjhkMDc2NGFhZDYuLjFjNTA2NTMyYzYyNCAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMv
eGZzX3BhcmVudC5oCj4gPiArKysgYi9mcy94ZnMvbGlieGZzL3hmc19wYXJlbnQuaAo+ID4gQEAg
LTI3LDYgKzI3LDEwIEBAIGludCB4ZnNfcGFyZW50X2luaXQoeGZzX21vdW50X3QgKm1wLCBzdHJ1
Y3QKPiA+IHhmc19wYXJlbnRfZGVmZXIgKipwYXJlbnRwKTsKPiA+IMKgaW50IHhmc19wYXJlbnRf
ZGVmZXJfYWRkKHN0cnVjdCB4ZnNfdHJhbnMgKnRwLCBzdHJ1Y3QKPiA+IHhmc19wYXJlbnRfZGVm
ZXIgKnBhcmVudCwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBzdHJ1Y3QgeGZzX2lub2RlICpkcCwgc3RydWN0IHhmc19uYW1lCj4gPiAqcGFyZW50
X25hbWUsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgeGZzX2RpcjJfZGF0YXB0cl90IGRpcm9mZnNldCwgc3RydWN0Cj4gPiB4ZnNfaW5vZGUgKmNo
aWxkKTsKPiA+ICtpbnQgeGZzX3BhcmVudF9kZWZlcl9yZW1vdmUoc3RydWN0IHhmc190cmFucyAq
dHAsIHN0cnVjdCB4ZnNfaW5vZGUKPiA+ICpkcCwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCB4ZnNfcGFyZW50X2RlZmVyICpw
YXJlbnQsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB4ZnNfZGlyMl9kYXRhcHRyX3QgZGlyb2Zmc2V0LAo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHhmc19pbm9kZSAq
Y2hpbGQpOwo+ID4gwqB2b2lkIHhmc19wYXJlbnRfY2FuY2VsKHhmc19tb3VudF90ICptcCwgc3Ry
dWN0IHhmc19wYXJlbnRfZGVmZXIKPiA+ICpwYXJlbnQpOwo+ID4gwqB1bnNpZ25lZCBpbnQgeGZz
X3BwdHJfY2FsY19zcGFjZV9yZXMoc3RydWN0IHhmc19tb3VudCAqbXAsCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdW5zaWduZWQgaW50IG5hbWVsZW4pOwo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNf
aW5vZGUuYyBiL2ZzL3hmcy94ZnNfaW5vZGUuYwo+ID4gaW5kZXggZjJlN2RhMWJlZmE0Li44M2Nj
NTJjMmJjZjEgMTAwNjQ0Cj4gPiAtLS0gYS9mcy94ZnMveGZzX2lub2RlLmMKPiA+ICsrKyBiL2Zz
L3hmcy94ZnNfaW5vZGUuYwo+ID4gQEAgLTI0NzIsNiArMjQ3MiwxOSBAQCB4ZnNfaXVucGluX3dh
aXQoCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9feGZzX2l1bnBpbl93YWl0
KGlwKTsKPiA+IMKgfQo+ID4gwqAKPiA+ICt1bnNpZ25lZCBpbnQKPiA+ICt4ZnNfcmVtb3ZlX3Nw
YWNlX3JlcygKPiAKPiBUaGlzIHByb2JhYmx5IG5lZWRzIHRvIHJlbW92ZSBYRlNfUkVNT1ZFX1NQ
QUNFX1JFUyAodGhlIG1hY3JvKSByaWdodD8KWWVzLCBJIHRoaW5rIHRoYXQncyBvayB0byByZW1v
dmUgbm93LgoKPiAKPiBXaXRoIHRoYXQgZml4ZWQsCj4gUmV2aWV3ZWQtYnk6IERhcnJpY2sgSi4g
V29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+Cj4gCkdyZWF0LCB0aGFua3MgZm9yIHRoZSByZXZpZXdz
IQpBbGxpc29uCgo+IC0tRAo+IAo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19tb3VudMKg
wqDCoMKgwqDCoMKgwqAqbXAsCj4gPiArwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnTCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBuYW1lbGVuKQo+ID4gK3sKPiA+ICvCoMKgwqDCoMKgwqDCoHVuc2ln
bmVkIGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldCA9IFhGU19ESVJSRU1PVkVfU1BBQ0Vf
UkVTKG1wKTsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoGlmICh4ZnNfaGFzX3BhcmVudChtcCkp
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0ICs9IHhmc19wcHRyX2NhbGNf
c3BhY2VfcmVzKG1wLCBuYW1lbGVuKTsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBy
ZXQ7Cj4gPiArfQo+ID4gKwo+ID4gwqAvKgo+ID4gwqAgKiBSZW1vdmluZyBhbiBpbm9kZSBmcm9t
IHRoZSBuYW1lc3BhY2UgaW52b2x2ZXMgcmVtb3ZpbmcgdGhlCj4gPiBkaXJlY3RvcnkgZW50cnkK
PiA+IMKgICogYW5kIGRyb3BwaW5nIHRoZSBsaW5rIGNvdW50IG9uIHRoZSBpbm9kZS4gUmVtb3Zp
bmcgdGhlCj4gPiBkaXJlY3RvcnkgZW50cnkgY2FuCj4gPiBAQCAtMjUwMSwxNiArMjUxNCwxOCBA
QCB4ZnNfaXVucGluX3dhaXQoCj4gPiDCoCAqLwo+ID4gwqBpbnQKPiA+IMKgeGZzX3JlbW92ZSgK
PiA+IC3CoMKgwqDCoMKgwqDCoHhmc19pbm9kZV90wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICpk
cCwKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDCoMKgKmRw
LAo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfbmFtZcKgwqDCoMKgwqDCoMKgwqDCoCpu
YW1lLAo+ID4gLcKgwqDCoMKgwqDCoMKgeGZzX2lub2RlX3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCppcCkKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDC
oMKgKmlwKQo+ID4gwqB7Cj4gPiAtwqDCoMKgwqDCoMKgwqB4ZnNfbW91bnRfdMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgKm1wID0gZHAtPmlfbW91bnQ7Cj4gPiAtwqDCoMKgwqDCoMKgwqB4ZnNf
dHJhbnNfdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqdHAgPSBOVUxMOwo+ID4gK8KgwqDCoMKg
wqDCoMKgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKgwqAqbXAgPSBkcC0+aV9tb3VudDsK
PiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfdHJhbnPCoMKgwqDCoMKgwqDCoMKgKnRwID0g
TlVMTDsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBpc19kaXIgPSBTX0lTRElSKFZGU19JKGlwKS0KPiA+ID5pX21vZGUpOwo+
ID4gwqDCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGRvbnRjYXJlOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZXJyb3IgPSAwOwo+ID4gwqDCoMKgwqDCoMKgwqDCoHVp
bnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVzYmxrczsKPiA+ICvC
oMKgwqDCoMKgwqDCoHhmc19kaXIyX2RhdGFwdHJfdMKgwqDCoMKgwqDCoGRpcl9vZmZzZXQ7Cj4g
PiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3BhcmVudF9kZWZlcsKgKnBhcmVudCA9IE5VTEw7
Cj4gPiDCoAo+ID4gwqDCoMKgwqDCoMKgwqDCoHRyYWNlX3hmc19yZW1vdmUoZHAsIG5hbWUpOwo+
ID4gwqAKPiA+IEBAIC0yNTI1LDYgKzI1NDAsMTIgQEAgeGZzX3JlbW92ZSgKPiA+IMKgwqDCoMKg
wqDCoMKgwqBpZiAoZXJyb3IpCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdv
dG8gc3RkX3JldHVybjsKPiA+IMKgCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoeGZzX2hhc19wYXJl
bnQobXApKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNf
cGFyZW50X2luaXQobXAsICZwYXJlbnQpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGlmIChlcnJvcikKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgZ290byBzdGRfcmV0dXJuOwo+ID4gK8KgwqDCoMKgwqDCoMKgfQo+ID4gKwo+ID4g
wqDCoMKgwqDCoMKgwqDCoC8qCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogV2UgdHJ5IHRvIGdldCB0
aGUgcmVhbCBzcGFjZSByZXNlcnZhdGlvbiBmaXJzdCwgYWxsb3dpbmcKPiA+IGZvcgo+ID4gwqDC
oMKgwqDCoMKgwqDCoCAqIGRpcmVjdG9yeSBidHJlZSBkZWxldGlvbihzKSBpbXBseWluZyBwb3Nz
aWJsZSBibWFwCj4gPiBpbnNlcnQocykuwqAgSWYgd2UKPiA+IEBAIC0yNTM2LDEyICsyNTU3LDEy
IEBAIHhmc19yZW1vdmUoCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogdGhlIGRpcmVjdG9yeSBjb2Rl
IGNhbiBoYW5kbGUgYSByZXNlcnZhdGlvbmxlc3MgdXBkYXRlCj4gPiBhbmQgd2UgZG9uJ3QKPiA+
IMKgwqDCoMKgwqDCoMKgwqAgKiB3YW50IHRvIHByZXZlbnQgYSB1c2VyIGZyb20gdHJ5aW5nIHRv
IGZyZWUgc3BhY2UgYnkKPiA+IGRlbGV0aW5nIHRoaW5ncy4KPiA+IMKgwqDCoMKgwqDCoMKgwqAg
Ki8KPiA+IC3CoMKgwqDCoMKgwqDCoHJlc2Jsa3MgPSBYRlNfUkVNT1ZFX1NQQUNFX1JFUyhtcCk7
Cj4gPiArwqDCoMKgwqDCoMKgwqByZXNibGtzID0geGZzX3JlbW92ZV9zcGFjZV9yZXMobXAsIG5h
bWUtPmxlbik7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfdHJhbnNfYWxsb2NfZGly
KGRwLCAmTV9SRVMobXApLT50cl9yZW1vdmUsIGlwLAo+ID4gJnJlc2Jsa3MsCj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAmdHAsICZkb250Y2FyZSk7
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKSB7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoEFTU0VSVChlcnJvciAhPSAtRU5PU1BDKTsKPiA+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBnb3RvIHN0ZF9yZXR1cm47Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZ290byBkcm9wX2luY29tcGF0Owo+ID4gwqDCoMKgwqDCoMKgwqDCoH0KPiA+
IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiA+IEBAIC0yNTk1LDEyICsyNjE2LDE4IEBAIHhm
c19yZW1vdmUoCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKQo+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF90cmFuc19jYW5jZWw7Cj4gPiDCoAo+ID4gLcKg
wqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfZGlyX3JlbW92ZW5hbWUodHAsIGRwLCBuYW1lLCBpcC0+
aV9pbm8sCj4gPiByZXNibGtzLCBOVUxMKTsKPiA+ICvCoMKgwqDCoMKgwqDCoGVycm9yID0geGZz
X2Rpcl9yZW1vdmVuYW1lKHRwLCBkcCwgbmFtZSwgaXAtPmlfaW5vLAo+ID4gcmVzYmxrcywgJmRp
cl9vZmZzZXQpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChlcnJvcikgewo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBBU1NFUlQoZXJyb3IgIT0gLUVOT0VOVCk7Cj4gPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3RyYW5zX2NhbmNlbDsKPiA+IMKg
wqDCoMKgwqDCoMKgwqB9Cj4gPiDCoAo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHBhcmVudCkgewo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycm9yID0geGZzX3BhcmVudF9kZWZl
cl9yZW1vdmUodHAsIGRwLCBwYXJlbnQsCj4gPiBkaXJfb2Zmc2V0LCBpcCk7Cj4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF90cmFuc19jYW5jZWw7Cj4gPiAr
wqDCoMKgwqDCoMKgwqB9Cj4gPiArCj4gPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiA+IMKgwqDCoMKg
wqDCoMKgwqAgKiBJZiB0aGlzIGlzIGEgc3luY2hyb25vdXMgbW91bnQsIG1ha2Ugc3VyZSB0aGF0
IHRoZQo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqIHJlbW92ZSB0cmFuc2FjdGlvbiBnb2VzIHRvIGRp
c2sgYmVmb3JlIHJldHVybmluZyB0bwo+ID4gQEAgLTI2MjUsNiArMjY1Miw5IEBAIHhmc19yZW1v
dmUoCj4gPiDCoCBvdXRfdW5sb2NrOgo+ID4gwqDCoMKgwqDCoMKgwqDCoHhmc19pdW5sb2NrKGlw
LCBYRlNfSUxPQ0tfRVhDTCk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgeGZzX2l1bmxvY2soZHAsIFhG
U19JTE9DS19FWENMKTsKPiA+ICsgZHJvcF9pbmNvbXBhdDoKPiA+ICvCoMKgwqDCoMKgwqDCoGlm
IChwYXJlbnQpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZzX3BhcmVudF9j
YW5jZWwobXAsIHBhcmVudCk7Cj4gPiDCoCBzdGRfcmV0dXJuOgo+ID4gwqDCoMKgwqDCoMKgwqDC
oHJldHVybiBlcnJvcjsKPiA+IMKgfQo+ID4gLS0gCj4gPiAyLjI1LjEKPiA+IAoK
