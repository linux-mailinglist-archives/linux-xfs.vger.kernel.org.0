Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A5B653A66
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Dec 2022 02:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiLVBxg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Dec 2022 20:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiLVBxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 20:53:34 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E882D25C53
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 17:53:32 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so4255444pjr.3
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 17:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ezbr64aBmVtHXm1AXyFdaFR488mDt3YEvnUbqF9QlsY=;
        b=DvCII+f3b5oXIpEEhk7hHC8KceC9mETOyOq3ynx8wieSS+JrhCvJzSDcL/OZv5sJfE
         cKLP4tROS1m8c7CVTaGpL3aUqVk/ZO8u2EhUe7q/6tZR4Q9OdaPlLTh36MuamYb46psW
         wjvX52n9PyzTDAcNCAkPeEH1FtDhNHmNIdFQT5uw31gpKkIM8NN++zMsKQL+EpDIE+F8
         4gytlqhlHBNc7krjemv8m/cOK61/LQpN/P+K3dKr0/TrYFZ00zyAPiRqEH1SvZAom/Lt
         btYxJp4YgDy+oWXzw6xM6vo41VHnXHY1FbMJa1kDOveetOtE8QCuOI0y1r/vTk03EAWx
         AE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ezbr64aBmVtHXm1AXyFdaFR488mDt3YEvnUbqF9QlsY=;
        b=U3x9KlxdEe24pXIj3vUsrtdBwrrCbH3fjI3mL9u5bvv2GEPb3LVe6p1MXHBedShlE5
         GeQbXyy0T6WasSacUMzNcEvRR5rbYzsrWQk8RpTZjkVNvAsHTdtyCRmAZ0dkEBB3J8HD
         RYW38ohxa5chs7XEsqEcDBxw9fg8H+XEvnR/1mr7Vz2swc4x9pI7tmykiFIYtlqqe0dn
         OvMdckJd+MFwbVqD517AW9pufFVAAbn9CS8sK+pNequVQD+vsVQCf18sqjDm44noDfmX
         0JspGig9F8fY2p7OQ1SmJJWxhwN7s1kMc6qevutMW7eL7HHkeImCoRyMrYbZUN+dFaaN
         1biw==
X-Gm-Message-State: AFqh2kqAheWN+Y8ap4Qoh7AcuIw0o0umXd2djVEXH347Fm9S6nj3zb6/
        Jw+qXwFVYe3PqgLjpKhdQuZbTsdkysE=
X-Google-Smtp-Source: AMrXdXusVjmniLSubZOBnNPhipLL/rt0QzptiwDAKT69qG/zGKWINwcbaTDC9mihZP74rS/EN4m5HQ==
X-Received: by 2002:a05:6a20:e187:b0:aa:c42:bab with SMTP id ks7-20020a056a20e18700b000aa0c420babmr5435071pzb.59.1671674011914;
        Wed, 21 Dec 2022 17:53:31 -0800 (PST)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9181:1cf0::41f2])
        by smtp.gmail.com with ESMTPSA id f10-20020a631f0a000000b004790f514f15sm10405116pgf.22.2022.12.21.17.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 17:53:31 -0800 (PST)
From:   Khem Raj <raj.khem@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 2/2] Replace off64_t/stat64 with off_t/stat
Date:   Wed, 21 Dec 2022 17:53:27 -0800
Message-Id: <20221222015327.939932-2-raj.khem@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221222015327.939932-1-raj.khem@gmail.com>
References: <20221222015327.939932-1-raj.khem@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When using AC_SYS_LARGEFILE, it will automatically add
-D_FILE_OFFSET_BITS=64 to enable 64bit off_t and all lfs64 support

