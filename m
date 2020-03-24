Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399B81917C9
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Mar 2020 18:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgCXRiQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Mar 2020 13:38:16 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:59688 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbgCXRiQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Mar 2020 13:38:16 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 30AE15474AC;
        Tue, 24 Mar 2020 13:38:15 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id B139360AFA0;
        Tue, 24 Mar 2020 13:38:14 -0400 (EDT)
Date:   Tue, 24 Mar 2020 18:38:19 +0100
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Pawan Prakash Sharma <pawanprakash101@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs duplicate UUID
Message-ID: <20200324183819.36aa5448@harpe.intellique.com>
In-Reply-To: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
References: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GXo9sssWeRPrkibaQ5kkKVO"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/GXo9sssWeRPrkibaQ5kkKVO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 24 Mar 2020 21:43:25 +0530
Pawan Prakash Sharma <pawanprakash101@gmail.com> =C3=A9crivait:

> Now, when I am creating a ZFS snapshot and ZFS clone and trying to
> mount the clone filesystem, I am getting duplicate UUID error and I am
> not able to moiunt it.
>=20

Did you try to mount it with the "nouuid" option?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/GXo9sssWeRPrkibaQ5kkKVO
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl56RYwACgkQX3jQXNUicVZmHACg+MvxwyR7nH9+R8vzBl2oYSp7
/6AAn2PQ3Mnn2dMy/A1sl+yin5B6JXsC
=KnkD
-----END PGP SIGNATURE-----

--Sig_/GXo9sssWeRPrkibaQ5kkKVO--
