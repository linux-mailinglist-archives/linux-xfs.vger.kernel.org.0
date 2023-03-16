Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992596BD64E
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Mar 2023 17:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCPQwu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Mar 2023 12:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjCPQwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 12:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B50BCB079
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 09:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA4A8620A1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 16:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B651C433D2;
        Thu, 16 Mar 2023 16:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678985567;
        bh=AQBlO3OME4L0SI7clhb9Zv8JFyTQ8LhgA3ylQC/srWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h7sWayoUskRcgDszakGg20o8pMWkvkCrPVBzEAZPdLpDjByj6RSVFBp9E2mPS1Sga
         oBxZXshX0iam7wx5vsxHdnFVzHU5ThoAD19UypVMXPB96yGjVBuSYjxDqtWnDz4tAb
         ApKmM4IfRiAYTrXwoZ10b8i6IJHT4lBfdSYoaKDdjs3rq6bCyCUJxICHCTPlwVue7i
         WUWZnk2+YHQutDUCjO0+p3vCj6ZHOFCu+DCU4DKc/FjTJ5ezIimKvf8BYvG4rF/Q6h
         6N2xELQKLbYqq0qdykQ0IBxIpSGpGROW8PonREOhl5PR6pnOaME5Avm2Z4CRbX/Va7
         6U7B4Y/2KlfDA==
Date:   Thu, 16 Mar 2023 09:52:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 2/2] misc: test the dir/attr hash before formatting or
 repairing fs
Message-ID: <20230316165246.GO11376@frogsfrogsfrogs>
References: <20230316165101.GN11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316165101.GN11376@frogsfrogsfrogs>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Back in the 6.2-rc1 days, Eric Whitney reported a fstests regression in
ext4 against generic/454.  The cause of this test failure was the
unfortunate combination of setting an xattr name containing UTF8 encoded
emoji, an xattr hash function that accepted a char pointer with no
explicit signedness, signed type extension of those chars to an int, and
the 6.2 build tools maintainers deciding to mandate -funsigned-char
across the board.  As a result, the ondisk extended attribute structure
written out by 6.1 and 6.2 were not the same.

This discrepancy, in fact, had been noticeable if a filesystem with such
an xattr were moved between any two architectures that don't employ the
same signedness of a raw "char" declaration.  The only reason anyone
noticed is that x86 gcc defaults to signed, and no such -funsigned-char
update was made to e2fsprogs, so e2fsck immediately started reporting
data corruption.

After a day and a half of discussing how to handle this use case (xattrs
with bit 7 set anywhere in the name) without breaking existing users,
Linus merged his own patch and didn't tell the mailing list.  None of
the developers noticed until AUTOSEL made an announcement.

In the end, this problem could have been detected much earlier if there
had been any useful tests of hash function(s) in use inside ext4 to make
sure that they always produce the same outputs given the same inputs.

The XFS dirent/xattr name hash takes a uint8_t*, so I don't think it's
vulnerable to this problem.  However, let's avoid all this drama by
adding our own self test to check that the da hash produces the same
outputs for a static pile of inputs on various platforms.  This
corresponds to the similar patch for the kernel.

Link: https://lore.kernel.org/linux-ext4/Y8bpkm3jA3bDm3eL@debian-BULLSEYE-live-builder-AMD64/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/Makefile         |    1 
 libfrog/crc32cselftest.h |   17 ++---
 libfrog/dahashselftest.h |  172 ++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c          |    8 ++
 repair/init.c            |    5 +
 5 files changed, 195 insertions(+), 8 deletions(-)
 create mode 100644 libfrog/dahashselftest.h

diff --git a/libfrog/Makefile b/libfrog/Makefile
index b89818ed..f292afe3 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -40,6 +40,7 @@ crc32c.h \
 crc32cselftest.h \
 crc32defs.h \
 crc32table.h \
+dahashselftest.h \
 fsgeom.h \
 logging.h \
 paths.h \
