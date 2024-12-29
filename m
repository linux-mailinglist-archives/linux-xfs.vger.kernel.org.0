Return-Path: <linux-xfs+bounces-17645-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBBC89FDEFB
	for <lists+linux-xfs@lfdr.de>; Sun, 29 Dec 2024 14:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FD57161822
	for <lists+linux-xfs@lfdr.de>; Sun, 29 Dec 2024 13:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A5FC155CB3;
	Sun, 29 Dec 2024 13:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K3hkOS+A"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39C9148FE8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479316; cv=none; b=G4QT8F4/RWLbp8htbpqJGBei7O4DXweDFETh/eCiBTeHEzsyxOnGDUBe/sMOa87fnhdYNulWQMNsTCv2qQ8HfdHjc0wgsezMd4+P8Bq+cgP9dV2L90tcgxw9SLjGMIo3m2bGwF3Tlk8SSHWGlB9gqZMcA3S0YjJsn+A2PYFD1lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479316; c=relaxed/simple;
	bh=SKmR4XC8XQmf3ntmzf8bWWu7AMxrqhxWnR+wopxrdcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHORkVZ5aESn62H+Qb+aL5vaiajDYUYC8UVedwpyx4Clr2iOW8scbr4hyINN1q6v4EBuza9LUT+dDUZSsZGN2sZsQ4o2987410Tx0uKf5Cxau0FPdh3iqSsdnAg8PLQKmPrtI6shENRwcu36KGhrjodZi7DjVMCM0J6gsf/XpRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K3hkOS+A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=glBacYWfX9Q3xp8T1KVNQ0gzBh0tlRGa7EpyFCNx4to=;
	b=K3hkOS+A1aj2EswLuGw5YpGAkhy13TkyGz/Rq8FAbTXXR25MRDAdqeaTZErWaVjObWVUJt
	sV5N6NQ3P5ok/7dNYaoD+NErYnpUgEvDaWMeJGIuFgCJY0smxpjgN7HKOr7Hq4f+LrDATk
	436+H7hzt++jkArlpXfJ/f+pJIGiAsE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-JyE1RnzDPvuMH78QPzlK2w-1; Sun, 29 Dec 2024 08:35:11 -0500
X-MC-Unique: JyE1RnzDPvuMH78QPzlK2w-1
X-Mimecast-MFC-AGG-ID: JyE1RnzDPvuMH78QPzlK2w
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5d3f3d6a999so2201945a12.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:35:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479309; x=1736084109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=glBacYWfX9Q3xp8T1KVNQ0gzBh0tlRGa7EpyFCNx4to=;
        b=Wza2Hh6dKhZharrTOIcGxXKL1W8D5pY1Apy8q5ootrlz+/J0C4k5U0YQTafslOMSbI
         lhFgsPNzLu1zP8XD4pmPZ5uQ3s99MpBP4PM7zOnSoS1ayBImI0aNhVgUfUCuhBGsZij/
         zy3gwfuH2aXo9wdyjCFb8c6t3NAdtHeUaPmvcaYJNkW+lvvzl6b0SO8hISNaIyCKzfDP
         4v4p0hofNrwvfU7YmPviby5kUGQ6X81xemw8nlKcR+xVH2eGm2e1sw5fxJv0Lmjsax2I
         ilZ/XRCAQP9U2YAqFzRPtWATBHnxL2lasVXGKrkTBMlj5HEggeLq7SxM8xessiUwroks
         Z7tg==
X-Gm-Message-State: AOJu0YzTP7yfu50fNy5SyAnu5LRlb1PQm9fj8CikFY1wv5re15/Gq1Pn
	wAplWW/xK9M346reJiU3DFiai922MGyJ8ji6TQEAvoMMUNyoxP1YaB0e5go+Kr3TcN/wdRN8kZ6
	+Rnb6rnRfJrnuVBG/K5OD5yOT7UUal8GOmtsii+/pJmD4Oqsd4OPRh5DMxASlDSNWrkzrTqtE5V
	WtH79Yr6DpV4n1cG6U/I0mYdHM2IwvtT9A5VN/ZcQw
