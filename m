Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590CB63F6D3
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Dec 2022 18:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiLARui (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Dec 2022 12:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiLARuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 12:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0EEC23F5;
        Thu,  1 Dec 2022 09:47:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ACB8B81FC8;
        Thu,  1 Dec 2022 17:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AEFC433D6;
        Thu,  1 Dec 2022 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669916830;
        bh=m8U7jzpzu8DJW/ApKPQ4QWEhOrKWuPWKtBOksh9rSCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ph3QEMLFncXejdNr5z9g4cpcey3J0FMTNhln42u6dAE93wivLVjex8vopTObja7qT
         F6dnxDuweldZENQyGtybNaQ5soUoqPbeKMh5Z14yzKNybs42cRRQaScTbzx/kTo0cO
         7BYpRtsxPkEZVobN5sBPck7l1c8q0S+G43yuu8k0gaL1R+9+EKuJOJ4iGLYUN6/Cks
         OoiCO+99nUqTZ2/bIO57ndK2zXILTScpAzIm3n9fi+SdeYsL0L1Ncy2/iX8dw3zacl
         BXJApdgogJ9SMBl6iFhPxh0/DOVPTe29NRRuZ7N5Hu75pDLJRHFbITbU91pKWl4b5i
         6n41DgI9QcoVg==
Date:   Thu, 1 Dec 2022 09:47:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] fsdax,xfs: fix warning messages
Message-ID: <Y4jonnIvY2F/dD9y@magnolia>
References: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
 <6386d512ce3fc_c9572944e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <Y4bZGvP8Ozp+4De/@magnolia>
 <638700ba5db1_c95729435@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <Y4fGRurfXoFSBqMB@magnolia>
 <bf1ef4da-de16-c6bb-7ef5-374c6ed197e2@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bf1ef4da-de16-c6bb-7ef5-374c6ed197e2@fujitsu.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2022 at 11:39:12PM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2022/12/1 5:08, Darrick J. Wong 写道:
