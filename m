Return-Path: <linux-xfs+bounces-31012-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0J9/My2nlmmTiQIAu9opvQ
	(envelope-from <linux-xfs+bounces-31012-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:01:17 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA5115C45C
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:01:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 95B7130066BF
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366802DD5E2;
	Thu, 19 Feb 2026 06:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTWm3DxT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143E321FF33
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480875; cv=none; b=rs44f1aD9QTlpnuGbqW2r62uUPwpUAy1SZS4FKOnJY+KlNNwdql/JAeYuL0vH27LlP79rESNsnJAAPOMJD/GFmP7YRfr07I4WrwpDIeamfG7r8Dfv1GsDAWSrA9R+R7cUl7wW8562f6fGoidIC4CFjpkacDBKTZz1z7OfpB37mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480875; c=relaxed/simple;
	bh=6DWg5PlOcuHKVYFUbIJmDb5zzppSE7BlzAM3HPi9woo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3lp0UK5Un2SKpQCnIcs+OIWyXZyclCBsZoqpvZCVlwQtTzD3pXBv9xoiUXPiij+WPD817etNeFVBEIWdQhBHyOHOMt4fR8zegrJRK8ZTKXQQBEDM9IQWqWI8aWM278kNSrEDsbPvjjH8GxlE+J44YqohuxRldzYLBW+HumooxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qTWm3DxT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EC8C4CEF7;
	Thu, 19 Feb 2026 06:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480874;
	bh=6DWg5PlOcuHKVYFUbIJmDb5zzppSE7BlzAM3HPi9woo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qTWm3DxT6MQzs0bFTq3ufPQG20Q2M/+v6iY6am7d2moVeMeyZTycyjUE6LnAA790c
	 cLms3a9fbsogDYjbF61pgxXmW5Zjbd/kwPBRav5c0xw/IA7YZF5y6EYQsnCA0LZCL2
	 7Eu30fOTiUS3UbSlMuD1n9gYz/k+cOzJNJSlK42ys+D80NARjEdvzQHZE9sbDbb1WI
	 br6yfCHhjIpUsYs7FrViDth5yAKN0CGIVughXz/UwVnTZq6Qux6m1xGpe50B8T8Wlo
	 fRZ3MZD9S7Jb3inEXi044nX+UyEjkB2fxR5hRsy9R3I4vQqMJrwxL82+8JO5noCxAN
	 JG9sWAsWwuANw==
Date: Wed, 18 Feb 2026 22:01:14 -0800
Subject: [PATCH 2/6] xfs: fix xfs_group release bug in
 xfs_verify_report_losses
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: clm@meta.com, linux-xfs@vger.kernel.org
Message-ID: <177145925451.401799.12258119310555841656.stgit@frogsfrogsfrogs>
In-Reply-To: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31012-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,meta.com:email]
X-Rspamd-Queue-Id: 6AA5115C45C
X-Rspamd-Action: no action

From: Darrick J. Wong <djwong@kernel.org>

Chris Mason reports that his AI tools noticed that we were using
xfs_perag_put and xfs_group_put to release the group reference returned
by xfs_group_next_range.  However, the iterator function returns an
object with an active refcount, which means that we must use the correct
function to release the active refcount, which is _rele.

Fixes: b8accfd65d31f ("xfs: add media verification ioctl")
Reported-by: Chris Mason <clm@meta.com>
Link: https://lore.kernel.org/linux-xfs/20260206030527.2506821-1-clm@meta.com/
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_verify_media.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 069cd371619dc2..8bbd4ec567f8a1 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -122,7 +122,7 @@ xfs_verify_report_losses(
 
 			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
 			if (error) {
-				xfs_perag_put(pag);
+				xfs_perag_rele(pag);
 				break;
 			}
 
@@ -158,7 +158,7 @@ xfs_verify_report_losses(
 		if (rtg)
 			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
 		if (error) {
-			xfs_group_put(xg);
+			xfs_group_rele(xg);
 			break;
 		}
 	}