X-Gm-Gg: ASbGncv2uOTbBY9NU/caQPmqcQkUnwk8ozm7W8qTnQ0zmccco9GPfqXhAHR7xDaOu6g
	D2hF1kfyjZ1jQb/0XUJueI9vlks0SfxExaRHmcn1/cfkltTmzTnybmveDUEP7QIadqcbNiHTHEh
	uzCZe5TwYPQHAY71NsX7K4e5foc7HDl99tmM9CGZ6gs5ZRvpe2yv2fxS0umjTCm9BZ4p5TjanPc
	lpSPe740WNpE6QbdzQwIraovnDQW3+cdTmYztp5HhwVTEVLNAc9/wskXp6MPOLM7HuMuD1tfewn
	OxDO+tHVPahf/Fo=
X-Received: by 2002:a05:6402:2345:b0:5d1:2377:5afc with SMTP id 4fb4d7f45d1cf-5d81dd66e6amr28247596a12.3.1735479308849;
        Sun, 29 Dec 2024 05:35:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFnmsg0kwGWqm95HFd8o2uPcvESpbtgkG4hEYpC8X2K6iDPnZGvaa3QAuEzuI3hI4r29DIpg==
X-Received: by 2002:a05:6402:2345:b0:5d1:2377:5afc with SMTP id 4fb4d7f45d1cf-5d81dd66e6amr28247549a12.3.1735479308238;
        Sun, 29 Dec 2024 05:35:08 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679eebcsm13481700a12.41.2024.12.29.05.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:35:07 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH] xfs: direct mapped xattrs design documentation
Date: Sun, 29 Dec 2024 14:35:01 +0100
Message-ID: <20241229133501.1192867-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133350.1192387-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Direct mapped xattrs are a form of remote xattr that don't contain
internal self describing metadata. Hence the xattr data can be
directly mapped into page cache pages by iomap infrastructure
without needing to go through the XFS buffer cache.

This functionality allows XFS to implement fsverity data checksum
information externally to the file data, but interact with XFS data
checksum storage through the existing page cache interface.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 .../xfs/xfs-direct-mapped-xattr-design.rst    | 304 ++++++++++++++++++
 1 file changed, 304 insertions(+)
 create mode 100644 Documentation/filesystems/xfs/xfs-direct-mapped-xattr-design.rst

