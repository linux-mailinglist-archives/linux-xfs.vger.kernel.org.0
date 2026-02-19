Return-Path: <linux-xfs+bounces-31073-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QIf6CyzdlmlJpgIAu9opvQ
	(envelope-from <linux-xfs+bounces-31073-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 10:51:40 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D08015D8A9
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 10:51:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1BCE30265A5
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 09:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF5D30F921;
	Thu, 19 Feb 2026 09:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QjGY/HPM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aIGswDF1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9732FB09A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 09:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771494684; cv=none; b=H6siNLIVUX2oyBPGjoxcDB+oLP3k8gXfXYCOoEyJsR97sFONRjZVkr5QbcO0QpQ6fpU1KJADIw7ExcBhoLaavbjtSNEOfgeUXoeODVJm0LD1S6F50bSFLjYUnimjoqSLHpwQWP7DDOXfoOY2lQLXaLBQBZGYbnca4SaJJQXJZ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771494684; c=relaxed/simple;
	bh=qzaET1Zy37x+a+KIo6FvgZb076ajIH6u8Jf7ivmPbBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvDMCeqbIJmY+V8fva+zkjxw9ZXHWueznz8U4L41EX4gW/qWSJJznafB0fEciwPkG69UABGUKOEAcWc8lcLfzOWKXQWtyN4q6AYtC64UJn0/b3QAkkAKDg29YsKvpPBZBgMpbLKoKTMmTHn5HROtzEMnNTaQnIPfPJheCDq0vHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QjGY/HPM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aIGswDF1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771494682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K33V4rOOwYLW15X+o+vqv2I81VqZ2aMaDFF+pr+8/b4=;
	b=QjGY/HPMHSxe4Zvt6wV1pK9bVYeyonNEH+kUeOc1dDmiOqqE9GxgQVpMk5hSZwhLd0SY37
	vXKLCDs8mDNnUNyEkki1/pazADeUyrI5ouphg6S6TYlnKdEzvEszqAscFy1NyCxwu4wU26
	stLe1rSIqPN901vptMsBT5RwfSM75gU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-2nrrsaAaM_ul3xpwCnEPlA-1; Thu, 19 Feb 2026 04:51:18 -0500
X-MC-Unique: 2nrrsaAaM_ul3xpwCnEPlA-1
X-Mimecast-MFC-AGG-ID: 2nrrsaAaM_ul3xpwCnEPlA_1771494677
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48379489438so7747435e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 01:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771494677; x=1772099477; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K33V4rOOwYLW15X+o+vqv2I81VqZ2aMaDFF+pr+8/b4=;
        b=aIGswDF1Np8mHRifm/A9yfQ4bb75R7ov99adkycpJOwhu6sJH3xwxQXLPygSRP/RnD
         FDc6DkoRBb8B6YwbuW08lW6zKBLLHnSG6HUVza0hPcYnY+U07mZjJEXrk4AsozdBb504
         4cXR+x8+TxjdT7SNxyS28oem7R+xDwl+ywU9i5vIF/wSz/SOlIpMXU/IsatgGhwui43v
         WxCvirjtr96+4y4awUjPvvPQo1b96Pdkm0yc9WxT2MpUONpb+wNHJOS50NWhPGEUrYpm
         rxWs6B4EeV08dKRg8ngqEi5BSS/5KppAlUl3vKfHLGO+BbnWX4LdWPos0Eq7AfGUIE6p
         tlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771494677; x=1772099477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K33V4rOOwYLW15X+o+vqv2I81VqZ2aMaDFF+pr+8/b4=;
        b=n8g2uJyXHhIq8ZONGqDockSozhvQtjpUcmABYNbTNRHQ5n8oqqjWHqy9zHIU2HBflt
         AIvroPHdEqWvnC7BWJfMsakni80acAF8IACaVeZaNEcr9aJ/iX9aq39RNE5AIw8DdnjX
         Zxa0/2R07zPqpxRgdnTR0M9hwv+lGOhBAdGrybyna+wvYlqQjtY7hAQeHyilSaBrC/L3
         0ET+oBBMbkW5lOJLQS6npukRBF+0SzFjFCJbcwo+qpjoHmQcyQz1Ey5HnR7uvHBtZYtY
         KnvAi6ooPOPUWQ655NCPiN7IpFinHCsS5QTDwjizv/DncD16/LPxYxlW32UaJg4ZkRTP
         L0EA==
X-Forwarded-Encrypted: i=1; AJvYcCWIaMM4mmwIOZbyM/aa2P1EFbzDXl7jcWj3Tu18dIgv9NqS3CwKuh7840wTqdDBS80QwvH6GNjqm+M=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz8j4gOhOZRH6bFfoifSUcpvgqQqT1fEpAAngBKdbiusuEZ464
	jp8PLEKR45HBcBetfJmMbO63Q1qCNaL63O6j0GONYE1z5jxVDqHiVXyiALr6EAsCudrM6nuClaF
	2REN8+vaJqkqBuRLm/vxfUQ95qiN0w+F8F0yp97S+o/hZmJrf4uGruI1Zygxs
X-Gm-Gg: AZuq6aJRKO425XUwUCnVLha3BhNc5z0FFuNVOTUqAyufIc0OOBBEh2Nvvu2Cnl7FUNd
	qgWEpguPWNumBP+d2tDIIlNE3AEBK+1cbOfwN5ITO0lWvfQvH+IYHizDr5CN9mrOYkKo8KFAdMx
	2nxvevtCKGnUVkTiDpqkZ18OeiMxPcS8yz0C3hZxOYr7Mb8Z2LfU50udVnbbAyYLi1eOhcdyQ87
	8XiK6rNCvMcjPk4zix2KmloH6ofTJTF9xW/hRvgzw30qF2HQeSVjRhBHyivwZyK+q4/q36AzaNq
	z7WPfGM+KGpI2axQPOyknU5n/7muwFYPbznivbOy9Ypq2JoslIn7qSlgddpw0CACb7t2AFGo/we
	/VibbKFOrfco=
X-Received: by 2002:a05:6000:40dc:b0:437:7010:1d0b with SMTP id ffacd0b85a97d-43958df17a3mr7223990f8f.6.1771494677311;
        Thu, 19 Feb 2026 01:51:17 -0800 (PST)
X-Received: by 2002:a05:6000:40dc:b0:437:7010:1d0b with SMTP id ffacd0b85a97d-43958df17a3mr7223941f8f.6.1771494676703;
        Thu, 19 Feb 2026 01:51:16 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5b07fsm48227142f8f.2.2026.02.19.01.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:51:16 -0800 (PST)
Date: Thu, 19 Feb 2026 10:51:14 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 28/35] xfs: add fs-verity support
Message-ID: <4cmnh4lgygm4fj3fixsgy3b7xp2ayo3jirvspoma6qxusdgluu@nyamffhaurej>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-29-aalbersh@kernel.org>
 <20260218064429.GC8768@lst.de>
 <mtnj4ahovgefkl4pexgwkxrreq6fm7hwpk5lgeaihxg7z5zdlz@tpzevymml5qx>
 <20260219061122.GA4091@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219061122.GA4091@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31073-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aalbersh@redhat.com,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7D08015D8A9
