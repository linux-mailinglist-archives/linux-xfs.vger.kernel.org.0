Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2979352416
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 09:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbfFYHLV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 03:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726856AbfFYHLV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 03:11:21 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7601C01DE89;
        Tue, 25 Jun 2019 07:11:20 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81FBD19723;
        Tue, 25 Jun 2019 07:11:19 +0000 (UTC)
Date:   Tue, 25 Jun 2019 15:16:39 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfs_info on block device and mountpoint
Message-ID: <20190625071639.GG30864@dhcp-12-102.nay.redhat.com>
References: <20190622153827.4448-1-zlang@redhat.com>
 <20190623214919.GD5387@magnolia>
 <20190624012103.GF30864@dhcp-12-102.nay.redhat.com>
 <20190625024546.GO15846@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625024546.GO15846@desktop>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 25 Jun 2019 07:11:20 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 25, 2019 at 10:45:46AM +0800, Eryu Guan wrote:
> On Mon, Jun 24, 2019 at 09:21:03AM +0800, Zorro Lang wrote:
> > On Sun, Jun 23, 2019 at 02:49:19PM -0700, Darrick J. Wong wrote:
> > > On Sat, Jun 22, 2019 at 11:38:27PM +0800, Zorro Lang wrote:
> > > > There was a bug, xfs_info fails on a mounted block device:
> > > > 
> > > >   # xfs_info /dev/mapper/testdev
> > > >   xfs_info: /dev/mapper/testdev contains a mounted filesystem
> > > > 
> > > >   fatal error -- couldn't initialize XFS library
> > > > 
> > > > xfsprogs has fixed it by:
> > > > 
> > > >   bbb43745 xfs_info: use findmnt to handle mounted block devices
> > > > 
> > > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > 
> > > Aha!  I remembered something -- xfs/449 already checks for consistency
> > > in the various xfs geometry reports that each command provides, so why
> > > not just add the $XFS_INFO_PROG $SCRATCH_DEV case at the end?

Hmm... But I hope the case can keep running xfs_info test even there're not
xfs_spaceman -c "info" or xfs_db -c "info", just skip these two steps. Due
to RHEL-7 has old xfsprogs, we'd like to cover bug on RHEL-7.

What do you think?

> > 
> > Wow, there're so many cases, can't sure what we've covered now:)
> > 
> > Sure, I can do this change on xfs/449, if Eryu thinks it's fine to increase
> > the test coverage of a known case.
> 
> Given that we're having more and more tests and the test time grows
> quickly, I'm fine now with adding such small & similar test to existing
> test case to reuse the test setups, especially when XFS maintainer
> agrees to do so :)
> 
> Thanks,
> Eryu