diff --git a/Documentation/filesystems/xfs/xfs-direct-mapped-xattr-design.rst b/Documentation/filesystems/xfs/xfs-direct-mapped-xattr-design.rst
new file mode 100644
index 000000000000..a0efa9546eca
--- /dev/null
+++ b/Documentation/filesystems/xfs/xfs-direct-mapped-xattr-design.rst
@@ -0,0 +1,304 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================================
+XFS Direct Mapped Extended Atrtibutes
+=====================================
+
+Background
+==========
+
+We have need to support fsverity in XFS. An attempt to support fsverity
+using named remote xattrs has already been made, but the complexity of the
+solution has made acceptance of that implementation .... challenging.
+
+The fundamental problem caused by using remote xattr blocks to store the
+fsverity checksum data is that the data is stored as opaque filesystem block
+sized chunks of data and accesses them directly through a page cache based
+interface interface.
+
+These filesystem block sized chunks do not fit neatly into remote xattr blocks
+because the remote xattr blocks have metadata headers in them containing self
+describing metadata and CRCs for the metadata. Hence filesystem block sized data
+now spans two filesystem blocks and is not contiguous on disk (it is split up
+by headers).
+
+The fsverity interfaces require page aligned data blocks, which then requires
+copying the fsverity data out of the xattr buffers into a separate bounce buffer
+which is then cached independently of the xattr buffer. IOWs, we have to double
+buffer the fsverity checksum data and that costs a lot in terms of complexity.
+
+Because the remote xattr data is also using the generic xattr read code, it
+requires use of xfs metadata buffers to read and write it to disk. Hence we have
+block based IO requirements for the fsverity data, not page based IO
+requirements. Hence there is an impedence mismatch between the fsverity IO model
+and the XFS xattr IO model as well.
+
+
+Directories, Xattrs and dabtrees
+================================
+
+Directories in XFS are complex - they maintain two separate lookup indexes to
+the dirent data because we have to optimise for two different types of access.
+We also have dirent stability requirements for seek operations.
+
+Hence directories have an offset indexed data segment that hold dirent data,
+with each individual dirent at an offset that is fixed for the life of the
+dirent. This provides dirent stability as the offset of the dirent can be used
+as a seek cookie. This offset indexed data segment is optimised for dirent
+reading by readdir/getdents which iterates sequentially through the dirent data
+and requires stable cookies for iteration continuation.
+
+Directories must also support lookup by name - path based directory lookups need
+to find the dirent by name rather than by offset. This is implemented by the
+dabtree in the directory. It stores name hashes and the leaf records for a
+specific name hash point to the offset of the dirent with that hash. Hence name
+based lookups are fast and efficient when directed through the dabtree.
+Importantly, the dabtree does not store dirent data, it simply provides a
+pointer to the external dirent: the stable offset of the dirent in the offset
+indexed data segment.
+
+In comparison, the attr fork dabtree only has one index - the name hash based
+dabtree. Everything stored in the xattr fork needs to be named and the record
+for the xattr data is indexed by the hash of that name. As there is no external
+stable offset based index data segment, data that does not fit inline in the
+xattr leaf record gets stored in a dynamically allocated remote xattr extent.
+The remote extent is created at the first largest hole in the xattr address space,
+so the remote xattr data does not get allocated sequentially on disk.
+
+Further, because everything is name hash indexed, sequential offset indexed data
+is not going to hash down to sequential record indexes in the dabtree. Hence
+access to offset index based xattr data is not going to be sequential in either
+record lookup patterns nor xattr data read patterns. This isn't a huge issue
+as the dabtree blocks rapidly get cached, but it does consume more CPU time
+that doing equivalent sequential offset based access in the directory structure.
+
+Darrick Wong pondered whether it would help to create a sequentially
+indexed segment in the xattr fork for the merkle tree blocks when discussing
+better ways to handle fsverity metadata. This document is intended to flesh out
+that concept into something that is usable by mutable data checksum
+functionality.
+
+
+fsverity is just data checksumming
+==================================
+
+I had a recent insight into fsverity when discussing what to do with the
+fsverity code with Andrey. That insight came from realising that all fsverity
+was doing is recording a per-filesystem block checksum and then validating
+it on read. While this might seem obvious now that I say it, the previous
+approach we took was all about fsverity needing to read and write opaque blocks
+of individually accessed metadata.
+
+Storing opaque, externally defined metadata is what xattrs are intended to be
+used for, and that drove the original design. i.e. a fsverity merkle tree block
+was just another named xattr object that encoded the tree index in the xattr
+name. Simple and straight forward from the xattr POV, but all the complexity
+arose in translating the xattr data into a form that fsverity could use.
+
+Fundamentally, however, the merkle tree blocks just contain data checksums.
+Yes, they are complex, cryptographically secure data checksums, but the
+fundamental observation is that there is a direct relationship between the file
+data at a given offset and the contents of merkle tree block at a given tree
+index.
+
+fsverity has a mechanism to calculate the checksums from the file data and store
+them in filesystem blocks, hence providing external checksum storage for the
+file data. It also has mechanism to read the external checksum storage and
+compare that against the calculated checksum of the data. Hence fsverity is just
+a fancy way of saying the filesystem provides "tamper proof read-only data
+checksum verification"
+
+But what if we want data checksums for normal read-write data files to be able
+to detect bit-rot in data at rest?
+
+
+Direct Mapped Xattr Data
+========================
+
+fsverity really wants to read and write it's checksum data through the page
+cache. To do this efficiently, we need to store the fsverity metadata in block
+aligned data storage. We don't have that capability in XFS xattrs right now, and
+this is what we really want/need for data checksum storage. There are two ways
+of doing direct mapped xattr data.
+
+A New Remote Xattr Record Format
+--------------------------------
+
+The first way we can do direct mapped xattr data is to change the format of the
+remote xattr. The remote xattr header currently looks like this:
+
+.. code-block:: c
+
+	typedef struct xfs_attr_leaf_name_remote {
+		__be32  valueblk;               /* block number of value bytes */
+		__be32  valuelen;               /* number of bytes in value */
+		__u8    namelen;                /* length of name bytes */
+		/*
+		 * In Linux 6.5 this flex array was converted from name[1] to name[].
+		 * Be very careful here about extra padding at the end; see
+		 * xfs_attr_leaf_entsize_remote() for details.
+		 */
+		__u8    name[];                 /* name bytes */
+	} xfs_attr_leaf_name_remote_t;
+
+It stores the location and size of the remote xattr data as a filesystem block
+offset into the attr fork, along with the xattr name. The remote xattr block
+contains then this self describing header:
+
+.. code-block:: c
+
+	struct xfs_attr3_rmt_hdr {
+		__be32  rm_magic;
+		__be32  rm_offset;
+		__be32  rm_bytes;
+		__be32  rm_crc;
+		uuid_t  rm_uuid;
+		__be64  rm_owner;
+		__be64  rm_blkno;
+		__be64  rm_lsn;
+	};
+
+This is the self describing metadata that we use to validate the xattr data
+block is what it says it is, and this is the cause of the unaligned remote xattr
+data.
+
+The key field in the self describing metadata is ``*rm_crc``. This
+contains the CRC of the xattr data, and that tells us that the contents of the
+xattr data block are the same as what we wrote to disk. Everything else in
+this header is telling us who the block belongs to, it's expected size and
+when and where it was written to. This is far less critical to detecting storage
+errors than the CRC.
+
+Hence if we drop this header and move the ``rm_crc`` field to the ``struct
+xfs_attr_leaf_name_remote``, we can still check that the xattr data is has not
+been changed since we wrote the data to storage. If we have rmap enabled we
+have external tracking of the owner for the xattr data block, as well as the
+offset into the xattr data fork. ``rm_lsn`` is largely meaningless for remote
+xattrs because the data is written synchronously before the dabtree remote
+record is committed to the journal.
+
+Hence we can drop the headers from the remote xattr data blocks and not really
+lose much in way of robustness or recovery capability when rmap is enabled. This
+means all the xattr data is now filesystem block aligned, and this enables us to
+directly map the xattr data blocks directly for read IO.
+
+However, we can't easily directly map this xattr data for write operations. The
+xattr record header contains the CRC, and this needs to be updated
+transactionally. We can't update this before we do a direct mapped xattr write,
+because we have to do the write before we can recalculate the CRC. We can't do
+it after the write, because then we can have the transaction commit before the
+direct mapped data write IO is submitted and completed. This means recovery
+would result in a CRC mismatch for that data block. And we can't do it after the
+data write IO completes, because if we crash before the transaction is committed
+to the journal we again have a CRC mismatch.
+
+This is made more complex because we don't allow xattr headers to be
+re-written. Currently an update to an xattr requires a "remove and recreate"
+operation to ensure that the update is atomic w.r.t. remote xattr data changes.
+
+One approach which we can take is to use two CRCs - for old and new xattr data.
+``rm_crc`` becomes ``rm_crc[2]`` and xattr gains new bit flag
+``XFS_ATTR_RMCRC_SEL_BIT``. This bit defines which of the two fields contains
+the primary CRC. When we write a new CRC, we write it into the secondary
+``rm_crc[]`` field (i.e. the one the bit does not point to). When the data IO
+completes, we toggle the bit so that it points at the new primary value.
+
+If the primary does not match but the secondary does, we can flag an online
+repair operation to run at the completion of whatever operation read the xattr
+data to correct the state of the ``XFS_ATTR_RMCRC_SEL_BIT``.
+
+If neither CRCs match, then we have an -EFSCORRUPTED situation, and that needs
+to mark the attr fork as sick (which brings it to the attention of scrub/repair)
+and return -EFSCORRUPTED to the reader.
+
+Offset-based Xattr Indexing Segments
+------------------------------------
+
+The other mechanism for direct mapping xattr data is to introduce an offset
+indexed segment similar to the directory data segment. The xattr data fork uses
+32 bit filesystem block addressing, so on a 4kB block size filesystem we can
+index 16TB of address space. A dabtree that indexes this amount of data would be
+massive and quite inefficient, and we'd likely be hitting against the maximum
+extent count limits for the attr fork at this point, anyway (32 bit extent
+count).
+
+Hence taking half the address space (the upper 8TB) isn't going to cause any
+significant limitations on what we can store in the existing attr fork dabtree.
+It does, however, provide us with a significant amount of data address space we
+can use for offset indexed based xattr data. We can even split this upper region
+into multiple segments so that it can have multiple separate sets of data and
+even dabtrees to index them.
+
+At this point in time, I do not see a need for these xattr segments to be
+directly accessible from userspace through existing xattr interfaces. If there
+is need for the data the kernel stores in an xattr data segment to be exposed to
+userspace, we can add the necessary interfaces when they are required.
+
+For the moment, let's first concentrate on what is needed in kernel space for
+the fsverity merkle tree blocks.
+
+
+Fsverity Data Segment
+`````````````````````
+
+Let's assume we have carved out a section of the inode address space for fsverity
+metadata. fsverity only supports file sizes up to 4TB (see `thread
+<https://lore.kernel.org/linux-xfs/Y5rDCcYGgH72Wn%2Fe@sol.localdomain/>`_::
+and so at a 4kB block size and 128 bytes per fsb the amount of addressing space
+needed for fsverity is a bit over 128GiB. Hence we could carve out a fixed
+256GiB address space segment just for fsverity data if we need to.
+
+When fsverity measures the file and creates the merkle tree block, it requires
+the filesystem to persistently record that inode is undergoing measurement. It
+also then tells the filesystem when measurement is complete so that the
+filesystem can remove the "under measurement" flag and seal the inode as
+fsverity protected.
+
+Hence with these persistent notifications, we don't have to care about
+persistent creation of the merkle tree data. As long as it has been written back
+before we seal the inode with a synchronous transaction, the merkle tree data
+will be stable on disk before the seal is written to the journal thanks to the
+cache flushes issued before the journal commit starts.
+
+This also means that we don't have to care about what is in the fsverity segment
+when measurement is started - we can just punch out what is already there (e.g.
+debris from a failed measurement) as the measurement process will rewrite
+the entire segment contents from scratch.
+
+Ext4 does this write process via the page cache into the inode's mapping. It
+operates at the aops level directly, but that won't work for XFS as we use iomap
+for buffered IO. Hence we need to call through iomap to map the disk space
+and allocate the page cache pages for the merkle tree data to be written.
+
+This will require us to provide an iomap_ops structure with a ->begin_iomap
+method that allocates and maps blocks from the attr fork fsverity data segment.
+We don't care what file offset the iomap code chooses to cache the folios that
+are inserted into the page cache, all we care about is that we are passed the
+merkle tree block position that it needs to be stored at.
+
+This will require iomap to be aware that it is mapping external metadata rather
+than normal file data so that it can offset the page cache index it uses for
+this data appropriately. The writeback also needs to know that it's working with
+fsverity folios past EOF. This requires changes to how those folios are mapped
+as they are indexed by xattr dabtree. The differentiation factor will be the
+fact that only merkle tree data can be written while inode is under fsverity
+initialization or filesystems also can check if these page is in "fsverity"
+region of the page cache.
+
+The writeback mapping of these specially marked merkle tree folios should be, at
+this point, relatively trivial. We will need to call fsverity ->map_blocks
+callback to map the fsverity address space rather than the file data address
+space, but other than that the process of allocating space and mapping it is
+largely identical to the existing data fork allocation code. We can even use
+delayed allocation to ensure the merkle tree data is as contiguous as possible.
+
+The read side is less complex as all it needs to do is map blocks directly from
+the fsverity address space. We can read from the region intended for the
+fsverity metadata, then ->begin_iomap will map this request to xattr data blocks
+instead of file blocks.
+
+Therefore, we can have something like iomap_read_region() and
+iomap_write_region() to know that we are righting metadata and no filesize or
+any other data releated checks need to be done. This interface will take normal
+IO arguments and an offset of the region allowing filesystem to read relative to
+this offset.
-- 
2.47.0


