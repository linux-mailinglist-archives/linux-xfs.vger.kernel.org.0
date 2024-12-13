Return-Path: <linux-xfs+bounces-16838-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EFA09F1043
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 16:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43A4118827BC
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 15:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB69A1E2307;
	Fri, 13 Dec 2024 15:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QlgNnXf8"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A201DF73B
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734102227; cv=none; b=mnzQwlp0UOMpPQf282GPuWtQU9mGqaKY8G9nIaL575+np1MtSa11ZhPk3zPNGGOSj5GaMn7MFFfXVIriKSF92k9zL9rwdF27GTfhfbWfGpm97cIAT0acP5wBiGVYQ/UDgp+wEFJMDOL/F5ZK7fgWbs5I3breYwqieo3DndaAIqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734102227; c=relaxed/simple;
	bh=wO8MsH8wW8HeO5rEWgH4hLiGH9SlcLU8tkBsSy0Ewwo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mRz0PU9S0tGGSTFc9SxlhDXguaCKymujQ6h2d3qFd67vGVKqZvEwJjaWUw/6weMnUj1f4+lUg3hWgW74RV3XOrivMefRoObDv6EELY3fmFcgcOQxXUpTgB+EwMYCv/YHjd7XCrlD54C1b4sb9hn3m7l0q9j2aenM83tDs9QTkH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QlgNnXf8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734102224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AMFKCNoILSyERHx67uxUGjkl1noKKgcNWkzVsHJ2FZY=;
	b=QlgNnXf8syJQMCyz8L1g45LdBVh6psmCiIQKGAhogwbe/+EXDcen0ftlnPGwZZ46JLOWr9
	+RjA5nd5HcMS8zbh0wlgOeMQ4Gq4jMJocwguk5Zo5LvWS6w8bb43Gxk+EtWe5qVFkmlbM7
	WP65ZO71KekdiViU633CGmm1+elrR7s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-lhoj4b33NSCFGVhwom6_hw-1; Fri,
 13 Dec 2024 10:03:42 -0500
X-MC-Unique: lhoj4b33NSCFGVhwom6_hw-1
X-Mimecast-MFC-AGG-ID: lhoj4b33NSCFGVhwom6_hw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC5DB195608C;
	Fri, 13 Dec 2024 15:03:41 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.90.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 242FA195394B;
	Fri, 13 Dec 2024 15:03:41 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH RFCv2 0/4] iomap: zero range folio batch processing prototype
Date: Fri, 13 Dec 2024 10:05:24 -0500
Message-ID: <20241213150528.1003662-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi all,

This is an update of the folio_batch prototype for zero range. The idea
here is first to provide a mechanism to correctly handle dirty folios
over unwritten extents on zero range without needing to flush, and
second to add it in a way such that it can be extended to other
operations in the future. For example, seek data over unwritten extents
could use similar treatment as zero range, and multiple people have
brought up the idea of using this for buffered writes in the future.

The primary change in RFCv2 is this is now ported on top of the
incremental iter advance patches, which eliminates the need for patch 1
in RFCv1 and allows plumbing into the normal folio get path.

This is still a WIP and I'm posting mainly as a reference for the
incremental advance patches. Patch 1 is a squash of 7 or 8 prep patches
that aren't all that interesting, patch 2 implements batch support,
patch 3 is a prep patch for XFS, and patch 4 updates XFS to use the iter
batch on zero range.

Thoughts, reviews, flames appreciated.

Brian

RFCv2:
- Port onto incremental advance, drop patch 1 from RFCv1.
- Moved batch into iomap_iter, dynamically allocate and drop flag.
- Tweak XFS patch to always trim zero range on EOF boundary.
RFCv1: https://lore.kernel.org/linux-fsdevel/20241119154656.774395-1-bfoster@redhat.com/

Brian Foster (4):
  iomap: prep work for folio_batch support
  iomap: optional zero range dirty folio processing
  xfs: always trim mapping to requested range for zero range
  xfs: fill dirty folios on zero range of unwritten mappings

 fs/iomap/buffered-io.c | 177 ++++++++++++++++++++++++++++++-----------
 fs/iomap/iter.c        |   6 ++
 fs/xfs/xfs_iomap.c     |  25 ++++--
 include/linux/iomap.h  |   4 +
 4 files changed, 158 insertions(+), 54 deletions(-)

-- 
2.47.0


