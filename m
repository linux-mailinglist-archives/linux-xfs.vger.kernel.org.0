Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0ADB1A3D90
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Apr 2020 03:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDJBBH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Apr 2020 21:01:07 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57692 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgDJBBH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 21:01:07 -0400
Received: from dread.disaster.area (pa49-180-167-53.pa.nsw.optusnet.com.au [49.180.167.53])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 68F383A3C08;
        Fri, 10 Apr 2020 11:01:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jMi2X-0006FQ-OF; Fri, 10 Apr 2020 11:01:01 +1000
Date:   Fri, 10 Apr 2020 11:01:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: stop CONFIG_XFS_DEBUG from changing compiler flags
Message-ID: <20200410010101.GV24067@dread.disaster.area>
References: <20200409080909.3646059-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409080909.3646059-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=2xmR08VVv0jSFCMMkhec0Q==:117 a=2xmR08VVv0jSFCMMkhec0Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=VK9ohqNZyv40iBll5AsA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22 a=pHzHmUro8NiASowvMSCR:22
        a=nt3jZW36AmriUCFCBwmW:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 09, 2020 at 10:08:56AM +0200, Arnd Bergmann wrote:
> I ran into a linker warning in XFS that originates from a mismatch
> between libelf, binutils and objtool when certain files in the kernel
> are built with "gcc -g":
> 
> x86_64-linux-ld: fs/xfs/xfs_trace.o: unable to initialize decompress status for section .debug_info
> 
> After some discussion, nobody could identify why xfs sets this flag
> here. CONFIG_XFS_DEBUG used to enable lots of unrelated settings, but
> now its main purpose is to enable extra consistency checks and assertions
> that are unrelated to the debug info.

I'm pretty sure it was needed for the original kgdb integration back
in the early 2000s. That was when SGI used to patch their XFS dev
tree with kgdb and debug symbols were needed by the custom kgdb
modules that were ported across from the Irix kernel debugger.

ISTR that the early kcrash kernel dump analysis tools (again,
originated from the Irix "icrash" kernel dump tools) had custom XFS
debug scripts that needed also the debug info to work correctly...

Which is a long way of saying "we don't need it anymore" instead of
"nobody knows why it was set"... :)

With an update to commit message:

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
