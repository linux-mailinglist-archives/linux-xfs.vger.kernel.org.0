Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF2156237
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 08:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFZGRU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 02:17:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44668 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZGRU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 02:17:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id r16so1180902wrl.11;
        Tue, 25 Jun 2019 23:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AJN8bH8h41rFzhN3b/I8EWjHXsNP9Hzw60BpANM+LP0=;
        b=Om4myVJ1qV1NPrLjT1Ozf8pUFhkd8mr8WA883o8pr9Zq0eU6GCPeXxIoqgBx3rwEvI
         YLJJBx6TBePc2NAQNW6oqHoRJ8/mL9RAsPAS9Xh5f0Mz3l8HBxw51tvNdJXRFaBIsXcp
         TgP+LnVwcCpctLpcjCyFyG92weCRIwVIjdyyjy5D0N5pnvpFj0EQb5rwTA+8sndTnejF
         S0bih5NnmGCAIN1hahc0ESmPUIBoxRAznaU5/p0L+CwpJkGjEPvUqp3xDhlwRIJS7e/e
         3KZ0Wnw02iaf6n7DKP8KbZb2KEW0IlRH7ASZSkdRcDbtAGFetTql4VU10H016pxhHaE3
         xyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AJN8bH8h41rFzhN3b/I8EWjHXsNP9Hzw60BpANM+LP0=;
        b=kuD49XW0M4zWJ5sTDzzyqzytfhE2SmA7rhC3Kp9w4lZF+Mlq+6tkj2z7acVxbZ3JoL
         XslDnuDSw5YMwrl0sbwi/sWt5BNtYYFuCktLlVuEm9YjZnOFI7qFbFyFimR1d6PtYVeD
         T2j5hFGL4U++FDrx+CzSAoBFjUQic2meP24ZhJCS+0rK7EOaE5FyVYOFs4aamVY1r4l5
         oZ1zx4HXGmju6bNdXYPGdJNG527djU4ptYmD45WynJQJrglDM3QTvZc0djY3pK+RKaCH
         W+gktJn4rboCvOZQFsFH9UjJRCqM3piW6eZE/DAZPNsQewbGdv6jC/cCHaM4ivHhxNDU
         l9Og==
X-Gm-Message-State: APjAAAXiqjhrx4vWmx2VLoP3PJ2g6vXZkZWdRtIItJHLq9hVAdi1X1mG
        6/lBDJ2fLAhU5PBdu6cnAwZQSruA
X-Google-Smtp-Source: APXvYqytmH3WNLTIH2zsC2JPg3N4aIT1ZFWN+Dzh3NdST0ynzzAGd7E0eIsas8HdOXND/MACTSARKQ==
X-Received: by 2002:adf:f1d2:: with SMTP id z18mr4895wro.262.1561529838084;
        Tue, 25 Jun 2019 23:17:18 -0700 (PDT)
Received: from localhost.localdomain ([5.102.238.208])
        by smtp.gmail.com with ESMTPSA id a2sm2311875wmj.9.2019.06.25.23.17.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 23:17:17 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2] xfs_io: allow passing an open file to copy_range
Date:   Wed, 26 Jun 2019 09:17:11 +0300
Message-Id: <20190626061711.27690-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Commit 1a05efba ("io: open pipes in non-blocking mode")
addressed a specific copy_range issue with pipes by always opening
pipes in non-blocking mode.

This change takes a different approach and allows passing any
open file as the source file to copy_range.  Besides providing
more flexibility to the copy_range command, this allows xfstests
to check if xfs_io supports passing an open file to copy_range.

The intended usage is:
$ mkfifo fifo
$ xfs_io -f -n -r -c "open -f dst" -C "copy_range -f 0" fifo

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---

Eric,

Re-posting this patch with Darrick's RVB, since it was missed last
two for-next updates.
This change is needed to implement the copy_range bounds test [1].

The -f option is already available with sendfile command and
we can make it available for reflink and dedupe commands if
we want to. Too bad that these 4 commands have 3 different
usage patterns to begin with...

Thanks,
Amir.

[1] https://marc.info/?l=fstests&m=155910786017989&w=2

 io/copy_file_range.c | 30 ++++++++++++++++++++++++------
 man/man8/xfs_io.8    | 10 +++++++---
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index d069e5bb..1f0d2713 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -26,6 +26,8 @@ copy_range_help(void)
 					       file at offset 200\n\
  'copy_range some_file' - copies all bytes from some_file into the open file\n\
                           at position 0\n\
+ 'copy_range -f 2' - copies all bytes from open file 2 into the current open file\n\
+                          at position 0\n\
 "));
 }
 
@@ -82,11 +84,12 @@ copy_range_f(int argc, char **argv)
 	int opt;
 	int ret;
 	int fd;
+	int src_file_arg = 1;
 	size_t fsblocksize, fssectsize;
 
 	init_cvtnum(&fsblocksize, &fssectsize);
 
-	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
+	while ((opt = getopt(argc, argv, "s:d:l:f:")) != -1) {
 		switch (opt) {
 		case 's':
 			src = cvtnum(fsblocksize, fssectsize, optarg);
@@ -109,15 +112,30 @@ copy_range_f(int argc, char **argv)
 				return 0;
 			}
 			break;
+		case 'f':
+			fd = atoi(argv[1]);
+			if (fd < 0 || fd >= filecount) {
+				printf(_("value %d is out of range (0-%d)\n"),
+					fd, filecount-1);
+				return 0;
+			}
+			fd = filetable[fd].fd;
+			/* Expect no src_file arg */
+			src_file_arg = 0;
+			break;
 		}
 	}
 
-	if (optind != argc - 1)
+	if (optind != argc - src_file_arg) {
+		fprintf(stderr, "optind=%d, argc=%d, src_file_arg=%d\n", optind, argc, src_file_arg);
 		return command_usage(&copy_range_cmd);
+	}
 
-	fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
-	if (fd < 0)
-		return 0;
+	if (src_file_arg) {
+		fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
+		if (fd < 0)
+			return 0;
+	}
 
 	if (src == 0 && dst == 0 && len == 0) {
 		off64_t	sz;
@@ -150,7 +168,7 @@ copy_range_init(void)
 	copy_range_cmd.argmin = 1;
 	copy_range_cmd.argmax = 7;
 	copy_range_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	copy_range_cmd.args = _("[-s src_off] [-d dst_off] [-l len] src_file");
+	copy_range_cmd.args = _("[-s src_off] [-d dst_off] [-l len] src_file | -f N");
 	copy_range_cmd.oneline = _("Copy a range of data between two files");
 	copy_range_cmd.help = copy_range_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 980dcfd3..6e064bdd 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -660,12 +660,16 @@ Do not print timing statistics at all.
 .RE
 .PD
 .TP
-.BI "copy_range [ -s " src_offset " ] [ -d " dst_offset " ] [ -l " length " ] src_file"
+.BI "copy_range [ -s " src_offset " ] [ -d " dst_offset " ] [ -l " length " ] src_file | \-f " N
 On filesystems that support the
 .BR copy_file_range (2)
-system call, copies data from the
+system call, copies data from the source file into the current open file.
+The source must be specified either by path
+.RB ( src_file )
+or as another open file
+.RB ( \-f ).
+If
 .I src_file
-into the open file.  If
 .IR src_offset ,
 .IR dst_offset ,
 and
-- 
2.17.1

