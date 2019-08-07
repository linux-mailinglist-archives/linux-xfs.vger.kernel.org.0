Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F2384B41
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Aug 2019 14:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387433AbfHGMNX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Aug 2019 08:13:23 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56000 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbfHGMNX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 08:13:23 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8D38B43DDBD;
        Wed,  7 Aug 2019 22:13:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hvKnc-00025G-GH; Wed, 07 Aug 2019 22:12:12 +1000
Date:   Wed, 7 Aug 2019 22:12:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Petr Vorel <pvorel@suse.cz>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>, chrubis@suse.cz,
        ltp@lists.linux.it, linux-xfs@vger.kernel.org
Subject: Re: [LTP] [PATCH v7 3/3] syscalls/copy_file_range02: increase
 coverage and remove EXDEV test
Message-ID: <20190807121212.GM7777@dread.disaster.area>
References: <20190730110555.GB7528@rei.lan>
 <1564569629-2358-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <1564569629-2358-3-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <20190805065832.ti6vpoviykfaxcj7@XZHOUW.usersys.redhat.com>
 <5D47D6B9.9090306@cn.fujitsu.com>
 <20190805102211.pvyufepn6xywi7vm@XZHOUW.usersys.redhat.com>
 <20190806162703.GA1333@dell5510>
 <20190807101742.mt6tgowsh4xw5hyt@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807101742.mt6tgowsh4xw5hyt@XZHOUW.usersys.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=gu9DDhuZhshYSb5Zs/lkOA==:117 a=gu9DDhuZhshYSb5Zs/lkOA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=f0VrTJKEscU-Eh1SCHsA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 07, 2019 at 06:17:42PM +0800, Murphy Zhou wrote:
> ccing linux-xfs@vger.kernel.org
> 
> Hi,
> 
> Tracked down this to be a xfs specific issue:
> 
> If we call copy_file_range with a large offset like this:
> 
> 	loff_t off = 9223372036854710270; // 2 ** 63
> 	ret = copy_file_range(fd_in, 0, fd_out, &off, 65537, 0);

That's not 2**63:

$ echo $((9223372036854710270 + 65537))
9223372036854775807

$ echo $((2**63 - 1))
9223372036854775807

i.e. it's LLONG_MAX, not an overflow. XFS sets sb->s_maxbytes in
xfs_max_file_offset to:

	(1 << BITS_PER_LONG - 1) - 1 = 2**63 - 1 = LLONG_MAX.

So no matter how we look at it, this operation should not return
EFBIG on XFS.

> (test programme cfrbig.c attached)
> 
> xfs has it done successfully, while ext4 returns EFBIG.

ext4 has a max file size of 2**32 * blocksize, so it doesn't support
files larger than 16TB. So it will give EFBIG on this test.

/me compiles and runs the test program on his workstation:

$ ls -l foobar
-rw------- 1 dave dave 10737418240 Apr 12 14:46 foobar
$ ./a.out foobar bar
ret 65537
$ ls -l bar
-rw-r--r-- 1 dave dave 9223372036854775807 Aug  7 22:11 bar
$

That looks like a successful copy to me, not EINVAL or EFBIG...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
