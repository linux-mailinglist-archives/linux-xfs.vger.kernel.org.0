Return-Path: <linux-xfs+bounces-10700-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 960B1933F54
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Jul 2024 17:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C815A1C22A69
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Jul 2024 15:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62051181B8D;
	Wed, 17 Jul 2024 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="PIbi01yD"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E423220B0F;
	Wed, 17 Jul 2024 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721229183; cv=none; b=KOo8eTNcMpv1xbwjm4qUWTFmcYeAMRXhYL2yy1SkMH0RApt6oa2+Ph5umNvOpHy5xTmwtYvvzynDxmcbrTHjVc/1gaUVR4v2IXocUfmXq3whNbYwEAZuWi11mhDZYbCUABvfJXJHq2iRjOAXTRWNVjN7yZnXDnOFdPNXZBjX8iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721229183; c=relaxed/simple;
	bh=QsFQR9ykG4piFKvmVNGE7MsWS/73G/aUMfN4Y1G2Qyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sA2o546M2WoW62daBNDvVkJTXPH40ZCgSMlbgi1ecptp8yZzlVY25T8Cwm84I5buH2Yubn14r0Q3jtHut4My26c31BpcekBlrMIpTNtSCvM+BrnDxmuuj6xso4SnT2UqiTeU/WLPb+KTrScXC/AT5RjYTO2A4q5pneFxyrwXnn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=PIbi01yD; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4WPKF46PK9z9scN;
	Wed, 17 Jul 2024 17:12:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1721229176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkGlIL/8yYyHEDYOvtGp85rUzFdd0lvsLxhOub/l8Dw=;
	b=PIbi01yDD/lqKD8I/KAF7g90eBYXWrXENMgSb3CBHFRS0GSbqzabZPo2jnKsAclomkqi/E
	PnViURvG9P0HFHP3M85oB3QocxVJ5j+nSgdDhBPlaVgVrqtz5uwEZnfWd2D+0WBGmsGkYF
	L8mOjI28meM12Hq9K06VmfgpVohIKttL5euBe7gsK3UFejQWpvrqxkfxoR62kkmHdG2v11
	UBf2LXozSlh9JKw2BlwsZah7XUXWRSpZYcRMC5n7RlBiMVE0D/WmuagEK9KEjbh3BEQc9W
	rfveAKVXMSNn/FpxJFUc+RUw8GSfwe3ltnqLmvrbfkFegAWYeB0ps9YIPD9UPA==
Date: Wed, 17 Jul 2024 15:12:51 +0000
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>, david@fromorbit.com,
	chandan.babu@oracle.com, djwong@kernel.org, brauner@kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	yang@os.amperecomputing.com, linux-mm@kvack.org,
	john.g.garry@oracle.com, linux-fsdevel@vger.kernel.org,
	hare@suse.de, p.raghav@samsung.com, mcgrof@kernel.org,
	gost.dev@samsung.com, cl@os.amperecomputing.com,
	linux-xfs@vger.kernel.org, hch@lst.de, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v10 01/10] fs: Allow fine-grained control of folio sizes
Message-ID: <20240717151251.x7vkwajb57pefs6m@quentin>
References: <20240715094457.452836-1-kernel@pankajraghav.com>
 <20240715094457.452836-2-kernel@pankajraghav.com>
 <ZpaRElX0HyikQ1ER@casper.infradead.org>
 <20240717094621.fdobfk7coyirg5e5@quentin>
 <61806152-3450-4a4f-b81f-acc6c6aeed29@arm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61806152-3450-4a4f-b81f-acc6c6aeed29@arm.com>
X-Rspamd-Queue-Id: 4WPKF46PK9z9scN

> >>
> >> This is really too much.  It's something that will never happen.  Just
> >> delete the message.
> >>
> >>> +	if (max > MAX_PAGECACHE_ORDER) {
> >>> +		VM_WARN_ONCE(1,
> >>> +	"max order > MAX_PAGECACHE_ORDER. Setting max_order to MAX_PAGECACHE_ORDER");
> >>> +		max = MAX_PAGECACHE_ORDER;
> >>
> >> Absolutely not.  If the filesystem declares it can support a block size
> >> of 4TB, then good for it.  We just silently clamp it.
> > 
> > Hmm, but you raised the point about clamping in the previous patches[1]
> > after Ryan pointed out that we should not silently clamp the order.
> > 
> > ```
> >> It seems strange to silently clamp these? Presumably for the bs>ps usecase,
> >> whatever values are passed in are a hard requirement? So wouldn't want them to
> >> be silently reduced. (Especially given the recent change to reduce the size of
> >> MAX_PAGECACHE_ORDER to less then PMD size in some cases).
> > 
> > Hm, yes.  We should probably make this return an errno.  Including
> > returning an errno for !IS_ENABLED() and min > 0.
> > ```
> > 
> > It was not clear from the conversation in the previous patches that we
> > decided to just clamp the order (like it was done before).
> > 
> > So let's just stick with how it was done before where we clamp the
> > values if min and max > MAX_PAGECACHE_ORDER?
> > 
> > [1] https://lore.kernel.org/linux-fsdevel/Zoa9rQbEUam467-q@casper.infradead.org/
> 
> The way I see it, there are 2 approaches we could take:
> 
> 1. Implement mapping_max_folio_size_supported(), write a headerdoc for
> mapping_set_folio_order_range() that says min must be lte max, max must be lte
> mapping_max_folio_size_supported(). Then emit VM_WARN() in
> mapping_set_folio_order_range() if the constraints are violated, and clamp to
> make it safe (from page cache's perspective). The VM_WARN()s can just be inline

Inlining with the `if` is not possible since:
91241681c62a ("include/linux/mmdebug.h: make VM_WARN* non-rvals")

> in the if statements to keep them clean. The FS is responsible for checking
> mapping_max_folio_size_supported() and ensuring min and max meet requirements.

This is sort of what is done here but IIUC willy's reply to the patch,
he prefers silent clamping over having WARNINGS. I think because we check
the constraints during the mount time, so it should be safe to call
this I guess?

> 
> 2. Return an error from mapping_set_folio_order_range() (and the other functions
> that set min/max). No need for warning. No state changed if error is returned.
> FS can emit warning on error if it wants.

I think Chinner was not happy with this approach because this is done
per inode and basically we would just shutdown the filesystem in the
first inode allocation instead of refusing the mount as we know about
the MAX_PAGECACHE_ORDER even during the mount phase anyway.

--
Pankaj

