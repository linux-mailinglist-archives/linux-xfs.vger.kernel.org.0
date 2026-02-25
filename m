Return-Path: <linux-xfs+bounces-31268-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AnmJluInmnwVwQAu9opvQ
	(envelope-from <linux-xfs+bounces-31268-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 06:27:55 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C102919204B
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 06:27:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4B18B300D55E
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 05:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064B02D46A1;
	Wed, 25 Feb 2026 05:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g6ShyyeS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3322C11DD
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 05:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996668; cv=none; b=vE5WxMEC6uEj5s+rNW0DRon5quF1r+Prqd19/uXMHEp9j0ychR0ISbrstnwwf4P9YuK3LizYQgk9zvtjqyzMcsDG3QnJT1oKRyWBcyOX7dgL5j8l1VNi2405v160ZnJMuain1cqtdEIyOMyJxeHRHNU8yJGMZkyN5Fyisdb9lw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996668; c=relaxed/simple;
	bh=Wgn5r/lPJPjsgA4MoDbSJYHnfAMkY8qlZA+J5phAEng=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=bKBJS6IqsheBc5nj6zBZ6RMNZ4tvP+8FgZvRkVSsGxOpz9GLsBuF/YR8EwKtbMGPm+735h1P4hOUb81NRWYAOCQy1R40UyZf4MKusQBiHWoBG9onqTGVDC1JoZ8R5q4GuNiKmwYpAKfMARDWnOjrigqrXSdd0rQKuAibRSUy9zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g6ShyyeS; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c70ea5e9e9dso74515a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 21:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771996667; x=1772601467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tm/pFrokwWEbL0vu5bebZLYMxEX5AVIntN1lmNVMkbg=;
        b=g6ShyyeSv0aFRGY4MVQPnQrVDMhUZTZLreic1e9Mi1wkbRFaqQo73+AfPENcm16DGN
         QbFmjdbNtfyQymDjKZv8nxyy1JIZwmeTUVJUANzz55/xiYMEF4IMiyky8n8kTFkZ0yQL
         KxgjcgwSn6HenWC2eiWqm1rUWOvxQm9IXFzvl3vQeGiFsth6ti2s3TY81zuIubu6gI53
         tM7u82MscgAD/GNEFAVdyufZUGtKvQ4WQuFlugbTGKKXUw5XdmbFukdalRNRQWnvSyEX
         Nvp8Q1447Y/BzQp26sXRq+nvQczMi5xFVWDx8gKQ3pQ6Z2h6kw8ad1bQ0MDudjnkgagC
         36Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771996667; x=1772601467;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tm/pFrokwWEbL0vu5bebZLYMxEX5AVIntN1lmNVMkbg=;
        b=VrRcbJxchN997AmXsE4feWbqRhLnJbu/1FC4QaLHGQDk4dsuP6+zHtIxauCerS6B+s
         KxmmZr45pyg5bTMgBS1AdReVksEcz0ncky+MeYPJlRTlhHlYmgopkyEuLIKt7kG4WJl6
         pyTxNqUp1979T/CSd5+Ye7HtGe4VFWBwXjA0rGOSSYYMV4AgkLXafJJO4OEiUU4zXkdR
         HErzZ2w1Bm4eQq2ZiC1y8HAntnOaUBD2xFAT6L6ZY6CFcBVZFuEAPgqXnqWIDfllH1dn
         DyUWjDp2ynmTglXabPe+iqKNOG9G07U/r180BNUdtbeC16ZejyXU/03vGTKKGf8b+0BM
         DekQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqeKDqf4W7pt8bGCSdY36pZqgmPw5BMB4ypeBi0Wdf3uVvRTNtxkYC3xz4mM7Hm1vNCGh3h692IHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys+XB3WxYb/gQCFdqL6+7gfRZ/IC9vxKDhg5xWCasCSScl2Fe8
	qTQdwZ7ZZ4LBSE2uha2wv3n5a1YB1fjTj12nsJt1WOaL6uM9PtSEjYBW
X-Gm-Gg: ATEYQzxJm11K50tnfznpS5xq7lCkwV+sD86Fo76GiwkMr99PFAWPTR72jL0JNopaIwo
	+SGlrAWmBtsYHtHjJMRxLWrmsNogC9Su+k4Yw2Fg/M6qTqx5JjukyQpQXuPzNEYZU/rutuav7Cf
	OcW7Rwr0E+wNIQyVIBGL5c6z59GIQnvzRYiM11/HUFHh6L6wbeq/cAeEZdF5+IX0Jse6oCbIIuK
	OlsV6bTrw0+JzueQC9qMrQXYBLJLCpzzsrn0ZkScemCg6hC7yiTJFVEH+wJXue+uLRSD8G02KPO
	GehQ9oOpWhPYBKyHbW7tftQmbns/np+h/Kgb539ifgPihg8qoy2zYTeI8LWvicKBleDjTio1KCI
	wXbTBFUsHF5x5sJqGFZlkL0O6i5li17MZNGuSFlz2MOW/EcI8Q33eWLDy0AipSR2Po0F5kz/hlf
	2BBBWFiOe6eOVmUdnsz+d5D+6Uck2poWMv6EqFprZldC2XLSCdp36h0KfX/v/vL7YF7Luyok0FO
	MeB7KOche57+w==
X-Received: by 2002:a17:90b:314a:b0:356:7917:23c with SMTP id 98e67ed59e1d1-3590f1afabdmr1140696a91.27.1771996666950;
        Tue, 24 Feb 2026 21:17:46 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.233.55])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359019780bfsm1434203a91.8.2026.02.24.21.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 21:17:46 -0800 (PST)
