Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA854DD31
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 00:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfFTWHP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 18:07:15 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:54584 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfFTWHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 18:07:14 -0400
Received: from dread.disaster.area (pa49-195-189-25.pa.nsw.optusnet.com.au [49.195.189.25])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id BE3BA3DCB41;
        Fri, 21 Jun 2019 08:07:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1he5CA-0006sy-7P; Fri, 21 Jun 2019 08:06:14 +1000
Date:   Fri, 21 Jun 2019 08:06:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/11] xfsprogs: remove unneeded #includes
Message-ID: <20190620220614.GE26375@dread.disaster.area>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=K5LJ/TdJMXINHCwnwvH1bQ==:117 a=K5LJ/TdJMXINHCwnwvH1bQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=7-415B0cAAAA:8 a=z9mBUTKy4XBHfgIsgsIA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 20, 2019 at 04:29:23PM -0500, Eric Sandeen wrote:
> This is the result of a mechanical process and ... may have a few
> oddities, for example removing "init.h" from some utils made me
> realize that we inherit it from libxfs and also have it in local

We do? That'd be really, really broken if we did - including local
header files from a global header files is not a good idea.

/me goes looking, can't find where libxfs.h includes init.h

libxfs/init.h is private to libxfs/, it's not a global include file,
and it is included directly in all the libxfs/*.c files that need
it, which is 3 files - init.c, rdwr.c and util.c. 

> headers; libxfs has a global but so does scrub, etc.  So that stuff
> can/should be fixed up, but in the meantime, this zaps out a ton
> of header dependencies, and seems worthwhile.

IMO, this doesn't improve the tangle of header files in userspace.
All it does is make the include patterns inconsistent across files
because of the tangled mess of the libxfs/ vs include/ header files
that was never completely resolved when libxfs was created as a
shared kernel library....

IOWs, the include pattern I was originally aiming for with the
libxfs/ shared userspace/kernel library was:

#include "libxfs_priv.h"
<include shared kernel header files>

And for things outside libxfs/ that use libxfs:

#include "libxfs.h"
<include local header files>

IOWs, "libxfs_priv.h" contained the includes for all the local
userspace libxfs includes and defines and non-shared support
structures, and it would export on build all the header files that
external code needs to build into include/ via symlinks. This is
incomplete - stuff like include/xfs_mount.h, xfs_inode.h, etc needs
to move into libxfs as private header files (similar to how they are
private in the kernel) and then exported at build time.

Likewise, "libxfs.h" should only contain global include files and
those exported from libxfs, and that's all the external code should
include to use /anything/ from libxfs. i.e.  a single include forms
the external interface to libxfs.

AFAIC, nothing should be including platform or build dependent
things like platform_defs.h, because that should be pulled in by
libxfs.h or libxfs_priv.h. And nothing external should need to pull
in, say, xfs_format.h or xfs_mount.h, because they are all pulled in
by include/libxfs.h (which it mostly does already).

Hence I'd prefer we finish untangling the header file include mess
before we cull unneceesary includes. Otherwise we are going to end
up culling the wrong includes and then have to clean up that mess as
well to bring the code back to being clean and consistent....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
