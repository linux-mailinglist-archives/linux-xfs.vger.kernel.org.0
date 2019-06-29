Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D8A5ABF6
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 16:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfF2Oyu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 29 Jun 2019 10:54:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40774 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfF2Oyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Jun 2019 10:54:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so9180237wre.7;
        Sat, 29 Jun 2019 07:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Us7E2m9FjQEVFeyGCN1o9lfo1FB04AlBXh42LqDN8y0=;
        b=t3CTG0i72xAzx6p3BJgGIXsHvW0f9jW0l6Jy9U39FngkmTdbUyWgmUgSjBaBSgjxwZ
         e3goDeYsDc5zhjHlNr+pPHzXd0fWkeOfyh5PIzQFMbDC6q+L/lZtCXQX6woVbI2nBBn4
         TFpoH4hEQsO+r58mp1E8RqwEhwwj/1muUMX9WuIiVz4SaLCWZQr/M3nx99VH3ilINSZ2
         03EPxllnsK6pEWjZi/fxrKzqBocR3e0VxSfx9GkjTVTRcz8ukvXKrHPLkJQecVA42tIH
         CFRgXw8U2sRzknBvU7TTp3iSYC8ibBb9rxqJ1UTxg5D8JfS9atpfenxl3v4jc9vNVX5V
         7NrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Us7E2m9FjQEVFeyGCN1o9lfo1FB04AlBXh42LqDN8y0=;
        b=qIbT2uTGiXZe/vxf2ZrsIlrRK9eoMCT6tCZPPxC2AmYmyBLM0Umbw9DthZaO/peNid
         qwVFTBzln59dYTK5Fi8XzaiJTHRAmLhlEb0d9DNg8a/b7QXOYWyUjeRU9agUN6R+pvxp
         P5zqOupUcpWa4BRo/gP1kcxSTpCMUj9BCllRP47rU4qRlKe9XOLb4DdMVyDYj5dcA2HT
         JxrngGd2C0RdF4mSy26gOJ/xdiRT1y3u/TNBUj6CC8nFSNqQ4GQfaAtDBkBxHVLiaYzf
         1c4bcauXiwsvlnAfCegEJeJoKq3PAdE/+KvewuFXTLhIO3Xgg9gYkYIjITnnX9DMs7lj
         GNNQ==
X-Gm-Message-State: APjAAAURbSpMRZF04OYMgfmnaalzKag54pT5pgVb50d7I44DYtUywAyz
        Md42cu0oLcyPYc8wzRGg4pVJYHix
X-Google-Smtp-Source: APXvYqw9H+vX1XmHCchAuNC7YSYL85Bliu/U1NYCZMgeqB2FcA+JkHIqTRGPYOQ2M5eBWrf4ZrjOaw==
X-Received: by 2002:a5d:4cca:: with SMTP id c10mr11440110wrt.233.1561820082823;
        Sat, 29 Jun 2019 07:54:42 -0700 (PDT)
Received: from localhost ([197.210.35.74])
        by smtp.gmail.com with ESMTPSA id a13sm3778612wrx.55.2019.06.29.07.54.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 07:54:42 -0700 (PDT)
Date:   Sat, 29 Jun 2019 15:54:33 +0100
From:   Sheriff Esseson <sheriffesseson@gmail.com>
To:     skhan@linuxfoundation.org
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] Doc : fs : convert xfs.txt to ReST
Message-ID: <20190629145433.GA10491@localhost>
References: <20190628214302.GA12096@localhost>
 <20190629010733.GA31770@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190629010733.GA31770@localhost>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 29, 2019 at 02:25:08AM +0100, Sheriff Esseson wrote:
> On Fri, Jun 28, 2019 at 10:43:24PM +0100, Sheriff Esseson wrote:
> > 	Convert xfs.txt to ReST, markup and rename accordingly. Update
> > 	Documentation/index.rst.
> > 	
> > 	While at it, make "value" in "option=value" form xfs options definable by
> > 	the user, by embedding in angle "<>" brackets, rather than something
> > 	predifined elsewhere. This is inline with the conventions in manuals.
> > 	
> > 	Also, make defaults of boolean options prefixed with "(*)". This is
> > 	so that options can be compressed to "[no]option" and on a single line, which renders
> > 	consistently and nicely in htmldocs.
> > 	lastly, enforce a "one option, one definition" policy to keep things
> > 	consistent and simple.
> > 
> > Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
> > ---
> > -- 
> > 2.22.0
> > 
> 
> Rid Documentation/filesystems/index.rst of ".rst" in toc-tree references.
> 
> CC xfs-list.
> 
> Correct email indentation.
> 
> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
> ---
> -- 
> 2.22.0
> 

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---

In v2:
Update MAINTAINERS.
fix indentation/long lines issues.
cc Darick and xfs mailing list.

 Documentation/filesystems/index.rst |   5 +-
 Documentation/filesystems/xfs.rst   | 467 +++++++++++++++++++++++++++
 Documentation/filesystems/xfs.txt   | 470 ----------------------------
 MAINTAINERS                         |   2 +-
 4 files changed, 471 insertions(+), 473 deletions(-)
 create mode 100644 Documentation/filesystems/xfs.rst
 delete mode 100644 Documentation/filesystems/xfs.txt

diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 1131c34d7..a4cf5fca4 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -16,7 +16,7 @@ algorithms work.
 .. toctree::
    :maxdepth: 2
 
-   path-lookup.rst
+   path-lookup
    api-summary
    splice
 
