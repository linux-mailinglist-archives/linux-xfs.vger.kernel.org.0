Return-Path: <linux-xfs+bounces-31664-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UA9eHzAppmk+LQAAu9opvQ
	(envelope-from <linux-xfs+bounces-31664-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:20:00 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D43DF1E7100
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ECABC305186C
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 00:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EDC1632E7;
	Tue,  3 Mar 2026 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imS10cBX"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6735E390991
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497169; cv=none; b=BI8zQljlrBeq0CZZcXt247+C/dJNGz0l2aHTfpwgI3S3UNXQA5JKMTfiQCl5ksqpEZxPhVOIamD5Au3VpLTCHLExs0yO7EFY2zqJk8vdkyAhJkxQsteZagv5ZJ8BmkpflWijehSJ8CyE7Na9vKLxJiQyJiAJiVjqmtmxwBr7908=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497169; c=relaxed/simple;
	bh=2dE2YuVgQK72DY6DVbv/0Iga+0ko0sKqqaj61UXPqdg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uKphqy1eNdwtLt2v0wc0Cjm1KgQjW9qr80zU47yWcnCR3A23N3Lh3TFvug/iJUUwfB7oNcY58xJnchi1l2JFFhJYxZQKGd17ODDO4y2QRuVirxzPdMA0YdToZ0Qbz0dAeY5q8OygURbR0nEL5c9BiRj/FHcijGBxBI8GSujjX+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imS10cBX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D85CC19423;
	Tue,  3 Mar 2026 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497169;
	bh=2dE2YuVgQK72DY6DVbv/0Iga+0ko0sKqqaj61UXPqdg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=imS10cBXv0lx7bQKylo6ZP2n2JWTw7pKsurDVysuhZraUs2d7lId86UH2aOUBFM8X
	 ORmADqXkXsRMA5ePZVGFfnrWaiQMx1PS72gDkzTBo2dS2VsO8isty07RSnfxkvQAhY
	 V80kVTqmck5Ptulp22VSLjpLpw7frubJ4QC/7x0fnBqa6JbYEAGWJgpS8P3RWinnad
	 wVXzbsQLR3tMGh7fiJnV70fGeTVLfL7C83DzRDkrBmu6FLBJlrhudgmSUaUkanQfBh
	 TvHcVCLeUVOvzjlIpNYD5LTIJXqi39d9ytcaj4Gx738bUGrN27GwS6ErU2+C3TebrK
	 4ZeOhwCWypOAw==
Date: Mon, 02 Mar 2026 16:19:28 -0800
Subject: [PATCH 28/36] xfs: give the defer_relog stat a xs_ prefix
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, dlemoal@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249638293.457970.8228658779271002294.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D43DF1E7100
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31664-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lst.de:email]
X-Rspamd-Action: no action

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: edf6078212c366459d3c70833290579b200128b1

Make this counter naming consistent with all the others.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 5bd3cbe4cfa1a3..c0d3aa401cbab5 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -558,7 +558,7 @@ xfs_defer_relog(
 			continue;
 
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
-		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
+		XFS_STATS_INC((*tpp)->t_mountp, xs_defer_relog);
 
 		xfs_defer_relog_intent(*tpp, dfp);
 	}


