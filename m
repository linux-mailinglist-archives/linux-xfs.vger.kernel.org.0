Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB23242DE
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 23:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfETV32 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 17:29:28 -0400
Received: from sandeen.net ([63.231.237.45]:55304 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfETV31 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 17:29:27 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C98D178A9
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 16:29:24 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsdump updated to 86b0b04
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <e9755095-5845-9ab6-2148-3af523acd888@sandeen.net>
Date:   Mon, 20 May 2019 16:29:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qEldC44RxUgWxTwjGZpIifwo6sJJ2696M"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qEldC44RxUgWxTwjGZpIifwo6sJJ2696M
Content-Type: multipart/mixed; boundary="DjEcnM5gtzq4iNt4tty1FU6lXrxrixNOZ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e9755095-5845-9ab6-2148-3af523acd888@sandeen.net>
Subject: [ANNOUNCE] xfsdump updated to 86b0b04

--DjEcnM5gtzq4iNt4tty1FU6lXrxrixNOZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsdump repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

86b0b04 xfs_restore: support fallocate when reserving space for a file

New Commits:

Darrick J. Wong (4):
      [c50e407] xfs_restore: refactor open-coded file creation code
      [678f0f3] xfs_restore: check return value
      [0ca06d3] xfs_restore: fix unsupported ioctl detection
      [86b0b04] xfs_restore: support fallocate when reserving space for a=
 file

Jan Tulak (9):
      [354d07d] xsfsdump: (style) remove trailing whitespaces
      [fc342f7] xfsdump: do not split function call with ifdef
      [6ff49bf] common/types.h: Wrap #define UUID_STR_LEN 36 in #ifndef
      [8866703] common/drive.c: include stdlib.h
      [db93af5] xfsdump: don't fail installation if /sbin is symlink of  =
/usr/sbin
      [dae8f55] xfsdump: (style) remove spaces from parentheses
      [cbe6e30] xfsdump: (style) remove spaces in front of commas/semicol=
ons
      [ef3a1e2] xfsdump: (style) remove spaces for pointers and negations=

      [46a0d93] xfsdump: add a space after commas and semicolons where wa=
s none


Code Diffstat:

 common/arch_xlate.c     |   32 +-
 common/cldmgr.c         |  134 +-
 common/cldmgr.h         |   16 +-
 common/cleanup.c        |   68 +-
 common/cleanup.h        |   18 +-
 common/content.h        |   44 +-
 common/content_common.c |   94 +-
 common/content_common.h |    2 +-
 common/content_inode.h  |   94 +-
 common/dlog.c           |  288 +--
 common/dlog.h           |   32 +-
 common/drive.c          |  181 +-
 common/drive.h          |  134 +-
 common/drive_minrmt.c   | 2185 +++++++++----------
 common/drive_scsitape.c | 3028 +++++++++++++-------------
 common/drive_simple.c   |  742 +++----
 common/exit.h           |    4 +-
 common/fs.c             |  188 +-
 common/fs.h             |   12 +-
 common/getdents.c       |    2 +-
 common/global.c         |  212 +-
 common/global.h         |   32 +-
 common/hsmapi.c         |   24 +-
 common/inventory.c      |  396 ++--
 common/inventory.h      |   82 +-
 common/lock.c           |   14 +-
 common/lock.h           |    6 +-
 common/main.c           | 1608 +++++++-------
 common/media.c          |  130 +-
 common/media.h          |   20 +-
 common/media_rmvtape.h  |    8 +-
 common/mlog.c           |  340 +--
 common/mlog.h           |   60 +-
 common/openutil.c       |   72 +-
 common/openutil.h       |   22 +-
 common/path.c           |  190 +-
 common/path.h           |    8 +-
 common/qlock.c          |  126 +-
 common/qlock.h          |   18 +-
 common/rec_hdr.h        |    6 +-
 common/ring.c           |  232 +-
 common/ring.h           |   22 +-
 common/stream.c         |  100 +-
 common/stream.h         |   26 +-
 common/timeutil.c       |    8 +-
 common/timeutil.h       |    6 +-
 common/ts_mtio.h        |   64 +-
 common/types.h          |   64 +-
 common/util.c           |  268 +--
 common/util.h           |   60 +-
 configure.ac            |    2 +
 dump/Makefile           |    4 +-
 dump/content.c          | 3726 ++++++++++++++++----------------
 dump/getopt.h           |    2 +-
 dump/inomap.c           |  776 +++----
 dump/inomap.h           |   32 +-
 dump/var.c              |   96 +-
 dump/var.h              |    4 +-
 include/builddefs.in    |    1 +
 include/swab.h          |   30 +-
 include/swap.h          |   30 +-
 inventory/getopt.h      |    2 +-
 inventory/inv_api.c     |  584 ++---
 inventory/inv_core.c    |  128 +-
 inventory/inv_files.c   |   10 +-
 inventory/inv_fstab.c   |  188 +-
 inventory/inv_idx.c     |  368 ++--
 inventory/inv_mgr.c     |  418 ++--
 inventory/inv_oref.c    |  148 +-
 inventory/inv_oref.h    |   16 +-
 inventory/inv_priv.h    |  286 +--
 inventory/inv_stobj.c   | 1008 ++++-----
 inventory/inventory.h   |   88 +-
 inventory/testmain.c    |  322 +--
 invutil/cmenu.h         |   38 +-
 invutil/fstab.c         |   20 +-
 invutil/invidx.c        |  126 +-
 invutil/invutil.c       |  302 +--
 invutil/invutil.h       |    6 +-
 invutil/menu.c          |    8 +-
 invutil/screen.c        |    2 +-
 invutil/stobj.c         |   38 +-
 librmt/rmtcommand.c     |    2 +-
 librmt/rmtfstat.c       |    8 +-
 librmt/rmtioctl.c       |   52 +-
 librmt/rmtlib.h         |    2 +-
 librmt/rmtopen.c        |    6 +-
 librmt/rmtstatus.c      |    8 +-
 librmt/rmtwrite.c       |    2 +-
 m4/Makefile             |    1 +
 m4/package_libcdev.m4   |   15 +
 restore/Makefile        |    8 +-
 restore/bag.c           |   72 +-
 restore/bag.h           |   20 +-
 restore/content.c       | 5524 +++++++++++++++++++++++------------------=
------
 restore/dirattr.c       |  763 ++++---
 restore/dirattr.h       |   48 +-
 restore/getopt.h        |    2 +-
 restore/inomap.c        |  290 +--
 restore/inomap.h        |   34 +-
 restore/mmap.c          |    2 +-
 restore/namreg.c        |  280 +--
 restore/namreg.h        |   12 +-
 restore/node.c          |  330 +--
 restore/node.h          |   12 +-
 restore/tree.c          | 2930 ++++++++++++-------------
 restore/tree.h          |   48 +-
 restore/win.c           |  138 +-
 restore/win.h           |   12 +-
 109 files changed, 15455 insertions(+), 15497 deletions(-)
 create mode 100644 m4/package_libcdev.m4


--DjEcnM5gtzq4iNt4tty1FU6lXrxrixNOZ--

--qEldC44RxUgWxTwjGZpIifwo6sJJ2696M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzjHDUACgkQIK4WkuE9
3uBdIw//XYVti4SeVK2s0T8r/PYqkAHwuGB+6Ns8B9BsraRju1akwQBYRlB3fN3J
nZjD/HDlTezDSuAykPihB4vKk8nUiC29K+XC5V1HHA5VxjdqeoidIQleum729JjA
dvqNbs1L+VhK7NJOgJX+VtFgsnEsiBoZO4ZeW6iCwKGXRH0MqhEmm5+JBlkbuGc0
zNK367A6defciXSn5R826/c1CaQMLAq149puhCiX66b2f16FPxyYTBZftuoTVaQD
4G5QM4jEQhCodEnjCH4AI1bRuvsTjCnPcizqJHiQisCJgoUW/Yqd/EVBJRSHeVab
j/AP3YquObxHxSjjnpaGkEBXMZq64C2CxOf9SRNuSLNu3O0MtdJaE34VQL2szrLP
jqz5mzKnNOKTR0tbTgOuj/3s6QNCWpSlkxNHWBZExqi4dm6qGUbgWVjIZhV+4H8A
pKJnFGq8sxXh3bAb7fFvyzgcNOBb8USRiidPsVdF9WKhx0TOK6OQE/KBXdG6bm9d
OgBd5RlzDwzkUeOcE9uXgqmzMHfoz8aFyDIkvNlqDv4ym08WIvxcYXzbUH0ZuUDA
gwBBoBFBkhsyAjRj1OjreSNbRn0RPK2MwLHZ5H5o4krYTiY5qsaRvJPFg9oiKYl7
iAYMZK+o6PvphORmRrFF81QIdlXF8ZoWC+Y+AodBQYIC7A/O6IM=
=l7o3
-----END PGP SIGNATURE-----

--qEldC44RxUgWxTwjGZpIifwo6sJJ2696M--
