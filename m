Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434BB240144
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Aug 2020 05:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHJD4L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Sun, 9 Aug 2020 23:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJD4L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 9 Aug 2020 23:56:11 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Mon, 10 Aug 2020 03:56:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208827-201763-QXsR1XFq3h@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208827-201763@https.bugzilla.kernel.org/>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208827

--- Comment #3 from Dave Chinner (david@fromorbit.com) ---
On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
> On Fri, Aug 07, 2020 at 03:12:03AM +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=208827
> > 
> > --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
> > On Thu, Aug 06, 2020 at 04:57:58AM +0000,
> bugzilla-daemon@bugzilla.kernel.org
> > wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=208827
> > > 
> > >             Bug ID: 208827
> > >            Summary: [fio io_uring] io_uring write data crc32c verify
> > >                     failed
> > >            Product: File System
> > >            Version: 2.5
> > >     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
> 
> FWIW, I can reproduce this with a vanilla 5.8 release kernel,
> so this isn't related to contents of the XFS dev tree at all...
> 
> In fact, this bug isn't a recent regression. AFAICT, it was
> introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
> reproduce. More info once I've finished bisecting it....

f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
commit f67676d160c6ee2ed82917fadfed6d29cab8237c
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Dec 2 11:03:47 2019 -0700

    io_uring: ensure async punted read/write requests copy iovec

    Currently we don't copy the iovecs when we punt to async context. This
    can be problematic for applications that store the iovec on the stack,
    as they often assume that it's safe to let the iovec go out of scope
    as soon as IO submission has been called. This isn't always safe, as we
    will re-copy the iovec once we're in async context.

    Make this 100% safe by copying the iovec just once. With this change,
    applications may safely store the iovec on the stack for all cases.

    Reported-by: 李通洲 <carter.li@eoitek.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

 fs/io_uring.c | 243 +++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 181 insertions(+), 62 deletions(-)

Full log:

$  git bisect log
git bisect start
# bad: [d5226fa6dbae0569ee43ecfc08bdcd6770fc4755] Linux 5.5
git bisect bad d5226fa6dbae0569ee43ecfc08bdcd6770fc4755
# good: [219d54332a09e8d8741c1e1982f5eae56099de85] Linux 5.4
git bisect good 219d54332a09e8d8741c1e1982f5eae56099de85
# good: [8c39f71ee2019e77ee14f88b1321b2348db51820] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
git bisect good 8c39f71ee2019e77ee14f88b1321b2348db51820
# good: [76bb8b05960c3d1668e6bee7624ed886cbd135ba] Merge tag 'kbuild-v5.5' of
git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild
git bisect good 76bb8b05960c3d1668e6bee7624ed886cbd135ba
# bad: [018e0e3594f7dcd029d258e368c485e742fa9cdb] habanalabs: rate limit error
msg on waiting for CS
git bisect bad 018e0e3594f7dcd029d258e368c485e742fa9cdb
# good: [ec939e4c94bd3ef2fd4f34c15f8aaf79bd0c5ee1] Merge tag 'armsoc-drivers'
of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect good ec939e4c94bd3ef2fd4f34c15f8aaf79bd0c5ee1
# good: [7c3ddc6b038feaa9a05b09c3f20e64fed50f9a3f] Merge tag
'ti-k3-soc-for-v5.5' of
git://git.kernel.org/pub/scm/linux/kernel/git/kristo/linux into arm/dt
git bisect good 7c3ddc6b038feaa9a05b09c3f20e64fed50f9a3f
# bad: [9feb1af97e7366b512ecb9e4dd61d3252074cda3] Merge tag
'for-linus-20191205' of git://git.kernel.dk/linux-block
git bisect bad 9feb1af97e7366b512ecb9e4dd61d3252074cda3
# good: [b08baef02b26cf7c2123e4a24a2fa1fb7a593ffb] Merge tag 'armsoc-defconfig'
of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect good b08baef02b26cf7c2123e4a24a2fa1fb7a593ffb
# good: [3f1266ec704d3efcfc8179c71bed9a75963b6344] Merge tag 'gfs2-for-5.5' of
git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2
git bisect good 3f1266ec704d3efcfc8179c71bed9a75963b6344
# bad: [bca1c43cb2dbe4212aea0793bfd91aeb4c2d184d] null_blk: remove unused
variable warning on !CONFIG_BLK_DEV_ZONED
git bisect bad bca1c43cb2dbe4212aea0793bfd91aeb4c2d184d
# bad: [5c4bd1f40c23d08ffbdccd68a5fd63751c794d89] null_blk: fix zone size
paramter check
git bisect bad 5c4bd1f40c23d08ffbdccd68a5fd63751c794d89
# bad: [03b1230ca12a12e045d83b0357792075bf94a1e0] io_uring: ensure async punted
sendmsg/recvmsg requests copy data
git bisect bad 03b1230ca12a12e045d83b0357792075bf94a1e0
# good: [490547ca2df66b8413bce97cb651630f2c531487] block: don't send uevent for
empty disk when not invalidating
git bisect good 490547ca2df66b8413bce97cb651630f2c531487
# bad: [f67676d160c6ee2ed82917fadfed6d29cab8237c] io_uring: ensure async punted
read/write requests copy iovec
git bisect bad f67676d160c6ee2ed82917fadfed6d29cab8237c
# good: [1a6b74fc87024db59d41cd7346bd437f20fb3e2d] io_uring: add general async
offload context
git bisect good 1a6b74fc87024db59d41cd7346bd437f20fb3e2d
# first bad commit: [f67676d160c6ee2ed82917fadfed6d29cab8237c] io_uring: ensure
async punted read/write requests copy iove
$

The bisect is good, but I've got no idea how this commit is
triggering page cache corruption on read IO....

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
