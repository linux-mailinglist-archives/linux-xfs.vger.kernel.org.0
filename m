Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9517EE3FC
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Nov 2023 16:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbjKPPOZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Nov 2023 10:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345330AbjKPPOY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 10:14:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D934194
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 07:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700147659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X8NGv7VXMUWuytuFkM4ZM2qpjvMT06L73jRRm663/08=;
        b=Yy5wSjVUlTT9596DarXLIm+OYH/koDq3JRX/pQkx2IqsmIkr/+hn8lbrZQzVBIz6rzELpP
        RWjhNNfgJizIoWWDWsRVdb0jVTZNZL64Mecwp9KSxhzrLvezxtwE9knjWTOL+rVnSv0eR+
        2q30c6aeueruCklNis0hd9GkVh1cn+c=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-ugO1R4xpOpuLy59I4bHQjg-1; Thu, 16 Nov 2023 10:14:15 -0500
X-MC-Unique: ugO1R4xpOpuLy59I4bHQjg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1cc1682607eso10234345ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 07:14:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700147653; x=1700752453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8NGv7VXMUWuytuFkM4ZM2qpjvMT06L73jRRm663/08=;
        b=t2KhxelTU0Adi/1PVsS0i/UT/2XbX3XPaavYC/9A3vyfnmS5p64Wx93lLD5o9qxq9U
         1180Gbew4Bnhbt8EDVgdnqVuqpSMCGTngX8zznkwZ5EOy4FLUnlnKujlAdHIvrQqY5mQ
         y56QYKLYRpOVxdyyf7bGk4UYzWwDLJcvcEEjVuE3J1rxSJTK2PKTrsJBNs414VLBgE13
         8TxHouof2tjhn1FPYEaCPurpxgRvoSzWR9JUTIFBvHXFV0w02SVypBRH3pY9bfy9nNeW
         qGZ7nmdtg4ah0fG/pshVstvN0Uz2IpEi2rxOKbLxQRwVd8Twy4NW9pJizZQmWVo8rpMH
         oo1Q==
X-Gm-Message-State: AOJu0YzbNSdNOhRJd3CFPORJyv59zauouRR9TLdC7EUicm41qwxuvflY
        OIu3PjaVxRqFLCScK8VLoBI1365CGOkq8LHO2J7F1dVRpN8QMQLW32XS2ikTYpnYxB5BVssJpwe
        ZrJYGtvFabjm3ZGWmnDgHFgsTYmDx
X-Received: by 2002:a17:903:4288:b0:1cc:4559:ff with SMTP id ju8-20020a170903428800b001cc455900ffmr7679856plb.13.1700147652758;
        Thu, 16 Nov 2023 07:14:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHkp37GnyaU5c3CKEgZHUZaNxWHi6wfy4UVI9ftfRAZe4FKY2Nq77E1tF2R3emv3zVynyaEZA==
X-Received: by 2002:a17:903:4288:b0:1cc:4559:ff with SMTP id ju8-20020a170903428800b001cc455900ffmr7679836plb.13.1700147652388;
        Thu, 16 Nov 2023 07:14:12 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id iw14-20020a170903044e00b001c76891b1c9sm9355961plb.10.2023.11.16.07.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 07:14:12 -0800 (PST)
Date:   Thu, 16 Nov 2023 23:14:08 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: privatize the FIEXCHANGE ioctl for now
Message-ID: <20231116151408.rbs4skzefu4zbjag@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <169947992096.220003.8427995158013553083.stgit@frogsfrogsfrogs>
 <169947992659.220003.6848674343755298330.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169947992659.220003.6848674343755298330.stgit@frogsfrogsfrogs>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,WEIRD_PORT
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 01:45:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I'm abandoning (for now) efforts to bring atomic file content exchanges
> to the VFS.  The goal here is to reduce friction in getting online fsck
> merged, so Dave and I want to take this back to being a private XFS
> ioctl so we can explore with it for a while before committing it to the
> stable KABI.
> 
> Shift all the existing FIEXCHANGE usage to XFS_IOC_EXCHANGE_RANGE, and
> try to pick it up from xfs_fs_staging.h if the system xfslibs-dev
> package has such an animal.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Hi Darrick,

