Return-Path: <linux-xfs+bounces-30409-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJX8FruFeWnGxQEAu9opvQ
	(envelope-from <linux-xfs+bounces-30409-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 04:42:51 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EE6AF9CD17
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 04:42:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 575F9300914E
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 03:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9A932E12E;
	Wed, 28 Jan 2026 03:42:39 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47EF1A3029
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 03:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769571759; cv=none; b=UgkibaIphw1UcbJet5GlsznPYDNOE1Yqdc8il6HThG51x3bEHT+mSBCHV2127bDgCCH6hTHmf7nKbcpp1zN0cc4xQtZykv6mcvMqxktPGU+f5oJrd3LespfbpkdXlg41NWvq/NuWbfamGVdJOjgDS25wcu3+LW1IcQnYts2WSWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769571759; c=relaxed/simple;
	bh=7MrGaCEkdvXfGqLDGY/aTXowRQ6nGmPD4FRNZtfhmdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NfFHJCCcE+IQfPwMiGAJcO8qoRKdDf6WMSID0TK5uM5BwCFvY51auwZSsxSyO4WfP6LdHmXr+OV5RD66aIHv9XFxRqFnnAuTE1ZplSRNJJa1KABwYwQpea+nHh/pyn9xyDRns6fBZWa5yRVHgxRVoq7S0jJyxJAuWIVn+lkHZew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EB2EE227A8E; Wed, 28 Jan 2026 04:42:35 +0100 (CET)
Date: Wed, 28 Jan 2026 04:42:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: allocate m_errortag early
Message-ID: <20260128034235.GA30989@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-3-hch@lst.de> <20260128013259.GB5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128013259.GB5945@frogsfrogsfrogs>
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
	TAGGED_FROM(0.00)[bounces-30409-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: EE6AF9CD17
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 05:32:59PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 27, 2026 at 05:05:42PM +0100, Christoph Hellwig wrote:
> > Ensure the mount structure always has a valid m_errortag for debug
> > builds.  This removes the NULL checking from the runtime code, and
> > prepares for allowing to set errortags from mount.
> 
> Hrmm.  Are you /sure/ you want to allow errortag mount options?
> Saying that only because I really hate mount options.

Well, if you have any other good idea to add error tags at mount
time I'm all ears :)


