Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153E19E549
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2019 12:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfH0KET (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Aug 2019 06:04:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:43072 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbfH0KET (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 06:04:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1DD75AE91;
        Tue, 27 Aug 2019 10:04:18 +0000 (UTC)
Date:   Tue, 27 Aug 2019 12:04:16 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>, chrubis@suse.cz,
        ltp@lists.linux.it, linux-xfs@vger.kernel.org,
        Clemens Famulla-Conrad <cfamullaconrad@suse.de>
Subject: Re: [LTP] [PATCH v7 3/3] syscalls/copy_file_range02: increase
 coverage and remove EXDEV test
Message-ID: <20190827100416.GB17923@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190730110555.GB7528@rei.lan>
 <1564569629-2358-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <1564569629-2358-3-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <20190805065832.ti6vpoviykfaxcj7@XZHOUW.usersys.redhat.com>
 <5D47D6B9.9090306@cn.fujitsu.com>
 <20190805102211.pvyufepn6xywi7vm@XZHOUW.usersys.redhat.com>
 <20190806162703.GA1333@dell5510>
 <20190807101742.mt6tgowsh4xw5hyt@XZHOUW.usersys.redhat.com>
 <5D4B92EF.4090800@cn.fujitsu.com>
 <20190808035730.3kzors4trok6amtr@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808035730.3kzors4trok6amtr@XZHOUW.usersys.redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Murphy,

> On Thu, Aug 08, 2019 at 11:11:43AM +0800, Yang Xu wrote:
> > on 2019/08/07 18:17, Murphy Zhou wrote:

> > > And I have a question about LTP itself.

> > > If we run the testcase directly like:
> > > 	 ./testcases/kernel/syscalls/copy_file_range/copy_file_range02

> > > to test all_filesystems, for every filesystem, we mkfs and mount it in
> > > .mntpoint, but we do not chdir to .mntpoint. So we are running tests in 
> > > the same tmpdir, fs type of which does not change while looping
> > > all_filesystems.  Only the .mntpoint in tmpdir has different fs type in
> > > each loop.

> > > Now we are using this to test cross-device copy in copy_file_range01.c,
> > > but in copy_file_range02.c, we are not using .mntpint at all, all the
> > > tests in the all_filesystems loop are running in the same tmpdir. In other
> > > words, we are NOT testing all filesystems.

> > > Is this expected?
> >  I removed the mnted test for cross-device copy_file_range in copy_file_range02.c.
> > And I ignore the non-used mntpoint. IMO, we can directly use the FILE_MNTED to test EFBIG on all filesystems, 

> If mntpoint is not used, it makes absolutely NO sense to test all_filesystems.
Thanks for pointing this out. I was blind when reviewing this patchset.
At least this has been fixed.

> Because in the all_filesystems loop, various supported filesystems are
> created and mounted in mntpoint.

> And the copy_file_range tests happens outside of mntpoint. It just repeats
> the same test several times in the same tmpdir, fs type of which depends
> on /tmp configuration.

> When the log prints "testing ext2", it's not the truth.

> EFBIG is another issue.
Yep, we still need to think about different errnos, which depend on LTP policy
being defined [1].

> Thanks,
> Murphy

Kind regards,
Petr

[1] https://patchwork.ozlabs.org/patch/1143438/
