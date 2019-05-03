Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F43613450
	for <lists+linux-xfs@lfdr.de>; Fri,  3 May 2019 22:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfECUIc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 May 2019 16:08:32 -0400
Received: from sandeen.net ([63.231.237.45]:41714 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfECUIc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 May 2019 16:08:32 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1E9C3560
        for <linux-xfs@vger.kernel.org>; Fri,  3 May 2019 15:08:29 -0500 (CDT)
Subject: Re: [ANNOUNCE] xfsprogs master updated to 65dcd3b
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <215c5b02-9eb9-e626-f21b-c5c8404ae8e5@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 mQINBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjBzp96cpCs
 nQZV32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7V3807PQcI18YzkF+
 WL05ODFQ2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87Yu2ZuaWF+Gh1W2ix6hikRJmQ
 vj5BEeAx7xKkyBhzdbNIbbjV/iGi9b26B/dNcyd5w2My2gxMtxaiP7q5b6GM2rsQklHP8FtW
 ZiYO7jsg/qIppR1C6Zr5jK1GQlMUIclYFeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGC
 sEEHj2khs7GfVv4pmUUHf1MRIvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2
 BS6Rg851ay7AypbCPx2w4d8jIkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2j
 gJBs57loTWAGe2Ve3cMy3VoQ40Wt3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftK
 LKhPj4c7uqjnBjrgOVaVBupGUmvLiePlnW56zJZ51BR5igWnILeOJ1ZIcf7KsaHyE6B1mG+X
 dmYtjDhjf3NAcoBWJuj8euxMB6TcQN2MrSXy5wSKaw40evooGwARAQABtCVFcmljIFIuIFNh
 bmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+iQI7BBMBAgAlAhsDBgsJCAcDAgYVCAIJCgsE
 FgIDAQIeAQIXgAUCUzMzbAIZAQAKCRAgrhaS4T3e4Fr7D/wO+fenqVvHjq21SCjDCrt8HdVj
 aJ28B1SqSU2toxyg5I160GllAxEHpLFGdbFAhQfBtnmlY9eMjwmJb0sCIrkrB6XNPSPA/B2B
 UPISh0z2odJv35/euJF71qIFgWzp2czJHkHWwVZaZpMWWNvsLIroXoR+uA9c2V1hQFVAJZyk
 EE4xzfm1+oVtjIC12B9tTCuS00pY3AUy21yzNowT6SSk7HAzmtG/PJ/uSB5wEkwldB6jVs2A
 sjOg1wMwVvh/JHilsQg4HSmDfObmZj1d0RWlMWcUE7csRnCE0ZWBMp/ttTn+oosioGa09HAS
 9jAnauznmYg43oQ5Akd8iQRxz5I58F/+JsdKvWiyrPDfYZtFS+UIgWD7x+mHBZ53Qjazszox
 gjwO9ehZpwUQxBm4I0lPDAKw3HJA+GwwiubTSlq5PS3P7QoCjaV8llH1bNFZMz2o8wPANiDx
 5FHgpRVgwLHakoCU1Gc+LXHXBzDXt7Cj02WYHdFzMm2hXaslRdhNGowLo1SXZFXa41KGTlNe
 4di53y9CK5ynV0z+YUa+5LR6RdHrHtgywdKnjeWdqhoVpsWIeORtwWGX8evNOiKJ7j0RsHha
 WrePTubr5nuYTDsQqgc2r4aBIOpeSRR2brlT/UE3wGgy9LY78L4EwPR0MzzecfE1Ws60iSqw
 Pu3vhb7h3bkCDQROsffUARAA0DrUifTrXQzqxO8aiQOC5p9Tz25Np/Tfpv1rofOwL8VPBMvJ
 X4P5l1V2yd70MZRUVgjmCydEyxLJ6G2YyHO2IZTEajUY0Up+b3ErOpLpZwhvgWatjifpj6bB
 SKuDXeThqFdkphF5kAmgfVAIkan5SxWK3+S0V2F/oxstIViBhMhDwI6XsRlnVBoLLYcEilxA
 2FlRUS7MOZGmRJkRtdGD5koVZSM6xVZQSmfEBaYQ/WJBGJQdPy94nnlAVn3lH3+N7pXvNUuC
 GV+t4YUt3tLcRuIpYBCOWlc7bpgeCps5Xa0dIZgJ8Louu6OBJ5vVXjPxTlkFdT0S0/uerCG5
 1u8p6sGRLnUeAUGkQfIUqGUjW2rHaXgWNvzOV6i3tf9YaiXKl3avFaNW1kKBs0T5M1cnlWZU
 Utl6k04lz5OjoNY9J/bGyV3DSlkblXRMK87iLYQSrcV6cFz9PRl4vW1LGff3xRQHngeN5fPx
 ze8X5NE3hb+SSwyMSEqJxhVTXJVfQWWW0dQxP7HNwqmOWYF/6m+1gK/Y2gY3jAQnsWTru4RV
 TZGnKwEPmOCpSUvsTRXsVHgsWJ70qd0yOSjWuiv4b8vmD3+QFgyvCBxPMdP3xsxN5etheLMO
 gRwWpLn6yNFq/xtgs+ECgG+gR78yXQyA7iCs5tFs2OrMqV5juSMGmn0kxJUAEQEAAYkCHwQY
 AQIACQUCTrH31AIbDAAKCRAgrhaS4T3e4BKwD/0ZOOmUNOZCSOLAMjZx3mtYtjYgfUNKi0ki
 YPveGoRWTqbis8UitPtNrG4XxgzLOijSdOEzQwkdOIp/QnZhGNssMejCnsluK0GQd+RkFVWN
 mcQT78hBeGcnEMAXZKq7bkIKzvc06GFmkMbX/gAl6DiNGv0UNAX+5FYh+ucCJZSyAp3sA+9/
 LKjxnTedX0aygXA6rkpX0Y0FvN/9dfm47+LGq7WAqBOyYTU3E6/+Z72bZoG/cG7ANLxcPool
 LOrU43oqFnD8QwcN56y4VfFj3/jDF2MX3xu4v2OjglVjMEYHTCxP3mpxesGHuqOit/FR+mF0
 MP9JGfj6x+bj/9JMBtCW1bY/aPeMdPGTJvXjGtOVYblGZrSjXRn5++Uuy36CvkcrjuziSDG+
 JEexGxczWwN4mrOQWhMT5Jyb+18CO+CWxJfHaYXiLEW7dI1AynL4jjn4W0MSiXpWDUw+fsBO
 Pk6ah10C4+R1Jc7dyUsKksMfvvhRX1hTIXhth85H16706bneTayZBhlZ/hK18uqTX+s0onG/
 m1F3vYvdlE4p2ts1mmixMF7KajN9/E5RQtiSArvKTbfsB6Two4MthIuLuf+M0mI4gPl9SPlf
 fWCYVPhaU9o83y1KFbD/+lh1pjP7bEu/YudBvz7F2Myjh4/9GUAijrCTNeDTDAgvIJDjXuLX pA==
Message-ID: <2092fa5f-d87f-bac9-8091-ed2a9e64fe01@sandeen.net>
Date:   Fri, 3 May 2019 15:08:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <215c5b02-9eb9-e626-f21b-c5c8404ae8e5@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XsEsrDGhE9cSz8iL8psJM1WElKNhbwdXA"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XsEsrDGhE9cSz8iL8psJM1WElKNhbwdXA
Content-Type: multipart/mixed; boundary="ENQF41FoByJVxUdJLhxXttxlktMpIGaoq";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <2092fa5f-d87f-bac9-8091-ed2a9e64fe01@sandeen.net>
Subject: Re: [ANNOUNCE] xfsprogs master updated to 65dcd3b
References: <215c5b02-9eb9-e626-f21b-c5c8404ae8e5@sandeen.net>
In-Reply-To: <215c5b02-9eb9-e626-f21b-c5c8404ae8e5@sandeen.net>

--ENQF41FoByJVxUdJLhxXttxlktMpIGaoq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/3/19 3:06 PM, Eric Sandeen wrote:
> Hi folks,
>=20
> The xfsprogs repository at:
>=20
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>=20
> has just been updated.

Forgot to sign that one, so I'll sign a reply, just in case anyone
was worried.

-Eric
=20
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
>=20
> The new head of the master branch is commit:
>=20
> Hi folks,
>=20
> The xfsprogs repository at:
>=20
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>=20
> has just been updated.
>=20
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
>=20
> The new head of the master branch is commit:
>=20
> 65dcd3b xfsprogs: Release v5.0.0
>=20
> New Commits:
>=20
> Eric Sandeen (2):
>       [868d0cc] xfs_io: rework includes for statx structures
>       [65dcd3b] xfsprogs: Release v5.0.0
>=20
> Jorge Guerra (1):
>       [0c1d691] xfs_db: scan entire file system when using 'frag'
>=20
>=20
> Code Diffstat:
>=20
>  VERSION          | 2 +-
>  configure.ac     | 2 +-
>  db/frag.c        | 2 +-
>  debian/changelog | 6 ++++++
>  doc/CHANGES      | 4 ++++
>  io/stat.c        | 3 ---
>  io/statx.h       | 7 +++++++
>  7 files changed, 20 insertions(+), 6 deletions(-)
>  xfsprogs: Release v5.0.0
>=20
> New Commits:
>=20
> Eric Sandeen (2):
>       [868d0cc] xfs_io: rework includes for statx structures
>       [65dcd3b] xfsprogs: Release v5.0.0
>=20
> Jorge Guerra (1):
>       [0c1d691] xfs_db: scan entire file system when using 'frag'
>=20
>=20
> Code Diffstat:
>=20
>  VERSION          | 2 +-
>  configure.ac     | 2 +-
>  db/frag.c        | 2 +-
>  debian/changelog | 6 ++++++
>  doc/CHANGES      | 4 ++++
>  io/stat.c        | 3 ---
>  io/statx.h       | 7 +++++++
>  7 files changed, 20 insertions(+), 6 deletions(-)
>=20


--ENQF41FoByJVxUdJLhxXttxlktMpIGaoq--

--XsEsrDGhE9cSz8iL8psJM1WElKNhbwdXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzMn78ACgkQIK4WkuE9
3uD5Rg/9EpoSGEDem2Zo0CZPFKoLpjd4VHJe/ghTrruhx9wfB8bitn9RfGNNbr9z
x7vNgKNFQYn7A4I3H0ri0B7hmtr9iWnOjz/+A1tckXufNQ1S52doBcWvfwHEchC5
Db1hASpcrIwSIroa6J82SAw7KB/r1lWVLIBLma7OrMN3g7Jm+TMIE3WYK45qHFBo
NVzGlAEuDPXwnzpvOjT/i4I15dwQVIOZdMHFlNyWKtBHlLojKs49V8WsSahui4iL
0u9i2qFFw4QMevLqproo6g4UX17WBKAUzEa4Pi+ZO43jgnyP0qxmzwNrRwpZdqgV
np8n0M939aC4yd9uXhM2GSrO8MeJOY3sPexdKpnbpJIsfIWTO4z0xlar68rBZCrY
0CtQ4bLQgg1AnweoyhGT1oV2IDEDLpZqYgglAbFZNZqISvUhafbFGIZ8b62DHY3W
u/y5UaXX4/dqnkD9kvv9A5cSXn+1VDLXJruK0L1gRXHFsoNV3HYkw/5xj7EL9Un9
B4q1TTrcikIcJKGcBIvAEEb4cpPb1I1r2OgSD35pVMwdVjXVM3uQiNph5/jatr6c
6vGA/YsBv9Rs724Uqy3StnD3SKT5lw1gmOQ4MzWvUtA4gPaGmdklwKsQkgrg8Ri0
bA79pKHTDkW/sHB/lYVAhrVRjJgQzcd34eX/DucYNiqsZXmFv+Y=
=HPpB
-----END PGP SIGNATURE-----

--XsEsrDGhE9cSz8iL8psJM1WElKNhbwdXA--