Could you please rebase this patchset onto latest fstests for-next branch?
I can't merge it onto for-next or master branch, always hit:
  $ git am -s  ./20231108_djwong_fstests_fiexchange_is_now_an_xfs_ioctl.mbx
  Applying: misc: privatize the FIEXCHANGE ioctl for now
  error: patch failed: configure.ac:70
  error: configure.ac: patch does not apply
  error: patch failed: include/builddefs.in:72
  error: include/builddefs.in: patch does not apply
  error: patch failed: m4/package_libcdev.m4:155
  error: m4/package_libcdev.m4: patch does not apply
  error: patch failed: src/Makefile:98
  error: src/Makefile: patch does not apply
  Patch failed at 0001 misc: privatize the FIEXCHANGE ioctl for now

Can you rebase this patchset onto latest for-next branch, better to after: 

  [PATCH 1/1] generic: test reads racing with slow reflink operations

I've merged it.

And of course, you please keep the RVB from Christoph Hellwig :)

Thanks,
Zorro


>  configure.ac          |    2 +-
>  doc/group-names.txt   |    2 +-
>  include/builddefs.in  |    2 +-
>  ltp/Makefile          |    4 ++--
>  ltp/fsstress.c        |   10 +++++-----
>  ltp/fsx.c             |   20 ++++++++++----------
>  m4/package_libcdev.m4 |   19 -------------------
>  m4/package_xfslibs.m4 |   14 ++++++++++++++
>  src/Makefile          |    4 ++++
>  src/fiexchange.h      |   44 ++++++++++++++++++++++----------------------
>  src/global.h          |    4 +---
>  src/vfs/Makefile      |    4 ++++
>  tests/generic/724     |    2 +-
>  tests/xfs/122.out     |    1 +
>  tests/xfs/791         |    2 +-
>  15 files changed, 68 insertions(+), 66 deletions(-)
> 
> 
> diff --git a/configure.ac b/configure.ac
> index 7333045330..b22fc52bff 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -70,7 +70,7 @@ AC_HAVE_SEEK_DATA
>  AC_HAVE_BMV_OF_SHARED
>  AC_HAVE_NFTW
>  AC_HAVE_RLIMIT_NOFILE
> -AC_HAVE_FIEXCHANGE
> +AC_HAVE_XFS_IOC_EXCHANGE_RANGE
>  AC_HAVE_FICLONE
>  
>  AC_CHECK_FUNCS([renameat2])
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index c3dcca3755..fec6bf71ab 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -52,7 +52,7 @@ enospc			ENOSPC error reporting
>  exportfs		file handles
>  fiemap			fiemap ioctl
>  filestreams		XFS filestreams allocator
> -fiexchange		FIEXCHANGE_RANGE ioctl
> +fiexchange		XFS_IOC_EXCHANGE_RANGE ioctl
>  freeze			filesystem freeze tests
>  fsck			general fsck tests
>  fsmap			FS_IOC_GETFSMAP ioctl
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 446350d5fc..ce95fe7d4b 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -72,7 +72,7 @@ HAVE_SEEK_DATA = @have_seek_data@
>  HAVE_NFTW = @have_nftw@
>  HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
>  HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
> -HAVE_FIEXCHANGE = @have_fiexchange@
> +HAVE_XFS_IOC_EXCHANGE_RANGE = @have_xfs_ioc_exchange_range@
>  HAVE_FICLONE = @have_ficlone@
>  
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
> diff --git a/ltp/Makefile b/ltp/Makefile
> index c2b70d896e..c0b2824076 100644
> --- a/ltp/Makefile
> +++ b/ltp/Makefile
> @@ -36,8 +36,8 @@ ifeq ($(HAVE_COPY_FILE_RANGE),yes)
>  LCFLAGS += -DHAVE_COPY_FILE_RANGE
>  endif
>  
> -ifeq ($(HAVE_FIEXCHANGE),yes)
> -LCFLAGS += -DHAVE_FIEXCHANGE
> +ifeq ($(HAVE_XFS_IOC_EXCHANGE_RANGE),yes)
> +LCFLAGS += -DHAVE_XFS_IOC_EXCHANGE_RANGE
>  endif
>  
>  default: depend $(TARGETS)
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index abe2874253..2681ed2b08 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -2592,8 +2592,8 @@ xchgrange_f(
>  	opnum_t			opno,
>  	long			r)
>  {
> -#ifdef FIEXCHANGE_RANGE
> -	struct file_xchg_range	fxr = { 0 };
> +#ifdef XFS_IOC_EXCHANGE_RANGE
> +	struct xfs_exch_range	fxr = { 0 };
>  	static __u64		swap_flags = 0;
>  	struct pathname		fpath1;
>  	struct pathname		fpath2;
> @@ -2721,10 +2721,10 @@ xchgrange_f(
>  	fxr.flags = swap_flags;
>  
>  retry:
> -	ret = ioctl(fd2, FIEXCHANGE_RANGE, &fxr);
> +	ret = ioctl(fd2, XFS_IOC_EXCHANGE_RANGE, &fxr);
>  	e = ret < 0 ? errno : 0;
> -	if (e == EOPNOTSUPP && !(swap_flags & FILE_XCHG_RANGE_NONATOMIC)) {
> -		swap_flags = FILE_XCHG_RANGE_NONATOMIC;
> +	if (e == EOPNOTSUPP && !(swap_flags & XFS_EXCH_RANGE_NONATOMIC)) {
> +		swap_flags = XFS_EXCH_RANGE_NONATOMIC;
>  		fxr.flags |= swap_flags;
>  		goto retry;
>  	}
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index a30e2a8dbc..777ba0de5d 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -1389,27 +1389,27 @@ do_insert_range(unsigned offset, unsigned length)
>  }
>  #endif
>  
> -#ifdef FIEXCHANGE_RANGE
> +#ifdef XFS_IOC_EXCHANGE_RANGE
>  static __u64 swap_flags = 0;
>  
>  int
>  test_xchg_range(void)
>  {
> -	struct file_xchg_range	fsr = {
> +	struct xfs_exch_range	fsr = {
>  		.file1_fd = fd,
> -		.flags = FILE_XCHG_RANGE_DRY_RUN | swap_flags,
> +		.flags = XFS_EXCH_RANGE_DRY_RUN | swap_flags,
>  	};
>  	int ret, e;
>  
>  retry:
> -	ret = ioctl(fd, FIEXCHANGE_RANGE, &fsr);
> +	ret = ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &fsr);
>  	e = ret < 0 ? errno : 0;
> -	if (e == EOPNOTSUPP && !(swap_flags & FILE_XCHG_RANGE_NONATOMIC)) {
> +	if (e == EOPNOTSUPP && !(swap_flags & XFS_EXCH_RANGE_NONATOMIC)) {
>  		/*
>  		 * If the call fails with atomic mode, try again with non
>  		 * atomic mode.
>  		 */
> -		swap_flags = FILE_XCHG_RANGE_NONATOMIC;
> +		swap_flags = XFS_EXCH_RANGE_NONATOMIC;
>  		fsr.flags |= swap_flags;
>  		goto retry;
>  	}
> @@ -1427,7 +1427,7 @@ test_xchg_range(void)
>  void
>  do_xchg_range(unsigned offset, unsigned length, unsigned dest)
>  {
> -	struct file_xchg_range	fsr = {
> +	struct xfs_exch_range	fsr = {
>  		.file1_fd = fd,
>  		.file1_offset = offset,
>  		.file2_offset = dest,
> @@ -1470,10 +1470,10 @@ do_xchg_range(unsigned offset, unsigned length, unsigned dest)
>  			testcalls, offset, offset+length, length, dest);
>  	}
>  
> -	if (ioctl(fd, FIEXCHANGE_RANGE, &fsr) == -1) {
> +	if (ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &fsr) == -1) {
>  		prt("exchange range: 0x%x to 0x%x at 0x%x\n", offset,
>  				offset + length, dest);
> -		prterr("do_xchg_range: FIEXCHANGE_RANGE");
> +		prterr("do_xchg_range: XFS_IOC_EXCHANGE_RANGE");
>  		report_failure(161);
>  		goto out_free;
>  	}
> @@ -2452,7 +2452,7 @@ usage(void)
>  #ifdef HAVE_COPY_FILE_RANGE
>  "	-E: Do not use copy range calls\n"
>  #endif
> -#ifdef FIEXCHANGE_RANGE
> +#ifdef XFS_IOC_EXCHANGE_RANGE
>  "	-0: Do not use exchange range calls\n"
>  #endif
>  "	-K: Do not use keep size\n\
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 91eb64db21..d5d88b8e44 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -155,25 +155,6 @@ AC_DEFUN([AC_HAVE_RLIMIT_NOFILE],
>      AC_SUBST(have_rlimit_nofile)
>    ])
>  
> -#
> -# Check if we have a FIEXCHANGE_RANGE ioctl (Linux)
> -#
> -AC_DEFUN([AC_HAVE_FIEXCHANGE],
> -  [ AC_MSG_CHECKING([for FIEXCHANGE_RANGE])
> -    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
> -#define _GNU_SOURCE
> -#include <sys/syscall.h>
> -#include <sys/ioctl.h>
> -#include <unistd.h>
> -#include <linux/fs.h>
> -#include <linux/fiexchange.h>
> -    ]], [[
> -         struct file_xchg_range fxr;
> -         ioctl(-1, FIEXCHANGE_RANGE, &fxr);
> -    ]])],[have_fiexchange=yes
> -       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
> -    AC_SUBST(have_fiexchange)
> -
>  # Check if we have FICLONE
>  AC_DEFUN([AC_HAVE_FICLONE],
>    [ AC_MSG_CHECKING([for FICLONE])
> diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
> index 8ef58cc064..1549360df6 100644
> --- a/m4/package_xfslibs.m4
> +++ b/m4/package_xfslibs.m4
> @@ -119,3 +119,17 @@ AC_DEFUN([AC_HAVE_BMV_OF_SHARED],
>         AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
>      AC_SUBST(have_bmv_of_shared)
>    ])
> +
> +# Check if we have XFS_IOC_EXCHANGE_RANGE
> +AC_DEFUN([AC_HAVE_XFS_IOC_EXCHANGE_RANGE],
> +  [ AC_MSG_CHECKING([for XFS_IOC_EXCHANGE_RANGE])
> +    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
> +#define _GNU_SOURCE
> +#include <xfs/xfs.h>
> +    ]], [[
> +         struct xfs_exch_range obj;
> +         ioctl(-1, XFS_IOC_EXCHANGE_RANGE, &obj);
> +    ]])],[have_xfs_ioc_exchange_range=yes
> +       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
> +    AC_SUBST(have_xfs_ioc_exchange_range)
> +  ])
> diff --git a/src/Makefile b/src/Makefile
> index 49dd2f6c1e..8160a0e8ec 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -98,6 +98,10 @@ ifeq ($(HAVE_FICLONE),yes)
>       TARGETS += t_reflink_read_race
>  endif
>  
> +ifeq ($(HAVE_XFS_IOC_EXCHANGE_RANGE),yes)
> +LCFLAGS += -DHAVE_XFS_IOC_EXCHANGE_RANGE
> +endif
> +
>  CFILES = $(TARGETS:=.c)
>  LDIRT = $(TARGETS) fssum
>  
> diff --git a/src/fiexchange.h b/src/fiexchange.h
> index 29b3ac0ff5..6a3ae8964d 100644
> --- a/src/fiexchange.h
> +++ b/src/fiexchange.h
> @@ -16,13 +16,13 @@
>   * called against (which we'll call file2).  Filesystems must be able to
>   * restart and complete the operation even after the system goes down.
>   */
> -struct file_xchg_range {
> +struct xfs_exch_range {
>  	__s64		file1_fd;
>  	__s64		file1_offset;	/* file1 offset, bytes */
>  	__s64		file2_offset;	/* file2 offset, bytes */
>  	__s64		length;		/* bytes to exchange */
>  
> -	__u64		flags;		/* see FILE_XCHG_RANGE_* below */
> +	__u64		flags;		/* see XFS_EXCH_RANGE_* below */
>  
>  	/* file2 metadata for optional freshness checks */
>  	__s64		file2_ino;	/* inode number */
> @@ -38,39 +38,39 @@ struct file_xchg_range {
>   * Atomic exchange operations are not required.  This relaxes the requirement
>   * that the filesystem must be able to complete the operation after a crash.
>   */
> -#define FILE_XCHG_RANGE_NONATOMIC	(1 << 0)
> +#define XFS_EXCH_RANGE_NONATOMIC	(1 << 0)
>  
>  /*
>   * Check that file2's inode number, mtime, and ctime against the values
>   * provided, and return -EBUSY if there isn't an exact match.
>   */
> -#define FILE_XCHG_RANGE_FILE2_FRESH	(1 << 1)
> +#define XFS_EXCH_RANGE_FILE2_FRESH	(1 << 1)
>  
>  /*
>   * Check that the file1's length is equal to file1_offset + length, and that
>   * file2's length is equal to file2_offset + length.  Returns -EDOM if there
>   * isn't an exact match.
>   */
> -#define FILE_XCHG_RANGE_FULL_FILES	(1 << 2)
> +#define XFS_EXCH_RANGE_FULL_FILES	(1 << 2)
>  
>  /*
>   * Exchange file data all the way to the ends of both files, and then exchange
>   * the file sizes.  This flag can be used to replace a file's contents with a
>   * different amount of data.  length will be ignored.
>   */
> -#define FILE_XCHG_RANGE_TO_EOF		(1 << 3)
> +#define XFS_EXCH_RANGE_TO_EOF		(1 << 3)
>  
>  /* Flush all changes in file data and file metadata to disk before returning. */
> -#define FILE_XCHG_RANGE_FSYNC		(1 << 4)
> +#define XFS_EXCH_RANGE_FSYNC		(1 << 4)
>  
>  /* Dry run; do all the parameter verification but do not change anything. */
> -#define FILE_XCHG_RANGE_DRY_RUN		(1 << 5)
> +#define XFS_EXCH_RANGE_DRY_RUN		(1 << 5)
>  
>  /*
> - * Do not exchange any part of the range where file1's mapping is a hole.  This
> - * can be used to emulate scatter-gather atomic writes with a temp file.
> + * Only exchange ranges where file1's range maps to a written extent.  This can
> + * be used to emulate scatter-gather atomic writes with a temp file.
>   */
> -#define FILE_XCHG_RANGE_SKIP_FILE1_HOLES (1 << 6)
> +#define XFS_EXCH_RANGE_FILE1_WRITTEN	(1 << 6)
>  
>  /*
>   * Commit the contents of file1 into file2 if file2 has the same inode number,
> @@ -83,19 +83,19 @@ struct file_xchg_range {
>   * commit is complete.
>   *
>   * This flag should not be combined with NONATOMIC.  It can be combined with
> - * SKIP_FILE1_HOLES.
> + * FILE1_WRITTEN.
>   */
> -#define FILE_XCHG_RANGE_COMMIT		(FILE_XCHG_RANGE_FILE2_FRESH | \
> -					 FILE_XCHG_RANGE_FSYNC)
> +#define XFS_EXCH_RANGE_COMMIT		(XFS_EXCH_RANGE_FILE2_FRESH | \
> +					 XFS_EXCH_RANGE_FSYNC)
>  
> -#define FILE_XCHG_RANGE_ALL_FLAGS	(FILE_XCHG_RANGE_NONATOMIC | \
> -					 FILE_XCHG_RANGE_FILE2_FRESH | \
> -					 FILE_XCHG_RANGE_FULL_FILES | \
> -					 FILE_XCHG_RANGE_TO_EOF | \
> -					 FILE_XCHG_RANGE_FSYNC | \
> -					 FILE_XCHG_RANGE_DRY_RUN | \
> -					 FILE_XCHG_RANGE_SKIP_FILE1_HOLES)
> +#define XFS_EXCH_RANGE_ALL_FLAGS	(XFS_EXCH_RANGE_NONATOMIC | \
> +					 XFS_EXCH_RANGE_FILE2_FRESH | \
> +					 XFS_EXCH_RANGE_FULL_FILES | \
> +					 XFS_EXCH_RANGE_TO_EOF | \
> +					 XFS_EXCH_RANGE_FSYNC | \
> +					 XFS_EXCH_RANGE_DRY_RUN | \
> +					 XFS_EXCH_RANGE_FILE1_WRITTEN)
>  
> -#define FIEXCHANGE_RANGE	_IOWR('X', 129, struct file_xchg_range)
> +#define XFS_IOC_EXCHANGE_RANGE	_IOWR('X', 129, struct xfs_exch_range)
>  
>  #endif /* _LINUX_FIEXCHANGE_H */
> diff --git a/src/global.h b/src/global.h
> index 49570ef117..4f92308d6c 100644
> --- a/src/global.h
> +++ b/src/global.h
> @@ -171,9 +171,7 @@
>  #include <sys/mman.h>
>  #endif
>  
> -#ifdef HAVE_FIEXCHANGE
> -# include <linux/fiexchange.h>
> -#else
> +#ifndef HAVE_XFS_IOC_EXCHANGE_RANGE
>  # include "fiexchange.h"
>  #endif
>  
> diff --git a/src/vfs/Makefile b/src/vfs/Makefile
> index 4841da1286..868540f578 100644
> --- a/src/vfs/Makefile
> +++ b/src/vfs/Makefile
> @@ -19,6 +19,10 @@ ifeq ($(HAVE_URING), true)
>  LLDLIBS += -luring
>  endif
>  
> +ifeq ($(HAVE_XFS_IOC_EXCHANGE_RANGE),yes)
> +LCFLAGS += -DHAVE_XFS_IOC_EXCHANGE_RANGE
> +endif
> +
>  default: depend $(TARGETS)
>  
>  depend: .dep
> diff --git a/tests/generic/724 b/tests/generic/724
> index 8d7dc4e12a..67e0dba446 100755
> --- a/tests/generic/724
> +++ b/tests/generic/724
> @@ -5,7 +5,7 @@
>  # FS QA Test No. 724
>  #
>  # Test scatter-gather atomic file writes.  We create a temporary file, write
> -# sparsely to it, then use FILE_SWAP_RANGE_SKIP_FILE1_HOLES flag to swap
> +# sparsely to it, then use XFS_EXCH_RANGE_FILE1_WRITTEN flag to swap
>  # atomicallly only the ranges that we wrote.
>  
>  . ./common/preamble
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index 21549db7fd..89f7b735b0 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -90,6 +90,7 @@ sizeof(struct xfs_disk_dquot) = 104
>  sizeof(struct xfs_dqblk) = 136
>  sizeof(struct xfs_dsb) = 264
>  sizeof(struct xfs_dsymlink_hdr) = 56
> +sizeof(struct xfs_exch_range) = 120
>  sizeof(struct xfs_extent_data) = 24
>  sizeof(struct xfs_extent_data_info) = 32
>  sizeof(struct xfs_fs_eofblocks) = 128
> diff --git a/tests/xfs/791 b/tests/xfs/791
> index d82314ee08..4944c1517c 100755
> --- a/tests/xfs/791
> +++ b/tests/xfs/791
> @@ -5,7 +5,7 @@
>  # FS QA Test No. 791
>  #
>  # Test scatter-gather atomic file writes.  We create a temporary file, write
> -# sparsely to it, then use FILE_SWAP_RANGE_SKIP_FILE1_HOLES flag to swap
> +# sparsely to it, then use XFS_EXCH_RANGE_FILE1_WRITTEN flag to swap
>  # atomicallly only the ranges that we wrote.  Inject an error so that we can
>  # test that log recovery finishes the swap.
>  
> 

