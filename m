Return-Path: <linux-xfs+bounces-30525-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +AL+OIRFe2l+DAIAu9opvQ
	(envelope-from <linux-xfs+bounces-30525-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 12:33:24 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 52BEFAFA9F
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 12:33:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B5110301BC18
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 11:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75672387377;
	Thu, 29 Jan 2026 11:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBZO6PMX"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CFC3859C1;
	Thu, 29 Jan 2026 11:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686360; cv=none; b=g8kFAyA5dtie0gTL50A2auPf7umaBeT/izNh4PbwNRppeAzJA85gDgskxlnXXcE1LbageOaHMNOa2TScPe2/B/BhSvkct3fF+eWSxLiZR68LjMY06tz9b9uU6Yyku8fsx6BQlyi2oWnOq4z2a9cy4tmeaatQQ4NGh4M4SCcKQXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686360; c=relaxed/simple;
	bh=qQ+wogcQlgpu0wiZDQWsjcht7f5E6zf0yY75TNg9GoY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KzPfuzaWUgS1SfHRPSLLwBTLiLw28nzRYCx6blsjFCoFqi3ksODdft5kolO231o0Oa3mEhSIe8z61wPoSFBDF+rmm1Eiw8d+Q3Dm5taR8NjgEgBnyfQnujAbiLnPHPcV4p9MI39zZmVBOcS+XPyOkR7f1msHYs5VS/l7fZ+WCfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBZO6PMX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F10C4CEF7;
	Thu, 29 Jan 2026 11:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769686359;
	bh=qQ+wogcQlgpu0wiZDQWsjcht7f5E6zf0yY75TNg9GoY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=QBZO6PMX9T2oKys+Rtql8OC7MxoRbkJfT1hl6r+Z2ForPKcyIKwwHUij+M96ftO7n
	 bBONicqUckgNToDK51DWql9BrLiTh4dsABfe7Ir0xG9ozpQgTd6b4l97qmFGXAEB/u
	 3aWmId+aKP4tQVS9D+OD7cFacGzelZBQ2sG4ekZrd0u28h2449vwT2t66mCaT2T3PP
	 pLUHCOdzUtDDRv0QnBgzhnqql2KfoEhYqXO/EFJ22Z+QKS+LhrwHgrLxy3UnV/RSah
	 pCWwpYvM/NNhOuwrDW28GwX3esLi4/1gVjpJZL2OQimHMYYjG3ICqTDcyElaRe2exS
	 sfnnZ+CdbjHkw==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <176919034772.1844314.23527352508595796012.stg-ugh@frogsfrogsfrogs>
References: <176919034772.1844314.23527352508595796012.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL 1/4] xfs: autonomous self healing of filesystems
Message-Id: <176968635857.19384.17214008764443796096.b4-ty@kernel.org>
Date: Thu, 29 Jan 2026 12:32:38 +0100
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
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30525-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 52BEFAFA9F
X-Rspamd-Action: no action


On Sun, 25 Jan 2026 23:21:40 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs for 7.0-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> Note that this branch is NOT based off the existing xfs-7.0-merge branch;
> instead it's based off of brauner's vfs fserror branch.  You could merge it
> into xfs-7.0-merge, but you could also push it straight to xfs/xfs-linux.git
> and make for-next the merge of xfs-7.0-merge and health-monitoring-7.0 and send
> two PRs to Linus.
> 
> [...]

Merged, thanks!

merge commit: 04a65666a69508fa0022c7343026c5a3d41d166d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


