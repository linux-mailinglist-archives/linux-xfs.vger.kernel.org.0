Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E7E45156B
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Nov 2021 21:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350342AbhKOUhw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Nov 2021 15:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344029AbhKOTXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Nov 2021 14:23:08 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700AAC04992A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 10:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=ZrqzEYS7zcGSlEsC2E7z6ArnPcmykKt4j2RXG6nZ6mU=; b=GcmI3t1Y4yvMbXHAXHiktuRV4S
        W4a2rH5pPxqmF1U0Q72++99n7JAyYQ1eAuda3mbi9JiXSQja1uTIB6lIeOyPKlpDxD03Lb/c4JaIv
        hqj6ZvBh+X6lDd+Erd3F9GI4ca/sCawmV2gbog3l/6KrpmTpY0CCFJRTQwRoqTYbvH2psrF6Z7ZGO
        /FgQ9iBMlNseuBW78RkFE7HZjXdarHdXC8fy5DK0nqUeWkGO5lziKNxVceXiC+NK3QMdSdU2LF9mY
        wdm464jG9dRoEyaMEqQvNIg51IA7D5Wn0IGIXW8+x5Dm6k7dXXqOWsBMQty+Kn+QW2gJImCDHKJzu
        pP2hCYrg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mmghF-0004EU-VT; Mon, 15 Nov 2021 18:27:13 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bage@debian.org>
Subject: Bug#997656: marked as done (xfsprogs: FTBFS: mkdir: cannot create
 directory =?UTF-8?Q?=E2=80=98/usr/include/xfs=E2=80=99:?= Permission
 denied)
Message-ID: <handler.997656.D997656.163700072115882.ackdone@bugs.debian.org>
References: <E1mmgfP-0004r6-O6@fasolo.debian.org>
 <YXR8xgWW168lGMaT@xanadu.blop.info>
X-Debian-PR-Message: closed 997656
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: bookworm ftbfs sid
X-Debian-PR-Source: xfsprogs
Reply-To: 997656@bugs.debian.org
Date:   Mon, 15 Nov 2021 18:27:13 +0000
Content-Type: multipart/mixed; boundary="----------=_1637000833-16261-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1637000833-16261-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Mon, 15 Nov 2021 18:25:19 +0000
with message-id <E1mmgfP-0004r6-O6@fasolo.debian.org>
and subject line Bug#997656: fixed in xfsprogs 5.14.0-rc1-1
has caused the Debian Bug report #997656,
regarding xfsprogs: FTBFS: mkdir: cannot create directory =E2=80=98/usr/inc=
lude/xfs=E2=80=99: Permission denied
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
997656: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D997656
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1637000833-16261-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 23 Oct 2021 21:24:50 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.9 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	SPF_HELO_NONE,SPF_NONE,TXREP autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 16; hammy, 149; neutral, 44; spammy,
	1. spammytokens:0.960-+--H*r:smtp hammytokens:0.000-+--pkgbuilddir,
	0.000-+--PKGBUILDDIR, 0.000-+--H*RU:178.79.145.134,
	0.000-+--Hx-spam-relays-external:sk:xanadu.,
	0.000-+--Hx-spam-relays-external:178.79.145.134
Return-path: <lucas@debian.org>
Received: from xanadu.blop.info ([178.79.145.134]:48018)
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <lucas@debian.org>)
	id 1meOVW-0007Ll-0y
	for submit@bugs.debian.org; Sat, 23 Oct 2021 21:24:50 +0000
Received: from [127.0.0.1] (helo=xanadu.blop.info)
	by xanadu.blop.info with smtp (Exim 4.89)
	(envelope-from <lucas@debian.org>)
	id 1meOVU-0004Ir-6W
	for submit@bugs.debian.org; Sat, 23 Oct 2021 23:24:48 +0200
Received: (nullmailer pid 491373 invoked by uid 1000);
	Sat, 23 Oct 2021 21:21:10 -0000
Date: Sat, 23 Oct 2021 23:21:10 +0200
From: Lucas Nussbaum <lucas@debian.org>
To: submit@bugs.debian.org
Subject: xfsprogs: FTBFS: mkdir: cannot =?utf-8?Q?c?=
 =?utf-8?B?cmVhdGUgZGlyZWN0b3J5IOKAmC91c3IvaW5jbHVkZS94ZnPigJk=?=
 =?utf-8?Q?=3A?= Permission denied
Message-ID: <YXR8xgWW168lGMaT@xanadu.blop.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Delivered-To: submit@bugs.debian.org

Source: xfsprogs
Version: 5.13.0-1
Severity: serious
Justification: FTBFS
Tags: bookworm sid ftbfs
User: lucas@debian.org
Usertags: ftbfs-20211023 ftbfs-bookworm

Hi,

During a rebuild of all packages in sid, your package failed to build
on amd64.


Relevant part (hopefully):
> make[1]: Entering directory '/<<PKGBUILDDIR>>'
> Installing libfrog-install
> Installing libxfs-install
> ../install-sh -o root -g root -m 755 -d /usr/include/xfs
> mkdir: cannot create directory ‘/usr/include/xfs’: Permission denied
> mkdir: cannot create directory ‘/usr/include/xfs’: Permission denied
> gmake[2]: *** [Makefile:124: install] Error 1
> make[1]: *** [Makefile:148: libxfs-install] Error 2


The full build log is available from:
http://qa-logs.debian.net/2021/10/23/xfsprogs_5.13.0-1_unstable.log

A list of current common problems and possible solutions is available at
http://wiki.debian.org/qa.debian.org/FTBFS . You're welcome to contribute!

