Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F57B8047F
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Aug 2019 07:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfHCFg3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 3 Aug 2019 01:36:29 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41059 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726429AbfHCFg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Aug 2019 01:36:29 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C61EA43F38B;
        Sat,  3 Aug 2019 15:36:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1htmhK-00064n-2C; Sat, 03 Aug 2019 15:35:18 +1000
Date:   Sat, 3 Aug 2019 15:35:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Luciano ES <lucmove@gmail.com>
Cc:     XFS mailing list <linux-xfs@vger.kernel.org>
Subject: Re: XFS file system corruption, refuses to mount
Message-ID: <20190803053518.GQ7777@dread.disaster.area>
References: <20181211183203.7fdbca0f@lud1.home>
 <20190803011106.GJ7138@magnolia>
 <20190802225320.77b4b3c2@lud1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802225320.77b4b3c2@lud1.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=gu9DDhuZhshYSb5Zs/lkOA==:117 a=gu9DDhuZhshYSb5Zs/lkOA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=gMTaRVFpig5o6S-0yo0A:9 a=vFlidsJLMDoZ6EtM:21
        a=do8cOi8fgLDwmN2K:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 02, 2019 at 10:53:20PM -0300, Luciano ES wrote:
> On Fri, 2 Aug 2019 18:11:06 -0700, Darrick J. Wong wrote:
> 
> > On Fri, Aug 02, 2019 at 09:53:56PM -0300, Luciano ES wrote:
> > > I've had this internal disk running for a long time. I had to 
> > > disconnect it from the SATA and power plugs for two days. 
> > > Now it won't mount. 
> > > 
> > > mount: wrong fs type, bad option, bad superblock
> > > on /dev/mapper/cab3, missing codepage or helper program, or other
> > > error In some cases useful info is found in syslog - try
> > >        dmesg | tail or so.
> > > 
> > > I get this in dmesg:
> > > 
> > > [   30.301450] XFS (dm-1): Mounting V5 Filesystem
> > > [   30.426206] XFS (dm-1): Corruption warning: Metadata has LSN
> > > (16:367696) ahead of current LSN (16:367520). Please unmount and run
> > > xfs_repair (>= v4.3) to resolve.  
> > 
> > Hm, I think this means the superblock LSN is behind the log LSN, which
> > could mean that... software is buggy?  The disk didn't flush its cache
> > before it was unplugged?  Something else?

Given the difference in LSNs is only 176 sectors, it seems very
likely that the drive isn't honoring device flushes and so the log
writes that moved the tail haven't hit the disk before the metadata
which was issued after the log write completed...

What is the drive you are using (brand, model number age, etc)? What
is the output from demsg when the device is first discovered on
boot?

> > What kernel & xfsprogs?
> 
> Debian 4.9.0-3-amd64, xfsprogs 4.9.0.
> 
> 
> > And how did you disconnect it from the power plugs?
> 
> I shut down the machine, opened the box's cover and disconnected the 
> data and power cables. I used them on the CD/DVD drive, which I never 
> use but this time I had to. The hard disk drive remained quiet in its 
> bay. Then I shut down the machine and reconnected the cables to the 
> hard disk and this problem came up. I also tried another cable and 
> another SATA port, to no avail.
> 
> 
> > > [   30.426209] XFS (dm-1): log mount/recovery failed: error -22
> > > [   30.426310] XFS (dm-1): log mount failed
> > > 
> > > Note that the entire disk is encrypted with cryptsetup/LUKS, 
> > > which is working fine. Wrong passwords fail. The right password 
> > > opens it. But then it refuses to mount.
> > > 
> > > This has been happening a lot to me with XFS file systems. 
> > > Why is this happening?
> > > 
> > > Is there something I can do to recover the data?  
> > 
> > Try xfs_repair -n to see what it would do if you ran repair?
> 
> I tried and got this output:
> 
> 
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
> 
> attempting to find secondary superblock...

Unlock the encrypted device first? What does blkid tell you about
that device?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
