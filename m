Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF27817E3D
	for <lists+linux-xfs@lfdr.de>; Wed,  8 May 2019 18:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfEHQkG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 May 2019 12:40:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbfEHQkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 May 2019 12:40:06 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48GUXGG017006;
        Wed, 8 May 2019 09:39:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=o64HvOJu7SRrAyBhLSqP68ufXaYaxzP7NBsSHPeQs7E=;
 b=T3MAsMDRI7oBUPWeyDwxWKtAEVt3hPKpX3Jtz4vg9pLKo7uLNKH29wtPK44Dnl4MLCyJ
 M8BY53lOJE7+wMkvLvD9phjiup/5wTKVeKEWWYTn+j3MvKECK6FuKIPtS2eTZgwUJa1V
 ccixVBQBI77vnRWaZXf1euAfejRBY/e/gKA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sc2prg141-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 May 2019 09:39:44 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 May 2019 09:39:42 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 May 2019 09:39:42 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 8 May 2019 09:39:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o64HvOJu7SRrAyBhLSqP68ufXaYaxzP7NBsSHPeQs7E=;
 b=AM41/qiout1BAs2Bxe6ALjC/mwk1BOCMNQ0LRRky5UKlUq9RHEGAlgdmveThA5DgkR9zEfEfzxN4QvyRkrXsjsobIQbMezp2hERFjpARna0ScH+mT13dio0ZoXl704ytaHl8g55SVak3jZnpzYxoNaSYtzDUFgG61m7+xXBWm5o=
Received: from DM5PR15MB1290.namprd15.prod.outlook.com (10.173.212.17) by
 DM5PR15MB1273.namprd15.prod.outlook.com (10.173.210.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Wed, 8 May 2019 16:39:41 +0000
Received: from DM5PR15MB1290.namprd15.prod.outlook.com
 ([fe80::6182:329:231e:af13]) by DM5PR15MB1290.namprd15.prod.outlook.com
 ([fe80::6182:329:231e:af13%5]) with mapi id 15.20.1878.019; Wed, 8 May 2019
 16:39:41 +0000
From:   Chris Mason <clm@fb.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     Rik van Riel <riel@surriel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] fs,xfs: fix missed wakeup on l_flush_wait
Thread-Topic: [PATCH] fs,xfs: fix missed wakeup on l_flush_wait
Thread-Index: AQHVBPcY/HUnN5riH06Iaueg4x5436ZgK/GAgAFDUoA=
Date:   Wed, 8 May 2019 16:39:41 +0000
Message-ID: <605BF0CA-EB32-46A5-8045-2BAB7EB0BD66@fb.com>
References: <20190507130528.1d3d471b@imladris.surriel.com>
 <20190507212213.GO29573@dread.disaster.area>
