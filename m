Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E33528147
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 17:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbfEWPdr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 11:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730752AbfEWPdr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 May 2019 11:33:47 -0400
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F43820868;
        Thu, 23 May 2019 15:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558625626;
        bh=eU0bc1TZXJmCh4tCLvIgnWjjGcWTvmqs3/XKWuOj0Rw=;
        h=Date:From:To:Cc:Subject:From;
        b=shr/vyPXYAf7BJng+NopCN58Hohj7ENBVhPVi2GBA2VGs+VphSTRmh0ameJkUHYn3
         oJH+bP8nYk7XtJbaWOjcSq8DYYmtzmCwuauXSXJcexTVGy5uhTC9ov76acb7V29ssW
         tLD/unmzEQvRKgj3Xcz09wXLokUckxgeuIChjGGI=
Date:   Thu, 23 May 2019 08:33:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Subject: [GIT PULL] xfs: fixes for 5.2
Message-ID: <20190523153346.GG5141@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Here's a bug fix for a minor accounting problem reported by a user.
It's survived a few days of fstests and merges cleanly with upstream as
of a few minutes ago.  Let me know if there are problems.

(Urgh, I just noticed that the tag message lists the wrong version.  If
that's going to be a problem I can retag and resend...)

--D

The following changes since commit a188339ca5a396acc588e5851ed7e19f66b0ebd9:

  Linux 5.2-rc1 (2019-05-19 15:47:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.2-fixes-1

for you to fetch changes up to 5cd213b0fec640a46adc5e6e4dfc7763aa54b3b2:

  xfs: don't reserve per-AG space for an internal log (2019-05-20 11:25:39 -0700)

----------------------------------------------------------------
Fixes for 5.1:
- Fix an accounting mistake where we included the log space when
  calculating the reserve space for metadata expansion.

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: don't reserve per-AG space for an internal log

 fs/xfs/libxfs/xfs_ialloc_btree.c   | 9 +++++++++
 fs/xfs/libxfs/xfs_refcount_btree.c | 9 +++++++++
 fs/xfs/libxfs/xfs_rmap_btree.c     | 9 +++++++++
 3 files changed, 27 insertions(+)
