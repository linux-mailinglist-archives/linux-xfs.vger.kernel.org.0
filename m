Return-Path: <linux-xfs+bounces-3527-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC27184AA71
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Feb 2024 00:24:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C53FC1C27BD8
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Feb 2024 23:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8B6487BF;
	Mon,  5 Feb 2024 23:24:01 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AC448786
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 23:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175441; cv=none; b=BViSS24iSIGg9H6TCWcEA6c724QhXmkchusUtAQH2egdgOUuN1Mp6Pxb+mqMvjciYqQVefPzXLR22ipRgWbSfFlqWRSMlM+qOUuBZftM7pAu8V/a2WEX1amwk2xUBNs6ttpjk8p/KTz7GP1X+XbONKJp24BT1Xk5rPmnd+D03wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175441; c=relaxed/simple;
	bh=EFYV8enX7+bEXOJ4QBeEgXFMN/78pYSvwjuBrwg5R2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fAV3RcrQGVueTBsxoHK+fRbo8oYp0u0jy+1s/buKXwl8HDW5+dwfPVLRYoKU04Ltdy3wq/rRcU4oWRuLRwgTgZ6YIUIJPIxZPEtpG3om3KvKfN5u0p1kZ907aJV1yBtSzvL2zQH+jCWyqDiHlg/3EzzP5GaHToUPs4qEiIqf8Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <carlos@maiolino.me>,
	Violet Purcell <vimproved@inventati.org>,
	Felix Janda <felix.janda@posteo.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sam James <sam@gentoo.org>
Subject: [PATCH v5 1/3] Remove use of LFS64 interfaces
Date: Mon,  5 Feb 2024 23:23:19 +0000
Message-ID: <20240205232343.2162947-1-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Violet Purcell <vimproved@inventati.org>

LFS64 interfaces are non-standard and are being removed in the upcoming musl
1.2.5. Setting _FILE_OFFSET_BITS=64 (which is currently being done) makes all
interfaces on glibc 64-bit by default, so using the LFS64 interfaces is
redundant. This commit replaces all occurences of off64_t with off_t,
stat64 with stat, and fstat64 with fstat.

Link: https://bugs.gentoo.org/907039
Cc: Felix Janda <felix.janda@posteo.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Violet Purcell <vimproved@inventati.org>
Signed-off-by: Sam James <sam@gentoo.org>
---
v5: Rebased on master & changed the order of patches 2 and 3 per Christoph's suggestion.

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
 io/mmap.c                 | 13 +++++++------
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
 26 files changed, 75 insertions(+), 74 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 0420649d..98a578a0 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -881,7 +881,7 @@ main(int argc, char **argv)
 			}
 		} else  {
 			char	*lb = memalign(wbuf_align, XFS_MAX_SECTORSIZE);
-			off64_t	off;
+			off_t	off;
 			ssize_t	len;
 
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
index 722a389b..6182e1c5 100644
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
index 7db51847..bf119639 100644
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
index fe474faf..68e5e487 100644
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
index 425957d4..7161ae8e 100644
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
@@ -155,7 +155,8 @@ mmap_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off_t		offset;
+
 	ssize_t		length = 0, length2 = 0;
 	void		*address = NULL;
 	char		*filename;
@@ -308,7 +309,7 @@ msync_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off_t		offset;
 	ssize_t		length;
 	void		*start;
 	int		c, flags = 0;
@@ -401,7 +402,7 @@ mread_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, tmp, dumpoffset, printoffset;
+	off_t		offset, tmp, dumpoffset, printoffset;
 	ssize_t		length;
 	size_t		dumplen, cnt = 0;
 	char		*bp;
@@ -566,7 +567,7 @@ mwrite_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset, tmp;
+	off_t		offset, tmp;
 	ssize_t		length;
 	void		*start;
 	char		*sp;
diff --git a/io/pread.c b/io/pread.c
index 0f1d8b97..79990c6a 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -116,7 +116,7 @@ alloc_buffer(
 static void
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
index 0e332110..153007d5 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -576,7 +576,7 @@ libxfs_balloc(
 
 
 static int
-__read_buf(int fd, void *buf, int len, off64_t offset, int flags)
+__read_buf(int fd, void *buf, int len, off_t offset, int flags)
 {
 	int	sts;
 
@@ -638,7 +638,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 
 	buf = bp->b_addr;
 	for (i = 0; i < bp->b_nmaps; i++) {
-		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
+		off_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
 		int len = BBTOB(bp->b_maps[i].bm_len);
 
 		error = __read_buf(fd, buf, len, offset, flags);
@@ -797,7 +797,7 @@ err:
 }
 
 static int
-__write_buf(int fd, void *buf, int len, off64_t offset, int flags)
+__write_buf(int fd, void *buf, int len, off_t offset, int flags)
 {
 	int	sts;
 
@@ -863,7 +863,7 @@ libxfs_bwrite(
 		void	*buf = bp->b_addr;
 
 		for (i = 0; i < bp->b_nmaps; i++) {
-			off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
+			off_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
 			int len = BBTOB(bp->b_maps[i].bm_len);
 
 			bp->b_error = __write_buf(fd, buf, len, offset,
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 8e3998db..334bdd22 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -160,7 +160,7 @@ verify_device_size(
 	} else {
 		/* ensure device is sufficiently large enough */
 		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
-		off64_t		off;
+		off_t		off;
 
 		off = nr_blocks * blocksize - sizeof(lb);
 		if (pwrite(dev_fd, lb, sizeof(lb), off) < 0)
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 78c1e397..b0dd1977 100644
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
index b6fd4118..9cefe074 100644
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
index 70dcdb5c..f5177cb4 100644
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
2.43.0


