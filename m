Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC8107F2B
	for <lists+linux-xfs@lfdr.de>; Sat, 23 Nov 2019 16:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfKWPzP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 23 Nov 2019 10:55:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51438 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726638AbfKWPzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Nov 2019 10:55:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574524514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=clONc5ffeJpCqgFX0EMI3i14IdrW9eg7+/UJx5M4OOI=;
        b=Grm8qWiESf4eUkdY9ep+GG7JtNvIAlLwbOsWaYFS2mJ0AIQHkzrIawRTuDoKKP7F1S7A51
        Z92Fg1wpRtqVa9/YtddmtR3UHezpI9+KysJ05TP1OQfnFwQBNYpfeF6V/ODAluZDqSOoNe
        BdjAyo1R80eVtKVmW05zO3IFM1ayBio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-Rlbx8jWOOkKO11IhruMYEg-1; Sat, 23 Nov 2019 10:55:12 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1AF6107B26F
        for <linux-xfs@vger.kernel.org>; Sat, 23 Nov 2019 15:55:11 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-120-110.rdu2.redhat.com [10.10.120.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BE5E60850;
        Sat, 23 Nov 2019 15:55:11 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     esandeen@redhat.com
Cc:     preichl@redhat.com, linux-xfs@vger.kernel.org,
        John Pittman <jpittman@redhat.com>
Subject: [PATCH v3] xfsprogs: add missing line feeds in libxfs/rdwr.c
Date:   Sat, 23 Nov 2019 10:55:08 -0500
Message-Id: <20191123155508.15769-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Rlbx8jWOOkKO11IhruMYEg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In libxfs/rdwr.c, there are several fprintf() calls that are
missing trailing line feeds. This translates to the following
CLI prompt being on the same line as the message. Add missing
line feeds, alleviating the issue.

Fixes: 0a7942b38215 ("libxfs: don't discard dirty buffers")
Signed-off-by: John Pittman <jpittman@redhat.com>
---
 libxfs/rdwr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7080cd9c..3f69192d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -651,7 +651,7 @@ __libxfs_getbufr(int blen)
 =09pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
 =09bp->b_ops =3D NULL;
 =09if (bp->b_flags & LIBXFS_B_DIRTY)
-=09=09fprintf(stderr, "found dirty buffer (bulk) on free list!");
+=09=09fprintf(stderr, "found dirty buffer (bulk) on free list!\n");
=20
 =09return bp;
 }
@@ -1224,7 +1224,7 @@ libxfs_brelse(
 =09=09return;
 =09if (bp->b_flags & LIBXFS_B_DIRTY)
 =09=09fprintf(stderr,
-=09=09=09"releasing dirty buffer to free list!");
+=09=09=09"releasing dirty buffer to free list!\n");
=20
 =09pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
 =09list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
@@ -1245,7 +1245,7 @@ libxfs_bulkrelse(
 =09list_for_each_entry(bp, list, b_node.cn_mru) {
 =09=09if (bp->b_flags & LIBXFS_B_DIRTY)
 =09=09=09fprintf(stderr,
-=09=09=09=09"releasing dirty buffer (bulk) to free list!");
+=09=09=09=09"releasing dirty buffer (bulk) to free list!\n");
 =09=09count++;
 =09}
=20
--=20
2.17.2

