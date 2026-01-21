Return-Path: <linux-xfs+bounces-29971-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oD6lOlZecGkVXwAAu9opvQ
	(envelope-from <linux-xfs+bounces-29971-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:04:22 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A40514BD
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:04:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 645C74E0AE8
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 05:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F85E33C528;
	Wed, 21 Jan 2026 05:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eU/+WL4h"
X-Original-To: linux-xfs@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B882532F750;
	Wed, 21 Jan 2026 05:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768971857; cv=none; b=c9XdpC6uO7xj5ymNdO9Uy/wzvgyhBRDDl3wBQD+1jh7xJD8p3mXJcEX3Fe2nzeArGl31kzh4yeGeUEhvEEKoNeXUDasSqsoV7PB2g4L8HoszxEbaZHidOUlcKYxkKBTMk2HQUZZPHYWVWSMExFsc10c9VvypcWokRBZ0ASyH6CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768971857; c=relaxed/simple;
	bh=VA5Noq28tiqekF1L61kBf56ok6a+FePbh6yVWHB54xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WR9sakVcYdFXd9JNwAjgKkn9KyCBtJ1RyD5PQTnW7fqPrneLV5rhneCN1+4231IF7ZKqfhCwt49Rv7cWeOOKzPP4nEOfGH04sAXpHl01m6TnUqEGRJDRD+X7kdQweJhIRabgfGfBOChEezAoBdhv/zJ1ZE3Qf+kABmsYuN9LAJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eU/+WL4h; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VA5Noq28tiqekF1L61kBf56ok6a+FePbh6yVWHB54xk=; b=eU/+WL4hdJU9jC9HxsbjUIRtaG
	BlzmwGdd/wz2JLhHnAzCIx5CZMbPjaqddh/3yR8BhgYXEy7i72+KNA2B8cnDUXvgtw8/s4R1/dxV5
	I+WfxpfBBZfCve/h3hzmuP+nqTjEytCNeSgCPGe1firJY/VBKwNnwqLWUDhsKyPJXftYis50SDWOp
	u/fbvgZlREXFTj4NmzsGkkcKxVQmyM1tyl2P5LSZAdk3ltvPFUzFnaqHVkupsX1IDApM+8PmBiwIw
	iJ2Xm7+0PeSR8aMnK07KGfFUS3EI+daW4inOpr/p8PnYnoufEYt4Nb39OiXyU3hgXdHPfgMN827PD
	FaMBOb7A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viQO1-0000000FuEn-2wQP;
	Wed, 21 Jan 2026 05:04:09 +0000
Date: Wed, 21 Jan 2026 05:04:09 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jiaming Zhang <r772577952@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, brauner@kernel.org,
	linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: [Linux Kernel Bug] general protection fault in xfarray_destroy
Message-ID: <aXBeSQJdqtfvSC6u@casper.infradead.org>
References: <CANypQFaxY=1aGi=F69+XRz8HakXoP3rarym55yPPvhpZFiQOeQ@mail.gmail.com>
 <20260120184647.GW15551@frogsfrogsfrogs>
 <CANypQFYSjPCi=VFwUPBiO+JUjLB_=1pq2aTqixGrMoNDgkEeXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANypQFYSjPCi=VFwUPBiO+JUjLB_=1pq2aTqixGrMoNDgkEeXg@mail.gmail.com>
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[infradead.org,none];
	TAGGED_FROM(0.00)[bounces-29971-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[casper.infradead.org:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,infradead.org:dkim]
X-Rspamd-Queue-Id: 71A40514BD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 12:58:58PM +0800, Jiaming Zhang wrote:
> Additionally, all reported issues were discovered by running syzkaller
> with our new generated syscall specs :) syzbot has not found these
> issues yet because the upstream instance currently lacks these specs.

Work with syzkaller upstream to get your changes into syzkaller.
It's far more productive, both for you and everybody else involved.
Don't be syzbot, you're not nearly as good at being syzbot as syzbot is.

