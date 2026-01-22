Return-Path: <linux-xfs+bounces-30108-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHZ1HGrEcWn0LwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30108-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jan 2026 07:32:10 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A65062430
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jan 2026 07:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C74504C4CFA
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jan 2026 06:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77226285CBA;
	Thu, 22 Jan 2026 06:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sCtUWvUp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA76B30B52C
	for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 06:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769063492; cv=none; b=Nubjnh5FxANQH++6XkLH62U/IHovyfw/koPwNIun+Rth0MrdgEdGIfnTY6JxfNe7/1fsm8Fjnz/ZqX054qWD2ukCzjPG1U6mgBjsnKGtTA1sHN9BALfziaJdbm8aOR1CkW3v+v+QlXaLlrCo/7xDLyu2sMJyRQMb4aH0rIXpkxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769063492; c=relaxed/simple;
	bh=pN9s4wpD7iMx301PC/hBDDhaC2OUkktcSd0yHBAIZHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbi63qi04p3OOe4i6J+RPRCc6qCbKb81fVxA+Mr/uarTde4PX58iUWOJKwcxBJ0iSc0bQBd0T4sK5YICbVVw5dcRKZjDmWNfwjsF9n304RkH/Xp5eihOP9/gEWva80ak0qAgItSfGdvRranm6OtOn7EdVxiIJU84ch6kLNp58Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sCtUWvUp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eKQlYeldjvQz5MafqtyND8AgndiBZfBlUfWpNFGkUX0=; b=sCtUWvUpJxp+LbflvPhkadr0gB
	s21nJHe1+85WzRvASI2dP4GnU0n6gWHKHq3OP0dZj5P7XuN1D7QZuUwbF9Ej6rfZ4SHwI2YUT+lqC
	P3TIIyagC2YrbnAfPF5tpWTcFjjOsrjf6gF+xljzCOSyIo4pfLcDfCWPz21yj063aP87Bz3ArdNOm
	I6B9uZ13CqkKo60HRHSpPTA2oCB84Iqb0f/D4ATqpSBQRCQ/56q2VMwswW9qtfEIOX+yM/dcs0duV
	mvHVpFRm+UXtKnFWqWX4KTho/GmDeG4vWaVe93CuKiRc/MRct82OR+Ue4LTyaSnLSTGw1SG0HQ+2p
	2hqrZ8LQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vioE5-00000006V9v-03zK;
	Thu, 22 Jan 2026 06:31:29 +0000
Date: Wed, 21 Jan 2026 22:31:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: speed up parent pointer operations when possible
Message-ID: <aXHEQN3g31QPZ5mX@infradead.org>
References: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
 <176897695972.202851.10720887475428645960.stgit@frogsfrogsfrogs>
 <aXDvLIufYilqY-Ab@infradead.org>
 <20260121180646.GG5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121180646.GG5945@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30108-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[infradead.org,none];
	RCPT_COUNT_THREE(0.00)[4];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 1A65062430
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 10:06:46AM -0800, Darrick J. Wong wrote:
> > This is really a could and not a can, it might still not be possible
> > and we bail out.  Maybe reflect that in at least the comment, if not
> > also the name?
> 
> How about:
> 
> /*
>  * Decide if it is theoretically possible to try to bypass the attr
>  * intent mechanism for better performance.  Other constraints (e.g.
>  * available space in the existing structure) are not considered
>  * here.
>  */
> static inline bool
> xfs_attr_can_shortcut(

Sounds good.