In-Reply-To: <20190507212213.GO29573@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.4r5594)
x-clientproxiedby: HK2PR03CA0063.apcprd03.prod.outlook.com
 (2603:1096:202:17::33) To DM5PR15MB1290.namprd15.prod.outlook.com
 (2603:10b6:3:b8::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c094:180::1:db0d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcca6d8e-6af1-446b-6003-08d6d3d3c441
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM5PR15MB1273;
x-ms-traffictypediagnostic: DM5PR15MB1273:
x-microsoft-antispam-prvs: <DM5PR15MB1273F583AA6D4E554B7516DDD3320@DM5PR15MB1273.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(366004)(396003)(189003)(199004)(86362001)(2906002)(54906003)(68736007)(14454004)(6916009)(6246003)(36756003)(4326008)(25786009)(316002)(8936002)(81156014)(81166006)(8676002)(6436002)(50226002)(186003)(7736002)(46003)(229853002)(305945005)(476003)(486006)(446003)(11346002)(6512007)(2616005)(6486002)(33656002)(66476007)(66556008)(64756008)(66446008)(478600001)(71190400001)(71200400001)(66946007)(82746002)(83716004)(76176011)(52116002)(73956011)(6506007)(386003)(5660300002)(53546011)(102836004)(99286004)(6116002)(256004)(14444005)(53936002)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1273;H:DM5PR15MB1290.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 15FAq5z3LpLQMoVrMMmhwzcn4S9lGlVJi0saiaLzAzGl6tbDchHMIQ0S9AyoMOHRnO/WtRJSDv1SshalxcqYrmwXT8rsRmA50MF764jNoFPq6CDKISMLjBXVYOYb/b2v64gUn8XKeCdstPaMKbrh4PhO0s79kHtzpwKqmFR4CI9OfEuEldhh9lge8+wf/ag/xadwdfL0XV2iu2J28fyK74V+/J/HA/7/BygoEoWFvvDjeiHl5WCBdt4jacv9RtVa0PuR+CH0XxIu0u3kD9F2Fs+160qDWjvuGp2X22GG8+dES/3KeJLTD7LiYjqARrE6Y4WN6lh6siOPWHANVR4NJoTN0//SuhwUSe7RFZqJkrRkcn4h0I2mUB/7pUdqQaYjGN0FxRKNVDtrQGji89vP0Cpagd9xoFOcp9D2Vb95u9w=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dcca6d8e-6af1-446b-6003-08d6d3d3c441
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 16:39:41.1099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1273
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080102
X-FB-Internal: deliver
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gNyBNYXkgMjAxOSwgYXQgMTc6MjIsIERhdmUgQ2hpbm5lciB3cm90ZToNCg0KPiBPbiBUdWUs
IE1heSAwNywgMjAxOSBhdCAwMTowNToyOFBNIC0wNDAwLCBSaWsgdmFuIFJpZWwgd3JvdGU6DQo+
PiBUaGUgY29kZSBpbiB4bG9nX3dhaXQgdXNlcyB0aGUgc3BpbmxvY2sgdG8gbWFrZSBhZGRpbmcg
dGhlIHRhc2sgdG8NCj4+IHRoZSB3YWl0IHF1ZXVlLCBhbmQgc2V0dGluZyB0aGUgdGFzayBzdGF0
ZSB0byBVTklOVEVSUlVQVElCTEUgYXRvbWljDQo+PiB3aXRoIHJlc3BlY3QgdG8gdGhlIHdha2Vy
Lg0KPj4NCj4+IERvaW5nIHRoZSB3YWtldXAgYWZ0ZXIgcmVsZWFzaW5nIHRoZSBzcGlubG9jayBv
cGVucyB1cCB0aGUgZm9sbG93aW5nDQo+PiByYWNlIGNvbmRpdGlvbjoNCj4+DQo+PiAtIGFkZCB0
YXNrIHRvIHdhaXQgcXVldWUNCj4+DQo+PiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB3YWtlIHVwIHRhc2sNCj4+DQo+PiAtIHNldCB0YXNrIHN0YXRlIHRvIFVOSU5URVJS
VVBUSUJMRQ0KPj4NCj4+IFNpbXBseSBtb3ZpbmcgdGhlIHNwaW5fdW5sb2NrIHRvIGFmdGVyIHRo
ZSB3YWtlX3VwX2FsbCByZXN1bHRzDQo+PiBpbiB0aGUgd2FrZXIgbm90IGJlaW5nIGFibGUgdG8g
c2VlIGEgdGFzayBvbiB0aGUgd2FpdHF1ZXVlIGJlZm9yZQ0KPj4gaXQgaGFzIHNldCBpdHMgc3Rh
dGUgdG8gVU5JTlRFUlJVUFRJQkxFLg0KPg0KPiBZdXAsIHNlZW1zIGxpa2UgYW4gaXNzdWUuIEdv
b2QgZmluZCwgUmlrLg0KPg0KPiBTbywgd2hhdCBwcm9ibGVtIGlzIHRoaXMgYWN0dWFsbHkgZml4
aW5nPyBXYXMgaXQgbm90aWNlZCBieQ0KPiBpbnNwZWN0aW9uLCBvciBpcyBpdCBhY3R1YWxseSBt
YW5pZmVzdGluZyBvbiBwcm9kdWN0aW9uIG1hY2hpbmVzPw0KPiBJZiBpdCBpcyBtYW5pZmVzdGlu
ZyBJUkwsIHdoYXQgYXJlIHRoZSBzeW1wdG9tcyAoZS5nLiBoYW5nIHJ1bm5pbmcNCj4gb3V0IG9m
IGxvZyBzcGFjZT8pIGFuZCBkbyB5b3UgaGF2ZSBhIHRlc3QgY2FzZSBvciBhbnkgd2F5IHRvDQo+
IGV4ZXJjaXNlIGl0IGVhc2lseT8NCg0KVGhlIHN0ZXBzIHRvIHJlcHJvZHVjZSBhcmUgc2VtaS1j
b21wbGljYXRlZCwgdGhleSBjcmVhdGUgYSBidW5jaCBvZiANCmZpbGVzLCBkbyBzdHVmZiwgYW5k
IHRoZW4gZGVsZXRlIGFsbCB0aGUgZmlsZXMgaW4gYSBsb29wLiAgSSB0aGluayB0aGV5IA0Kc2hv
dGd1bm5lZCBpdCBhY3Jvc3MgNTAwIG9yIHNvIG1hY2hpbmVzIHRvIHRyaWdnZXIgNSB0aW1lcywg
YW5kIHRoZW4gDQpsZWZ0IHRoZSB3cmVja2FnZSBmb3IgdXMgdG8gcG9rZSBhdC4NCg0KVGhlIHN5
bXB0b21zIHdlcmUgaWRlbnRpY2FsIHRvIHRoZSBidWcgZml4ZWQgaGVyZToNCg0KY29tbWl0IDY5
NmE1NjIwNzJlM2MxNGJjZDEzYWU1YWNjMTljZGYyNzY3OWU4NjUNCkF1dGhvcjogQnJpYW4gRm9z
dGVyIDxiZm9zdGVyQHJlZGhhdC5jb20+DQpEYXRlOiAgIFR1ZSBNYXIgMjggMTQ6NTE6NDQgMjAx
NyAtMDcwMA0KDQp4ZnM6IHVzZSBkZWRpY2F0ZWQgbG9nIHdvcmtlciB3cSB0byBhdm9pZCBkZWFk
bG9jayB3aXRoIGNpbCB3cQ0KDQpCdXQgc2luY2Ugb3VyIDQuMTYga2VybmVsIGlzIG5ldyB0aGFu
IHRoYXQsIEkgYnJpZWZseSBob3BlZCB0aGF0IA0KbV9zeW5jX3dvcmtxdWV1ZSBuZWVkZWQgdG8g
YmUgZmxhZ2dlZCB3aXRoIFdRX01FTV9SRUNMQUlNLiAgSSBkb24ndCBoYXZlIA0KYSBncmVhdCBw
aWN0dXJlIG9mIGhvdyBhbGwgb2YgdGhlc2Ugd29ya3F1ZXVlcyBpbnRlcmFjdCwgYnV0IEkgZG8g
dGhpbmsgDQppdCBuZWVkcyBXUV9NRU1fUkVDTEFJTS4gIEl0IGNhbid0IGJlIHRoZSBjYXVzZSBv
ZiB0aGlzIGRlYWRsb2NrLCB0aGUgDQp3b3JrcXVldWUgd2F0Y2hkb2cgd291bGQgaGF2ZSBmaXJl
ZC4NCg0KUmlrIG1lbnRpb25lZCB0aGF0IEkgZm91bmQgc2xlZXBpbmcgcHJvY3Mgd2l0aCBhbiBl
bXB0eSBpY2xvZyB3YWl0cXVldWUgDQpsaXN0LCB3aGljaCBpcyB3aGVuIGhlIG5vdGljZWQgdGhp
cyByYWNlLiAgV2Ugc2VudCBhIHdha2V1cCB0byB0aGUgDQpzbGVlcGluZyBwcm9jZXNzLCBhbmQg
ZnRyYWNlIHNob3dlZCB0aGUgcHJvY2VzcyBsb29waW5nIGJhY2sgYXJvdW5kIHRvIA0Kc2xlZXAg
b24gdGhlIGljbG9nIGFnYWluLiAgTG9uZyBzdG9yeSBzaG9ydCwgUmlrJ3MgcGF0Y2ggZGVmaW5p
dGVseSANCndvdWxkbid0IGhhdmUgcHJldmVudGVkIHRoZSBkZWFkbG9jaywgYW5kIHRoZSBpY2xv
ZyB3YWl0cXVldWUgSSB3YXMgDQpwb2tpbmcgbXVzdCBub3QgaGF2ZSBiZWVuIHRoZSBzYW1lIG9u
ZSB0aGF0IHByb2Nlc3Mgd2FzIHNsZWVwaW5nIG9uLg0KDQpUaGUgYWN0dWFsIHByb2JsZW0gZW5k
ZWQgdXAgYmVpbmcgdGhlIGJsa21xIElPIHNjaGVkdWxlcnMgc2l0dGluZyBvbiBhIA0KcmVxdWVz
dC4gIFN3aXRjaGluZyBzY2hlZHVsZXJzIG1ha2VzIHRoZSBib3ggY29tZSBiYWNrIHRvIGxpZmUs
IHNvIGl0J3MgDQplaXRoZXIgYSBreWJlciBidWcgb3Igc2xpZ2h0bHkgaGlnaGVyIHVwIGluIGJs
a21xbGFuZC4NCg0KVGhhdCdzIGEgaHVnZSB0YW5nZW50IGFyb3VuZCBhY2tpbmcgUmlrJ3MgcGF0
Y2gsIGJ1dCBpdCdzIGhhcmQgdG8gYmUgDQpzdXJlIGlmIHdlJ3ZlIGhpdCB0aGUgbG9zdCB3YWtl
dXAgaW4gcHJvZC4gIEkgY291bGQgc2VhcmNoIHRocm91Z2ggYWxsIA0KdGhlIHJlbGF0ZWQgaHVu
ZyB0YXNrIHRpbWVvdXRzLCBidXQgdGhleSBhcmUgcHJvYmFibHkgYWxsIHN0dWNrIGluIA0KYmxr
bXEuDQoNCkFja2VkLWJ1dC1JJ20tc3RpbGwtYmxhbWluZy1KZW5zLWJ5OiBDaHJpcyBNYXNvbiA8
Y2xtQGZiLmNvbT4NCg0KLWNocmlzDQo=
