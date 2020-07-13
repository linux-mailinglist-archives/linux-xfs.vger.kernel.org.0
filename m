Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A127B21B20E
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Jul 2020 11:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGJJPy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jul 2020 05:15:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28349 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726787AbgGJJPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 05:15:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594372552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWU56+udF9u682jgrbppgzTARZvHMZ3VmAYP7V10/ug=;
        b=Cxxan3FhYB4KetHA5wI9GoVOLXGrc0TWNgMbUhM3YACjDqLKKXbVbCBYyHAj8XSxaqUQrj
        LCqPDaIaLqu7w1F9/kAi3OlGCcX/iqDOAmXwdcLtLa3KzBIdgdExVRqF0U2Xje1DyPoK5X
        JAoHxslGEY2T4f6aWgdbdmx/KbjC1C8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-JvaSy4rHNSegw5wAN-P-pw-1; Fri, 10 Jul 2020 05:15:51 -0400
X-MC-Unique: JvaSy4rHNSegw5wAN-P-pw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41C36800FEB
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:50 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A6E95D9E5
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:49 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: remove xfs_zone_{alloc,zalloc} helpers
Date:   Fri, 10 Jul 2020 11:15:35 +0200
Message-Id: <20200710091536.95828-5-cmaiolino@redhat.com>
In-Reply-To: <20200710091536.95828-1-cmaiolino@redhat.com>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All their users have been converted to use MM API directly, no need to
keep them around anymore.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.c      | 21 ---------------------
 fs/xfs/kmem.h      |  8 --------
 fs/xfs/xfs_trace.h |  1 -
 3 files changed, 30 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index f1366475c389c..e841ed781a257 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -115,24 +115,3 @@ kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
-
-void *
-kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
-{
-	int	retries = 0;
-	gfp_t	lflags = kmem_flags_convert(flags);
-	void	*ptr;
-
-	trace_kmem_zone_alloc(kmem_cache_size(zone), flags, _RET_IP_);
-	do {
-		ptr = kmem_cache_alloc(zone, lflags);
-		if (ptr || (flags & KM_MAYFAIL))
-			return ptr;
-		if (!(++retries % 100))
-			xfs_err(NULL,
-		"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
-				current->comm, current->pid,
-				__func__, lflags);
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
-	} while (1);
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 34cbcfde92281..8e8555817e6d3 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -85,14 +85,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 #define kmem_zone	kmem_cache
 #define kmem_zone_t	struct kmem_cache
 
-extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
-
-static inline void *
-kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
-{
-	return kmem_zone_alloc(zone, flags | KM_ZERO);
-}
-
 static inline struct page *
 kmem_to_page(void *addr)
 {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 460136628a795..d8f5f3d99bb8f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3582,7 +3582,6 @@ DEFINE_KMEM_EVENT(kmem_alloc);
 DEFINE_KMEM_EVENT(kmem_alloc_io);
 DEFINE_KMEM_EVENT(kmem_alloc_large);
 DEFINE_KMEM_EVENT(kmem_realloc);
-DEFINE_KMEM_EVENT(kmem_zone_alloc);
 
 TRACE_EVENT(xfs_check_new_dalign,
 	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
-- 
2.26.2

