Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D87889528
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 03:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfHLBVk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 11 Aug 2019 21:21:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54370 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbfHLBVj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 11 Aug 2019 21:21:39 -0400
Received: from [IPv6:2001:4dd6:c89b:0:149a:6c9b:d6bb:ae22] (2001-4dd6-c89b-0-149a-6c9b-d6bb-ae22.ipv6dyn.netcologne.de [IPv6:2001:4dd6:c89b:0:149a:6c9b:d6bb:ae22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: whissi)
        by smtp.gentoo.org (Postfix) with ESMTPSA id B1B9034992E
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 01:21:36 +0000 (UTC)
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
From:   Thomas Deutschmann <whissi@gentoo.org>
Openpgp: preference=signencrypt
Autocrypt: addr=whissi@gentoo.org; prefer-encrypt=mutual; keydata=
 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
Organization: Gentoo Foundation, Inc
Message-ID: <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
Date:   Mon, 12 Aug 2019 03:21:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190812002306.GH7777@dread.disaster.area>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="3zqWurH15WEVzZn119NZKn5vzL4izrk8u"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3zqWurH15WEVzZn119NZKn5vzL4izrk8u
Content-Type: multipart/mixed; boundary="xh4DQbO1yk1tBLrab7ekrGKT35rFElrJH";
 protected-headers="v1"
From: Thomas Deutschmann <whissi@gentoo.org>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
In-Reply-To: <20190812002306.GH7777@dread.disaster.area>

--xh4DQbO1yk1tBLrab7ekrGKT35rFElrJH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-08-12 02:23, Dave Chinner wrote:
> That still doesn't explain where all the whacky gcc options are
> coming from - that's got to be something specific to your build or
> distro environment.

Mh, at the moment it looks like xfsprogs' build system is adding
$LDFLAGS multiple times when LDFLAGS is set in environment.

In a clear environment, do:

> tar -xaf xfsprogs-5.2.0.tar.xz
> cd xfsprogs-5.2.0
> export CFLAGS=3D"-O2 -pipe -march=3Divybridge -mtune=3Divybridge -mno-x=
saveopt"
> export LDFLAGS=3D"-Wl,-O1 -Wl,--as-needed"
> ./configure
> make V=3D1

And you will end up

> /bin/bash ../libtool --quiet --tag=3DCC --mode=3Dlink x86_64-pc-linux-g=
nu-gcc -o xfs_repair -Wl,-O1 -Wl,--as-needed  -Wl,-O1 -Wl,--as-needed   -=
Wl,-O1 -Wl,--as-needed   -Wl,-O1 -Wl,--as-needed -static-libtool-libs  ag=
header.o attr_repair.o avl.o bmap.o btree.o da_util.o dino_chunks.o dinod=
e.o dir2.o globals.o incore.o incore_bmc.o init.o incore_ext.o incore_ino=
=2Eo phase1.o phase2.o phase3.o phase4.o phase5.o phase6.o phase7.o progr=
ess.o prefetch.o rmap.o rt.o sb.o scan.o slab.o threads.o versions.o xfs_=
repair.o   ../libxfs/libxfs.la ../libxlog/libxlog.la ../libxcmd/libxcmd.l=
a ../libfrog/libfrog.la -luuid -lrt -lpthread -lblkid


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--xh4DQbO1yk1tBLrab7ekrGKT35rFElrJH--

--3zqWurH15WEVzZn119NZKn5vzL4izrk8u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl1QvxhfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDEz
MTI5MUNFOEY4QjBENzI2MDVDN0I5NDQ0RTZFQkRDOUJGNjA1NTkACgkQRObr3Jv2
BVmZTAf+Md5TzvB+pGOmgTi5jQ2YQPO44Jy+I8aPrFrqY60E2oeSjwrcdHcrr836
VryoS6aP55OfANffw/aE4ugRB0NN8KPyUNgAaJs28+LDzypbhwbPFqH411Lz2Y7O
S7dEvoV+J3WfXBnaSwzVZsXVBg6tXpjYimjq6RCaRdryNF64pA4rKbJSpld4V/Kz
Yn3qyfUxWyLARVJ5l6nBXYEdlMEF+9rcUDjkkBGY7aX2LQUc+MX8P7Fb0kJuACQR
NY+q8/H7g68Wkci39K9XXtwoYXOPI/O9r85T12UFBNJvZV5COctieMYMY//uDSla
hl9+lRAWbrpd9NuFo/P5h798EDDfuw==
=sG3l
-----END PGP SIGNATURE-----

--3zqWurH15WEVzZn119NZKn5vzL4izrk8u--
