Return-Path: <linux-xfs+bounces-6321-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 828B689D117
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Apr 2024 05:34:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32470285DF5
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Apr 2024 03:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79C8657CF;
	Tue,  9 Apr 2024 03:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejqSQ8zv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D64657A3;
	Tue,  9 Apr 2024 03:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712633682; cv=none; b=UqbEoDFL0XdQahSXRUHnKk1YzzmP3TSMNsOeKe5Mx4Ia8/RwFhqWhWDUgl+//NDmbiZjTPWF9cB9G/tLOdHFgnIljVs4LoRTyw3OwhMOrk6nc0o454YBWa/stx/YA5WWIxtBu7Brn67XEwMJ1ZHpxMBDAo4oCzgyKcDYwj/CNvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712633682; c=relaxed/simple;
	bh=7lLGsmW8tm03KH5MAOuOHaYBRFJCG49gSbIsENep5g8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=TgFyN9v384F4kIKhX0jlj6VOTE6U3SZW5boFa5YMZgs58bYNyAD+BC2/oeInF9TgthQExwMawIpYqOVffiT9OvR+Ui9TtEsO38Ha0BsXuTguk4yH6NrZWrEB00KubClKSJbF+2gN4ESDd3YfkIXHFiRfKKUruUHR6e+gz4PRjDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejqSQ8zv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F2BC433F1;
	Tue,  9 Apr 2024 03:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712633681;
	bh=7lLGsmW8tm03KH5MAOuOHaYBRFJCG49gSbIsENep5g8=;
	h=Date:Subject:From:To:Cc:From;
	b=ejqSQ8zv115fkEvXgzuOVQe36lb5IabWInTF2qpQUVweyZqpgY87kz+CLPpaKnlx5
	 /oA9HBMK0dH1JoLrnwQXbt4XTl084kOwQwopFWsZ33dVjjoV6q5+RBudwWdkACfmgw
	 ZLESuAzgguBUGJxFhIW20IIlRa8OgH+nhMlYcgLwnw3DyXJVWmHXlNRtgjq8BfjTwZ
	 YoSwRJAImZTxfKPmyXrYRvM75299TC/HJ5ojPWt7q1DaLTz6dUARailIMtPKPW/nZK
	 wLW8yZeFWzkuPFYdhwDJ80o91pQ5+9qU5A8EVnIkTb2q0Xs5Xq7LnZls6XY221sHgm
	 hXvJ+jhJ485fw==
Date: Mon, 08 Apr 2024 20:34:40 -0700
Subject: [PATCHSET v30.2] xfs: atomic file content exchanges
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, hch@lst.de,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <171263348423.2978056.309570547736145336.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi all,

This series creates a new XFS_IOC_EXCHANGE_RANGE ioctl to exchange
ranges of bytes between two files atomically.  This differs from
v30.1 by switching the feature bit to INCOMPAT from INCOMPAT_LOG.

This new functionality enables data storage programs to stage and commit
file updates such that reader programs will see either the old contents
or the new contents in their entirety, with no chance of torn writes.  A
successful call completion guarantees that the new contents will be seen
even if the system fails.

The ability to exchange file fork mappings between files in this manner
is critical to supporting online filesystem repair, which is built upon
the strategy of constructing a clean copy of a damaged structure and
committing the new structure into the metadata file atomically.  The
ioctls exist to facilitate testing of the new functionality and to
enable future application program designs.

User programs will be able to update files atomically by opening an
O_TMPFILE, reflinking the source file to it, making whatever updates
they want to make, and exchange the relevant ranges of the temp file
with the original file.  If the updates are aligned with the file block
size, a new (since v2) flag provides for exchanging only the written
areas.  Note that application software must quiesce writes to the file
while it stages an atomic update.  This will be addressed by a
subsequent series.

This mechanism solves the clunkiness of two existing atomic file update
mechanisms: for O_TRUNC + rewrite, this eliminates the brief period
where other programs can see an empty file.  For create tempfile +
rename, the need to copy file attributes and extended attributes for
each file update is eliminated.

