Return-Path: <linux-xfs+bounces-30179-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MrbrD+AIc2lqrwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30179-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 06:36:32 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C6FC57079B
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 06:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5418930058C8
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 05:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FE132ED3B;
	Fri, 23 Jan 2026 05:36:29 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191D837F8C3
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 05:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769146588; cv=none; b=cvrTgYHQEPfY0I10CQMoT7J7ro5W1HnbioedqJm864mQC80oQ6eHa5rxSpnLhdl+3VBWTI5lN5HJr91JF3I339Ro+MNOkBOWoNAr7StZMstxhC/CI3b08e760uoavKqJTsF+7jry2VW4V2ZmHI8bArPyT/On8cfy+h2Mvz+/Ufg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769146588; c=relaxed/simple;
	bh=Kjczueb1WGVSnPcsyZUWByAa7yim7MvyrY9VlGMam0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/+FKbRwmoQhBhG61hwlN0NZYGO+3Mnz1Ji98GK91BW4RE045lrS5NtKH14ld77jqaol+aVRVhtppwPslGNh2uQ4NtbJlFSrMwD0jLPMg8ywAiB0SHcnWg0r+vjhhf5QFDOGfybCkQG2TymVCUzctIxUPb2H/Iv3RhQMp5P192A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 84090227AAE; Fri, 23 Jan 2026 06:36:19 +0100 (CET)
Date: Fri, 23 Jan 2026 06:36:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/3] xfs: switch (back) to a per-buftarg buffer hash
Message-ID: <20260123053619.GB24680@lst.de>
References: <20260122052709.412336-1-hch@lst.de> <20260122052709.412336-4-hch@lst.de> <20260122181012.GD5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122181012.GD5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-xfs,0391d34e801643e2809b];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	R_DKIM_NA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30179-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: C6FC57079B
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 10:10:12AM -0800, Darrick J. Wong wrote:
> Anyone want to venture forth with a fixes tag?
> 
> (Though I wonder if a less invasive fix for LTS kernels would be to make
> unmount wait for xg_ref to hit zero, though I guess that runs the risk
> of stuck mounts if someone leaks a xfs_group reference)

I tried.  It probably is the patch that initially added the per-ag
rbtrees:

74f75a0cb7033918eb0fa4a50df25091ac75c16e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Sep 24 19:59:04 2010 +1000

    xfs: convert buffer cache hash to rbtree

but as I can't reproduce the issue locally, and getting syzbot to
verify it required horribly hacker to avoid lockdep I can't actually
confirm it.


