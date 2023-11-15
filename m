Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3B37E8D1D
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Nov 2023 23:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjKKWXD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 11 Nov 2023 17:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjKKWXC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Nov 2023 17:23:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C65530D6
        for <linux-xfs@vger.kernel.org>; Sat, 11 Nov 2023 14:22:58 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CF9C433C7;
        Sat, 11 Nov 2023 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699741378;
        bh=UHiHrlZlYd6X/riEXECrqPHEC7190bCDk/N7/2l348M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WtBtB0gpCKcbgvqXjMVs9Dt6qxU1wDr1nH9swmvudHN8BU2sVrl8NqFf8G9uTVzTG
         OAL4n4VhByXsePQdGSaPuCCqpFXEDCqdY6dciyjQDADl/XNlPT5P2ywppFnzDkX/w0
         /JHrDy4+lTHMmIJwH1t1QB5iQjjbQMyRtFS8jmndvKodRZKiGRrxwoLJFTzaHuLq6e
         HB1ppKYRRmNN1a9wisMean76PxYfjQfv9QIVfmqzMgqT+TgwhNpzD2dpldW3afo065
         ZOhS7/u7wBPc/dy7+JPEIGqDuVhKvdx5dQlp3OCotNltg0sO1NkyEyOGxa9t0CGx1V
         +Lm+4DROI/H0Q==
Date:   Sat, 11 Nov 2023 14:22:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Catherine Hoang <catherine.hoang@oracle.com>, guan@eryu.me,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/1] generic: test reads racing with slow reflink
 operations
Message-ID: <20231111222257.GB36175@frogsfrogsfrogs>
References: <169947896328.203781.17647180888752123384.stgit@frogsfrogsfrogs>
 <169947896885.203781.13438458222742566484.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169947896885.203781.13438458222742566484.stgit@frogsfrogsfrogs>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS has a rather slow reflink operation.  While a reflink operation is
running, other programs cannot read the contents of the source file,
which is causing latency spikes.  Catherine Hoang wrote a patch to
permit reads, since the source file contents do not change.  This is a
functionality test for that patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
v2: fix a couple of things pointed out by zorro
---
 configure.ac              |    1 
 include/builddefs.in      |    1 
 m4/package_libcdev.m4     |   13 ++
 src/Makefile              |    4 +
 src/t_reflink_read_race.c |  339 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1953        |   75 ++++++++++
 tests/generic/1953.out    |    6 +
 tests/xfs/1872            |   10 +
 tests/xfs/1873            |   10 +
 9 files changed, 447 insertions(+), 12 deletions(-)
 create mode 100644 src/t_reflink_read_race.c
 create mode 100755 tests/generic/1953
 create mode 100644 tests/generic/1953.out

diff --git a/configure.ac b/configure.ac
index 4687d8a3c0..7333045330 100644
--- a/configure.ac
+++ b/configure.ac
@@ -71,6 +71,7 @@ AC_HAVE_BMV_OF_SHARED
 AC_HAVE_NFTW
 AC_HAVE_RLIMIT_NOFILE
 AC_HAVE_FIEXCHANGE
+AC_HAVE_FICLONE
 
 AC_CHECK_FUNCS([renameat2])
 AC_CHECK_FUNCS([reallocarray])
diff --git a/include/builddefs.in b/include/builddefs.in
index 969acf0da2..446350d5fc 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -73,6 +73,7 @@ HAVE_NFTW = @have_nftw@
 HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
 HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
 HAVE_FIEXCHANGE = @have_fiexchange@
+HAVE_FICLONE = @have_ficlone@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 7f73104405..0f4b8063f3 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -174,3 +174,16 @@ AC_DEFUN([AC_HAVE_FIEXCHANGE],
        AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
     AC_SUBST(have_fiexchange)
   ])
+
+# Check if we have FICLONE
+AC_DEFUN([AC_HAVE_FICLONE],
+  [ AC_MSG_CHECKING([for FICLONE])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+    ]], [[
+	 ioctl(-1, FICLONE, -1);
+    ]])],[have_ficlone=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_ficlone)
+  ])
diff --git a/src/Makefile b/src/Makefile
index 2815f919b2..49dd2f6c1e 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -94,6 +94,10 @@ ifeq ($(HAVE_SEEK_DATA), yes)
  endif
 endif
 
+ifeq ($(HAVE_FICLONE),yes)
+     TARGETS += t_reflink_read_race
+endif
+
 CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS) fssum
 
