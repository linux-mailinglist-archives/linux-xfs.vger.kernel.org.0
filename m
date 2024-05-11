Return-Path: <linux-xfs+bounces-8296-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CABA78C2F3A
	for <lists+linux-xfs@lfdr.de>; Sat, 11 May 2024 05:11:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 591BD1F2284E
	for <lists+linux-xfs@lfdr.de>; Sat, 11 May 2024 03:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A6224205;
	Sat, 11 May 2024 03:11:43 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0782212B95
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 03:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715397103; cv=none; b=QY9H2Jgwdd2eM1i3ohpQwfynFS4xYqEsshC+DCg1KE/Dbn/dUgBsICU274F+OMWjSPvF5M85vQG+Vw6gOrox14IWhepIpP/KYKwLFfIhnRUOZR1rrsXcLOG8E/Gd/xzMCfl743Wg2eVrUVAFw7Medq+PbNd8EVVOnKjScs7UZ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715397103; c=relaxed/simple;
	bh=6IlaphAKZlSYpalXeT4AqUBDfuVal5duq12iaViZmmI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ic0wzh/5Y4I4iEQPvB1F28gDcIqB37MmZZz5270U6qXyo7GcP1nIentFDoPaTOlmddMW8uH1GT11Y6JhqlPLFRocDCIouSMYWB2QIfmKNu9vYDdhI+IjuLjT6SQio2korkZuuGHX1NT2ZAEsTk34fmUAVbWGgH1Qdrx6Q/ybzSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VbrPW4cqHz4f3jR6
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 11:11:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 179A11A016E
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 11:11:36 +0800 (CST)
Received: from [10.174.179.80] (unknown [10.174.179.80])
	by APP2 (Coremail) with SMTP id Syh0CgDnCw_k4T5mcIKHMg--.56225S3;
	Sat, 11 May 2024 11:11:34 +0800 (CST)
Subject: Re: [BUG REPORT] generic/561 fails when testing xfs on next-20240506
 kernel
To: Chandan Babu R <chandanbabu@kernel.org>,
 Dave Chinner <david@fromorbit.com>, djwong@kernel.org,
 Christoph Hellwig <hch@infradead.org>
Cc: brauner@kernel.org, Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <87ttj8ircu.fsf@debian-BULLSEYE-live-builder-AMD64>
From: Zhang Yi <yi.zhang@huaweicloud.com>
Message-ID: <6c2c5235-d19e-202c-67cf-2609db932d5a@huaweicloud.com>
Date: Sat, 11 May 2024 11:11:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <87ttj8ircu.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: base64
X-CM-TRANSID:Syh0CgDnCw_k4T5mcIKHMg--.56225S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtw45Cr18ur43tr18Ar4xZwb_yoWxAr45pF
	y8JF1UXr1Utw1UJr1UJrnrJFyUGr1rJr1UXr1UGr1UJr1UAr1UJr4jqr1UJr1UJr1UJr15
	Jr1DJryUJr1UJFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9jb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFcxC0VAYjxAxZF0Ew4CEw7xC0wCYjI0SjxkI62AI
	1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWU
	twCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UMVCEFcxC0VAYjxAxZFUvcSsGvf
	C2KfnxnUUI43ZEXa7IU1I385UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

