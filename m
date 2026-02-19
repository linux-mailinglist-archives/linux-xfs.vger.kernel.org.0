Return-Path: <linux-xfs+bounces-31131-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eO92NVOhl2nc3AIAu9opvQ
	(envelope-from <linux-xfs+bounces-31131-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:48:35 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D1C163ACD
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 83A163055DF9
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 23:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8378931B108;
	Thu, 19 Feb 2026 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfunYst7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6172131A813
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544625; cv=none; b=WB07mVM96Q3/XvMJVsycM2TKEkMNWNF9mWiyHgdhC8RvQsL0Jk6ghqZvFY7qZqaUh2O9NgmcCtgoB03bxMhxXFtsd56KZsSLQZQwV1UHhNavn69M/i1x6NDooci4O0vrH2nCp6vu+Yd4XszjDS5QHy0t9s1YsCeN+oCxbeUTevA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544625; c=relaxed/simple;
	bh=3JaQBIrFIbtChjC3pyLRwcWB1xL4UUd0CQGPYZnrD7o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G9MEtW891jDzmlUzgxxs7Y4d+BnuQdOUJkmxYujMhy+Ip0yrpa+QIqSteFCc9w+v59dYeKXZPI3AwtDZS4T0m66xg0IF27IsAlvB5fl8CIs92NXGoGh/L0WokvLPLBY6IsSOyL7Yy48UZOgjfRIrMTowv1kUgaem2SjdH3DXpZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfunYst7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440E9C4CEF7;
	Thu, 19 Feb 2026 23:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544625;
	bh=3JaQBIrFIbtChjC3pyLRwcWB1xL4UUd0CQGPYZnrD7o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MfunYst767AD2snkFv7vZnR5yc/FwAijK6Su21/gYviz/kRCuk7NJ9da2czJs9kcD
	 V3RoPjuuyuQfYKcRm0EPjJOXG0jSVSXF4BznY/BulmtWd7d28Eqmrn/m7E5lv5ECeL
	 +jH8VoL34G2vglBhO3H3Q7pjRfDSiLrnl37KqRyC+l9n+5bBfQ7jHoZKvSyNME+YbT
	 FFccaN37lbHPSeoTu4weFjzdstiEN1vZ0CCzhcbMX4D6o+y3tep6rIjQgcVVHVgTiU
	 l0DqAS+CmI09U6QobOGIHQd/sRYPFmAp3PTw+hlHxsEDnGhelG/SqNYLpurL4b7EYc
	 Egy4q/DfGloig==
Date: Thu, 19 Feb 2026 15:43:44 -0800
Subject: [PATCH 01/12] xfs: error tag to force zeroing on debug kernels
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: bfoster@redhat.com, brauner@kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177154456747.1285810.6219232325635808732.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31131-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 60D1C163ACD
X-Rspamd-Action: no action

From: Brian Foster <bfoster@redhat.com>

Source kernel commit: 66d78a11479cfea00e8d1d9d3e33f3db1597e6bf

iomap_zero_range() has to cover various corner cases that are
difficult to test on production kernels because it is used in fairly
limited use cases. For example, it is currently only used by XFS and
mostly only in partial block zeroing cases.

While it's possible to test most of these functional cases, we can
provide more robust test coverage by co-opting fallocate zero range
to invoke zeroing of the entire range instead of the more efficient
block punch/allocate sequence. Add an errortag to occasionally
invoke forced zeroing.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 libxfs/xfs_errortag.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index de840abc0bcd44..57e47077c75a2a 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -73,7 +73,8 @@
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
-#define XFS_ERRTAG_MAX					46
+#define XFS_ERRTAG_FORCE_ZERO_RANGE			46
+#define XFS_ERRTAG_MAX					47
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -133,7 +134,8 @@ XFS_ERRTAG(ATTR_LEAF_TO_NODE,	attr_leaf_to_node,	1) \
 XFS_ERRTAG(WB_DELAY_MS,		wb_delay_ms,		3000) \
 XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
 XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
-XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4)
+XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
+XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4)
 #endif /* XFS_ERRTAG */
 
 #endif /* __XFS_ERRORTAG_H_ */


