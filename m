Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04ED45C0A3
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 17:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfGAPtu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 11:49:50 -0400
Received: from ozlabs.org ([203.11.71.1]:47459 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727373AbfGAPtu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Jul 2019 11:49:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45csJC5Q7Vz9s3Z;
        Tue,  2 Jul 2019 01:49:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561996187;
        bh=uYN0y0aQlZBTgN0OvRy1quf4Tph3kiuWeHujYKyUaAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L0jw6WvQosv77PO5PxCyIFnTxFLX77Lw6t7ErOWGoZjTGUPXHbWgEim0YTp9jgzkQ
         ABsODXtFxtD9yTOwqDMJb7G5sj2pgmM3v6cLkkdZ0XX2fx/JM/y1yfYadyi+JmcPVA
         hx7aDzpsC4X1AIq5Ne2vC1OjF6VWzINgg1zCzX67WCE+1rqzbfBF6hP/K/JRSJ1SQ4
         MW6eCWzD2nsZxLSrknJNoLvQhU99syiPisOpreGSHtfTRk9HS+lxa2v1aRBAkZ3fgq
         DiOHhmevMkxwizM8NeURxxE0XXRQSMOLmDHB0h0ovMlAaQVv/LXuTO5sMISNnncGCa
         Hxa4IMOTJSpoQ==
Date:   Tue, 2 Jul 2019 01:49:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Adding some trees to linux-next?
Message-ID: <20190702014944.79bd326a@canb.auug.org.au>
In-Reply-To: <20190701153552.GJ1404256@magnolia>
References: <20190701110603.5abcbb2c@canb.auug.org.au>
        <20190701153552.GJ1404256@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fev+fzqjHW.N7FIhhlClsrz"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/fev+fzqjHW.N7FIhhlClsrz
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

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/fev+fzqjHW.N7FIhhlClsrz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0aK5gACgkQAVBC80lX
0GwmMQf8CnI5xnqYrX8x9t5LBtRJq5gPcLukCc+FjM8GkphUoE/T8Xa2yPMyxnGs
6vpp/nGVX+UyYmvOkRbRNZfnIWY9WlBaXAfxK+If2jHjJy34Dmdm/yTu4WWgcCZu
Ji+/GSpH02b9J/Zn4DuVYymLtVLEPFgaWEVjWxm5nbYMgwrq6b+wMKvn2ybPHuOU
IDNFkRv33y1XN1o6m/AiMNK1J0ywcAJX3D4/qkUz4lAReQTPCZmWjAHbEBAVkOaL
2tdJcV03DFORsoiIzxYqEX5Sict5+r4Dph2nw5ysVPJ8Mz8DrZrj8btjhGJcXUq8
G+me/aG3McL+Js3NfdbaE/J25d8VqQ==
=lykB
-----END PGP SIGNATURE-----

--Sig_/fev+fzqjHW.N7FIhhlClsrz--
