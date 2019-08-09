Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A79788360
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 21:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfHITkI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 15:40:08 -0400
Received: from sandeen.net ([63.231.237.45]:60604 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfHITkH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Aug 2019 15:40:07 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8B9FD328A16
        for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2019 14:40:06 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.2.0 released
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <e172f478-0923-b9cd-2032-70ffae337d15@sandeen.net>
Date:   Fri, 9 Aug 2019 14:40:04 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a4jNrQfPmXxLdvGXuoPbj6kMFY9CjRENj"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a4jNrQfPmXxLdvGXuoPbj6kMFY9CjRENj
Content-Type: multipart/mixed; boundary="zwQSGMd8rxxqtShwbeXRTFViFTLnK9jtA";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e172f478-0923-b9cd-2032-70ffae337d15@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.2.0 released

--zwQSGMd8rxxqtShwbeXRTFViFTLnK9jtA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

xfsprogs v5.2.0 has been released, and the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.2.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.2.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.2.0.tar=
=2Esign


This is the most boring release ever(tm).  It contains only libxfs syncup=
s,
and some cosmetic changes unique to xfsprogs-specific libxfs/ files.
Onward to 5.3!

Thanks,
-Eric

The new head of the master branch is commit:

2976bfe xfsprogs: Release v5.2.0

New Commits since v5.1.0:

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

Eric Sandeen (7):
      [a37cde5] xfs: change some error-less functions to void types
      [e20cbd1] xfsprogs: Release v5.2.0-rc0
      [e6afdab] libxfs: reorder functions in libxfs/trans.c
      [9c64b9b] libxfs: cosmetic changes to libxfs/trans.c
      [42b85f5] libxfs: trivial changes to libxfs/trans.c
      [3a3f5b1] libxfs: don't use enum for buffer flags
      [2976bfe] xfsprogs: Release v5.2.0


Code Diffstat:

 VERSION                     |   2 +-
 configure.ac                |   2 +-
 db/info.c                   |  10 +-
 debian/changelog            |   6 +
 doc/CHANGES                 |   6 +
 fsr/xfs_fsr.c               |   8 +-
 include/xfs_mount.h         |   8 +
 include/xfs_trace.h         |   5 +
 include/xfs_trans.h         |   7 +-
 libxfs/libxfs_api_defs.h    |   1 +
 libxfs/libxfs_io.h          |  17 +-
 libxfs/libxfs_priv.h        |   1 +
 libxfs/trans.c              | 406 +++++++++++++++++++++++++++-----------=
------
 libxfs/util.c               |  21 ++-
 libxfs/xfs_ag.c             |  54 ++++++
 libxfs/xfs_ag.h             |   2 +
 libxfs/xfs_alloc.c          |  13 +-
 libxfs/xfs_attr.c           |  35 ++--
 libxfs/xfs_attr.h           |   2 +-
 libxfs/xfs_bmap.c           |  17 +-
 libxfs/xfs_defer.c          |  14 +-
 libxfs/xfs_dquot_buf.c      |   4 +-
 libxfs/xfs_fs.h             | 139 +++++++++++----
 libxfs/xfs_health.h         | 190 +++++++++++++++++++++
 libxfs/xfs_ialloc_btree.c   |   9 +
 libxfs/xfs_quota_defs.h     |   2 +-
 libxfs/xfs_refcount_btree.c |   9 +
 libxfs/xfs_rmap_btree.c     |   9 +
 libxfs/xfs_sb.c             |  18 +-
 libxfs/xfs_sb.h             |   2 +-
 libxfs/xfs_trans_resv.c     |   6 +-
 libxfs/xfs_types.c          |   2 +-
 libxfs/xfs_types.h          |   2 +
 mkfs/xfs_mkfs.c             |  11 +-
 rtcp/xfs_rtcp.c             |   2 +-
 35 files changed, 766 insertions(+), 276 deletions(-)
 create mode 100644 libxfs/xfs_health.h


--zwQSGMd8rxxqtShwbeXRTFViFTLnK9jtA--

--a4jNrQfPmXxLdvGXuoPbj6kMFY9CjRENj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl1NzBUACgkQIK4WkuE9
3uB2Dg/+JPQYh31RMx927fpPAkcMEZFGQN8b2nMMVhvraiNvAlfeaRiQEmtmysdy
KQDRDuejV6NXi1jbMpD1VuxShCmi/2gr0ZGVtAn8NqToCOx8fcjGNXEEMJcuBqjb
nFOYfzdYs9DqE1TL9quny4eWlvtW+dOyRFtSYrUMlEqG5D/2ZJ6ZNdArk9JEQt5O
2QMavBzysgKlwQK9mJRfaAOGzfH1/R6tZscZpNEBCj2MeLxvemgoxnWugku0s/58
+7Qo2noOFRABwBQQPTiLRnXu6Hrs4sSs92aBR2/J0uer4nEDrBxx1+iOy0p+174/
K6ZcjXVfYNaXIQFulRxOpwl5KN3QJjzGD3ufKNAz3STDc+2N8H2UVfz1nbqTKwFV
B5R5pbeOS0Xlpk9UDQCG3CnAdh6UodheEOozPCr8w/VWO6/txO4ZnauEACZ3SRws
jSvyUiEk24bV+zGNpqcriSQgdZg6jKci4zP7qFNQ9gesXxEU1kluyAalgRkeSm6a
WHCxUpIic1ZPR7wHm7WCw6UL9dAd5QQnYNMQaLH9pCiKPh+b9+myu/Qpvb+0Fm9Z
17l+kNXd48BybugEBHjTlDqVw1qeybTQ4AlHNOtALQi/p3d9ti5QrgGRf4ad5kIZ
D1lImq7Ovi2aaOR+bn38YS7S8dn1lQCnk7PC4WyPFpxj8zPVtv8=
=/+NG
-----END PGP SIGNATURE-----

--a4jNrQfPmXxLdvGXuoPbj6kMFY9CjRENj--
