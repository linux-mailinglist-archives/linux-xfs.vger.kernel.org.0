Return-Path: <linux-xfs+bounces-12412-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4231D962FB4
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Aug 2024 20:19:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDDDA283BD6
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Aug 2024 18:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96621AB519;
	Wed, 28 Aug 2024 18:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UiI7loO/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2141F1A7079
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 18:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724869102; cv=none; b=Kzc1WFnW02qeWHR8OogsrK/Ji8+IdXg3ZiHaK4pUp8ImEL11+icdowvJ+uUA9ouCPqnKnr1qYgPsbOxlimH1qZ0hh624I+t9xdIM4Q3+nXcrTCzwk14bBjP+SPsiI7Qz1xm2AHgWqwDZtQXz5TSwK1RxJ0TK6bx36rje2YgTRfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724869102; c=relaxed/simple;
	bh=IeazIBGYpuUDh7Te/VSg+ghSsutqtSc1DKErMdDc63A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i39NSycXCVuL2dcdT891zbDoWzDlEvaUf4YKsDJm4uodFKgONdBxF+6T/vYTFgVVCxVxy3yOcU0qpz0xQl+W0/FdsM+psJiKwwrDFB4UdHmlSTlWSSRt/UhRRzoBXV4G7AXRh5NcGQTsGRTJ1741jiIbcqhLyiNkJwEsZzAFjqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UiI7loO/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724869100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9LyocZQC5A09fP9vV6QdhkMyKaOf18t29tIGKLlrz0Y=;
	b=UiI7loO/Aa1ICLTsTpQTKrCfz2wRdd6QyXhrIqRARCmqNEDJZQ4IdNtt+tuLa3w88UzUqz
	vQNYJ4GbkQx1ozjEvAZzKtVkcGkBzNYiNMi0z245nHAjETy43DNGB1D6Tc2SmAH8lF9Cms
	6Stcmr0aSJ4PyOwfG5YGvNbiszuSsxI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-434-Wr66Bt9FOTWwaGYR9VrBhQ-1; Wed,
 28 Aug 2024 14:18:15 -0400
X-MC-Unique: Wr66Bt9FOTWwaGYR9VrBhQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 411BD1955D4A;
	Wed, 28 Aug 2024 18:18:13 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.95])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EBF601955D64;
	Wed, 28 Aug 2024 18:18:11 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH v2 1/2] iomap: fix handling of dirty folios over unwritten extents
Date: Wed, 28 Aug 2024 14:19:10 -0400
Message-ID: <20240828181912.41517-2-bfoster@redhat.com>
In-Reply-To: <20240828181912.41517-1-bfoster@redhat.com>
References: <20240828181912.41517-1-bfoster@redhat.com>
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


