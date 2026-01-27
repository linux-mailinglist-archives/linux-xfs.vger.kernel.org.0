Return-Path: <linux-xfs+bounces-30377-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHwRKtHieGkztwEAu9opvQ
	(envelope-from <linux-xfs+bounces-30377-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 17:07:45 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 425F69768D
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 17:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDDA1302C646
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 16:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8846835D611;
	Tue, 27 Jan 2026 16:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FuqO37ze"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3538635EDBA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769529987; cv=none; b=pk1M5YdfMmC7QpgYC5IIFs49XdF4vYKUDlvn6eaeiqyHBXMgA+ZGK6Y/m0BdAvlui60yGvQkFOV9pxMSt39fdHy0fzQcr0VpJr1+crgR2w+T6GU/MLwiN55QvGIrBxs/TAkEWzKngLtW8ORhcy8YozYA8S21Q1usFha52Kl/PhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769529987; c=relaxed/simple;
	bh=2XTXHx7b+zsT0ZiM1SZ8Uz2Jae12R+X6O3GMbiwGJ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T3XMfgoRq+y7mD/u8EkFdgBLeAFHk/Pdg998A8O7Dim5ane2gqAtSi4Ud+n0UNyn29QmgTiIWFsPcyB/zGEoPxnyxfpewy6i+Sxi00kyeT2WYgfupDW3OtNYuOpIAriSq+HH7J464HsR+Y05J4dQUIGeJ1G++VOUvfAAMQiRiQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FuqO37ze; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=XZsFl9jnUd0a6MUlNGIoq0KJkDJt29YBqFcpEJ6nJAM=; b=FuqO37zeuP1UrkkIhc5fJc+EVP
	YXHPiSxGSezTqxBKqzOimunGQyXqUIWdhyUihG8t8qThwqdP/57uL1f44DCwWM5yM57pYgdxxnWAa
	avi/fBd3W6D37x5N43cjK9UO91FdbJdJ0/omUazzI7C6ybK9jT9iXvhThxLnijRbv7VLAg0zMf6MU
	yuSQDgiiDqaFwmhqRMb36zRaFE6bkQACah3WHQClXxf2jXxOI3ygVsZJln5udoSKgdWm9qdO59kay
	CMjTsqqurOtSHLxCiUDKsRdD+N0xcv692KEsaUIegDRBrVEmx25rNV0tbpYYQtTfqEop8Suffvv3R
	oeAzyxAg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklaB-0000000EbjM-17w2;
	Tue, 27 Jan 2026 16:06:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: stats and error injection for zoned GC
Date: Tue, 27 Jan 2026 17:05:40 +0100
Message-ID: <20260127160619.330250-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30377-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lst.de:mid]
X-Rspamd-Queue-Id: 425F69768D
X-Rspamd-Action: no action

Hi all,

this series adds error injection for zoned resets and zoned GC stats.
My initial use is for a test case that verifies zone reset error
handling, but that stats should also be very useful for monitoring
tools like PCP and benchmarking.

As part of the error injection work I've also added a mount option to
enable error ibjection at mount time so that it can exercise the
mount code as well and cleaned up various other bits of the error
injection code.

Diffstat:
 Documentation/admin-guide/xfs.rst |    6 +
 fs/xfs/libxfs/xfs_errortag.h      |    8 +-
 fs/xfs/xfs_error.c                |  142 +++++++++++++++++++++-----------------
 fs/xfs/xfs_error.h                |   23 ++----
 fs/xfs/xfs_stats.c                |    7 +
 fs/xfs/xfs_stats.h                |    6 +
 fs/xfs/xfs_super.c                |   20 +++++
 fs/xfs/xfs_zone_gc.c              |   72 ++++++++++++-------
 8 files changed, 180 insertions(+), 104 deletions(-)

