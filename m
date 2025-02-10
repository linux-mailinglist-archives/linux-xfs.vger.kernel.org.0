Return-Path: <linux-xfs+bounces-19387-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24609A2E6F6
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Feb 2025 09:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2BCC16721C
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Feb 2025 08:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880351C07EE;
	Mon, 10 Feb 2025 08:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="d53xoIA/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B2C199E80;
	Mon, 10 Feb 2025 08:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739177469; cv=none; b=ieHKrveEv4AFmAGM5yFEJ45yCrRlrMa/0FjBxJtLXMT/o649RWGZrsx77O+jEkboW3Dc9b4j4sLizC8o66mYLX+zzKoH+Ib0KpWm+kxHFrEzKMVU9Jzh4srIAnHdud+FE82nyAcw+m0gbDgcvXPxmAkHhV/8v1fbr2GLlxA1OsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739177469; c=relaxed/simple;
	bh=IkD2+ChwLyf7QngQzQdC06wltUn1TertBzU1HJdYxDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e2qfVKqIZaVdSMuZ9/JBx2O8hV6+Jj0tAnpIDOXubbBmmVJ05lPLy7dFMJGukAzHPBz5CvWQgz9lYu0qFSc+q8QpXr/1SZLWjVfKh3/Mhnog967x7iER92lp0itZzTqH7MjXxneqwkGvKlY1l64HWUEyEtq7dp+GxNdebLCLpZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=d53xoIA/; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1739177465; x=1739782265; i=quwenruo.btrfs@gmx.com;
	bh=IkD2+ChwLyf7QngQzQdC06wltUn1TertBzU1HJdYxDo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=d53xoIA/rqN6+i1XcZjINVNbCHOBlW2tgeq2Xu+IfvICfyJU5UE22CI8P/mfFBAn
	 /qG5zNAVjfjU+8ramUbPXezOQNVv4tt6bqGZ6mK9VLwD53Es1tFnayxirUJFLgmTd
	 g5R+lc4RGCSoqB4HWYYTF5VyBr9AKuDGbSXes0l4sKC0WY7/nn9HB2yghoLF8zFQV
	 d0KadnEwOqwNG8Zwxw5lN1U5+qLLdVuEzhwq/YVXRScjrfbOEvv8YZrW2Ybd9EeGw
	 AW5wdgXIy+n9jsex+AXrK+QN1YyPXpL+6j2wECga5ZNQ+4G0V6tn7KEI2OeTEjv5V
	 x/o2bdabq1Tek4PQ2A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [172.16.0.191] ([159.196.52.54]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MC30P-1tXBgr2A8b-0088n4; Mon, 10
 Feb 2025 09:51:05 +0100
Message-ID: <669898c1-e998-461d-9381-9143a3cb39c2@gmx.com>
Date: Mon, 10 Feb 2025 19:20:58 +1030
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfs/folio splat with v6.14-rc1
To: Qi Zheng <zhengqi.arch@bytedance.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Wilcox <willy@infradead.org>, Christian Brauner
 <brauner@kernel.org>, David Hildenbrand <david@redhat.com>,
 Jann Horn <jannh@google.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner
 <david@fromorbit.com>, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250207-anbot-bankfilialen-acce9d79a2c7@brauner>
 <20250207-handel-unbehagen-fce1c4c0dd2a@brauner>
 <Z6aGaYkeoveytgo_@casper.infradead.org>
 <2766D04E-5A04-4BF6-A2A3-5683A3054973@nvidia.com>
 <8c71f41e-3733-4100-ab55-1176998ced29@bytedance.com>
 <dda6b378-c344-4de6-9a55-8571df3149a7@bytedance.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <dda6b378-c344-4de6-9a55-8571df3149a7@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:EC4xqQatFtQ165vekt4XxHWulLePZUCb3+pYQTwnOhpmUIfxqvG
 FhFFZ42M0gOnF7hXP1NbJ5iymVQWA3m8FCMD5QwZq76u/3o47hBZU863/Fhsy+0cklMPqWq
 A57+pZkfngM8x4v8VzMNFLioskYgjVAAoFheQoIr81NQy99khjt9KHVj5r0tcz1cjoM0Uw8
 clFVHd8hEJmLWv6nHtTaw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JRDyHF5gkyo=;6gm8y+IjhBmx+14I4X07PPltlde
 WulmlpauDBy+S81bf4cDYc2p4UL7k5SmrlRM4Ra0gx51GXKx9y/GzOrej6h8ozWWPLrWsMnA6
 JqnCiiYi5goyEjpsywEwlcyboWcFZvyTJAEyU+0QyH5OaHTzxVUHn4iU4A8vyJa3URRIG0Oue
 RS+uxyjTE6tGqXhG1gdwq/wirCMX+WI1X31w9/wO3Ie02R4fdLeoCwAxPZyGRKMIF3XChRwN8
 bPLhvclaF3HkMo/Kut/fCkp+dsPTiaFU3ZSiyYf+mgXt89XU+5yVK6uFKvxCWwPVzXoGxdSRS
 s88kfs5Hz+ugsBBUBfqxDz4XfBegcTm2JJVJVx/8KnDiyx7g16F46DTpH/eRtw0NMDBUFn6zw
 kaeygzbf1Is2MsPckOT7HCEySCih1v0mOShabxqAkO8NeZMYUghYUHOfAdKpKOOVBDocdiDi3
 pfhZgLcqPIb2TtM448RX054DNwNh4zo75AgNov1mWo4VjVFqIu2N3l2ztIPdHnZ+H2mtGv4UQ
 ibcG+wk9DtJdFHTvjSmDjqIA/cXnJl3T4hh9MK/tuaeJO+AkpxCRJ6YUY8zM35jKRy4Grkh8v
 vigy3GXnImu56Vll7hO9iuHbBdN6b4SZsBZc/n7+VgVKfW+zwX8yBiLFP5PZJQtjGz6qXx3aG
 V/sYOnECIG+vhJ2X8ZoWV6S91YWGyKO/X0mcccLrWTCwMLEy/BmlatmHas1qeaW0YjKnkFgrp
 957SkFZzZah86OykJB6heUovRMpEANdAEQvHZwBYhOGmynDa3OKoovbn67bvXhzal9/WonOmM
 tUFEXrrSLk/qvg19K1zeh2hx9fd+FeP+dskElhJW/kb3Ff6VC1XFeQae79PKN39NkKQ/3mDh9
 9Nv6WQ132j14GgGjbkUj3qTDqskSqW8xfI1B6k7HMNkPeo3nxjrDEVQ6pM2Z8qLnGZA10y8FI
 qjmjbUyLx+M7jDj4mrA/ljFGiKKz0qXv4ugfDGIh0FcyD5EBq9iV9b8DgDqagLZ+PdCk3y3Tw
 CBj+dSOvTaBeRmI152IBEmdwULvTHg2tnwZyNPcKl4pZpXaqsp2QX1cnakY1M5H7nng/wXOWI
 2AGtO62YmsOqmbK2kfHxRBMeU1T9grjKXUjQ7oIeCrOrRtlnMBgXD4yLu7IV/D6KxHiyEHuvp
 +2sq2wdco8RCI6ifh5yk6YmRWAwkJ5APJMsXLUHEHoxQDtOMRW1g8j7s/wl+8QuwJY9jubrmh
 fEZGZxbCHcaIMZFAfNCJ+IYQyhyI6oPlPLBGy5q4ptuGZPjzc/pjMQKf2oUrGp/YXtFqkSc56
 +GRoi6L/6UUzqzkXBTZk/9rVfoFq3a1PuNYHY8z6bgbV+XEKCWxDCfmA+CYdxgHn/0ukKm2+2
 u4Uf64uWXItjNc+rlnFwluRQFjXUyMMCDXZCRUjydh+NXbOqz3PCmYeLlu

DQoNCuWcqCAyMDI1LzIvMTAgMTg6NDgsIFFpIFpoZW5nIOWGmemBkzoNCj4gSGkgYWxsLA0KPiAN
Cj4gT24gMjAyNS8yLzEwIDEyOjAyLCBRaSBaaGVuZyB3cm90ZToNCj4+IEhpIFppLA0KPj4NCj4+
IE9uIDIwMjUvMi8xMCAxMTozNSwgWmkgWWFuIHdyb3RlOg0KPj4+IE9uIDcgRmViIDIwMjUsIGF0
IDE3OjE3LCBNYXR0aGV3IFdpbGNveCB3cm90ZToNCj4+Pg0KPj4+PiBPbiBGcmksIEZlYiAwNywg
MjAyNSBhdCAwNDoyOTozNlBNICswMTAwLCBDaHJpc3RpYW4gQnJhdW5lciB3cm90ZToNCj4+Pj4+
IHdoaWxlIHRydWU7IGRvIC4veGZzLnJ1bi5zaCAiZ2VuZXJpYy80MzciOyBkb25lDQo+Pj4+Pg0K
Pj4+Pj4gYWxsb3dzIG1lIHRvIHJlcHJvZHVjZSB0aGlzIGZhaXJseSBxdWlja2x5Lg0KPj4+Pg0K
Pj4+PiBvbiBob2xpZGF5LCBiYWNrIG1vbmRheQ0KPj4+DQo+Pj4gZ2l0IGJpc2VjdCBwb2ludHMg
dG8gY29tbWl0DQo+Pj4gNDgxN2Y3MGMyNWI2ICgieDg2OiBzZWxlY3QgQVJDSF9TVVBQT1JUU19Q
VF9SRUNMQUlNIGlmIFg4Nl82NCIpLg0KPj4+IFFpIGlzIGNjJ2QuDQo+Pj4NCj4+PiBBZnRlciBk
ZXNlbGVjdCBQVF9SRUNMQUlNIG9uIHY2LjE0LXJjMSwgdGhlIGlzc3VlIGlzIGdvbmUuDQo+Pj4g
QXQgbGVhc3QsIG5vIHNwbGF0IGFmdGVyIHJ1bm5pbmcgZm9yIG1vcmUgdGhhbiAzMDBzLA0KPj4+
IHdoZXJlYXMgdGhlIHNwbGF0IGlzIHVzdWFsbHkgdHJpZ2dlcmVkIGFmdGVyIH4yMHMgd2l0aA0K
Pj4+IFBUX1JFQ0xBSU0gc2V0Lg0KPj4NCj4+IFRoZSBQVF9SRUNMQUlNIG1haW5seSBtYWRlIHRo
ZSBmb2xsb3dpbmcgdHdvIGNoYW5nZXM6DQo+Pg0KPj4gMSkgdHJ5IHRvIHJlY2xhaW0gcGFnZSB0
YWJsZSBwYWdlcyBkdXJpbmcgbWFkdmlzZShNQURWX0RPTlRORUVEKQ0KPj4gMikgVW5jb25kaXRp
b25hbGx5IHNlbGVjdCBNTVVfR0FUSEVSX1JDVV9UQUJMRV9GUkVFDQo+Pg0KPj4gV2lsbCAuL3hm
cy5ydW4uc2ggImdlbmVyaWMvNDM3IiBwZXJmb3JtIHRoZSBtYWR2aXNlKE1BRFZfRE9OVE5FRUQp
Pw0KPj4NCj4+IEFueXdheSwgSSB3aWxsIHRyeSB0byByZXByb2R1Y2UgaXQgbG9jYWxseSBhbmQg
dHJvdWJsZXNob290IGl0Lg0KPiANCj4gSSByZXByb2R1Y2VkIGl0IGxvY2FsbHkgYW5kIGl0IHdh
cyBpbmRlZWQgY2F1c2VkIGJ5IFBUX1JFQ0xBSU0uDQo+IA0KPiBUaGUgcm9vdCBjYXVzZSBpcyB0
aGF0IHRoZSBwdGUgbG9jayBtYXkgYmUgcmVsZWFzZWQgbWlkd2F5IGluDQo+IHphcF9wdGVfcmFu
Z2UoKSBhbmQgdGhlbiByZXRyaWVkLiBJbiB0aGlzIGNhc2UsIHRoZSBvcmlnaW5hbGx5IG5vbmUg
cHRlDQo+IGVudHJ5IG1heSBiZSByZWZpbGxlZCB3aXRoIHBoeXNpY2FsIHBhZ2VzLg0KPiANCj4g
U28gd2Ugc2hvdWxkIHJlY2hlY2sgYWxsIHB0ZSBlbnRyaWVzIGluIHRoaXMgY2FzZToNCj4gDQo+
IGRpZmYgLS1naXQgYS9tbS9tZW1vcnkuYyBiL21tL21lbW9yeS5jDQo+IGluZGV4IGE4MTk2YWU3
MmU5YWUuLmNhMWIxMzNhMjg4YjUgMTAwNjQ0DQo+IC0tLSBhL21tL21lbW9yeS5jDQo+ICsrKyBi
L21tL21lbW9yeS5jDQo+IEBAIC0xNzIxLDcgKzE3MjEsNyBAQCBzdGF0aWMgdW5zaWduZWQgbG9u
ZyB6YXBfcHRlX3JhbmdlKHN0cnVjdCANCj4gbW11X2dhdGhlciAqdGxiLA0KPiAgwqDCoMKgwqDC
oMKgwqAgcG1kX3QgcG1kdmFsOw0KPiAgwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyBzdGFy
dCA9IGFkZHI7DQo+ICDCoMKgwqDCoMKgwqDCoCBib29sIGNhbl9yZWNsYWltX3B0ID0gcmVjbGFp
bV9wdF9pc19lbmFibGVkKHN0YXJ0LCBlbmQsIGRldGFpbHMpOw0KPiAtwqDCoMKgwqDCoMKgIGJv
b2wgZGlyZWN0X3JlY2xhaW0gPSBmYWxzZTsNCj4gK8KgwqDCoMKgwqDCoCBib29sIGRpcmVjdF9y
ZWNsYWltID0gdHJ1ZTsNCj4gIMKgwqDCoMKgwqDCoMKgIGludCBucjsNCj4gDQo+ICDCoHJldHJ5
Og0KPiBAQCAtMTczNiw4ICsxNzM2LDEwIEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nIHphcF9wdGVf
cmFuZ2Uoc3RydWN0IA0KPiBtbXVfZ2F0aGVyICp0bGIsDQo+ICDCoMKgwqDCoMKgwqDCoCBkbyB7
DQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYm9vbCBhbnlfc2tpcHBlZCA9IGZh
bHNlOw0KPiANCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG5lZWRfcmVzY2hl
ZCgpKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAobmVlZF9yZXNjaGVkKCkp
IHsNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRpcmVj
dF9yZWNsYWltID0gZmFsc2U7DQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGJyZWFrOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9DQo+
IA0KPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5yID0gZG9femFwX3B0ZV9yYW5n
ZSh0bGIsIHZtYSwgcHRlLCBhZGRyLCBlbmQsIA0KPiBkZXRhaWxzLCByc3MsDQo+ICDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAmZm9yY2VfZmx1c2gsICZmb3JjZV9icmVhaywgDQo+ICZhbnlfc2tpcHBlZCk7
DQo+IEBAIC0xNzQ1LDExICsxNzQ3LDEyIEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nIHphcF9wdGVf
cmFuZ2Uoc3RydWN0IA0KPiBtbXVfZ2F0aGVyICp0bGIsDQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNhbl9yZWNsYWltX3B0ID0gZmFsc2U7DQo+ICDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHVubGlrZWx5KGZvcmNlX2JyZWFrKSkg
ew0KPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBhZGRy
ICs9IG5yICogUEFHRV9TSVpFOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZGlyZWN0X3JlY2xhaW0gPSBmYWxzZTsNCj4gIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7DQo+ICDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfQ0KPiAgwqDCoMKgwqDCoMKgwqAgfSB3aGlsZSAocHRlICs9IG5yLCBh
ZGRyICs9IFBBR0VfU0laRSAqIG5yLCBhZGRyICE9IGVuZCk7DQo+IA0KPiAtwqDCoMKgwqDCoMKg
IGlmIChjYW5fcmVjbGFpbV9wdCAmJiBhZGRyID09IGVuZCkNCj4gK8KgwqDCoMKgwqDCoCBpZiAo
Y2FuX3JlY2xhaW1fcHQgJiYgZGlyZWN0X3JlY2xhaW0gJiYgYWRkciA9PSBlbmQpDQo+ICDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGlyZWN0X3JlY2xhaW0gPSB0cnlfZ2V0X2FuZF9j
bGVhcl9wbWQobW0sIHBtZCwgJnBtZHZhbCk7DQo+IA0KPiAgwqDCoMKgwqDCoMKgwqAgYWRkX21t
X3Jzc192ZWMobW0sIHJzcyk7DQo+IA0KPiBJIHRlc3RlZCB0aGUgYWJvdmUgY29kZSBhbmQgbm8g
YnVncyB3ZXJlIHJlcG9ydGVkIGZvciBhIHdoaWxlLiBEb2VzIGl0DQo+IHdvcmsgZm9yIHlvdT8N
Cg0KVGVzdGVkIDEyOCBnZW5lcmljLzQzNyBydW5zIHdpdGggQ09ORklHX1BUX1JFQ0xBSU0gb24g
YnRyZnMuDQpObyBtb3JlIGNyYXNoLCB3aWxsIGRvIGEgbG9uZ2VyIHJ1biwgYnV0IGl0IGxvb2tz
IGxpa2UgdG8gZ2V0IHRoZSBidWcgZml4ZWQuDQoNCkJlZm9yZSB0aGUgZml4IG1lcmdlZCwgSSds
bCBkZXNlbGVjdCBQVF9SRUNMQUlNIGFzIGEgd29ya2Fyb3VuZCBmb3IgbXkgDQpydW5zIG9uIGJ0
cmZzL2Zvci1uZXh0IGJyYW5jaC4NCg0KVGhhbmtzLA0KUXUNCg0KPiANCj4gVGhhbmtzLA0KPiBR
aQ0KPiANCj4+DQo+PiBUaGFua3MhDQo+Pg0KPj4+DQo+Pj4gLS0gDQo+Pj4gQmVzdCBSZWdhcmRz
LA0KPj4+IFlhbiwgWmkNCg0K