However, this method introduces its own awkwardness -- any program
initiating an exchange now needs to have a way to signal to other
programs that the file contents have changed.  For file access mediated
via read and write, fanotify or inotify are probably sufficient.  For
mmaped files, that may not be fast enough.

Here is the proposed manual page:

IOCTL-XFS-EXCHANGE-RANGE(2System Calls ManuIOCTL-XFS-EXCHANGE-RANGE(2)

NAME
       ioctl_xfs_exchange_range  -  exchange  the contents of parts of
       two files

SYNOPSIS
       #include <sys/ioctl.h>
       #include <xfs/xfs_fs.h>

       int ioctl(int file2_fd, XFS_IOC_EXCHANGE_RANGE, struct  xfs_ex‐
       change_range *arg);

DESCRIPTION
       Given  a  range  of bytes in a first file file1_fd and a second
       range of bytes in a second file  file2_fd,  this  ioctl(2)  ex‐
       changes the contents of the two ranges.

       Exchanges  are  atomic  with  regards to concurrent file opera‐
       tions.  Implementations must guarantee that readers see  either
       the old contents or the new contents in their entirety, even if
       the system fails.

       The system call parameters are conveyed in  structures  of  the
       following form:

           struct xfs_exchange_range {
               __s32    file1_fd;
               __u32    pad;
               __u64    file1_offset;
               __u64    file2_offset;
               __u64    length;
               __u64    flags;
           };

       The field pad must be zero.

       The  fields file1_fd, file1_offset, and length define the first
       range of bytes to be exchanged.

       The fields file2_fd, file2_offset, and length define the second
       range of bytes to be exchanged.

       Both  files must be from the same filesystem mount.  If the two
       file descriptors represent the same file, the byte ranges  must
       not  overlap.   Most  disk-based  filesystems  require that the
       starts of both ranges must be aligned to the file  block  size.
       If  this  is  the  case, the ends of the ranges must also be so
       aligned unless the XFS_EXCHANGE_RANGE_TO_EOF flag is set.

       The field flags control the behavior of the exchange operation.

           XFS_EXCHANGE_RANGE_TO_EOF
                  Ignore the length parameter.  All bytes in  file1_fd
                  from  file1_offset to EOF are moved to file2_fd, and
                  file2's size is set to  (file2_offset+(file1_length-
                  file1_offset)).   Meanwhile, all bytes in file2 from
                  file2_offset to EOF are moved to file1  and  file1's
                  size    is   set   to   (file1_offset+(file2_length-
                  file2_offset)).

           XFS_EXCHANGE_RANGE_DSYNC
                  Ensure that all modified in-core data in  both  file
                  ranges  and  all  metadata updates pertaining to the
                  exchange operation are flushed to persistent storage
                  before  the  call  returns.  Opening either file de‐
                  scriptor with O_SYNC or O_DSYNC will have  the  same
                  effect.

           XFS_EXCHANGE_RANGE_FILE1_WRITTEN
                  Only  exchange sub-ranges of file1_fd that are known
                  to contain data  written  by  application  software.
                  Each  sub-range  may  be  expanded (both upwards and
                  downwards) to align with the file  allocation  unit.
                  For files on the data device, this is one filesystem
                  block.  For files on the realtime  device,  this  is
                  the realtime extent size.  This facility can be used
                  to implement fast atomic  scatter-gather  writes  of
                  any  complexity for software-defined storage targets
                  if all writes are aligned  to  the  file  allocation
                  unit.

           XFS_EXCHANGE_RANGE_DRY_RUN
                  Check  the parameters and the feasibility of the op‐
                  eration, but do not change anything.

RETURN VALUE
       On error, -1 is returned, and errno is set to indicate the  er‐
       ror.

