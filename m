Return-Path: <linux-xfs+bounces-30568-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCaxK3PRfGlbOwIAu9opvQ
	(envelope-from <linux-xfs+bounces-30568-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 16:42:43 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 39C12BC21E
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 16:42:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D9D8C3004F65
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 15:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA3B333439;
	Fri, 30 Jan 2026 15:42:41 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A6E330337
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769787761; cv=none; b=KGM9UZFpjZMiEwhfNBPOh/MSjMPFvxCt6bfxFcA4i7+VnsHX3OzAllMfMSdnLxh2EthvFMmVGbA/JhBoaFaKhBmsQ7prgfZCnJYTMIaUbXzlH6tLKxrPCsjYF6OH2oe9/OAiNYJmyNGTVJK4+7JCHFFm4jZkNE5CFZyVHTpm/7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769787761; c=relaxed/simple;
	bh=TmU2CI91+CKnD1d7i9FTmah+L2Qa3QAstkk72rpQ6BM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SGxuhfpc42St/HRc1AEN21vYbgYIQynRVvsmnUARV+rjCvPidFXgnxZ1zSk30P+NEz/0TV/0VaIidoqB7nx8Vui9pBsNESPP7cEhqbTRAGhaGTpBs/h9ety/RcXIZjooOSVAGEZt2FHI/ar1po2ZicNZr9CxiZxqMoqM8hY2ggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 58BF2180F2D5;
	Fri, 30 Jan 2026 16:42:25 +0100 (CET)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 6oFZDmHRfGnyPBkAKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 30 Jan 2026 16:42:25 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 0/1] xfs: Use xarray to track SB UUIDs instead of plain array.
Date: Fri, 30 Jan 2026 16:42:06 +0100
Message-ID: <20260130154206.1368034-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30568-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[herbolt.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	FROM_NEQ_ENVFROM(0.00)[lukas@herbolt.com,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 39C12BC21E
X-Rspamd-Action: no action

Hi,
It was discussed in previous thread [1]. Some older kernels (pre v6.12),
complained doing allocation over 2xPAGE_SIZE in krealloc when mounting over
512 unique XFS. 

The warning was removed in v6.12, but Christoph suggested to start using
xrarray instead of plain array. So here it is.


[1]
 - https://lore.kernel.org/linux-xfs/aPhjZ4sfHngyJRQK@infradead.org/

Lukas Herbolt (1):
  xfs: Use xarray to track SB UUIDs instead of plain array.

 fs/xfs/xfs_mount.c | 87 +++++++++++++++++++++++-----------------------
 fs/xfs/xfs_mount.h |  3 +-
 fs/xfs/xfs_super.c |  2 +-
 3 files changed, 46 insertions(+), 46 deletions(-)


base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
-- 
2.52.0


