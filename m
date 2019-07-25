Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D515746C5
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 08:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfGYGEz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 02:04:55 -0400
Received: from relayout01-q02.e.movistar.es ([86.109.101.142]:55383 "EHLO
        relayout01-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726195AbfGYGEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 02:04:55 -0400
Received: from relayout01-redir.e.movistar.es (relayout01-redir.e.movistar.es [86.109.101.201])
        by relayout01-out.e.movistar.es (Postfix) with ESMTP id 45vMBF0yRlzjbws
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 08:04:53 +0200 (CEST)
Received: from Telcontar.valinor (70.red-88-9-30.dynamicip.rima-tde.net [88.9.30.70])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout01.e.movistar.es (Postfix) with ESMTPSA id 45vMBD65sJzfZ2T
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 08:04:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 51CE7320B40
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 08:04:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at valinor
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id SBPnwbA7S9Py for <linux-xfs@vger.kernel.org>;
        Thu, 25 Jul 2019 08:04:51 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 326163206C6
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 08:04:51 +0200 (CEST)
Subject: Re: Sanity check - need a second pair of eyes ;-)
To:     Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
 <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
From:   "Carlos E. R." <robin.listas@telefonica.net>
Openpgp: preference=signencrypt
Autocrypt: addr=robin.listas@telefonica.net; prefer-encrypt=mutual; keydata=
 mQGiBEBfUmURBADiQy6hqnDUs980vU7Pi0qm/JnurLnZUDDEf8k7H10UnKi8E3ySztQuWsPK
 12ccfWCHMKboluffBQA3jf0h1Rl6VZ9brU+rNuqy1eE8bkILhLkoZrsNGXWtzOvRHVSF7dhb
 GBuuFeqdGiRJPSvezQAi3S8dgXugSLZvbyHV97rATwCgmYzZ9mLrTV9RPMJy07K9SY2ZFFkD
 /1rvNuU1teq5hm4naypOFrfO2X4foo9+UjuqZpcPnxD4LEfyrjpx5QVNi3zEDGIAbN7exo4X
 s3VDWnrYZ8lqno4LfTlbuFcgLbAllhW7tYFg4sNW1dWr29VQjghZ8le+Fucx2VJOwv6ILWOr
 O7Qgj61HUvWlR+doKxQBOxFk50IiBACuUBaWimjjbJKvGjMRimJWdGHHxwo+oMA2ZLnsS7wJ
 cSIthF8FC8c1pyJwWcLiYcViy3kypJPloTiQqaZqhVx0ouCYFHBOYLaacCddJ7r6KHZyrjjo
 SegO1vIJn2Y9TolJfuHMNb276A+JPb3gHqm1bfcNHmduKa0gK2NyEkKGWbQwQ2FybG9zIEUu
 IFIuIChjZXIpIDxyb2Jpbi5saXN0YXNAdGVsZWZvbmljYS5uZXQ+iGEEExECACECGwMGCwkI
 BwMCAxUCAwMWAgECHgECF4AFAkfpXpcCGQEACgkQtTMYHG2NR9V4DwCePcfkI8iZtIo9WV1O
 K/ZB8CgMQcMAmwb/JZLJitq0tbzrWeKLZshwGr5puQENBEBfUmYQBACWLO2NmHMU9VM+eTt8
 91cIFfXuhdGBXo3rtQx6Ybgh6tgeag0Rziij7xtlgdtWyM+Gj2cSK5M74P3IOiPKp/ALpneW
 mYEq/11E0zyXPWC5TOXu1/kBfrRvR7sTwB/cXthHESq1j+eEOF//4h0sWrCCKWVwNe7NRy4E
 XbA6culWCwADBQP/c4MCf14YU1qaIQly79ZgNsSZPq/QiVLFI9LG3asrS1OdiPskVS1GN4OD
 BaedOGpUcMa/iwabRILH+d3l7lNIBvZ18aRZN85breq9BCmb0AIYgmZiUL2W5dxXh2gQPaqI
 vF7yvRuGuY5YzC5KqJ7Glpa2wzZ84IdoWAEVMZ+j/uSIRgQYEQIABgUCQF9SZgAKCRC1Mxgc
 bY1H1br5AKCHpABJhGBMGIozLmKiXQ+2MnFknQCeJZx7e+LQJKDrq4ti5MyK6Hjh1+I=
