Return-Path: <linux-xfs+bounces-30075-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EGj9FpIBcWmgbAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30075-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 17:40:50 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B915A095
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 17:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 916E67A9D59
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 15:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAB03644DB;
	Wed, 21 Jan 2026 15:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qWEkVek8"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAD12DCC03
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769008979; cv=none; b=t+evWsuXcAW+5FCfFd7ZGqRL812Y7WdoaCeIADBN/AbktoIZ67y/WvLkiajbHe+v4atdvDvSJsPQ6vdRayhlM4fzCTS1QJMl9FswwM7+15O5gQW6hfJW75d2FirGXF3uUQBrTGFtmU5ugGju7JaB+CXecYo2PAo/vSq7Qw9Jfow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769008979; c=relaxed/simple;
	bh=hW90o8FNcFcqwdcecEK+nSyjrPqau1Za8pcT8bmkS/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlP76ZyR6/pNzg4J6F88mnZD5JRuHMMKEzO+tJuZbm5Bjk3VyQ6Pa4Uhp082ly8rK7xkA5MeVkA4o3hR6LYGiBKX471Y4OLC0M4PcSDpKmESMGarRaUgOPix1QNoox1QhNkyXcAEXnW+ZNoHHgLICgPx1mtBnAyJPsrWzOFMdT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qWEkVek8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=joPIyEruzQYpJtMWTO+hG83VdwOmLdl78ZeWqqzL/Gc=; b=qWEkVek80n+d7A8kgPrLhNyVmU
	hKALDErQHTMQ3TEG5sTB7zPudIp3zUWkIBNQWkeDWMyjiNH9i4SIrTznOIWViM3WCX0tnTzSpnEh9
	27933SO9xvmo2knoFMs+CTlXFckoC/N9sq60yQbLpHxcXkMu91FxxiRDz0M/zzjPdCRU3xSNQJzwl
	3Amw3SI4L1jVLl22FmI4uoM1vk/vpcea7YcczPTMi4zLcE+6cfbjhufCoXIpzQPvBTtgh9hziiAXA
	upfafi41bh0UV6SvkAzsblFQ0V3LZNdVAQ2LVXgQxydKsf6p7HZJsSkQI+tfAeUBidKVRup9bxeX8
	y2WRv37Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1via2q-00000005iHg-33Gi;
	Wed, 21 Jan 2026 15:22:56 +0000
Date: Wed, 21 Jan 2026 07:22:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: add a method to replace shortform attrs
Message-ID: <aXDvUGGUGFzZF_Ts@infradead.org>
References: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
 <176897695994.202851.7241999799670618810.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695994.202851.7241999799670618810.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30075-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[infradead.org,none];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[linux-xfs];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,lst.de:email,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 13B915A095
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 10:40:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we're trying to replace an xattr in a shortform attr structure and
> the old entry fits the new entry, we can just memcpy and exit without
> having to delete, compact, and re-add the entry (or worse use the attr
> intent machinery).  For parent pointers this only advantages renaming
> where the filename length stays the same (e.g. mv autoexec.bat
> scandisk.exe) but for regular xattrs it might be useful for updating
> security labels and the like.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


