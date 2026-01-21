Return-Path: <linux-xfs+bounces-30049-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oAcYGHG+cGkRZgAAu9opvQ
	(envelope-from <linux-xfs+bounces-30049-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 12:54:25 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C68315650F
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 12:54:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 36268968719
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 11:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A704A3ECBE7;
	Wed, 21 Jan 2026 11:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lpv56kwp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834CA3ECBDA
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 11:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768995929; cv=none; b=IfKor7NUrauD24txS/jwNtZm7o6GMOWQ3rlzgxX4AMZ/D4+Jv172k2vJ6NjK+h8StP2uGnUIGufgTLJ5N7/PNe84Y6l5fiSBNdkqzQJQwhtYHtnz6UH927ESZX1Xg9+hw2mq6kxsgo7j0NmSKvSxZL/w9ptJ5iXfG5Bmy94+/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768995929; c=relaxed/simple;
	bh=ENhfutPw1CvDtl2Qs38RAQleEPX6GZS65XF1T5uyeh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PYL3ggeCDuVP5m0lV6Dc8hleYa5PUVWs53bMXcuqrEcsQuWTgg5eaqsCISNRzSfg5GlwFmJN8VQSrvd7saIrSOzl8nBPzVG/eTsLFJQ8zfleJQdZxpHr50vXj0jHZeM9h/gH/XJKveQX7AU5Zjj2pshWOzk5FGA/tli4KpN6LsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lpv56kwp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EA3C116D0;
	Wed, 21 Jan 2026 11:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768995929;
	bh=ENhfutPw1CvDtl2Qs38RAQleEPX6GZS65XF1T5uyeh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lpv56kwpBDMwPRHKD8U9M2qqcVyzFARlmVzBHYnKJ+IYbZa7E56n9Ddpeh4xhm8D6
	 YtWSSrf+boTCRQtcx+4BbbBJEgj4pcuE33Ks04OqG906gkw/nYMVkLV+SydC1boovT
	 UMqYzpsqoD2fCWO3GippN3o7rONVzrZ2IRm839ReNGsWU8TerHAAV4X6+MDCLAzraz
	 j8G5Co0YL6UbdlxKDDmY4h84AMiH9w2Gs3qy2hluQ6TuVwrgR1SqOlSSZ1kALW25mo
	 jXXjnL3IUmVuMVeuzBitRT0JtDNbs+Tuv50IdFsaj3RnH28x6XCfQA2r4rTZcKKdce
	 1jGjNWB/6MWqQ==
Date: Wed, 21 Jan 2026 12:45:25 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: promote metadata directories and large block support
Message-ID: <aXC8SH8-zyV789X0@nidhogg.toxiclabs.cc>
References: <a-5vQeWw6LnfGOvRdoGMbRxWS78ETAGa-UfYR5B0xb2DUlK_XJ43X9QV2mRZtYr-x9XokBbT2TNzi1NxvqD7vQ==@protonmail.internalid>
 <20260121064540.GA5945@frogsfrogsfrogs>
 <fbrzrkzqvwua64imzt2ii67uwre2fyqj47mogqj2gsrnlgk4my@k62y3yxnqm53>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbrzrkzqvwua64imzt2ii67uwre2fyqj47mogqj2gsrnlgk4my@k62y3yxnqm53>
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30049-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: C68315650F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 11:07:04AM +0100, Carlos Maiolino wrote:
> On Tue, Jan 20, 2026 at 10:45:40PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Large block support was merged upstream in 6.12 (Dec 2024) and metadata
> > directories was merged in 6.13 (Jan 2025).  We've not received any
> > serious complaints about the ondisk formats of these two features in the
> > past year, so let's remove the experimental warnings.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_message.h |    2 --
> >  fs/xfs/xfs_message.c |    8 --------
> >  fs/xfs/xfs_super.c   |    4 ----
> >  3 files changed, 14 deletions(-)
> 
> Looks good to me too.
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Sorry, this was supposed to be
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

:)

> 
> > 
> > diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> > index d68e72379f9dd5..49b0ef40d299de 100644
> > --- a/fs/xfs/xfs_message.h
> > +++ b/fs/xfs/xfs_message.h
> > @@ -93,8 +93,6 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
> >  enum xfs_experimental_feat {
> >  	XFS_EXPERIMENTAL_SHRINK,
> >  	XFS_EXPERIMENTAL_LARP,
> > -	XFS_EXPERIMENTAL_LBS,
> > -	XFS_EXPERIMENTAL_METADIR,
> >  	XFS_EXPERIMENTAL_ZONED,
> > 
> >  	XFS_EXPERIMENTAL_MAX,
> > diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> > index 19aba2c3d52544..5ac0ac3d4f39f9 100644
> > --- a/fs/xfs/xfs_message.c
> > +++ b/fs/xfs/xfs_message.c
> > @@ -149,14 +149,6 @@ xfs_warn_experimental(
> >  			.opstate	= XFS_OPSTATE_WARNED_LARP,
> >  			.name		= "logged extended attributes",
> >  		},
> > -		[XFS_EXPERIMENTAL_LBS] = {
> > -			.opstate	= XFS_OPSTATE_WARNED_LBS,
> > -			.name		= "large block size",
> > -		},
> > -		[XFS_EXPERIMENTAL_METADIR] = {
> > -			.opstate	= XFS_OPSTATE_WARNED_METADIR,
> > -			.name		= "metadata directory tree",
> > -		},
> >  		[XFS_EXPERIMENTAL_ZONED] = {
> >  			.opstate	= XFS_OPSTATE_WARNED_ZONED,
> >  			.name		= "zoned RT device",
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index bc71aa9dcee8d6..1f432d6645898e 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1835,8 +1835,6 @@ xfs_fs_fill_super(
> >  			error = -ENOSYS;
> >  			goto out_free_sb;
> >  		}
> > -
> > -		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_LBS);
> >  	}
> > 
> >  	/* Ensure this filesystem fits in the page cache limits */
> > @@ -1922,8 +1920,6 @@ xfs_fs_fill_super(
> >  			goto out_filestream_unmount;
> >  		}
> >  		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_ZONED);
> > -	} else if (xfs_has_metadir(mp)) {
> > -		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_METADIR);
> >  	}
> > 
> >  	if (xfs_has_reflink(mp)) {
> > 
> 

