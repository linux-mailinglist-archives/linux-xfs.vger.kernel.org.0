Return-Path: <linux-xfs+bounces-15936-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C0B9D9FFB
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Nov 2024 01:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA78028242D
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Nov 2024 00:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184921CA94;
	Wed, 27 Nov 2024 00:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZeF15Cc"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD641BDE6
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666792; cv=none; b=ierEiouENPJuPBVH0C+PH0sVvouj/dDSxfDL+mQ+GwxmiANl6Bb3pzAtgcQJshQMMMYHg3VeOVCqeJ7S023G2C5iWhmEHy7FKx1Y76U9bpmwOM9om1INKYaJyQKx7WtPlRqDKXoWdjWRdLg/4QDj7ZKIfIgdz+XuXd7gSwoVASM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666792; c=relaxed/simple;
	bh=PiZS44bkChSuYiSAdonoq3e8qfW8/yzOwPNOsosBl1M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVYcraYCQXRANsSjTrJD/rI4DmzwfhmRv6f6ZR5zBghmhnkG2/HbjFCenxmlOH6Pqu3NP3m3I6Nkd8bkl7tCZ8tsfoBSxk12jgD07KaRNqNST+nqwY+mThvq/5YuzbPy4hej4xV1EZNxirYZ30Oo1pCUD3wU3fQXoyvt3TebkyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZeF15Cc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D14C4CECF;
	Wed, 27 Nov 2024 00:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666792;
	bh=PiZS44bkChSuYiSAdonoq3e8qfW8/yzOwPNOsosBl1M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kZeF15CcSXOubTqJvUtfaEos/OHe3Qc6Q0Lb7PxeV1YdUmkeNSFimKx3ghBUzGYgY
	 D/+hSul9Q5z/A+Y7KUYJF0cplt+Jyohu9IvBcy+X22P/fo6yaVAcKquxNdY+QJb631
	 YvgAAilO1lOUJvqD7dCfAaRajiJWRQfxdEVtfFIcVVLIWWz5l3z1+Qv/SCA2jwnJ4v
	 uc1u8IJLQZLq27QR3jUnczF0rcyflhZmUyO4hS0LyjTYesOugIVMLql7OldCAdNdBq
	 ISdif3XSYEGOEvWXn3EihtWxMHqbIDHNlCENP/lpLVw2JK3exeoOFAaYuWsw3y9y1Z
	 P06kpx0Nwk6mQ==
Date: Tue, 26 Nov 2024 16:19:51 -0800
Subject: [PATCH 07/10] design: document realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662314.996198.11932771102538214485.stgit@frogsfrogsfrogs>
In-Reply-To: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
References: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document the ondisk changes for realtime allocation groups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../XFS_Filesystem_Structure/common_types.asciidoc |    4 
 .../internal_inodes.asciidoc                       |    2 
 design/XFS_Filesystem_Structure/magic.asciidoc     |    3 
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    2 
 design/XFS_Filesystem_Structure/realtime.asciidoc  |  344 ++++++++++++++++++++
 .../XFS_Filesystem_Structure/superblock.asciidoc   |   22 +
 6 files changed, 376 insertions(+), 1 deletion(-)


diff --git a/design/XFS_Filesystem_Structure/common_types.asciidoc b/design/XFS_Filesystem_Structure/common_types.asciidoc
index 51909be384e273..34cdfdaeccf848 100644
--- a/design/XFS_Filesystem_Structure/common_types.asciidoc
+++ b/design/XFS_Filesystem_Structure/common_types.asciidoc
@@ -43,7 +43,9 @@ Unsigned 64 bit raw filesystem block number.
 
 *xfs_rtblock_t*::
 Unsigned 64 bit extent number in the xref:Real-time_Devices[real-time]
-sub-volume.
+sub-volume.  If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled, these
+values combine an xref:Realtime_Groups[rtgroup number] and block offset into
+the realtime group.
 
 *xfs_fileoff_t*::
 Unsigned 64 bit block offset into a file.
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 68c86d30ff8206..5f4d62201cbd67 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -21,6 +21,8 @@ of those inodes have been deallocated and may be reused by future features.
 [options="header"]
 |=====
 | Metadata File                                  | Location
