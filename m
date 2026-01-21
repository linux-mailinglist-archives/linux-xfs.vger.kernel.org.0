Return-Path: <linux-xfs+bounces-30023-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJngCG15cGktYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30023-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:59:57 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB72527E4
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E0FC462178
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8D21F0E25;
	Wed, 21 Jan 2026 06:57:57 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EE536D516
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768978676; cv=none; b=qJ8yl85xTP81OPo30q/wS6EO7T7YVfJfXmNfxRJWxFybnRWCaQ0nRGS67/XsgzPryiuKRAwqOCWUAOsYdc9KeY0UJOKuRsP5kYJlscbg1JzYk1yclU210k3zKiwfWm9LOEbRWY+mMWQ27vkAOP3A2k8fRbmVowAAPkN+4RfzlYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768978676; c=relaxed/simple;
	bh=12m+pkJ9t4sASj/ZTlwHyhyQMxKHcgd8pnpUYZNNSMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jhr3K/L7hTpayZG8mR+e4UBTxKyOdfpzGpwjjSaOijqpFN8Rq2oDwT3PlFZDKIPkR+dTwAa4kQeoJXJ9Nf04MU/MF8tXH9cuZcM6fBIEoatSZ6CVqFjLLlhky3KRUtkzzM7LY/h2/DhLmEuiywzIVJCNEmvFaNK2cYdzFfs5sCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ECEB9227AAA; Wed, 21 Jan 2026 07:57:47 +0100 (CET)
Date: Wed, 21 Jan 2026 07:57:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: promote metadata directories and large block
 support
Message-ID: <20260121065747.GB11349@lst.de>
References: <20260121064540.GA5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121064540.GA5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : No valid SPF, No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-xfs];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-30023-lists,linux-xfs=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,lst.de:email,lst.de:mid]
X-Rspamd-Queue-Id: BCB72527E4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 10:45:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Large block support was merged upstream in 6.12 (Dec 2024) and metadata
> directories was merged in 6.13 (Jan 2025).  We've not received any
> serious complaints about the ondisk formats of these two features in the
> past year, so let's remove the experimental warnings.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


