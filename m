Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6951AB217
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 07:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392361AbfIFFjf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 Sep 2019 01:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390255AbfIFFjf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Sep 2019 01:39:35 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5769B307D8BE;
        Fri,  6 Sep 2019 05:39:35 +0000 (UTC)
Received: from dhcp-12-115.nay.redhat.com (dhcp-12-115.nay.redhat.com [10.66.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFB385D6A5;
        Fri,  6 Sep 2019 05:39:33 +0000 (UTC)
From:   "Jianhong.Yin" <yin-jianhong@163.com>
To:     linux-xfs@vger.kernel.org
Cc:     jiyin@redhat.com, darrick.wong@oracle.com,
        "Jianhong.Yin" <yin-jianhong@163.com>
Subject: [PATCH] xfs_io: copy_range don't truncate dst_file, and add smart length.
Date:   Fri,  6 Sep 2019 13:39:27 +0800
Message-Id: <20190906053927.8394-1-yin-jianhong@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 06 Sep 2019 05:39:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

1. copy_range should be a simple wrapper for copy_file_range(2)
and nothing else. and there's already -t option for truncate.
so here we remove the truncate action in copy_range.
see: https://patchwork.kernel.org/comment/22863587/#1

2. improve the default length value generation:
if -l option is omitted use the length that from src_offset to end
(src_file's size - src_offset) instead.
if src_offset is greater than file size, length is 0.

3. update manpage

and have confirmed that this change will not affect xfstests.

Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
---
 io/copy_file_range.c | 22 +++++-----------------
 man/man8/xfs_io.8    |  9 +++------
 2 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index b7b9fd88..02d50e53 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -66,21 +66,13 @@ copy_src_filesize(int fd)
 	return st.st_size;
 }
 
-static int
-copy_dst_truncate(void)
-{
-	int ret = ftruncate(file->fd, 0);
-	if (ret < 0)
-		perror("ftruncate");
-	return ret;
-}
-
 static int
 copy_range_f(int argc, char **argv)
 {
 	long long src = 0;
 	long long dst = 0;
 	size_t len = 0;
+	int len_ommited = 1;
 	int opt;
 	int ret;
 	int fd;
@@ -112,6 +104,7 @@ copy_range_f(int argc, char **argv)
 				printf(_("invalid length -- %s\n"), optarg);
 				return 0;
 			}
+			len_ommited = 0;
 			break;
 		case 'f':
 			src_file_nr = atoi(argv[1]);
@@ -137,7 +130,7 @@ copy_range_f(int argc, char **argv)
 		fd = filetable[src_file_nr].fd;
 	}
 
-	if (src == 0 && dst == 0 && len == 0) {
+	if (len_ommited) {
 		off64_t	sz;
 
 		sz = copy_src_filesize(fd);
@@ -145,13 +138,8 @@ copy_range_f(int argc, char **argv)
 			ret = 1;
 			goto out;
 		}
-		len = sz;
-
-		ret = copy_dst_truncate();
-		if (ret < 0) {
-			ret = 1;
-			goto out;
-		}
+		if (sz > src)
+			len = sz - src;
 	}
 
 	ret = copy_file_range_cmd(fd, &src, &dst, len);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6e064bdd..8bfaeeba 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -669,13 +669,10 @@ The source must be specified either by path
 or as another open file
 .RB ( \-f ).
 If
-.I src_file
-.IR src_offset ,
-.IR dst_offset ,
-and
 .I length
-are omitted the contents of src_file will be copied to the beginning of the
-open file, overwriting any data already there.
+is omitted will use ( src_size - 
+.I src_offset
+) instead.
 .RS 1.0i
 .PD 0
 .TP 0.4i
-- 
2.21.0

