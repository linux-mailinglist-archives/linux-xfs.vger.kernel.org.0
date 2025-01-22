Return-Path: <linux-xfs+bounces-18528-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69FAEA19294
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jan 2025 14:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43FAA3AB67A
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jan 2025 13:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE33213237;
	Wed, 22 Jan 2025 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjNOeLSZ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C5B43AA8
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737552748; cv=none; b=IukJOqTHE82n9TjKKsz1CzxuYmudi06uEMHvsgW/jJBQkU1TF8ZqCyxR9rDhiT+PB7+MQjrjWS9byQgr9Ged3uiX/SXOXnp0WsCAu8KLJoZeABFA2N+nATvlLHuwiY7xNxFF2pm5EFQxi+N3IwRrkJlNz1+QqfLy5zaiGrghtJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737552748; c=relaxed/simple;
	bh=/CcAGSXtCyzmWnS93ZOrskKZkHRoJXfInTSOetrZE0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iD57TVhxq3elOuS9POWOuluR1Xydv0+eg0bJvki/pqRVwWkVVMet9t9n/NUM4o+KKAJ1rAEC0PO9trsuIPzv9DkJBbG4IXRPa+i7h0pMG4g1OohDseWnXD4NuKicA5c5mFd0yCMQ0Kbt5P9JFWT4twzLWJwMr8r18uZJx4qJ0rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NjNOeLSZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737552746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l8+3EkgGdj8WgrbHVmLXjg2LfbG3NgNfTsmBRTx6Ry8=;
	b=NjNOeLSZK0KsZVsCpECuoEfh2aSIxVFaTFZ9kJtomImKKkL6NQ/TpzsiHioBFPJ1gL7fw6
	H5y1rv+kRJIG9cuYQQ50fegM3E+BZVAwSndXU6HPZMjUX4j11XXi1Hxh8a9Yp5bdfKmiUL
	cMHkDvZwqelhm1hUKb8J7iJkEYNG+38=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-YighNPpWOoKNiOYnBA5Pew-1; Wed,
 22 Jan 2025 08:32:23 -0500
X-MC-Unique: YighNPpWOoKNiOYnBA5Pew-1
X-Mimecast-MFC-AGG-ID: YighNPpWOoKNiOYnBA5Pew
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1669619560B8;
	Wed, 22 Jan 2025 13:32:22 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.118])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6F70D19560A7;
	Wed, 22 Jan 2025 13:32:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/7] iomap: split out iomap check and reset logic from iter advance
Date: Wed, 22 Jan 2025 08:34:28 -0500
Message-ID: <20250122133434.535192-2-bfoster@redhat.com>
In-Reply-To: <20250122133434.535192-1-bfoster@redhat.com>
References: <20250122133434.535192-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In preparation for more granular iomap_iter advancing, break out
some of the logic associated with higher level iteration from
iomap_advance_iter(). Specifically, factor the iomap reset code into
a separate helper and lift the iomap.length check into the calling
code, similar to how ->iomap_end() calls are handled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/iter.c | 49 ++++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 3790918646af..731ea7267f27 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -7,6 +7,13 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
+{
+	iter->processed = 0;
+	memset(&iter->iomap, 0, sizeof(iter->iomap));
+	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
+}
+
 /*
  * Advance to the next range we need to map.
  *
@@ -14,32 +21,24 @@
  * processed - it was aborted because the extent the iomap spanned may have been
  * changed during the operation. In this case, the iteration behaviour is to
  * remap the unprocessed range of the iter, and that means we may need to remap
- * even when we've made no progress (i.e. iter->processed = 0). Hence the
- * "finished iterating" case needs to distinguish between
- * (processed = 0) meaning we are done and (processed = 0 && stale) meaning we
- * need to remap the entire remaining range.
+ * even when we've made no progress (i.e. count = 0). Hence the "finished
+ * iterating" case needs to distinguish between (count = 0) meaning we are done
+ * and (count = 0 && stale) meaning we need to remap the entire remaining range.
  */
-static inline int iomap_iter_advance(struct iomap_iter *iter)
+static inline int iomap_iter_advance(struct iomap_iter *iter, s64 count)
 {
 	bool stale = iter->iomap.flags & IOMAP_F_STALE;
 	int ret = 1;
 
-	/* handle the previous iteration (if any) */
-	if (iter->iomap.length) {
-		if (iter->processed < 0)
-			return iter->processed;
-		if (WARN_ON_ONCE(iter->processed > iomap_length(iter)))
-			return -EIO;
-		iter->pos += iter->processed;
-		iter->len -= iter->processed;
-		if (!iter->len || (!iter->processed && !stale))
-			ret = 0;
-	}
+	if (count < 0)
+		return count;
+	if (WARN_ON_ONCE(count > iomap_length(iter)))
+		return -EIO;
+	iter->pos += count;
+	iter->len -= count;
+	if (!iter->len || (!count && !stale))
+		ret = 0;
 
-	/* clear the per iteration state */
-	iter->processed = 0;
-	memset(&iter->iomap, 0, sizeof(iter->iomap));
-	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
 	return ret;
 }
 
@@ -82,10 +81,14 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 			return ret;
 	}
 
+	/* advance and clear state from the previous iteration */
 	trace_iomap_iter(iter, ops, _RET_IP_);
-	ret = iomap_iter_advance(iter);
-	if (ret <= 0)
-		return ret;
+	if (iter->iomap.length) {
+		ret = iomap_iter_advance(iter, iter->processed);
+		iomap_iter_reset_iomap(iter);
+		if (ret <= 0)
+			return ret;
+	}
 
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
-- 
2.47.1


