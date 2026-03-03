Return-Path: <linux-xfs+bounces-31828-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AF3hDO4Vp2ncdQAAu9opvQ
	(envelope-from <linux-xfs+bounces-31828-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 18:10:06 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 851621F46E4
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 18:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC76D3007CB4
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 17:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E001351C12;
	Tue,  3 Mar 2026 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLHuUCQP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0205351C17
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772557586; cv=none; b=kPLRQO4aim5x+NuCX0RGHY4TqROSDP5jnQAj5GG9hJxZ0c8WpEprl3yAjNdk1yUMWeof60SEW2WPmaPAHpDcF0JYbBFp34N1iymY7vCMnC/F7E0vtTXceksMbwGv5qXyqcAZ4z+ouXoFUOPLqNfuE3+zdo8zbI/nRmoX/ZBXrv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772557586; c=relaxed/simple;
	bh=vyAoLeihvZ8MY6MWA90CuB9wsHyY25nB6K4h6XsbEE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwjWzbs/cIHI8cBbW6lHTt18vncjvT/LPMuWPIj4k1cXil/BLhxtlOT/XwkRgvpk2PBBWLy9hrNDdR0eL51y+uAljN0l3Ayn+0FfShjI80wqrQ6GLg9qoUFpDc8WfZgQoZ+eo93M6oEM4+HAplXgNHHNDHDGpx+E5RHFdyF8UWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLHuUCQP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC7EC116C6;
	Tue,  3 Mar 2026 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772557586;
	bh=vyAoLeihvZ8MY6MWA90CuB9wsHyY25nB6K4h6XsbEE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OLHuUCQPIl15a+GLlVQgcqY60eRn+XaGcixEkI1wLuXAJUDZqauukx1NImAvSUQ1B
	 HgZluszs/nulIeKFoPAplOW5kvsSYuDOsoqpCTzzUjbJ8be3S23P0g1KPpG7ElrwQ7
	 cjNzdCVT4nPwLJnQfGSF0s46/F00+lJYGA1fMb5IxooOi+/60GmEDfRSeRMwtV/+r1
	 d0VVEzcrpu5Tsf7sXN1rXPsL+cA/EbxJyjQeKbXgreR2z39TfdsXVnDl3gFa5qz39t
	 3md4cVme1Vi0Ckm6bmtt72W/O7eivTGH9nw5a1H0UGa3wFiGBU+n7pqHDVEW1By6C9
	 Rv4FfbylN/C4Q==
Date: Tue, 3 Mar 2026 09:06:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/26] xfs_healer: create a service to start the
 per-mount healer service
Message-ID: <20260303170626.GM57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783527.482027.17759904859193601740.stgit@frogsfrogsfrogs>
 <aacDDXudwf9ygIkQ@infradead.org>
 <20260303165221.GK57948@frogsfrogsfrogs>
 <aacSNL9qWjo8NIo-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aacSNL9qWjo8NIo-@infradead.org>
X-Rspamd-Queue-Id: 851621F46E4
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
	TAGGED_FROM(0.00)[bounces-31828-lists,linux-xfs=lfdr.de];
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

On Tue, Mar 03, 2026 at 08:54:12AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 08:52:21AM -0800, Darrick J. Wong wrote:
> > > > +	while ((ret = syscall(SYS_listmount, &req, &mnt_ids, 32, 0)) > 0) {
> > > 
> > > Should this use a wrapper so we can switch to the type safe libc
> > > version once it becomes available?
> > 
> > What kind of wrapper?
> 
> For calling the listmount system call.
> 
> > or did you have something else in mind?  The manual page for listmount
> > says that glibc provides no wrapper[1].
> 
> Ånd there are no plans to provide one? :(  Even if so having a libfrog
> wrapper would be nice rather than open coding syscall() in at least
> two places in this series.

Oh, I see.  Yes, I could create a libfrog helper to wrap the listmount
callsites.

I can't tell what sorts of discussions glibc may or may not have had
because sourceware is barely reachable due to AIDDOS attacks or whatever
the reason du jour is, and given that the archives are pipermail they're
probably not searchable anyway. :(

Google, FWIW, shows a discussion from November 2023 that seems to have
dried up, and the glibc gitweb doesn't produce any hits for listmount or
statmount.

So my guess is that we can just make our own libfrog wrapper and if libc
support ever shows up we can always port.

--D

