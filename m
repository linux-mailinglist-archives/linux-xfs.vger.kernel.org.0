Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2695B2AC
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 03:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfGABMM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 30 Jun 2019 21:12:12 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49557 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfGABMM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 30 Jun 2019 21:12:12 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45cTqY4Wc9z9s00;
        Mon,  1 Jul 2019 11:12:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561943529;
        bh=o6gd4NLWj/EtzaylEp5ED6sPC4TTEDVm/KOCAb3wtoY=;
        h=Date:From:To:Cc:Subject:From;
        b=fun4ppSre3K3LV3/4xj7PXIfux9LZBh6FujyY1LYX0X0DKEyNvHahvZc3xIPWBC4P
         32tCk0a58cPCZ8tem7XkTR63KVuZ+WP9xrNduwnk0oMg6Ag+X5fw47upO9datbLCHm
         vkYn8ic+GsyPtV8L5vjpbRyye01MPrKwcAmrE7B0rxvce7geKYeJUEiQKM1J0RYgpN
         3r7q9lEFjUl190A+Gof7kYI6x88IgO9DYGyX5X0P4gbHcB9Rv5pdlxwY1CrzVKhODB
         H7hxfGKh0tm4RZ7b+2hQP0bGpJClTbZBDfB2KRK5BjWZF72mM81+mLVeFAhtSI9fyz
         qFWV9o0T60uWA==
Date:   Mon, 1 Jul 2019 11:12:09 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build failure after merge of the xfs tree
Message-ID: <20190701111209.699082b7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GiBgqkQeV_Fn=xa4769+.=9"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/GiBgqkQeV_Fn=xa4769+.=9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xfs tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

fs/orangefs/file.c: In function 'orangefs_getflags':
fs/orangefs/file.c:372:7: warning: assignment to 'long unsigned int *' from=
 '__u64' {aka 'long long unsigned int'} makes pointer from integer without =
a cast [-Wint-conversion]
  uval =3D val;
       ^
fs/orangefs/file.c: In function 'orangefs_ioctl':
fs/orangefs/file.c:381:24: error: implicit declaration of function 'file_io=
ctl'; did you mean 'file_path'? [-Werror=3Dimplicit-function-declaration]
  struct inode *inode =3D file_ioctl(file);
                        ^~~~~~~~~~
                        file_path
fs/orangefs/file.c:381:24: warning: initialization of 'struct inode *' from=
 'int' makes pointer from integer without a cast [-Wint-conversion]
fs/orangefs/file.c:418:35: error: 'old_uval' undeclared (first use in this =
function); did you mean 'p4d_val'?
   ret =3D orangefs_getflags(inode, &old_uval);
                                   ^~~~~~~~
                                   p4d_val
fs/orangefs/file.c:418:35: note: each undeclared identifier is reported onl=
y once for each function it appears in

Caused by commit

  de2baa49bbae ("vfs: create a generic checking and prep function for FS_IO=
C_SETFLAGS")

I have used the xfs tree from next-20190628 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/GiBgqkQeV_Fn=xa4769+.=9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0ZXekACgkQAVBC80lX
0GwDoAf+ORrfhB4XavC2KJUhXgoqhs75kuRhvoxtnUb0j15p++q00JVuAoKXDF0e
AGuNMqTt0+nWCBwe0Ds6Vky/m20YsdT0PccVl2V3UXEDUiNShsNSVtEGuaFkqrIW
4bJUVNji3kU95lox7L8Rm6wMo1xZazCHvaeAMMMi4MmeoP4Y8oZT63MNJE0je21j
YOq9QEZiZIdeQ/hud8icxUapL8UMPLgpsOLrcV15NqTM9z+vurqRpKLJlFR9421c
XAbSX5WIlMBIfWbFCPqP2zuSng/fRJwA6/dSvNiFPDOjG8LNXIb1agCfhk/kqZdM
aNVbi57y4KdLYYHAo9skpCaHbr91AA==
=NGNr
-----END PGP SIGNATURE-----

--Sig_/GiBgqkQeV_Fn=xa4769+.=9--
