Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238AD596C9C
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Aug 2022 12:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiHQKFq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 17 Aug 2022 06:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbiHQKFq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Aug 2022 06:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632093F336
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 03:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F31E061458
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 10:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C8FCC433C1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 10:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660730744;
        bh=F8/hS6azRz6CHqvUUwzTkEcppASD9br8FEgN8J1l4Z4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aiXNYFHyVrr9ggVJpabtWe7Rh7tTe5A45fZaSdOojSRsk+tlXsR5kuGkdG7AMIcj+
         ND8gZXYx2f6n+qrm13duoqaQ9wrvpIX9BkHPz6UojHxqbhLOQ/Z6ZtfFGz6dRus6Ov
         gxSDTLpcrNn+hNjQfBPOd/vB2MOX2rVrqCDdfH7EuRrWNTFSHsweuztVNelML8PSd7
         WWT/gfcbsJOckiRgJDlXH1TlMIx1i+poemTTU4HxSn5Z2670v6OmzN8l8K5TrOGNR/
         w8lbZfU9AuibR5rPSXTjWi0MyHNIB7eKVSsrPvKbY8McWjk9uglubsIbdZUb4sJqsp
         rAnF4eH1QyUCw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 39899C433E6; Wed, 17 Aug 2022 10:05:44 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Wed, 17 Aug 2022 10:05:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zhoukete@126.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216343-201763-sk71fw4i3o@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216343-201763@https.bugzilla.kernel.org/>
References: <bug-216343-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216343

--- Comment #5 from zhoukete@126.com ---
(In reply to Amir Goldstein from comment #4)

>=20
> According to xfs_trans_dirty_buf() I think it could mean uptodate and
> dirty buffer.
>=20

when I review the xfs_trans_dirty_buf code, I found that xfs inode item
b_log_item is null,

crash> xfs_log_item.li_buf,li_ops 0xffff0340999a0a80 -x
  li_buf =3D 0xffff0200125b7180
  li_ops =3D 0xffff800008faec60 <xfs_inode_item_ops>=20
crash> xfs_buf.b_log_item 0xffff0200125b7180
  b_log_item =3D 0x0

and only xfs buf log item b_log_item has value

crash> xfs_log_item.li_buf,li_ops ffff033f8d7c9de8 -x
  li_buf =3D 0x0
  li_ops =3D 0xffff800008fae8d8 <xfs_buf_item_ops>=20
crash> xfs_buf_log_item.bli_buf  ffff033f8d7c9de8
  bli_buf =3D 0xffff0200125b4a80
crash> xfs_buf.b_log_item 0xffff0200125b4a80
  b_log_item =3D 0xffff033f8d7c9de8
crash> xfs_buf_log_item.bli_flags 0xffff033f8d7c9de8
  bli_flags =3D 2     (XFS_BLI_DIRTY)
crash> xfs_buf_log_item.bli_item.li_flags  ffff033f8d7c9de8
  bli_item.li_flags =3D 1,  (XFS_LI_IN_AIL)

So xfs buf log item XFS_DONE is set because of xfs_trans_dirty_buf(),buf xfs
inode log item never call xfs_trans_dirty_buf() because of b_log_item =3D=
=3D 0x0.

Do  you know the reason why xfs inode log item XFS_DONE is set=EF=BC=9F

>=20
> Maybe the hardware never returned with a response?
> Hard to say. Maybe someone else has ideas.
>=20

If we can prove that XFS_DONE isn't stand for iodone, I think this issue may
cause by the hardware error.

I find the err msg in dmesg:
[ 9824.111366] mpt3sas_cm0: issue target reset: handle =3D (0x0034)=20=20

Maybe it tell us mpt3sas lost the io requests before.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