+| xref:Real-Time_Bitmap_Inode[Realtime Bitmap]   | /rtgroups/*.bitmap
+| xref:Real-Time_Summary_Inode[Realtime Summary] | /rtgroups/*.summary
 |=====
 
 Metadata files are flagged by the +XFS_DIFLAG2_METADATA+ flag in the
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 60952aeb876ff5..5da29b9ef9f3a8 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -45,9 +45,12 @@ relevant chapters.  Magic numbers tend to have consistent locations:
 | +XFS_ATTR3_LEAF_MAGIC+	| 0x3bee	|     	| xref:Leaf_Attributes[Leaf Attribute], v5 only
 | +XFS_ATTR3_RMT_MAGIC+		| 0x5841524d	| XARM	| xref:Remote_Values[Remote Attribute Value], v5 only
 | +XFS_RMAP_CRC_MAGIC+		| 0x524d4233	| RMB3	| xref:Reverse_Mapping_Btree[Reverse Mapping B+tree], v5 only
+| +XFS_RTBITMAP_MAGIC+		| 0x424D505A	| BMPZ	| xref:Real-Time_Bitmap_Inode[Real-Time Bitmap], metadir only
+| +XFS_RTSUMMARY_MAGIC+		| 0x53554D59	| SUMY	| xref:Real-Time_Summary_Inode[Real-Time Summary], metadir only
 | +XFS_RTRMAP_CRC_MAGIC+	| 0x4d415052	| MAPR	| xref:Real_time_Reverse_Mapping_Btree[Real-Time Reverse Mapping B+tree], v5 only
 | +XFS_REFC_CRC_MAGIC+		| 0x52334643	| R3FC	| xref:Reference_Count_Btree[Reference Count B+tree], v5 only
 | +XFS_MD_MAGIC+		| 0x5846534d	| XFSM	| xref:Metadata_Dumps[Metadata Dumps]
+| +XFS_RTSB_MAGIC+		| 0x46726F67	| Frog	| xref:Realtime_Groups[Realtime Groups]
 |=====
 
 The magic numbers for log items are at offset zero in each log item, but items
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 02ec0d12bb57e5..e28929907147b7 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -199,6 +199,8 @@ directory tree.
 [source, c]
 ----
 enum xfs_metafile_type {
+     XFS_METAFILE_RTBITMAP,
+     XFS_METAFILE_RTSUMMARY,
 };
 ----
 
diff --git a/design/XFS_Filesystem_Structure/realtime.asciidoc b/design/XFS_Filesystem_Structure/realtime.asciidoc
index 11426e8fdb632d..3a72eb5175ad89 100644
--- a/design/XFS_Filesystem_Structure/realtime.asciidoc
+++ b/design/XFS_Filesystem_Structure/realtime.asciidoc
@@ -31,6 +31,146 @@ and bits per byte. This value is stored in +sb_rbmblocks+. The nblocks and
 extent array for the inode should match this.  Each real time block gets its
 own bit in the bitmap.
 
+If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled, each block of the
+realtime bitmap file has a header of the following format:
+
+[source, c]
+----
+struct xfs_rtbuf_blkinfo {
+	__be32		rt_magic;
+	__be32		rt_crc;
+	__be64		rt_owner;
+	__be64		rt_blkno;
+	__be64		rt_lsn;
+	uuid_t		rt_uuid;
+};
+----
+
+*rt_magic*::
+Specifies the magic number for the rtbitmap block: ``BMPZ'' (0x424D505A).
+
+*rt_crc*::
+Checksum of the block.
+
+*rt_owner*::
+Specifies the inode number for the file that owns this block.
+
+*rt_blkno*::
+Disk address of this block.
+
+*rt_lsn*::
+Log sequence number of the last write to this block.
+
+*rt_uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+After the block header, the bitmap data are encoded as be32 word values.
+
+=== xfs_db rtbitmap Example
+
+This example shows a real-time bitmap file from a freshly populated filesystem:
+
+----
+xfs_db> path -m /rtgroups/3.bitmap
+xfs_db> p
+core.magic = 0x494e
+core.mode = 0100000
+core.version = 3
+core.format = 2 (extents)
+core.metatype = 5 (rtbitmap)
+core.uid = 0
+core.gid = 0
+core.nlinkv2 = 1
+core.projid_lo = 3
+core.projid_hi = 0
+core.nextents = 1
+core.atime.sec = Tue Oct 15 16:04:02 2024
+core.atime.nsec = 769675000
+core.mtime.sec = Tue Oct 15 16:04:02 2024
+core.mtime.nsec = 769675000
+core.ctime.sec = Tue Oct 15 16:04:02 2024
+core.ctime.nsec = 769681000
+core.size = 135168
+core.nblocks = 33
+core.extsize = 0
+core.naextents = 0
+core.forkoff = 24
+core.aformat = 1 (local)
+core.dmevmask = 0
+core.dmstate = 0
+core.newrtbm = 0
+core.prealloc = 0
+core.realtime = 0
+core.immutable = 1
+core.append = 0
+core.sync = 1
+core.noatime = 1
+core.nodump = 1
+core.rtinherit = 0
+core.projinherit = 0
+core.nosymlinks = 0
+core.extsz = 0
+core.extszinherit = 0
+core.nodefrag = 1
+core.filestream = 0
+core.gen = 2653591217
+next_unlinked = null
+v3.crc = 0x34a17119 (correct)
+v3.change_count = 3
+v3.lsn = 0
+v3.flags2 = 0x38
+v3.cowextsize = 0
+v3.crtime.sec = Tue Oct 15 16:04:02 2024
+v3.crtime.nsec = 769675000
+v3.inumber = 33685633
+v3.uuid = a6575f59-1514-445e-883e-211b2c5a0f05
+v3.reflink = 0
+v3.cowextsz = 0
+v3.dax = 0
+v3.bigtime = 1
+v3.nrext64 = 1
+v3.metadata = 1
+u3.bmx[0] = [startoff,startblock,blockcount,extentflag] 
+0:[0,4210712,33,0]
+a.sfattr.hdr.totsize = 27
+a.sfattr.hdr.count = 1
+a.sfattr.list[0].namelen = 8
+a.sfattr.list[0].valuelen = 12
+a.sfattr.list[0].root = 0
+a.sfattr.list[0].secure = 0
+a.sfattr.list[0].parent = 1
+a.sfattr.list[0].name = "0.bitmap"
+a.sfattr.list[0].parent_dir.inumber = 33685632
+a.sfattr.list[0].parent_dir.gen = 142228546
+xfs_db> dblock 0
+xfs_db> p
+magicnum = 0x424d505a
+crc = 0xc8b10abf (correct)
+owner = 33685633
+bno = 20902080
+lsn = 0x100007696
+uuid = a6575f59-1514-445e-883e-211b2c5a0f05
+rtwords[0-1011] = 0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0 8:0 9:0 10:0 11:0 12:0 13:0
+14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0xfffff800 22:0xffffffff 23:0xffffffff
+24:0xffffffff 25:0xffffffff 26:0xffffffff 27:0xffffffff 28:0xffffffff
+29:0xffffffff 30:0xffffffff 31:0xffffffff 32:0xffffffff
+...
+979:0xffffffff 980:0xffffffff 981:0xffffffff 982:0xffffffff 983:0xffffffff
+984:0xffffffff 985:0xffffffff 986:0xffffffff 987:0xffffffff 988:0xffffffff
+989:0xffffffff 990:0xffffffff 991:0xffffffff 992:0xffffffff 993:0xffffffff
+994:0xffffffff 995:0xffffffff 996:0xffffffff 997:0xffffffff 998:0xffffffff
+999:0xffffffff 1000:0xffffffff 1001:0xffffffff 1002:0xffffffff 1003:0xffffffff
+1004:0xffffffff 1005:0xffffffff 1006:0xffffffff 1007:0xffffffff 1008:0xffffffff
+1009:0xffffffff 1010:0xffffffff 1011:0xffffffff
+----
+
+From this example, we can clearly see that this is a bitmap file in the
+metadata directory tree, and that it is the bitmap file for rtgroup 3.  When we
+access the first block in the bitmap file, we can clearly see the new block
+header and that the first 179 extents are allocated.  The bitmap words were
+excerpted for brevity.
+
 [[Real-Time_Summary_Inode]]
 == Free Space Summary Inode
 
@@ -47,4 +187,208 @@ This data structure is not particularly space efficient, however it is a very
 fast way to provide the same data as the two free space B+trees for regular
 files since the space is preallocated and metadata maintenance is minimal.
 
+If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled, each block of the
+realtime summary file has the same header as rtbitmap file blocks.  However,
+the magic number will be ``SUMY'' (0x53554D59).  After the block header, the
+summary counts are encoded as be32 integers.
+
+=== xfs_db rtsummary Example
+
+This example shows a real-time summary file from a freshly populated filesystem:
+
+----
+xfs_db> path -m /rtgroups/3.summary
+xfs_db> p
+core.magic = 0x494e
+core.mode = 0100000
+core.version = 3
+core.format = 2 (extents)
+core.metatype = 6 (rtsummary)
+core.uid = 0
+core.gid = 0
+core.nlinkv2 = 1
+core.projid_lo = 3
+core.projid_hi = 0
+core.nextents = 1
+core.atime.sec = Tue Oct 15 16:04:02 2024
+core.atime.nsec = 769694000
+core.mtime.sec = Tue Oct 15 16:04:02 2024
+core.mtime.nsec = 769694000
+core.ctime.sec = Tue Oct 15 16:04:02 2024
+core.ctime.nsec = 769699000
+core.size = 4096
+core.nblocks = 1
+core.extsize = 0
+core.naextents = 0
+core.forkoff = 24
+core.aformat = 1 (local)
+core.dmevmask = 0
+core.dmstate = 0
+core.newrtbm = 0
+core.prealloc = 0
+core.realtime = 0
+core.immutable = 1
+core.append = 0
+core.sync = 1
+core.noatime = 1
+core.nodump = 1
+core.rtinherit = 0
+core.projinherit = 0
+core.nosymlinks = 0
+core.extsz = 0
+core.extszinherit = 0
+core.nodefrag = 1
+core.filestream = 0
+core.gen = 519466891
+next_unlinked = null
+v3.crc = 0x54fc58d0 (correct)
+v3.change_count = 3
+v3.lsn = 0
+v3.flags2 = 0x38
+v3.cowextsize = 0
+v3.crtime.sec = Tue Oct 15 16:04:02 2024
+v3.crtime.nsec = 769694000
+v3.inumber = 33685634
+v3.uuid = a6575f59-1514-445e-883e-211b2c5a0f05
+v3.reflink = 0
+v3.cowextsz = 0
+v3.dax = 0
+v3.bigtime = 1
+v3.nrext64 = 1
+v3.metadata = 1
+u3.bmx[0] = [startoff,startblock,blockcount,extentflag] 
+0:[0,4210703,1,0]
+a.sfattr.hdr.totsize = 28
+a.sfattr.hdr.count = 1
+a.sfattr.list[0].namelen = 9
+a.sfattr.list[0].valuelen = 12
+a.sfattr.list[0].root = 0
+a.sfattr.list[0].secure = 0
+a.sfattr.list[0].parent = 1
+a.sfattr.list[0].name = "0.summary"
+a.sfattr.list[0].parent_dir.inumber = 33685632
+a.sfattr.list[0].parent_dir.gen = 142228546
+xfs_db> dblock 0
+xfs_db> p
+magicnum = 0x53554d59
+crc = 0x473340a8 (correct)
+owner = 33685634
+bno = 20902008
+lsn = 0x100007696
+uuid = a6575f59-1514-445e-883e-211b2c5a0f05
+suminfo[0-1011] = 0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0 8:0 9:0 10:0 11:0 12:0 13:0
+14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:0 24:0 25:0 26:0 27:0 28:0 29:0
+30:0 31:0 32:0
+...
+618:0 619:0 620:0 621:0 622:0 623:0 624:0 625:0 626:0 627:1 628:0 629:0 630:0
+...
+979:0 980:0 981:0 982:0 983:0 984:0 985:0 986:0 987:0 988:0 989:0 990:0 991:0
+992:0 993:0 994:0 995:0 996:0 997:0 998:0 999:0 1000:0 1001:0 1002:0 1003:0
+1004:0 1005:0 1006:0 1007:0 1008:0 1009:0 1010:0 1011:0
+----
+
+From this example, we can clearly see that this is a summary file in the
+metadata directory tree, and that it is the summary file for rtgroup 3.  When
+we access the first block in the summary file, we can clearly see the new block
+header and the nonzero counter for the one large free extent in this group.
+The summary counts were excerpted for brevity.
+
+[[Realtime_Groups]]
+== Realtime Groups
+
+To reduce metadata contention for space allocation and remapping activities
+being applied to realtime files, the realtime volume can be split into
+allocation groups, just like the data volume.  The free space information is
+still contained in a single file that applies to the entire volume.
+
+Each realtime allocation group can contain up to (2^31^ - 1) filesystem blocks,
+regardless of the underlying realtime extent size.
+
+Each realtime group has the following characteristics:
+
+         * Group 0 has a super block describing overall filesystem info
+         * Free space bitmap
+         * Summary of free space
+
+The free space metadata are the same as described in the previous sections,
+except that their scope covers only a single rtgroup.  The other structures are
+expanded upon in the following sections.
+
+[[Realtime_Group_Superblocks]]
+=== Superblocks
+
+The first block of each realtime group contains a superblock.  These fields
+must match their counterparts in the filesystem superblock on the data device.
+
+[source, c]
+----
+struct xfs_rtsb {
+	__be32		rsb_magicnum;
+	__le32		rsb_crc;
+
+	__be32		rsb_pad;
+	unsigned char	rsb_fname[XFSLABEL_MAX];
+
+	uuid_t		rsb_uuid;
+	uuid_t		rsb_meta_uuid;
+
+	/* must be padded to 64 bit alignment */
+};
+----
+
+*rsb_magicnum*::
+Identifies the filesystem. Its value is +XFS_RTSB_MAGIC+ ``Frog'' (0x46726F67).
+
+*rsb_crc*::
+Superblock checksum.
+
+*rsb_pad*::
+Must be zero.
+
+*rsb_fname[12]*::
+Name for the filesystem.  This matches +sb_fname+ in the primary superblock.
+
+*rsb_uuid*::
+UUID (Universally Unique ID) for the filesystem.  This matches +sb_uuid+ in the
+primary superblock.
+
+*rsb_meta_uuid*::
+Metadata UUID for the filesystem.  This matches +sb_meta_uuid+ in the primary
+superblock.
+
+==== xfs_db rtgroup Superblock Example
+
+A filesystem is made on a multidisk filesystem with the following command:
+
+----
+# mkfs.xfs -r rtgroups=1,rgcount=4,rtdev=/dev/sdb /dev/sda -f
+meta-data=/dev/sda               isize=512    agcount=4, agsize=1298176 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1, sparse=1, rmapbt=1
+         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
+         =                       metadir=1
+data     =                       bsize=4096   blocks=5192704, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
+log      =internal log           bsize=4096   blocks=16384, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =/dev/sdb               extsz=4096   blocks=5192704, rtextents=5192704
+         =                       rgcount=5    rgsize=1048576 extents
+----
+
+And in xfs_db, inspecting the realtime group superblock and then the regular
+superblock:
+
+----
+# xfs_db -R /dev/sdb /dev/sda
+xfs_db> rtsb
+xfs_db> print
+magicnum = 0x46726f67
+crc = 0x759a62d4 (correct)
+pad = 0
+fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
+uuid = 7e55b909-8728-4d69-a1fa-891427314eea
+meta_uuid = 7e55b909-8728-4d69-a1fa-891427314eea
+----
+
 include::rtrmapbt.asciidoc[]
