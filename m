Return-Path: <linux-xfs+bounces-30026-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOjpFZp6cGktYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30026-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 08:04:58 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F783528EA
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 08:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A2412466E1D
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945143D301F;
	Wed, 21 Jan 2026 07:04:27 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC39635E53A;
	Wed, 21 Jan 2026 07:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979067; cv=none; b=hUoX62dMV1AJr8ByJrYmga1HrugIhOHvZWFaiVRwX9mPDixHH27u5LPdMWZEjh8G9t1NRf0IKLFcNeYA7Es3hYcBCDg7Guwn307pULt9psCR/rqqaujVFzD179pPEwiRcjwKNfBuYf302FHwDZAm2e0Zj/JmNP2QrLjYSed1O04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979067; c=relaxed/simple;
	bh=172qC2M2WdtS/QOMqodnJea9J2jwpKMDdyVFuBgURa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRsDWP+DbEUmRXePYWz8gqLra8ecU7bDQfsGKCtR9sOzfZMizHW/ZskTUCK+jp0PSBchKl9dxOD4/xHuwQeAkYDtdChyyXEbvGmXdRKhAEuWdShuL1vuDeO43EKNlBzmd99x7rO1IGnJYdgzKL8sauRepVNv1ac0T2LTIJqH4Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B2CB0227AAC; Wed, 21 Jan 2026 08:04:21 +0100 (CET)
Date: Wed, 21 Jan 2026 08:04:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, r772577952@gmail.com, stable@vger.kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix UAF in xchk_btree_check_block_owner
Message-ID: <20260121070420.GC11640@lst.de>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs> <176897723630.207608.15659392786155037540.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897723630.207608.15659392786155037540.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : No valid SPF, No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	R_DKIM_NA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-xfs];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org,lst.de];
	TAGGED_FROM(0.00)[bounces-30026-lists,linux-xfs=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,lst.de:email,lst.de:mid]
X-Rspamd-Queue-Id: 2F783528EA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 10:41:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We cannot dereference bs->cur when trying to determine if bs->cur
> aliases bs->sc->sa.{bno,rmap}_cur after the latter has been freed.
> Fix this by sampling before type before any freeing could happen.
> The correct temporal ordering was broken when we removed xfs_btnum_t.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


