Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CBF10BAE
	for <lists+linux-xfs@lfdr.de>; Wed,  1 May 2019 19:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfEARBC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 May 2019 13:01:02 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:34896 "EHLO tmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfEARBB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 May 2019 13:01:01 -0400
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
        by mailer.gwdg.de with esmtp (Exim 4.90_1)
        (envelope-from <maan@tuebingen.mpg.de>)
        id 1hLsbL-0003Dl-5e; Wed, 01 May 2019 19:00:59 +0200
Received: from [10.37.80.2] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 22798765; Wed, 01 May 2019 19:02:25 +0200
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Wed, 01 May 2019 19:00:58 +0200
Date:   Wed, 1 May 2019 19:00:58 +0200
From:   Andre Noll <maan@tuebingen.mpg.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190501170058.GG2780@tuebingen.mpg.de>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
 <20190430210724.GD2780@tuebingen.mpg.de>
 <20190501153643.GL5207@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qL6YN2OI1pnKQLYZ"
Content-Disposition: inline
In-Reply-To: <20190501153643.GL5207@magnolia>
User-Agent: Mutt/1.11.4 (207b9306) (2019-03-13)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--qL6YN2OI1pnKQLYZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 01, 08:36, Darrick J. Wong wrote

> > I guess the important question is how much impact this issue
> > has on production systems (i.e., on CONFIG_XFS_DEBUG=3Dn kernels,
> > where the assert statement is not compiled in). If the unpatched
> > xfs_inobt_max_size() is very unlikely to cause problems on such
> > systems, we might as well live with it.
>=20
> ...but it's unlikely to cause problems since the allocator will probably
> pass over that runt AG so long as the others have more space and it will
> mostly stay empty.

That makes me feel better, as we have many such systems.  Thanks for
the assessment of risks.

> (He says knocking on wood knowing that he's now tempted fate :P)

One reason more to apply the patch :)

Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--qL6YN2OI1pnKQLYZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXMnQyQAKCRBa2jVAMQCT
Dx34AJ9NyhXYVUyqoySS2hNOqAa8KZ6kugCgpYbWW/hYgHXAkP/j8LUBeGnNjY4=
=MEgY
-----END PGP SIGNATURE-----

--qL6YN2OI1pnKQLYZ--
