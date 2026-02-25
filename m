Return-Path: <linux-xfs+bounces-31279-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFDrJxXEnmkuXQQAu9opvQ
	(envelope-from <linux-xfs+bounces-31279-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 10:42:45 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60AB1195316
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 10:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 81676309555F
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 09:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B19738F242;
	Wed, 25 Feb 2026 09:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmviitsE"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BFC38F246;
	Wed, 25 Feb 2026 09:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772012326; cv=none; b=cBPQz3HXbuTBPHopJbtzMmYAbFkYvHUOrD1PKH84aWmXx7GwGcWBS5kiSytGweE2KwlkIuIU3NoDCfuGelm8MIORLIaDypVNY4FT3KtUj+XovJFKT+OE8wRU0ITJiLT5mJ1Z5CUTf+k4XfvQ/DuBJNFPmEKdnHGC+w3rQAi0JNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772012326; c=relaxed/simple;
	bh=lfi05J89RRrbhiE4UWHFK5tZNhHQMDGgVHV69yqt/QU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=trSzeVXNCnsMMCcECb0kLl+oLJROpnotqh1aT85eqZ2wDOblrI4gUBEIlQTSlBIKF/u+3B1rm4MFdkTuaE3eTIAKcr5n32QYNtkwBd3eLHb6Tzq//kq6IbhWJlilzFGdBSnV5SNK4nkgccm32uk8C8+MiCNFFPvLGgMojMna3k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmviitsE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA7EC19422;
	Wed, 25 Feb 2026 09:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772012325;
	bh=lfi05J89RRrbhiE4UWHFK5tZNhHQMDGgVHV69yqt/QU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=JmviitsEnEXELcZPnWleU6QEo7wtiVdrzZDkkO5oW7gEFF0AQGYQpRekSjy1c0j+2
	 7sY/8X/pdnTY6s0Oho8kaM+jHMxG7SyiEjtuehuvvHUgmzu452H1pMQT/Q5Dy6g6NX
	 JijxACIo2yho6Vco2httt5P0vemrh+gNZZK6wyLaCG9mSi5QrVyBb/DGxB9vTNigxR
	 udqTgkFTWEeOXfEigVJNQqfTXqoKrT8zycPy4SF6ilQ3usmKqj57DgkjON1iJxVi2k
	 cgvd01tuex+Uy3aaMlTrKfsPb+uFE4+1zC+iVqXfsLgGiLNAy+c30NyG52EveDkD9a
	 Q5absLPlZcw7Q==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Ethan Tidmore <ethantidmore06@gmail.com>
Cc: brauner@kernel.org, neil@brown.name, jlayton@kernel.org, 
 amir73il@gmail.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260220033825.1153487-1-ethantidmore06@gmail.com>
References: <20260220033825.1153487-1-ethantidmore06@gmail.com>
Subject: Re: [PATCH v4] xfs: Fix error pointer dereference
Message-Id: <177201232362.40354.12522642521416160152.b4-ty@kernel.org>
Date: Wed, 25 Feb 2026 10:38:43 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31279-lists,linux-xfs=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,brown.name,gmail.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 60AB1195316
X-Rspamd-Action: no action

On Thu, 19 Feb 2026 21:38:25 -0600, Ethan Tidmore wrote:
> The function try_lookup_noperm() can return an error pointer and is not
> checked for one.
> 
> Add checks for error pointer in xrep_adoption_check_dcache() and
> xrep_adoption_zap_dcache().
> 
> Detected by Smatch:
> fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error:
> 'd_child' dereferencing possible ERR_PTR()
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Fix error pointer dereference
      commit: 98899e053df0678bcabde2114d509b0e308cf52c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


