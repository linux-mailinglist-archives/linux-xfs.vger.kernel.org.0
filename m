Return-Path: <linux-xfs+bounces-30410-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AwRMUGGeWnjxQEAu9opvQ
	(envelope-from <linux-xfs+bounces-30410-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 04:45:05 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 477939CD45
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 04:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EEB76300915A
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 03:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A3C2C1598;
	Wed, 28 Jan 2026 03:45:03 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665B63090D5
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 03:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769571903; cv=none; b=hJcINfPEiZhg792EC8EzGDWS7O3s6QwaVBgt5lULRdxud6wEtRmFDi9p7gMQ6CKuoC480JGbRH3WgIO/Yr+CiWrcW758qzAQC928x34LuA4dsOr1jmuLF6KpfeLePJ8cmlmjxORpZXFPbvSSgE6m90BBDdcRvPTiFGz5OigzVDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769571903; c=relaxed/simple;
	bh=+ssdpbAJNaWjAJiGNtDk1Jgd3f3uibMFgS5QREE3Kfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N93fP10wB4iw1N1GygoXXCHUiGcQmDBMFnLSX6Yl0f0MSVTM+pEZgq89/HkJDn25Fw5gsoC+UGyUmRhEDEtlRnAHc2674G/bhaD9d36DOCbK4cxOfqA7XzLZF4y6ertQH7pgOHahllpy6P9mODU6Ii9XmemFhPYgAdR5SnfKa9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC807227A8E; Wed, 28 Jan 2026 04:44:59 +0100 (CET)
Date: Wed, 28 Jan 2026 04:44:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <20260128034459.GB30989@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-5-hch@lst.de> <20260128013525.GD5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128013525.GD5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	R_DKIM_NA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-30410-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 477939CD45
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 05:35:25PM -0800, Darrick J. Wong wrote:
> > +	xfs_warn_ratelimited(mp,
> > +"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"",
> > +		delay, file, line,
> > +		mp->m_super->s_id);
> 
> Hrm.  This changes the logging ratelimiting from per-injection-site to
> global for the whole kernel.

True.  But this has a total of three callsites and now matches what the
more common XFS_TEST_ERROR does.  So if this was an issue, we'd have
noticed it with XFS_TEST_ERROR.

Talking about dmesg - one thing that annoys me for both of them is
that the messages is prefixed with the file system ID, but then
also adds ', on filesystem \"%s\"' at the end, which is a bit silly.

