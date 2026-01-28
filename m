Return-Path: <linux-xfs+bounces-30434-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YK2bFR/heWm50gEAu9opvQ
	(envelope-from <linux-xfs+bounces-30434-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 11:12:47 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D99B69F49E
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 11:12:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D6B9301F9E2
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 10:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96F52D7DE2;
	Wed, 28 Jan 2026 10:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOUz/fdf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D7C2C028F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 10:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769594976; cv=none; b=LtjJBW5D14BGWoyHdTTxCAMvAvYo5JToeFPswqZwsZkcZajTTm+XdFju581RXt+wOO84fQecd78zPoYBgpxMWrsyvBto20/7GH08/rp0au3qcs8RvDqLCiAw2Phywae3CbhTcl3Uox9OBWMjzNTQ0XmEyKEjZPiVKp515hQcY70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769594976; c=relaxed/simple;
	bh=1DJm8hs9H0jKhmqZ6X/Yr3oGRM6JlWHyZ7wl10JgoS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mchw1kF8qQM96PIRpVIZ9UJioMIh2AYnZlDDnk0e0zEgS54M5i5JpK4tu/c0UIPf5YXO0vlMh3yfPBHkOp/Kc7Wgr364AWo5MdSi2yzUvgJh5k6SzdsXK4ncmSruxu/6kvVaRvlDB5kbIzZs11xKyskLi7SmlNx22mZUv8b0QMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOUz/fdf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9899AC19421;
	Wed, 28 Jan 2026 10:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769594976;
	bh=1DJm8hs9H0jKhmqZ6X/Yr3oGRM6JlWHyZ7wl10JgoS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SOUz/fdfrGoF6wC+b1UGsqg7SKnWc59wTxcHnEhLXmlGaqPFH3D1IMJJmdZaImHTG
	 jMEaX7Nydq0WlhYMxJg4XgaKgCty6qxudgn8b1YyCsxEMmi+8pCx1T6wuoeQ63Vj0O
	 QC5qWRcmPT5J+eP/si5I6GgeDpWKf4XvSULSSqKNQ8xetgPoMP7XOjna4XAf+mJw9x
	 iK4MNLEwcJm12DoL5oeaZakG1Wqz10nNusJsJ4Q/JSyxPiBKVr/II0Gzz170giP0mW
	 MQ8ThkqybQp09iWZVo40ACQ5IIFlZVrbm7OEZJ7Y27nagSro0bw/5HU0yTUb0oCwQH
	 e3T200F9CPw4w==
Date: Wed, 28 Jan 2026 11:09:31 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Chris Mason <clm@meta.com>, Keith Busch <kbusch@kernel.org>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: use a seprate member to track space availabe in
 the GC scatch buffer
Message-ID: <aXnemInJ6bkOS5wL@nidhogg.toxiclabs.cc>
References: <20260127151026.299341-1-hch@lst.de>
 <20260127151026.299341-2-hch@lst.de>
 <20260128055622.GA1925@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128055622.GA1925@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30434-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nidhogg.toxiclabs.cc:mid]
X-Rspamd-Queue-Id: D99B69F49E
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 06:56:22AM +0100, Christoph Hellwig wrote:
> ... and I clearly can't spell "separate".  Carlos, if this goes
> ahead, can you fix it up?  Otherwise I'll do it for the next version.

No problem.

