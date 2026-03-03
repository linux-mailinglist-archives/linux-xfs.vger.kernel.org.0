Return-Path: <linux-xfs+bounces-31834-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QMgiB3Aap2m+dgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31834-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 18:29:20 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 987531F4A01
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 18:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55BC3300D47D
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 17:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D16723B8D74;
	Tue,  3 Mar 2026 17:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NE6NVlHW"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDCE3B7B6C
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 17:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772558957; cv=none; b=WVZqfX6+SaNKHje6Z+4Rvaha7XEAihKDstJZz1H0fqQkFOZb/XXm+OvmRVKQcAC0kIvpyk60dFMwyg4mVHIhmq6DbvSvliiUPi4MuMIkQG5kMjKyux2Gr89bxmUGunBes8Ed3iMB7xKJpMrCo2CHPhkhC0JCRpuv9rBRo0vVV4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772558957; c=relaxed/simple;
	bh=bXYS/blu8bgqcckDXrQnS2BiJIsvQYbaXPnnZI+xTqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/GxpItAkQc/6cqhKIdV/kTNzCOwrp5GwkK2Imap9Tekl6XYzmhgj7ob8YQ3TN6amoSSF1tN7TefzcVTGU6R1U4s2JSsI3DkQ7kqet7KRzYgDSkNG856ocO365R1lzDrFbpsQt4llc1SLq6ppdboK9MNU2WSj44TzaFOmFBiXFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NE6NVlHW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB09C116C6;
	Tue,  3 Mar 2026 17:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772558957;
	bh=bXYS/blu8bgqcckDXrQnS2BiJIsvQYbaXPnnZI+xTqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NE6NVlHWdMMD53K9tGS5gUdRH6R0/6DBEYb8N7U0jYlGexMCnnYEJBzUylx0fLIID
	 OjxGMu40YDr195DBOfWacU9ZrcLYLlkZgfVxzIAGX/ZKJF6h6a6+nleBr2LAAf56JW
	 5Oqy3LQS/TwilVP+sJTO0TQQXC655acfS0psJtdyt0HSN4ALa/GpoB+9uttTqrvRNv
	 mICre+FxHaGuHh4ZwQPM1M8J3al/Q5nLIVQPnFBH57bIZutDrvPrtR24J2LIAR265e
	 b/8Du7KEO06PNXcOzZ/KZvoK66CteYLWVoDmcVN53aY8IBjiybbljNaqZ6mDbsrmc1
	 BD+4v8Xcs+n1w==
Date: Tue, 3 Mar 2026 09:29:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <20260303172916.GR57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
 <aacE3gW9j6pKrspy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacE3gW9j6pKrspy@infradead.org>
X-Rspamd-Queue-Id: 987531F4A01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31834-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 07:57:18AM -0800, Christoph Hellwig wrote:
> 
> The idea of this is good, but is xfs_io really the right place for
> it?  I'd expect scrub or healer to just output this somewhow.

I suppose they could, but I didn't want to clutter up the argv parsing
any more than I had to; and xfs_healer gets installed to /usr/libexec
which would make fstests' use of them to find the service name more
complex.

(That was a long way of saying "can't we just keep using xfs_io as a
dumping ground for QA-related xfs stuff?" ;))

--D

