Return-Path: <linux-xfs+bounces-11889-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF6795B92F
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2024 16:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5F85B26D9A
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2024 14:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582221CC17B;
	Thu, 22 Aug 2024 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XmtHoMfo"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6379B1CC178
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 14:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724338702; cv=none; b=N1vQV0Nt4OfTTCuTZUk7CBiKK9xvtzBnWDdGNPFPnwjPLByLHY/3wmxieKpcuCTBkKXopysAWrp7PR1x8lU8HjiviyOkeHFXYHD2+kdRwRqiwkj/vgqhiXljGvTzG8zwU0m2Rxy7HDixXGZ22juDGaQ2gVohjGWDeu8j9RlK4X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724338702; c=relaxed/simple;
	bh=E6/pHohiOwWz1LLCF0Rh134Av/JRwWDiOi+lUZb6zYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=U8B1Z1mFAMo9JJWIjLbCrS3WyGeyfsraiFbC1S/yhhYnaODbcfOqUoFPAmdZzI8EusKtwy387vqmSKsdDZgd0frhSVyG3x55qZ8Vtue+OHe2bMHxqXfKZa2NGni4wrFytDGUN9NPxbrGiexxJqrL/5pC2ve09sX9BlIiNyl5k+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XmtHoMfo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724338699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L0ItGqJc+pE5VVBZpro+zT6jGmAybdoIjBREv6SAiFM=;
	b=XmtHoMfoWZ25+AieF3F4reA4hOYNQ/7SbboDID3LB874AOamH1IuWw9OsMGI5Jy0dm7pJ2
	+hmYXN6BfYA/EkGC0xmzoVdLNjawr44xO2wvrZcq/vdmjR/WJ9dgFl0fRrQvtbpbVs2Zt0
	WHcisiJi8gwXg9NzfRLDn24kEdGL3aw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-WxrO2GseN0-pj5a6ALcqwg-1; Thu,
 22 Aug 2024 10:58:15 -0400
X-MC-Unique: WxrO2GseN0-pj5a6ALcqwg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0A0C1955F3B;
	Thu, 22 Aug 2024 14:58:13 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.33.147])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B57E63002242;
	Thu, 22 Aug 2024 14:58:12 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH 0/2] iomap: flush dirty cache over unwritten mappings on zero range
Date: Thu, 22 Aug 2024 10:59:08 -0400
Message-ID: <20240822145910.188974-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi all,

This is the alternative flushing solution to the iomap zero range
problem with dirty pagecache over unwritten mappings. This is done in
two steps. Patch 1 lifts the XFS workaround into iomap, flushing the
range unconditionally and providing an easily backportable fix for
stable kernels. Patch 2 buries the flush further down into iomap, making
it conditional on the combined presence of dirty cache and unwritten
mappings in the target range. This may be reasonable backportable as
well, but is only required if performance is a concern.

I still have to look into the improved revalidation approach discussed
in the RFC thread, but given that requires validation support and this
is intended to be a generic fallback, I wanted to get this nailed down
first.

fstests coverage for this problem is posted here [1]. Thoughts, reviews,
flames appreciated.

Brian

v1:
- Alternative approach, flush instead of revalidate.
rfc: https://lore.kernel.org/linux-fsdevel/20240718130212.23905-1-bfoster@redhat.com/

[1] https://lore.kernel.org/fstests/20240822144422.188462-1-bfoster@redhat.com/

Brian Foster (2):
  iomap: fix handling of dirty folios over unwritten extents
  iomap: make zero range flush conditional on unwritten mappings

 fs/iomap/buffered-io.c | 52 ++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_iops.c      | 10 --------
 2 files changed, 48 insertions(+), 14 deletions(-)

-- 
2.45.0


