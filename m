Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E1D1BE50D
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Apr 2020 19:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgD2RWE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Apr 2020 13:22:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55581 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726776AbgD2RWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxmH4cVR+sKcJw3yPvmBISyMtv+aeVbzmxsQ4uTtU2c=;
        b=dBXe3tKED+yQy+a5xqpenKrp6cYSOzcSjYQ19D2EY8in6SCHAkrr7CBsfacb9Z1cJ+t+be
        fuoliGUMJm0Vr1CQ+B8ZLjz1wEQfIHxWP7F96fdvaacgU2QZzVAUGshhjNgPAzOhJcVSEL
        tyckHH8FhoDO0aqXleajnu4mTWIxW58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-Sy48V5cQOh20dcQ7BiGtzg-1; Wed, 29 Apr 2020 13:22:01 -0400
X-MC-Unique: Sy48V5cQOh20dcQ7BiGtzg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C0031083E80
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:00 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 286865C1BE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 11/17] xfs: use delete helper for items expected to be in AIL
Date:   Wed, 29 Apr 2020 13:21:47 -0400
Message-Id: <20200429172153.41680-12-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Various intent log items call xfs_trans_ail_remove() with a log I/O
error shutdown type, but this helper historically checks whether an
item is in the AIL before calling xfs_trans_ail_delete(). This means
the shutdown check is essentially a no-op for users of
xfs_trans_ail_remove().

It is possible that some items might not be AIL resident when the
AIL remove attempt occurs, but this should be isolated to cases
where the filesystem has already shutdown. For example, this
includes abort of the transaction committing the intent and I/O
error of the iclog buffer committing the intent to the log.
Therefore, update these callsites to use xfs_trans_ail_delete() to
provide AIL state validation for the common path of items being
released and removed when associated done items commit to the
physical log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ee6f4229cebc..909221a4a8ab 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -51,7 +51,7 @@ xfs_bui_release(
 {
 	ASSERT(atomic_read(&buip->bui_refcount) > 0);
 	if (atomic_dec_and_test(&buip->bui_refcount)) {
-		xfs_trans_ail_remove(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_bui_item_free(buip);
 	}
 }
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6ea847f6e298..cd98eba24884 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -55,7 +55,7 @@ xfs_efi_release(
 {
 	ASSERT(atomic_read(&efip->efi_refcount) > 0);
 	if (atomic_dec_and_test(&efip->efi_refcount)) {
-		xfs_trans_ail_remove(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
 	}
 }
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8eeed73928cd..712939a015a9 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -50,7 +50,7 @@ xfs_cui_release(
 {
 	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
 	if (atomic_dec_and_test(&cuip->cui_refcount)) {
-		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_cui_item_free(cuip);
 	}
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4911b68f95dd..ff949b32c051 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -50,7 +50,7 @@ xfs_rui_release(
 {
 	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
 	if (atomic_dec_and_test(&ruip->rui_refcount)) {
-		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_rui_item_free(ruip);
 	}
 }
--=20
2.21.1

