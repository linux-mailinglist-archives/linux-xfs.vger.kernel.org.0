Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89D6112D98
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Dec 2019 15:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfLDOkl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Wed, 4 Dec 2019 09:40:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbfLDOkl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Dec 2019 09:40:41 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205703] [xfstests generic/461]: BUG: KASAN: use-after-free in
 iomap_finish_ioend+0x58c/0x5c0
Date:   Wed, 04 Dec 2019 14:40:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205703-201763-KSWBapBIZR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205703-201763@https.bugzilla.kernel.org/>
References: <bug-205703-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205703

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
(In reply to Darrick J. Wong from comment #1)
> Could you please post the source line translations of the iomap functions? 
> I don't have your kernel build.

I tryed to use the faddr2line tool, then it point to a printk_ratelimited()
function. I'm sure I didn't change the kernel source code, the current kernel
is installed from it. Is that something wrong?

# ./scripts/faddr2line vmlinux iomap_finish_ioend+0x58c
iomap_finish_ioend+0x58c/0x5c0:
iomap_finish_ioend at
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/iomap/buffered-io.c:1153

# ./scripts/faddr2line vmlinux iomap_finish_ioend+0x168
iomap_finish_ioend+0x168/0x5c0:
iomap_finish_ioend at
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/iomap/buffered-io.c:1133

   1124 static void
   1125 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
   1126 {
   1127         struct inode *inode = ioend->io_inode;
   1128         struct bio *bio = &ioend->io_inline_bio;
   1129         struct bio *last = ioend->io_bio, *next;
   1130         u64 start = bio->bi_iter.bi_sector;
   1131         bool quiet = bio_flagged(bio, BIO_QUIET);
   1132 
   1133         for (bio = &ioend->io_inline_bio; bio; bio = next) {
   1134                 struct bio_vec *bv;
   1135                 struct bvec_iter_all iter_all;
   1136 
   1137                 /*
   1138                  * For the last bio, bi_private points to the ioend, so
we
   1139                  * need to explicitly end the iteration here.
   1140                  */
   1141                 if (bio == last)
   1142                         next = NULL;
   1143                 else
   1144                         next = bio->bi_private;
   1145 
   1146                 /* walk each page on bio, ending page IO on them */
   1147                 bio_for_each_segment_all(bv, bio, iter_all)
   1148                         iomap_finish_page_writeback(inode, bv->bv_page,
error);
   1149                 bio_put(bio);
   1150         }
   1151 
   1152         if (unlikely(error && !quiet)) {
   1153                 printk_ratelimited(KERN_ERR
   1154 "%s: writeback error on inode %lu, offset %lld, sector %llu",
   1155                         inode->i_sb->s_id, inode->i_ino,
ioend->io_offset,
   1156                         start);
   1157         }
   1158 }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
