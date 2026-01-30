Return-Path: <linux-xfs+bounces-30565-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPB3DEl/fGk8NgIAu9opvQ
	(envelope-from <linux-xfs+bounces-30565-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 10:52:09 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C60F7B9114
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 10:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 49966300A8DB
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 09:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E54432E723;
	Fri, 30 Jan 2026 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jP2BB6jv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA0D2EAB71;
	Fri, 30 Jan 2026 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769766727; cv=none; b=B2x/ZNgt+fg7odMDZFo7Yv2BSvFt4p0PeWw6DI5CdHScrGsB/3y5aGVDWb9VXvwEiM/+CU/Yu+Bjhj1jVt+rSse4PKRQg/VgAZ2B5Ltz77FsoPxSgtjAUrCQHJJGIZPZA93Fvr2IPoUPJoDIER+bavu09A2CIvHEDZOCoRtWiCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769766727; c=relaxed/simple;
	bh=QzRHMDkMfe6hwfcVW7glQ6TNVlACTNNmHj8snGT82Ps=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EMkG3q0DNh7/+MYTvfB1XIQL3bZw2b895Sa8fkgDQCG4BLRav7Jey0YTHeOuM8ceu4XR5gPTrQvcXS1R4fAxHhq5NZBXcX92g9tGEZU1Tay7scJdpBuTUmospVV2a6Nwu1RpX/lRg9zsKChqaVKti8hW/FwdSPCKLR5LVqnyo+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jP2BB6jv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235FEC19421;
	Fri, 30 Jan 2026 09:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769766727;
	bh=QzRHMDkMfe6hwfcVW7glQ6TNVlACTNNmHj8snGT82Ps=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=jP2BB6jvZYMu3FBfBxZo+0NGr03Kt/T7wyY5cHxKPofbYYvRq3cllb0Y+qPps4vmo
	 +3XiUH+4p4Zed4wHE/7RUZ1BWPjov5Vywi4RXnUksypIDJPdOTYocgrb2Xu50A3Z4k
	 XY5DkFwUTNf38JEbu3AMpolD2V0+14yMka1/rsSKYVXp9G8ESvuDnJXlSmh98AH7cY
	 TKvH1qcCJnGfyHrpquCYByBaPZo7qzoS6SbYTnhjqwtAqS2V3AvlVy55WoIq0JLgoE
	 t28Tr4aPAXtKqIJYTaMnIZaJJ42c1wItwj8tbo9Y2o9lcdo8gOfhyQMs70CIfWWUAF
	 vnz/z0g8Fnbtg==
From: Carlos Maiolino <cem@kernel.org>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: chandanbabu@kernel.org, djwong@kernel.org, bfoster@redhat.com, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com, 
 Christoph Hellwig <hch@lst.de>
In-Reply-To: <20260129185020.679674-2-rpthibeault@gmail.com>
References: <20260129185020.679674-2-rpthibeault@gmail.com>
Subject: Re: [PATCH v6] xfs: validate log record version against superblock
 log version
Message-Id: <176976672483.101188.14038361815799165327.b4-ty@kernel.org>
Date: Fri, 30 Jan 2026 10:52:04 +0100
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30565-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs,9f6d080dece587cfdd4c];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C60F7B9114
X-Rspamd-Action: no action

On Thu, 29 Jan 2026 13:50:21 -0500, Raphael Pinsonneault-Thibeault wrote:
> Syzbot creates a fuzzed record where xfs_has_logv2() but the
> xlog_rec_header h_version != XLOG_VERSION_2. This causes a
> KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
> xlog_recover_process() -> xlog_cksum().
> 
> Fix by adding a check to xlog_valid_rec_header() to abort journal
> recovery if the xlog_rec_header h_version does not match the super
> block log version.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: validate log record version against superblock log version
      commit: 44b9553c3dd043f14903d8ae5d4e7a9797c6d92e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


