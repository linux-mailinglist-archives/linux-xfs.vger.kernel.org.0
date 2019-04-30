Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241831000E
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2019 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfD3TFa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Apr 2019 15:05:30 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:54986 "EHLO tmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfD3TF3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Apr 2019 15:05:29 -0400
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
        by mailer.gwdg.de with esmtp (Exim 4.90_1)
        (envelope-from <maan@tuebingen.mpg.de>)
        id 1hLY4E-0008Vx-Pq; Tue, 30 Apr 2019 21:05:26 +0200
Received: from [10.37.80.2] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 22790245; Tue, 30 Apr 2019 21:06:52 +0200
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Tue, 30 Apr 2019 21:05:25 +0200
Date:   Tue, 30 Apr 2019 21:05:25 +0200
From:   Andre Noll <maan@tuebingen.mpg.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190430190525.GB2780@tuebingen.mpg.de>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OThxTnIjTxi+/jRk"
Content-Disposition: inline
In-Reply-To: <20190430174042.GH5207@magnolia>
User-Agent: Mutt/1.11.4 (207b9306) (2019-03-13)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--OThxTnIjTxi+/jRk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 10:40, Darrick J. Wong wrote
> > With CONFIG_XFS_DEBUG=3Dn the mount succeeded, and xfs_info says
> >=20
> > 	meta-data=3D/dev/mapper/zeal-tst   isize=3D512    agcount=3D101, agsiz=
e=3D268435392 blks
> > 		 =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
> > 		 =3D                       crc=3D1        finobt=3D1 spinodes=3D0 rma=
pbt=3D0
> > 		 =3D                       reflink=3D0
> > 	data     =3D                       bsize=3D4096   blocks=3D26843545600=
, imaxpct=3D1
>=20
> Oh, wait, you have a 100T filesystem with a runt AG at the end due to
> the raid striping...
>=20
> 26843545600 % 268435392 =3D=3D 6400 blocks (in AG 100)
>=20
> And that's why there's 6,392 free blocks in an AG and an attempted
> reservation of 267,367 blocks.

Jup, that nails it.

> In that case, the patch you want is c08768977b9 ("xfs: finobt AG
> reserves don't consider last AG can be a runt") which has not been
> backported to 4.9.  That patch relies on a function introduced in
> 21ec54168b36 ("xfs: create block pointer check functions") and moved to
> a different file in 86210fbebae6e ("xfs: move various type verifiers to
> common file").
>=20
> The c087 patch which will generate appropriately sized reservations for
> the last AG if it is significantly smaller than the the other and should
> fix the assertion failure.

Great. Thanks a lot for digging out these commits.

Would you be willing to support backporting this commit to
4.9.x? IOW, something like the below (against 4.9.171) which puts
xfs_inobt_max_size() into libxfs/xfs_ialloc_btree.c. Seems to work
fine.

Best
Andre
---
commit f847bda4d612744ff1812788417bd8df41a806d3
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Nov 19 13:31:08 2018 -0800

    xfs: finobt AG reserves don't consider last AG can be a runt
   =20
    This is a backport of upstream commit c08768977b9 and the part of
    21ec54168b36 which is needed by c08768977b9.
   =20
    Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
    Tested-by: Andre Noll <maan@tuebingen.mpg.de>

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_bt=
ree.c
index b9c351ff0422..33905989929e 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -502,17 +502,33 @@ xfs_inobt_rec_check_count(
 }
 #endif	/* DEBUG */
=20
+/* Find the size of the AG, in blocks. */
+static xfs_agblock_t
+xfs_ag_block_count(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	if (agno < mp->m_sb.sb_agcount - 1)
+		return mp->m_sb.sb_agblocks;
+	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
+}
+
 static xfs_extlen_t
 xfs_inobt_max_size(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
 {
+	xfs_agblock_t		agblocks =3D xfs_ag_block_count(mp, agno);
+
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
 	if (mp->m_inobt_mxr[0] =3D=3D 0)
 		return 0;
=20
 	return xfs_btree_calc_size(mp, mp->m_inobt_mnr,
-		(uint64_t)mp->m_sb.sb_agblocks * mp->m_sb.sb_inopblock /
-				XFS_INODES_PER_CHUNK);
+				(uint64_t)agblocks * mp->m_sb.sb_inopblock /
+					XFS_INODES_PER_CHUNK);
 }
=20
 static int
@@ -558,7 +574,7 @@ xfs_finobt_calc_reserves(
 	if (error)
 		return error;
=20
-	*ask +=3D xfs_inobt_max_size(mp);
+	*ask +=3D xfs_inobt_max_size(mp, agno);
 	*used +=3D tree_len;
 	return 0;
 }
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--OThxTnIjTxi+/jRk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXMiccwAKCRBa2jVAMQCT
D/vMAJ4tJOazJGsYqAf333CY+9TxulDkhQCgomdm7oyWL/rpJ1swQtl51mY00jE=
=COGK
-----END PGP SIGNATURE-----

--OThxTnIjTxi+/jRk--
