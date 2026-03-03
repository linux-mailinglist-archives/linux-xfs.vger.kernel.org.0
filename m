Return-Path: <linux-xfs+bounces-31821-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qP6OH+4Mp2k0cwAAu9opvQ
	(envelope-from <linux-xfs+bounces-31821-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:31:42 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E5B91F3D65
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E863F30C31F9
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 16:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEDB4D8DB3;
	Tue,  3 Mar 2026 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pI5BmLkl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4114D8DA7
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772555081; cv=none; b=H+MwwxlcbXxC3JbPOZwkI0HVjOgkoKpMALiBi1W5G/oHrGLP2lSdzA61EzRfe6h/ac6N0bamXyryvE7sjb3/774JggS+0BVKFIY5LizPIzfR0G+PJd/KbYyCMbyyu/XaGLLY4to29GvVfVeq6QLNwckOAYlD7BgRMDG2XVIVj5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772555081; c=relaxed/simple;
	bh=wzgsrGjmasuXITkCzZ13Fhxhz4cL5DD2J9g2wgjwVCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSOe8z47JFqXYyEhwM40RruU8swp/UVYZkIhMtXGMXKeAUCSLxwvs3IKycdjQrCo5+qXEOtEFbAZxKkl73hi3pD4vTFwI7Zd6tujuzk/QWWjFq8BXg96iGSqXn5NFcix9cNugWZSmxIeK9Emuc87QSGn5ryDe8klyFC602j/CyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pI5BmLkl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5B6C116C6;
	Tue,  3 Mar 2026 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772555081;
	bh=wzgsrGjmasuXITkCzZ13Fhxhz4cL5DD2J9g2wgjwVCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pI5BmLkl8D5PaMqrkGKCeQ80AeKkNB0HsDuIukJnDBLm8dxhHTn6HlscFs90KMvir
	 uf/rYWq9qMobudj4qXfKGOlRBAKKPmtlZalL39S+pkB+QlYGcnjqEnQEwb1yd6ZJ4I
	 X3UsU3AAghUgojCMtkgKlupf0M2ZhGU7YnYD/qRTwViDnjPS7SmDymhQ4gqdnJ/x71
	 5G94EFPrIYOxkoXCzgR56lQDIRkjtAB79apxHCXt6IX1iQfDa7YmcSxhLoK60LQONv
	 plOqeXT4kPCVO1qez5rdEMO7hQ7FGoHxwW4IpJHlXLQQ/MbCWWS7/Sd5vO2gPaRAuD
	 gqOHcrq/MEj/w==
Date: Tue, 3 Mar 2026 08:24:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/36] xfs: remove metafile inodes from the active inode
 stat
Message-ID: <20260303162440.GG57948@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249638385.457970.8057539261074430844.stgit@frogsfrogsfrogs>
 <aab03-37QcwSKu0u@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab03-37QcwSKu0u@infradead.org>
X-Rspamd-Queue-Id: 0E5B91F3D65
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31821-lists,linux-xfs=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 06:49:03AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 04:20:47PM -0800, Darrick J. Wong wrote:
> > -#define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
> > +#define XFS_STATS_DEC(mp, count)	do { (mp) = (mp); } while (0)
> 
> Looks like XFS_STATS_DEC has been around for a while like this.  Maybe
> split that fix out?

Will do, though AFAICT all the previous "callsites" were all #ifdef'd
out of existence anyway.

--D

