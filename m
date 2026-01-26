Return-Path: <linux-xfs+bounces-30327-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cHDyLPOsd2kZkAEAu9opvQ
	(envelope-from <linux-xfs+bounces-30327-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jan 2026 19:05:39 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0518E8BE78
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jan 2026 19:05:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9FD2B3062FBB
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jan 2026 18:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5535934D910;
	Mon, 26 Jan 2026 18:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nCI2vL9y"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC10234D3AD
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 18:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769450708; cv=none; b=e32ebLj1Je/KkSN6eA0Nvtc8zulgLOhDGv1sV3WBA1G89fd/9G82/kI7r1Zwpq+VncjkhmgCIA+GEnkqnf7sO0IKSLFaZBrKf5nzOUhqhNgwckk1G7466wwIATvJmHvRzTTjRA6ZmQzab/DqGkON+l94OMt2s+o62Pl7TBgwFbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769450708; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=a1n6GnR0ZNGtTh9UnNDYLbnKZsk18VFF6H4E4rUJ1uUjK2KWxuwPR4+G/phpBAsCsA+5Kdwj392EiZaKr7k2Xuo9wPW6VMmwlzcFxxcKkxnVVFRwASDJwfajqeJWIYrLEAt1Mh/z8F9OkuGD2fZitG0JwMnW3FbE+S4W5ScPAcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nCI2vL9y; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260126180504epoutp03ccb8ee502152d690a8da780a6ef2c816~OWgqDdHDm3011130111epoutp030
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 18:05:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260126180504epoutp03ccb8ee502152d690a8da780a6ef2c816~OWgqDdHDm3011130111epoutp030
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769450704;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=nCI2vL9yjqg6e2isPIgsn+obWSAih1SXQGtyNwDLN4dB4Y8W0iSpf9jZ2cnNa5cEG
	 6PiaRGssuqJMlBDgF3pPJLSl0FuSvSFS8pw0Kyda9jTEGlzKArMz67EFp2pcYkdk0p
	 sHC44FYQ6QXFxgES9n5UBMWmwl+fwZfsoBE0RwWM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260126180503epcas5p2414f3d83ee8977d60c210e13329e542c~OWgpG8Nmt2105821058epcas5p2d;
	Mon, 26 Jan 2026 18:05:03 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4f0Gf70pRKz3hhT3; Mon, 26 Jan
	2026 18:05:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260126180502epcas5p41916b21ec8c34d06b915e4be0af985d9~OWgnh-Lv32021420214epcas5p4R;
	Mon, 26 Jan 2026 18:05:02 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260126180500epsmtip1250f28e33d16e3e4a18cd40c3bb6d0f6~OWgl8qnDY0336703367epsmtip1M;
	Mon, 26 Jan 2026 18:05:00 +0000 (GMT)
Message-ID: <5ae4e0ea-b50a-45ad-9f5b-7efc86bdc5d8@samsung.com>
Date: Mon, 26 Jan 2026 23:34:58 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/15] block: make max_integrity_io_size public
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
	Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260121064339.206019-6-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260126180502epcas5p41916b21ec8c34d06b915e4be0af985d9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260121064412epcas5p1018133b5acd13040ad666a378c7e72b7
References: <20260121064339.206019-1-hch@lst.de>
	<CGME20260121064412epcas5p1018133b5acd13040ad666a378c7e72b7@epcas5p1.samsung.com>
	<20260121064339.206019-6-hch@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DKIM_TRACE(0.00)[samsung.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-30327-lists,linux-xfs=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:email,samsung.com:dkim,samsung.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joshi.k@samsung.com,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 0518E8BE78
X-Rspamd-Action: no action

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

