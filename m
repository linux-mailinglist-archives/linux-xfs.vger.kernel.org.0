Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0401CAA84
	for <lists+linux-xfs@lfdr.de>; Fri,  8 May 2020 14:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgEHMXo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 May 2020 08:23:44 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52106 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727774AbgEHMXm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 May 2020 08:23:42 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C6989FA0ADCFDE643901;
        Fri,  8 May 2020 20:23:40 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 20:23:30 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next] xfs: remove duplicate headers
Date:   Fri, 8 May 2020 20:27:24 +0800
Message-ID: <20200508122724.168979-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove duplicate headers which are included twice.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 fs/xfs/xfs_xattr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index fc5d7276026e..bca48b308c02 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -12,7 +12,6 @@
 #include "xfs_inode.h"
 #include "xfs_attr.h"
 #include "xfs_acl.h"
-#include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 
 #include <linux/posix_acl_xattr.h>
-- 
2.20.1

