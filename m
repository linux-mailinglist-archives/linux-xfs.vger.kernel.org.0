Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9DBFCF2C
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Nov 2019 21:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNUKE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 Nov 2019 15:10:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31349 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726444AbfKNUKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 15:10:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573762201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rpR+VyAww3uplHbVHv9VbdvQjEOqgwBImLWli104X9Y=;
        b=SanCEQ6VrLGmyLMYqB4wg4loE/pIwVLjwQy3q65uoi2XkQkb8qKhrnGSBfP9h8vg9p2kYr
        xDkERrcqcR3PbU4h0LlDYUdlLEgSZxrlL1+Rc1dL4KMvmRoiihDTeudDwX7srcFt8mZXDW
        vI3ziar8KweLsRFwb8AWezI9GQQ5VxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-yrwm2fIVN1uzFjO5kWJwcQ-1; Thu, 14 Nov 2019 15:10:00 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88FA1805A60
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 20:09:59 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 471EC17F22
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 20:09:58 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: Remove slab init wrappers
Date:   Thu, 14 Nov 2019 21:09:52 +0100
Message-Id: <20191114200955.1365926-2-cmaiolino@redhat.com>
In-Reply-To: <20191114200955.1365926-1-cmaiolino@redhat.com>
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: yrwm2fIVN1uzFjO5kWJwcQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove kmem_zone_init() and kmem_zone_init_flags() together with their
specific KM_* to SLAB_* flag wrappers.

Use kmem_cache_create() directly.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.h      | 18 ---------
 fs/xfs/xfs_buf.c   |  5 ++-
 fs/xfs/xfs_dquot.c | 10 +++--
 fs/xfs/xfs_super.c | 99 +++++++++++++++++++++++++++-------------------
 4 files changed, 68 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 8170d95cf930..15c5800128b3 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -78,27 +78,9 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
  * Zone interfaces
  */
=20
-#define KM_ZONE_HWALIGN=09SLAB_HWCACHE_ALIGN
-#define KM_ZONE_RECLAIM=09SLAB_RECLAIM_ACCOUNT
-#define KM_ZONE_SPREAD=09SLAB_MEM_SPREAD
-#define KM_ZONE_ACCOUNT=09SLAB_ACCOUNT
-
 #define kmem_zone=09kmem_cache
 #define kmem_zone_t=09struct kmem_cache
