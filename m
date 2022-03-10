Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCD24D4450
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Mar 2022 11:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiCJKNI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Mar 2022 05:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiCJKNH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 05:13:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B41108BC1
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 02:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7676B60AEE
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 10:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425BDC340E8;
        Thu, 10 Mar 2022 10:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646907125;
        bh=A6wBYUyUjktgEUv1h2nzXuRtAE0zOwbvgMf288qOkTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lahcdeaVEmShNo7bEEs9iHCQuZdwwze0tqa/RYKiA/ue/GKgUsfRpVt9rF2leJGzI
         5FnF6qURitsuigpSRyXyk6i+UEi78TodtS8CuTOwSGetXMAxVJpcwoWM/TQOjYhm4c
         GZy20Z7gHnVV7iQCK0xptd7Xfyz+saXhVkj9sdJ552CHHf+yHkC0+KIe1vFtsKRJ+m
         I0JeFvIrRKIjE3fj7Ct56Zwxdyu6uXwp8P1RvfFR9pKZe4kbp3iD3NO1qHauPLt+0B
         Y8KSQcQ3jNxLSP3webPvchRE/o934GYCCeguDe72nk6O0Co6EXBpVN+STVvRDXqval
         M5LWTa9G5ydWA==
Date:   Thu, 10 Mar 2022 11:11:58 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org,
        andrey.zhadchenko@virtuozzo.com, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: use setattr_copy to set vfs inode attributes
Message-ID: <20220310101158.atqf7grb2qz7a73o@wittgenstein>
References: <164685372611.495833.8601145506549093582.stgit@magnolia>
 <164685373184.495833.7593050602112292799.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <164685373184.495833.7593050602112292799.stgit@magnolia>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 11:22:11AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
> revocation isn't consistent with btrfs[1] or ext4.  Those two
> filesystems use the VFS function setattr_copy to convey certain
> attributes from struct iattr into the VFS inode structure.
> 
> Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
> decide if it should clear setgid and setuid on a file attribute update.
> This is a second symptom of the problem that Filipe noticed.
> 
> XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
> xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
> /not/ a simple copy function; it contains additional logic to clear the
> setgid bit when setting the mode, and XFS' version no longer matches.
> 
> The VFS implements its own setuid/setgid stripping logic, which
> establishes consistent behavior.  It's a tad unfortunate that it's
> scattered across notify_change, should_remove_suid, and setattr_copy but
> XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
> functions and get rid of the old functions.
> 
> [1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
> [2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/
> 
> Fixes: f736d93d76d3 ("xfs: support idmapped mounts")

Fwiw, as I've pointed out in
https://lore.kernel.org/linux-xfs/20220222122331.ijeapomur76h7xf6@wittgenstein/
the original analysis that this commit message links to in [2] is not
correct. But the thread clarifies it so I think it's fine.

But I think the fixes tag is wrong here afaict. As I've pointed out in
https://lore.kernel.org/linux-xfs/20220222123656.433l67bxhv3s2vbo@wittgenstein/
the faulty behavior should predate idmapped mounts by a lot. The bug is
with capable(CAP_FSETID). A simple reproducer that should work on any
pre 5.12 kernel is:

brauner@wittgenstein|~/src/git/linux/ltp/testcases/kernel/syscalls/chown|master %=
> unshare -U --map-root
root@wittgenstein|~/src/git/linux/ltp/testcases/kernel/syscalls/chown|master %=
> PATH=$PATH:$PWD ./chown02
tst_memutils.c:157: TWARN: Can't adjust score, even with capabilities!?
tst_test.c:1455: TINFO: Timeout per run is 0h 05m 00s
chown02.c:45: TPASS: chown(testfile1, 0, 0) passed
chown02.c:45: TPASS: chown(testfile2, 0, 0) passed
chown02.c:57: TFAIL: testfile2: wrong mode permissions 0100700, expected 0102700

Summary:
passed   2
failed   1
broken   0
skipped  0
warnings 1

There's no idmapped mounts here in play. The caller simply has been
placed in a new user namespace and thus they fail the current
capable(CAP_FSETID) check which will cause xfs to strip the sgid bit.

Now trying the same with ext4:

ubuntu@f2-vm:~/src/git/linux/ltp/testcases/kernel/syscalls/chown$ unshare -U --map-root
root@f2-vm:~/src/git/linux/ltp/testcases/kernel/syscalls/chown# PATH=$PATH:$PWD ./chown02
tst_memutils.c:157: TWARN: Can't adjust score, even with capabilities!?
tst_test.c:1455: TINFO: Timeout per run is 0h 05m 00s
chown02.c:45: TPASS: chown(testfile1, 0, 0) passed
chown02.c:45: TPASS: chown(testfile2, 0, 0) passed

Summary:
passed   2
failed   0
broken   0
skipped  0
warnings 1

it passes since ext4 uses setattr_copy() and thus the capability is
checked for in the caller's user namespace.

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Other than the wrong Fixes:,
Reviewed-by: Christian Brauner <brauner@kernel.org>
