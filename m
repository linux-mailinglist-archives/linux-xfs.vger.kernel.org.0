Return-Path: <linux-xfs+bounces-30920-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id x+YYJsdTlWnXOgIAu9opvQ
	(envelope-from <linux-xfs+bounces-30920-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 06:53:11 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 270831532DB
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 06:53:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 27C413006B64
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 05:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6B52798E8;
	Wed, 18 Feb 2026 05:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kQFO+eC3"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECBA3EBF13
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 05:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771393988; cv=none; b=A0I9P8BXfkTNbFqLWVDIFpWjiluJnjUaSfOLsydtrsFz8P8r7JDSuPKvk+2g60Jj64uMDRoUJqTow2bGhELO05VPxvtv5SXulZ9tHtyBT3nvWf3xKDVeS5MOhiImO2/1Z7xtJDq09F4TtOgah7k59jbowhmlxrJ90lqK2+F8mGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771393988; c=relaxed/simple;
	bh=sngeR8iI5jtvf064ydXaP74W3c5ikxxSxDbWXURMZ54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MqEB3j8Q4YcT9AfTf0wypmc41U4kVkG5tlpVSQMkrwJj9847Iht3zFiDIDTMBt0OMapFbk1M4mybwb4Wm08j7GwjI/ao80jHbQt4L++AurCSrYH4hSl1S14SshNumySBkQKHR/KzYD+3YC2lkPXvBUjY22RFnxPloVrVcKHknik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kQFO+eC3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MNnXWDhKb8d+tS/UibgdbnQxkDDi1/AwV3YN8xf2J54=; b=kQFO+eC3EE1gQD/OBVCaIZ+mtS
	sIAqXYaxmW3lRQAEW44o92TyBJEbgtZtPUACdTmEUe/9LzGqambku/54PHJN/viS0UiGexxsSPiaC
	4LYAH0TCUOO1ykO6yeu2zvLL4wjPcIGKeZtm4w64K40MPQy2sna7qZtA0N4HBs1I6563bZRg+204c
	yQfJV4lUguQ7vo6bReFlzblyVxA+v3J0caJ/63unvTO3W5EKaIlz84GoEGx2ipYV17svTrlzaaVec
	syGMkzo+NHtZjG+x7oyLq7aIukcA8OdLL22MS7qiVENXxqO3h6XYj+PE/cn8DmN46nyJb1oiZ62Ns
	YcH0Qk0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsaUk-00000009Kpv-0rIb;
	Wed, 18 Feb 2026 05:53:06 +0000
Date: Tue, 17 Feb 2026 21:53:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v1 1/4] xfs: Fix xfs_last_rt_bmblock()
Message-ID: <aZVTwrR4ORzYALSy@infradead.org>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <8b93afb5feaef3fef206c5e4a6a5f83a6d63b53b.1770904484.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b93afb5feaef3fef206c5e4a6a5f83a6d63b53b.1770904484.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30920-lists,linux-xfs=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,infradead.org,vger.kernel.org,gmail.com,linux.ibm.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-xfs];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 270831532DB
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 07:31:44PM +0530, Nirjhar Roy (IBM) wrote:
> Reproduce:
> $ mkfs.xfs -m metadir=0 -r rtdev=/dev/loop1 /dev/loop0 \
> 	-r rgsize=32768b,size=32769b -f
> $ mount -o rtdev=/dev/loop1 /dev/loop0 /mnt/scratch
> $ xfs_growfs -R $(( 32769 + 1 )) /mnt/scratch
> $ xfs_info /mnt/scratch | grep rtextents
> $ # We can see that rtextents hasn't changed

Please wire this up in xfstests.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

