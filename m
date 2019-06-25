Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3D1559B2
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 23:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfFYVIt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 17:08:49 -0400
Received: from sandeen.net ([63.231.237.45]:58094 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFYVIs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 17:08:48 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 09BFF1170C
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 16:08:37 -0500 (CDT)
Subject: [ANNOUNCE] xfsprogs for-next rebased to 8bfb5eac
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <14670eb1-0e0e-b669-7d85-0f4589e13bf9@sandeen.net>
Date:   Tue, 25 Jun 2019 16:08:45 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LBuaNj7teEoAVl9mo8lADRsYgqwoR20DR"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LBuaNj7teEoAVl9mo8lADRsYgqwoR20DR
Content-Type: multipart/mixed; boundary="cW2K9kKYJ9KMx3k9WcMoiL7AIuE4fRgy0";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <14670eb1-0e0e-b669-7d85-0f4589e13bf9@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next rebased to 8bfb5eac
References: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
In-Reply-To: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>

--cW2K9kKYJ9KMx3k9WcMoiL7AIuE4fRgy0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been rebased(!)

[I am on fire today, and accidentally pushed some unreviewed manpage
changes, go, me!]

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

8bfb5eac (HEAD -> for-next, origin/for-next, korg/for-next) xfs_quota: fi=
x built-in help for project setup

New Commits:

Amir Goldstein (1):
      [e0bdad06] xfs_info: limit findmnt to find mounted xfs filesystems

Darrick J. Wong (4):
      [b6ad9957] libfrog: don't set negative errno in conversion function=
s
      [b089256c] libfrog: cvt_u64 should use strtoull, not strtoll
      [8da52988] mkfs: validate start and end of aligned logs
      [f1572219] xfs_io: repair_f should use its own name

Eric Sandeen (1):
      [8bfb5eac] xfs_quota: fix built-in help for project setup


Code Diffstat:

 io/scrub.c           |  2 +-
 libfrog/convert.c    | 22 +++++++++++-----------
 mkfs/xfs_mkfs.c      | 15 ++++++++++++++-
 quota/project.c      |  2 +-
 spaceman/xfs_info.sh |  2 +-
 5 files changed, 28 insertions(+), 15 deletions(-)


--cW2K9kKYJ9KMx3k9WcMoiL7AIuE4fRgy0--

--LBuaNj7teEoAVl9mo8lADRsYgqwoR20DR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl0SjV0ACgkQIK4WkuE9
3uCHFA//XlQvrnVYkubjZd5d/QdVcUNmFvcVNiylaDwp52N+K1RQgbhsth893Afi
HlSalBZIEmSzdt5SMvMqeMaj1Adh6k1CPoYqxFmFwmcQTC7uTZJhfVZDVmYPL+5L
8kB+eV8+jLEw1WLmCjL1GyIjmBcW9mtD24Mm9lgCmGCxNZovWXR8rp3t/6xZWauE
AzZnwP5PYhNzueMHd190XfdiJ9T7HziZkL5OjxYkAnXtfI9UywA03bqhdr2eFbUB
7H3Yw495y8ox0xrI262k9VbFyrRQ9SGLAerC5YVYgNT+v5c3EIjyHt++ReEtUymY
LCMzISL3zskRKrxD+tN/iRAuzIjxXc5NzuO9QAM2/gSeykAUyxvpPS+RYaBF2mUL
+C34KftDufprJ15D2LaSbGVi2Ha/vqlRXPX7BWpH3XKgcTE9J2E0swZOULEH4Ar2
cZrynxUqQ3rYW6u58Nzq4I53pjfOhyaL1XC4beYAniP1btj3/UyOVP2Rvz0KT13r
O1ZSbsv3dHvR2t54c1H6WQKB18sTq6UDpgrxzRxjmi9dX/7/szTAz2GVaqQ/GhSS
Rer7f8Ney50ZX+zdl08Wo9gcPHyHDqvDEylF1gmvvH1Fwsy1UqIJg3iMZsMCNHRN
pcFaGczH29x0+VJsVPiH+t+i2vpgtJBS/euIaH7jk68Qp9PKVto=
=9pWq
-----END PGP SIGNATURE-----

--LBuaNj7teEoAVl9mo8lADRsYgqwoR20DR--
