Return-Path: <linux-xfs+bounces-30178-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ODt6NS4Ic2k7rwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30178-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 06:33:34 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8963B70782
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 06:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 40981300A8D7
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Jan 2026 05:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FE739283D;
	Fri, 23 Jan 2026 05:33:32 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F413921ED;
	Fri, 23 Jan 2026 05:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769146411; cv=none; b=DYxhDuEjVSnc0bN+Y0wVz4rwCRSeUCJrl6A6la1tlMlF19k4Pq1d+G3Qa8Xf9X5zByqX94Afl+ODH9TcjnCf26VHZc2KIeSY1x6UMGIwUHv0ycfLrhlhHO7r8s0IMySZRE9TTSmvNE6MjPoyzlUPn3dgevCso7w8U5mZSw6My9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769146411; c=relaxed/simple;
	bh=feINpxCb6vPK7KCsrsFhjPiqwiH8fQms8QdLTvJuuwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxcEZ/XKO4+vmJOqyHH4sAbXnXbwI74/wVHV828gfA8+X4u+FUaXpx/EHk7L34YvKggtLQoOmKvgRafVyLLIKb/cYivN7JulUsA5L9ST+vAX2qiX8zPwSTSzxAjgr5ewrQqtFqgTdTNNte1WMjOs2LqQuLOavVjXmIyrusZ7TZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 88E1C227AAE; Fri, 23 Jan 2026 06:33:23 +0100 (CET)
Date: Fri, 23 Jan 2026 06:33:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, r772577952@gmail.com,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: check the return value of xchk_xfile_*_descr
 calls
Message-ID: <20260123053323.GA24680@lst.de>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs> <176897723563.207608.1472219452580720216.stgit@frogsfrogsfrogs> <20260121070323.GA11640@lst.de> <20260121182208.GH5945@frogsfrogsfrogs> <20260122055748.GA23964@lst.de> <20260122185701.GO5966@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122185701.GO5966@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.987];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	R_DKIM_NA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-30178-lists,linux-xfs=lfdr.de];
	FREEMAIL_CC(0.00)[lst.de,kernel.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 8963B70782
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 10:57:01AM -0800, Darrick J. Wong wrote:
> > > Alternately we just drop all the helpers and kasprintf crap in favor of
> > > feeding the raw string ("iunlinked next pointers") all the way through
> > > to shmem_kernel_file_setup.
> > 
> > But wouldn't we get duplicate names for different inodes?
> 
> Yes, but that's only used for readlink of /proc/$pid/fd/* so (AFAICT) it
> makes tracing more confusing but doesn't affect functionality.
> xfs_healthmon just passes in "xfs_healthmon" and I can run healers on
> multiple filesystems just fine.
> 
> anon inodes are ... uh ... magic.

Ok, that certainly would simply things a lot, and I'd be ok with it.

My ideas didn't really work out.  The last idea I had was to be able
to specify a prefix in a new method in struct xchk_meta_ops, but
this starts to feel like severe overengineering.


