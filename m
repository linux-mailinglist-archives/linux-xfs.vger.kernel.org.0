Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD8D1344F
	for <lists+linux-xfs@lfdr.de>; Fri,  3 May 2019 22:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbfECUHt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 May 2019 16:07:49 -0400
Received: from sandeen.net ([63.231.237.45]:41672 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfECUHt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 May 2019 16:07:49 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D63C6560
        for <linux-xfs@vger.kernel.org>; Fri,  3 May 2019 15:07:45 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.0.0 released
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <86bfcc3d-129a-7394-b97a-f328c8d1964c@sandeen.net>
Date:   Fri, 3 May 2019 15:07:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LnyqsBi3QhoQud2HIpHvlZD9c9LYvikdL"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LnyqsBi3QhoQud2HIpHvlZD9c9LYvikdL
Content-Type: multipart/mixed; boundary="gqmRxcvIcqW3iLcZuHjkOw0Hpx8f13fyf";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <86bfcc3d-129a-7394-b97a-f328c8d1964c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.0.0 released

--gqmRxcvIcqW3iLcZuHjkOw0Hpx8f13fyf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

=46rom the "It's Friday" department:

xfsprogs-5.0.0 is out!  Before kernel 5.1 was released!  *phew*

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.0.0, with tarballs
available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.0.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.0.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.0.0.tar=
=2Esign

Highlights of changes since last release:

xfsprogs-5.0.0 (03 May 2019)
        - xfs_db: scan all sparse inodes when using 'frag' (Jorge Guerra)=

        - Fix build with newer statx headers (Eric Sandeen)

xfsprogs-5.0.0-rc1 (26 Apr 2019)
        - mkfs: validate extent size hint parameters (Darrick Wong)
        - xfs_repair: bump on-disk nlink when adding lost+found (Darrick =
Wong)
        - xfs_repair: reinitialize root directory nlink correctly (Darric=
k Wong)
        - xfs_repair: use lenient verifiers for half-fixed inodes (Darric=
k Wong)
        - xfs_repair: acct for btree shrinks when fixing freelist (Darric=
k Wong)
        - xfs_repair: better cli option parameter checking (Darrick Wong)=

        - xfs_repair: fix deadlock due to failed inode flushes (Dave Chin=
ner)
        - xfs_info: handle devices, mountpoints, and loop files (Darrick =
Wong)
        - xfs_metadump: fix symlink handling (Darrick Wong)
        - xfs_io: fix label parsing and validation (Darrick Wong)
        - xfs_io: print attributes_mask in statx (Darrick Wong)
        - xfs_scrub: fix Make targets which depend on builddefs (Darrick =
Wong)
        - xfs_scrub: check label for misleading characters (Darrick Wong)=

        - xfs_scrub: parallelize based on storage not CPUS (Darrick Wong)=

        - xfs_scrub: activate timer only after system is up (Darrick Wong=
)
        - libxfs: fix buffer & inode lifetimes (Darrick Wong)
        - misc: fix strncpy length complaints from gcc (Darrick Wong)
        - debian build & packaging fixes (Darrick Wong)
        - Merge libxfs from kernel 5.0



--gqmRxcvIcqW3iLcZuHjkOw0Hpx8f13fyf--

--LnyqsBi3QhoQud2HIpHvlZD9c9LYvikdL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzMn5QACgkQIK4WkuE9
3uAzFRAAqLaSXGLoLugWW/xjOE+sK3VeDf+ZmhxUQiJ6NRTkK5GcXeoc2SkqUdtT
8qjWbOgIiPbO7JvEov0gTs5fZsfSOf9nVPaXpn9PjfBY3TZMrYYqFZHvI5NOlUGB
0ATaTBz3VBtZ/JoZF++oIEG/fyPG4Wl7kcGlO1+8Ul9LW+L0e3Lba6usZNx8WVQG
+Ya955kzmCXY71qxRPV1uPLMX0/ZLd8gTcJVTSsSAGZYrIGeSxDMYzAvqQLa2GdS
v1McjJFmLceOobIFOiSiy9q2pZ/d/rKptfWTjGJJN50duuqYTurYi+u5U0Yw5aJS
l/if1xMLXBNdTIKOKRjHSATEhbYXvJSJEKrvDC7HHV6J5CpZIdH4TXRoEfjbFeYk
rLd9hOWgNmx0tsIBNWY+r3Wo4riUfKRajDLy+7PkXdCLOroleO3iD5FuHd7CjQIp
zR+NhDKHaxXoeegMHfSk0Gq20Q/8+Jgig6x/Wfnrf2zUJskJg/yRMOgXML/t/DYx
mZax4dp/I0+sE63GpfSHNMxZVvk208hhkB7oitDjwQq2DuSzDuldJ2QcRo49USV/
+RfpY/40O6chlp2i2gde1wzHHSUhM940M+XetSE+vYYMxn4MNvjVmzmdyJOu0WTU
OPzEieATamx4dXS+PgjvLxP68jlE8zqL3mUv/NPNMzjmTl9Egvw=
=YdY1
-----END PGP SIGNATURE-----

--LnyqsBi3QhoQud2HIpHvlZD9c9LYvikdL--