Message-ID: <d7853e26511631b9ca9a28bb691bbe82765640c0.camel@gmail.com>
Subject: Re: [RFC v1 4/4] xfs: Add support to shrink multiple empty realtime
 groups
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, david@fromorbit.com, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Date: Wed, 25 Feb 2026 10:47:40 +0530
In-Reply-To: <aZasXfB-GUiGT4yc@infradead.org>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
	 <1a3d14a03083b031ec831a3e748d9002fab23504.1771418537.git.nirjhar.roy.lists@gmail.com>
	 <aZasXfB-GUiGT4yc@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,fromorbit.com,vger.kernel.org,gmail.com,linux.ibm.com,linux.alibaba.com];
	TAGGED_FROM(0.00)[bounces-31268-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.989];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nirjharroylists@gmail.com,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C102919204B
X-Rspamd-Action: no action

On Wed, 2026-02-18 at 22:23 -0800, Christoph Hellwig wrote:
> Just q quick glance, no real review:
> 
> > +int
> > +xfs_group_get_active_refcount(struct xfs_group *xg)
> > +{
> > +	ASSERT(xg);
> > +	return atomic_read(&xg->xg_active_ref);
> > +}
> > +
> > +int
> > +xfs_group_get_passive_refcount(struct xfs_group *xg)
> > +{
> > +	ASSERT(xg);
> > +	return atomic_read(&xg->xg_ref);
> 
> Using "get" to read a refcount value is very confusing.  Looking
> at the users I'm tempted to say just open code these and the
> ag/rtg wrappers.

Noted.
> 
> > -	rtg = xfs_rtgroup_grab(mp, prev_rgcount - 1);
> > +	if (prev_rgcount >= mp->m_sb.sb_rgcount)
> > +		rgno = mp->m_sb.sb_rgcount - 1;
> > +	else
> > +		rgno = prev_rgcount - 1;
> > +	rtg = xfs_rtgroup_grab(mp, rgno);
> 
> Throw in a comment that this is about grow/shrink?

Noted.
> 
> > +void
> 
> Stick to the unique XFS style here and in other places, please.

Sure.
> 
> > +xfs_rtgroup_activate(struct xfs_rtgroup	*rtg)
> > +{
> > +	ASSERT(!xfs_rtgroup_is_active(rtg));
> > +	init_waitqueue_head(&rtg_group(rtg)->xg_active_wq);
> > +	atomic_set(&rtg_group(rtg)->xg_active_ref, 1);
> > +	xfs_add_frextents(rtg_mount(rtg),
> > +			xfs_rtgroup_extents(rtg_mount(rtg), rtg_rgno(rtg)));
> > +}
> > +
> > +int
> > +xfs_rtgroup_deactivate(struct xfs_rtgroup	*rtg)
> 
> It might also make sense to explain what activate/deactive means here.

Okay, will update in the upcoming revisions.
> 
> > +{
> > +	ASSERT(rtg);
> > +
> > +	int			error = 0;
> 
> No need for the assert, and code goes after declarations.

Noted.
> 
> > +	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
> > +	struct	xfs_mount	*mp = rtg_mount(rtg);
> > +	xfs_rtxnum_t		rtextents =
> > +			xfs_rtgroup_extents(mp, rgno);
> 
> This assignment fits onto a single line easily.

Okay - will fix this in the next revision.
> 
> > +	ASSERT(xfs_rtgroup_is_active(rtg));
> > +	ASSERT(rtg_rgno(rtg) < mp->m_sb.sb_rgcount);
> > +
> > +	if (!xfs_rtgroup_is_empty(rtg))
> > +		return -ENOTEMPTY;
> > +	/*
> > +	 * Manually reduce/reserve 1 realtime group worth of
> > +	 * free realtime extents from the global counters. This is necessary
> > +	 * in order to prevent a race where, some rtgs have been temporarily
> > +	 * offlined but the delayed allocator has already promised some bytes
> > +	 * and later the real extent/block allocation is failing due to
> > +	 * the rtgs(s) being offline.
> > +	 * If the overall shrink fails, we will restore the values.
> 
> Formatting: use up all 80 characters.

Okay.
> 
> > +	xfs_rgnumber_t          rgno = rtg_rgno(rtg);
> > +
> > +	struct xfs_rtalloc_args args = {
> 
> Weird empty line between the declarations.

Will fix this.
> 
> > +bool xfs_rtgroup_is_empty(struct xfs_rtgroup *rtg);
> > +
> > +#define for_each_rgno_range_reverse(agno, old_rgcount, new_rgcount) \
> > +	for ((agno) = ((old_rgcount) - 1); (typeof(old_rgcount))(agno) >= \
> > +		((typeof(old_rgcount))(new_rgcount) - 1); (agno)--)
> 
> I don't think this is helpful vs just open coding the loop.  The mix
> of ag and rg naming is also a bit odd.
> 
> > +	for_each_rgno_range_reverse(rgno, old_rgcount, new_rgcount + 1) {
> > +		rtg = xfs_rtgroup_get(mp, rgno);
> 
> Given that we have this pattern a bit, maybe add a reverse version
> of xfs_group_next_range to encapsulate it?

Okay - I will try to come up with something. Thank you for the suggestion.
> 
> 
> Highlevel note:  this seems to only cover classic bitmap based RTGs,
> and not zoned ones.  You might want to look into the latter because

Okay. So are you suggesting to add the shrink support only for the zoned devices or extend this
patch set to cover shrink for the zoned devices too?
> they're actually much simpler, and with the zoned GC code we actually
> have a super nice way to move data out of the RTG.  I'd be happy to
> supple you a code sniplet for the latter.

Sure, that would be super useful. Also, since I don't have much experience in zoned devices, can you
please point to some relevant resources and recent zoned device related patchsets that can help me
get started with?
--NR


