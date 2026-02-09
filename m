Return-Path: <linux-xfs+bounces-30701-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SM8aAJJ+iWlO+AQAu9opvQ
	(envelope-from <linux-xfs+bounces-30701-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Feb 2026 07:28:34 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF6F10C07F
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Feb 2026 07:28:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2898A3006B7A
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Feb 2026 06:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4CF2EB5AF;
	Mon,  9 Feb 2026 06:28:31 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB162D7D2E
	for <linux-xfs@vger.kernel.org>; Mon,  9 Feb 2026 06:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770618511; cv=none; b=OUKxu12QxIlKGV5WdSxn5aoTpRFW2EVz9wnv9TD/C+0iLJ8SQ7YRjiTYf48yrJodyJ+KJiSMjUSGvmwmVibQdNkM50Bqy9CaGCMK3CpBRj0Ia92Vwm28cJReSs/DUo56+qKjFgLb1YTNlvfhAPdxUAnL/4ev/6bUVObgMUm92QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770618511; c=relaxed/simple;
	bh=i1aKt3UdEGPrESw9H7osXNbDkeCmUgLgFljo7IT3X6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItPq39QwT8DaEWCG8dd81mReO7v0Fuqot1flpFuaS9DH2Ppmv/haZHwd748PvWnTkVeCgfpfiAR1e8YuazpfkOt6iYbz4r2OBgNoRVHiRIsrB0kQNC8PzveD/CbjU1oDncx/hqZ9EvQWBF4Ki09J3kjsi7eS1ob4+O+ul2R6Te8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C6B5668B05; Mon,  9 Feb 2026 07:28:21 +0100 (CET)
Date: Mon, 9 Feb 2026 07:28:21 +0100
From: hch <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by
 lsblk
Message-ID: <20260209062821.GA9021@lst.de>
References: <aYWobEmDn0jSPzqo@shinmob> <20260206173805.GY7712@frogsfrogsfrogs> <aYlHZ4bBQI3Vpb3N@shinmob> <20260209060716.GL1535390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209060716.GL1535390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30701-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.890];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lst.de:mid]
X-Rspamd-Queue-Id: 9BF6F10C07F
X-Rspamd-Action: no action

On Sun, Feb 08, 2026 at 10:07:16PM -0800, Darrick J. Wong wrote:
> Waitaminute, how can you even format xfs on nullblk to run fstests?
> Isn't that the bdev that silently discards everything written to it, and
> returns zero on reads??

nullblk can be used with or without a backing store.  In the former
case it will not always return zeroes on reads obviously.