diff --git a/libfrog/crc32cselftest.h b/libfrog/crc32cselftest.h
index 757a9cf1..ad9c74c7 100644
--- a/libfrog/crc32cselftest.h
+++ b/libfrog/crc32cselftest.h
@@ -41,7 +41,7 @@ static struct crc_test {
 	uint32_t start;	/* random 6 bit offset in buf */
 	uint32_t length;	/* random 11 bit length of test */
 	uint32_t crc32c_le;	/* expected crc32c_le result */
-} test[] =
+} crc_tests[] =
 {
 	{0x674bf11d, 0x00000038, 0x00000542, 0xf6e93d6c},
 	{0x35c672c6, 0x0000003a, 0x000001aa, 0x0fe92aca},
@@ -164,18 +164,19 @@ crc32c_test(
 
 	/* pre-warm the cache */
 	for (i = 0; i < 100; i++) {
-		bytes += 2*test[i].length;
+		bytes += 2 * crc_tests[i].length;
 
-		crc ^= crc32c_le(test[i].crc, randbytes_test_buf +
-		    test[i].start, test[i].length);
+		crc ^= crc32c_le(crc_tests[i].crc,
+				randbytes_test_buf + crc_tests[i].start,
+				crc_tests[i].length);
 	}
 
 	gettimeofday(&start, NULL);
 	for (i = 0; i < 100; i++) {
-		crc = crc32c_le(test[i].crc,
-				randbytes_test_buf + test[i].start,
-				test[i].length);
-		if (crc != test[i].crc32c_le)
+		crc = crc32c_le(crc_tests[i].crc,
+				randbytes_test_buf + crc_tests[i].start,
+				crc_tests[i].length);
+		if (crc != crc_tests[i].crc32c_le)
 			errors++;
 	}
 	gettimeofday(&stop, NULL);
diff --git a/libfrog/dahashselftest.h b/libfrog/dahashselftest.h
new file mode 100644
index 00000000..7dda5303
--- /dev/null
+++ b/libfrog/dahashselftest.h
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libfrog/randbytes.h"
+
+#ifndef __LIBFROG_DAHASHSELFTEST_H__
+#define __LIBFROG_DAHASHSELFTEST_H__
+
+/* 100 test cases */
+static struct dahash_test {
+	uint16_t	start;	/* random 12 bit offset in buf */
+	uint16_t	length;	/* random 8 bit length of test */
+	xfs_dahash_t	dahash;	/* expected dahash result */
+} dahash_tests[] =
+{
+	{0x0567, 0x0097, 0x96951389},
+	{0x0869, 0x0055, 0x6455ab4f},
+	{0x0c51, 0x00be, 0x8663afde},
+	{0x044a, 0x00fc, 0x98fbe432},
+	{0x0f29, 0x0079, 0x42371997},
+	{0x08ba, 0x0052, 0x942be4f7},
+	{0x01f2, 0x0013, 0x5262687e},
+	{0x09e3, 0x00e2, 0x8ffb0908},
+	{0x007c, 0x0051, 0xb3158491},
+	{0x0854, 0x001f, 0x83bb20d9},
+	{0x031b, 0x0008, 0x98970bdf},
+	{0x0de7, 0x0027, 0xbfbf6f6c},
+	{0x0f76, 0x0005, 0x906a7105},
+	{0x092e, 0x00d0, 0x86631850},
+	{0x0233, 0x0082, 0xdbdd914e},
+	{0x04c9, 0x0075, 0x5a400a9e},
+	{0x0b66, 0x0099, 0xae128b45},
+	{0x000d, 0x00ed, 0xe61c216a},
+	{0x0a31, 0x003d, 0xf69663b9},
+	{0x00a3, 0x0052, 0x643c39ae},
+	{0x0125, 0x00d5, 0x7c310b0d},
+	{0x0105, 0x004a, 0x06a77e74},
+	{0x0858, 0x008e, 0x265bc739},
+	{0x045e, 0x0095, 0x13d6b192},
+	{0x0dab, 0x003c, 0xc4498704},
+	{0x00cd, 0x00b5, 0x802a4e2d},
+	{0x069b, 0x008c, 0x5df60f71},
+	{0x0454, 0x006c, 0x5f03d8bb},
+	{0x040e, 0x0032, 0x0ce513b5},
+	{0x0874, 0x00e2, 0x6a811fb3},
+	{0x0521, 0x00b4, 0x93296833},
+	{0x0ddc, 0x00cf, 0xf9305338},
+	{0x0a70, 0x0023, 0x239549ea},
+	{0x083e, 0x0027, 0x2d88ba97},
+	{0x0241, 0x00a7, 0xfe0b32e1},
+	{0x0dfc, 0x0096, 0x1a11e815},
+	{0x023e, 0x001e, 0xebc9a1f3},
+	{0x067e, 0x0066, 0xb1067f81},
+	{0x09ea, 0x000e, 0x46fd7247},
+	{0x036b, 0x008c, 0x1a39acdf},
+	{0x078f, 0x0030, 0x964042ab},
+	{0x085c, 0x008f, 0x1829edab},
+	{0x02ec, 0x009f, 0x6aefa72d},
+	{0x043b, 0x00ce, 0x65642ff5},
+	{0x0a32, 0x00b8, 0xbd82759e},
+	{0x0d3c, 0x0087, 0xf4d66d54},
+	{0x09ec, 0x008a, 0x06bfa1ff},
+	{0x0902, 0x0015, 0x755025d2},
+	{0x08fe, 0x000e, 0xf690ce2d},
+	{0x00fb, 0x00dc, 0xe55f1528},
+	{0x0eaa, 0x003a, 0x0fe0a8d7},
+	{0x05fb, 0x0006, 0x86281cfb},
+	{0x0dd1, 0x00a7, 0x60ab51b4},
+	{0x0005, 0x001b, 0xf51d969b},
+	{0x077c, 0x00dd, 0xc2fed268},
+	{0x0575, 0x00f5, 0x432c0b1a},
+	{0x05be, 0x0088, 0x78baa04b},
+	{0x0c89, 0x0068, 0xeda9e428},
+	{0x0f5c, 0x0068, 0xec143c76},
+	{0x06a8, 0x0009, 0xd72651ce},
+	{0x060f, 0x008e, 0x765426cd},
+	{0x07b1, 0x0047, 0x2cfcfa0c},
+	{0x04f1, 0x0041, 0x55b172f9},
+	{0x0e05, 0x00ac, 0x61efde93},
+	{0x0bf7, 0x0097, 0x05b83eee},
+	{0x04e9, 0x00f3, 0x9928223a},
+	{0x023a, 0x0005, 0xdfada9bc},
+	{0x0acb, 0x000e, 0x2217cecd},
+	{0x0148, 0x0060, 0xbc3f7405},
+	{0x0764, 0x0059, 0xcbc201b1},
+	{0x021f, 0x0059, 0x5d6b2256},
+	{0x0f1e, 0x006c, 0xdefeeb45},
+	{0x071c, 0x00b9, 0xb9b59309},
+	{0x0564, 0x0063, 0xae064271},
+	{0x0b14, 0x0044, 0xdb867d9b},
+	{0x0e5a, 0x0055, 0xff06b685},
+	{0x015e, 0x00ba, 0x1115ccbc},
+	{0x0379, 0x00e6, 0x5f4e58dd},
+	{0x013b, 0x0067, 0x4897427e},
+	{0x0e64, 0x0071, 0x7af2b7a4},
+	{0x0a11, 0x0050, 0x92105726},
+	{0x0109, 0x0055, 0xd0d000f9},
+	{0x00aa, 0x0022, 0x815d229d},
+	{0x09ac, 0x004f, 0x02f9d985},
+	{0x0e1b, 0x00ce, 0x5cf92ab4},
+	{0x08af, 0x00d8, 0x17ca72d1},
+	{0x0e33, 0x000a, 0xda2dba6b},
+	{0x0ee3, 0x006a, 0xb00048e5},
+	{0x0648, 0x001a, 0x2364b8cb},
+	{0x0315, 0x0085, 0x0596fd0d},
+	{0x0fbb, 0x003e, 0x298230ca},
+	{0x0422, 0x006a, 0x78ada4ab},
+	{0x04ba, 0x0073, 0xced1fbc2},
+	{0x007d, 0x0061, 0x4b7ff236},
+	{0x070b, 0x00d0, 0x261cf0ae},
+	{0x0c1a, 0x0035, 0x8be92ee2},
+	{0x0af8, 0x0063, 0x824dcf03},
+	{0x08f8, 0x006d, 0xd289710c},
+	{0x021b, 0x00ee, 0x6ac1c41d},
+	{0x05b5, 0x00da, 0x8e52f0e2},
+};
+
+/* Don't print anything to stdout. */
+#define DAHASHTEST_QUIET	(1U << 0)
+
+static int
+dahash_test(
+	unsigned int	flags)
+{
+	int		i;
+	int		errors = 0;
+	int		bytes = 0;
+	struct timeval	start, stop;
+	uint64_t	usec;
+
+	/* keep static to prevent cache warming code from
+	 * getting eliminated by the compiler */
+	static xfs_dahash_t	hash;
+
+	/* pre-warm the cache */
+	for (i = 0; i < ARRAY_SIZE(dahash_tests); i++) {
+		bytes += 2 * dahash_tests[i].length;
+
+		hash ^= libxfs_da_hashname(
+				randbytes_test_buf + dahash_tests[i].start,
+				dahash_tests[i].length);
+	}
+
+	gettimeofday(&start, NULL);
+	for (i = 0; i < ARRAY_SIZE(dahash_tests); i++) {
+		hash = libxfs_da_hashname(
+				randbytes_test_buf + dahash_tests[i].start,
+				dahash_tests[i].length);
+		if (hash != dahash_tests[i].dahash)
+			errors++;
+	}
+	gettimeofday(&stop, NULL);
+
+	usec = stop.tv_usec - start.tv_usec +
+		1000000 * (stop.tv_sec - start.tv_sec);
+
+	if (flags & DAHASHTEST_QUIET)
+		return errors;
+
+	if (errors)
+		printf("dahash: %d self tests failed\n", errors);
+	else {
+		printf("dahash: tests passed, %d bytes in %" PRIu64 " usec\n",
+			bytes, usec);
+	}
+
+	return errors;
+}
+
+#endif /* __LIBFROG_DAHASHSELFTEST_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 54730497..4320cd9e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -11,6 +11,7 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/convert.h"
 #include "libfrog/crc32cselftest.h"
+#include "libfrog/dahashselftest.h"
 #include "proto.h"
 #include <ini.h>
 
@@ -4264,6 +4265,13 @@ main(
 		return 1;
 	}
 
+	/* Make sure our dir/attr hash algorithm really works. */
+	if (dahash_test(DAHASHTEST_QUIET) != 0) {
+		fprintf(stderr,
+ _("xfs dir/attr self-test failed, will not create a filesystem here.\n"));
+		return 1;
+	}
+
 	/*
 	 * All values have been validated, discard the old device layout.
 	 */
diff --git a/repair/init.c b/repair/init.c
index 3a320b4f..0d5bfabc 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -15,6 +15,7 @@
 #include "incore.h"
 #include "prefetch.h"
 #include "libfrog/crc32cselftest.h"
+#include "libfrog/dahashselftest.h"
 #include <sys/resource.h>
 
 static void
@@ -105,4 +106,8 @@ _("Unmount or use the dangerous (-d) option to repair a read-only mounted filesy
 	if (crc32c_test(CRC32CTEST_QUIET) != 0)
 		do_error(
  _("crc32c self-test failed, will not examine filesystem.\n"));
+
+	if (dahash_test(DAHASHTEST_QUIET) != 0)
+		do_error(
+ _("xfs dir/attr hash self-test failed, will not examine filesystem.\n"));
 }