Message-ID: <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
Date:   Thu, 25 Jul 2019 08:04:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QckbUVJHuJ4ZfsPQkWQNwF1vpSbM8jk3d"
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-TnetOut-Country: IP: 88.9.30.70 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout01
X-TnetOut-MsgID: 45vMBD65sJzfZ2T.ADE9A
X-TnetOut-SpamCheck: no es spam (whitelisted), Unknown
X-TnetOut-From: robin.listas@telefonica.net
X-TnetOut-Watermark: 1564639493.00024@1QzkqF1kTUKblTiQxSiGEw
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QckbUVJHuJ4ZfsPQkWQNwF1vpSbM8jk3d
Content-Type: multipart/mixed; boundary="ndUJxwgkGmbBxKzv7gEgFLgFS5pVnKAig";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
Subject: Re: Sanity check - need a second pair of eyes ;-)
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
 <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
In-Reply-To: <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>

--ndUJxwgkGmbBxKzv7gEgFLgFS5pVnKAig
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 24/07/2019 22.21, Eric Sandeen wrote:

=2E..

>> Is that the correct command line to achieve written sectors of 2 KiB?
>=20
> If you want to set the sector size, the instructions are in the man pag=
e for
> mkfs.xfs ;)
>=20
>        -s sector_size
>               This  option  specifies  the  fundamental  sector  size  =
of  the
>               filesystem.  The sector_size is specified either as a  va=
lue  in
>               bytes  with  size=3Dvalue  or  as  a base two logarithm v=
alue with
>               log=3Dvalue.  The default sector_size is 512  bytes.  The=
  minimum
>               value for sector size is 512; the maximum is 32768 (32 Ki=
B). The
>               sector_size must be a power of 2 size and cannot be made =
 larger
>               than the filesystem block size.

Thanks.=20

(Yes, I looked at the manual but did not /see/ aka understand what I real=
ly needed).

My page is a little bit different:

       -s sector_size_options
              This option specifies the fundamental  sector  size  of
              the filesystem.  The valid sector_size_option is:

                   size=3Dvalue
                          The  sector  size is specified with a value
                          in bytes.  The default sector_size  is  512
                          bytes. The minimum value for sector size is
                          512; the maximum is  32768  (32  KiB).  The
                          sector_size  must  be a power of 2 size and
                          cannot be made larger than  the  filesystem
                          block size.

                          To  specify any options on the command line
                          in units of sectors, this  option  must  be
                          specified  first so that the sector size is
                          applied consistently to all options.

Thus the final command line was:

# mkfs.xfs -L ANameUnseen -s size=3D2048 /dev/mapper/cr_nombre
meta-data=3D/dev/mapper/cr_nombre  isize=3D512    agcount=3D4, agsize=3D3=
054592 blks
         =3D                       sectsz=3D2048  attr=3D2, projid32bit=3D=
1
         =3D                       crc=3D1        finobt=3D1, sparse=3D0,=
 rmapbt=3D0
         =3D                       reflink=3D0
data     =3D                       bsize=3D4096   blocks=3D12218368, imax=
pct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1=

log      =3Dinternal log           bsize=3D4096   blocks=3D5966, version=3D=
2
         =3D                       sectsz=3D2048  sunit=3D1 blks, lazy-co=
unt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D=
0


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 15.0 x86_64 at Telcontar)


--ndUJxwgkGmbBxKzv7gEgFLgFS5pVnKAig--

--QckbUVJHuJ4ZfsPQkWQNwF1vpSbM8jk3d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXTlGeAAKCRC1MxgcbY1H
1URoAKCIZhOq0P+knvLwbHryzO3kL1p1FgCePLDlmr8z7r4xXMHxN/GGPT6T9g8=
=Qekq
-----END PGP SIGNATURE-----

--QckbUVJHuJ4ZfsPQkWQNwF1vpSbM8jk3d--