ERRORS
       Error  codes can be one of, but are not limited to, the follow‐
       ing:

       EBADF  file1_fd is not open for reading and writing or is  open
              for  append-only  writes;  or  file2_fd  is not open for
              reading and writing or is open for append-only writes.

       EINVAL The parameters are not correct for  these  files.   This
              error  can  also appear if either file descriptor repre‐
              sents a device, FIFO, or socket.  Disk filesystems  gen‐
              erally  require  the  offset  and length arguments to be
              aligned to the fundamental block sizes of both files.

       EIO    An I/O error occurred.

       EISDIR One of the files is a directory.

       ENOMEM The kernel was unable to allocate sufficient  memory  to
              perform the operation.

       ENOSPC There  is  not  enough  free space in the filesystem ex‐
              change the contents safely.

       EOPNOTSUPP
              The filesystem does not support exchanging bytes between
              the two files.

       EPERM  file1_fd or file2_fd are immutable.

       ETXTBSY
              One of the files is a swap file.

       EUCLEAN
              The filesystem is corrupt.

       EXDEV  file1_fd  and  file2_fd  are  not  on  the  same mounted
              filesystem.

CONFORMING TO
       This API is XFS-specific.

USE CASES
       Several use cases are imagined for this system  call.   In  all
       cases, application software must coordinate updates to the file
       because the exchange is performed unconditionally.

       The first is a data storage program that wants to  commit  non-
       contiguous  updates  to a file atomically and coordinates write
       access to that file.  This can be done by creating a  temporary
       file, calling FICLONE(2) to share the contents, and staging the
       updates into the temporary file.  The FULL_FILES flag is recom‐
       mended  for this purpose.  The temporary file can be deleted or
       punched out afterwards.

       An example program might look like this:

           int fd = open("/some/file", O_RDWR);
           int temp_fd = open("/some", O_TMPFILE | O_RDWR);

           ioctl(temp_fd, FICLONE, fd);

           /* append 1MB of records */
           lseek(temp_fd, 0, SEEK_END);
           write(temp_fd, data1, 1000000);

           /* update record index */
           pwrite(temp_fd, data1, 600, 98765);
           pwrite(temp_fd, data2, 320, 54321);
           pwrite(temp_fd, data2, 15, 0);

           /* commit the entire update */
           struct xfs_exchange_range args = {
               .file1_fd = temp_fd,
               .flags = XFS_EXCHANGE_RANGE_TO_EOF,
           };

           ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &args);

       The second is a software-defined  storage  host  (e.g.  a  disk
       jukebox)  which  implements an atomic scatter-gather write com‐
       mand.  Provided the exported disk's logical block size  matches
       the file's allocation unit size, this can be done by creating a
       temporary file and writing the data at the appropriate offsets.
       It  is  recommended that the temporary file be truncated to the
       size of the regular file before any writes are  staged  to  the
       temporary  file  to avoid issues with zeroing during EOF exten‐
       sion.  Use this call with the FILE1_WRITTEN  flag  to  exchange
       only  the  file  allocation  units involved in the emulated de‐
       vice's write command.  The temporary file should  be  truncated
       or  punched out completely before being reused to stage another
       write.

       An example program might look like this:

           int fd = open("/some/file", O_RDWR);
           int temp_fd = open("/some", O_TMPFILE | O_RDWR);
           struct stat sb;
           int blksz;

           fstat(fd, &sb);
           blksz = sb.st_blksize;

           /* land scatter gather writes between 100fsb and 500fsb */
           pwrite(temp_fd, data1, blksz * 2, blksz * 100);
           pwrite(temp_fd, data2, blksz * 20, blksz * 480);
           pwrite(temp_fd, data3, blksz * 7, blksz * 257);

           /* commit the entire update */
           struct xfs_exchange_range args = {
               .file1_fd = temp_fd,
               .file1_offset = blksz * 100,
               .file2_offset = blksz * 100,
               .length       = blksz * 400,
               .flags        = XFS_EXCHANGE_RANGE_FILE1_WRITTEN |
                               XFS_EXCHANGE_RANGE_FILE1_DSYNC,
           };

           ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &args);

NOTES
       Some filesystems may limit the amount of data or the number  of
       extents that can be exchanged in a single call.

SEE ALSO
       ioctl(2)

XFS                           2024-02-10   IOCTL-XFS-EXCHANGE-RANGE(2)

The reference implementation in XFS creates a new log incompat feature
and log intent items to track high level progress of swapping ranges of
two files and finish interrupted work if the system goes down.  Sample
code can be found in the corresponding changes to xfs_io to exercise the
use case mentioned above.

