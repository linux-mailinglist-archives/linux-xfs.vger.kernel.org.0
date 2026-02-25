Return-Path: <linux-xfs+bounces-31303-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eQ0/EOSFn2mmcgQAu9opvQ
	(envelope-from <linux-xfs+bounces-31303-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Feb 2026 00:29:40 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B202819ED6E
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Feb 2026 00:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1399C302D086
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 23:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784743806B1;
	Wed, 25 Feb 2026 23:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PnzLtIcM"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555091E5B7B
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 23:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772062177; cv=none; b=YGvPZSEZzwtm765Ta++Odq9nF68HKRgRhTd2Wyqi+ukOGGWmhoYExOiz3QXrgbnuPaRWmOIIEf5eiM1QrTWH79KIm6ssG0EK/F6r/R5rz1EZnlNk78VFx+IaR0tQQrXrKrjcM875QZsJO32orTphFL8M2iJM1qc8Jvqqgs6bspw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772062177; c=relaxed/simple;
	bh=yIiDxnte3vWQAVAGCQR7uV5n87iACrYN+GpKTY8+QGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gxBUwQNGAr1kBbHv7wWnuXN5mhPXAVnlAjYGPNt0wZKBg3Xm+SXWrJP9L5hpTica37CcvznG2V8WrWxBrsdCGzRpT+i8/sdyuq8r2u2r1V+WIDRDbYfHDneKdjORPWmjtysPeEYMbHT3xWd0eSuxnxG/CfrQj4n7n5nGUQTVrII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PnzLtIcM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125E1C116D0;
	Wed, 25 Feb 2026 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772062176;
	bh=yIiDxnte3vWQAVAGCQR7uV5n87iACrYN+GpKTY8+QGs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PnzLtIcMfeucHHuFGysc7HT7OS7I5H+Uue0Z+pCc3jHNo/t2NKhS+9tNCf8W+cKlZ
	 nKJlesw/dq3ob47JCkdmOMqrV9TWpF1kJohXwt+YDKbQ9VhtCHX49hr84+VhdMS2yA
	 tr/sNyDnUnVEi4vRcezrVmyDXTvqMsra2rEB9u2NBNwibMpGXwG8FipV5Ttd4RPv9S
	 ydT/kLnoo5tIh44gcZYx0QRWtwQP04BnoZG7H37kEUw2gK/8CL5D0A7heugYEukI8Y
	 a+YQToHtibt159R7JMFMUgeQe1gmGprPK75GpDIDuwVeWXUVuXPKcKCE0Wu685WgNQ
	 0/DOycuW/wczw==
Message-ID: <32f7339a-6019-4fca-aa0f-1d1b6364b992@kernel.org>
Date: Thu, 26 Feb 2026 08:29:34 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: struct xfs_zone_scratch is undefined in 7.0-rc1
To: Christoph Hellwig <hch@infradead.org>
Cc: Wang Yugui <wangyugui@e16-tech.com>, linux-xfs@vger.kernel.org
References: <20260225153923.47B2.409509F4@e16-tech.com>
 <42a5498b-31dc-4ad9-aa76-3d332d6113bc@kernel.org>
 <aZ8CUfVRaG4w3dly@infradead.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aZ8CUfVRaG4w3dly@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31303-lists,linux-xfs=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	HAS_ORG_HEADER(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dlemoal@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B202819ED6E
X-Rspamd-Action: no action

On 2/25/26 23:08, Christoph Hellwig wrote:
> On Wed, Feb 25, 2026 at 06:01:59PM +0900, Damien Le Moal wrote:
>> On 2/25/26 16:39, Wang Yugui wrote:
>>> Hi,
>>>
>>> struct xfs_zone_scratch is undefined in 7.0-rc1.
>>>
>>> # grep xfs_zone_scratch -nr *
>>> fs/xfs/xfs_zone_gc.c:99:        struct xfs_zone_scratch         *scratch;
>>> #
>>>
>>> Could we change 'struct xfs_zone_scratch  *' to 'void *',
>>> or just delete this var?
>>
>> This should do it:
> 
> Can you send a formal patch?

Done.


-- 
Damien Le Moal
Western Digital Research

