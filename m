Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABFCB73B99
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 22:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405431AbfGXUBe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 16:01:34 -0400
Received: from sandeen.net ([63.231.237.45]:42276 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405442AbfGXUBe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jul 2019 16:01:34 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8D10F78A9
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:01:03 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to e20cbd1
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <b8cf4492-f09a-0cb9-658d-0b142e16a169@sandeen.net>
Date:   Wed, 24 Jul 2019 15:01:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="y97OcbJrmCNtXSsadLzdMijDxHNFBiHSi"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--y97OcbJrmCNtXSsadLzdMijDxHNFBiHSi
Content-Type: multipart/mixed; boundary="xjG4bnN5tliYSKVMu5Kzj6rSc1YzKi3Ny";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <b8cf4492-f09a-0cb9-658d-0b142e16a169@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to e20cbd1

--xjG4bnN5tliYSKVMu5Kzj6rSc1YzKi3Ny
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just the libxfs resync to 5.2, and this release may not have=20
a whole lot more substance in it.  If you have a more urgent fix, please
do bring it to my attention.

(Also note that I'll be on vacation next week so things will proceed
even more slowly than usual!)

The new head of the for-next branch is commit:

e20cbd1 xfsprogs: Release v5.2.0-rc0

New Commits:

Brian Foster (3):
      [580a438] xfs: don't account extra agfl blocks as available
      [b8b9c3c] xfs: make tr_growdata a permanent transaction
      [d85d342] xfs: assert that we don't enter agfl freeing with a non-p=
ermanent transaction

Darrick J. Wong (11):
      [f866934] xfs: track metadata health status
      [7b55f0f] xfs: replace the BAD_SUMMARY mount flag with the equivale=
nt health code
      [25b8487] xfs: clear BAD_SUMMARY if unmounting an unhealthy filesys=
tem
      [debdc16] xfs: add a new ioctl to describe allocation group geometr=
y
      [69423ea] xfs: report fs and rt health via geometry structure
      [378d9e6] xfs: report AG health via AG geometry ioctl
      [f394edc] xfs: report inode health via bulkstat
      [f73690f] xfs: track delayed allocation reservations across the fil=
esystem
      [9833c1a] xfs: always rejoin held resources during defer roll
      [e9caede] xfs: add online scrub for superblock counters
      [247c499] xfs: don't reserve per-AG space for an internal log

Dave Chinner (1):
      [4ddaada] xfs: bump XFS_IOC_FSGEOMETRY to v5 structures

Eric Sandeen (2):
      [a37cde5] xfs: change some error-less functions to void types
      [e20cbd1] xfsprogs: Release v5.2.0-rc0


Code Diffstat:

 VERSION                     |   4 +-
 configure.ac                |   2 +-
 db/info.c                   |  10 +--
 fsr/xfs_fsr.c               |   8 +-
 include/xfs_mount.h         |   8 ++
 include/xfs_trace.h         |   3 +
 include/xfs_trans.h         |   1 +
 libxfs/libxfs_api_defs.h    |   1 +
 libxfs/libxfs_priv.h        |   1 +
 libxfs/trans.c              |  24 ++++++
 libxfs/util.c               |  21 ++++-
 libxfs/xfs_ag.c             |  54 +++++++++++++
 libxfs/xfs_ag.h             |   2 +
 libxfs/xfs_alloc.c          |  13 ++-
 libxfs/xfs_attr.c           |  35 +++-----
 libxfs/xfs_attr.h           |   2 +-
 libxfs/xfs_bmap.c           |  17 +++-
 libxfs/xfs_defer.c          |  14 ++--
 libxfs/xfs_dquot_buf.c      |   4 +-
 libxfs/xfs_fs.h             | 139 +++++++++++++++++++++++++-------
 libxfs/xfs_health.h         | 190 ++++++++++++++++++++++++++++++++++++++=
++++++
 libxfs/xfs_ialloc_btree.c   |   9 +++
 libxfs/xfs_quota_defs.h     |   2 +-
 libxfs/xfs_refcount_btree.c |   9 +++
 libxfs/xfs_rmap_btree.c     |   9 +++
 libxfs/xfs_sb.c             |  18 +++--
 libxfs/xfs_sb.h             |   2 +-
 libxfs/xfs_trans_resv.c     |   6 +-
 libxfs/xfs_types.c          |   2 +-
 libxfs/xfs_types.h          |   2 +
 mkfs/xfs_mkfs.c             |  11 +--
 rtcp/xfs_rtcp.c             |   2 +-
 32 files changed, 518 insertions(+), 107 deletions(-)
 create mode 100644 libxfs/xfs_health.h


--xjG4bnN5tliYSKVMu5Kzj6rSc1YzKi3Ny--

--y97OcbJrmCNtXSsadLzdMijDxHNFBiHSi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl04uRoACgkQIK4WkuE9
3uAJjQ//X8u8tzvewAQ2wJ/IGHW9azkdvtWqUETdoTqhuUUSkTYCPunZJDIgoK9k
oeE5raAcBVCHcGVkithqEMHm7IaMuEZOvqh9mZWe2YZrmS8E5tW/sB0wn8sTyXnT
VPaOifh8EDReTUJU270RcTHH4y6BJDuQ2/yvDro5ta+75gmT1gk/P6WwLgq4a5c2
awS7R4051nVEv4vjey8IOoHG0y3x2PPAGmg6j50JfvaE8hTzg+07yR4wCaHYLicq
kXagX9idcpt/LFDnPEti5uejV1a9aknvnp4URdolxmhgAD5r9ezxrE+SiyRNVZFZ
oKdlwt+rG8HeUx71cZLX8KyKOTpWaPgm8h4roLKv+1CXEzFoh4l3xvlITyC/xYX2
tP/5LVs+1Sj9DBRSYAj5FpmwItE26QgkHQ2TkAwH90+XEbf8nH/qTzeYHvnFf0n2
kZ3e1hUF8lOc1EZpVT2OK1n+fJZ/Cp1shNC4MEo2W2Z+EyR86Q7wqDzVT15q/WWO
QzLYR1BX45oh3jQrZtla5z6JyOofDhC3EqUgR9hSoeaWpmH0fqqquJGRoWsSYbrC
7Tlpvv5MKM5G6n+qa1FLm1DvD6pQNY5jJZXXfZERJc+Ab4DguBLl8qtqwB5zua4J
FA7VYfyui9yF+yUrc2w3XrEY18NNvzwwuhhIV//n9ED4juzMtHI=
=B2mO
-----END PGP SIGNATURE-----

--y97OcbJrmCNtXSsadLzdMijDxHNFBiHSi--
