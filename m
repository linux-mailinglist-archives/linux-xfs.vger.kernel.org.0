Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055F675366
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 18:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388426AbfGYQAa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 12:00:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387874AbfGYQA3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jul 2019 12:00:29 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C54630ADC81;
        Thu, 25 Jul 2019 16:00:29 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 422F760C05;
        Thu, 25 Jul 2019 16:00:29 +0000 (UTC)
Date:   Thu, 25 Jul 2019 12:00:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
Message-ID: <20190725160027.GB5221@bfoster>
References: <f7c3d69e-bbd4-244c-41d7-b03c923c5344@i-love.sakura.ne.jp>
 <20190725105350.GA5221@bfoster>
 <0f507f3d-eed0-f6b8-48fe-acc9fd872d6b@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f507f3d-eed0-f6b8-48fe-acc9fd872d6b@i-love.sakura.ne.jp>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 25 Jul 2019 16:00:29 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 09:30:01PM +0900, Tetsuo Handa wrote:
> On 2019/07/25 19:53, Brian Foster wrote:
> > This is a known problem. XFS delayed allocation has a window between
> > delalloc to real block conversion and writeback completion where stale
> > data exposure is possible if the writeback doesn't complete (i.e., due
> > to crash, I/O error, etc.). See fstests generic/536 for another
> > reference.  We've batted around potential solutions like using unwritten
> > extents for delalloc allocations, but IIRC we haven't been able to come
> > up with something with suitable performance to this point.
> > 
> > I'm curious why your OOM test results in writeback errors in the first
> > place. Is that generally expected? Does dmesg show any other XFS related
> > events, such as filesystem shutdown for example? I gave it a quick try
> > on a 4GB swapless VM and it doesn't trigger OOM. What's your memory
> > configuration and what does the /tmp filesystem look like ('xfs_info
> > /tmp')?
> 
> Writeback errors should not happen by just close-to-OOM situation.
> And there is no other XFS related events.
> 

Indeed, that is strange.

...
> 
> Kernel config is http://I-love.SAKURA.ne.jp/tmp/config-5.3-rc1 .
> 
> Below result is from a different VM which shows the same problem.
> 
> # xfs_info /tmp
> meta-data=/dev/sda1              isize=256    agcount=4, agsize=16383936 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0 spinodes=0
> data     =                       bsize=4096   blocks=65535744, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=31999, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 	

I ran your oom-torture.c (without the fs fill step) tool again after
dropping VM RAM to 3GB and still had to invoke some usemem (from
fstests) instances to consume memory before OOM triggered. I eventually
reproduced oom-torture OOM kills but did not reproduce writeback errors.
I've only run it once, but this is against a virtio vdisk backing
lvm+XFS in the guest. What is your target device here? Is it failing
independently by chance?

Brian

> 
> 
