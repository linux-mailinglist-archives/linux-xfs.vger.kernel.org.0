Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6B788403
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Aug 2023 11:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjHYJo1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Aug 2023 05:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbjHYJoN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 05:44:13 -0400
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B03719A1
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 02:44:08 -0700 (PDT)
Date:   Fri, 25 Aug 2023 09:43:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
        s=protonmail3; t=1692956646; x=1693215846;
        bh=e0tZ1MXNX78RGFjIe+SGvNOfl/5+qot1bY5+DP83/7E=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=m9NxbC1k0kzX+IsBcwn3sRbFO68T9s8GSPXiqtb30mAxRIdan6Z4JfFVw9xBtVmBc
         MvckV0q5Bbf279MhRqnHCEWjgL1S1fDs1RqLi8tlzgn/GaW4JYNBzFbxOjXyRgcXU6
         WiYt2DZnURsXBClr6RJNyqIvxwreBhQa1/AmXC+ETbOgiMFeAtcEMcAizzyvOTN3tD
         zwdqb1cGvKHyNS3/rK7BVBfbrNLOzSGXrFR7vMMsP5J8aKzZRJWJZ5DmBpB8ICtwgk
         5ks09qRYOf7KGT9pO7xmsfVu2gCrZyHxDKgW9EEQH+z/s4kejS6KuRZ8vKmhIfWJcp
         mBIoDhqbX7Q3Q==
To:     linux-xfs@vger.kernel.org
From:   Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsdump: for-next updated to 8e97f9c
Message-ID: <20230825094354.5em5f4tu5ahm4r5n@andromeda>
Feedback-ID: 28765827:user:proton
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------4b2fb183cb95a643ae7bbbe5f84b32426caf5737d7bd82444f32c7cb3159b36f"; charset=utf-8
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,TRACKER_ID
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------4b2fb183cb95a643ae7bbbe5f84b32426caf5737d7bd82444f32c7cb3159b36f
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Aug 2023 11:43:54 +0200
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsdump: for-next updated to 8e97f9c
Message-ID: <20230825094354.5em5f4tu5ahm4r5n@andromeda>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsdump for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

8e97f9c2b3c362fa6dd872d72594713c713479bc

1 new commits:

Donald Douwsma (1):
      [8e97f9c] xfsrestore: suggest -x rather than assert for false roots

Code Diffstat:

 restore/tree.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Carlos

--------4b2fb183cb95a643ae7bbbe5f84b32426caf5737d7bd82444f32c7cb3159b36f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmTod90JkOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AALUBAP9d0+DsoL3t2+P8OKeoYTR5T1D2ucn01CKG3EQXxlVHlwEA4l4a
fuI0LWoU/WQFKV51SFYVdgMMJpp6NJWa8CP82gE=
=Bj+h
-----END PGP SIGNATURE-----


--------4b2fb183cb95a643ae7bbbe5f84b32426caf5737d7bd82444f32c7cb3159b36f--

