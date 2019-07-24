Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1981373E09
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 22:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbfGXUV4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 16:21:56 -0400
Received: from sandeen.net ([63.231.237.45]:43576 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389035AbfGXUVz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jul 2019 16:21:55 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2FE1FD5E;
        Wed, 24 Jul 2019 15:21:25 -0500 (CDT)
Subject: Re: Sanity check - need a second pair of eyes ;-)
To:     "Carlos E. R." <robin.listas@telefonica.net>,
        Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
Date:   Wed, 24 Jul 2019 15:21:52 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TrjTLOPH2oBLcBUNHZc3SfzY0o5JPCsnc"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TrjTLOPH2oBLcBUNHZc3SfzY0o5JPCsnc
Content-Type: multipart/mixed; boundary="QVt4k46B3sAbU71396fCJeaCFLqBrMVXG";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: "Carlos E. R." <robin.listas@telefonica.net>,
 Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
Subject: Re: Sanity check - need a second pair of eyes ;-)
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
In-Reply-To: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>

--QVt4k46B3sAbU71396fCJeaCFLqBrMVXG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> Hi,
>=20
> I'm trying to create an XFS image to be written on a Blue Ray disk, enc=
rypted. I'm told that DVDs have a sector size of 2 KiB, thus it is beter =
to tell the formatting utility of that, because when creating the image f=
ile it is on a hard disk where sector size is 512B.
>=20
> Basic procedure:
>=20
> truncate -s 50050629632 image_1_50.img
> losetup -f image_1_50.img
> cryptsetup luksFormat --type luks2 --label blueray50img /dev/loop0
> cryptsetup luksOpen /dev/loop0 cr_nombre
>=20
>=20
> So now I have the image file loop mounted on /dev/mapper/cr_nombre, and=
 I do (this is the step I ask about):
>=20
> Telcontar:/home_aux/BLUERAY_OPS # mkfs.xfs -L ANameUnseen -b size=3D204=
8 /dev/mapper/cr_nombre
                                                             ^^^ block si=
ze

> meta-data=3D/dev/mapper/cr_nombre  isize=3D512    agcount=3D4, agsize=3D=
6109184 blks
>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D1
>          =3D                       crc=3D1        finobt=3D1, sparse=3D=
0, rmapbt=3D0
>          =3D                       reflink=3D0
> data     =3D                       bsize=3D2048   blocks=3D24436736, im=
axpct=3D25
                                   ^^^ block size
>          =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D=
1
> log      =3Dinternal log           bsize=3D2048   blocks=3D11932, versi=
on=3D2
>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-=
count=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> Telcontar:/home_aux/BLUERAY_OPS #
>=20
>=20
> Is that the correct command line to achieve written sectors of 2 KiB?

If you want to set the sector size, the instructions are in the man page =
for
mkfs.xfs ;)

       -s sector_size
              This  option  specifies  the  fundamental  sector  size  of=
  the
              filesystem.  The sector_size is specified either as a  valu=
e  in
              bytes  with  size=3Dvalue  or  as  a base two logarithm val=
ue with
              log=3Dvalue.  The default sector_size is 512  bytes.  The  =
minimum
              value for sector size is 512; the maximum is 32768 (32 KiB)=
=2E The
              sector_size must be a power of 2 size and cannot be made  l=
arger
              than the filesystem block size.

-Eric

> I ask because I see isize=3D512 and sectsz=3D512 and I wonder.
>=20
>=20
> -- Cheers,
>        Carlos E. R.
>        (from openSUSE 15.0 x86_64 at Telcontar)
>=20


--QVt4k46B3sAbU71396fCJeaCFLqBrMVXG--

--TrjTLOPH2oBLcBUNHZc3SfzY0o5JPCsnc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl04veAACgkQIK4WkuE9
3uB+XxAAk2YrFN9/mx8zQHyrQwWdJtVHGjjUPX+MRHSFO3eRlX8FSVdw7cTx2GOe
QFfwDe2o7tHUGhXx+z1r2gq+JbxBri577VyAsRXil5DJxXNj77pYluKEpF8v+HFZ
QQ2mGgX+aCvzmff338DCVpuzgm9YbWZX0c+A52DrpoAqEyZn+NvF/8hfAJUbq1mL
c0XLFC0k/2+UB/1M4dU8UIyCaifKjXWO+bNEANOkdCzrYxddrO3eEgBslPIR08ux
I7Xlqy0YhlivrXwd73AmOvpXLtHEAxbwUJvJBJ762cCDomrDTpP9gz+QC0FNewyk
lcnhR8DPxZv3OhCPG7r+97yhgznA0YmkRkDShh+B01ocDELnvn293cCvKivckk3F
y7+a2JACdwrD6tE7U1PElCsb5Po3t+NXvwxeO+k4dWMu/GeLcezEz1Uro6fYFVEu
tX/jO2sFY7oPHVVAHbzfIEYvdQwUIN1El2osJFpm772lxk0AfeYKa1EjRKf3BSNr
VGrQqmqPQ0JDkIRbz4+rDwiIduu7kQgFFWe/qB6vR7zYlh2yrdFlFBMR0YhYRX9Z
gayHO84+SrFbWC4aF4jFmfYWJUyWJ4ZBE0B28zT/n0DI9bhbic4kc7lIKbt9badO
ZxeQ3ijo8ZX3w9+RntDzyj+H8vvmJNFJxs2H1m+yE45smV/znKY=
=HJWD
-----END PGP SIGNATURE-----

--TrjTLOPH2oBLcBUNHZc3SfzY0o5JPCsnc--
