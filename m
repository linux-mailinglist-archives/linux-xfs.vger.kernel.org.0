Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183873921D4
	for <lists+linux-xfs@lfdr.de>; Wed, 26 May 2021 23:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhEZVR5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 May 2021 17:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233321AbhEZVR4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 May 2021 17:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A76261157;
        Wed, 26 May 2021 21:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622063784;
        bh=uEXIFI+L4SKigKIAweO/cjr41FgRtohujauek92fRok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hst1KNnUY9lcj3qT6j5XE+yamkkUaMR14Ud4rB+OHolTQ1bf4NxrqlqUq99GcZuw2
         HmpIsXDBVvZpkrw0r2QFTo+pikM5CBKb+bwUqkEHE90GU78c6ohwT1Us81C5vaCahI
         TodFvqBrlZKP0CMBkCUgS9+/2fti+S15SSo+enyp3vcYupHrfpH2Q+OKyGQZHR5hxb
         cwk+ZIjZ7aWTZlidE39HU5Kxoo6Yo870MdqrQWsehiMplHRn8x+mSNOyc2eivUKexg
         HqGaJAHBakhfRF3fJoTk3wUTLGkeQyWPobFq1GUWBWnqUuVtyP7iahyhLhiNN9Fbt0
         /POv0zkmAlloA==
Date:   Wed, 26 May 2021 14:16:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        joe@perches.com
Subject: Re: [PATCH][next] xfs: Fix fall-through warnings for Clang
Message-ID: <20210526211624.GB202121@locust>
References: <20210420230652.GA70650@embeddedor>
 <20210420233850.GQ3122264@magnolia>
 <62895e8c-800d-fa7b-15f6-480179d552be@embeddedor.com>
 <bcae9d46-644c-d6f6-3df5-e8f7c50a673d@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcae9d46-644c-d6f6-3df5-e8f7c50a673d@embeddedor.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 26, 2021 at 01:21:06PM -0500, Gustavo A. R. Silva wrote:
> 
> 
> On 4/20/21 18:56, Gustavo A. R. Silva wrote:
> > 
> > 
> > On 4/20/21 18:38, Darrick J. Wong wrote:
> >> On Tue, Apr 20, 2021 at 06:06:52PM -0500, Gustavo A. R. Silva wrote:
> >>> In preparation to enable -Wimplicit-fallthrough for Clang, fix
> >>> the following warnings by replacing /* fall through */ comments,
> >>> and its variants, with the new pseudo-keyword macro fallthrough:
> >>>
> >>> fs/xfs/libxfs/xfs_alloc.c:3167:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/libxfs/xfs_da_btree.c:286:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/libxfs/xfs_ag_resv.c:346:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/libxfs/xfs_ag_resv.c:388:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_bmap_util.c:246:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_export.c:88:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_export.c:96:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_file.c:867:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_ioctl.c:562:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_ioctl.c:1548:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_iomap.c:1040:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_inode.c:852:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_log.c:2627:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/xfs_trans_buf.c:298:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/scrub/bmap.c:275:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/scrub/btree.c:48:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/scrub/common.c:85:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/scrub/common.c:138:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/scrub/common.c:698:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/scrub/dabtree.c:51:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>> fs/xfs/scrub/repair.c:951:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >>>
> >>> Notice that Clang doesn't recognize /* fall through */ comments as
> >>> implicit fall-through markings, so in order to globally enable
> >>> -Wimplicit-fallthrough for Clang, these comments need to be
> >>> replaced with fallthrough; in the whole codebase.
> >>>
> >>> Link: https://github.com/KSPP/linux/issues/115
> >>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> >>
> >> I've already NAKd this twice, so I guess I'll NAK it a third time.
> > 
> > Darrick,
> > 
> > The adoption of fallthrough; has been already accepted and in use since Linux v5.7:
> > 
> > https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> > 
> > This change is needed, and I would really prefer if this goes upstream through your tree.
> > 
> > Linus has taken these patches directly for a while, now.
> > 
> > Could you consider taking it this time? :)
> > 
> 
> Hi Darrick,
> 
> If you don't mind, I will take this in my -next[1] branch for v5.14, so we can globally enable
> -Wimplicit-fallthrough for Clang in that release.
> 
> We had thousands of these warnings and now we are down to 47 in next-20210526,
> 22 of which are fixed with this patch.

I guess we're all required to kowtow to a bunch of effing bots now.
Hooray for having to have a macro to code-switch for the sake of
stupid compiler writers who refuse to give the rest of us a single
workable way to signal "this switch code block should not end here":

/* fall through */
__attribute__((fallthrough));
do { } while (0) /* fall through */

and soon the ISO geniuses will make it worse by adding to C2x:

[[fallthrough]];

Hooray!  Macros to abstractify stupidity!!!!

Dave and I have told you and Miaohe several[1] times[2] to fix[3] the
compiler, but clearly you don't care what we think and have decided to
ram this in through Linus anyway.

Since that is what you choose, do not send me email again.

NAKed-by: Darrick J. Wong <djwong@kernel.org>

--D

[1] https://lore.kernel.org/linux-xfs/20200820191237.GK6096@magnolia/
[2] https://lore.kernel.org/linux-xfs/20210420230652.GA70650@embeddedor/
[3] https://lore.kernel.org/linux-xfs/20200708065512.GN2005@dread.disaster.area/

> 
> Thanks
> --
> Gustavo
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp
