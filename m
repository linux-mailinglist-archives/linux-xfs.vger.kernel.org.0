Return-Path: <linux-xfs+bounces-30560-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCNIFKtSfGmwLwIAu9opvQ
	(envelope-from <linux-xfs+bounces-30560-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 07:41:47 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4D7B7AB4
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 07:41:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CB5CD3011A6A
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 06:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331BE33E34E;
	Fri, 30 Jan 2026 06:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/5W0PLq"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103ED33D512
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 06:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769755305; cv=none; b=DkexPDKkapjzxDAWVrBN8H4YOb08Mk72KJYNj5Yas4VZEa1foyt/WAuFen1sgKoUo3tkagZJP4QeZ/8LolxVnhtTeq7Uiok3Ab1kTh25Yq90hE/RIAjdlQ6OGGtWBTsGTTiTeEydYyjJ2Oasdp/YCoiIuuc0C18/BMI5xeUVa1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769755305; c=relaxed/simple;
	bh=adDzHg5EimOOMRq2eDqbNBsgA86t+1i9hVj6IdvCRLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RkIior8Kb1Z1h4kJyt8sDBoZm+16GPCgYsPUPAti5PYC0lio67FJB52PXIfmbNux+YlAQjg1+2FLfpu2E9PXqRuY45mEz7xePesvQXsg3k4lDqaWMk75Xam2YescuK7FDahN4/zvbudpJgPhhpBuIAD6J6kmUs9UEsFm8u+Sz/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/5W0PLq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD04C4CEF7;
	Fri, 30 Jan 2026 06:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769755304;
	bh=adDzHg5EimOOMRq2eDqbNBsgA86t+1i9hVj6IdvCRLg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F/5W0PLq1XP6fxMK54bo7nMMiQav+TIHpbNrgW8UUaqYPgyrrVHQNkuVYamXfjYYr
	 B630tsdPkTDml974ATymIg8HZSAiy4YkubuxpzqdvFtpz9AHebb4M5sluh0b/D4ohU
	 fUuIDfbrq4cqxPAi7ZqdSfhJTMa7kL9GLZSTpvke6qaqUsBYJzR8NlS40LImkD1Vju
	 6U8VC9eClrifqm4/dGKW79lPIvWBWAFoaKYi2WmCzNEcvqkZoHxpWtt0ZV0yRqCnSf
	 1xgc6woRaJEuGMCawATI9u9cuq3HJC/eiFHWXEq3HJG9eDIF6058c+ayB+uvYn4h7S
	 yuk8TOxnMlzgw==
Message-ID: <34e20771-d036-4ffe-b443-c27e30bd2eb8@kernel.org>
Date: Fri, 30 Jan 2026 15:41:42 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/11] xfs: give the defer_relog stat a xs_ prefix
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260130052012.171568-1-hch@lst.de>
 <20260130052012.171568-11-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260130052012.171568-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-30560-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dlemoal@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lst.de:email]
X-Rspamd-Queue-Id: DE4D7B7AB4
X-Rspamd-Action: no action

On 1/30/26 14:19, Christoph Hellwig wrote:
> Make this counter naming consistent with all the others.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