diff --git a/design/XFS_Filesystem_Structure/superblock.asciidoc b/design/XFS_Filesystem_Structure/superblock.asciidoc
index 56877615ae81bf..bffb1659d0ba38 100644
--- a/design/XFS_Filesystem_Structure/superblock.asciidoc
+++ b/design/XFS_Filesystem_Structure/superblock.asciidoc
@@ -70,6 +70,10 @@ struct xfs_dsb {
 	__be64		sb_lsn;
 	uuid_t		sb_meta_uuid;
 	__be64		sb_metadirino;
+	__be32		sb_rgcount;
+	__be32		sb_rgextents;
+	__u8		sb_rgblklog;
+	__u8		sb_pad[7];
 
 	/* must be padded to 64 bit alignment */
 };
@@ -480,6 +484,24 @@ If the +XFS_SB_FEAT_RO_INCOMPAT_METADIR+ feature is set, this field points to
 the inode of the root directory of the metadata directory tree.
 This field is zero otherwise.
 
+*sb_rgcount*::
+Count of realtime groups in the filesystem, if the
++XFS_SB_FEAT_RO_INCOMPAT_METADIR+ feature is enabled.  If no realtime subvolume
+exists, this value will be zero.
+
+*sb_rgextents*::
+Maximum number of realtime extents that can be contained within a realtime
+group, if the +XFS_SB_FEAT_RO_INCOMPAT_METADIR+ feature is enabled.
+
+*sb_rgblklog*::
+If the +XFS_SB_FEAT_RO_INCOMPAT_METADIR+ feature is enabled, this is the log~2~
+value of +sb_rgextents+ * +sb_rextsize+ (rounded up). This value is used to
+generate absolute block numbers defined in extent maps from the segmented
++xfs_rtblock_t+ values.
+
+*sb_pad[7]*::
+Zeroes, if the +XFS_SB_FEAT_RO_INCOMPAT_METADIR+ feature is enabled.
+
 === xfs_db Superblock Example
 
 A filesystem is made on a single disk with the following command:


