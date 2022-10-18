Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A4D603420
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Oct 2022 22:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJRUoj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Oct 2022 16:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiJRUof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 16:44:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD88C19007
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 13:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5915FB82116
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 20:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1944DC43141
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 20:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666125867;
        bh=/50HYN7fhJUJXXzWDvSDxdtnWUWp92x8Kn4yGfgfFd0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iZCWr5epHusKCGjIHTA8afA8H4LBKAEtfYpAbTLSymW9nExzCDIJgbv9kobUF5sW8
         9xjBB0jRpoS3N0JI1flLq3184vhfoRaO7w3FfS7FYftbFX07TNeScHI4Qm8kraCCqw
         fAnknQzuXpVVDig3LsSqFPaZt0hrKhmnjBIQMcR7hwgGSZcnO0Ud9ae/JphZyVwaHC
         1GvNS/kBn38Q4sIwB44SxK3huliMVxflIwX4QaqojQTaVX4EjrcowMBpJwuLy4kZWl
         JTMrsYAYqARTAZfic5j3Sbp+RQTpQXgiHra281tc/NHzLs6HLVA8q4uaCImRUMpABy
         ynHHQWTYhBxSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 09837C05F8D; Tue, 18 Oct 2022 20:44:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216563] [xfstests generic/113] memcpy: detected field-spanning
 write (size 32) of single field "efdp->efd_format.efd_extents" at
 fs/xfs/xfs_extfree_item.c:693 (size 16)
Date:   Tue, 18 Oct 2022 20:44:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216563-201763-3vpUtdFzFb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216563-201763@https.bugzilla.kernel.org/>
References: <bug-216563-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216563

--- Comment #4 from Darrick J. Wong (djwong@kernel.org) ---
On Sun, Oct 09, 2022 at 10:42:29PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216563
>=20
> --- Comment #3 from Dave Chinner (david@fromorbit.com) ---
> On Sun, Oct 09, 2022 at 10:08:46AM -0700, Darrick J. Wong wrote:
> > On Sun, Oct 09, 2022 at 11:59:13AM +0000, bugzilla-daemon@kernel.org wr=
ote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D216563
> > >=20
> > >             Bug ID: 216563
> > >            Summary: [xfstests generic/113] memcpy: detected
> field-spanning
> > >                     write (size 32) of single field
> > >                     "efdp->efd_format.efd_extents" at
> > >                     fs/xfs/xfs_extfree_item.c:693 (size 16)
> > >            Product: File System
> > >            Version: 2.5
> > >     Kernel Version: v6.1-rc0
> > >           Hardware: All
> > >                 OS: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P1
> > >          Component: XFS
> > >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> > >           Reporter: zlang@redhat.com
> > >         Regression: No
> > >=20
> > > I xfstests generic/113 hit below kernel warning [1] on xfs with 64k
> > directory
> > > block size (-n size=3D65536). It's reproducible for me, and the last =
time I
> > > reproduce this bug on linux v6.0+ which HEAD=3D ...
> > >=20
> > > commit e8bc52cb8df80c31c73c726ab58ea9746e9ff734
> > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > Date:   Fri Oct 7 17:04:10 2022 -0700
> > >=20
> > >     Merge tag 'driver-core-6.1-rc1' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
> > >=20
> > > I hit this issue on xfs with 64k directory block size 3 times(aarch64,
> > x86_64
> > > and ppc64le), and once on xfs with 1k blocksize (aarch64).
> > >=20
> > >=20
> > > [1]
> > > [ 4328.023770] run fstests generic/113 at 2022-10-08 11:57:42
> > > [ 4330.104632] XFS (sda3): EXPERIMENTAL online scrub feature in use. =
Use
> at
> > > your own risk!
> > > [ 4333.094807] XFS (sda3): Unmounting Filesystem
> > > [ 4333.934996] XFS (sda3): Mounting V5 Filesystem
> > > [ 4333.973061] XFS (sda3): Ending clean mount
> > > [ 4335.457595] XFS (sda3): EXPERIMENTAL online scrub feature in use. =
Use
> at
> > > your own risk!
> > > [ 4338.564849] XFS (sda3): Unmounting Filesystem
> > > [ 4339.391848] XFS (sda3): Mounting V5 Filesystem
> > > [ 4339.430908] XFS (sda3): Ending clean mount
> > > [ 4340.100364] XFS (sda3): EXPERIMENTAL online scrub feature in use. =
Use
> at
> > > your own risk!
> > > [ 4343.379506] XFS (sda3): Unmounting Filesystem
> > > [ 4344.195036] XFS (sda3): Mounting V5 Filesystem
> > > [ 4344.232984] XFS (sda3): Ending clean mount
> > > [ 4345.190073] XFS (sda3): EXPERIMENTAL online scrub feature in use. =
Use
> at
> > > your own risk!
> > > [ 4348.198562] XFS (sda3): Unmounting Filesystem
> > > [ 4349.065061] XFS (sda3): Mounting V5 Filesystem
> > > [ 4349.104995] XFS (sda3): Ending clean mount
> > > [ 4350.118883] XFS (sda3): EXPERIMENTAL online scrub feature in use. =
Use
> at
> > > your own risk!
> > > [ 4353.233555] XFS (sda3): Unmounting Filesystem
> > > [ 4354.093530] XFS (sda3): Mounting V5 Filesystem
> > > [ 4354.135975] XFS (sda3): Ending clean mount
> > > [ 4354.337550] ------------[ cut here ]------------
> > > [ 4354.342354] memcpy: detected field-spanning write (size 32) of sin=
gle
> > field
> > > "efdp->efd_format.efd_extents" at fs/xfs/xfs_extfree_item.c:693 (size=
 16)
> > > [ 4354.355820] WARNING: CPU: 7 PID: 899243 at
> fs/xfs/xfs_extfree_item.c:693
> > > xfs_efi_item_relog+0x1fc/0x270 [xfs]
> >=20
> > I think this is caused by an EF[ID] with ef[id]_nextents > 1, since the
> > structure definition is:
> >=20
> > typedef struct xfs_efd_log_format {
> >       uint16_t                efd_type;       /* efd log item type */
> >       uint16_t                efd_size;       /* size of this item */
> >       uint32_t                efd_nextents;   /* # of extents freed */
> >       uint64_t                efd_efi_id;     /* id of corresponding ef=
i */
> >       xfs_extent_t            efd_extents[1]; /* array of extents freed=
 */
> > } xfs_efd_log_format_t;
> >=20
> > Yuck, an array[1] that is actually a VLA!
>=20
> Always been the case; the comment above both EFI and EFD definitions
> state this directly:
>=20
> /*
>  * This is the structure used to lay out an efi log item in the
>  * log.  The efi_extents field is a variable size array whose
>  * size is given by efi_nextents.
>  */
>=20
> The EFI/EFD support recording multiple extents being freed in a
> single intent. The idea behind this originally was that all the
> extents being freed in a single transaction would be recorded in the
> same EFI (i.e.  XFS_ITRUNC_MAX_EXTENTS) and the EFI and EFD could
> then be relogged as progress freeing those extents is made after the
> BMBT modifications were committed...
>=20
> > I guess we're going to have to turn that into a real VLA, and adjust the
> > xfs_ondisk.h macros to match?
> >=20
> > What memory sanitizer kconfig option enables this, anyway?
>=20
> 54d9469bc515 fortify: Add run-time WARN for cross-field memcpy()
>=20
> CONFIG_FORTIFY_SOURCE=3Dy, committed in 6.0-rc2.
>=20
> It effectively ignores flex arrays defined with [], but sees
> anything defined with [1] as a fixed size array of known size and so
> issues a warning when it's actually used as a flex array.
>=20
> unsafe_memcpy() could be a temporary solution, given we know the
> code works fine as it stands...

Annoyingly, this now triggers fstests failures on xfs/436 when log
recovery tries to memcpy a BUI log item:

------------[ cut here ]------------
memcpy: detected field-spanning write (size 48) of single field
"dst_bui_fmt" at fs/xfs/xfs_bmap_item.c:628 (size 16)
WARNING: CPU: 0 PID: 20925 at fs/xfs/xfs_bmap_item.c:628
xlog_recover_bui_commit_pass2+0x124/0x160 [xfs]

Here we're using struct xfs_map_extent bui_extents[] for the VLA, so I
think this means the memcpy fortify macros aren't detecting the VLAs
correctly at all.

--D

> Cheers,
>=20
> Dave.
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
