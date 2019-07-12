Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14706747E
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2019 19:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfGLRov (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Jul 2019 13:44:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbfGLRov (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 13:44:51 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 45AD2309B15B
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:44:51 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B46A15D756;
        Fri, 12 Jul 2019 17:44:48 +0000 (UTC)
Subject: [PATCH 1/2] xfs: move xfs_trans_inode.c to libxfs/
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <eb65b33a-1104-6be9-530b-390a050b831e@redhat.com>
Date:   Fri, 12 Jul 2019 12:44:48 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 12 Jul 2019 17:44:51 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Userspace now has an identical xfs_trans_inode.c which it has already
moved to libxfs/ so do the same move for kernelspace.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b74a47169297..06b68b6115bc 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -49,6 +49,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_refcount_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
+				   xfs_trans_inode.o \
 				   xfs_trans_resv.o \
 				   xfs_types.o \
 				   )
@@ -107,8 +108,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_rmap_item.o \
 				   xfs_log_recover.o \
 				   xfs_trans_ail.o \
-				   xfs_trans_buf.o \
-				   xfs_trans_inode.o
+				   xfs_trans_buf.o
 
 # optional features
 xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
similarity index 100%
rename from fs/xfs/xfs_trans_inode.c
rename to fs/xfs/libxfs/xfs_trans_inode.c

