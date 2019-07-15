Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9C769F10
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jul 2019 00:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbfGOWkD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 18:40:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44486 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730608AbfGOWkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 18:40:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so18739143wrf.11;
        Mon, 15 Jul 2019 15:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=mqI4EOfS51RrWX+R3Z3hkRylPd09x5J5s/zU8+JEiHc=;
        b=d5npAWz5SjsAxEN9nkQgsd+f4QlFBn2rCVPuImwwb5BbM0Mdd55l+WKdpVa6o+6ggJ
         XYIVQ3IASQya2ISTo5VgdvdlpzfCWofKuJxz1yN+th7HI77pCYHgiU/Y9UuJhjakbFe7
         wzgTS33S4TgG1ei7o3tk7f1SR5ofuy4vgug+Uzr4Lf9OUEU50olGp/+uWTXgdL9zFt04
         IYtRkKjGJayqSf/FAF+MYSeUkkkN6qnMvFpfC4xnfGpPBOUQVyxI6pavm5XiQFVH2MA6
         E3/LL6Wgi09dG0F5fROr7iZRXQHz1+YYUrapTNzzC4c4rqtGKDl2quVr0SgBMoWOVq9N
         VZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=mqI4EOfS51RrWX+R3Z3hkRylPd09x5J5s/zU8+JEiHc=;
        b=CJNfcWFXuXnE6uVViLeectLodcP5LZAFGAuPh/UUBcrrm82S6b9EUcBMkfTEQ1MI93
         FC0vpQmYFHIKvhuX6MyoJtHCZi1YoTQOQw3+ZEnedathHnTnMuEslfVwm0FyieORqw1E
         Yyd7VT3HQn6ASUjERENzb4hNVdjmz5rqyrNMIWaOcNoULiEp9BzQBXq/j4WxW2a945z1
         de6oMdkU1t22Jd4LzeL8uZAyyjJtZhlwI4Babwmvb7qD1RXp3k01BA8dnH6dnVHHC8S1
         4sF+jalISdHPRG/rAsgna5o/86UwRPlCP3UsOSpQAJE6O0MmFj2AFQ4tdxxMG/Pv+PYI
         gm5A==
X-Gm-Message-State: APjAAAVP3LgH7ddJJik0rVoTlSQXlrmsHjfa5WYwa7hLN/2xYhm+5J6i
        Ffz968HFBOh07RhB6plkUMo=
X-Google-Smtp-Source: APXvYqxUJezZFEyKR9fk4rdqMGxXoaOzA9NBaOts5iaTbKiVKjwIEBmPX4Whp7l5+YwYLA6eP+uKpA==
X-Received: by 2002:adf:de08:: with SMTP id b8mr6678931wrm.282.1563230398718;
        Mon, 15 Jul 2019 15:39:58 -0700 (PDT)
Received: from sheriff-Aspire-5735 ([129.205.112.210])
        by smtp.gmail.com with ESMTPSA id r123sm17343336wme.7.2019.07.15.15.39.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jul 2019 15:39:58 -0700 (PDT)
Date:   Mon, 15 Jul 2019 23:39:51 +0100
From:   Sheriff Esseson <sheriffesseson@gmail.com>
To:     skhan@linuxfoundation.org
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        sheriffesseson@gmail.com
Subject: Re: [PATCH v9] Documentation: filesystem: Convert xfs.txt to ReST
Message-ID: <20190715223950.GC27635@sheriff-Aspire-5735>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move xfs.txt to admin-guide, convert to ReST and fix broken references.

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---

Changes in v9:
	- fix table for "Removed Sysctls".
	- "Deprecated Mount Options", just like "Deprecated Sysctls",
	  currently needs no table - remove table. 	

 Documentation/admin-guide/index.rst           |   1 +
 .../xfs.txt => admin-guide/xfs.rst}           | 136 +++++++++---------
 Documentation/filesystems/dax.txt             |   2 +-
 MAINTAINERS                                   |   2 +-
 4 files changed, 68 insertions(+), 73 deletions(-)
 rename Documentation/{filesystems/xfs.txt => admin-guide/xfs.rst} (80%)

diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index 24fbe0568eff..0615ea3a744c 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -70,6 +70,7 @@ configure specific aspects of kernel behavior to your liking.
    ras
    bcache
    ext4
+   xfs
    binderfs
    pm/index
    thunderbolt
diff --git a/Documentation/filesystems/xfs.txt b/Documentation/admin-guide/xfs.rst
similarity index 80%
rename from Documentation/filesystems/xfs.txt
rename to Documentation/admin-guide/xfs.rst
index a5cbb5e0e3db..e1b412a3dd29 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/admin-guide/xfs.rst
@@ -1,4 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
 
+======================
 The SGI XFS Filesystem
 ======================
 
@@ -18,8 +20,6 @@ Mount Options
 =============
 
 When mounting an XFS filesystem, the following options are accepted.
-For boolean mount options, the names with the (*) suffix is the
-default behaviour.
 
   allocsize=size
 	Sets the buffered I/O end-of-file preallocation size when
@@ -31,46 +31,43 @@ default behaviour.
 	preallocation size, which uses a set of heuristics to
 	optimise the preallocation size based on the current
 	allocation patterns within the file and the access patterns
-	to the file. Specifying a fixed allocsize value turns off
+	to the file. Specifying a fixed ``allocsize`` value turns off
 	the dynamic behaviour.
 
-  attr2
-  noattr2
+  attr2 or noattr2
 	The options enable/disable an "opportunistic" improvement to
 	be made in the way inline extended attributes are stored
 	on-disk.  When the new form is used for the first time when
