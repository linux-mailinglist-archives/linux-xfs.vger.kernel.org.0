Return-Path: <linux-xfs+bounces-31897-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBikID5fqGmduAAAu9opvQ
	(envelope-from <linux-xfs+bounces-31897-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 17:35:10 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC5B2045EB
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 17:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 797D030098B3
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2026 16:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DA336D9E1;
	Wed,  4 Mar 2026 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qtf2aHyi"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E950E35E948
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 16:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772642104; cv=none; b=kdHINnZRm2QOnIPcRTHECSyh5DlmOVkAWzXPMROLtMwnHoJweDVxjktbgnAVHuvT0FUVz5EAXEsN5qM7c8/vQNFCEDgQBuKCwEsPBCXzZcCAJqwtwhdyoYzAFNC2wGtsXxGt3YiP4IEogRoESzMYDYEpjMfdm6nIrBSkGaY/6Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772642104; c=relaxed/simple;
	bh=LV/NmH2Icjkm167Lisysr8e5DoR2luFIm2fACHqaFJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCkVjAJofjHNYIiwGs8TQR7z7Alc8Ff2h5wgpG/n+ZCpa9WcY/cSRIFxxhA7oCrB/mCWtiPfxD49WNpwc/zzdpWPZ8Av1XoVJ+TvyQG+2xrNeXjNusd5udOI3jfl9se8mvScDBfRD2CBZi2DEgoHqNO94GbGQLp6kGo3PJymGKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qtf2aHyi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55793C4CEF7;
	Wed,  4 Mar 2026 16:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772642103;
	bh=LV/NmH2Icjkm167Lisysr8e5DoR2luFIm2fACHqaFJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qtf2aHyiMau2TQwneGmseRRBkorTTbT+YehZOHQH2aBiyg1Uoj7VsLiypvHOyg2E/
	 R459mc4MGTcoaMYM239+6QMWwD/xxmxqzxLX17jIa5dGyi2tzlL5gEho3SpzDIvaD7
	 hQXh2eFZSvyF8CSQ7+vQlX+ZaHhbyixG4q+u/HH01MIjVY4H7pz2dzrv987PPwc06a
	 8n/nfkpOQ90moCifky2hx48wi1zgaBn6/6b+iVXYLaq3a7PPJBiAODcIunBXvdKDSs
	 3ezgzjWhWdq7XbHoXEjvmKsF39kd2FmEuDv6tFNfv/ef9x9trFg9PVGH8lsFrWQxoj
	 XUIhdM8Gti6KA==
Date: Wed, 4 Mar 2026 08:35:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <20260304163502.GV57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
 <aacE3gW9j6pKrspy@infradead.org>
 <20260303172916.GR57948@frogsfrogsfrogs>
 <aagt0pZTkqysyjQJ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aagt0pZTkqysyjQJ@infradead.org>
X-Rspamd-Queue-Id: 2CC5B2045EB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31897-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 05:04:18AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 09:29:16AM -0800, Darrick J. Wong wrote:
> > (That was a long way of saying "can't we just keep using xfs_io as a
> > dumping ground for QA-related xfs stuff?" ;))
> 
> I really hate messing it up with things that are no I/O at all,
> and not related to issuing I/O or related syscalls.  Maybe just add
> a new little binary for it?

How about xfs_db, since normal users shouldn't need to compute the
service unit names?

--D

