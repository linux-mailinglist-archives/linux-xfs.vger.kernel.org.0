Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2D32550D
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 18:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfEUQLh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 12:11:37 -0400
Received: from sandeen.net ([63.231.237.45]:57346 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728933AbfEUQLh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 12:11:37 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0BDED325F
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 11:11:32 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 5539639
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <47a8553f-576b-a45b-18b8-be600e0e6c5f@sandeen.net>
Date:   Tue, 21 May 2019 11:11:35 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="POoZA4fFMmLiCDa4EqY8tZwfzG3qZhsDq"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--POoZA4fFMmLiCDa4EqY8tZwfzG3qZhsDq
Content-Type: multipart/mixed; boundary="w4Tw49lgYRsQU628B0gg5si52F0utWIIg";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <47a8553f-576b-a45b-18b8-be600e0e6c5f@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 5539639

--w4Tw49lgYRsQU628B0gg5si52F0utWIIg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

5539639 libxfs: share kernel's xfs_trans_inode.c

New Commits:

Christoph Hellwig (1):
      [15b8fe6] libxfs: factor common xfs_trans_bjoin code

Dave Chinner (1):
      [fb34b2d] xfs: factor log item initialisation

Eric Sandeen (5):
      [bc603ef] libxfs: Remove XACT_DEBUG #ifdefs
      [cebe02e] libxfs: rename bli_format to avoid confusion with bli_for=
mats
      [31355f9] libxfs: fix argument to xfs_trans_add_item
      [b192e77] libxfs: create current_time helper and sync xfs_trans_ich=
gtime
      [5539639] libxfs: share kernel's xfs_trans_inode.c


Code Diffstat:

 include/xfs_inode.h      |  14 ++++
 include/xfs_trace.h      |  13 +++
 include/xfs_trans.h      |   5 +-
 libxfs/Makefile          |   1 +
 libxfs/libxfs_priv.h     |  10 +++
 libxfs/logitem.c         |  14 ++--
 libxfs/trans.c           | 209 +++++++++++++++--------------------------=
------
 libxfs/util.c            |  39 ++++-----
 libxfs/xfs_trans_inode.c | 155 +++++++++++++++++++++++++++++++++++
 9 files changed, 283 insertions(+), 177 deletions(-)
 create mode 100644 libxfs/xfs_trans_inode.c


--w4Tw49lgYRsQU628B0gg5si52F0utWIIg--

--POoZA4fFMmLiCDa4EqY8tZwfzG3qZhsDq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzkIzcACgkQIK4WkuE9
3uAPZg/+NUF+c9saNklPkmiU9U1oNpvkirpQSMtiRB24Nh6u0u3Q7xSj7JnVDvLC
DerYrbYeZbOv802LzSiI1XRFBROo83AjWhq6EcYyfBpplk3ubYUQQRFZVJNieIlt
9Zq1PDaFct3DCvmjlEoi6tpXyxi5rd/YVyUSgzwjilOXkEawkh58reDZuopcCM8L
9u0h4c+CT5279IWJS+SN9A+WKB+1BJHSx9aopv3xgCxIDof8E+y/s+U5+G+JvqkH
fWjhwpNqib+3vUkMMDswjlrZcpQVecq7WqNVfFgXixyTKjS4EB7+jOWqldnlSVGQ
4tnbpEBpE+45wP5UL9o//Rcard6wmUIzWnCJ5JbvPWEMXNvhNp2cSm1bvJkWQ2kc
MIIeRjLx+aP4QNjUlHehq7mYnnknprfxCiqS/fZ7NXv/B7CMnBULgNnnL3XbpIGV
dt5NpE3jvD6LK5IawXjnsZIMZxdoH4CEHmlY/2xOvKhk58AYibQiEQ4R4COQz/4s
wcMCuYRPGFP8sJk60Irjow+VyuA85AfeNd987008W+dw4/A4Ph6Xr1WfQoAkHTem
NFZe7bDMWzzmJouIsrArI6qnC9qwuaCbrx+Hpqd+xEBBw+3A3ogZgKvpQ852DADf
OJiGfc13ntAHxBYDbwZXcN5/XmLVjAlKPpxF0e767ErERthfzAs=
=8x76
-----END PGP SIGNATURE-----

--POoZA4fFMmLiCDa4EqY8tZwfzG3qZhsDq--
