Return-Path: <linux-xfs+bounces-30430-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCOaMK2meWl0yQEAu9opvQ
	(envelope-from <linux-xfs+bounces-30430-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 07:03:25 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9C19D4F7
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 07:03:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E8753007F6C
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 06:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79063358A9;
	Wed, 28 Jan 2026 06:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnaZ8e1D"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310A7335571
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 06:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769580202; cv=none; b=ZF50lovlo3WowDUP6WU49itYSn5lEdPJ/d6lfV2SebQHcncdUUQVME064kgiN2BPou4Y9rWWNI1obHNRWLc1uKGXi44L0BCQZ8JuIqAmg096xg3Od7js2ZEAI4rWYKKziznPJzr9rrhIZNIIWG0zjg/G42YMer+4JTznP49janM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769580202; c=relaxed/simple;
	bh=rKJNcXxQ7EZvQYDTLSDMqc4puj6f0yG1BSEXQTs+XFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n6v42vdANLK0NHsyjzmxgNj3avjsMqptIAfct0AejoVYxRliYjaVKVI41mEusp75v0L5h/lGSw69JynyeCTn9b0bGHqj5JMxO1LZVyZ5jocjGEdES5vNMA39Rzq8nYUXD4zsXYugmLbDUkZLIgQsq+imM9k6ZEAi4YrM5Y+e258=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnaZ8e1D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03906C4CEF1;
	Wed, 28 Jan 2026 06:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769580201;
	bh=rKJNcXxQ7EZvQYDTLSDMqc4puj6f0yG1BSEXQTs+XFw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YnaZ8e1DpOVVKa13iDr+Mf/EL1D3eWSUxz4PDnjj5dchRr2d8HBI7VpxFP0hys8aT
	 sTjC+IHvTQYxNN1Y2pgZWhxbdCzbN9nVFpHq6FiAD3bnAA8EpmOzTFTU14tBaptK0H
	 pCQpIjw9Gt/XYzK/+m++MMNDE3SqQvoH+7TQ8WO97KfQbMgPKomwGczOKPXSn5CsUV
	 Uo8mkL1tTaR+9PmZ98rP+qc65l/UmiYwUUYrhKj83aHVYY/LCAaRWEWIsKlcYeLSv8
	 bJYh8JkEv2WzGSvY4MdIyVpf3i0KKauIu6n47ZIFkSZWAXOREuLYdiCakTdRLbndvT
	 zKs+x04o4zrIw==
Message-ID: <82c9707f-7a79-4a81-b17a-be020f320640@kernel.org>
Date: Wed, 28 Jan 2026 14:58:22 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] include blkzoned.h in platform_defs.h
To: Christoph Hellwig <hch@lst.de>, Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org
References: <20260128043318.522432-1-hch@lst.de>
 <20260128043318.522432-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260128043318.522432-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-30430-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dlemoal@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lst.de:email]
X-Rspamd-Queue-Id: 2F9C19D4F7
X-Rspamd-Action: no action

On 1/28/26 1:32 PM, Christoph Hellwig wrote:
> We'll need to conditionally add definitions added in later version of
> blkzoned.h soon.  The right place for that is platform_defs.h, which
> means blkzoned.h needs to be included there for cpp trickery to work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for fixing this.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

