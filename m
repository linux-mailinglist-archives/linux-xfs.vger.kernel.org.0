Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9374A55582
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 19:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfFYRH2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 13:07:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbfFYRH2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 13:07:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 396BA81120;
        Tue, 25 Jun 2019 17:07:28 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA7485D71B;
        Tue, 25 Jun 2019 17:07:27 +0000 (UTC)
Date:   Wed, 26 Jun 2019 01:12:48 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfs_info on block device and mountpoint
Message-ID: <20190625171248.GH30864@dhcp-12-102.nay.redhat.com>
References: <20190622153827.4448-1-zlang@redhat.com>
 <20190623214919.GD5387@magnolia>
 <20190624012103.GF30864@dhcp-12-102.nay.redhat.com>
 <20190625024546.GO15846@desktop>
 <20190625071639.GG30864@dhcp-12-102.nay.redhat.com>
 <20190625143616.GD5380@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625143616.GD5380@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 25 Jun 2019 17:07:28 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 25, 2019 at 07:36:16AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 25, 2019 at 03:16:39PM +0800, Zorro Lang wrote:
> > On Tue, Jun 25, 2019 at 10:45:46AM +0800, Eryu Guan wrote:
> > > On Mon, Jun 24, 2019 at 09:21:03AM +0800, Zorro Lang wrote:
> > > > On Sun, Jun 23, 2019 at 02:49:19PM -0700, Darrick J. Wong wrote:
> > > > > On Sat, Jun 22, 2019 at 11:38:27PM +0800, Zorro Lang wrote:
> > > > > > There was a bug, xfs_info fails on a mounted block device:
> > > > > > 
> > > > > >   # xfs_info /dev/mapper/testdev
> > > > > >   xfs_info: /dev/mapper/testdev contains a mounted filesystem
> > > > > > 
> > > > > >   fatal error -- couldn't initialize XFS library
> > > > > > 
> > > > > > xfsprogs has fixed it by:
> > > > > > 
> > > > > >   bbb43745 xfs_info: use findmnt to handle mounted block devices
> > > > > > 
> > > > > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > > > 
> > > > > Aha!  I remembered something -- xfs/449 already checks for consistency
> > > > > in the various xfs geometry reports that each command provides, so why
> > > > > not just add the $XFS_INFO_PROG $SCRATCH_DEV case at the end?
> > 
> > Hmm... But I hope the case can keep running xfs_info test even there're not
> > xfs_spaceman -c "info" or xfs_db -c "info", just skip these two steps. Due
> > to RHEL-7 has old xfsprogs, we'd like to cover bug on RHEL-7.
> > 
> > What do you think?
> 
> If there isn't an xfs_db -c info command then xfs_info <blockev> won't
> work because that's what it does internally.
> 
> Sooo unless you're backporting the new xfs_db info command to rhel7
> xfsprogs as well as the new xfs_info wrapper, the test ought to just
> _notrun on rhel7.

No, I'm not trying to test an unmount <blockdev>. I'm trying to run
xfs_info on a mounted <blockdev>.

There was a bug. RHEL-7 xfsprogs can get a mounted device info:

# xfs_growfs -p xfs_info -n /dev/mapper/home 
meta-data=/dev/mapper/home isize=512    agcount=4, agsize=47341056 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=189364224, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=92463, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


But RHEL-8.0 xfsprogs can't do that:

# xfs_info /dev/mapper/xfshome
xfs_info: /dev/mapper/xfshome contains a mounted filesystem

fatal error -- couldn't initialize XFS library

Thanks,
Zorro

> 
> --D
> 
> > > > 
> > > > Wow, there're so many cases, can't sure what we've covered now:)
> > > > 
> > > > Sure, I can do this change on xfs/449, if Eryu thinks it's fine to increase
> > > > the test coverage of a known case.
> > > 
> > > Given that we're having more and more tests and the test time grows
> > > quickly, I'm fine now with adding such small & similar test to existing
> > > test case to reuse the test setups, especially when XFS maintainer
> > > agrees to do so :)
> > > 
> > > Thanks,
> > > Eryu
