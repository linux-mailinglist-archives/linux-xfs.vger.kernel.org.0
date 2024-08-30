Return-Path: <linux-xfs+bounces-12524-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4179664A4
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2024 16:55:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC8302867AD
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2024 14:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384FC1B2EDF;
	Fri, 30 Aug 2024 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FtEJeTBE"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D101B1D63
	for <linux-xfs@vger.kernel.org>; Fri, 30 Aug 2024 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725029741; cv=none; b=kvo1q6qbuX2kXk25OzS0il/E/cm28BLZbcyNZFxO3V9vM2n6U1AFTFk/iUQaNvQRQCv1cPEf5TMT3yEuQi9hukFP81fvEcS7XciSHGrvW2d0WdUZjj1MF5OUtkdz6Jl9dX6cK5hjZb7MhkngGrzlRwemZeICxJ3iUQ2UpDzWSvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725029741; c=relaxed/simple;
	bh=lxJy1bfkGH5MRwRSYqTpGuPGXjbV+1nU60UlSsZBork=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nRIuD6eOw67XLMGVsQ775/S0YJVQXnMS9Aexu7DD8mKZDMw2eWMghbG5cGpC+XQHTYDK8/T+giNVgRFAJfHcq09SfKW4exDMMy+ICdTD7BIDDTfFNrgAgq1SxnadOT0RN2Z4zR7fu9M3nEDjNfI+/9jEAUtHo5xabnxXRrnGB9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FtEJeTBE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725029738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yvlhxan2ye80ilpu4JKEu4xMzHk4erT0MRVQTz99B68=;
	b=FtEJeTBEKF6bxBlsibWnrhijrlRL5ydo8YlRF4dKcxAcGTIBAuKvCPIHgZucREUAoXpxjO
	mEHxqomllTz0XCsBedCqTECLqumLBV1QSr2nrAF8XJRQatRkMn1bcCSAyeLxrMzMWxy0aE
	E/XH8zweYP2T5xQovIagu//r0/L94yw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-KWka9FxGNOONcqHtcgibMA-1; Fri,
 30 Aug 2024 10:55:36 -0400
X-MC-Unique: KWka9FxGNOONcqHtcgibMA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E1961955BF2;
	Fri, 30 Aug 2024 14:55:35 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.95])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6C26819560AE;
	Fri, 30 Aug 2024 14:55:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH v3 1/2] iomap: fix handling of dirty folios over unwritten extents
Date: Fri, 30 Aug 2024 10:56:33 -0400
Message-ID: <20240830145634.138439-2-bfoster@redhat.com>
In-Reply-To: <20240830145634.138439-1-bfoster@redhat.com>
References: <20240830145634.138439-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The iomap zero range implementation doesn't properly handle dirty
pagecache over unwritten mappings. It skips such mappings as if they
were pre-zeroed. If some part of an unwritten mapping is dirty in
pagecache from a previous write, the data in cache should be zeroed
as well. Instead, the data is left in cache and creates a stale data
exposure problem if writeback occurs sometime after the zero range.

Most callers are unaffected by this because the higher level
filesystem contexts that call zero range typically perform a filemap
flush of the target range for other reasons. A couple contexts that
don't otherwise need to flush are write file size extension and
truncate in XFS. The former path is currently susceptible to the
stale data exposure problem and the latter performs a flush
specifically to work around it.

This is clearly inconsistent and incomplete. As a first step toward
correcting behavior, lift the XFS workaround to iomap_zero_range()
and unconditionally flush the range before the zero range operation
proceeds. While this appears to be a bit of a big hammer, most all
users already do this from calling context save for the couple of
exceptions noted above. Future patches will optimize or elide this
flush while maintaining functional correctness.

Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/iomap/buffered-io.c | 10 ++++++++++
 fs/xfs/xfs_iops.c      | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index f420c53d86ac..3e846f43ff48 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1451,6 +1451,16 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 	};
 	int ret;
 
+	/*
+	 * Zero range wants to skip pre-zeroed (i.e. unwritten) mappings, but
+	 * pagecache must be flushed to ensure stale data from previous
+	 * buffered writes is not exposed.
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping,
+			pos, pos + len - 1);
+	if (ret)
+		return ret;
+
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = iomap_zero_iter(&iter, did_zero);
 	return ret;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1cdc8034f54d..ddd3697e6ecd 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -870,16 +870,6 @@ xfs_setattr_size(
 		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
 				&did_zeroing);
 	} else {
-		/*
-		 * iomap won't detect a dirty page over an unwritten block (or a
-		 * cow block over a hole) and subsequently skips zeroing the
-		 * newly post-EOF portion of the page. Flush the new EOF to
-		 * convert the block before the pagecache truncate.
-		 */
-		error = filemap_write_and_wait_range(inode->i_mapping, newsize,
-						     newsize);
-		if (error)
-			return error;
 		error = xfs_truncate_page(ip, newsize, &did_zeroing);
 	}
 
-- 
2.45.0


