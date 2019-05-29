Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9AB2DA27
	for <lists+linux-xfs@lfdr.de>; Wed, 29 May 2019 12:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfE2KNk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 06:13:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54008 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfE2KNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 06:13:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id d17so1238019wmb.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 03:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+2ZwPJzUNGnxvZ31bbIgh9k9BbnCDp3AYE5BZGtFCR4=;
        b=lYiKxdFp2EP/o1Zzv7hPaeq5VSfpHa+EkPsrqNStZAGcfrYqK8u2nnnhwadxG21NEi
         5hXX9snpyQR8mk3t7HQi8/RNw0f4KGUiq6ukbVlKkR8UUlnRpNS+rWF3mx3quQseQ8GL
         TmqxPW7i1nrfO9Jcp7Q3mxWwFGLJSTQh/FSldR21m4wERfrH4j5zv+FQvJQ2hXkbb2kJ
         cNPQ4P5WzOH6pusC6MQOD2UaRnoCYcrt+bKkz7+NP1LyJnmUXM+vKbRRqrMYvCme5T7D
         5Piyl1eV8VfBVaf9oLQEWEHCtBGBvNKrzr0UUAyP+bnIdeOzF943kacMPxe9MLUYK0m0
         U8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+2ZwPJzUNGnxvZ31bbIgh9k9BbnCDp3AYE5BZGtFCR4=;
        b=icEiuqhHxFIzxstQsEnUn5oVAdpi6T8bjnyXajiHuiBrjDSZkx+Fo+iUy43PYBOLi2
         zTcpliLJ+bnTqj/qTBNI7jKxRTz7netFEv9zTJPpO9dhjK6Mi/cSLSRt+KOXU8UHyXCD
         vdBfVNMTiDpMYWI26PAPi1g9hwZ/pApHcKfxYx75uycZxaNtaVT6JoBanlHh8sZYaie2
         PHc7sudVayPlABPcd9M+QRppI0NAUfpfIMAym1ASJBkJ6Um+qPA+TkqJKkBAVD06aszk
         TWE9LBNcT331dsI+Z0gOs1nJfVEuClq13hTO+P3JvpRsBSEhzzVB5ch/mIrg+SCIzbHe
         ykrg==
X-Gm-Message-State: APjAAAUHnouj9F5ZGmr3UgyMexul80hF6SKPM11c33EO2zKYrjAjO3F6
        pscFef8ScTXBXOhvAUEQY98=
X-Google-Smtp-Source: APXvYqxJJgdZ8dqksiUyRPqgMa7Scdow7EldpDE27iqLT5cMPs4Uw1UBSPT21jF/1VJD7pBMCA4wWQ==
X-Received: by 2002:a1c:2dc2:: with SMTP id t185mr6435826wmt.52.1559124816906;
        Wed, 29 May 2019 03:13:36 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id y12sm13403893wrh.40.2019.05.29.03.13.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 03:13:36 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_io: allow passing an open file to copy_range
Date:   Wed, 29 May 2019 13:13:30 +0300
Message-Id: <20190529101330.29470-1-amir73il@gmail.com>
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
---

Darrick,

Folowing our discussion on the copy_range bounds test [1],
what do you think about using copy_range -f in the copy_range
fifo test with a fifo that was explicitly opened non-blocking,
instead of trying to figure out if copy_range is going to hang
or not?

This option is already available with sendfile command and
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

