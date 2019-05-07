Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF6A16D85
	for <lists+linux-xfs@lfdr.de>; Wed,  8 May 2019 00:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfEGW2W (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 May 2019 18:28:22 -0400
Received: from sandeen.net ([63.231.237.45]:36526 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfEGW2V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 May 2019 18:28:21 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0DCBC1164B
        for <linux-xfs@vger.kernel.org>; Tue,  7 May 2019 17:28:12 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 93ad4d9
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <c9de816b-14c7-688d-bfa8-f4efc972b30c@sandeen.net>
Date:   Tue, 7 May 2019 17:28:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZAWb2rsuCbC0jeiFpPCn0UZN2N1ppUhik"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZAWb2rsuCbC0jeiFpPCn0UZN2N1ppUhik
Content-Type: multipart/mixed; boundary="hfPT0ZKQnZdCW0HmEnd17R5Q5KpzFHATZ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <c9de816b-14c7-688d-bfa8-f4efc972b30c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 93ad4d9

--hfPT0ZKQnZdCW0HmEnd17R5Q5KpzFHATZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This includes only the libxfs kernelspace sync up at this point,
and associated non-libxfs adjustments.

The new head of the for-next branch is commit:

93ad4d9 xfs: always init bma in xfs_bmapi_write

New Commits:

Brian Foster (13):
      [a2fa97f] xfs: update fork seq counter on data fork changes
      [98da7e1] xfs: remove superfluous writeback mapping eof trimming
      [badaa59] xfs: create delalloc bmapi wrapper for full extent alloca=
tion
      [bbbbfd0] xfs: use the latest extent at writeback delalloc conversi=
on time
      [7563fc9] xfs: always check magic values in on-disk byte order
      [035ae96] xfs: create a separate finobt verifier
      [c08793b] xfs: distinguish between inobt and finobt magic values
      [fce74e9] xfs: split up allocation btree verifier
      [1d8220b] xfs: distinguish between bnobt and cntbt magic values
      [26b7b8f] xfs: use verifier magic field in dir2 leaf verifiers
      [68dbe77] xfs: miscellaneous verifier magic value fixups
      [6b27f70] xfs: factor xfs_da3_blkinfo verification into common help=
er
      [82ed51d] xfs: don't trip over uninitialized buffer on extent read =
of corrupted inode

Christoph Hellwig (6):
      [939ebc1] xfs: simplify the xfs_bmap_btree_to_extents calling conve=
ntions
      [ee62279] xfs: factor out two helpers from xfs_bmapi_write
      [330a35f] xfs: split XFS_BMAPI_DELALLOC handling from xfs_bmapi_wri=
te
      [c784c9d] xfs: move transaction handling to xfs_bmapi_convert_delal=
loc
      [44e165d] xfs: move stat accounting to xfs_bmapi_convert_delalloc
      [9fa4db1] xfs: make COW fork unwritten extent conversions more robu=
st

Darrick J. Wong (14):
      [95a8c91] xfs: scrub should flag dir/attr offsets that aren't mappa=
ble with xfs_dablk_t
      [d2b2d41] xfs: check directory name validity
      [0692657] xfs: check attribute name validity
      [7a425ea] xfs: add xfs_verify_agino_or_null helper
      [d9fa440] xfs: cache unlinked pointers in an rhashtable
      [62031c2] xfs: add inode magic to inode verifier
      [7a97b8e] xfs: add magic numbers to dquot buffer ops
      [4c7161c] xfs: rename m_inotbt_nores to m_finobt_nores
      [9e26de8] xfs: fix xfs_buf magic number endian checks
      [ed76255] xfs: fix uninitialized error variables
      [d8ddf13] xfs: clean up xfs_dir2_leafn_add
      [732a9d4] xfs: zero initialize highstale and lowstale in xfs_dir2_l=
eaf_addname
      [c01c6d6] xfs: clean up xfs_dir2_leaf_addname
      [93ad4d9] xfs: always init bma in xfs_bmapi_write

Nathan Chancellor (1):
      [e02a7d4] xfs: Zero initialize highstale and lowstale in xfs_dir2_l=
eafn_add


Code Diffstat:

 db/type.c                   |  12 +-
 include/xfs_mount.h         |   2 +-
 io/inject.c                 |   1 +
 libxfs/libxfs_io.h          |   7 +
 libxfs/libxfs_priv.h        |   3 +-
 libxfs/rdwr.c               |  37 ++++++
 libxfs/xfs_ag.c             |   6 +-
 libxfs/xfs_ag_resv.c        |   2 +-
 libxfs/xfs_alloc.c          |  12 +-
 libxfs/xfs_alloc_btree.c    |  74 +++++------
 libxfs/xfs_attr.c           |  17 +++
 libxfs/xfs_attr.h           |   2 +-
 libxfs/xfs_attr_leaf.c      |  21 +--
 libxfs/xfs_attr_remote.c    |   8 +-
 libxfs/xfs_bmap.c           | 317 ++++++++++++++++++++++++++------------=
------
 libxfs/xfs_bmap.h           |  16 +--
 libxfs/xfs_bmap_btree.c     |  13 +-
 libxfs/xfs_da_btree.c       |  49 ++++---
 libxfs/xfs_da_format.h      |   3 +
 libxfs/xfs_dir2.c           |  17 +++
 libxfs/xfs_dir2.h           |   1 +
 libxfs/xfs_dir2_block.c     |  10 +-
 libxfs/xfs_dir2_data.c      |  12 +-
 libxfs/xfs_dir2_leaf.c      | 137 ++++++-------------
 libxfs/xfs_dir2_node.c      |  28 ++--
 libxfs/xfs_dquot_buf.c      |   4 +
 libxfs/xfs_errortag.h       |   4 +-
 libxfs/xfs_ialloc.c         |   3 +-
 libxfs/xfs_ialloc_btree.c   |  29 ++--
 libxfs/xfs_iext_tree.c      |  13 +-
 libxfs/xfs_inode_buf.c      |  11 +-
 libxfs/xfs_inode_fork.h     |   2 +-
 libxfs/xfs_refcount_btree.c |   3 +-
 libxfs/xfs_rmap_btree.c     |   3 +-
 libxfs/xfs_sb.c             |   7 +-
 libxfs/xfs_shared.h         |   4 +-
 libxfs/xfs_symlink_remote.c |   3 +-
 libxfs/xfs_types.c          |  24 ++++
 libxfs/xfs_types.h          |   3 +
 mkfs/xfs_mkfs.c             |   6 +-
 repair/phase5.c             |   6 +-
 repair/scan.c               |   6 +-
 42 files changed, 542 insertions(+), 396 deletions(-)


--hfPT0ZKQnZdCW0HmEnd17R5Q5KpzFHATZ--

--ZAWb2rsuCbC0jeiFpPCn0UZN2N1ppUhik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzSBoMACgkQIK4WkuE9
3uBa8Q//U1GQmM7StR1ccIksueHVbP5yiL1is/FTjxrN7Ppn2v9yJMvLdu8iB8ig
7XhCkIlbqWEU6Hi4CPNdH9vhzIBGWe1omTMdgBGYsYp5R8NaBqsBTWn0Yq+YuD9J
ytnRGr0kMRwY1sUuEJ+aG595MN2jN6biSc9VxOgb9MYjQajXrSmWD54uNMGvyKzC
YcW86JE3kGoqS6sAq2mx1l7a8X/yMYVTK3QlMloNnpkWA8ygSyKbo2sSg5UB1Gsw
v98mFMRrrNgdo8KqclDYuV/FPKMccYchiSL4dPXxCu01IV6VjRRxWkSsmO/MiaNj
R9WUTqHM6tCUzp2mAOrwf09fBD8IQll11gJhrQa/950iY8GBHycpPFWc8HTeKQjC
AMJyYk4FeRXzDGkkqBZC55z/1jvKQR87JI8EL69oiaQWm12Yn6gO9iMSsMH2hnYd
h8j/SdBmKkGhlQN2UciCL6zzisrfsAIgQVHKchhnKGWtWLWGU1zarQRqMr4TxvUf
qz/zlLYrH35JOQQ1bwSSyeAD2L6S8RTE/57FKI6Yt6FBI91PxSUNS/1jsIHUcIDJ
uMMOxB8KKWPs8i9M5fbhpZKD2Fl7/lcXa5C0+NvuPTCuk5baIG916VTYu9rCTfdG
JqBq4Y9GXNSIEWfxTg7UauCYWNdT/kNLkKM9JDLAg2A1HcGaciE=
=PFwY
-----END PGP SIGNATURE-----

--ZAWb2rsuCbC0jeiFpPCn0UZN2N1ppUhik--
