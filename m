Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F07C5EB38B
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Sep 2022 23:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiIZVtg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Sep 2022 17:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiIZVtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2022 17:49:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCDEB14ED
        for <linux-xfs@vger.kernel.org>; Mon, 26 Sep 2022 14:49:26 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QKe0MW006207;
        Mon, 26 Sep 2022 21:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=uQ1cs2IN2QlBMR9gQ/e3MCcLHwFJri2FtuSl+f69Kwc=;
 b=UEnJ3zCchqLWlqRpcsT0Q/Qab8B8Gc8bW82teUq4WDVk9dvaTH0ln233ossWceHh+VX7
 5q34YaxwXyVoZrKRPgleB466G88cx1ds+ccDeio+BmzptVpvqdvOPU+4St9mOfX4kM41
 h96S3kvYCgSKXNqak9lg6/X4sv76GdcTc6AQ/oTADMzGHo+2927FU+VHGYt3KnQAd82V
 /97mJURofjbHQL5ClRjfeH96KQ0vSRbSQOThfhy1GO8+/21kxLTmEC6he7mrh+fQ8rHN
 PPhufE/vVFD7OwNmcr41Z9z6JZC7FDeGRE9GjcnJD08VJBgZYIOw5SE71lSDHQR2eNQh qg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13cy9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:49:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28QKPiHX019170;
        Mon, 26 Sep 2022 21:49:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvdnfjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 21:49:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HO2GSVK4qgUySCBB2vW7l6C4GLA2MKYUGANMF2IvbuvVMjfB1IneJiRRcuFTkIjDlDPU9VvBT2Y0t2jTdvhXuCU8ZpZtRSHBY6BXn6bQdprp/OBTwQCBFAakw0vhzIy7DdSsRdIisd8cAV90+6oDXrXabr2GuMCde72NfDtaFyLUTLHRbi+Gqw+k200GLKj96CvvFj/k65xdFa5/OCAJGXrZqzptXAGmrp9Fet3TSrMv/4Mc0GdJdDcRSbslC1Sj8AzGR38Ap5uzWFVXujs4nIltBPPTYQuGrTD4LMkSoZGydMds05Tx1H7Z31bXXQom5TEtUaDesouFcjS34DVJ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQ1cs2IN2QlBMR9gQ/e3MCcLHwFJri2FtuSl+f69Kwc=;
 b=bD3J12ZFrzYQWH9n4x0sZJf4lD/iSXxUax630Vyv5bJB7Gzze32GaqSenJL63QAhIYlRvFAnj8TKtPzd8F7YCKU9gFGBXuXERRQcet7N2c+wLO+ne0GEmcOC0wI1BGcjyTEDPlTvi2D8zllp6jyOCCgV6udY7DcuGcZ+MAHt0PALbTU10D88kdVsMQXhVZwPAYMd6zooTyI6CKGT62BgO+vCGnvAJWZD5fkWhruttli8yfpWGxkOiIYrypZs36oCpT4m8Vad3niPUjwyYZVTAqrW3JNzmMqZCqDYsnpc1bZaXbpX6qdavmNTJqqDSuxXHG1zpLFOFx7kP9Io6M4pOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQ1cs2IN2QlBMR9gQ/e3MCcLHwFJri2FtuSl+f69Kwc=;
 b=eCdxEE/lmO2NAYWMCHCPeLqGN9/YsD8Y4CTNzdagyWj0OFQPlWSgIjgIcf2o0F9gWFmj94Xr8qfLcSxPjODAcc1pOfmJGTYX0gYLZ/NIIGksYGnd9bBOpvVeBqC4lgu6Qt//B2U80PVW/+uH/RH0Ez6xyxCoUQsiuATBhtFxcXg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4689.namprd10.prod.outlook.com (2603:10b6:303:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 26 Sep
 2022 21:49:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 21:49:19 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 17/26] xfs: remove parent pointers in unlink
Thread-Topic: [PATCH v3 17/26] xfs: remove parent pointers in unlink
Thread-Index: AQHYzkaDm5rupAGbeE2vahBCWvJB+q3tiJgAgAS+ggA=
Date:   Mon, 26 Sep 2022 21:49:19 +0000
Message-ID: <a2bc3b04d94037802001995ca5b4b36702c831bb.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-18-allison.henderson@oracle.com>
         <Yy4jkMAy20T3LIfs@magnolia>
In-Reply-To: <Yy4jkMAy20T3LIfs@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CO1PR10MB4689:EE_
x-ms-office365-filtering-correlation-id: 8530d266-3b16-4425-fe42-08daa008f724
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GbvXtR5W9LsdmdGUX2unII6KwDJgz9f7nDhwJnWMzsNOHKeGWi/W66u7l/ApWKMwHGaOkBDMtKZNA2uZrAKORQR3+PuqfLGQFT8cSnoP1eISYboP0Y2f86iSDTbvpT0jK/ATmmbmcy9sHck1D6fP2EJw80/HRTmOwQNmz7x4wkflGkLUf4AEad1sx21EZpNr52EBlkhmyqxhQta3GdZ2IvvK7kggOAI86hPVcwILoLL/TdpS4XUihp/irs7/8gL2s/gsV2Fj8z58jkbaa2X9cpQtXoJEtUEGG+jL/eVVNhvnAVAECLvQNu5mDu4s2q7RROLWh938rCPml/Yhfj8luTHtV96x0gr/kVzcWAYKIhlobMsLXu47FxIZHde0FETccQjtc491IKOdKZEhJ83wXgBcZKe339MWbzgBDnA7cAjbpV5qC55jaqaL3lWaBjJfRtMHFuizPJlK3iwbb+9jd4nNs0TzCtE36NbkgOFhdjhAMp+OIscsZ4+rXMpxZKRmV+tH7iZTFz5y9yP0uaz/+TUqB+1fx8xTdE13+fp5WFJFOJc55EXbVj0YhDPkm0YeN0jkDrViMJvqrO1rNeBMSl+kNBpMq1tHja9MLTVP8qAM4KzPUFrnFoznd4lQ1Eegz9ZP2LuuIlpPEF1lJ6lXpWcM+pg+Ila4OxLlreQpgXhA4JDP3PzESLRF6DG+Vnlw8AfX1k3w0vhw16ACQN/vfdtaEo1n090yNkZZ9ihuiN9Pl47V6s29sNvT2p8nDFanL63+gPhbeqfDuO1rxUZEOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(122000001)(2616005)(36756003)(2906002)(186003)(86362001)(44832011)(8936002)(38070700005)(6512007)(64756008)(66446008)(66476007)(66556008)(41300700001)(26005)(4326008)(8676002)(66946007)(76116006)(5660300002)(83380400001)(316002)(6506007)(6916009)(478600001)(6486002)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alAwcnN2SzVUNGF3cGxOY1h4cjREcWpUd09ZekNlM1RFUE5oMGV6OCtsc2FD?=
 =?utf-8?B?cndqZFJoeVhQM2R3S1IzTVozd3lGY3ZlM2ptR090SG5ldlF5cFZmVzF1TWVN?=
 =?utf-8?B?VnZWOUNtYTBBdDRIZTJnQTljdlliWWtLMnRhWTNhb0Rleks0UWtPWkY2V1pK?=
 =?utf-8?B?RXd3a3RTWTZBQzhCVEwzMk0xUFk2RGxpMkd0SWoxSlBUUGVmbXBXYXNNbVZR?=
 =?utf-8?B?TzFGaFFHL2VOU3pzWGZaNkhLallBTVV0Yithd1JuN1dJSW1RWUFrNlBEb214?=
 =?utf-8?B?TDFiUldaYlRtRVdGbkhWZVl5ZnpJM2VLY2NmMU5KM2RjMzl6NTdHa01sbXBw?=
 =?utf-8?B?bk9tVW1XS3gwSjJIL2ExV09tdzh5WWYzK3pPMnZwdElyd0ppK0pBVjZ6d3NU?=
 =?utf-8?B?SjUwWmFabUhDQmVYK00rV0JTdTdaQVdwbHFGajVwVitHdEdPVkhrWURqbThM?=
 =?utf-8?B?YlVTMVBHNXM0cDBLeEhTWklkSWZXbWxDVmJrM0F1RTMxeWhsVDcyLzQwd2NC?=
 =?utf-8?B?R2UrT1g3YjMyMm9tTHB2U0tFTGJOYXo2MEU5bjZGU2t2emZ0czhpOUtCZEZQ?=
 =?utf-8?B?alN5UDZSUUFFbExHbjJoYlJuQnJZMkFEVkxubU0xWUo3aXpHQy9ySEtmTFpX?=
 =?utf-8?B?elcyRWd3dkk1TWhkRitlczVsZFVjZWVEN0x1Y2JFcG1uMWFRZFM5OFhXVCtL?=
 =?utf-8?B?UGhRWTRsOXNCaThINFRyV084c3RuRmpxWVJPZWZPWW1Ld1RjR3A3YUZEQnZC?=
 =?utf-8?B?ZG9WbllERXVCWlQwbTFpazZTUFVOZHN2cXRZVW51ZlBlU1ppeFNxTEJmaWlU?=
 =?utf-8?B?Y2ZzTkxNdnd3ZkVhOVJKV3Z0Y3FtS2d5T1VEZzNoWjMyQWZtSlN0bVBrckFC?=
 =?utf-8?B?ZWJOeiswRlJpeHRMd2cvRlRXYzVOMkNydm1VWWkvMk5GNDVubkEzM21rcmM0?=
 =?utf-8?B?ZzJXbXhPbSsyaDNtS1RBMU43azI4alpnVk85OUo1Vks2L2lFelpROGluL2R6?=
 =?utf-8?B?OVIzbGY2SmN0VFIzRStVNzhLNTAwekFjNnV0dVVjcFZMbkxnUFBhSC96UXF6?=
 =?utf-8?B?eFdZdzJJWFpNNU9iK0Y1OHA4dXBSazZaY1IvcXNQZUZMWjREOTNURmcvTVpU?=
 =?utf-8?B?ZHR1MUN1NEJMaTlqOE5wTVR6MVBsVkZRYTYzL0F6dzFxd25JWWxUWU9NODA1?=
 =?utf-8?B?UGs2cFIvUWZ2SGNxVFZleGxXOGRPZ3pjcHBFVk9GK0F2c2tvQlNlOVd5RFQy?=
 =?utf-8?B?M3Z3ZlZSdit3aTM5T2gzdTh2cUJZSkNyd01IbVN4U29DbzVKQktzZldidW1J?=
 =?utf-8?B?MUMwMzBPc2k3Z29TVFlRRVFLU2JQMnh1ZmhvV1pwZWVNUkthSE4vVis3amhE?=
 =?utf-8?B?QjJvM2hBcndoa3BqUkRsME4xOXB4aHc2TGt6YmdkOGJ3T0dMTVFDQWx5aGpY?=
 =?utf-8?B?aUhic2o2T2lOdGhucGJlemppemVtRDFWajlJT2RIYjcrbmZzTDVPb2dnZ29X?=
 =?utf-8?B?eDF3cFNua0RDV01hMmtHbE9TemhMallJOVdVN1dFNHNvU2FZUVFyVkhMd2Q2?=
 =?utf-8?B?VVBYQ1dUaWY5S2hZZ2xHRHZodlE0RXIybHBPVDJ5U3BOK3FtY1VoeXVnSXly?=
 =?utf-8?B?MGJ0a1NUdHF1Nlp3eHViczRZSFJhSitQeUpiQ3VTOEtBWks2MitlbHozdllN?=
 =?utf-8?B?cHlZdC8xQXNtUHRzZHJyQ1R6R2pRcUZuZ2R2TDdRQWNaYS9FYVc2cGhjeDVE?=
 =?utf-8?B?YzZycVA1MUpaZURzYmN4MVVzaVhaQi9TN09teFFYcml1aFJTSkZOODFibW9N?=
 =?utf-8?B?OGo1ZVRkR3p1Vzg0Yk1pVWVOMFJQSTVxN09PVUI4Z0VFd2poSzdaRmwwd0tN?=
 =?utf-8?B?WWc5SWpqblpzSVdDWE9VeG5aYnhRM2F1VXZ0S1pEU3RZcWdvZHRiUmI2Qnp1?=
 =?utf-8?B?bitxUG02eW03N3JLNFF1YnlVeTl2Qmp0NHlPM0tpRyt6T2g1N2VDdUZ1Vktn?=
 =?utf-8?B?M3RMRW01d3ByQXlLTWlmcDhNSGErNEI5Q0JiRWpCcUNpT1ltVzFGQWNpRHh6?=
 =?utf-8?B?Q0RXSDh5aWVvQjJLVVlBanJidUFGS1lKL2h3RUtTMy9aVDd6amMyWTVrUW5M?=
 =?utf-8?B?dllTSUVSZlZ5RlJqTVgzQ2tOcUdhd1J4M3l1ZmtnbEdjZjY2WEZWa2pGM2lt?=
 =?utf-8?B?UlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ADE29AC39D7B3E44BC3F4E7246DE8AB2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8530d266-3b16-4425-fe42-08daa008f724
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 21:49:19.2457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jZ+A2KhgPAlhUlhtVDR8jF+xf0mZWiDV5xu+5QO32JAbahYWWEf+FzufWg2JFa1Xzqk6vqB24mrxy0wBXORXzfT88jvvQ/K4p5+CEDcHdpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_10,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260134
X-Proofpoint-ORIG-GUID: -ZU54cFgPyi3oucVvUtmBfZfuZKQuwFY
X-Proofpoint-GUID: -ZU54cFgPyi3oucVvUtmBfZfuZKQuwFY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTIzIGF0IDE0OjIyIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgMTA6NDQ6NDlQTSAtMDcwMCwKPiBhbGxpc29uLmhl
bmRlcnNvbkBvcmFjbGUuY29twqB3cm90ZToKPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29uIDxh
bGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+ID4gCj4gPiBUaGlzIHBhdGNoIHJlbW92ZXMg
dGhlIHBhcmVudCBwb2ludGVyIGF0dHJpYnV0ZSBkdXJpbmcgdW5saW5rCj4gPiAKPiA+IFNpZ25l
ZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KPiA+IFNpZ25lZC1v
ZmYtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+
ID4gLS0tCj4gPiDCoGZzL3hmcy9saWJ4ZnMveGZzX2F0dHIuY8KgwqAgfMKgIDIgKy0KPiA+IMKg
ZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5owqDCoCB8wqAgMSArCj4gPiDCoGZzL3hmcy9saWJ4ZnMv
eGZzX3BhcmVudC5jIHwgMTcgKysrKysrKysrKysrKysrKysKPiA+IMKgZnMveGZzL2xpYnhmcy94
ZnNfcGFyZW50LmggfMKgIDQgKysrKwo+ID4gwqBmcy94ZnMveGZzX2lub2RlLmPCoMKgwqDCoMKg
wqDCoMKgIHwgMjkgKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0KPiA+IMKgNSBmaWxlcyBj
aGFuZ2VkLCA0NiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQo+ID4gCj4gPiBkaWZmIC0t
Z2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5jIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5j
Cj4gPiBpbmRleCA4MDVhYWE1NjM5ZDIuLmU5Njc3MjhkMWVlNyAxMDA2NDQKPiA+IC0tLSBhL2Zz
L3hmcy9saWJ4ZnMveGZzX2F0dHIuYwo+ID4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5j
Cj4gPiBAQCAtOTQ2LDcgKzk0Niw3IEBAIHhmc19hdHRyX2RlZmVyX3JlcGxhY2UoCj4gPiDCoH0K
PiA+IMKgCj4gPiDCoC8qIFJlbW92ZXMgYW4gYXR0cmlidXRlIGZvciBhbiBpbm9kZSBhcyBhIGRl
ZmVycmVkIG9wZXJhdGlvbiAqLwo+ID4gLXN0YXRpYyBpbnQKPiA+ICtpbnQKPiA+IMKgeGZzX2F0
dHJfZGVmZXJfcmVtb3ZlKAo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfZGFfYXJnc8Kg
wqDCoMKgwqDCoCphcmdzKQo+ID4gwqB7Cj4gPiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94
ZnNfYXR0ci5oIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5oCj4gPiBpbmRleCAwY2YyM2Y1MTE3
YWQuLjAzMzAwNTU0MmI5ZSAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2F0dHIu
aAo+ID4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNfYXR0ci5oCj4gPiBAQCAtNTQ1LDYgKzU0NSw3
IEBAIGJvb2wgeGZzX2F0dHJfaXNfbGVhZihzdHJ1Y3QgeGZzX2lub2RlICppcCk7Cj4gPiDCoGlu
dCB4ZnNfYXR0cl9nZXRfaWxvY2tlZChzdHJ1Y3QgeGZzX2RhX2FyZ3MgKmFyZ3MpOwo+ID4gwqBp
bnQgeGZzX2F0dHJfZ2V0KHN0cnVjdCB4ZnNfZGFfYXJncyAqYXJncyk7Cj4gPiDCoGludCB4ZnNf
YXR0cl9kZWZlcl9hZGQoc3RydWN0IHhmc19kYV9hcmdzICphcmdzKTsKPiA+ICtpbnQgeGZzX2F0
dHJfZGVmZXJfcmVtb3ZlKHN0cnVjdCB4ZnNfZGFfYXJncyAqYXJncyk7Cj4gPiDCoGludCB4ZnNf
YXR0cl9zZXQoc3RydWN0IHhmc19kYV9hcmdzICphcmdzKTsKPiA+IMKgaW50IHhmc19hdHRyX3Nl
dF9pdGVyKHN0cnVjdCB4ZnNfYXR0cl9pbnRlbnQgKmF0dHIpOwo+ID4gwqBpbnQgeGZzX2F0dHJf
cmVtb3ZlX2l0ZXIoc3RydWN0IHhmc19hdHRyX2ludGVudCAqYXR0cik7Cj4gPiBkaWZmIC0tZ2l0
IGEvZnMveGZzL2xpYnhmcy94ZnNfcGFyZW50LmMKPiA+IGIvZnMveGZzL2xpYnhmcy94ZnNfcGFy
ZW50LmMKPiA+IGluZGV4IGRkZGJmMDk2YTRiNS4uMzc4ZmEyMjdiODdmIDEwMDY0NAo+ID4gLS0t
IGEvZnMveGZzL2xpYnhmcy94ZnNfcGFyZW50LmMKPiA+ICsrKyBiL2ZzL3hmcy9saWJ4ZnMveGZz
X3BhcmVudC5jCj4gPiBAQCAtMTI0LDYgKzEyNCwyMyBAQCB4ZnNfcGFyZW50X2RlZmVyX2FkZCgK
PiA+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4geGZzX2F0dHJfZGVmZXJfYWRkKGFyZ3MpOwo+ID4g
wqB9Cj4gPiDCoAo+ID4gK2ludAo+ID4gK3hmc19wYXJlbnRfZGVmZXJfcmVtb3ZlKAo+ID4gK8Kg
wqDCoMKgwqDCoMKgc3RydWN0IHhmc190cmFuc8KgwqDCoMKgwqDCoMKgwqAqdHAsCj4gPiArwqDC
oMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2RlwqDCoMKgwqDCoMKgwqDCoCpkcCwKPiA+ICvCoMKg
wqDCoMKgwqDCoHN0cnVjdCB4ZnNfcGFyZW50X2RlZmVywqAqcGFyZW50LAo+ID4gK8KgwqDCoMKg
wqDCoMKgeGZzX2RpcjJfZGF0YXB0cl90wqDCoMKgwqDCoMKgZGlyb2Zmc2V0LAo+ID4gK8KgwqDC
oMKgwqDCoMKgc3RydWN0IHhmc19pbm9kZcKgwqDCoMKgwqDCoMKgwqAqY2hpbGQpCj4gPiArewo+
ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19kYV9hcmdzwqDCoMKgwqDCoMKgKmFyZ3MgPSAm
cGFyZW50LT5hcmdzOwo+ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgeGZzX2luaXRfcGFyZW50X25h
bWVfcmVjKCZwYXJlbnQtPnJlYywgZHAsIGRpcm9mZnNldCk7Cj4gPiArwqDCoMKgwqDCoMKgwqBh
cmdzLT50cmFucyA9IHRwOwo+ID4gK8KgwqDCoMKgwqDCoMKgYXJncy0+ZHAgPSBjaGlsZDsKPiA+
ICvCoMKgwqDCoMKgwqDCoGFyZ3MtPmhhc2h2YWwgPSB4ZnNfZGFfaGFzaG5hbWUoYXJncy0+bmFt
ZSwgYXJncy0+bmFtZWxlbik7Cj4gPiArwqDCoMKgwqDCoMKgwqByZXR1cm4geGZzX2F0dHJfZGVm
ZXJfcmVtb3ZlKGFyZ3MpOwo+ID4gK30KPiA+ICsKPiA+IMKgdm9pZAo+ID4gwqB4ZnNfcGFyZW50
X2NhbmNlbCgKPiA+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfbW91bnRfdMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgKm1wLAo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9saWJ4ZnMveGZzX3BhcmVudC5o
Cj4gPiBiL2ZzL3hmcy9saWJ4ZnMveGZzX3BhcmVudC5oCj4gPiBpbmRleCA5NzEwNDQ0NThmOGEu
Ljc5ZDNmYWJiNWU1NiAxMDA2NDQKPiA+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX3BhcmVudC5o
Cj4gPiArKysgYi9mcy94ZnMvbGlieGZzL3hmc19wYXJlbnQuaAo+ID4gQEAgLTI3LDYgKzI3LDEw
IEBAIGludCB4ZnNfcGFyZW50X2luaXQoeGZzX21vdW50X3QgKm1wLCBzdHJ1Y3QKPiA+IHhmc19w
YXJlbnRfZGVmZXIgKipwYXJlbnRwKTsKPiA+IMKgaW50IHhmc19wYXJlbnRfZGVmZXJfYWRkKHN0
cnVjdCB4ZnNfdHJhbnMgKnRwLCBzdHJ1Y3QKPiA+IHhmc19wYXJlbnRfZGVmZXIgKnBhcmVudCwK
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1
Y3QgeGZzX2lub2RlICpkcCwgc3RydWN0IHhmc19uYW1lCj4gPiAqcGFyZW50X25hbWUsCj4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgeGZzX2RpcjJf
ZGF0YXB0cl90IGRpcm9mZnNldCwgc3RydWN0Cj4gPiB4ZnNfaW5vZGUgKmNoaWxkKTsKPiA+ICtp
bnQgeGZzX3BhcmVudF9kZWZlcl9yZW1vdmUoc3RydWN0IHhmc190cmFucyAqdHAsIHN0cnVjdCB4
ZnNfaW5vZGUKPiA+ICpkcCwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCB4ZnNfcGFyZW50X2RlZmVyICpwYXJlbnQsCj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB4ZnNf
ZGlyMl9kYXRhcHRyX3QgZGlyb2Zmc2V0LAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHhmc19pbm9kZSAqY2hpbGQpOwo+ID4g
wqB2b2lkIHhmc19wYXJlbnRfY2FuY2VsKHhmc19tb3VudF90ICptcCwgc3RydWN0IHhmc19wYXJl
bnRfZGVmZXIKPiA+ICpwYXJlbnQpOwo+ID4gwqAKPiA+IMKgI2VuZGlmwqAvKiBfX1hGU19QQVJF
TlRfSF9fICovCj4gPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19pbm9kZS5jIGIvZnMveGZzL3hm
c19pbm9kZS5jCj4gPiBpbmRleCBhZjNmNWVkYjczMTkuLjFhMzVkYzk3MmQ0ZCAxMDA2NDQKPiA+
IC0tLSBhL2ZzL3hmcy94ZnNfaW5vZGUuYwo+ID4gKysrIGIvZnMveGZzL3hmc19pbm9kZS5jCj4g
PiBAQCAtMjQ2NSwxNiArMjQ2NSwxOCBAQCB4ZnNfaXVucGluX3dhaXQoCj4gPiDCoCAqLwo+ID4g
wqBpbnQKPiA+IMKgeGZzX3JlbW92ZSgKPiA+IC3CoMKgwqDCoMKgwqDCoHhmc19pbm9kZV90wqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICpkcCwKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNf
aW5vZGXCoMKgwqDCoMKgwqDCoMKgKmRwLAo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNf
bmFtZcKgwqDCoMKgwqDCoMKgwqDCoCpuYW1lLAo+ID4gLcKgwqDCoMKgwqDCoMKgeGZzX2lub2Rl
X3TCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCppcCkKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVj
dCB4ZnNfaW5vZGXCoMKgwqDCoMKgwqDCoMKgKmlwKQo+ID4gwqB7Cj4gPiAtwqDCoMKgwqDCoMKg
wqB4ZnNfbW91bnRfdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKm1wID0gZHAtPmlfbW91bnQ7
Cj4gPiAtwqDCoMKgwqDCoMKgwqB4ZnNfdHJhbnNfdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAq
dHAgPSBOVUxMOwo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDC
oMKgwqAqbXAgPSBkcC0+aV9tb3VudDsKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfdHJh
bnPCoMKgwqDCoMKgwqDCoMKgKnRwID0gTlVMTDsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpbnTCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpc19kaXIgPSBTX0lTRElSKFZG
U19JKGlwKS0KPiA+ID5pX21vZGUpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGludMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRvbnRjYXJlOwo+ID4gwqDCoMKgwqDCoMKg
wqDCoGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZXJyb3IgPSAw
Owo+ID4gwqDCoMKgwqDCoMKgwqDCoHVpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmVzYmxrczsKPiA+ICvCoMKgwqDCoMKgwqDCoHhmc19kaXIyX2RhdGFwdHJfdMKg
wqDCoMKgwqDCoGRpcl9vZmZzZXQ7Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3BhcmVu
dF9kZWZlcsKgKnBhcmVudCA9IE5VTEw7Cj4gPiDCoAo+ID4gwqDCoMKgwqDCoMKgwqDCoHRyYWNl
X3hmc19yZW1vdmUoZHAsIG5hbWUpOwo+ID4gwqAKPiA+IEBAIC0yNDg5LDYgKzI0OTEsMTIgQEAg
eGZzX3JlbW92ZSgKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gc3RkX3JldHVybjsKPiA+IMKgCj4gPiArwqDCoMKg
wqDCoMKgwqBpZiAoeGZzX2hhc19wYXJlbnQobXApKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfcGFyZW50X2luaXQobXAsICZwYXJlbnQpOwo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChlcnJvcikKPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBzdGRfcmV0dXJuOwo+ID4gK8Kg
wqDCoMKgwqDCoMKgfQo+ID4gKwo+ID4gwqDCoMKgwqDCoMKgwqDCoC8qCj4gPiDCoMKgwqDCoMKg
wqDCoMKgICogV2UgdHJ5IHRvIGdldCB0aGUgcmVhbCBzcGFjZSByZXNlcnZhdGlvbiBmaXJzdCwg
YWxsb3dpbmcKPiA+IGZvcgo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqIGRpcmVjdG9yeSBidHJlZSBk
ZWxldGlvbihzKSBpbXBseWluZyBwb3NzaWJsZSBibWFwCj4gPiBpbnNlcnQocykuwqAgSWYgd2UK
PiAKPiBTYW1lIHRoaW5nIGhlcmU6Cj4gCj4gdW5zaWduZWQgaW50Cj4geGZzX3JlbW92ZV9zcGFj
ZV9yZXMoCj4gwqDCoMKgwqDCoMKgwqAgc3RydWN0IHhmc19tb3VudMKgwqDCoMKgwqDCoMKgICpt
cCwKPiDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5h
bWVsZW4pCj4gewo+IMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGludMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0ID0gWEZTX0RJUlJFTU9WRV9TUEFDRV9SRVMobXApOwo+IAo+IMKgwqDCoMKgwqDC
oMKgIGlmICh4ZnNfaGFzX3BhcmVudChtcCkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHJldCArPSB4ZnNfcHB0cl9jYWxjX3NwYWNlX3JlcyhtcCwgbmFtZWxlbik7Cj4gCj4gwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIHJldDsKPiB9Cj4gCj4geGZzX3JlbW92ZSguLikKPiB7Cj4gwqDC
oMKgwqDCoMKgwqDCoC8qIC4uLiAqLwo+IAo+IMKgwqDCoMKgwqDCoMKgwqByZXNibGtzID0geGZz
X3JlbW92ZV9zcGFjZV9yZXMobXAsIG5hbWUtPmxlbik7Cj4gwqDCoMKgwqDCoMKgwqDCoGVycm9y
ID0geGZzX3RyYW5zX2FsbG9jX2RpcihkcCwgJk1fUkVTKG1wKS0+dHJfcmVtb3ZlLCBpcCwKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAmcmVzYmxrcywg
JnRwLCAmZG9udGNhcmUpOwo+IMKgwqDCoMKgwqDCoMKgwqAvKiByZW1vdmFsIGNvZGUuLi4gKi8K
PiB9CgpPaywgd2lsbCBhZGQgdGhlc2UgaGVscGVycyB0b28uICBUaGFua3MhCkFsbGlzb24KCj4g
Cj4gLS1ECj4gCj4gPiBAQCAtMjUwNSw3ICsyNTEzLDcgQEAgeGZzX3JlbW92ZSgKPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCZ0cCwgJmRvbnRjYXJl
KTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgQVNTRVJUKGVycm9yICE9IC1FTk9TUEMpOwo+ID4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gc3RkX3JldHVybjsKPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBnb3RvIGRyb3BfaW5jb21wYXQ7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgfQo+
ID4gwqAKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKgo+ID4gQEAgLTI1NTksMTIgKzI1NjcsMTggQEAg
eGZzX3JlbW92ZSgKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3RyYW5zX2NhbmNlbDsKPiA+IMKgCj4gPiAt
wqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19kaXJfcmVtb3ZlbmFtZSh0cCwgZHAsIG5hbWUsIGlw
LT5pX2lubywKPiA+IHJlc2Jsa3MsIE5VTEwpOwo+ID4gK8KgwqDCoMKgwqDCoMKgZXJyb3IgPSB4
ZnNfZGlyX3JlbW92ZW5hbWUodHAsIGRwLCBuYW1lLCBpcC0+aV9pbm8sCj4gPiByZXNibGtzLCAm
ZGlyX29mZnNldCk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGVycm9yKSB7Cj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoEFTU0VSVChlcnJvciAhPSAtRU5PRU5UKTsKPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXRfdHJhbnNfY2FuY2VsOwo+ID4g
wqDCoMKgwqDCoMKgwqDCoH0KPiA+IMKgCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAocGFyZW50KSB7
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfcGFyZW50X2Rl
ZmVyX3JlbW92ZSh0cCwgZHAsIHBhcmVudCwKPiA+IGRpcl9vZmZzZXQsIGlwKTsKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3RyYW5zX2NhbmNlbDsKPiA+
ICvCoMKgwqDCoMKgwqDCoH0KPiA+ICsKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKgo+ID4gwqDCoMKg
wqDCoMKgwqDCoCAqIElmIHRoaXMgaXMgYSBzeW5jaHJvbm91cyBtb3VudCwgbWFrZSBzdXJlIHRo
YXQgdGhlCj4gPiDCoMKgwqDCoMKgwqDCoMKgICogcmVtb3ZlIHRyYW5zYWN0aW9uIGdvZXMgdG8g
ZGlzayBiZWZvcmUgcmV0dXJuaW5nIHRvCj4gPiBAQCAtMjU4OSw2ICsyNjAzLDkgQEAgeGZzX3Jl
bW92ZSgKPiA+IMKgIG91dF91bmxvY2s6Cj4gPiDCoMKgwqDCoMKgwqDCoMKgeGZzX2l1bmxvY2so
aXAsIFhGU19JTE9DS19FWENMKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqB4ZnNfaXVubG9jayhkcCwg
WEZTX0lMT0NLX0VYQ0wpOwo+ID4gKyBkcm9wX2luY29tcGF0Ogo+ID4gK8KgwqDCoMKgwqDCoMKg
aWYgKHBhcmVudCkKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNfcGFyZW50
X2NhbmNlbChtcCwgcGFyZW50KTsKPiA+IMKgIHN0ZF9yZXR1cm46Cj4gPiDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIGVycm9yOwo+ID4gwqB9Cj4gPiAtLSAKPiA+IDIuMjUuMQo+ID4gCgo=
