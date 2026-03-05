Return-Path: <linux-xfs+bounces-31951-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QCmqFMKnqWlSBwEAu9opvQ
	(envelope-from <linux-xfs+bounces-31951-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 16:56:50 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9C9214F30
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 16:56:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B46B73014751
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2026 15:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5A83CA48D;
	Thu,  5 Mar 2026 15:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTf0ztwC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875AB366803
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 15:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772726206; cv=none; b=lNAXKUlPTyP1BXjlxP3HFbiQp6SQFYyE0XJDTsBJQtlD5ie+1BvAFSJSLn5DPC8EdPt7cMqhhXiOC22wc+dDeE9Hyh3xyTeOesIRx9RctY6yzltEBGw8dY5iLf5U0jkdAAE7v6XjgXl9jdB/n4Ljduur5IAtAaRjPHpecDEINFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772726206; c=relaxed/simple;
	bh=VvMMsTIpNr7swlgIpVlzgwXVqLQwZD0H4GHKHGgBdY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bm9bGtCUMl92+y0raUGh5bGh4MhmVMz4ODdyB2N0YleZJWgpRmJsS5Zmb5l2qlJoAnVkMNWsUe09hlNUhTsH5nnKxu1Tt11xOIXyeVSp2N/5iV2vacxq6PQXePMyt9fCTfRyDi0YSHi54gdaNHQxrm6LX0zi9n3Nx4zgKOdqEZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qTf0ztwC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07834C19423;
	Thu,  5 Mar 2026 15:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772726206;
	bh=VvMMsTIpNr7swlgIpVlzgwXVqLQwZD0H4GHKHGgBdY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qTf0ztwCMWGv0b7lC7Xi0oc54sciRphR0LjXe62DHZAIkbt5SPYHcM1g30C0uXahg
	 KkRpA1NHNR8MK/vlD/WClG1tc68P6GDTRZpROmjr4SRwfH/dZPyKzzlqNyjWlBiC4w
	 sCu1WiUh9PBNxBeJvjoIeia0FrlS00dFY48jkqc6xYPUx+GwNqGH6eiUp3bo8yAafb
	 2cCNdn6uVaND+/tpPP7EvAHFLzBBl8I61v2XIThPNHZULORHz+YC7RbdmXuM1Qvseg
	 JRpcpOTIY6jczc6jcci1B6DFNxVUSJ879VZ/3O3kLbhhskCbhSGmk7DH0roT+LC390
	 dCdi3N0fk476w==
Date: Thu, 5 Mar 2026 07:56:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libxfs: fix data corruption bug in libxfs_file_write
Message-ID: <20260305155645.GE57948@frogsfrogsfrogs>
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
 <177268457046.1999857.4333152615677714192.stgit@frogsfrogsfrogs>
 <95b8493c-4e56-03b2-0d9f-7a8ce1675a07@applied-asynchrony.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95b8493c-4e56-03b2-0d9f-7a8ce1675a07@applied-asynchrony.com>
X-Rspamd-Queue-Id: BD9C9214F30
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31951-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026 at 08:46:35AM +0100, Holger Hoffstätte wrote:
> On 2026-03-05 05:24, Darrick J. Wong wrote:
> > Cc: <linux-xfs@vger.kernel.org> # v6.13.0
>        ^^^^^^^^^
> 
> I guess meant stable@ here and in the other patches?

No, these are userspace bugfixes and stable@ is only for kernel code.

Nowadays I like to annotate bugfixes for the benefit of anyone
backporting bugfixes to stable QA setups / xfsprogs packages (me), but
the awkward thing is that xfsprogs doesn't have a separate stable
backports list.  Unfortunately, the autobackporting tools all settled on
greg/sasha's shortsighted choice of tag format, so stuffing in an email
address for no good reason is what we're stuck with until someone else
screws up the courage to coordinate a flag day.

e.g.

Fixes: xfsprogs v6.13.0 73fb78e5ee8940 ("mkfs: support copying in large or sparse files")
Fixes: linux v5.8 b707fffda6a3e1 ("xfs: abort consistently on dquot flush failure")

or any such variant would have been clearer about where you're supposed
to apply it, at least in terms of repo and tag.

--D

