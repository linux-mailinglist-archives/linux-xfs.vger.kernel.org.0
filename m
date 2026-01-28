Return-Path: <linux-xfs+bounces-30413-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sFbLAJyReWmOxgEAu9opvQ
	(envelope-from <linux-xfs+bounces-30413-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 05:33:32 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B939CFF6
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 05:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5B8A4301A291
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 04:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984EC22156B;
	Wed, 28 Jan 2026 04:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ka/+pP2T"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91928C8CE
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 04:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769574808; cv=none; b=GqL+gUSswrHJnamdmEcOY6xlt6KQx/Dip8dpS9VNi5RGniFsaBLqwZMOrSMth3dFqm4vSTaQlZirvQKTpax6U0KSVCBo/o/Em4BgdCSImy5iwdIRgCKqZAmLk83HiHSUpdPwOI11hlL3LioF3wneYZY3nXiEi3wMxJTp778uLG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769574808; c=relaxed/simple;
	bh=CtcYMpCIEgo4q1rWHcez0dqMkLYHGWe2A3pL+hLcF1w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GQd47ApycEWffu2skdgD774vqqifRGhHRg5Oh9LvNu4NuZPdlYE9wLcNDeSQ7v8uM7cNJKb9S8geQUGwWVCPAUNmLM6xNzcm2drozpHJkJfALZzbD0feMQPvDDklvtdIgacjHpbGoUDhcZ8RFSa0zdjBWTbFnb+9DX4g6eNtybc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ka/+pP2T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=BXr7VM0AdRqSDWxSo7OLOLgfQ2WdUnRXocaSW9sVbIo=; b=ka/+pP2TiBpuoameG1Ze865/Ru
	fSI6nJSqp1JYBHiFk70BsFUisB5Net+zT4i/y8hUmH75gClZ4ItmK9lkULQ28AdCcnrjMbL1OdSRg
	PEhoege6vw4SDthDIvl9h8DcJ6LnspWSf67e/njlC6b7WdbGJaKNMF+ULgmbcbeXcMgn69veGOryZ
	wnNUiLwP/TsyFvBxoIqhR1K7QobYOWdrsny4a/PeVgSujiHiXG+noc+GPK0qVDwMiPOH9VRavNHfU
	ITQVZAt+yd5786egh5SdkmBvroVNqO0GFfoH1/F59JXol16ICpeeL3MXVEAhggS65MtSQEXz/y8f4
	9lyt0VuA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkxF4-0000000FQab-2SjI;
	Wed, 28 Jan 2026 04:33:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: enable cached zone report v5
Date: Wed, 28 Jan 2026 05:32:54 +0100
Message-ID: <20260128043318.522432-1-hch@lst.de>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-30413-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lst.de:mid]
X-Rspamd-Queue-Id: 70B939CFF6
X-Rspamd-Action: no action

Enable cached zone report to speed up mkfs and repair on a zoned block
device (e.g. an SMR disk). Cached zone report support was introduced in
the kernel with version 6.19-rc1.

Note: I've taken this series over from Damien as he's busy and it need
it as a base for further work.

Changes from v4:
 - include blkzoned.h from platform_defs.h and add the missing bits
   there to avoid problems with newer kernel headers

Changes from v3:
 - reorder includes to not need the forward declaration in xfs_zones.h
 - use the libfrog/ for #include statements
 - fix the include guard in libfrog/zones.h
 - fix up i18n string mess
 - hide the new ioctl definition in libfrog/zones.c
 - don't add userspace includes to libxfs/xfs_zones.h
 - reuse the buffer for multiple report zone calls

Changes from v2:
 - Complete rework of the series to make the zone reporting code common
   in libfrog
 - Added patch 1 and 2 as small cleanups/improvements.

Changes from v1:
 - Fix erroneous handling of ioctl(BLKREPORTZONEV2) error to correctly
   fallback to the regular ioctl(BLKREPORTZONE) if the kernel does not
   support BLKREPORTZONEV2.