-	attr2 is selected (either when setting or removing extended
+	``attr2`` is selected (either when setting or removing extended
 	attributes) the on-disk superblock feature bit field will be
 	updated to reflect this format being in use.
 
 	The default behaviour is determined by the on-disk feature
-	bit indicating that attr2 behaviour is active. If either
-	mount option it set, then that becomes the new default used
+	bit indicating that ``attr2`` behaviour is active. If either
+	mount option is set, then that becomes the new default used
 	by the filesystem.
 
-	CRC enabled filesystems always use the attr2 format, and so
-	will reject the noattr2 mount option if it is set.
+	CRC enabled filesystems always use the ``attr2`` format, and so
+	will reject the ``noattr2`` mount option if it is set.
 
-  discard
-  nodiscard (*)
+  discard or nodiscard (default)
 	Enable/disable the issuing of commands to let the block
 	device reclaim space freed by the filesystem.  This is
 	useful for SSD devices, thinly provisioned LUNs and virtual
 	machine images, but may have a performance impact.
 
-	Note: It is currently recommended that you use the fstrim
-	application to discard unused blocks rather than the discard
+	Note: It is currently recommended that you use the ``fstrim``
+	application to ``discard`` unused blocks rather than the ``discard``
 	mount option because the performance impact of this option
 	is quite severe.
 
-  grpid/bsdgroups
-  nogrpid/sysvgroups (*)
+  grpid/bsdgroups or nogrpid/sysvgroups (default)
 	These options define what group ID a newly created file
-	gets.  When grpid is set, it takes the group ID of the
+	gets.  When ``grpid`` is set, it takes the group ID of the
 	directory in which it is created; otherwise it takes the
-	fsgid of the current process, unless the directory has the
-	setgid bit set, in which case it takes the gid from the
-	parent directory, and also gets the setgid bit set if it is
+	``fsgid`` of the current process, unless the directory has the
+	``setgid`` bit set, in which case it takes the ``gid`` from the
+	parent directory, and also gets the ``setgid`` bit set if it is
 	a directory itself.
 
   filestreams
@@ -78,46 +75,42 @@ default behaviour.
 	across the entire filesystem rather than just on directories
 	configured to use it.
 
-  ikeep
-  noikeep (*)
-	When ikeep is specified, XFS does not delete empty inode
-	clusters and keeps them around on disk.  When noikeep is
+  ikeep or noikeep (default)
+	When ``ikeep`` is specified, XFS does not delete empty inode
+	clusters and keeps them around on disk.  When ``noikeep`` is
 	specified, empty inode clusters are returned to the free
 	space pool.
 
-  inode32
-  inode64 (*)
-	When inode32 is specified, it indicates that XFS limits
+  inode32 or inode64 (default)
+	When ``inode32`` is specified, it indicates that XFS limits
 	inode creation to locations which will not result in inode
 	numbers with more than 32 bits of significance.
 
-	When inode64 is specified, it indicates that XFS is allowed
+	When ``inode64`` is specified, it indicates that XFS is allowed
 	to create inodes at any location in the filesystem,
 	including those which will result in inode numbers occupying
-	more than 32 bits of significance. 
+	more than 32 bits of significance.
 
-	inode32 is provided for backwards compatibility with older
+	``inode32`` is provided for backwards compatibility with older
 	systems and applications, since 64 bits inode numbers might
 	cause problems for some applications that cannot handle
 	large inode numbers.  If applications are in use which do
-	not handle inode numbers bigger than 32 bits, the inode32
+	not handle inode numbers bigger than 32 bits, the ``inode32``
 	option should be specified.
 
-
-  largeio
-  nolargeio (*)
-	If "nolargeio" is specified, the optimal I/O reported in
-	st_blksize by stat(2) will be as small as possible to allow
+  largeio or nolargeio (default)
+	If ``nolargeio`` is specified, the optimal I/O reported in
+	``st_blksize`` by **stat(2)** will be as small as possible to allow
 	user applications to avoid inefficient read/modify/write
 	I/O.  This is typically the page size of the machine, as
 	this is the granularity of the page cache.
 
-	If "largeio" specified, a filesystem that was created with a
-	"swidth" specified will return the "swidth" value (in bytes)
-	in st_blksize. If the filesystem does not have a "swidth"
-	specified but does specify an "allocsize" then "allocsize"
+	If ``largeio`` is specified, a filesystem that was created with a
+	``swidth`` specified will return the ``swidth`` value (in bytes)
+	in ``st_blksize``. If the filesystem does not have a ``swidth``
+	specified but does specify an ``allocsize`` then ``allocsize``
 	(in bytes) will be returned instead. Otherwise the behaviour
-	is the same as if "nolargeio" was specified.
+	is the same as if ``nolargeio`` was specified.
 
   logbufs=value
 	Set the number of in-memory log buffers.  Valid numbers
@@ -127,7 +120,7 @@ default behaviour.
 
 	If the memory cost of 8 log buffers is too high on small
 	systems, then it may be reduced at some cost to performance
-	on metadata intensive workloads. The logbsize option below
+	on metadata intensive workloads. The ``logbsize`` option below
 	controls the size of each buffer and so is also relevant to
 	this case.
 
@@ -138,7 +131,7 @@ default behaviour.
 	and 32768 (32k).  Valid sizes for version 2 logs also
 	include 65536 (64k), 131072 (128k) and 262144 (256k). The
 	logbsize must be an integer multiple of the log
-	stripe unit configured at mkfs time.
+	stripe unit configured at **mkfs(8)** time.
 
 	The default value for for version 1 logs is 32768, while the
 	default value for version 2 logs is MAX(32768, log_sunit).
@@ -153,21 +146,21 @@ default behaviour.
   noalign
 	Data allocations will not be aligned at stripe unit
 	boundaries. This is only relevant to filesystems created
-	with non-zero data alignment parameters (sunit, swidth) by
-	mkfs.
+	with non-zero data alignment parameters (``sunit``, ``swidth``) by
+	**mkfs(8)**.
 
   norecovery
 	The filesystem will be mounted without running log recovery.
 	If the filesystem was not cleanly unmounted, it is likely to
-	be inconsistent when mounted in "norecovery" mode.
+	be inconsistent when mounted in ``norecovery`` mode.
 	Some files or directories may not be accessible because of this.
-	Filesystems mounted "norecovery" must be mounted read-only or
+	Filesystems mounted ``norecovery`` must be mounted read-only or
 	the mount will fail.
 
   nouuid
 	Don't check for double mounted file systems using the file
-	system uuid.  This is useful to mount LVM snapshot volumes,
-	and often used in combination with "norecovery" for mounting
+	system ``uuid``.  This is useful to mount LVM snapshot volumes,
+	and often used in combination with ``norecovery`` for mounting
 	read-only snapshots.
 
   noquota
@@ -176,15 +169,15 @@ default behaviour.
 
   uquota/usrquota/uqnoenforce/quota
 	User disk quota accounting enabled, and limits (optionally)
-	enforced.  Refer to xfs_quota(8) for further details.
+	enforced.  Refer to **xfs_quota(8)** for further details.
 
   gquota/grpquota/gqnoenforce
 	Group disk quota accounting enabled and limits (optionally)
-	enforced.  Refer to xfs_quota(8) for further details.
+	enforced.  Refer to **xfs_quota(8)** for further details.
 
   pquota/prjquota/pqnoenforce
 	Project disk quota accounting enabled and limits (optionally)
-	enforced.  Refer to xfs_quota(8) for further details.
+	enforced.  Refer to **xfs_quota(8)** for further details.
 
   sunit=value and swidth=value
 	Used to specify the stripe unit and width for a RAID device
@@ -192,11 +185,11 @@ default behaviour.
 	block units. These options are only relevant to filesystems
 	that were created with non-zero data alignment parameters.
 
-	The sunit and swidth parameters specified must be compatible
+	The ``sunit`` and ``swidth`` parameters specified must be compatible
 	with the existing filesystem alignment characteristics.  In
-	general, that means the only valid changes to sunit are
-	increasing it by a power-of-2 multiple. Valid swidth values
-	are any integer multiple of a valid sunit value.
+	general, that means the only valid changes to ``sunit`` are
+	increasing it by a power-of-2 multiple. Valid ``swidth`` values
+	are any integer multiple of a valid ``sunit`` value.
 
 	Typically the only time these mount options are necessary if
 	after an underlying RAID device has had it's geometry
@@ -221,22 +214,22 @@ default behaviour.
 Deprecated Mount Options
 ========================
 
-  Name				Removal Schedule
-  ----				----------------
+None at present.
 
 
 Removed Mount Options
 =====================
 
+===========================     =======
   Name				Removed
-  ----				-------
+===========================	=======
   delaylog/nodelaylog		v4.0
   ihashsize			v4.0
   irixsgid			v4.0
   osyncisdsync/osyncisosync	v4.0
   barrier			v4.19
   nobarrier			v4.19
-
+===========================     =======
 
 sysctls
 =======
@@ -302,27 +295,27 @@ The following sysctls are available for the XFS filesystem:
 
   fs.xfs.inherit_sync		(Min: 0  Default: 1  Max: 1)
 	Setting this to "1" will cause the "sync" flag set
-	by the xfs_io(8) chattr command on a directory to be
+	by the **xfs_io(8)** chattr command on a directory to be
 	inherited by files in that directory.
 
   fs.xfs.inherit_nodump		(Min: 0  Default: 1  Max: 1)
 	Setting this to "1" will cause the "nodump" flag set
-	by the xfs_io(8) chattr command on a directory to be
+	by the **xfs_io(8)** chattr command on a directory to be
 	inherited by files in that directory.
 
   fs.xfs.inherit_noatime	(Min: 0  Default: 1  Max: 1)
 	Setting this to "1" will cause the "noatime" flag set
-	by the xfs_io(8) chattr command on a directory to be
+	by the **xfs_io(8)** chattr command on a directory to be
 	inherited by files in that directory.
 
   fs.xfs.inherit_nosymlinks	(Min: 0  Default: 1  Max: 1)
 	Setting this to "1" will cause the "nosymlinks" flag set
-	by the xfs_io(8) chattr command on a directory to be
+	by the **xfs_io(8)** chattr command on a directory to be
 	inherited by files in that directory.
 
   fs.xfs.inherit_nodefrag	(Min: 0  Default: 1  Max: 1)
 	Setting this to "1" will cause the "nodefrag" flag set
-	by the xfs_io(8) chattr command on a directory to be
+	by the **xfs_io(8)** chattr command on a directory to be
 	inherited by files in that directory.
 
   fs.xfs.rotorstep		(Min: 1  Default: 1  Max: 256)
@@ -341,11 +334,12 @@ None at present.
 Removed Sysctls
 ===============
 
+  ===========================   =======
   Name				Removed
-  ----				-------
+  ===========================	=======	
   fs.xfs.xfsbufd_centisec	v4.0
   fs.xfs.age_buffer_centisecs	v4.0
-
+  ===========================   =======
 
 Error handling
 ==============
@@ -368,7 +362,7 @@ handler:
  -error handlers:
 	Defines the behavior for a specific error.
 
-The filesystem behavior during an error can be set via sysfs files. Each
+The filesystem behavior during an error can be set via ``sysfs`` files. Each
 error handler works independently - the first condition met by an error handler
 for a specific class will cause the error to be propagated rather than reset and
 retried.
@@ -419,7 +413,7 @@ level directory:
 	handler configurations.
 
 	Note: there is no guarantee that fail_at_unmount can be set while an
-	unmount is in progress. It is possible that the sysfs entries are
+	unmount is in progress. It is possible that the ``sysfs`` entries are
 	removed by the unmounting filesystem before a "retry forever" error
 	handler configuration causes unmount to hang, and hence the filesystem
 	must be configured appropriately before unmount begins to prevent
@@ -428,7 +422,7 @@ level directory:
 Each filesystem has specific error class handlers that define the error
 propagation behaviour for specific errors. There is also a "default" error
 handler defined, which defines the behaviour for all errors that don't have
-specific handlers defined. Where multiple retry constraints are configuredi for
+specific handlers defined. Where multiple retry constraints are configured for
 a single error, the first retry configuration that expires will cause the error
 to be propagated. The handler configurations are found in the directory:
 
@@ -463,7 +457,7 @@ to be propagated. The handler configurations are found in the directory:
 	Setting the value to "N" (where 0 < N < Max) will allow XFS to retry the
 	operation for up to "N" seconds before propagating the error.
 
-Note: The default behaviour for a specific error handler is dependent on both
+**Note:** The default behaviour for a specific error handler is dependent on both
 the class and error context. For example, the default values for
 "metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
 to "fail immediately" behaviour. This is done because ENODEV is a fatal,
diff --git a/Documentation/filesystems/dax.txt b/Documentation/filesystems/dax.txt
index 6d2c0d340dea..679729442fd2 100644
--- a/Documentation/filesystems/dax.txt
+++ b/Documentation/filesystems/dax.txt
@@ -76,7 +76,7 @@ exposure of uninitialized data through mmap.
 These filesystems may be used for inspiration:
 - ext2: see Documentation/filesystems/ext2.txt
 - ext4: see Documentation/filesystems/ext4/
-- xfs:  see Documentation/filesystems/xfs.txt
+- xfs:  see Documentation/admin-guide/xfs.rst
 
 
 Handling Media Errors
diff --git a/MAINTAINERS b/MAINTAINERS
index 43ca94856944..3b6e0b6d8cbd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17453,7 +17453,7 @@ L:	linux-xfs@vger.kernel.org
 W:	http://xfs.org/
 T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 S:	Supported
-F:	Documentation/filesystems/xfs.txt
+F:	Documentation/admin-guide/xfs.rst
 F:	fs/xfs/
 
 XILINX AXI ETHERNET DRIVER
-- 
2.17.1