Note that this function is /not/ the O_DIRECT atomic untorn file writes
concept that has also been floating around for years.  It is also not
the RWF_ATOMIC patchset that has been shared.  This RFC is constructed
entirely in software, which means that there are no limitations other
than the general filesystem limits.

As a side note, the original motivation behind the kernel functionality
is online repair of file-based metadata.  The atomic file content
exchange is implemented as an atomic exchange of file fork mappings,
which means that we can implement online reconstruction of extended
attributes and directories by building a new one in another inode and
exchanging the contents.

Subsequent patchsets adapt the online filesystem repair code to use
atomic file exchanges.  This enables repair functions to construct a
clean copy of a directory, xattr information, symbolic links, realtime
bitmaps, and realtime summary information in a temporary inode.  If this
completes successfully, the new contents can be committed atomically
into the inode being repaired.  This is essential to avoid making
corruption problems worse if the system goes down in the middle of
running repair.

For userspace, this series also includes the userspace pieces needed to
test the new functionality, and a sample implementation of atomic file
updates.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-file-updates

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-file-updates

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=atomic-file-updates

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=atomic-file-updates
---
Commits in this patchset:
 * vfs: export remap and write check helpers
 * xfs: introduce new file range exchange ioctl
 * xfs: create a incompat flag for atomic file mapping exchanges
 * xfs: introduce a file mapping exchange log intent item
 * xfs: create deferred log items for file mapping exchanges
 * xfs: bind together the front and back ends of the file range exchange code
 * xfs: add error injection to test file mapping exchange recovery
 * xfs: condense extended attributes after a mapping exchange operation
 * xfs: condense directories after a mapping exchange operation
 * xfs: condense symbolic links after a mapping exchange operation
 * xfs: make file range exchange support realtime files
 * xfs: support non-power-of-two rtextsize with exchange-range
 * docs: update swapext -> exchmaps language
 * xfs: enable logged file mapping exchange feature
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |  259 ++--
 fs/read_write.c                                    |    1 
 fs/remap_range.c                                   |    4 
 fs/xfs/Makefile                                    |    3 
 fs/xfs/libxfs/xfs_defer.c                          |    6 
 fs/xfs/libxfs/xfs_defer.h                          |    2 
 fs/xfs/libxfs/xfs_errortag.h                       |    4 
 fs/xfs/libxfs/xfs_exchmaps.c                       | 1237 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_exchmaps.h                       |  123 ++
 fs/xfs/libxfs/xfs_format.h                         |   26 
 fs/xfs/libxfs/xfs_fs.h                             |   42 +
 fs/xfs/libxfs/xfs_log_format.h                     |   64 +
 fs/xfs/libxfs/xfs_log_recover.h                    |    2 
 fs/xfs/libxfs/xfs_sb.c                             |    5 
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   47 +
 fs/xfs/libxfs/xfs_symlink_remote.h                 |    1 
 fs/xfs/libxfs/xfs_trans_space.h                    |    4 
 fs/xfs/xfs_error.c                                 |    3 
 fs/xfs/xfs_exchmaps_item.c                         |  599 ++++++++++
 fs/xfs/xfs_exchmaps_item.h                         |   64 +
 fs/xfs/xfs_exchrange.c                             |  769 ++++++++++++
 fs/xfs/xfs_exchrange.h                             |   42 +
 fs/xfs/xfs_ioctl.c                                 |   38 +
 fs/xfs/xfs_log_recover.c                           |    2 
 fs/xfs/xfs_mount.h                                 |    7 
 fs/xfs/xfs_super.c                                 |   23 
 fs/xfs/xfs_symlink.c                               |   49 -
 fs/xfs/xfs_trace.c                                 |    2 
 fs/xfs/xfs_trace.h                                 |  381 ++++++
 include/linux/fs.h                                 |    1 
 30 files changed, 3624 insertions(+), 186 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_exchmaps.c
 create mode 100644 fs/xfs/libxfs/xfs_exchmaps.h
 create mode 100644 fs/xfs/xfs_exchmaps_item.c
 create mode 100644 fs/xfs/xfs_exchmaps_item.h
 create mode 100644 fs/xfs/xfs_exchrange.c
 create mode 100644 fs/xfs/xfs_exchrange.h


