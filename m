Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204415C07A
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 17:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfGAPmV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 11:42:21 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58993 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbfGAPmV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Jul 2019 11:42:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45cs7Z1L7nz9s3Z;
        Tue,  2 Jul 2019 01:42:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561995738;
        bh=cKjt+D7w0RIO3MeUeoCcq1c6qBlW5HWwqMuUlp3y4L0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eVvt+xIPMTC0Js9hFSPelJefZgdDyGTKOkuwzP4PTY+yqVocSd+WJfGJWnPDTCHqg
         FLIcztyZFcBowSo9vHY9Oh5CiEV6mS2YwdU4xEGITjezfLSWlpHqYn2gQsv5CdVhgL
         fhKbD7kxkGno9eqm/IEJ2UlvRLVDgmIsp+BDHVZw/Du1zDdGtPPtfzY6y5IWzm78/v
         aq1M0BYfK9nzZepsLZjwEu/TBMRadaKIz4/jWIKfOVuIcKS93TBmT8ze61MdsdiPOl
         Ip50JnLaPO09+1lE3qfBpEiCeGoA7gZKus4diqlJFLHuJd6Hv2W9SopzDPGRhYjgAB
         1S2B6s4BgFQeA==
Date:   Tue, 2 Jul 2019 01:42:10 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Adding some trees to linux-next?
Message-ID: <20190702014210.1c95f9f1@canb.auug.org.au>
In-Reply-To: <20190701153552.GJ1404256@magnolia>
References: <20190701110603.5abcbb2c@canb.auug.org.au>
        <20190701153552.GJ1404256@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UN5Vxl1AFy.bml=FS8LPM8+"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/UN5Vxl1AFy.bml=FS8LPM8+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Darrick,

On Mon, 1 Jul 2019 08:35:52 -0700 "Darrick J. Wong" <darrick.wong@oracle.co=
m> wrote:
>
> Could you add my iomap-for-next and vfs-for-next branches to linux-next,
> please?  They can be found here:
>=20
> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#iomap-for-next
> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#vfs-for-next
>=20
> I've decided that trying to munge all that through the xfs for-next
> branch is too much insanity and splitting them up will help me prevent
> my head from falling off.

Just out of interest, do you intend to send these directly to Linus, or
via another tree?

--=20
Cheers,
Stephen Rothwell

--Sig_/UN5Vxl1AFy.bml=FS8LPM8+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0aKdIACgkQAVBC80lX
0Gznawf9HG3yAIa9ql5EEFzHWdjd0niap4Jw2Djgfi/AQ028W2dQ/j1Q86Vqw8Yi
enXmApWWoNL+SACY4chSua3MBE3s5VvZaaFbljtZVtUb7q7zAeDQCTG2SKBC99jW
4NB5XYMQKakDk1cPqmil6i+RrKQVolPPIH5AL/TunugCZ2dBcDPFk1RW4QO/8Vo+
DpIk1Bg3kWePgnmnmiyA8bx7PRuv9ftL35G/GCjdl2iGxySx/tpVkZONZ+QketqE
9bJSC5DMEpYE7opI/JBs9R8OSQmGNx0m2aYYaU5GCon60oQChZ97ebga9YME6zjZ
CSOaZHOZWut8qZSWDlT6HZxOkTkd8Q==
=cb/6
-----END PGP SIGNATURE-----

--Sig_/UN5Vxl1AFy.bml=FS8LPM8+--
