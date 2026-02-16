Return-Path: <linux-xfs+bounces-30832-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uEkdMQ5Jk2mi3AEAu9opvQ
	(envelope-from <linux-xfs+bounces-30832-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Feb 2026 17:42:54 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 258CB1464C8
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Feb 2026 17:42:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 635BC3009F97
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Feb 2026 16:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0300C2DB7BA;
	Mon, 16 Feb 2026 16:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIgElr9t"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D528E27F00A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260148; cv=none; b=u1k+qS24UaFRruOox2Yqjuhg2fcaBTdwYs4+snBX5pyRcExBQiizNMkwbDJZVSVb9u3MpD+IAxJ4ukERKRPWDW+MtxcX2lVQf0TRBIJc2/tBq4flI7k9px5zGk5zv/9NslP0eX6uZ2cnszoiZ4IpH8E6Z8g0pz4t7ddjGOJkgaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260148; c=relaxed/simple;
	bh=6bl3xnd6wAmll73sj0y6ZtnDk8gUXJprf08gAxZb22k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HYLWr4K6lc45tAkfST8xK9mpN/81tQwJcn1ZgBtSXnvYi41G8L3KgOu5oXCLBm/dfqjieYL4ZihuzR7p8wA5O4nQgbH6hKLXovCYpvSQxiHibnZsZyUZzcfvs7UIcPEmm0u3qdlLJxD2S4dHu7oTl/NyWJQsyahRTuHjCam44Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIgElr9t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA6AC19424;
	Mon, 16 Feb 2026 16:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771260148;
	bh=6bl3xnd6wAmll73sj0y6ZtnDk8gUXJprf08gAxZb22k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=JIgElr9t+0V1YTdHk+C6hcmJn7AKk7luXJXsfbPrYIjFOAkRb0ExxiBCBB27cO1DF
	 A9i9nMuq3pEURI3CWERqY/1bYswtwesuFTRhyXhFR0kdNlHhIlk1qk0ju41/OHPuRh
	 YedNsANlTaXKVDgzsOcHVl+TI5s0Le/sNwYxt69+f10QRHGWiPO15dLuoNXIkkox7y
	 K0jH/NXUnR5Ve3EW+BOE8V22i2a7I7ELH+i9HTh7nRGioC2AZC0qOva2Yw4CBhkZPw
	 cPjy06PMEjHvs9Jt9xXMkcLaSMfN4XQvxXFK76gIFIndaG1VxfTid0lykvvFjP51UO
	 VRO990AJCbxgw==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, hch@infradead.org, nirjhar@linux.ibm.com
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com, 
 nirjhar.roy.lists@gmail.com
In-Reply-To: <cover.1770817711.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770817711.git.nirjhar.roy.lists@gmail.com>
Subject: Re: [PATCH v2 0/2] Misc refactorings in XFS
Message-Id: <177126014661.263147.1931052626585278722.b4-ty@kernel.org>
Date: Mon, 16 Feb 2026 17:42:26 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,linux.ibm.com];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-30832-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 258CB1464C8
X-Rspamd-Action: no action

On Wed, 11 Feb 2026 19:25:12 +0530, nirjhar@linux.ibm.com wrote:
> This patchset contains 2 refactorings. Details are in the patches.
> Please note that Darrick's RB in patch 1 was given in [1]. There is a
> thread in lore where this series was partially sent[2] - please ignore
> that.
> 
> [v1] -> v2
> 1. Added RB from Christoph.
> 2. Fixed some styling/formatting issues in patch 1 and commit message of
>    patch 2.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: Refactoring the nagcount and delta calculation
      commit: c656834e964d0ec4e6599baa448510330c62e01e
[2/2] xfs: Replace &rtg->rtg_group with rtg_group()
      commit: f0d0d93e22e52a56121a3d7875ea7b577a217d62

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


