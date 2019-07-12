Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6865A6639E
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2019 04:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfGLCAO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Jul 2019 22:00:14 -0400
Received: from sandeen.net ([63.231.237.45]:53802 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729062AbfGLCAO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jul 2019 22:00:14 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E9916D5E
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 21:00:04 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.1.0-rc1 tagged
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <f28373cc-94c8-3640-2839-86302cdab6f0@sandeen.net>
Date:   Thu, 11 Jul 2019 21:00:11 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8mjlSamgIZcXEqGDLyM2CDNnFHlnSq3KU"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8mjlSamgIZcXEqGDLyM2CDNnFHlnSq3KU
Content-Type: multipart/mixed; boundary="KkZsATsa3W7nVGKnuaIbWcffUbemEemgw";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <f28373cc-94c8-3640-2839-86302cdab6f0@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.1.0-rc1 tagged

--KkZsATsa3W7nVGKnuaIbWcffUbemEemgw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

f5de3c7 xfsprogs: Release v5.1.0-rc1

Barring horrific problems this will be what is released as
5.1.0, so if I'm missing something speak up now.

New Commits:

Allison Collins (1):
      [59cf967] xfsprogs: Fix uninitialized cfg->lsunit

Alvin Zheng (1):
      [c72f16b] mkfs.xfs.8: Fix an inconsistency between the code and the=
 man page.

Amir Goldstein (1):
      [10d4ca4] xfs_io: allow passing an open file to copy_range

Darrick J. Wong (9):
      [21e8caf] man: create a separate GETXATTR/SETXATTR ioctl manpage
      [b427c81] man: create a separate GEOMETRY ioctl manpage
      [9a59e45] man: create a separate FSBULKSTAT ioctl manpage
      [6237c49] man: link to the SCRUB_METADATA ioctl manpage from xfsctl=
=2E3
      [59f96d9] man: create a separate INUMBERS ioctl manpage
      [1a7af84] man: create a separate FSCOUNTS ioctl manpage
      [cb5c5cb] man: create a separate RESBLKS ioctl manpage
      [647d25c] man: create a separate GETBMAPX/GETBMAPA/GETBMAP ioctl ma=
npage
      [8a91e33] man: create a separate xfs shutdown ioctl manpage

Eric Sandeen (3):
      [9c726ef] mkfs: don't use xfs_verify_fsbno() before m_sb is fully s=
et up
      [328148f] xfs_io: reorganize source file handling in copy_range
      [f5de3c7] xfsprogs: Release v5.1.0-rc1

Yang Xu (1):
      [b68e255] mkfs: remove useless log options in usage


Code Diffstat:

 VERSION                            |   2 +-
 configure.ac                       |   2 +-
 debian/changelog                   |   6 +
 doc/CHANGES                        |  15 ++
 io/copy_file_range.c               |  30 ++-
 man/man2/ioctl_xfs_fsbulkstat.2    | 216 +++++++++++++++++++++
 man/man2/ioctl_xfs_fscounts.2      |  69 +++++++
 man/man2/ioctl_xfs_fsgetxattr.2    | 242 +++++++++++++++++++++++
 man/man2/ioctl_xfs_fsgetxattra.2   |   1 +
 man/man2/ioctl_xfs_fsinumbers.2    | 122 ++++++++++++
 man/man2/ioctl_xfs_fsop_geometry.2 | 221 +++++++++++++++++++++
 man/man2/ioctl_xfs_fssetxattr.2    |   1 +
 man/man2/ioctl_xfs_getbmap.2       |   1 +
 man/man2/ioctl_xfs_getbmapa.2      |   1 +
 man/man2/ioctl_xfs_getbmapx.2      | 176 +++++++++++++++++
 man/man2/ioctl_xfs_getresblks.2    |  67 +++++++
 man/man2/ioctl_xfs_goingdown.2     |  60 ++++++
 man/man2/ioctl_xfs_setresblks.2    |   1 +
 man/man3/xfsctl.3                  | 386 +++++++------------------------=
------
 man/man8/mkfs.xfs.8                |  14 +-
 man/man8/xfs_io.8                  |  10 +-
 mkfs/xfs_mkfs.c                    |  11 +-
 22 files changed, 1306 insertions(+), 348 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_fsbulkstat.2
 create mode 100644 man/man2/ioctl_xfs_fscounts.2
 create mode 100644 man/man2/ioctl_xfs_fsgetxattr.2
 create mode 100644 man/man2/ioctl_xfs_fsgetxattra.2
 create mode 100644 man/man2/ioctl_xfs_fsinumbers.2
 create mode 100644 man/man2/ioctl_xfs_fsop_geometry.2
 create mode 100644 man/man2/ioctl_xfs_fssetxattr.2
 create mode 100644 man/man2/ioctl_xfs_getbmap.2
 create mode 100644 man/man2/ioctl_xfs_getbmapa.2
 create mode 100644 man/man2/ioctl_xfs_getbmapx.2
 create mode 100644 man/man2/ioctl_xfs_getresblks.2
 create mode 100644 man/man2/ioctl_xfs_goingdown.2
 create mode 100644 man/man2/ioctl_xfs_setresblks.2


--KkZsATsa3W7nVGKnuaIbWcffUbemEemgw--

--8mjlSamgIZcXEqGDLyM2CDNnFHlnSq3KU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl0n6awACgkQIK4WkuE9
3uAjoA//dLzPh+ofNgTx3zKubXpIXnIhmNtoKrW2/QkoNO9pcqN3KG8dRGYOnQyF
aoi43fwWpXWimf0d8xgOOV73S4n3zefzFZ9cQ9sKO+1RK7cNlMJ3OcOLD1E9LnGQ
25SYecGnzKijpYfSe7SlV4QN8SZbohTNbOTWQUvtCRywjoSJ6F7QgOp2GmXCgKX0
jJEmjpxVPnW+OCSJYDH1GprWwXU8hfPSZLLI8Vc20SpYMeX1fPdiiJEgyruVDS4Y
icKvKy/Eg98RhwcAHZM77EIbVPYfaJrvobcRNC4kYtjKvHc6HbCQgYRrNMl2pp0F
aZWZDC1BZLbioe0m8R2/nN70BZeZr4Pvk68PGsGtcwQH4e+NlUM/hDgZT82pZkPg
06ZQxuKSpcLCr5XrBKUBYHhI2hIMEN9VxznIkWp23EjcXNNQihM1lIflK4HOknT4
lZEzUYVjFcXl/M+hKol5nyyjRfz2YEiY2UJFTlw3uOhGTzGFonn3cEQmtS8YzvW2
BxM3MCM6MlTojhb7+sxelEhNb0Xczr1f7VbHAl+zWUpPu08VvGFk4AJp/eZoxQAW
fOcONWXaoKbDH2TxWYNmKsDQPrX6KNbaqD+tom2tdqd2EO/mhI9up3+2Qbza0ZJ3
sXDslJ0bK6EMo9O2am0+bsV8ATPWDAoBWLWP7yfTgMCLJD2U7Sg=
=xpoj
-----END PGP SIGNATURE-----

--8mjlSamgIZcXEqGDLyM2CDNnFHlnSq3KU--