diff --git a/src/t_reflink_read_race.c b/src/t_reflink_read_race.c
new file mode 100644
index 0000000000..00c19d7c05
--- /dev/null
+++ b/src/t_reflink_read_race.c
@@ -0,0 +1,339 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Race reads with reflink to see if reads continue while we're cloning.
+ * Copyright 2023 Oracle.  All rights reserved.
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+#include <time.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <signal.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+
+static pid_t mypid;
+
+static FILE *outcome_fp;
+
+/* Significant timestamps.  Initialized to zero */
+static double program_start, clone_start, clone_end;
+
+/* Coordinates access to timestamps */
+static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
+
+struct readinfo {
+	int fd;
+	unsigned int blocksize;
+	char *descr;
+};
+
+struct cloneinfo {
+	int src_fd, dst_fd;
+};
+
+#define MSEC_PER_SEC	1000
+#define NSEC_PER_MSEC	1000000
+
+/*
+ * Assume that it shouldn't take longer than 100ms for the FICLONE ioctl to
+ * enter the kernel and take locks on an uncontended file.  This is also the
+ * required CLOCK_MONOTONIC granularity.
+ */
+#define EARLIEST_READ_MS	(MSEC_PER_SEC / 10)
+
+/*
+ * We want to be reasonably sure that the FICLONE takes long enough that any
+ * read initiated after clone operation locked the source file could have
+ * completed a disk IO before the clone finishes.  Therefore, we require that
+ * the clone operation must take at least 4x the maximum setup time.
+ */
+#define MINIMUM_CLONE_MS	(EARLIEST_READ_MS * 5)
+
+static double timespec_to_msec(const struct timespec *ts)
+{
+	return (ts->tv_sec * (double)MSEC_PER_SEC) +
+	       (ts->tv_nsec / (double)NSEC_PER_MSEC);
+}
+
+static void sleep_ms(unsigned int len)
+{
+	struct timespec time = {
+		.tv_nsec = len * NSEC_PER_MSEC,
+	};
+
+	nanosleep(&time, NULL);
+}
+
+static void outcome(const char *str)
+{
+	fprintf(outcome_fp, "%s\n", str);
+	fflush(outcome_fp);
+}
+
+static void *reader_fn(void *arg)
+{
+	struct timespec now;
+	struct readinfo *ri = arg;
+	char *buf = malloc(ri->blocksize);
+	loff_t pos = 0;
+	ssize_t copied;
+	int ret;
+
+	if (!buf) {
+		perror("alloc buffer");
+		goto kill_error;
+	}
+
+	/* Wait for the FICLONE to start */
+	pthread_mutex_lock(&lock);
+	while (clone_start < program_start) {
+		pthread_mutex_unlock(&lock);
+#ifdef DEBUG
+		printf("%s read waiting for clone to start; cs=%.2f ps=%.2f\n",
+				ri->descr, clone_start, program_start);
+		fflush(stdout);
+#endif
+		sleep_ms(1);
+		pthread_mutex_lock(&lock);
+	}
+	pthread_mutex_unlock(&lock);
+	sleep_ms(EARLIEST_READ_MS);
+
+	/* Read from the file... */
+	while ((copied = read(ri->fd, buf, ri->blocksize)) > 0) {
+		double read_completion;
+
+		ret = clock_gettime(CLOCK_MONOTONIC, &now);
+		if (ret) {
+			perror("clock_gettime");
+			goto kill_error;
+		}
+		read_completion = timespec_to_msec(&now);
+
+		/*
+		 * If clone_end is still zero, the FICLONE is still running.
+		 * If the read completion occurred a safe duration after the
+		 * start of the ioctl, then report that as an early read
+		 * completion.
+		 */
+		pthread_mutex_lock(&lock);
+		if (clone_end < program_start &&
+		    read_completion > clone_start + EARLIEST_READ_MS) {
+			pthread_mutex_unlock(&lock);
+
+			/* clone still running... */
+			printf("finished %s read early at %.2fms\n",
+					ri->descr,
+					read_completion - program_start);
+			fflush(stdout);
+			outcome("finished read early");
+			goto kill_done;
+		}
+		pthread_mutex_unlock(&lock);
+
+		sleep_ms(1);
+		pos += copied;
+	}
+	if (copied < 0) {
+		perror("read");
+		goto kill_error;
+	}
+
+	return NULL;
+kill_error:
+	outcome("reader error");
+kill_done:
+	kill(mypid, SIGTERM);
+	return NULL;
+}
+
+static void *clone_fn(void *arg)
+{
+	struct timespec now;
+	struct cloneinfo *ci = arg;
+	int ret;
+
+	/* Record the approximate start time of this thread */
+	ret = clock_gettime(CLOCK_MONOTONIC, &now);
+	if (ret) {
+		perror("clock_gettime clone start");
+		goto kill_error;
+	}
+	pthread_mutex_lock(&lock);
+	clone_start = timespec_to_msec(&now);
+	pthread_mutex_unlock(&lock);
+
+	printf("started clone at %.2fms\n", clone_start - program_start);
+	fflush(stdout);
+
+	/* Kernel call, only killable with a fatal signal */
+	ret = ioctl(ci->dst_fd, FICLONE, ci->src_fd);
+	if (ret) {
+		perror("FICLONE");
+		goto kill_error;
+	}
+
+	/* If the ioctl completes, note the completion time */
+	ret = clock_gettime(CLOCK_MONOTONIC, &now);
+	if (ret) {
+		perror("clock_gettime clone end");
+		goto kill_error;
+	}
+
+	pthread_mutex_lock(&lock);
+	clone_end = timespec_to_msec(&now);
+	pthread_mutex_unlock(&lock);
+
+	printf("finished clone at %.2fms\n",
+			clone_end - program_start);
+	fflush(stdout);
+
+	/* Complain if we didn't take long enough to clone. */
+	if (clone_end < clone_start + MINIMUM_CLONE_MS) {
+		printf("clone did not take enough time (%.2fms)\n",
+				clone_end - clone_start);
+		fflush(stdout);
+		outcome("clone too fast");
+		goto kill_done;
+	}
+
+	outcome("clone finished before any reads");
+	goto kill_done;
+
+kill_error:
+	outcome("clone error");
+kill_done:
+	kill(mypid, SIGTERM);
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	struct cloneinfo ci;
+	struct readinfo bufio = { .descr = "buffered" };
+	struct readinfo directio = { .descr = "directio" };
+	struct timespec now;
+	pthread_t clone_thread, bufio_thread, directio_thread;
+	double clockres;
+	int ret;
+
+	if (argc != 4) {
+		printf("Usage: %s src_file dst_file outcome_file\n", argv[0]);
+		return 1;
+	}
+
+	mypid = getpid();
+
+	/* Check for sufficient clock precision. */
+	ret = clock_getres(CLOCK_MONOTONIC, &now);
+	if (ret) {
+		perror("clock_getres MONOTONIC");
+		return 2;
+	}
+	printf("CLOCK_MONOTONIC resolution: %llus %luns\n",
+			(unsigned long long)now.tv_sec,
+			(unsigned long)now.tv_nsec);
+	fflush(stdout);
+
+	clockres = timespec_to_msec(&now);
+	if (clockres > EARLIEST_READ_MS) {
+		fprintf(stderr, "insufficient CLOCK_MONOTONIC resolution\n");
+		return 2;
+	}
+
+	/*
+	 * Measure program start time since the MONOTONIC time base is not
+	 * all that well defined.
+	 */
+	ret = clock_gettime(CLOCK_MONOTONIC, &now);
+	if (ret) {
+		perror("clock_gettime MONOTONIC");
+		return 2;
+	}
+	if (now.tv_sec == 0 && now.tv_nsec == 0) {
+		fprintf(stderr, "Uhoh, start time is zero?!\n");
+		return 2;
+	}
+	program_start = timespec_to_msec(&now);
+
+	outcome_fp = fopen(argv[3], "w");
+	if (!outcome_fp) {
+		perror(argv[3]);
+		return 2;
+	}
+
+	/* Open separate fds for each thread */
+	ci.src_fd = open(argv[1], O_RDONLY);
+	if (ci.src_fd < 0) {
+		perror(argv[1]);
+		return 2;
+	}
+
+	ci.dst_fd = open(argv[2], O_RDWR | O_CREAT, 0600);
+	if (ci.dst_fd < 0) {
+		perror(argv[2]);
+		return 2;
+	}
+
+	bufio.fd = open(argv[1], O_RDONLY);
+	if (bufio.fd < 0) {
+		perror(argv[1]);
+		return 2;
+	}
+	bufio.blocksize = 37;
+
+	directio.fd = open(argv[1], O_RDONLY | O_DIRECT);
+	if (directio.fd < 0) {
+		perror(argv[1]);
+		return 2;
+	}
+	directio.blocksize = 512;
+
+	/* Start threads */
+	ret = pthread_create(&clone_thread, NULL, clone_fn, &ci);
+	if (ret) {
+		fprintf(stderr, "create clone thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	ret = pthread_create(&bufio_thread, NULL, reader_fn, &bufio);
+	if (ret) {
+		fprintf(stderr, "create bufio thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	ret = pthread_create(&directio_thread, NULL, reader_fn, &directio);
+	if (ret) {
+		fprintf(stderr, "create directio thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	/* Wait for threads */
+	ret = pthread_join(clone_thread, NULL);
+	if (ret) {
+		fprintf(stderr, "join clone thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	ret = pthread_join(bufio_thread, NULL);
+	if (ret) {
+		fprintf(stderr, "join bufio thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	ret = pthread_join(directio_thread, NULL);
+	if (ret) {
+		fprintf(stderr, "join directio thread: %s\n", strerror(ret));
+		return 2;
+	}
+
+	printf("Program should have killed itself?\n");
+	outcome("program failed to end early");
+	return 0;
+}
diff --git a/tests/generic/1953 b/tests/generic/1953
new file mode 100755
index 0000000000..70aefc736b
--- /dev/null
+++ b/tests/generic/1953
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 1953
+#
+# Race file reads with a very slow reflink operation to see if the reads
+# actually complete while the reflink is ongoing.  This is a functionality
+# test for XFS commit f3ba4762fa56 "xfs: allow read IO and FICLONE to run
+# concurrently".
+#
+. ./common/preamble
+_begin_fstest auto clone punch
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "fpunch"
+_require_test_program "punch-alternating"
+_require_test_program "t_reflink_read_race"
+_require_command "$TIMEOUT_PROG" timeout
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+mkdir "$testdir"
+
+calc_space() {
+	blocks_needed=$(( 2 ** (fnr + 1) ))
+	space_needed=$((blocks_needed * blksz * 5 / 4))
+}
+
+# Figure out the number of blocks that we need to get the reflink runtime above
+# 1 seconds
+echo "Create a many-block file"
+for ((fnr = 1; fnr < 40; fnr++)); do
+	free_blocks=$(stat -f -c '%a' "$testdir")
+	blksz=$(_get_file_block_size "$testdir")
+	space_avail=$((free_blocks * blksz))
+	calc_space
+	test $space_needed -gt $space_avail && \
+		_notrun "Insufficient space for stress test; would only create $blocks_needed extents."
+
+	off=$(( (2 ** fnr) * blksz))
+	$XFS_IO_PROG -f -c "pwrite -S 0x61 -b 4194304 $off $off" "$testdir/file1" >> "$seqres.full"
+	"$here/src/punch-alternating" "$testdir/file1" >> "$seqres.full"
+
+	timeout 1s cp --reflink=always "$testdir/file1" "$testdir/garbage" || break
+done
+echo "fnr=$fnr" >> $seqres.full
+
+echo "Reflink the big file"
+$here/src/t_reflink_read_race "$testdir/file1" "$testdir/file2" \
+	"$testdir/outcome" &>> $seqres.full
+
+if [ ! -e "$testdir/outcome" ]; then
+	echo "Could not set up program"
+elif grep -q "finished read early" "$testdir/outcome"; then
+	echo "test completed successfully"
+else
+	cat "$testdir/outcome"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1953.out b/tests/generic/1953.out
new file mode 100644
index 0000000000..8eaacb7ff0
--- /dev/null
+++ b/tests/generic/1953.out
@@ -0,0 +1,6 @@
+QA output created by 1953
+Format and mount
+Create a many-block file
+Reflink the big file
+Terminated
+test completed successfully
diff --git a/tests/xfs/1872 b/tests/xfs/1872
index 004e99176e..289fc99612 100755
--- a/tests/xfs/1872
+++ b/tests/xfs/1872
@@ -10,15 +10,13 @@
 . ./common/preamble
 _begin_fstest auto quick unlink
 
-# Import common functions.
-source ./common/filter
-source ./common/fuzzy
-source ./common/quota
+. ./common/filter
+. ./common/fuzzy
+. ./common/quota
 
 # real QA test starts here
 
-# Modify as appropriate.
-_supported_fs generic
+_supported_fs xfs
 _require_xfs_db_command iunlink
 _require_scratch_nocheck	# we'll run repair ourselves
 
diff --git a/tests/xfs/1873 b/tests/xfs/1873
index 46af16f5d1..5d9fc620dc 100755
--- a/tests/xfs/1873
+++ b/tests/xfs/1873
@@ -10,15 +10,13 @@
 . ./common/preamble
 _begin_fstest auto online_repair
 
-# Import common functions.
-source ./common/filter
-source ./common/fuzzy
-source ./common/quota
+. ./common/filter
+. ./common/fuzzy
+. ./common/quota
 
 # real QA test starts here
 
-# Modify as appropriate.
-_supported_fs generic
+_supported_fs xfs
 _require_xfs_db_command iunlink
 # The iunlink bucket repair code wasn't added to the AGI repair code
 # until after the directory repair code was merged
