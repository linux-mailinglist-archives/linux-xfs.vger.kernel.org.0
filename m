Return-Path: <linux-xfs+bounces-19671-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43150A39495
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2025 09:12:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FE041888B89
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2025 08:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02B822AE76;
	Tue, 18 Feb 2025 08:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aqZJ8EdV"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7291FF1B4
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866322; cv=none; b=AQ58NXmF1ZfdkRox5Y+ioMt+/96nMnrWG3jyFRmOdTHQLjsqMIy3nik0XiZRDPaMkCaEV7oggGF6QtTQ9qGx7nwZv/V+T0gojIpG8QjCmcWKx5l6Y/c91r/sg0gnbn0MPgb0EI4zwBRp1aO8rjJk3QKx7Hwn4P8rNYgVSlfjwNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866322; c=relaxed/simple;
	bh=TAMz2Rgdyoin+zKnAje7H5pc6TUcH1/T5eex6fBMkOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tdiJV337cxoyF31w7fMsg5bv9wB6WLi+7ifVJwpkyMRi42T+YELy/ivs1VRp5GxizfpkFJ475+xCwjscEgz5Sg5WM+bzduaa3oOjgxE+l3rQnf9h2F6MAv7fFRG5AMJlcVvPQoWQvABwGkH3f9yItbRe3fER/algXUjz560fndA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aqZJ8EdV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=j2IPgmA+phYCDPZS/ro6L5A5w86SUxrlMCyMdZ9ImRI=; b=aqZJ8EdVr0hl3h0bX8gJO0aDGf
	PqsWKdPANMHRJdTUFS0d+qiP7Gr4sMNApqc7xOO8VLyizhZwoOKChD8Eo8g2PC+yISINDdQnOALqN
	Y+qYy9huQLVL1eCt7IWHi9p7r2cW/QV1QTgbV4dpUohgyJ0Ozm/i+ZV0j5x8Rhc9/1X9gFvrcuZY1
	WDtskEROYdV7petVsBcVXAupaOf9CDGgVsqCKC51ueuylHbDqH+nwQ3MxFJLjqvdL6DjnENkWTRVz
	pwUyjsmgcoWVJ9ZRJX2DBRdxDXpvQPD8Z4JL0Z8jI8eexYnP3rDcgA55n3hO/545ZCWn7RoWuqEBs
	iiP6DDWg==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIhw-00000007CFd-3ipa;
	Tue, 18 Feb 2025 08:11:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: support for zoned devices v3
Date: Tue, 18 Feb 2025 09:10:03 +0100
Message-ID: <20250218081153.3889537-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series adds support for zoned devices:

    https://zonedstorage.io/docs/introduction/zoned-storage

to XFS. It has been developed for and tested on both SMR hard drives,
which are the oldest and most common class of zoned devices:

   https://zonedstorage.io/docs/introduction/smr

and ZNS SSDs:

   https://zonedstorage.io/docs/introduction/zns

It has not been tested with zoned UFS devices, as their current capacity
points and performance characteristics aren't too interesting for XFS
use cases (but never say never).

Sequential write only zones are only supported for data using a new
allocator for the RT device, which maps each zone to a rtgroup which
is written sequentially.  All metadata and (for now) the log require
using randomly writable space. This means a realtime device is required
to support zoned storage, but for the common case of SMR hard drives
that contain random writable zones and sequential write required zones
on the same block device, the concept of an internal RT device is added
which means using XFS on a SMR HDD is as simple as:

$ mkfs.xfs /dev/sda
$ mount /dev/sda /mnt

When using NVMe ZNS SSDs that do not support conventional zones, the
traditional multi-device RT configuration is required.  E.g. for an
SSD with a conventional namespace 1 and a zoned namespace 2:

$ mkfs.xfs /dev/nvme0n1 -o rtdev=/dev/nvme0n2
$ mount -o rtdev=/dev/nvme0n2 /dev/nvme0n1 /mnt

