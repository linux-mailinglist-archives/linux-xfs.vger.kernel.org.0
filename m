Return-Path: <linux-xfs+bounces-30053-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKyrObfGcGkNZwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30053-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:29:43 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 788FF56C73
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:29:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7DC4D9C55C3
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 12:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E3D244694;
	Wed, 21 Jan 2026 12:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="acVUeiDg"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FDF33971F
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998204; cv=none; b=soSAznxI2B7iC2jmYMdxV6xb57zjrGqXLp0nTnGHpwvZRd21caIcZmgi3wdkdURB3tuvysf6qv4FWgzC4ak0bs/YzI1xwfkIVuyqsDiob9J/ydWf1Iz+YBx8mkEb7PKfZFcN9vgf88AsL2H3hS0e+ITFIFk+D8GkLQe5LxbjMgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998204; c=relaxed/simple;
	bh=QRSl5Zb5NADjH2ijyLS6aIlSTkx07S5YLRj8OOzd3os=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lPplpO7HFhjiuHkC5B54mPJvnm7IgiRNRmBW6PcQ0EUbrl7iYEzjykOZMXC89icNRCK0A6SfoCrS63t57XcW9pMKHPSp2HBaeBxXvc3jLh9in6vziW41UdUXKpcID9tTzzvKBKLnEbnuIuNmFPKw8e87I+U8Pm1tdBGVIVFIwWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=acVUeiDg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D270EC116D0;
	Wed, 21 Jan 2026 12:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998202;
	bh=QRSl5Zb5NADjH2ijyLS6aIlSTkx07S5YLRj8OOzd3os=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=acVUeiDgPVjOewOJvI1FI5v+icSGVwooLjSQS76wiGVxRdA3QunFZxqGEXEWClAOL
	 lkQcpRbi3qe/FV61hGdapB+T7NAswtS3zmer2nKIC5ztFnThTjVwVBY8aC6l5BH631
	 eOop/YeX5XuWmma5opCF9b7eoGqTYRrAqqHmcsWvpYULp/8o2hojOh1hgn9pTBHXw3
	 9uMAVdlYc4qRuSOdFx7U6wRtOLkTTxrYDlslQ6f5meHdVOp+E3ZF2/FhkNFee9o8qW
	 wNxN+7tMKbbXFUZwbQJt6XIir9wEforb+9WS06Cw3XedUA3yg4/6EjUrl+0ofC/ZjC
	 ZerrLDz2AEr1g==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260121064540.GA5945@frogsfrogsfrogs>
References: <20260121064540.GA5945@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: promote metadata directories and large block
 support
Message-Id: <176899820156.852684.15749463510034523694.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:23:21 +0100
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
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-30053-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 788FF56C73
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, 20 Jan 2026 22:45:40 -0800, Darrick J. Wong wrote:
> Large block support was merged upstream in 6.12 (Dec 2024) and metadata
> directories was merged in 6.13 (Jan 2025).  We've not received any
> serious complaints about the ondisk formats of these two features in the
> past year, so let's remove the experimental warnings.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: promote metadata directories and large block support
      commit: 4d6d335ea9558a7dc0c5044886440d7223596235

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