helps compile on musl where off_t was always 64bit and lfs64 were never
needed

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 copy/xfs_copy.c           |  2 +-
 fsr/xfs_fsr.c             |  2 +-
 io/bmap.c                 |  6 +++---
 io/copy_file_range.c      |  4 ++--
 io/cowextsize.c           |  6 +++---
 io/fadvise.c              |  2 +-
 io/fiemap.c               |  6 +++---
 io/fsmap.c                |  6 +++---
 io/io.h                   | 10 +++++-----
 io/madvise.c              |  2 +-
 io/mincore.c              |  2 +-
 io/mmap.c                 | 12 ++++++------
 io/pread.c                | 22 +++++++++++-----------
 io/pwrite.c               | 20 ++++++++++----------
 io/reflink.c              |  4 ++--
 io/seek.c                 |  6 +++---
 io/sendfile.c             |  6 +++---
 io/stat.c                 |  2 +-
 io/sync_file_range.c      |  2 +-
 io/truncate.c             |  2 +-
 libxfs/rdwr.c             |  8 ++++----
 mdrestore/xfs_mdrestore.c |  2 +-
 repair/prefetch.c         |  2 +-
 scrub/spacemap.c          |  6 +++---
 spaceman/freesp.c         |  4 ++--
 spaceman/trim.c           |  2 +-
 26 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 79f65946..854fd7f4 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -888,7 +888,7 @@ main(int argc, char **argv)
 			}
 		} else  {
 			char	*lb[XFS_MAX_SECTORSIZE] = { NULL };
-			off64_t	off;
+			off_t	off;
 
 			/* ensure device files are sufficiently large */
 
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index ba02506d..12fffbd8 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1148,7 +1148,7 @@ packfile(char *fname, char *tname, int fd,
 	struct dioattr	dio;
 	static xfs_swapext_t   sx;
 	struct xfs_flock64  space;
-	off64_t 	cnt, pos;
+	off_t 	cnt, pos;
 	void 		*fbuf = NULL;
 	int 		ct, wc, wc_b4;
 	char		ffname[SMBUFSZ];
diff --git a/io/bmap.c b/io/bmap.c
index 27383ca6..0b14bb7b 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -257,7 +257,7 @@ bmap_f(
 #define	FLG_BSW		0000010	/* Not on begin of stripe width */
 #define	FLG_ESW		0000001	/* Not on end   of stripe width */
 		int	agno;
-		off64_t agoff, bbperag;
+		off_t agoff, bbperag;
 		int	foff_w, boff_w, aoff_w, tot_w, agno_w;
 		char	rbuf[32], bbuf[32], abuf[32];
 		int	sunit, swidth;
@@ -267,8 +267,8 @@ bmap_f(
 		if (is_rt)
 			sunit = swidth = bbperag = 0;
 		else {
-			bbperag = (off64_t)fsgeo.agblocks *
-				  (off64_t)fsgeo.blocksize / BBSIZE;
+			bbperag = (off_t)fsgeo.agblocks *
+				  (off_t)fsgeo.blocksize / BBSIZE;
 			sunit = (fsgeo.sunit * fsgeo.blocksize) / BBSIZE;
 			swidth = (fsgeo.swidth * fsgeo.blocksize) / BBSIZE;
 		}
diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index d154fa76..422e691a 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -54,7 +54,7 @@ copy_file_range_cmd(int fd, long long *src_off, long long *dst_off, size_t len)
 	return 0;
 }
 
-static off64_t
+static off_t
 copy_src_filesize(int fd)
 {
 	struct stat st;
@@ -154,7 +154,7 @@ copy_range_f(int argc, char **argv)
 	}
 
 	if (!len_specified) {
-		off64_t	sz;
+		off_t	sz;
 
 		sz = copy_src_filesize(fd);
 		if (sz < 0 || (unsigned long long)sz > SIZE_MAX) {
diff --git a/io/cowextsize.c b/io/cowextsize.c
index f6b134df..00e40c6f 100644
--- a/io/cowextsize.c
+++ b/io/cowextsize.c
@@ -50,10 +50,10 @@ static int
 set_cowextsize(const char *path, int fd, long extsz)
 {
 	struct fsxattr	fsx;
-	struct stat64	stat;
+	struct stat	stat;
 
-	if (fstat64(fd, &stat) < 0) {
-		perror("fstat64");
+	if (fstat(fd, &stat) < 0) {
+		perror("fstat");
 		exitcode = 1;
 		return 0;
 	}
diff --git a/io/fadvise.c b/io/fadvise.c
index 60cc0f08..0966c41b 100644
--- a/io/fadvise.c
+++ b/io/fadvise.c
@@ -39,7 +39,7 @@ fadvise_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset = 0, length = 0;
+	off_t		offset = 0, length = 0;
 	int		c, range = 0, advise = POSIX_FADV_NORMAL;
 
 	while ((c = getopt(argc, argv, "dnrsw")) != EOF) {
diff --git a/io/fiemap.c b/io/fiemap.c
index f0c74dfe..b41f71bf 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -234,9 +234,9 @@ fiemap_f(
 	int		tot_w = 5;	/* 5 since its just one number */
 	int		flg_w = 5;
 	__u64		last_logical = 0;	/* last extent offset handled */
-	off64_t		start_offset = 0;	/* mapping start */
-	off64_t		length = -1LL;		/* mapping length */
-	off64_t		range_end = -1LL;	/* mapping end*/
+	off_t		start_offset = 0;	/* mapping start */
+	off_t		length = -1LL;		/* mapping length */
+	off_t		range_end = -1LL;	/* mapping end*/
 	size_t		fsblocksize, fssectsize;
 	struct stat	st;
 
diff --git a/io/fsmap.c b/io/fsmap.c
index 9dd19cc0..dfdaa1b4 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -170,7 +170,7 @@ dump_map_verbose(
 	unsigned long long	i;
 	struct fsmap		*p;
 	int			agno;
-	off64_t			agoff, bperag;
+	off_t			agoff, bperag;
 	int			foff_w, boff_w, aoff_w, tot_w, agno_w, own_w;
 	int			nr_w, dev_w;
 	char			rbuf[40], bbuf[40], abuf[40], obuf[40];
@@ -183,8 +183,8 @@ dump_map_verbose(
 	dev_w = 3;
 	nr_w = 4;
 	tot_w = MINTOT_WIDTH;
-	bperag = (off64_t)fsgeo->agblocks *
-		  (off64_t)fsgeo->blocksize;
+	bperag = (off_t)fsgeo->agblocks *
+		  (off_t)fsgeo->blocksize;
 	sunit = (fsgeo->sunit * fsgeo->blocksize);
 	swidth = (fsgeo->swidth * fsgeo->blocksize);
 
diff --git a/io/io.h b/io/io.h
index 64b7a663..5f423016 100644
--- a/io/io.h
+++ b/io/io.h
@@ -53,7 +53,7 @@ extern int stat_f(int argc, char **argv);
 typedef struct mmap_region {
 	void		*addr;		/* address of start of mapping */
 	size_t		length;		/* length of mapping */
-	off64_t		offset;		/* start offset into backing file */
+	off_t		offset;		/* start offset into backing file */
 	int		prot;		/* protection mode of the mapping */
 	int		flags;		/* MAP_* flags passed to mmap() */
 	char		*name;		/* name of backing file */
@@ -63,13 +63,13 @@ extern mmap_region_t	*maptable;	/* mmap'd region array */
 extern int		mapcount;	/* #entries in the mapping table */
 extern mmap_region_t	*mapping;	/* active mapping table entry */
 extern int maplist_f(void);
-extern void *check_mapping_range(mmap_region_t *, off64_t, size_t, int);
+extern void *check_mapping_range(mmap_region_t *, off_t, size_t, int);
 
 /*
  * Various xfs_io helper routines/globals
  */
 
-extern off64_t		filesize(void);
+extern off_t		filesize(void);
 extern int		openfile(char *, struct xfs_fsop_geom *, int, mode_t,
 				 struct fs_path *);
 extern int		addfile(char *, int , struct xfs_fsop_geom *, int,
@@ -84,9 +84,9 @@ extern size_t		io_buffersize;
 extern int		vectors;
 extern struct iovec	*iov;
 extern int		alloc_buffer(size_t, int, unsigned int);
-extern int		read_buffer(int, off64_t, long long, long long *,
+extern int		read_buffer(int, off_t, long long, long long *,
 					int, int);
-extern void		dump_buffer(off64_t, ssize_t);
+extern void		dump_buffer(off_t, ssize_t);
 
 extern void		attr_init(void);
 extern void		bmap_init(void);
diff --git a/io/madvise.c b/io/madvise.c
index bde31539..6e9c5b12 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -39,7 +39,7 @@ madvise_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, llength;
+	off_t		offset, llength;
 	size_t		length;
 	void		*start;
 	int		advise = MADV_NORMAL, c;
diff --git a/io/mincore.c b/io/mincore.c
index 67f1d6c4..24147ac2 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -17,7 +17,7 @@ mincore_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, llength;
+	off_t		offset, llength;
 	size_t		length;
 	size_t		blocksize, sectsize;
 	void		*start;
diff --git a/io/mmap.c b/io/mmap.c
index 425957d4..10fd7b4a 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -63,11 +63,11 @@ print_mapping(
 void *
 check_mapping_range(
 	mmap_region_t	*map,
-	off64_t		offset,
+	off_t		offset,
 	size_t		length,
 	int		pagealign)
 {
-	off64_t		relative;
+	off_t		relative;
 
 	if (offset < mapping->offset) {
 		printf(_("offset (%lld) is before start of mapping (%lld)\n"),
@@ -155,7 +155,7 @@ mmap_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off_t		offset;
 	ssize_t		length = 0, length2 = 0;
 	void		*address = NULL;
 	char		*filename;
@@ -308,7 +308,7 @@ msync_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off_t		offset;
 	ssize_t		length;
 	void		*start;
 	int		c, flags = 0;
@@ -401,7 +401,7 @@ mread_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, tmp, dumpoffset, printoffset;
+	off_t		offset, tmp, dumpoffset, printoffset;
 	ssize_t		length;
 	size_t		dumplen, cnt = 0;
 	char		*bp;
@@ -566,7 +566,7 @@ mwrite_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, tmp;
+	off_t		offset, tmp;
 	ssize_t		length;
 	void		*start;
 	char		*sp;
diff --git a/io/pread.c b/io/pread.c
index 458a78b8..89fab81d 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -116,7 +116,7 @@ alloc_buffer(
 void
 __dump_buffer(
 	void		*buf,
-	off64_t		offset,
+	off_t		offset,
 	ssize_t		len)
 {
 	int		i, j;
@@ -141,7 +141,7 @@ __dump_buffer(
 
 void
 dump_buffer(
-	off64_t		offset,
+	off_t		offset,
 	ssize_t		len)
 {
 	int		i, l;
@@ -164,7 +164,7 @@ dump_buffer(
 static ssize_t
 do_preadv(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count)
 {
 	int		vecs = 0;
@@ -199,7 +199,7 @@ do_preadv(
 static ssize_t
 do_pread(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	size_t		buffer_size)
 {
@@ -212,13 +212,13 @@ do_pread(
 static int
 read_random(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	long long	*total,
 	unsigned int	seed,
 	int		eof)
 {
-	off64_t		end, off, range;
+	off_t		end, off, range;
 	ssize_t		bytes;
 	int		ops = 0;
 
@@ -259,12 +259,12 @@ read_random(
 static int
 read_backward(
 	int		fd,
-	off64_t		*offset,
+	off_t		*offset,
 	long long	*count,
 	long long	*total,
 	int		eof)
 {
-	off64_t		end, off = *offset;
+	off_t		end, off = *offset;
 	ssize_t		bytes = 0, bytes_requested;
 	long long	cnt = *count;
 	int		ops = 0;
@@ -319,7 +319,7 @@ read_backward(
 static int
 read_forward(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	long long	*total,
 	int		verbose,
@@ -353,7 +353,7 @@ read_forward(
 int
 read_buffer(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	long long	*total,
 	int		verbose,
@@ -368,7 +368,7 @@ pread_f(
 	char		**argv)
 {
 	size_t		bsize;
-	off64_t		offset;
+	off_t		offset;
 	unsigned int	zeed = 0;
 	long long	count, total, tmp;
 	size_t		fsblocksize, fssectsize;
diff --git a/io/pwrite.c b/io/pwrite.c
index 467bfa9f..8d134c56 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -54,7 +54,7 @@ pwrite_help(void)
 static ssize_t
 do_pwritev(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	int		pwritev2_flags)
 {
@@ -97,7 +97,7 @@ do_pwritev(
 static ssize_t
 do_pwrite(
 	int		fd,
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	size_t		buffer_size,
 	int		pwritev2_flags)
@@ -110,13 +110,13 @@ do_pwrite(
 
 static int
 write_random(
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	unsigned int	seed,
 	long long	*total,
 	int 		pwritev2_flags)
 {
-	off64_t		off, range;
+	off_t		off, range;
 	ssize_t		bytes;
 	int		ops = 0;
 
@@ -155,12 +155,12 @@ write_random(
 
 static int
 write_backward(
-	off64_t		offset,
+	off_t		offset,
 	long long	*count,
 	long long	*total,
 	int		pwritev2_flags)
 {
-	off64_t		end, off = offset;
+	off_t		end, off = offset;
 	ssize_t		bytes = 0, bytes_requested;
 	long long	cnt = *count;
 	int		ops = 0;
@@ -214,11 +214,11 @@ write_backward(
 
 static int
 write_buffer(
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	size_t		bs,
 	int		fd,
-	off64_t		skip,
+	off_t		skip,
 	long long	*total,
 	int		pwritev2_flags)
 {
@@ -253,7 +253,7 @@ write_buffer(
 
 static int
 write_once(
-	off64_t		offset,
+	off_t		offset,
 	long long	count,
 	long long	*total,
 	int		pwritev2_flags)
@@ -275,7 +275,7 @@ pwrite_f(
 	char		**argv)
 {
 	size_t		bsize;
-	off64_t		offset, skip = 0;
+	off_t		offset, skip = 0;
 	long long	count, total, tmp;
 	unsigned int	zeed = 0, seed = 0xcdcdcdcd;
 	size_t		fsblocksize, fssectsize;
diff --git a/io/reflink.c b/io/reflink.c
index 8e4f3899..b6a3c05a 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -98,7 +98,7 @@ dedupe_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		soffset, doffset;
+	off_t		soffset, doffset;
 	long long	count, total;
 	char		*infile;
 	int		condensed, quiet_flag;
@@ -226,7 +226,7 @@ reflink_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		soffset, doffset;
+	off_t		soffset, doffset;
 	long long	count = 0, total;
 	char		*infile = NULL;
 	int		condensed, quiet_flag;
diff --git a/io/seek.c b/io/seek.c
index 6734ecb5..ffe7439c 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -63,8 +63,8 @@ static void
 seek_output(
 	int	startflag,
 	char	*type,
-	off64_t	start,
-	off64_t	offset)
+	off_t	start,
+	off_t	offset)
 {
 	if (offset == -1) {
 		if (errno == ENXIO) {
@@ -92,7 +92,7 @@ seek_f(
 	int	argc,
 	char	**argv)
 {
-	off64_t		offset, start;
+	off_t		offset, start;
 	size_t		fsblocksize, fssectsize;
 	int		c;
 	int		current;	/* specify data or hole */
diff --git a/io/sendfile.c b/io/sendfile.c
index a003bb55..2ce569c2 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -34,12 +34,12 @@ sendfile_help(void)
 
 static int
 send_buffer(
-	off64_t		offset,
+	off_t		offset,
 	size_t		count,
 	int		fd,
 	long long	*total)
 {
-	off64_t		off = offset;
+	off_t		off = offset;
 	ssize_t		bytes, bytes_remaining = count;
 	int		ops = 0;
 
@@ -66,7 +66,7 @@ sendfile_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset = 0;
+	off_t		offset = 0;
 	long long	count, total;
 	size_t		blocksize, sectsize;
 	struct timeval	t1, t2;
diff --git a/io/stat.c b/io/stat.c
index b57f9eef..e8f68dc3 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -21,7 +21,7 @@ static cmdinfo_t stat_cmd;
 static cmdinfo_t statfs_cmd;
 static cmdinfo_t statx_cmd;
 
-off64_t
+off_t
 filesize(void)
 {
 	struct stat	st;
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
index 94285c22..2375a060 100644
--- a/io/sync_file_range.c
+++ b/io/sync_file_range.c
@@ -30,7 +30,7 @@ sync_range_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset = 0, length = 0;
+	off_t		offset = 0, length = 0;
 	int		c, sync_mode = 0;
 	size_t		blocksize, sectsize;
 
diff --git a/io/truncate.c b/io/truncate.c
index 1d049194..a74b6131 100644
--- a/io/truncate.c
+++ b/io/truncate.c
@@ -16,7 +16,7 @@ truncate_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off_t		offset;
 	size_t		blocksize, sectsize;
 
 	init_cvtnum(&blocksize, &sectsize);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 20e0793c..0e67b7b0 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -568,7 +568,7 @@ libxfs_balloc(
 
 
 static int
-__read_buf(int fd, void *buf, int len, off64_t offset, int flags)
+__read_buf(int fd, void *buf, int len, off_t offset, int flags)
 {
 	int	sts;
 
@@ -631,7 +631,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 	fd = libxfs_device_to_fd(btp->bt_bdev);
 	buf = bp->b_addr;
 	for (i = 0; i < bp->b_nmaps; i++) {
-		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
+		off_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
 		int len = BBTOB(bp->b_maps[i].bm_len);
 
 		error = __read_buf(fd, buf, len, offset, flags);
@@ -790,7 +790,7 @@ err:
 }
 
 static int
-__write_buf(int fd, void *buf, int len, off64_t offset, int flags)
+__write_buf(int fd, void *buf, int len, off_t offset, int flags)
 {
 	int	sts;
 
@@ -856,7 +856,7 @@ libxfs_bwrite(
 		void	*buf = bp->b_addr;
 
 		for (i = 0; i < bp->b_nmaps; i++) {
-			off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
+			off_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
 			int len = BBTOB(bp->b_maps[i].bm_len);
 
 			bp->b_error = __write_buf(fd, buf, len, offset,
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 7c1a66c4..bb54e382 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -116,7 +116,7 @@ perform_restore(
 		/* ensure device is sufficiently large enough */
 
 		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
-		off64_t		off;
+		off_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
 		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 017750e9..35b50134 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -475,7 +475,7 @@ pf_batch_read(
 {
 	struct xfs_buf		*bplist[MAX_BUFS];
 	unsigned int		num;
-	off64_t			first_off, last_off, next_off;
+	off_t			first_off, last_off, next_off;
 	int			len, size;
 	int			i;
 	int			inode_bufs;
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 03440d3a..00bee179 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -97,11 +97,11 @@ scan_ag_rmaps(
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_blocks	*sbx = arg;
 	struct fsmap		keys[2];
-	off64_t			bperag;
+	off_t			bperag;
 	int			ret;
 
-	bperag = (off64_t)ctx->mnt.fsgeom.agblocks *
-		 (off64_t)ctx->mnt.fsgeom.blocksize;
+	bperag = (off_t)ctx->mnt.fsgeom.agblocks *
+		 (off_t)ctx->mnt.fsgeom.blocksize;
 
 	memset(keys, 0, sizeof(struct fsmap) * 2);
 	keys->fmr_device = ctx->fsinfo.fs_datadev;
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 423568a4..df878ce8 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -62,7 +62,7 @@ static void
 addtohist(
 	xfs_agnumber_t	agno,
 	xfs_agblock_t	agbno,
-	off64_t		len)
+	off_t		len)
 {
 	long		i;
 
@@ -152,7 +152,7 @@ scan_ag(
 	struct fsmap		*l, *h;
 	struct fsmap		*p;
 	struct xfs_fd		*xfd = &file->xfd;
-	off64_t			aglen;
+	off_t			aglen;
 	xfs_agblock_t		agbno;
 	unsigned long long	freeblks = 0;
 	unsigned long long	freeexts = 0;
diff --git a/spaceman/trim.c b/spaceman/trim.c
index e9ed47e4..727dd818 100644
--- a/spaceman/trim.c
+++ b/spaceman/trim.c
@@ -26,7 +26,7 @@ trim_f(
 	struct xfs_fd		*xfd = &file->xfd;
 	struct xfs_fsop_geom	*fsgeom = &xfd->fsgeom;
 	xfs_agnumber_t		agno = 0;
-	off64_t			offset = 0;
+	off_t			offset = 0;
 	ssize_t			length = 0;
 	ssize_t			minlen = 0;
 	int			aflag = 0;
-- 
2.39.0

