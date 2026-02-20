Return-Path: <linux-xfs+bounces-31191-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGC4GkqXmGlaJwMAu9opvQ
	(envelope-from <linux-xfs+bounces-31191-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 18:18:02 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0004169A9D
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 18:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 536713051CB0
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 17:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2161F32AABD;
	Fri, 20 Feb 2026 17:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="ro95OdAT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECBC322A1C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771607853; cv=none; b=mZzFF7ummaMiZ3ygznWr3ww2SCS9zOqIvU/UWIytCYtYZ36zjVkdWvFu0K1c5AA2+xsCYKNESdb9GOGRTEKnqtLV6TrezZOOTMtFK3i4Z3om2yCo54Q/qpQnlRHjNSFIpnYHvfGuM3IRHOXi4nJX1hIuvPDNE7quPVHFStE/FeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771607853; c=relaxed/simple;
	bh=O6OxqMJbaPs+0W2b57PGJgVm+ChM2bLhrhvpF63oeiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UJnFEcuZuXvwepg+IwjFN3T4Dh5gGbCnKlZoXt7lt9xGwVnNKX0Lvf441yUCgxZ+5nC9MsI1LivBygJCauT1iA01SqT22Lu586Djf71Za4NAfBTvfP0S7d5ifB/6B8cFraqAlhbmYATjJhMQiWcUUhelXjqH52KuUrAsjCeuLeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=ro95OdAT; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=O6OxqMJbaPs+0W2b57PGJgVm+ChM2bLhrhvpF63oeiE=; b=ro95OdATKllOR0Uc/ufrYFdu3J
	WJ4RL6/10B5WeuwVTFvM7sZLv3w/8bFsXJ7mw/rqS4l8n68pDCY7xY0iSVFGHoGKgUxLbJDrniA+1
	dDtW5Hcfx65YWDQd7RLTFwzkzW2DDYcthXBbW+qsg6ZrAzf5UsNf2STUw5HeZ+e0dPKFSm8R29maf
	E+q14nOWCYrHNitL8WkT/0Bv4lWg0kFscHe6E9GpD33YEp+k1Cm9yXMekTYliSAmJblzSl6enmKSn
	+0QU17xZcmB2bsvcxaMrs67ut+o1PKDlFbCqI5EyytiX0LCRXHcSQHb7fz4gfGcCzqPNBFh4701P8
	294ohpVw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1vtU84-006nrR-UT; Fri, 20 Feb 2026 17:17:23 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH] debian: Drop Uploader: Bastian Germann
Date: Fri, 20 Feb 2026 18:17:10 +0100
Message-ID: <20260220171714.852017-1-bage@debian.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[debian.org];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-31191-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bage@debian.org,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[debian.org:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B0004169A9D
X-Rspamd-Action: no action

I am no longer uploading the package to Debian.
The package is the same except for debian/upstream/signing-key.asc
which I have kept on the actual signer's key for the releases.

Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 66b0a47a..6473c10b 100644
--- a/debian/control
+++ b/debian/control
@@ -2,7 +2,7 @@ Source: xfsprogs
 Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
-Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
+Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
 Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libicu-dev, pkg-config, liburcu-dev, systemd-dev | systemd (<< 253-2~)
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/

