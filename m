Return-Path: <linux-xfs+bounces-30390-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MCQaMunqeGmHtwEAu9opvQ
	(envelope-from <linux-xfs+bounces-30390-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 17:42:17 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73DD197E37
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 17:42:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F42213007505
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 16:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7883361652;
	Tue, 27 Jan 2026 16:42:14 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9357835EDC9
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769532134; cv=none; b=bv1nn+tohkxK3LiLE+yOFS7i317hoyJUgAMqxdP2tI5kA+C0+M/3p9XIrxYSTGXUx0z42Fj7Cxn0/kF/9vkKDhwBAUYNu5OsaznuM4/QLbmmaf3zpzqHPGhG11aL7naF3wCrMx+TfALQHGf/8F7liDabM70orwWq1r/MYyI3/KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769532134; c=relaxed/simple;
	bh=TmbzlUcuat7oVxMU8X7UFn3KDk2Tgls7t2uN2f+GyMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxYwjkM8+9fibLxJTssjgyt4hSjXVv5XINRuHYJ5P3VUnCyfLygEU9BlDflqZi7Idyu4s+SWEq+q1fO8fJGCLzG0Xc67ratfAN3P019SK1Beaxlngi5kFP00LXDkp10PGNcVfv1pG96XlTBPIJ2QeXm4TQvXRS+aiWHpwm14Zx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 450EA6732A; Tue, 27 Jan 2026 17:42:09 +0100 (CET)
Date: Tue, 27 Jan 2026 17:42:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: don't keep a reference for buffers on the LRU
Message-ID: <20260127164208.GA8761@lst.de>
References: <20260126053825.1420158-1-hch@lst.de> <20260126053825.1420158-2-hch@lst.de> <aXe-EkVrEB-UhNy2@bfoster> <20260127052050.GB24364@lst.de> <aXjc2gsNToSSANmn@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXjc2gsNToSSANmn@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.999];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,lst.de:mid];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30390-lists,linux-xfs=lfdr.de];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 73DD197E37
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 10:42:18AM -0500, Brian Foster wrote:
> IOW, I'm not arguing for or against a change in buffer lifetime behavior
> here, just that it should probably be done separately with some more
> careful analysis. The secondary advantage is that if this behavior does
> somehow uncover something problematic, we can bisect/revert back to
> historical lifetime behavior without having to walk back these
> functional changes.

Allright, I'll see if I can split it out.

