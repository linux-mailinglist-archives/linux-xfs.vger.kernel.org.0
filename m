Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8868C6EC1E
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Jul 2019 23:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfGSVhm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Jul 2019 17:37:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfGSVhm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jul 2019 17:37:42 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 718443CA00;
        Fri, 19 Jul 2019 21:37:42 +0000 (UTC)
Received: from redhat.com (ovpn-123-79.rdu2.redhat.com [10.10.123.79])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1141851F09;
        Fri, 19 Jul 2019 21:37:41 +0000 (UTC)
Date:   Fri, 19 Jul 2019 16:37:40 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 204049] [xfstests generic/388]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
Message-ID: <20190719213740.GA31263@redhat.com>
References: <bug-204049-201763@https.bugzilla.kernel.org/>
 <bug-204049-201763-eo3Tgqh1ro@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-204049-201763-eo3Tgqh1ro@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 19 Jul 2019 21:37:42 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 19, 2019 at 09:29:04PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=204049
> 
> --- Comment #5 from Luis Chamberlain (mcgrof@kernel.org) ---
> (In reply to Luis Chamberlain from comment #4)
> > The crash observed on stable kernels can be fixed with commit 6958d11f77
> > ("xfs: don't trip over uninitialized buffer on extent read of corrupted
> > inode") merged on v5.1.
> > 
> > I can't reproduce the immediate panic on v5.1 with the
> > "xfs_reflink_normapbt" anymore, as such I believe this seems like a
> > regression, and you should be able to bisect to v5.1 as the good kernel.
> 
> Correction, it just took longer to crash. Same crash as in kz#204223 [0] on
> v5.1. That issue is still not fixed.

In my experience,
many iterations of g/388 will definitely ferret out elusive failures.
It's sometimes tough to distinguish between real problems and abheritions.

-Bill


> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204223
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
