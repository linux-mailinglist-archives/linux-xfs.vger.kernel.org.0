Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9993B10168
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2019 23:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfD3VH2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Apr 2019 17:07:28 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39806 "EHLO tmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfD3VH2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Apr 2019 17:07:28 -0400
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
        by mailer.gwdg.de with esmtp (Exim 4.90_1)
        (envelope-from <maan@tuebingen.mpg.de>)
        id 1hLZyH-00044Z-Gx; Tue, 30 Apr 2019 23:07:25 +0200
Received: from [10.37.80.2] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 22791534; Tue, 30 Apr 2019 23:08:51 +0200
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Tue, 30 Apr 2019 23:07:24 +0200
Date:   Tue, 30 Apr 2019 23:07:24 +0200
From:   Andre Noll <maan@tuebingen.mpg.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190430210724.GD2780@tuebingen.mpg.de>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eu8nj/18vubUeVCi"
Content-Disposition: inline
In-Reply-To: <20190430191825.GF5217@magnolia>
User-Agent: Mutt/1.11.4 (207b9306) (2019-03-13)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--eu8nj/18vubUeVCi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 12:18, Darrick J. Wong wrote
> > commit f847bda4d612744ff1812788417bd8df41a806d3
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Mon Nov 19 13:31:08 2018 -0800
> >=20
> >     xfs: finobt AG reserves don't consider last AG can be a runt
> >    =20
> >     This is a backport of upstream commit c08768977b9 and the part of
> >     21ec54168b36 which is needed by c08768977b9.
>=20
> You could send this patch to the stable list, but my guess is that
> they'd prefer a straight backport of all three commits...

Hm, cherry-picking the first commit onto 4.9,171 already gives
four conflicting files. The conflicts are trivial to resolve (git
cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
(xfs: create a function to query all records in a btree) is needed as
well. But then, applying 86210fbebae (xfs: move various type verifiers
to common file) on top of that gives non-trivial conflicts.

So, for automatic backporting we would need to cherry-pick even more,
and each backported commit should be tested of course. Given this, do
you still think Greg prefers a rather large set of straight backports
over the simple commit that just pulls in the missing function?

I guess the important question is how much impact this issue
has on production systems (i.e., on CONFIG_XFS_DEBUG=3Dn kernels,
where the assert statement is not compiled in). If the unpatched
xfs_inobt_max_size() is very unlikely to cause problems on such
systems, we might as well live with it.

Thanks
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--eu8nj/18vubUeVCi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXMi5CQAKCRBa2jVAMQCT
DyqRAJ9haZLNWKNF1m2TNS7qlvy9B+Og7QCgkgF+uEQORJ7ALymtB4oypC+7MUY=
=LEL+
-----END PGP SIGNATURE-----

--eu8nj/18vubUeVCi--
