Return-Path: <linux-xfs+bounces-30522-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yKmsIh5Fe2l+DAIAu9opvQ
	(envelope-from <linux-xfs+bounces-30522-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 12:31:42 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D6DDAFA5D
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 12:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9BD06300559A
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 11:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C72629C321;
	Thu, 29 Jan 2026 11:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCX40yOA"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398D326CE39
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 11:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686299; cv=none; b=nfdj9+joQa2DiNStFzVzXhKL8sJVCVTsPNmECBOEc10rZOY3nE83C6N0TjTH3vKwkuVLksPbt2qJGHr1/ohCHfod825EI0IJvBvCtsIs9A1VZWGppmBbRATftHgcvH8Ev4JtqUzmONCASHkwqX1LHY4vrATApks3l0AFaGct4dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686299; c=relaxed/simple;
	bh=vGSR0u7Vrje1P5FAVmRGXBZgXvPRFrz7fhoMeyOU3lM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BMO4Jc7CSyYlS3z9mFriRf5hsUkG6LUi99NNb5mndXcxSxYQVzQ9vtofi0vMFyvJakAIIW0he5jayWNwng+g6rdhSHkqsmH1SurFUcItdWrhiSoz68vETJMRo2TmrxzSUaRVS4NrYfnLywxL/YjTy7KeQWQawUhEZhBKPNmXPDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCX40yOA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9B8C4CEF7;
	Thu, 29 Jan 2026 11:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769686298;
	bh=vGSR0u7Vrje1P5FAVmRGXBZgXvPRFrz7fhoMeyOU3lM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=mCX40yOAHPAjaEkjvuqmi8kdC62Xu5nV5uzvg4qDw+QHknfET2DXAQEJ9jkeGifdb
	 80v/IqZYIWyT/rhYCIaFWb1VchVlnnddBFWyp7ANapq0Oi3v2papEa0Ok11nmX9Ku0
	 Bpvgp2N/OUkKuP10iQnjahLkP144TydwchU0LQYoyzxSi1KE6NKy7MHhKXBHDGqE5G
	 Y9VbCBtimzQvnf51DIrYm7STAbFQ0a4qIO0EqYjJzsEaVHdGn/yemC3XHasyWnha+2
	 BkGoomqhuwrJdqXrDpPf3WGGo2YF1DKKhP8hJkIYoqK7s0LD1hmX4AyauZ2iiF8wJT
	 /ssRSQpbXCcwg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
In-Reply-To: <176939848221.2856414.2186658227930504931.stg-ugh@frogsfrogsfrogs>
References: <176939848221.2856414.2186658227930504931.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL 3/4] xfs: improve shortform attr performance
Message-Id: <176968629765.19252.1672136172736920409.b4-ty@kernel.org>
Date: Thu, 29 Jan 2026 12:31:37 +0100
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30522-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3D6DDAFA5D
X-Rspamd-Action: no action


On Sun, 25 Jan 2026 23:22:12 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs for 7.0-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> [...]

Merged, thanks!

merge commit: 60382993a2e18041f88c7969f567f168cd3b4de3

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


