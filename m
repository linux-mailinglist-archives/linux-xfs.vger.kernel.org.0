Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90C0A6744
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Sep 2019 13:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfICLTQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 Sep 2019 07:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfICLTQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Sep 2019 07:19:16 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 797898AC6E1;
        Tue,  3 Sep 2019 11:19:16 +0000 (UTC)
Received: from dhcp-12-115.nay.redhat.com (dhcp-12-115.nay.redhat.com [10.66.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4107E196AE;
        Tue,  3 Sep 2019 11:19:08 +0000 (UTC)
From:   "Jianhong.Yin" <yin-jianhong@163.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     lsahlber@redhat.com, alexander198961@gmail.com,
        fengxiaoli0714@gmail.com, dchinner@redhat.com, sandeen@redhat.com,
        "Jianhong.Yin" <yin-jianhong@163.com>
Subject: [PATCH v2] xfsprogs: io/copy_range: cover corner case (fd_in == fd_out)
Date:   Tue,  3 Sep 2019 19:19:03 +0800
Message-Id: <20190903111903.12231-1-yin-jianhong@163.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Tue, 03 Sep 2019 11:19:16 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Related bug:
  copy_file_range return "Invalid argument" when copy in the same file
  https://bugzilla.kernel.org/show_bug.cgi?id=202935

if argument of option -f is "-", use current file->fd as fd_in

Usage:
  xfs_io -c 'copy_range -f -' some_file

Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
---
 io/copy_file_range.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index b7b9fd88..2dde8a31 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -28,6 +28,7 @@ copy_range_help(void)
                           at position 0\n\
  'copy_range -f 2' - copies all bytes from open file 2 into the current open file\n\
                           at position 0\n\
+ 'copy_range -f -' - copies all bytes from current open file append the current open file\n\
 "));
 }
 
@@ -114,11 +115,15 @@ copy_range_f(int argc, char **argv)
 			}
 			break;
 		case 'f':
-			src_file_nr = atoi(argv[1]);
-			if (src_file_nr < 0 || src_file_nr >= filecount) {
-				printf(_("file value %d is out of range (0-%d)\n"),
-					src_file_nr, filecount - 1);
-				return 0;
+			if (strcmp(argv[1], "-") == 0)
+				src_file_nr = (file - &filetable[0]) / sizeof(fileio_t);
+			else {
+				src_file_nr = atoi(argv[1]);
+				if (src_file_nr < 0 || src_file_nr >= filecount) {
+					printf(_("file value %d is out of range (0-%d)\n"),
+						src_file_nr, filecount - 1);
+					return 0;
+				}
 			}
 			/* Expect no src_path arg */
 			src_path_arg = 0;
@@ -147,10 +152,14 @@ copy_range_f(int argc, char **argv)
 		}
 		len = sz;
 
-		ret = copy_dst_truncate();
-		if (ret < 0) {
-			ret = 1;
-			goto out;
+		if (fd != file->fd) {
+			ret = copy_dst_truncate();
+			if (ret < 0) {
+				ret = 1;
+				goto out;
+			}
+		} else {
+			dst = sz;
 		}
 	}
 
-- 
2.17.2

