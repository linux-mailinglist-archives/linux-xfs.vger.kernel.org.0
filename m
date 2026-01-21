Return-Path: <linux-xfs+bounces-30052-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMaSEn3FcGkNZwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30052-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:24:29 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 378C456B5F
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DC43042578D
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 12:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929E641322A;
	Wed, 21 Jan 2026 12:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfJn1sME"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA1A3B8BA1
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998137; cv=none; b=pi8bmLDp2raRVszTzPQlglqodrDZKSlizg8y4dmYrOXHZDfKjrn4f/38YUmhiFthqdSFcIm71X7MqNBJbtSUrhvvkJuETi9LK0vKeqkP1HMYZdg/8MDfGGzol2QDEN6ylYVkaUvMeqVhI7V/1N06ZGMh4JoecyLDfbKq0MaqGcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998137; c=relaxed/simple;
	bh=FdOo3wSXVBjC7ZWg2SUoy53Q1UzzHtiOBjNDpexlKvw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TXhtHKg3Wd1OW9vNMGPhu/qD+1zhi9H7SeyCTUuIwAMfG1nx5RW9zFHvs5V4kzRoFvyJNihvj4gi6wTr+vqhqj0xy6BcPRz3z4lh9tM7Qzg0I0PINm2fUm3kP6HJQJ4FdYFvVanvHitMdEfd4opbyZ3n5QXZSnKINU8FT2KzpMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfJn1sME; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41753C116D0;
	Wed, 21 Jan 2026 12:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998136;
	bh=FdOo3wSXVBjC7ZWg2SUoy53Q1UzzHtiOBjNDpexlKvw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=YfJn1sME0a4azE6zV7hE6HyPTHvkCARq1iaYv9OE37DdjTa1a8yFAg1YNgPKhPlYS
	 zmhwOv1OuMYwNVvUMa9twPwE0xEPymt+r/0EoLtn5cWHYS+EODjw35Y1XofbvVFG7u
	 kO9hZr/dmSdvFu4uqx4ZeSUCsFrYZm148kBGL5deYYoFWb1cTZFkgv+bddTZnwHx0m
	 D5qgjXJIJdHo3lJ0yktus6L4c0MYgz3OkSi9QYP8vxPULNfLCtBDP5e3vKcU+n7Q0S
	 veTV2yicS+unYogD64OI0Xww7oSPK1HuQ5K1u0IEgbvWQ8BuBMSZUW4CKHLVIW9wbv
	 gw01FapRIv1uA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20251219024050.GE7725@frogsfrogsfrogs>
References: <20251219024050.GE7725@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: mark data structures corrupt on EIO and ENODATA
Message-Id: <176899813495.852572.16929545766879384817.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:22:14 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-30052-lists,linux-xfs=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 378C456B5F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 18 Dec 2025 18:40:50 -0800, Darrick J. Wong wrote:
> I learned a few things this year: first, blk_status_to_errno can return
> ENODATA for critical media errors; and second, the scrub code doesn't
> mark data structures as corrupt on ENODATA or EIO.
> 
> Currently, scrub failing to capture these errors isn't all that
> impactful -- the checking code will exit to userspace with EIO/ENODATA,
> and xfs_scrub will log a complaint and exit with nonzero status.  Most
> people treat fsck tools failing as a sign that the fs is corrupt, but
> online fsck should mark the metadata bad and keep moving.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: mark data structures corrupt on EIO and ENODATA
      commit: f39854a3fb2f06dc69b81ada002b641ba5b4696b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