T24gMjAyNC81LzggMTc6MDEsIENoYW5kYW4gQmFidSBSIHdyb3RlOg0KPiBIaSwNCj4gDQo+
IGdlbmVyaWMvNTYxIGZhaWxzIHdoZW4gdGVzdGluZyBYRlMgb24gYSBuZXh0LTIwMjQwNTA2
IGtlcm5lbCBhcyBzaG93biBiZWxvdywNCj4gDQo+ICMgLi9jaGVjayBnZW5lcmljLzU2MQ0K
PiBGU1RZUCAgICAgICAgIC0tIHhmcyAoZGVidWcpDQo+IFBMQVRGT1JNICAgICAgLS0gTGlu
dXgveDg2XzY0IHhmcy1jcmMtcnRkZXYtZXh0c2l6ZS0yOGsgNi45LjAtcmM3LW5leHQtMjAy
NDA1MDYrICMxIFNNUCBQUkVFTVBUX0RZTkFNSUMgTW9uIE1heSAgNiAwNzo1Mzo0NiBHTVQg
MjAyNA0KPiBNS0ZTX09QVElPTlMgIC0tIC1mIC1ycnRkZXY9L2Rldi9sb29wMTQgLWYgLW0g
cmVmbGluaz0wLHJtYXBidD0wLCAtZCBydGluaGVyaXQ9MSAtciBleHRzaXplPTI4ayAvZGV2
L2xvb3A1DQo+IE1PVU5UX09QVElPTlMgLS0gLW8gY29udGV4dD1zeXN0ZW1fdTpvYmplY3Rf
cjpyb290X3Q6czAgLW9ydGRldj0vZGV2L2xvb3AxNCAvZGV2L2xvb3A1IC9tZWRpYS9zY3Jh
dGNoDQo+IA0KPiBnZW5lcmljLzU2MSAgICAgICAtIG91dHB1dCBtaXNtYXRjaCAoc2VlIC92
YXIvbGliL3hmc3Rlc3RzL3Jlc3VsdHMveGZzLWNyYy1ydGRldi1leHRzaXplLTI4ay82Ljku
MC1yYzctbmV4dC0yMDI0MDUwNisveGZzX2NyY19ydGRldl9leHRzaXplXzI4ay9nZW5lcmlj
LzU2MS5vdXQuYmFkKQ0KPiAgICAgLS0tIHRlc3RzL2dlbmVyaWMvNTYxLm91dCAgIDIwMjQt
MDUtMDYgMDg6MTg6MDkuNjgxNDMwMzY2ICswMDAwDQo+ICAgICArKysgL3Zhci9saWIveGZz
dGVzdHMvcmVzdWx0cy94ZnMtY3JjLXJ0ZGV2LWV4dHNpemUtMjhrLzYuOS4wLXJjNy1uZXh0
LTIwMjQwNTA2Ky94ZnNfY3JjX3J0ZGV2X2V4dHNpemVfMjhrL2dlbmVyaWMvNTYxLm91dC5i
YWQgICAgICAgIDIwMjQtMDUtMDggMDk6MTQ6MjQuOTA4MDEwMTMzICswMDAwDQo+ICAgICBA
QCAtMSwyICsxLDUgQEANCj4gICAgICBRQSBvdXRwdXQgY3JlYXRlZCBieSA1NjENCj4gICAg
ICsvbWVkaWEvc2NyYXRjaC9kaXIvcDAvZDBYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWC9kNDg2
L2Q0YlhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYL2Q1YlhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWC9kMjEyWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWC9kMTFYWFhYWFhYWFgvZDU0L2RlNC9kMTU4L2QyN2Yv
ZDg5NS9kMTMwN1hYWC9kOGE0L2Q4MzJYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWC9yMTEyZlhYWFhYWFhYWFhYOiBGQUlMRUQNCj4gICAg
ICsvbWVkaWEvc2NyYXRjaC9kaXIvcDAvZDBYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWC9kNDg2
L2Q0YlhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYL2Q1YlhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWC9kMjEyWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWC9kMTFYWFhYWFhYWFgvZDU0L2RlNC9kMTU4L2QyN2Yv
ZDEzYTNYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWC9kMTNjMFhYWFhYWFhYL2QyMzAxWC9kMjIyYlhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYL2QxMjQwWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYL2Q3MjJYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYL2QxMzgwWFhY
WFhYWFhYWFhYWFhYWC9kYzYyWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY
WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFgvcjEwZDU6IEZBSUxFRA0KPiAgICAg
K21kNXN1bTogV0FSTklORzogMiBjb21wdXRlZCBjaGVja3N1bXMgZGlkIE5PVCBtYXRjaA0K
PiAgICAgIFNpbGVuY2UgaXMgZ29sZGVuDQo+ICAgICAuLi4NCj4gICAgIChSdW4gJ2RpZmYg
LXUgL3Zhci9saWIveGZzdGVzdHMvdGVzdHMvZ2VuZXJpYy81NjEub3V0IC92YXIvbGliL3hm
c3Rlc3RzL3Jlc3VsdHMveGZzLWNyYy1ydGRldi1leHRzaXplLTI4ay82LjkuMC1yYzctbmV4
dC0yMDI0MDUwNisveGZzX2NyY19ydGRldl9leHRzaXplXzI4ay9nZW5lcmljLzU2MS5vdXQu
YmFkJyAgdG8gc2VlIHRoZSBlbnRpcmUgZGlmZikNCj4gUmFuOiBnZW5lcmljLzU2MQ0KPiBG
YWlsdXJlczogZ2VuZXJpYy81NjENCj4gRmFpbGVkIDEgb2YgMSB0ZXN0cw0KPiANCg0KU29y
cnkgYWJvdXQgdGhpcyByZWdyZXNzaW9uLiBBZnRlciBkZWJ1Z2luZyBhbmQgYW5hbHl6aW5n
IHRoZSBjb2RlLCBJIG5vdGljZQ0KdGhhdCB0aGlzIHByb2JsZW0gY291bGQgb25seSBoYXBw
ZW5zIG9uIHhmcyByZWFsdGltZSBpbm9kZS4gVGhlIHJlYWwgcHJvYmxlbQ0KaXMgYWJvdXQg
cmVhbHRpbWUgZXh0ZW50IGFsaWdubWVudC4NCg0KUGxlYXNlIGFzc3VtZSB0aGF0IGlmIHdl
IGhhdmUgYSBmaWxlIHRoYXQgY29udGFpbnMgYSB3cml0dGVuIGV4dGVudCBbQSwgRCkuDQpX
ZSB1bmFsaWduZWQgdHJ1bmNhdGUgdG8gdGhlIGZpbGUgdG8gQiwgaW4gdGhlIG1pZGRsZSBv
ZiB0aGlzIHdyaXR0ZW4gZXh0ZW50Lg0KDQogICAgICAgQSAgICAgICAgICAgIEIgICAgICAg
ICAgICAgICAgICBEDQogICAgICArd3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3
DQoNCkFmdGVyIHRoZSB0cnVuY2F0ZSwgdGhlIGlfc2l6ZSBpcyBzZXQgdG8gQiwgYnV0IGR1
ZSB0byB0aGUgc2JfcmV4dHNpemUsDQp4ZnNfaXRydW5jYXRlX2V4dGVudHMoKSB0cnVuY2F0
ZSBhbmQgYWxpZ25lZCB0aGUgd3JpdHRlbiBleHRlbnQgdG8gQywgc28gdGhlDQpkYXRhIGlu
IFtCLCBDKSBkb2Vzbid0IHplcm9lZCBhbmQgYmVjb21lcyBzdGFsZS4NCg0KICAgICAgIEEg
ICAgICAgICAgICBCICAgICBDDQogICAgICArd3d3d3d3d3d3d3d3d3dTU1NTU1MNCiAgICAg
ICAgICAgICAgICAgICAgXg0KICAgICAgICAgICAgICAgICAgIEVPRg0KDQpUaGUgaWYgd2Ug
d3JpdGUgW0UsIEYpIGJleW9uZCB0aGlzIHdyaXR0ZW4gZXh0ZW50LCB4ZnNfZmlsZV93cml0
ZV9jaGVja3MoKS0+DQp4ZnNfemVyb19yYW5nZSgpIHdvdWxkIHplcm8gW0IsIEMpIGluIHBh
Z2UgY2FjaGUsIGJ1dCBzaW5jZSB3ZSBkb24ndCBpbmNyZWFzZQ0KaV9zaXplIGluIGlvbWFw
X3plcm9faXRlcigpLCB0aGUgd3JpdGViYWNrIHByb2Nlc3MgZG9lc24ndCB3cml0ZSB6ZXJv
IGRhdGENCnRvIGRpc2suIEFmdGVyIHdyaXRlLCB0aGUgZGF0YSBpbiBbQiwgQykgaXMgc3Rp
bGwgc3RhbGUgc28gb25jZSB3ZSBjbGVhciB0aGUNCnBhZ2VjYWNoZSwgdGhpcyBzdGFsZSBk
YXRhIGlzIGV4cG9zZWQuDQoNCiAgICAgICBBICAgICAgICAgICAgQiAgICAgQyAgICAgICAg
RSAgICAgIEYNCiAgICAgICt3d3d3d3d3d3d3d3d3d1NTU1NTUyAgICAgICAgd3d3d3d3d3cN
Cg0KVGhlIHJlYXNvbiB0aGlzIHByb2JsZW0gZG9lc24ndCBvY2N1ciBvbiBub3JtYWwgaW5v
ZGUgaXMgYmVjYXVzZSBub3JtYWwgaW5vZGUNCmRvZXNuJ3QgaGF2ZSBhIHBvc3QgRU9GIHdy
aXR0ZW4gZXh0ZW50LiBGb3IgcmVhbHRpbWUgaW5vZGUsIEkgZ3Vlc3MgaXQncyBub3QNCmVu
b3VnaCB0byBqdXN0IHplcm8gdGhlIEVPRiBibG9jayAoeGZzX3NldGF0dHJfc2l6ZSgpLT54
ZnNfdHJ1bmNhdGVfcGFnZSgpKSwNCndlIHNob3VsZCBhbHNvIHplcm8gdGhlIGV4dHJhIGJs
b2NrcyB0aGF0IGFsaWduZWQgdG8gcmVhbHRpbWUgZXh0ZW50IHNpemUNCmJlZm9yZSB1cGRh
dGluZyBpX3NpemUuIEFueSBzdWdnZXN0aW9ucz8NCg0KVGhhbmtzLA0KWWkuDQoNCg0KDQo+
IFRoZSBmb2xsb3dpbmcgd2FzIHRoZSBmc3Rlc3QgY29uZmlndXJhdGlvbiB1c2VkIGZvciB0
aGUgdGVzdCBydW4sDQo+IA0KPiAgIEZTVFlQPXhmcw0KPiAgIFRFU1RfRElSPS9tZWRpYS90
ZXN0DQo+ICAgU0NSQVRDSF9NTlQ9L21lZGlhL3NjcmF0Y2gNCj4gICBURVNUX0RFVj0vZGV2
L2xvb3AxNg0KPiAgIFRFU1RfTE9HREVWPS9kZXYvbG9vcDEzDQo+ICAgU0NSQVRDSF9ERVZf
UE9PTD0iL2Rldi9sb29wNSAvZGV2L2xvb3A2IC9kZXYvbG9vcDcgL2Rldi9sb29wOCAvZGV2
L2xvb3A5IC9kZXYvbG9vcDEwIC9kZXYvbG9vcDExIC9kZXYvbG9vcDEyIg0KPiAgIE1LRlNf
T1BUSU9OUz0nLWYgLW0gY3JjPTEscmVmbGluaz0wLHJtYXBidD0wLCAtaSBzcGFyc2U9MCAt
bHNpemU9MWcnDQo+ICAgVEVTVF9GU19NT1VOVF9PUFRTPSItbyBsb2dkZXY9L2Rldi9sb29w
MTMiDQo+ICAgTU9VTlRfT1BUSU9OUz0nLW8gdXNycXVvdGEsZ3JwcXVvdGEscHJqcXVvdGEn
DQo+ICAgVEVTVF9GU19NT1VOVF9PUFRTPSIkVEVTVF9GU19NT1VOVF9PUFRTIC1vIHVzcnF1
b3RhLGdycHF1b3RhLHByanF1b3RhIg0KPiAgIFNDUkFUQ0hfTE9HREVWPS9kZXYvbG9vcDE1
DQo+ICAgVVNFX0VYVEVSTkFMPXllcw0KPiAgIExPR1dSSVRFU19ERVY9L2Rldi9sb29wMTUN
Cj4gDQo+IEdpdCBiaXNlY3QgcHJvZHVjZWQgdGhlIGZvbGxvd2luZyBhcyB0aGUgZmlyc3Qg
YmFkIGNvbW1pdCwNCj4gDQo+IGNvbW1pdCA5NDNiYzA4ODJjZWJmNDgyNDIyNjQwOTI0MDYy
YTdkYWFjNWEyN2JhDQo+IEF1dGhvcjogWmhhbmcgWWkgPHlpLnpoYW5nQGh1YXdlaS5jb20+
DQo+IERhdGU6ICAgV2VkIE1hciAyMCAxOTowNTo0NSAyMDI0ICswODAwDQo+IA0KPiAgICAg
aW9tYXA6IGRvbid0IGluY3JlYXNlIGlfc2l6ZSBpZiBpdCdzIG5vdCBhIHdyaXRlIG9wZXJh
dGlvbg0KPiANCj4gICAgIEluY3JlYXNlIGlfc2l6ZSBpbiBpb21hcF96ZXJvX3JhbmdlKCkg
YW5kIGlvbWFwX3Vuc2hhcmVfaXRlcigpIGlzIG5vdA0KPiAgICAgbmVlZGVkLCB0aGUgY2Fs
bGVyIHNob3VsZCBoYW5kbGUgaXQuIEVzcGVjaWFsbHksIHdoZW4gdHJ1bmNhdGUgcGFydGlh
bA0KPiAgICAgYmxvY2ssIHdlIHNob3VsZCBub3QgaW5jcmVhc2UgaV9zaXplIGJleW9uZCB0
aGUgbmV3IEVPRiBoZXJlLiBJdCBkb2Vzbid0DQo+ICAgICBhZmZlY3QgeGZzIGFuZCBnZnMy
IG5vdyBiZWNhdXNlIHRoZXkgc2V0IHRoZSBuZXcgZmlsZSBzaXplIGFmdGVyIHplcm8NCj4g
ICAgIG91dCwgaXQgZG9lc24ndCBtYXR0ZXIgdGhhdCBhIHRyYW5zaWVudCBpbmNyZWFzZSBp
biBpX3NpemUsIGJ1dCBpdCB3aWxsDQo+ICAgICBhZmZlY3QgZXh0NCBiZWNhdXNlIGl0IHNl
dCBmaWxlIHNpemUgYmVmb3JlIHRydW5jYXRlLiBTbyBtb3ZlIHRoZSBpX3NpemUNCj4gICAg
IHVwZGF0aW5nIGxvZ2ljIHRvIGlvbWFwX3dyaXRlX2l0ZXIoKS4NCj4gDQo+ICAgICBTaWdu
ZWQtb2ZmLWJ5OiBaaGFuZyBZaSA8eWkuemhhbmdAaHVhd2VpLmNvbT4NCj4gICAgIExpbms6
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyNDAzMjAxMTA1NDguMjIwMDY2Mi03LXlp
LnpoYW5nQGh1YXdlaWNsb3VkLmNvbQ0KPiAgICAgUmV2aWV3ZWQtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAgICAgUmV2aWV3ZWQtYnk6IERhcnJpY2sgSi4gV29u
ZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+ICAgICBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RpYW4g
QnJhdW5lciA8YnJhdW5lckBrZXJuZWwub3JnPg0KPiANCj4gIGZzL2lvbWFwL2J1ZmZlcmVk
LWlvLmMgfCA1MCArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDI1IGRlbGV0
aW9ucygtKQ0KPiAgDQo+IA0K


