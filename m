Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE412E7B4F
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Dec 2020 18:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgL3Q7x (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Dec 2020 11:59:53 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:10914 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726594AbgL3Q7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Dec 2020 11:59:52 -0500
X-IronPort-AV: E=Sophos;i="5.78,461,1599494400"; 
   d="scan'208";a="103085828"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Dec 2020 00:58:39 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 801344CE6020;
        Thu, 31 Dec 2020 00:58:36 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 31 Dec 2020 00:58:36 +0800
Received: from irides.mr (10.167.225.141) by G08CNEXCHPEKD04.g08.fujitsu.local
 (10.167.33.209) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 31 Dec 2020 00:58:35 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>
CC:     <linux-fsdevel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <darrick.wong@oracle.com>, <dan.j.williams@intel.com>,
        <david@fromorbit.com>, <hch@lst.de>, <song@kernel.org>,
        <rgoldwyn@suse.de>, <qi.fuli@fujitsu.com>, <y-goto@fujitsu.com>
Subject: [PATCH 03/10] fs: Introduce ->corrupted_range() for superblock
Date:   Thu, 31 Dec 2020 00:55:54 +0800
Message-ID: <20201230165601.845024-4-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201230165601.845024-1-ruansy.fnst@cn.fujitsu.com>
References: <20201230165601.845024-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 801344CE6020.A8417
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Memory failure occurs in fsdax mode will finally be handled in
filesystem.  We introduce this interface to find out files or metadata
affected by the corrupted range, and try to recover the corrupted data
if possiable.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8667d0cdc71e..282e2139b23e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1965,6 +1965,8 @@ struct super_operations {
 				  struct shrink_control *);
 	long (*free_cached_objects)(struct super_block *,
 				    struct shrink_control *);
+	int (*corrupted_range)(struct super_block *sb, struct block_device *bdev,
+			       loff_t offset, size_t len, void *data);
 };
 
 /*
-- 
2.29.2