X-Rspamd-Action: no action

On 2026-02-19 07:11:22, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 10:57:35AM +0100, Andrey Albershteyn wrote:
> > > > +static int
> > > > +xfs_fsverity_drop_descriptor_page(
> > > > +	struct inode	*inode,
> > > > +	u64		offset)
> > > > +{
> > > > +	pgoff_t index = offset >> PAGE_SHIFT;
> > > > +
> > > > +	return invalidate_inode_pages2_range(inode->i_mapping, index, index);
> > > > +}
> > > 
> > > What is the rationale for this?  Why do ext4 and f2fs get away without
> > > it?
> > 
> > They don't skip blocks full of zero hashes and then synthesize them.
> > XFS has holes in the tree and this is handling for the case
> > fs block size < PAGE_SIZE when these tree holes are in one folio
> > with descriptor. Iomap can not fill them without getting descriptor
> > first.
> 
> Should we just simply not create tree holes for that case?  Anything
> involving page cache validation is a pain, so if we have an easy
> enough way to avoid it I'd rather do that.

I don't think we can. Any hole at the tree tail which gets into the
same folio with descriptor need to be skipped. If we write out
hashes instead of the holes for the 4k page then other holes at
lower offsets of the tree still can have holes on bigger page
system.

Adding a bit of space between tree tail and descriptor would
probably work but that's also dependent on the page size.

-- 
- Andrey


