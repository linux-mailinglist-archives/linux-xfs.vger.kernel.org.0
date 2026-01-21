Return-Path: <linux-xfs+bounces-30054-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qI+HBLXGcGkNZwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30054-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:29:41 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6D456C6C
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E295B9C571E
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 12:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624EB1E5B68;
	Wed, 21 Jan 2026 12:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mxl046Kj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E235280324
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998227; cv=none; b=afgWrLkcAb3PZYlXtQpxm9KhhweFhH7YiQrJBUXiPUpaK0mcVkW9DX8JkEIoHwy47J4fVGSJJJtJBdBee+hcyTV6AC7dmnijOq+KEYAjr7UCXXZbQPTNFRCdHiGB6ePd02hjiu3+SfD/DkMjKJrYkwGMZhOgX/J23lb8lPM3XcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998227; c=relaxed/simple;
	bh=+CooiZbkve2KMLULNZLmkT5tjGwzBZuiCEHRB8r8v5c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IOOW9sjAfplYe2qiOcGMZwf6ffcnUgJCxD3sQuwCrhaqseVf7jxgsE/fZT02ojKMQ2OzayKIlAlgnxxGPgyr2GomfKJicWVRkwpAHV6PfkQrdEV6EocChlq+TB2u6y8FR2pSGlKOEFJQYmiJ8nho6AZnduPpAAb8xON3eBHyk98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mxl046Kj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E21C116D0;
	Wed, 21 Jan 2026 12:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998226;
	bh=+CooiZbkve2KMLULNZLmkT5tjGwzBZuiCEHRB8r8v5c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Mxl046KjY9v560kSKqbYiKbwGJZibfa9PKFE7+d1CNWG/OTwJTw5dwpU7dyeUO5yg
	 UVX94JXU5VTcDeiQ1SEyIsCgvGuvbveSk2ejivaAVjpqu4btlydZtnRNOe+Zl78mc2
	 GnFk8L2PWzO3Lwbszah2GjkIktltbephGKtLwzYvII3pG+/xl87GN99KHJwbTt6+aC
	 UMPstXzE65FrlPzD2Id5lzep5tOudX8PYQdjJz7LgnkRbnlFv/9gVoBxGrUg2/tgZ1
	 jRCIucEQNDjjCf7SuoxEOfExA4y/5evQCAD/mSW0GoKr5d4cLQv1GVaj+U+gknATg5
	 NSTg0hoCm+ung==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
In-Reply-To: <20260109151741.2376835-1-hch@lst.de>
References: <20260109151741.2376835-1-hch@lst.de>
Subject: Re: [PATCH] xfs: remove xfs_attr_leaf_hasname
Message-Id: <176899822575.852789.16884969955086028170.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:23:45 +0100
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
	TAGGED_FROM(0.00)[bounces-30054-lists,linux-xfs=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 9F6D456C6C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 09 Jan 2026 16:17:40 +0100, Christoph Hellwig wrote:
> The calling convention of xfs_attr_leaf_hasname() is problematic, because
> it returns a NULL buffer when xfs_attr3_leaf_read fails, a valid buffer
> when xfs_attr3_leaf_lookup_int returns -ENOATTR or -EEXIST, and a
> non-NULL buffer pointer for an already released buffer when
> xfs_attr3_leaf_lookup_int fails with other error values.
> 
> Fix this by simply open coding xfs_attr_leaf_hasname in the callers, so
> that the buffer release code is done by each caller of
> xfs_attr3_leaf_read.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove xfs_attr_leaf_hasname
      commit: 3a65ea768b8094e4699e72f9ab420eb9e0f3f568

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