> > On Tue, Nov 29, 2022 at 11:05:30PM -0800, Dan Williams wrote:
> > > Darrick J. Wong wrote:
> > > > On Tue, Nov 29, 2022 at 07:59:14PM -0800, Dan Williams wrote:
> > > > > [ add Andrew ]
> > > > > 
> > > > > Shiyang Ruan wrote:
> > > > > > Many testcases failed in dax+reflink mode with warning message in dmesg.
> > > > > > This also effects dax+noreflink mode if we run the test after a
> > > > > > dax+reflink test.  So, the most urgent thing is solving the warning
> > > > > > messages.
> > > > > > 
> > > > > > Patch 1 fixes some mistakes and adds handling of CoW cases not
> > > > > > previously considered (srcmap is HOLE or UNWRITTEN).
> > > > > > Patch 2 adds the implementation of unshare for fsdax.
> > > > > > 
> > > > > > With these fixes, most warning messages in dax_associate_entry() are
> > > > > > gone.  But honestly, generic/388 will randomly failed with the warning.
> > > > > > The case shutdown the xfs when fsstress is running, and do it for many
> > > > > > times.  I think the reason is that dax pages in use are not able to be
> > > > > > invalidated in time when fs is shutdown.  The next time dax page to be
> > > > > > associated, it still remains the mapping value set last time.  I'll keep
> > > > > > on solving it.
> > > > > > 
> > > > > > The warning message in dax_writeback_one() can also be fixed because of
> > > > > > the dax unshare.
> > > > > 
> > > > > Thank you for digging in on this, I had been pinned down on CXL tasks
> > > > > and worried that we would need to mark FS_DAX broken for a cycle, so
> > > > > this is timely.
> > > > > 
> > > > > My only concern is that these patches look to have significant collisions with
> > > > > the fsdax page reference counting reworks pending in linux-next. Although,
> > > > > those are still sitting in mm-unstable:
> > > > > 
> > > > > http://lore.kernel.org/r/20221108162059.2ee440d5244657c4f16bdca0@linux-foundation.org
> > > > > 
> > > > > My preference would be to move ahead with both in which case I can help
> > > > > rebase these fixes on top. In that scenario everything would go through
> > > > > Andrew.
> > > > > 
> > > > > However, if we are getting too late in the cycle for that path I think
> > > > > these dax-fixes take precedence, and one more cycle to let the page
> > > > > reference count reworks sit is ok.
> > > > 
> > > > Well now that raises some interesting questions -- dax and reflink are
> > > > totally broken on 6.1.  I was thinking about cramming them into 6.2 as a
> > > > data corruption fix on the grounds that is not an acceptable state of
> > > > affairs.
> > > 
> > > I agree it's not an acceptable state of affairs, but for 6.1 the answer
> > > may be to just revert to dax+reflink being forbidden again. The fact
> > > that no end user has noticed is probably a good sign that we can disable
> > > that without any one screaming. That may be the easy answer for 6.2 as
> > > well given how late this all is.
> > > 
> > > > OTOH we're past -rc7, which is **really late** to be changing core code.
> > > > Then again, there aren't so many fsdax users and nobody's complained
> > > > about 6.0/6.1 being busted, so perhaps the risk of regression isn't so
> > > > bad?  Then again, that could be a sign that this could wait, if you and
> > > > Andrew are really eager to merge the reworks.
> > > 
> > > The page reference counting has also been languishing for a long time. A
> > > 6.2 merge would be nice, it relieves maintenance burden, but they do not
> > > start to have real end user implications until CXL memory hotplug
> > > platforms arrive and the warts in the reference counting start to show
> > > real problems in production.
> > 
> > Hm.  How bad *would* it be to rebase that patchset atop this one?
> > 
> > After overnight testing on -rc7 it looks like Ruan's patchset fixes all
> > the problems AFAICT.  Most of the remaining regressions are to mask off
> > fragmentation testing because fsdax cow (like the directio write paths)
> > doesn't make much use of extent size hints.
> > 
> > > > Just looking at the stuff that's still broken with dax+reflink -- I
> > > > noticed that xfs/550-552 (aka the dax poison tests) are still regressing
> > > > on reflink filesystems.
> > > 
> > > That's worrying because the whole point of reworking dax, xfs, and
> > > mm/memory-failure all at once was to handle the collision of poison and
> > > reflink'd dax files.
> > 
> > I just tried out -rc7 and all three pass, so disregard this please.
> > 
> > > > So, uh, what would this patchset need to change if the "fsdax page
> > > > reference counting reworks" were applied?  Would it be changing the page
> > > > refcount instead of stashing that in page->index?
> > > 
> > > Nah, it's things like switching from pages to folios and shifting how
> > > dax goes from pfns to pages.
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-unstable&id=cca48ba3196
> > > 
> > > Ideally fsdax would never deal in pfns at all and do everything in terms
> > > of offsets relative to a 'struct dax_device'.
> > > 
> > > My gut is saying these patches, the refcount reworks, and the
> > > dax+reflink fixes, are important but not end user critical. One more
> > > status quo release does not hurt, and we can circle back to get this all
> > > straightened early in v6.3.
> > 
> > Being a data corruption fix, I don't see why we shouldn't revisit this
> > during the 6.2 cycle, even if it comes after merging the refcounting
> > stuff.
> > 
> > Question for Ruan: Would it be terribly difficult to push out a v2 with
> > the review comments applied so that we have something we can backport to
> > 6.1; and then rebase the series atop 6.2-rc1 so we can apply it to
> > upstream (and then apply the 6.1 version to the LTS)?  Or is this too
> > convoluted...?
> 
> It's fine to me.  V2 has been posted just now.  The big patch has been
> separated.

Ok, thank you.

Since akpm/Dan aren't moving forward with the page refcounting changes
for 6.2, I think I'll try to merge these fixes for 6.2-rc1 without so
much rebasing. :)

--D

> 
> --
> Thanks,
> Ruan.
> 
> > 
> > > I.e. just revert:
> > > 
> > > 35fcd75af3ed xfs: fail dax mount if reflink is enabled on a partition
> > > 
> > > ...for v6.1-rc8 and get back to this early in the New Year.
> > 
> > Hm.  Tempting.
> > 
> > --D
> > 
> > > > 
> > > > --D
> > > > 
> > > > > > Shiyang Ruan (2):
> > > > > >    fsdax,xfs: fix warning messages at dax_[dis]associate_entry()
> > > > > >    fsdax,xfs: port unshare to fsdax
> > > > > > 
> > > > > >   fs/dax.c             | 166 ++++++++++++++++++++++++++++++-------------
> > > > > >   fs/xfs/xfs_iomap.c   |   6 +-
> > > > > >   fs/xfs/xfs_reflink.c |   8 ++-
> > > > > >   include/linux/dax.h  |   2 +
> > > > > >   4 files changed, 129 insertions(+), 53 deletions(-)
> > > > > > 
> > > > > > -- 
> > > > > > 2.38.1
> > > 
> > > 
