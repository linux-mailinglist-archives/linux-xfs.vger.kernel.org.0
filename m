Return-Path: <linux-xfs+bounces-31282-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 1I7rJDPEnmlEXQQAu9opvQ
	(envelope-from <linux-xfs+bounces-31282-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 10:43:15 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 793CA195344
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 10:43:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1898A30A02F5
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 09:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6A438F259;
	Wed, 25 Feb 2026 09:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAVj3FAm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7935E38E5FA;
	Wed, 25 Feb 2026 09:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772012332; cv=none; b=Sj/adNswH3gv1ov3TXaIGHT+yhUWfkkx5zJFufUqHBvhrFwoFBy1yTrK4v3vktxAcgpcWOx7j0j4Pohi0acWFd8nRHzOTiagwtmHh+RNU+RaYSAlvlWnyvlsISN/cb9YnZYI9NuqDtWCgJOfJu+3gtMlyPJiGlw1BdH3p6wO/rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772012332; c=relaxed/simple;
	bh=nhbA1ppGEXGEhKFLVMT3pCtdX8dRgHiPQj9eIoWOHdg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AkFgye3vMt/UJMAohwYz67PZD2TwPeOsFRzYw7YifgjPfAEcwMGFrqEn14N61/K8hfbe+IXaBucvQe4ZF/498RNHnhpu2Vclh5tGc6dqNzdocjuCMzUM2x6Te7bXEh41nb8QB4He4c+IsKLdMJOBxZuA7Wyw+lIK455t05Y77EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAVj3FAm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFCBC19422;
	Wed, 25 Feb 2026 09:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772012332;
	bh=nhbA1ppGEXGEhKFLVMT3pCtdX8dRgHiPQj9eIoWOHdg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=nAVj3FAmSdtPRLvbDndr4ug8DsN/v4maN76M/qRVkH8wvdlZjlbN0a9O7+5PUUFC7
	 ueb3cs4MuPebcj8gA6qMnHeUQW7B0c1QO7gIcoP0cWQhDMWceNGTP7zpIawZwPkavy
	 rUo2eRg/debbYaWPg53pel34CEPP8wF+b9ttDBzQ+Wo6HmXT4xkkD9GdnfCyQK36qz
	 /PE4ZU9gN5+LahD7wdaIMySAHKaGVw6PExtdtjyArLE8i/q9aMvo3+qLB/gfmPOVHR
	 vPj+WEoxtU0V07bR0Br2UqnD+QKRW+O1N2xHlUajgkQ5vSMZ/sMsJS1TXr1cAEjl9V
	 PHtyWWg6ZtaxA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Christoph Hellwig <hch@lst.de>, Wilfred Mallawa <wilfred.mallawa@wdc.com>
In-Reply-To: <20260211032902.3649525-2-wilfred.opensource@gmail.com>
References: <20260211032902.3649525-2-wilfred.opensource@gmail.com>
Subject: Re: [PATCH v3 1/2] xfs: remove duplicate static size checks
Message-Id: <177201233055.40354.6150258423184087454.b4-ty@kernel.org>
Date: Wed, 25 Feb 2026 10:38:50 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31282-lists,linux-xfs=lfdr.de];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 793CA195344
X-Rspamd-Action: no action

On Wed, 11 Feb 2026 13:29:02 +1000, Wilfred Mallawa wrote:
> In libxfs/xfs_ondisk.h, remove some duplicate entries of
> XFS_CHECK_STRUCT_SIZE().
> 
> 

Applied to for-next, thanks!

[1/2] xfs: remove duplicate static size checks
      commit: 3ab9082fcda0ce7d1b9fcfc3fee5b66f82c4edf2
[2/2] xfs: add static size checks for ioctl UABI
      commit: d7a47448177783ecdb9faa96770006ce660b7c62

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