=20
-static inline kmem_zone_t *
-kmem_zone_init(int size, char *zone_name)
-{
-=09return kmem_cache_create(zone_name, size, 0, 0, NULL);
-}
-
-static inline kmem_zone_t *
-kmem_zone_init_flags(int size, char *zone_name, slab_flags_t flags,
-=09=09     void (*construct)(void *))
-{
-=09return kmem_cache_create(zone_name, size, 0, flags, construct);
-}
-
 static inline void
 kmem_zone_free(kmem_zone_t *zone, void *ptr)
 {
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2ed3c65c602f..3741f5b369de 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2060,8 +2060,9 @@ xfs_buf_delwri_pushbuf(
 int __init
 xfs_buf_init(void)
 {
-=09xfs_buf_zone =3D kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
-=09=09=09=09=09=09KM_ZONE_HWALIGN, NULL);
+=09xfs_buf_zone =3D kmem_cache_create("xfs_buf",
+=09=09=09=09=09 sizeof(struct xfs_buf), 0,
+=09=09=09=09=09 SLAB_HWCACHE_ALIGN, NULL);
 =09if (!xfs_buf_zone)
 =09=09goto out;
=20
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bcd4247b5014..90dd1623de5a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1211,13 +1211,15 @@ xfs_dqlock2(
 int __init
 xfs_qm_init(void)
 {
-=09xfs_qm_dqzone =3D
-=09=09kmem_zone_init(sizeof(struct xfs_dquot), "xfs_dquot");
+=09xfs_qm_dqzone =3D kmem_cache_create("xfs_dquot",
+=09=09=09=09=09  sizeof(struct xfs_dquot),
+=09=09=09=09=09  0, 0, NULL);
 =09if (!xfs_qm_dqzone)
 =09=09goto out;
=20
-=09xfs_qm_dqtrxzone =3D
-=09=09kmem_zone_init(sizeof(struct xfs_dquot_acct), "xfs_dqtrx");
+=09xfs_qm_dqtrxzone =3D kmem_cache_create("xfs_dqtrx",
+=09=09=09=09=09     sizeof(struct xfs_dquot_acct),
+=09=09=09=09=09     0, 0, NULL);
 =09if (!xfs_qm_dqtrxzone)
 =09=09goto out_free_dqzone;
=20
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7f1fc76376f5..d3c3f7b5bdcf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1797,32 +1797,39 @@ MODULE_ALIAS_FS("xfs");
 STATIC int __init
 xfs_init_zones(void)
 {
-=09xfs_log_ticket_zone =3D kmem_zone_init(sizeof(xlog_ticket_t),
-=09=09=09=09=09=09"xfs_log_ticket");
+=09xfs_log_ticket_zone =3D kmem_cache_create("xfs_log_ticket",
+=09=09=09=09=09=09sizeof(struct xlog_ticket),
+=09=09=09=09=09=090, 0, NULL);
 =09if (!xfs_log_ticket_zone)
 =09=09goto out;
=20
-=09xfs_bmap_free_item_zone =3D kmem_zone_init(
-=09=09=09sizeof(struct xfs_extent_free_item),
-=09=09=09"xfs_bmap_free_item");
+=09xfs_bmap_free_item_zone =3D kmem_cache_create("xfs_bmap_free_item",
+=09=09=09=09=09sizeof(struct xfs_extent_free_item),
+=09=09=09=09=090, 0, NULL);
 =09if (!xfs_bmap_free_item_zone)
 =09=09goto out_destroy_log_ticket_zone;
=20
-=09xfs_btree_cur_zone =3D kmem_zone_init(sizeof(xfs_btree_cur_t),
-=09=09=09=09=09=09"xfs_btree_cur");
+=09xfs_btree_cur_zone =3D kmem_cache_create("xfs_btree_cur",
+=09=09=09=09=09       sizeof(struct xfs_btree_cur),
+=09=09=09=09=09       0, 0, NULL);
 =09if (!xfs_btree_cur_zone)
 =09=09goto out_destroy_bmap_free_item_zone;
=20
-=09xfs_da_state_zone =3D kmem_zone_init(sizeof(xfs_da_state_t),
-=09=09=09=09=09=09"xfs_da_state");
+=09xfs_da_state_zone =3D kmem_cache_create("xfs_da_state",
+=09=09=09=09=09      sizeof(struct xfs_da_state),
+=09=09=09=09=09      0, 0, NULL);
 =09if (!xfs_da_state_zone)
 =09=09goto out_destroy_btree_cur_zone;
=20
-=09xfs_ifork_zone =3D kmem_zone_init(sizeof(struct xfs_ifork), "xfs_ifork"=
);
+=09xfs_ifork_zone =3D kmem_cache_create("xfs_ifork",
+=09=09=09=09=09   sizeof(struct xfs_ifork),
+=09=09=09=09=09   0, 0, NULL);
 =09if (!xfs_ifork_zone)
 =09=09goto out_destroy_da_state_zone;
=20
-=09xfs_trans_zone =3D kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
+=09xfs_trans_zone =3D kmem_cache_create("xf_trans",
+=09=09=09=09=09   sizeof(struct xfs_trans),
+=09=09=09=09=09   0, 0, NULL);
 =09if (!xfs_trans_zone)
 =09=09goto out_destroy_ifork_zone;
=20
@@ -1832,70 +1839,82 @@ xfs_init_zones(void)
 =09 * size possible under XFS.  This wastes a little bit of memory,
 =09 * but it is much faster.
 =09 */
-=09xfs_buf_item_zone =3D kmem_zone_init(sizeof(struct xfs_buf_log_item),
-=09=09=09=09=09   "xfs_buf_item");
+=09xfs_buf_item_zone =3D kmem_cache_create("xfs_buf_item",
+=09=09=09=09=09      sizeof(struct xfs_buf_log_item),
+=09=09=09=09=09      0, 0, NULL);
 =09if (!xfs_buf_item_zone)
 =09=09goto out_destroy_trans_zone;
=20
-=09xfs_efd_zone =3D kmem_zone_init((sizeof(xfs_efd_log_item_t) +
-=09=09=09((XFS_EFD_MAX_FAST_EXTENTS - 1) *
-=09=09=09=09 sizeof(xfs_extent_t))), "xfs_efd_item");
+=09xfs_efd_zone =3D kmem_cache_create("xfs_efd_item",
+=09=09=09=09=09(sizeof(struct xfs_efd_log_item) +
+=09=09=09=09=09(XFS_EFD_MAX_FAST_EXTENTS - 1) *
+=09=09=09=09=09sizeof(struct xfs_extent)),
+=09=09=09=09=090, 0, NULL);
 =09if (!xfs_efd_zone)
 =09=09goto out_destroy_buf_item_zone;
=20
-=09xfs_efi_zone =3D kmem_zone_init((sizeof(xfs_efi_log_item_t) +
-=09=09=09((XFS_EFI_MAX_FAST_EXTENTS - 1) *
-=09=09=09=09sizeof(xfs_extent_t))), "xfs_efi_item");
+=09xfs_efi_zone =3D kmem_cache_create("xfs_efi_item",
+=09=09=09=09=09 (sizeof(struct xfs_efi_log_item) +
+=09=09=09=09=09 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
+=09=09=09=09=09 sizeof(struct xfs_extent)),
+=09=09=09=09=09 0, 0, NULL);
 =09if (!xfs_efi_zone)
 =09=09goto out_destroy_efd_zone;
=20
-=09xfs_inode_zone =3D
-=09=09kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
-=09=09=09KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD |
-=09=09=09KM_ZONE_ACCOUNT, xfs_fs_inode_init_once);
+=09xfs_inode_zone =3D kmem_cache_create("xfs_inode",
+=09=09=09=09=09   sizeof(struct xfs_inode), 0,
+=09=09=09=09=09   (SLAB_HWCACHE_ALIGN |
+=09=09=09=09=09    SLAB_RECLAIM_ACCOUNT |
+=09=09=09=09=09    SLAB_MEM_SPREAD | SLAB_ACCOUNT),
+=09=09=09=09=09   xfs_fs_inode_init_once);
 =09if (!xfs_inode_zone)
 =09=09goto out_destroy_efi_zone;
=20
-=09xfs_ili_zone =3D
-=09=09kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
-=09=09=09=09=09KM_ZONE_SPREAD, NULL);
+=09xfs_ili_zone =3D kmem_cache_create("xfs_ili",
+=09=09=09=09=09 sizeof(struct xfs_inode_log_item), 0,
+=09=09=09=09=09 SLAB_MEM_SPREAD, NULL);
 =09if (!xfs_ili_zone)
 =09=09goto out_destroy_inode_zone;
-=09xfs_icreate_zone =3D kmem_zone_init(sizeof(struct xfs_icreate_item),
-=09=09=09=09=09"xfs_icr");
+
+=09xfs_icreate_zone =3D kmem_cache_create("xfs_icr",
+=09=09=09=09=09     sizeof(struct xfs_icreate_item),
+=09=09=09=09=09     0, 0, NULL);
 =09if (!xfs_icreate_zone)
 =09=09goto out_destroy_ili_zone;
=20
-=09xfs_rud_zone =3D kmem_zone_init(sizeof(struct xfs_rud_log_item),
-=09=09=09"xfs_rud_item");
+=09xfs_rud_zone =3D kmem_cache_create("xfs_rud_item",
+=09=09=09=09=09 sizeof(struct xfs_rud_log_item),
+=09=09=09=09=09 0, 0, NULL);
 =09if (!xfs_rud_zone)
 =09=09goto out_destroy_icreate_zone;
=20
-=09xfs_rui_zone =3D kmem_zone_init(
+=09xfs_rui_zone =3D kmem_cache_create("xfs_rui_item",
 =09=09=09xfs_rui_log_item_sizeof(XFS_RUI_MAX_FAST_EXTENTS),
-=09=09=09"xfs_rui_item");
+=09=09=090, 0, NULL);
 =09if (!xfs_rui_zone)
 =09=09goto out_destroy_rud_zone;
=20
-=09xfs_cud_zone =3D kmem_zone_init(sizeof(struct xfs_cud_log_item),
-=09=09=09"xfs_cud_item");
+=09xfs_cud_zone =3D kmem_cache_create("xfs_cud_item",
+=09=09=09=09=09 sizeof(struct xfs_cud_log_item),
+=09=09=09=09=09 0, 0, NULL);
 =09if (!xfs_cud_zone)
 =09=09goto out_destroy_rui_zone;
=20
-=09xfs_cui_zone =3D kmem_zone_init(
+=09xfs_cui_zone =3D kmem_cache_create("xfs_cui_item",
 =09=09=09xfs_cui_log_item_sizeof(XFS_CUI_MAX_FAST_EXTENTS),
-=09=09=09"xfs_cui_item");
+=09=09=090, 0, NULL);
 =09if (!xfs_cui_zone)
 =09=09goto out_destroy_cud_zone;
=20
-=09xfs_bud_zone =3D kmem_zone_init(sizeof(struct xfs_bud_log_item),
-=09=09=09"xfs_bud_item");
+=09xfs_bud_zone =3D kmem_cache_create("xfs_bud_item",
+=09=09=09=09=09 sizeof(struct xfs_bud_log_item),
+=09=09=09=09=09 0, 0, NULL);
 =09if (!xfs_bud_zone)
 =09=09goto out_destroy_cui_zone;
=20
-=09xfs_bui_zone =3D kmem_zone_init(
+=09xfs_bui_zone =3D kmem_cache_create("xfs_bui_item",
 =09=09=09xfs_bui_log_item_sizeof(XFS_BUI_MAX_FAST_EXTENTS),
-=09=09=09"xfs_bui_item");
+=09=09=090, 0, NULL);
 =09if (!xfs_bui_zone)
 =09=09goto out_destroy_bud_zone;
=20
--=20
2.23.0

