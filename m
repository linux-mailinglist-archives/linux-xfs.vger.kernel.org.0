Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249538A36C
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbfHLQfA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:35:00 -0400
Received: from sandeen.net ([63.231.237.45]:42770 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbfHLQfA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Aug 2019 12:35:00 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9BC3815D9A;
        Mon, 12 Aug 2019 11:34:58 -0500 (CDT)
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
To:     Thomas Deutschmann <whissi@gentoo.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <5aff83b5-2ff3-4c2c-e0ef-c04bc506fe4f@sandeen.net>
Date:   Mon, 12 Aug 2019 11:34:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pisG2onWkJFSznO9hIZiEMsNQHioRVFCH"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pisG2onWkJFSznO9hIZiEMsNQHioRVFCH
Content-Type: multipart/mixed; boundary="pvSy01QCrO70y4in7HudnJ6LFvlFw2ebk";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Thomas Deutschmann <whissi@gentoo.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <5aff83b5-2ff3-4c2c-e0ef-c04bc506fe4f@sandeen.net>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
In-Reply-To: <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>

--pvSy01QCrO70y4in7HudnJ6LFvlFw2ebk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/12/19 5:57 AM, Thomas Deutschmann wrote:
> Hi,
>=20
> On 2019-08-12 06:30, Dave Chinner wrote:
>>>> In a clear environment, do:
>>>>
>>>>> tar -xaf xfsprogs-5.2.0.tar.xz
>>>>> cd xfsprogs-5.2.0
>>>>> export CFLAGS=3D"-O2 -pipe -march=3Divybridge -mtune=3Divybridge -m=
no-xsaveopt"
>>>>> export LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed"
>>>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> Don't do this.
>>>
>>> "--as-needed" is the default linker behaviour since gcc 4.x. You do
>>> not need this. As for passing "-O1" to the linker, that's not going
>>> to do anything measurable for you. Use --enable-lto to turn on link
>>> time optimisations if they are supported by the compiler.
>>
>> Ok, I could reproduce your link time failure for a while with
>> --enable-lto, but I ran 'make distclean' and the problem went away
>> completely. And I can build with your options successfully, too:
>>
>> $ make realclean
>> $ make configure
>> <builds new configure script>
>> $ LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed" ./configure
>=20
> That's not the correct way to reproduce. It's really important to
> _export_ the variable to trigger the problem and _this_ is a problem in=

> xfsprogs' build system.
>=20
> But keep in mind that 3x "-Wl,-O1 -Wl,--as-needed" don't cause a failur=
e
> without "--disable-static" for me... that's just the answer for your
> question where this is coming from.

My takeaway here is that I should probably stub out some things to make
this issue go away altogether, but that it can also be remedied by adjust=
ing
compiler/linker flags.  Correct?  I'm not sure if this warrants a 5.2.1 r=
elease.

Thanks,
-Eric


--pvSy01QCrO70y4in7HudnJ6LFvlFw2ebk--

--pisG2onWkJFSznO9hIZiEMsNQHioRVFCH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIyBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl1RlTAACgkQIK4WkuE9
3uDRqw/2JkVJuPr3AymxYLg3I/Jqkni/HQpxiaCwdSkRZIkws28EmADzyAn1Gf5B
/Bo+OHIXnHKKfc/C2PvL7wd7jzy7mSOWRmsftnVWx/4DIVsX2eICpqo3DJdhjBa/
Tf7/bzvhF+CJ0uuqWzm0FPmFoSOFNhohWWO+hqPCjHRGIRwJFGqOFMeg8Nt/8zTh
MF8kFLymMQEnTJreWgZ31Id2pZr+PzMPl53Djj9faDKn6g3fCdIGgERBJSIgdjwf
OaQ5X4gmusuv3U6IpkOgAz/tm+KwXmdA3OSCp8LwUVb/06xa/pQKKlgRczCkSTuy
yUFMS2uswsgPkkr4qqUz3NTgqghY8R4Yc16v/A7TLaJ0BfLY8Ti5/X6J8+Vdt60J
GTlLa42i3z350kriNX0/BSMVbsZS2xF4UlMxWZSVCfIJWWM4nfLvF603UJWqjGbx
ljVDNhGYoWAj1LRKwpZXcPh8SRy/jS5A08/HsAnnDUiEfSGhBNkgMwcXIzxmZU65
yLCMiS3Vr096L+z8T0oFE4+ZWyaGCpluh6R2kLAD1axTiMI6BR7dxk/tF5lt82NJ
gUy3M3pYb6wUUILH9qbHNbKCmELVdJULb5mFhb3/3G7KwamJ4JyflE65dA6/kua1
75glPdIrpWh43Xk6UaBvh2JInYIGmEyO4yY9MzG7stEN4wFUXw==
=RUc+
-----END PGP SIGNATURE-----

--pisG2onWkJFSznO9hIZiEMsNQHioRVFCH--