If you reassign this bug to another package, please marking it as 'affects'-ing
this package. See https://www.debian.org/Bugs/server-control#affects

If you fail to reproduce this, please provide a build log and diff it with mine
so that we can identify if something relevant changed in the meantime.

------------=_1637000833-16261-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 997656-close) by bugs.debian.org; 15 Nov 2021 18:25:21 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.1 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FOURLA,FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,MD5_SHA1_SUM,PGPSIGNATURE,
	RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,TXREP autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 114; hammy, 150; neutral, 132; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--Hx-spam-relays-external:sk:envelop, 0.000-+--H*r:138.16.160
Return-path: <envelope@ftp-master.debian.org>
Received: from muffat.debian.org ([2607:f8f0:614:1::1274:33]:45762)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=muffat.debian.org,EMAIL=hostmaster@muffat.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1mmgfR-00047x-MS
	for 997656-close@bugs.debian.org; Mon, 15 Nov 2021 18:25:21 +0000
Received: from fasolo.debian.org ([138.16.160.17]:52734)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1mmgfR-0005qv-8T; Mon, 15 Nov 2021 18:25:21 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1mmgfP-0004r6-O6; Mon, 15 Nov 2021 18:25:19 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Reply-To: Bastian Germann <bage@debian.org>
To: 997656-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#997656: fixed in xfsprogs 5.14.0-rc1-1
Message-Id: <E1mmgfP-0004r6-O6@fasolo.debian.org>
Date: Mon, 15 Nov 2021 18:25:19 +0000

Source: xfsprogs
Source-Version: 5.14.0-rc1-1
Done: Bastian Germann <bage@debian.org>

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive.

A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 997656@bugs.debian.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Bastian Germann <bage@debian.org> (supplier of updated xfsprogs package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster@ftp-master.debian.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Sun, 14 Nov 2021 23:18:22 +0100
Source: xfsprogs
Architecture: source
Version: 5.14.0-rc1-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Closes: 794158 997656
Changes:
 xfsprogs (5.14.0-rc1-1) unstable; urgency=medium
 .
   [ Dave Chinner ]
   * New build dependency: liburcu-dev
 .
   [ Helmut Grohne ]
   * Fix FTCBFS (Closes: #794158)
     + Pass --build and --host to configure
 .
   [ Boian Bonev ]
   * Fix FTBFS (Closes: #997656)
     + Keep custom install-sh after autogen
Checksums-Sha1:
 d3c15cd8386cbeb793838196efa329c31f67b170 2045 xfsprogs_5.14.0-rc1-1.dsc
 38f986a3f49a914f81f65cf3a09553f565ac2c0d 1536948 xfsprogs_5.14.0-rc1.orig.tar.gz
 cca1668fde70c881cb28d1e0d612229150293889 14232 xfsprogs_5.14.0-rc1-1.debian.tar.xz
 80932400488c0408da8b03f5ef3df87bea6ddd05 6251 xfsprogs_5.14.0-rc1-1_source.buildinfo
Checksums-Sha256:
 7ba6ebb4446bfd8257e185ef3b15172a9dec870f25dca875939fc2092792169e 2045 xfsprogs_5.14.0-rc1-1.dsc
 fccadafbf8c609fec5f6b38f452879b83647dff640a16bca939777ea4e81bc04 1536948 xfsprogs_5.14.0-rc1.orig.tar.gz
 7eede3f2cb24fecc5419762b4e2493afc856a850f47adfc0ea4a6b044f768885 14232 xfsprogs_5.14.0-rc1-1.debian.tar.xz
 516f6e2eb6e94804e0b7e6849507786b2af7bf5af45795c1daaefd980f250d0e 6251 xfsprogs_5.14.0-rc1-1_source.buildinfo
Files:
 c584f503002c94b4375d63a65eeeda79 2045 admin optional xfsprogs_5.14.0-rc1-1.dsc
 5170e9971709bb1847b2b5363d3d2807 1536948 admin optional xfsprogs_5.14.0-rc1.orig.tar.gz
 d2939ac3e1db87942907ba9b6953b016 14232 admin optional xfsprogs_5.14.0-rc1-1.debian.tar.xz
 c0a1a12e94c11239a1c696a7df4bb7bb 6251 admin optional xfsprogs_5.14.0-rc1-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmGSmlcACgkQH1x6i0VW
QxRcagv+JRdcKjx/4J8TDXt6wRS9GY9Qx1AcgsjpaY5auCzCXN/l4AzkBHinlVzO
JFUy/icg7c2jQq22rEkyMD/uHkURp/O0Kz7Ld73wghYBbTmLs+czLa66cA9eVPYQ
cu0X/biC2DTGASHvp0FuetHgvO4KUQvTYDIINEeDnfVgwSjSHzMkHTIPlHj/X74d
GBNH7++IV8MpqKlZBDfgKYSUeE9Hm0zssCjlgZudA4+dal/cF3gq31omcE0lFjAE
p3OBDzn9fOOei1jEwDtwV9K3y+5NP5tBVsOSG2EkLJEhRRS+VqbpQCUUQwAzpKNF
RpqIZ+JQZH3cyOnVpqidae/oABN/oEXAHDlZ/X52bT2tlH4wSGMRtz6rXC5hp0jd
j2phekA8lHaW+7ACPH1rNYE7e8Vg0hUdOCAzxNu2FDnPLzC/GfInlSBoHojWhTt2
2oBo/Z16ejjShcuuaTM2RWJSEopY2X9ouz1ea/nTdOCVV3F8kYGnORWScj16QzPo
vdJg1PlB
=GJZC
-----END PGP SIGNATURE-----
------------=_1637000833-16261-0--