The zoned allocator can also be used on conventional block devices, or
on conventional zones (e.g. when using an SMR HDD as the external RT
device).  For example using zoned XFS on normal SSDs shows very nice
performance advantages and write amplification reduction for intelligent
workloads like RocksDB.

Some work is still in progress or planned, but should not affect the
integration with the rest of XFS or the on-disk format:

 - support for quotas
 - support for reflinks - the I/O path already supports them, but
   garbage collection currently isn't refcount aware and would unshare
   them, rendering the feature useless
 - more scalable garbage collection victim selection
 - various improvements to hint based data placement

To make testing easier a git tree is provided that has the required
iomap changes that we merged through the VFS tree, this code and a
few misc patches that make VM testing easier:

    git://git.infradead.org/users/hch/xfs.git xfs-zoned

The matching xfsprogs is available here:

    git://git.infradead.org/users/hch/xfsprogs.git xfs-zoned

An xfstests branch to enable the zoned code, and with various new tests
is here:

    git://git.infradead.org/users/hch/xfstests-dev.git xfs-zoned

An updated xfs-documentation branch documenting the on-disk format is
here:

    git://git.infradead.org/users/hch/xfs-documentation.git xfs-zoned

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-zoned
    http://git.infradead.org/users/hch/xfsprogs.git/shortlog/refs/heads/xfs-zoned
    http://git.infradead.org/users/hch/xfstests-dev.git/shortlog/refs/heads/xfs-zoned
    http://git.infradead.org/users/hch/xfs-documentation.git/shortlog/refs/heads/xfs-zoned

Changes since RFCv2:
 - split the freecounter changes into two patches and changed the
   structure to have a single array with a struct as entry for the
   percpu counter and the reserved blocks fields
 - split up the global metabtree reservation patch
 - fix fixing up the metabtree reservation when rebuilding metabtrees
 - guard the sysfs code with IS_ENABLED(CONFIG_XFS_RT)
 - make the in-core sb_rtstart an xfs_rfsblock_t
 - remove very verbose printks
 - improve a few tracepoints to include more information
 - move a few hunks to earlier patches
 - use an if/else block in xfs_vm_writepages to keep the context
 - use vmalloc for zi_used_bucket_bitmap
   in it's own block
 - improve a comment message
 - more typo and whitespace fixin'

Changes since RFC:
 - rebased to current Linus' tree that has rtrmap and rtreflink merged
 - adjust for minor changes in the iomap series
 - add one more caller of rtg_rmap
 - comment on the sb_dblocks access in statfs
 - use xfs_inode_alloc_unitsize to report dio alignments
 - improve various commit messages
 - misc spelling fixes
 - misc whitespace fixes
 - add separate helpers for raw vs always positive free space counters
 - print the pool name when reservations failed
 - return bool from xfs_zone_validate
 - use more rtg locking helpers
 - use more XFS_IS_CORRUPT
 - misc cleanups and minor renames
 - document the XFS_ZR_* constants
 - rename the IN_GC flag
 - make gc_bio.state an enum
 - don't join rtg to empty transaction in xfs_zone_gc_query
 - update copyrights
 - better inode and sb verifiers
 - allocate GC thread specific data outside the thread
 - clean up GC naming and add more comments
 - use the cmp_int trick
 - rework zone list locking a bit to avoid kmallocing under a spinlock
 - export rtstart in the fsgeometry in fsblocks
 - use buckets to speed up GC victim selection
 - stop the GC thread when freezing the file system
 - drop an assert that was racy
 - move some code additions between patches in the series
 - keep an active open zone reference for outstanding I/O
 - handle the case of all using all available open zones and an an
   open GC at shutdown at mount time correctly
 - reject zoned specific mount options for non-zoned file systems
 - export the max_open_zones limit in sysfs
 - add freecounter tracing
 - reduce metafile reservations
 - fix GC I/O splitting on devices with not LBA aligned max_sectors