@@ -40,4 +40,5 @@ Documentation for individual filesystem types can be found here.
 .. toctree::
    :maxdepth: 2
 
-   binderfs.rst
+   binderfs
+   xfs
diff --git a/Documentation/filesystems/xfs.rst b/Documentation/filesystems/xfs.rst
new file mode 100644
index 000000000..f52046b96
--- /dev/null
+++ b/Documentation/filesystems/xfs.rst
@@ -0,0 +1,467 @@
+======================
+The SGI XFS Filesystem
+======================
+
+XFS is a high performance journaling filesystem which originated
+on the SGI IRIX platform.  It is completely multi-threaded, can
+support large files and large filesystems, extended attributes,
+variable block sizes, is extent based, and makes extensive use of
+Btrees (directories, extents, free space) to aid both performance
+and scalability.
+
+Refer to the documentation at https://xfs.wiki.kernel.org/
+for further details.  This implementation is on-disk compatible
+with the IRIX version of XFS.
+
+
+Mount Options
+=============
+
+When mounting an XFS filesystem, the following options are accepted.  For
+boolean mount options, the names with the "(*)" prefix is the default behaviour.
+For example, take a behaviour enabled by default to be a one (1) or, a zero (0)
+otherwise, ``(*)[no]default`` would be 0 while ``[no](*)default`` , a 1.
+
+   allocsize=<size>
+        Sets the buffered I/O end-of-file preallocation size when doing delayed
+        allocation writeout (default size is 64KiB).  Valid values for this
+        option are page size (typically 4KiB) through to 1GiB, inclusive, in
+        power-of-2 increments.
+
+        The default behaviour is for dynamic end-of-file preallocation size,
+        which uses a set of heuristics to optimise the preallocation size based
+        on the current allocation patterns within the file and the access
+        patterns to the file. Specifying a fixed allocsize value turns off the
+        dynamic behaviour.
+
+   [no]attr2
+        The options enable/disable an "opportunistic" improvement to be made in
+        the way inline extended attributes are stored on-disk.  When the new
+        form is used for the first time when ``attr2`` is selected (either when
+        setting or removing extended attributes) the on-disk superblock feature
+        bit field will be updated to reflect this format being in use.
+
+        The default behaviour is determined by the on-disk feature bit
+        indicating that ``attr2`` behaviour is active. If either mount option is
+        set, then that becomes the new default used by the filesystem. However
+        on CRC enabled filesystems, the ``attr2`` format is always used , and so
+        will reject the ``noattr2`` mount option if it is set.
+
+   (*)[no]discard
+        Enable/disable the issuing of commands to let the block device reclaim
+        space freed by the filesystem.  This is useful for SSD devices, thinly
+        provisioned LUNs and virtual machine images, but may have a performance
+        impact.
+
+        Note: It is currently recommended that you use the ``fstrim``
+        application to discard unused blocks rather than the ``discard`` mount
+        option because the performance impact of this option is quite severe.
+
+   grpid/bsdgroups
+   nogrpid/(*)sysvgroups
+        These options define what group ID a newly created file gets.  When
+        ``grpid`` is set, it takes the group ID of the directory in which it is
+        created; otherwise it takes the ``fsgid`` of the current process, unless
+        the directory has the ``setgid`` bit set, in which case it takes the
+        ``gid`` from the parent directory, and also gets the ``setgid`` bit set
+        if it is a directory itself.
+
+   filestreams
+        Make the data allocator use the filestreams allocation mode across the
+        entire filesystem rather than just on directories configured to use it.
+
+   (*)[no]ikeep
+        When ``ikeep`` is specified, XFS does not delete empty inode clusters
+        and keeps them around on disk.  When ``noikeep`` is specified, empty
+        inode clusters are returned to the free space pool.
+
+   inode32 | (*)inode64
+        When ``inode32`` is specified, it indicates that XFS limits inode
+        creation to locations which will not result in inode numbers with more
+        than 32 bits of significance.
+
+        When ``inode64`` is specified, it indicates that XFS is allowed to
+        create inodes at any location in the filesystem, including those which
+        will result in inode numbers occupying more than 32 bits of
+        significance.
+
+        ``inode32`` is provided for backwards compatibility with older systems
+        and applications, since 64 bits inode numbers might cause problems for
+        some applications that cannot handle large inode numbers.  If
+        applications are in use which do not handle inode numbers bigger than 32
+        bits, the ``inode32`` option should be specified.
+
+
+   (*)[no]largeio
+        If ``nolargeio`` is specified, the optimal I/O reported in st_blksize by
+        **stat(2)** will be as small as possible to allow user applications to
+        avoid inefficient read/modify/write I/O.  This is typically the page
+        size of the machine, as this is the granularity of the page cache.
+
+        If ``largeio`` is specified, a filesystem that was created with a
+        ``swidth`` specified will return the ``swidth`` value (in bytes) in
+        st_blksize. If the filesystem does not have a ``swidth`` specified but
+        does specify an ``allocsize`` then ``allocsize`` (in bytes) will be
+        returned instead. Otherwise the behaviour is the same as if
+        ``nolargeio`` was specified.
+
+   logbufs=<value>
+        Set the number of in-memory log buffers to ``value``.  Valid numbers
+        range from 2-8 inclusive.
+
+        The default value is 8 buffers.
+
+        If the memory cost of 8 log buffers is too high on small systems, then
+        it may be reduced at some cost to performance on metadata intensive
+        workloads. The ``logbsize`` option below controls the size of each
+        buffer and so is also relevant to this case.
+
+   logbsize=<value>
+        Set the size of each in-memory log buffer to ``value``.  The size may be
+        specified in bytes, or in kilobytes with a "k" suffix. Valid sizes for
+        version 1 and version 2 logs are 16384 (16k) and 32768 (32k).  Valid
+        sizes for version 2 logs also include 65536 (64k), 131072 (128k) and
+        262144 (256k). The ``logbsize`` must be an integer multiple of the
+        "log stripe unit" configured at mkfs time.
+
+        The default value for for version 1 logs is 32768, while the default
+        value for version 2 logs is ``MAX(32768, log_sunit)``.
+
+   logdev=<device>
+        Use ``device`` as an external log (metadata journal).  In an XFS
+        filesystem, the log device can be separate from the data device or
+        contained within it.
+
+   rtdev=<device>
+        An XFS filesystem has up to three parts: a data section, a log section,
+        and a real-time section.  The real-time section is optional.  If
+        enabled, ``rtdev`` sets ``device`` to be used as an external real-time
+        section, similar to ``logdev`` above.
+
+   noalign
+        Data allocations will not be aligned at stripe unit boundaries. This is
+        only relevant to filesystems created with non-zero data alignment
+        parameters (sunit, swidth) by mkfs.
+
+   norecovery
+        The filesystem will be mounted without running log recovery.  If the
+        filesystem was not cleanly unmounted, it is likely to be inconsistent
+        when mounted in ``norecovery`` mode.  Some files or directories may not
+        be accessible because of this.  Filesystems mounted ``norecovery`` must
+        be mounted read-only or the mount will fail.
+
+   nouuid
+        Don't check for double mounted file systems using the file system uuid.
+        This is useful to mount LVM snapshot volumes, and often used in
+        combination with ``norecovery`` for mounting read-only snapshots.
+
+   noquota
+	Forcibly turns off all quota accounting and enforcement
+	within the filesystem.
+
+   uquota/usrquota/uqnoenforce/quota
+        User disk quota accounting enabled, and limits (optionally) enforced.
+        Refer to **xfs_quota(8)** for further details.
+
+   gquota/grpquota/gqnoenforce
+        Group disk quota accounting enabled and limits (optionally) enforced.
+        Refer to **xfs_quota(8)** for further details.
+
+   pquota/prjquota/pqnoenforce
+        Project disk quota accounting enabled and limits (optionally) enforced.
+        Refer to **xfs_quota(8)** for further details.
+
+   sunit=<value>
+        Used to specify the stripe unit for a RAID device or (in conjunction
+        with ``swidth`` below) a stripe volume.  ``value`` must be specified in
+        512-byte block units. This option is only relevant to filesystems that
+        were created with non-zero data alignment parameters.
+
+        The ``sunit`` parameter specified must be compatible with the existing
+        filesystem alignment characteristics.  In general, that means the only
+        valid changes to ``sunit`` are increasing it by a power-of-2 multiple.
+
+        Typically, this mount option is necessary only after an underlying RAID
+        device has had its geometry modified, such as adding a new disk to a
+        RAID5 lun and reshaping it.
+
+   swidth=<value>
+        Used to specify the stripe width for a RAID device or (in conjunction
+        with ``sunit`` above) a stripe volume.  ``value`` must be specified in
+        512-byte block units. This option, like ``sunit`` above, is only
+        relevant to filesystems that were created with non-zero data alignment
+        parameters.
+
+        The ``swidth`` parameter specified must be compatible with the existing
+        filesystem alignment characteristics.  In general, that means the only
+        valid swidth values are any integer multiple of a valid ``sunit`` value.
+
+        Typically, this mount option is necessary only after an underlying RAID
+        device has had its geometry modified, such as adding a new disk to a
+        RAID5 lun and reshaping it.
+
+
+   swalloc
+        Data allocations will be rounded up to stripe width boundaries when the
+        current end of file is being extended and the file size is larger than
+        the stripe width size.
+
+   wsync
+        When specified, all filesystem namespace operations are executed
+        synchronously. This ensures that when the namespace operation (create,
+        unlink, etc) completes, the change to the namespace is on stable
+        storage. This is useful in HA setups where failover must not result in
+        clients seeing inconsistent namespace presentation during or after a
+        failover event.
+
+
+Deprecated Mount Options
+========================
+
+  Name				Removal Schedule
+  ----				----------------
+
+
+Removed Mount Options
+=====================
+
+  Name				Removed
+  ----				-------
+  delaylog/nodelaylog		v4.0
+  ihashsize			v4.0
+  irixsgid			v4.0
+  osyncisdsync/osyncisosync	v4.0
+  barrier			v4.19
+  nobarrier			v4.19
+
+
+sysctls
+=======
+
+The following sysctls are available for the XFS filesystem:
+
+  fs.xfs.stats_clear		(Min: 0  Default: 0  Max: 1)
+	Setting this to "1" clears accumulated XFS statistics
+	in /proc/fs/xfs/stat.  It then immediately resets to "0".
+
+  fs.xfs.xfssyncd_centisecs	(Min: 100  Default: 3000  Max: 720000)
+	The interval at which the filesystem flushes metadata
+	out to disk and runs internal cache cleanup routines.
+
+  fs.xfs.filestream_centisecs	(Min: 1  Default: 3000  Max: 360000)
+	The interval at which the filesystem ages filestreams cache
+	references and returns timed-out AGs back to the free stream
+	pool.
+
+  fs.xfs.speculative_prealloc_lifetime
+		(Units: seconds   Min: 1  Default: 300  Max: 86400)
+	The interval at which the background scanning for inodes
+	with unused speculative preallocation runs. The scan
+	removes unused preallocation from clean inodes and releases
+	the unused space back to the free pool.
+
+  fs.xfs.error_level		(Min: 0  Default: 3  Max: 11)
+	A volume knob for error reporting when internal errors occur.
+	This will generate detailed messages & backtraces for filesystem
+	shutdowns, for example.  Current threshold values are:
+
+		XFS_ERRLEVEL_OFF:       0
+		XFS_ERRLEVEL_LOW:       1
+		XFS_ERRLEVEL_HIGH:      5
+
+  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 256)
+	Causes certain error conditions to call BUG(). Value is a bitmask;
+	OR together the tags which represent errors which should cause panics:
+
+		XFS_NO_PTAG                     0
+		XFS_PTAG_IFLUSH                 0x00000001
+		XFS_PTAG_LOGRES                 0x00000002
+		XFS_PTAG_AILDELETE              0x00000004
+		XFS_PTAG_ERROR_REPORT           0x00000008
+		XFS_PTAG_SHUTDOWN_CORRUPT       0x00000010
+		XFS_PTAG_SHUTDOWN_IOERROR       0x00000020
+		XFS_PTAG_SHUTDOWN_LOGERROR      0x00000040
+		XFS_PTAG_FSBLOCK_ZERO           0x00000080
+		XFS_PTAG_VERIFIER_ERROR         0x00000100
+
+	This option is intended for debugging only.
+
+  fs.xfs.irix_symlink_mode	(Min: 0  Default: 0  Max: 1)
+	Controls whether symlinks are created with mode 0777 (default)
+	or whether their mode is affected by the umask (irix mode).
+
+  fs.xfs.irix_sgid_inherit	(Min: 0  Default: 0  Max: 1)
+	Controls files created in SGID directories.
+	If the group ID of the new file does not match the effective group
+	ID or one of the supplementary group IDs of the parent dir, the
+	ISGID bit is cleared if the irix_sgid_inherit compatibility sysctl
+	is set.
+
+  fs.xfs.inherit_sync		(Min: 0  Default: 1  Max: 1)
+	Setting this to "1" will cause the "sync" flag set
+	by the **xfs_io(8)** chattr command on a directory to be
+	inherited by files in that directory.
+
+  fs.xfs.inherit_nodump		(Min: 0  Default: 1  Max: 1)
+	Setting this to "1" will cause the "nodump" flag set
+	by the **xfs_io(8)** chattr command on a directory to be
+	inherited by files in that directory.
+
+  fs.xfs.inherit_noatime	(Min: 0  Default: 1  Max: 1)
+	Setting this to "1" will cause the "noatime" flag set
+	by the **xfs_io(8)** chattr command on a directory to be
+	inherited by files in that directory.
+
+  fs.xfs.inherit_nosymlinks	(Min: 0  Default: 1  Max: 1)
+	Setting this to "1" will cause the "nosymlinks" flag set
+	by the **xfs_io(8)** chattr command on a directory to be
+	inherited by files in that directory.
+
+  fs.xfs.inherit_nodefrag	(Min: 0  Default: 1  Max: 1)
+	Setting this to "1" will cause the "nodefrag" flag set
+	by the **xfs_io(8)** chattr command on a directory to be
+	inherited by files in that directory.
+
+  fs.xfs.rotorstep		(Min: 1  Default: 1  Max: 256)
+	In "inode32" allocation mode, this option determines how many
+	files the allocator attempts to allocate in the same allocation
+	group before moving to the next allocation group.  The intent
+	is to control the rate at which the allocator moves between
+	allocation groups when allocating extents for new files.
+
+Deprecated Sysctls
+==================
+
+None at present.
+
+
+Removed Sysctls
+===============
+
+  Name				Removed
+  ----				-------
+  fs.xfs.xfsbufd_centisec	v4.0
+  fs.xfs.age_buffer_centisecs	v4.0
+
+
+Error handling
+==============
+
+XFS can act differently according to the type of error found during its
+operation. The implementation introduces the following concepts to the error
+handler:
+
+ -failure speed:
+	Defines how fast XFS should propagate an error upwards when a specific
+	error is found during the filesystem operation. It can propagate
+	immediately, after a defined number of retries, after a set time period,
+	or simply retry forever.
+
+ -error classes:
+	Specifies the subsystem the error configuration will apply to, such as
+	metadata IO or memory allocation. Different subsystems will have
+	different error handlers for which behaviour can be configured.
+
+ -error handlers:
+	Defines the behavior for a specific error.
+
+The filesystem behavior during an error can be set via sysfs files. Each
+error handler works independently - the first condition met by an error handler
+for a specific class will cause the error to be propagated rather than reset and
+retried.
+
+The action taken by the filesystem when the error is propagated is context
+dependent - it may cause a shut down in the case of an unrecoverable error,
+it may be reported back to userspace, or it may even be ignored because
+there's nothing useful we can with the error or anyone we can report it to (e.g.
+during unmount).
+
+The configuration files are organized into the following hierarchy for each
+mounted filesystem:
+
+  /sys/fs/xfs/<dev>/error/<class>/<error>/
+
+Where:
+  <dev>
+	The short device name of the mounted filesystem. This is the same device
+	name that shows up in XFS kernel error messages as "XFS(<dev>): ..."
+
+  <class>
+	The subsystem the error configuration belongs to. As of 4.9, the defined
+	classes are:
+
+		- "metadata": applies metadata buffer write IO
+
+  <error>
+	The individual error handler configurations.
+
+
+Each filesystem has "global" error configuration options defined in their top
+level directory:
+
+  /sys/fs/xfs/<dev>/error/
+
+  fail_at_unmount		(Min:  0  Default:  1  Max: 1)
+	Defines the filesystem error behavior at unmount time.
+
+	If set to a value of 1, XFS will override all other error configurations
+	during unmount and replace them with "immediate fail" characteristics.
+	i.e. no retries, no retry timeout. This will always allow unmount to
+	succeed when there are persistent errors present.
+
+	If set to 0, the configured retry behaviour will continue until all
+	retries and/or timeouts have been exhausted. This will delay unmount
+	completion when there are persistent errors, and it may prevent the
+	filesystem from ever unmounting fully in the case of "retry forever"
+	handler configurations.
+
+	Note: there is no guarantee that fail_at_unmount can be set while an
+	unmount is in progress. It is possible that the sysfs entries are
+	removed by the unmounting filesystem before a "retry forever" error
+	handler configuration causes unmount to hang, and hence the filesystem
+	must be configured appropriately before unmount begins to prevent
+	unmount hangs.
+
+Each filesystem has specific error class handlers that define the error
+propagation behaviour for specific errors. There is also a "default" error
+handler defined, which defines the behaviour for all errors that don't have
+specific handlers defined. Where multiple retry constraints are configuredi for
+a single error, the first retry configuration that expires will cause the error
+to be propagated. The handler configurations are found in the directory:
+
+  /sys/fs/xfs/<dev>/error/<class>/<error>/
+
+  max_retries			(Min: -1  Default: Varies  Max: INTMAX)
+	Defines the allowed number of retries of a specific error before
+	the filesystem will propagate the error. The retry count for a given
+	error context (e.g. a specific metadata buffer) is reset every time
+	there is a successful completion of the operation.
+
+	Setting the value to "-1" will cause XFS to retry forever for this
+	specific error.
+
+	Setting the value to "0" will cause XFS to fail immediately when the
+	specific error is reported.
+
+	Setting the value to "N" (where 0 < N < Max) will make XFS retry the
+	operation "N" times before propagating the error.
+
+  retry_timeout_seconds		(Min:  -1  Default:  Varies  Max: 1 day)
+	Define the amount of time (in seconds) that the filesystem is
+	allowed to retry its operations when the specific error is
+	found.
+
+	Setting the value to "-1" will allow XFS to retry forever for this
+	specific error.
+
+	Setting the value to "0" will cause XFS to fail immediately when the
+	specific error is reported.
+
+	Setting the value to "N" (where 0 < N < Max) will allow XFS to retry the
+	operation for up to "N" seconds before propagating the error.
+
+Note: The default behaviour for a specific error handler is dependent on both
+the class and error context. For example, the default values for
+"metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
+to "fail immediately" behaviour. This is done because ENODEV is a fatal,
+unrecoverable error no matter how many times the metadata IO is retried.
diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
deleted file mode 100644
index a5cbb5e0e..000000000
--- a/Documentation/filesystems/xfs.txt
+++ /dev/null
@@ -1,470 +0,0 @@
-
-The SGI XFS Filesystem
-======================
-
-XFS is a high performance journaling filesystem which originated
-on the SGI IRIX platform.  It is completely multi-threaded, can
-support large files and large filesystems, extended attributes,
-variable block sizes, is extent based, and makes extensive use of
-Btrees (directories, extents, free space) to aid both performance
-and scalability.
-
-Refer to the documentation at https://xfs.wiki.kernel.org/
-for further details.  This implementation is on-disk compatible
-with the IRIX version of XFS.
-
-
-Mount Options
-=============
-
-When mounting an XFS filesystem, the following options are accepted.
-For boolean mount options, the names with the (*) suffix is the
-default behaviour.
-
-  allocsize=size
-	Sets the buffered I/O end-of-file preallocation size when
-	doing delayed allocation writeout (default size is 64KiB).
-	Valid values for this option are page size (typically 4KiB)
-	through to 1GiB, inclusive, in power-of-2 increments.
-
-	The default behaviour is for dynamic end-of-file
-	preallocation size, which uses a set of heuristics to
-	optimise the preallocation size based on the current
-	allocation patterns within the file and the access patterns
-	to the file. Specifying a fixed allocsize value turns off
-	the dynamic behaviour.
-
-  attr2
-  noattr2
-	The options enable/disable an "opportunistic" improvement to
-	be made in the way inline extended attributes are stored
-	on-disk.  When the new form is used for the first time when
-	attr2 is selected (either when setting or removing extended
-	attributes) the on-disk superblock feature bit field will be
-	updated to reflect this format being in use.
-
-	The default behaviour is determined by the on-disk feature
-	bit indicating that attr2 behaviour is active. If either
-	mount option it set, then that becomes the new default used
-	by the filesystem.
-
-	CRC enabled filesystems always use the attr2 format, and so
-	will reject the noattr2 mount option if it is set.
-
-  discard
-  nodiscard (*)
-	Enable/disable the issuing of commands to let the block
-	device reclaim space freed by the filesystem.  This is
-	useful for SSD devices, thinly provisioned LUNs and virtual
-	machine images, but may have a performance impact.
-
-	Note: It is currently recommended that you use the fstrim
-	application to discard unused blocks rather than the discard
-	mount option because the performance impact of this option
-	is quite severe.
-
-  grpid/bsdgroups
-  nogrpid/sysvgroups (*)
-	These options define what group ID a newly created file
-	gets.  When grpid is set, it takes the group ID of the
-	directory in which it is created; otherwise it takes the
-	fsgid of the current process, unless the directory has the
-	setgid bit set, in which case it takes the gid from the
-	parent directory, and also gets the setgid bit set if it is
-	a directory itself.
-
-  filestreams
-	Make the data allocator use the filestreams allocation mode
-	across the entire filesystem rather than just on directories
-	configured to use it.
-
-  ikeep
-  noikeep (*)
-	When ikeep is specified, XFS does not delete empty inode
-	clusters and keeps them around on disk.  When noikeep is
-	specified, empty inode clusters are returned to the free
-	space pool.
-
-  inode32
-  inode64 (*)
-	When inode32 is specified, it indicates that XFS limits
-	inode creation to locations which will not result in inode
-	numbers with more than 32 bits of significance.
-
-	When inode64 is specified, it indicates that XFS is allowed
-	to create inodes at any location in the filesystem,
-	including those which will result in inode numbers occupying
-	more than 32 bits of significance. 
-
-	inode32 is provided for backwards compatibility with older
-	systems and applications, since 64 bits inode numbers might
-	cause problems for some applications that cannot handle
-	large inode numbers.  If applications are in use which do
-	not handle inode numbers bigger than 32 bits, the inode32
-	option should be specified.
-
-
-  largeio
-  nolargeio (*)
-	If "nolargeio" is specified, the optimal I/O reported in
-	st_blksize by stat(2) will be as small as possible to allow
-	user applications to avoid inefficient read/modify/write
-	I/O.  This is typically the page size of the machine, as
-	this is the granularity of the page cache.
-
-	If "largeio" specified, a filesystem that was created with a
-	"swidth" specified will return the "swidth" value (in bytes)
-	in st_blksize. If the filesystem does not have a "swidth"
-	specified but does specify an "allocsize" then "allocsize"
-	(in bytes) will be returned instead. Otherwise the behaviour
-	is the same as if "nolargeio" was specified.
-
-  logbufs=value
-	Set the number of in-memory log buffers.  Valid numbers
-	range from 2-8 inclusive.
-
-	The default value is 8 buffers.
-
-	If the memory cost of 8 log buffers is too high on small
-	systems, then it may be reduced at some cost to performance
-	on metadata intensive workloads. The logbsize option below
-	controls the size of each buffer and so is also relevant to
-	this case.
-
-  logbsize=value
-	Set the size of each in-memory log buffer.  The size may be
-	specified in bytes, or in kilobytes with a "k" suffix.
-	Valid sizes for version 1 and version 2 logs are 16384 (16k)
-	and 32768 (32k).  Valid sizes for version 2 logs also
-	include 65536 (64k), 131072 (128k) and 262144 (256k). The
-	logbsize must be an integer multiple of the log
-	stripe unit configured at mkfs time.
-
-	The default value for for version 1 logs is 32768, while the
-	default value for version 2 logs is MAX(32768, log_sunit).
-
-  logdev=device and rtdev=device
-	Use an external log (metadata journal) and/or real-time device.
-	An XFS filesystem has up to three parts: a data section, a log
-	section, and a real-time section.  The real-time section is
-	optional, and the log section can be separate from the data
-	section or contained within it.
-
-  noalign
-	Data allocations will not be aligned at stripe unit
-	boundaries. This is only relevant to filesystems created
-	with non-zero data alignment parameters (sunit, swidth) by
-	mkfs.
-
-  norecovery
-	The filesystem will be mounted without running log recovery.
-	If the filesystem was not cleanly unmounted, it is likely to
-	be inconsistent when mounted in "norecovery" mode.
-	Some files or directories may not be accessible because of this.
-	Filesystems mounted "norecovery" must be mounted read-only or
-	the mount will fail.
-
-  nouuid
-	Don't check for double mounted file systems using the file
-	system uuid.  This is useful to mount LVM snapshot volumes,
-	and often used in combination with "norecovery" for mounting
-	read-only snapshots.
-
-  noquota
-	Forcibly turns off all quota accounting and enforcement
-	within the filesystem.
-
-  uquota/usrquota/uqnoenforce/quota
-	User disk quota accounting enabled, and limits (optionally)
-	enforced.  Refer to xfs_quota(8) for further details.
-
-  gquota/grpquota/gqnoenforce
-	Group disk quota accounting enabled and limits (optionally)
-	enforced.  Refer to xfs_quota(8) for further details.
-
-  pquota/prjquota/pqnoenforce
-	Project disk quota accounting enabled and limits (optionally)
-	enforced.  Refer to xfs_quota(8) for further details.
-
-  sunit=value and swidth=value
-	Used to specify the stripe unit and width for a RAID device
-	or a stripe volume.  "value" must be specified in 512-byte
-	block units. These options are only relevant to filesystems
-	that were created with non-zero data alignment parameters.
-
-	The sunit and swidth parameters specified must be compatible
-	with the existing filesystem alignment characteristics.  In
-	general, that means the only valid changes to sunit are
-	increasing it by a power-of-2 multiple. Valid swidth values
-	are any integer multiple of a valid sunit value.
-
-	Typically the only time these mount options are necessary if
-	after an underlying RAID device has had it's geometry
-	modified, such as adding a new disk to a RAID5 lun and
-	reshaping it.
-
-  swalloc
-	Data allocations will be rounded up to stripe width boundaries
-	when the current end of file is being extended and the file
-	size is larger than the stripe width size.
-
-  wsync
-	When specified, all filesystem namespace operations are
-	executed synchronously. This ensures that when the namespace
-	operation (create, unlink, etc) completes, the change to the
-	namespace is on stable storage. This is useful in HA setups
-	where failover must not result in clients seeing
-	inconsistent namespace presentation during or after a
-	failover event.
-
-
-Deprecated Mount Options
-========================
-
-  Name				Removal Schedule
-  ----				----------------
-
-
-Removed Mount Options
-=====================
-
-  Name				Removed
-  ----				-------
-  delaylog/nodelaylog		v4.0
-  ihashsize			v4.0
-  irixsgid			v4.0
-  osyncisdsync/osyncisosync	v4.0
-  barrier			v4.19
-  nobarrier			v4.19
-
-
-sysctls
-=======
-
-The following sysctls are available for the XFS filesystem:
-
-  fs.xfs.stats_clear		(Min: 0  Default: 0  Max: 1)
-	Setting this to "1" clears accumulated XFS statistics
-	in /proc/fs/xfs/stat.  It then immediately resets to "0".
-
-  fs.xfs.xfssyncd_centisecs	(Min: 100  Default: 3000  Max: 720000)
-	The interval at which the filesystem flushes metadata
-	out to disk and runs internal cache cleanup routines.
-
-  fs.xfs.filestream_centisecs	(Min: 1  Default: 3000  Max: 360000)
-	The interval at which the filesystem ages filestreams cache
-	references and returns timed-out AGs back to the free stream
-	pool.
-
-  fs.xfs.speculative_prealloc_lifetime
-		(Units: seconds   Min: 1  Default: 300  Max: 86400)
-	The interval at which the background scanning for inodes
-	with unused speculative preallocation runs. The scan
-	removes unused preallocation from clean inodes and releases
-	the unused space back to the free pool.
-
-  fs.xfs.error_level		(Min: 0  Default: 3  Max: 11)
-	A volume knob for error reporting when internal errors occur.
-	This will generate detailed messages & backtraces for filesystem
-	shutdowns, for example.  Current threshold values are:
-
-		XFS_ERRLEVEL_OFF:       0
-		XFS_ERRLEVEL_LOW:       1
-		XFS_ERRLEVEL_HIGH:      5
-
-  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 256)
-	Causes certain error conditions to call BUG(). Value is a bitmask;
-	OR together the tags which represent errors which should cause panics:
-
-		XFS_NO_PTAG                     0
-		XFS_PTAG_IFLUSH                 0x00000001
-		XFS_PTAG_LOGRES                 0x00000002
-		XFS_PTAG_AILDELETE              0x00000004
-		XFS_PTAG_ERROR_REPORT           0x00000008
-		XFS_PTAG_SHUTDOWN_CORRUPT       0x00000010
-		XFS_PTAG_SHUTDOWN_IOERROR       0x00000020
-		XFS_PTAG_SHUTDOWN_LOGERROR      0x00000040
-		XFS_PTAG_FSBLOCK_ZERO           0x00000080
-		XFS_PTAG_VERIFIER_ERROR         0x00000100
-
-	This option is intended for debugging only.
-
-  fs.xfs.irix_symlink_mode	(Min: 0  Default: 0  Max: 1)
-	Controls whether symlinks are created with mode 0777 (default)
-	or whether their mode is affected by the umask (irix mode).
-
-  fs.xfs.irix_sgid_inherit	(Min: 0  Default: 0  Max: 1)
-	Controls files created in SGID directories.
-	If the group ID of the new file does not match the effective group
-	ID or one of the supplementary group IDs of the parent dir, the
-	ISGID bit is cleared if the irix_sgid_inherit compatibility sysctl
-	is set.
-
-  fs.xfs.inherit_sync		(Min: 0  Default: 1  Max: 1)
-	Setting this to "1" will cause the "sync" flag set
-	by the xfs_io(8) chattr command on a directory to be
-	inherited by files in that directory.
-
-  fs.xfs.inherit_nodump		(Min: 0  Default: 1  Max: 1)
-	Setting this to "1" will cause the "nodump" flag set
-	by the xfs_io(8) chattr command on a directory to be
-	inherited by files in that directory.
-
-  fs.xfs.inherit_noatime	(Min: 0  Default: 1  Max: 1)
-	Setting this to "1" will cause the "noatime" flag set
-	by the xfs_io(8) chattr command on a directory to be
-	inherited by files in that directory.
-
-  fs.xfs.inherit_nosymlinks	(Min: 0  Default: 1  Max: 1)
-	Setting this to "1" will cause the "nosymlinks" flag set
-	by the xfs_io(8) chattr command on a directory to be
-	inherited by files in that directory.
-
-  fs.xfs.inherit_nodefrag	(Min: 0  Default: 1  Max: 1)
-	Setting this to "1" will cause the "nodefrag" flag set
-	by the xfs_io(8) chattr command on a directory to be
-	inherited by files in that directory.
-
-  fs.xfs.rotorstep		(Min: 1  Default: 1  Max: 256)
-	In "inode32" allocation mode, this option determines how many
-	files the allocator attempts to allocate in the same allocation
-	group before moving to the next allocation group.  The intent
-	is to control the rate at which the allocator moves between
-	allocation groups when allocating extents for new files.
-
-Deprecated Sysctls
-==================
-
-None at present.
-
-
-Removed Sysctls
-===============
-
-  Name				Removed
-  ----				-------
-  fs.xfs.xfsbufd_centisec	v4.0
-  fs.xfs.age_buffer_centisecs	v4.0
-
-
-Error handling
-==============
-
-XFS can act differently according to the type of error found during its
-operation. The implementation introduces the following concepts to the error
-handler:
-
- -failure speed:
-	Defines how fast XFS should propagate an error upwards when a specific
-	error is found during the filesystem operation. It can propagate
-	immediately, after a defined number of retries, after a set time period,
-	or simply retry forever.
-
- -error classes:
-	Specifies the subsystem the error configuration will apply to, such as
-	metadata IO or memory allocation. Different subsystems will have
-	different error handlers for which behaviour can be configured.
-
- -error handlers:
-	Defines the behavior for a specific error.
-
-The filesystem behavior during an error can be set via sysfs files. Each
-error handler works independently - the first condition met by an error handler
-for a specific class will cause the error to be propagated rather than reset and
-retried.
-
-The action taken by the filesystem when the error is propagated is context
-dependent - it may cause a shut down in the case of an unrecoverable error,
-it may be reported back to userspace, or it may even be ignored because
-there's nothing useful we can with the error or anyone we can report it to (e.g.
-during unmount).
-
-The configuration files are organized into the following hierarchy for each
-mounted filesystem:
-
-  /sys/fs/xfs/<dev>/error/<class>/<error>/
-
-Where:
-  <dev>
-	The short device name of the mounted filesystem. This is the same device
-	name that shows up in XFS kernel error messages as "XFS(<dev>): ..."
-
-  <class>
-	The subsystem the error configuration belongs to. As of 4.9, the defined
-	classes are:
-
-		- "metadata": applies metadata buffer write IO
-
-  <error>
-	The individual error handler configurations.
-
-
-Each filesystem has "global" error configuration options defined in their top
-level directory:
-
-  /sys/fs/xfs/<dev>/error/
-
-  fail_at_unmount		(Min:  0  Default:  1  Max: 1)
-	Defines the filesystem error behavior at unmount time.
-
-	If set to a value of 1, XFS will override all other error configurations
-	during unmount and replace them with "immediate fail" characteristics.
-	i.e. no retries, no retry timeout. This will always allow unmount to
-	succeed when there are persistent errors present.
-
-	If set to 0, the configured retry behaviour will continue until all
-	retries and/or timeouts have been exhausted. This will delay unmount
-	completion when there are persistent errors, and it may prevent the
-	filesystem from ever unmounting fully in the case of "retry forever"
-	handler configurations.
-
-	Note: there is no guarantee that fail_at_unmount can be set while an
-	unmount is in progress. It is possible that the sysfs entries are
-	removed by the unmounting filesystem before a "retry forever" error
-	handler configuration causes unmount to hang, and hence the filesystem
-	must be configured appropriately before unmount begins to prevent
-	unmount hangs.
-
-Each filesystem has specific error class handlers that define the error
-propagation behaviour for specific errors. There is also a "default" error
-handler defined, which defines the behaviour for all errors that don't have
-specific handlers defined. Where multiple retry constraints are configuredi for
-a single error, the first retry configuration that expires will cause the error
-to be propagated. The handler configurations are found in the directory:
-
-  /sys/fs/xfs/<dev>/error/<class>/<error>/
-
-  max_retries			(Min: -1  Default: Varies  Max: INTMAX)
-	Defines the allowed number of retries of a specific error before
-	the filesystem will propagate the error. The retry count for a given
-	error context (e.g. a specific metadata buffer) is reset every time
-	there is a successful completion of the operation.
-
-	Setting the value to "-1" will cause XFS to retry forever for this
-	specific error.
-
-	Setting the value to "0" will cause XFS to fail immediately when the
-	specific error is reported.
-
-	Setting the value to "N" (where 0 < N < Max) will make XFS retry the
-	operation "N" times before propagating the error.
-
-  retry_timeout_seconds		(Min:  -1  Default:  Varies  Max: 1 day)
-	Define the amount of time (in seconds) that the filesystem is
-	allowed to retry its operations when the specific error is
-	found.
-
-	Setting the value to "-1" will allow XFS to retry forever for this
-	specific error.
-
-	Setting the value to "0" will cause XFS to fail immediately when the
-	specific error is reported.
-
-	Setting the value to "N" (where 0 < N < Max) will allow XFS to retry the
-	operation for up to "N" seconds before propagating the error.
-
-Note: The default behaviour for a specific error handler is dependent on both
-the class and error context. For example, the default values for
-"metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
-to "fail immediately" behaviour. This is done because ENODEV is a fatal,
-unrecoverable error no matter how many times the metadata IO is retried.
diff --git a/MAINTAINERS b/MAINTAINERS
index d0ed73599..66e972e9a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17364,7 +17364,7 @@ L:	linux-xfs@vger.kernel.org
 W:	http://xfs.org/
 T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 S:	Supported
-F:	Documentation/filesystems/xfs.txt
+F:	Documentation/filesystems/xfs.rst
 F:	fs/xfs/
 
 XILINX AXI ETHERNET DRIVER
-- 
2.22.0

