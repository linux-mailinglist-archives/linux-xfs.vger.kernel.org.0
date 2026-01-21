Return-Path: <linux-xfs+bounces-29972-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yMvhNMJjcGkVXwAAu9opvQ
	(envelope-from <linux-xfs+bounces-29972-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:27:30 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 745B851812
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1D5BB4ED6B5
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 05:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2B43D5247;
	Wed, 21 Jan 2026 05:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="DDKk7E82"
X-Original-To: linux-xfs@vger.kernel.org
Received: from forward502d.mail.yandex.net (forward502d.mail.yandex.net [178.154.239.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DB93D3007;
	Wed, 21 Jan 2026 05:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768973233; cv=none; b=jFw7OmsZadTIsXBC3pk42+HNaIQ8rYaQqiS4bvh6usFOn3AkkiS1PgQ1o0cSafmTZ3FZTnlqm2rZ7GtpkEb3F7Nl1XIygmX1/xgxuuPTIhWiJynsbZrVuqxjSuQIzoPvpx7g2Kz4MpdwHGI7jgRVZUft87T7j+UxX5EzC11ZV6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768973233; c=relaxed/simple;
	bh=944G5ACzShJqoYQQ/s5AwXliuJjwXfEjrxWX1yjfBjQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KgoEoyN+sfznxy+15+nOYa1+jeHhG+HGrP/rFtE51i6F+RbvghfTrccXanQiw/1N7gtkHei3su3cFAavfxF/4klYYl4k6rCdTebuThR6PaYosKXF3j76ZWnQr2ibtIzNvULzEIvlihsYw0tHmru3EPX81vbHwBjq8Lh11Af08Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=DDKk7E82; arc=none smtp.client-ip=178.154.239.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:9a4b:0:640:e388:0])
	by forward502d.mail.yandex.net (Yandex) with ESMTPS id 4B352C1898;
	Wed, 21 Jan 2026 08:21:44 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id gLT83a4GqqM0-QpxIAhL6;
	Wed, 21 Jan 2026 08:21:43 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1768972903; bh=944G5ACzShJqoYQQ/s5AwXliuJjwXfEjrxWX1yjfBjQ=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=DDKk7E82jCfAkC294AO1k0OoFd9POVqWp59V88lMSbTpDZXEQ67N15VGInIc+gB3o
	 ZgJfOhsguefdHNfZnLK4uUIqAiIT3uMCRwlsPVq9Ne9TXpbxI4eskzIxHbn3txnAtQ
	 uMIMVkvUu63OprsC/zcqPFejZAGiI+uK0GvoNrLg=
Authentication-Results: mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <db2897f9a625e7e9a6797fe32cc9364bde56d605.camel@yandex.ru>
Subject: Re: [PATCH v4 3/3] xfs: adjust handling of a few numerical mount
 options
From: Dmitry Antipov <dmantipov@yandex.ru>
To: "Darrick J. Wong" <djwong@kernel.org>, Andy Shevchenko
	 <andriy.shevchenko@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
 Carlos Maiolino
	 <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Date: Wed, 21 Jan 2026 08:21:42 +0300
In-Reply-To: <20260120225531.GZ15551@frogsfrogsfrogs>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
	 <20260120141229.356513-1-dmantipov@yandex.ru>
	 <20260120141229.356513-3-dmantipov@yandex.ru>
	 <aW-YP7wCEvRJzyfR@smile.fi.intel.com>
	 <dd2b5f76c1acfb0ebb22585a5282d94e1d8c979e.camel@yandex.ru>
	 <aW_4bxkLe4-g9teu@smile.fi.intel.com>
	 <20260120225531.GZ15551@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[yandex.ru:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[yandex.ru,none];
	DKIM_TRACE(0.00)[yandex.ru:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-29972-lists,linux-xfs=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[yandex.ru];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmantipov@yandex.ru,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 745B851812
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, 2026-01-20 at 14:55 -0800, Darrick J. Wong wrote:

> Yes.=C2=A0 Common code needs to have a rigorous self test suite, because =
I
> see no point in replacing inadequately tested bespoke parsing code with
> inadequately tested common parsing code.

Nothing to disagree but:

1) My experience clearly shows that it takes a few patch submission
iterations and a bunch of e-mails just to notice that the tests are
mandatory for lib/ stuff. If it is really a requirement, it is worth
to be mentioned somewhere under Documentation/process at least.

2) I've traced memparse() back to 2006 at least, and (if I didn't miss
something) there is no actual tests for it since them. And it's hard to
see a point in testing memvalue() prior to testing its actual workhorse.

Dmitry

