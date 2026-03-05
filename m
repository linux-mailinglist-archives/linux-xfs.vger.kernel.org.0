Return-Path: <linux-xfs+bounces-31960-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBXzMBf9qWnNJAEAu9opvQ
	(envelope-from <linux-xfs+bounces-31960-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 23:00:55 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A75218BEC
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 23:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D2492300E3FD
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2026 22:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EBD361DA6;
	Thu,  5 Mar 2026 22:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKbocx3z"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA2535F180
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 22:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772748052; cv=none; b=CrsJCBhIdp5ctbdpitwWLcNzCFa9M8neAVfZsztU8uR4IHiXf/vxKwBwyqItsfWFwA2MwUJcW6XxZLdA2RHyhhSTV6xfSSxqy3Wm6SSrtj3TBzICSzzD0aqalkuu9M+WyfQOkljtTp1QmNDXiz5B6gHUEtZRAMfAe7NacgxHE5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772748052; c=relaxed/simple;
	bh=fEXeooMXXx873akaI9eEsdD+sCwFDMoBfqq4mVPwtdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AoA6BOcB95Lbm8/lzv2qAeVjbUG53tXb8yCM5ZVKKsDvYzwlB0bVtiw2t8itn2t4VHyRfXylDsWOBJu5svpDn6gSQPjq3YavtszelTBN7EPjbNtnqCjk3hJpykAvPUwhh4O71Euh1khQa/4noqoZupVDTaevU+D4yvec1dT8T4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKbocx3z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7575CC116C6;
	Thu,  5 Mar 2026 22:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772748052;
	bh=fEXeooMXXx873akaI9eEsdD+sCwFDMoBfqq4mVPwtdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OKbocx3z72djAEAFdpIjnda1KfLd2uRkXvkAVBFZh3Ad5G5kt+2fqbLK+vXHcP26d
	 b/tNo7zbsBgGtbsFsmnO0upxWz+bwb5JNvyI2kU0ou5a7AYHWC8WTgTYDhvb7QCsqw
	 Rt/L2+wiUm4f1FeHiGZUsaMYiTjQBLHLpcKK2MlaEEbyhMJkGSocSSYaghZh3Lp5cj
	 GBxagUECWXgepazu1ku/vPvy6+PlhSdrJKs6wh4cGp7PJeudUzu5TTnXNjSdIAQkPC
	 UuviRjl0z1NevtCoSN4+b0T0MM1j7qOAkENGUHYKXkmCyCnP6Ztrk20sjTEYikP3uC
	 WhR9KlB3XxJ+g==
Date: Thu, 5 Mar 2026 14:00:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <20260305220051.GG57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
 <aacE3gW9j6pKrspy@infradead.org>
 <20260303172916.GR57948@frogsfrogsfrogs>
 <aagt0pZTkqysyjQJ@infradead.org>
 <20260304163502.GV57948@frogsfrogsfrogs>
 <aamLP5UnWiPhvKqh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aamLP5UnWiPhvKqh@infradead.org>
X-Rspamd-Queue-Id: 41A75218BEC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31960-lists,linux-xfs=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026 at 05:55:11AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2026 at 08:35:02AM -0800, Darrick J. Wong wrote:
> > On Wed, Mar 04, 2026 at 05:04:18AM -0800, Christoph Hellwig wrote:
> > > On Tue, Mar 03, 2026 at 09:29:16AM -0800, Darrick J. Wong wrote:
> > > > (That was a long way of saying "can't we just keep using xfs_io as a
> > > > dumping ground for QA-related xfs stuff?" ;))
> > > 
> > > I really hate messing it up with things that are no I/O at all,
> > > and not related to issuing I/O or related syscalls.  Maybe just add
> > > a new little binary for it?
> > 
> > How about xfs_db, since normal users shouldn't need to compute the
> > service unit names?
> 
> Still seems totally out of place for something not touching the
> on-disk structures.  What's the problem with adding a new trivial
> binary for it?  Or even just publishing the name in a file in
> /usr/share?

Eh I'll just put it in xfs_{scrub,healer} as a --svcname argument.

$ xfs_scrub --svcname /home
xfs_scrub@home.service
$ xfs_scrub --svcname -x /home
xfs_scrub_media@home.service
$ xfs_healer --svcname /home
xfs_healer@home.service

--D

