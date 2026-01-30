Return-Path: <linux-xfs+bounces-30570-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iC2aMq3XfGlbOwIAu9opvQ
	(envelope-from <linux-xfs+bounces-30570-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 17:09:17 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7191CBC64C
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 17:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BC64C3006140
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 16:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36388346E73;
	Fri, 30 Jan 2026 16:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KY4UiRjJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68280346774
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 16:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769789353; cv=none; b=qOftHxmNBZljL/6IE0DLgeXbNYAhtfHgQiqZ/wj4TOaJpqoBeJNsfv3YW9o8VVa4JD8ajoGcPt+ZDGeNYPHl8S8KjTqH7pUY6J8lsoewQ8uM4zJ26isxtD6/U4KG4HW7k4oxRJvjvBx+E5DTDKwTfeGYmqmz8RO7tcnLwHr6B60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769789353; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=n+xaIhL6iD1xQP0SEOWCCEe00PxdPTuPQ8oWpXJhUPpdsVZI6yAS+vTVg5jA+g6TUkkpDKxEQY7gIqv4+6qPxLMPBggzcxT2IPIBh07zfM3LTdbaKPBVVpXovBn0hfbTyq4xXrTXoz44RkY8zPgIKfPzWSpl1qKkstvF6hjcask=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KY4UiRjJ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260130160904epoutp04cf3fed3872a4198a2d05eb03bda853a7~Pjggqrjwo1685416854epoutp04L
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 16:09:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260130160904epoutp04cf3fed3872a4198a2d05eb03bda853a7~Pjggqrjwo1685416854epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769789344;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=KY4UiRjJGS2lCsrOGQdD93kUWvTwdyrnyLE/BUSQ8RBHEQGND4J0+Qy+8qLUdbfTp
	 NYHNuhHMKV7FVOUnpPF9dGIRjzL4MYApDqHx7wgluHHNnlSPBnf2yA5yZmGMrgZrpv
	 YWvHAqysKnNCFguPOz5O4ginKOckKkz84xBX8rs8=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260130160903epcas5p312a66a400bf438157c5285f2f9076dd5~PjggFPk7l2594425944epcas5p3R;
	Fri, 30 Jan 2026 16:09:03 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f2gtQ74s2z2SSKX; Fri, 30 Jan
	2026 16:09:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260130160902epcas5p4f47396b260179d83b338be44cb4b886e~Pjge3l3yq1410114101epcas5p4r;
	Fri, 30 Jan 2026 16:09:02 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260130160900epsmtip10421ddfc9116cd83f323b3bf56c455af~PjgdWa7fj1856918569epsmtip1p;
	Fri, 30 Jan 2026 16:09:00 +0000 (GMT)
Message-ID: <7cee5c9a-756f-43d2-92b7-5d8a5fb4fd2b@samsung.com>
Date: Fri, 30 Jan 2026 21:38:59 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/15] block: add fs_bio_integrity helpers
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
	Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260128161517.666412-7-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260130160902epcas5p4f47396b260179d83b338be44cb4b886e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260128165050epcas5p190f1dd0d8f5a3f51c74e8f3155e190ee
References: <20260128161517.666412-1-hch@lst.de>
	<CGME20260128165050epcas5p190f1dd0d8f5a3f51c74e8f3155e190ee@epcas5p1.samsung.com>
	<20260128161517.666412-7-hch@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DKIM_TRACE(0.00)[samsung.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-30570-lists,linux-xfs=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 7191CBC64C
X-Rspamd-Action: no action

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

