Return-Path: <linux-xfs+bounces-31829-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GIVNUsWp2m+dgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31829-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 18:11:39 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 230FD1F4722
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 18:11:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D2C03021E84
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 17:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9338735DA7F;
	Tue,  3 Mar 2026 17:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qi6J9ZGR"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711B33264DE
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 17:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772557694; cv=none; b=gAH2BFzuvRrwZSFILy6pOZQEHbhW9Pd2DbPSyfHMlvJCQc7d75R7VYkMakUrnhbbEehZJFdgkmhWkqbbiDJoNOHlNj3gXQRBMAAt/Gmys9jtqdurRm0nUEJrp8JxX8z+TuXAme9tz2ZuqF1edFnAFCUjyNo/HBEwgpbczrFrl+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772557694; c=relaxed/simple;
	bh=ehpzbk+zVzUXGlF+fBQbtWwsXhDQHZPcheA8B/3EuDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FWwCrFa72XrvswAyoTCoKoMUPRDgtxEFvG3vOQ/dx0NywOD7ef/wmnSqtaRQ2t/knltcWocEGk5DgT0wuRap48dbtI8M3Hd0+6Acvn5hBsrjtlO2FkKpZXg/mMDXI6wsD1D0I+uz9CB1BCFH0opJVf/P4RNrxQyZFFlk894u84U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qi6J9ZGR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F8DC19425;
	Tue,  3 Mar 2026 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772557694;
	bh=ehpzbk+zVzUXGlF+fBQbtWwsXhDQHZPcheA8B/3EuDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qi6J9ZGRLmuCKcrkRLVvKVcWdUxU3okd7AZ5Qf1QfdHR6mfLXd6zQFQZ+B55X3WSy
	 FRB9Kj5qQDANXzNqiAVTzKSdHYs3zt9XjMwP88+n7LBXGqeIFNsRU7cHIEvGBVEfav
	 AJ3gYdsa+JHkCITeyP8uSBom1vF6NSr0SBAQ36zhI8mqg2FQ4/sebUth7YoOynIW8t
	 9xkZ+ZTiHV3evjzNS1cH4LHwZ8PCAokuzshDgfN8Ii3NAM55SpTejn8RLI3k0KG+dZ
	 99KYmOHZrvBQZjPSgIivhJsDzvJ40LvOcj9cocMvzH/y7/3+qK1hVX0i1eCor7KaBd
	 y5Nq6uNgpWVpQ==
Date: Tue, 3 Mar 2026 09:08:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/26] xfs_io: add listmount command
Message-ID: <20260303170813.GN57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783693.482027.14656443953017714472.stgit@frogsfrogsfrogs>
 <aacEs2wlToV8vwu1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacEs2wlToV8vwu1@infradead.org>
X-Rspamd-Queue-Id: 230FD1F4722
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31829-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 07:56:35AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 04:39:33PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a command to list all mounts, now that we use this in
> > xfs_healer_start.
> 
> > +/* copied from linux/mount.h in linux 6.18 */
> > +struct statmount_fixed {
> 
> Shouldn't this use the kernel uapi header and/or a copy of it?
> 
> And be split out of the .c file into a separate header for maintainance
> and eventually nuking once the kernel requirement becomes new enough?
> 
> > +static int
> > +listmount(
> > +	const struct mnt_id_req	*req,
> > +	uint64_t		*mnt_ids,
> > +	size_t			nr_mnt_ids)
> > +{
> > +	return syscall(SYS_listmount, req, mnt_ids, nr_mnt_ids, 0);
> > +}
> 
> Same comment as for the other listmount instance here.
> 
> > +
> > +static int
> > +statmount(
> > +	const struct mnt_id_req	*req,
> > +	struct statmount_fixed	*smbuf,
> > +	size_t			smbuf_size)
> > +{
> > +	return syscall(SYS_statmount, req, smbuf, smbuf_size, 0);
> > +}
> 
> and similar here.

Yeah, I'll move all this into a libfrog .c/.h file.

--D

