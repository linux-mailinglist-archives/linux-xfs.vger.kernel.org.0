Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB97223E5F9
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Aug 2020 04:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGCmV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Aug 2020 22:42:21 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:58300 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgHGCmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Aug 2020 22:42:21 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 07CDCD7CEF7;
        Fri,  7 Aug 2020 12:42:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k3sKh-0001Jk-Gh; Fri, 07 Aug 2020 12:42:11 +1000
Date:   Fri, 7 Aug 2020 12:42:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 208827] New: [fio io_uring] io_uring write data crc32c
 verify failed
Message-ID: <20200807024211.GG2114@dread.disaster.area>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-208827-201763@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=5rSYxMdFigoYx87TRuQA:9 a=d2odK2Q6lhk3acVR:21
        a=TNQTxYroACMm6mQ1:21 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=208827
> 
>             Bug ID: 208827
>            Summary: [fio io_uring] io_uring write data crc32c verify
>                     failed
>            Product: File System
>            Version: 2.5
>     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
> 
> Description of problem:
> Our fio io_uring test failed as below:
> 
> # fio io_uring.fio
> uring_w: (g=0): rw=randwrite, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB, (T)
> 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
> uring_sqt_w: (g=0): rw=randwrite, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
> (T) 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
> uring_rw: (g=0): rw=randrw, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB, (T)
> 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
> uring_sqt_rw: (g=0): rw=randrw, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
> (T) 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
> fio-3.21-39-g87622
> Starting 4 threads
> uring_w: Laying out IO file (1 file / 256MiB)
> uring_sqt_w: Laying out IO file (1 file / 256MiB)
> uring_rw: Laying out IO file (1 file / 256MiB)
> uring_sqt_rw: Laying out IO file (1 file / 256MiB)
> crc32c: verify failed at file /mnt/fio/uring_rw.0.0 offset 265289728, length
> 65536 (requested block: offset=265289728, length=65536)
>        Expected CRC: e8f1ef35
>        Received CRC: 9dd0deae
> fio: pid=46530, err=84/file:io_u.c:2108, func=io_u_queued_complete,

This looks like it's either a short read or it's page cache
corruption. I've confirmed that the data on disk is correct when the
validation fails, but the data in the page cache is not correct.

That is, when the fio verification fails, the second 32kB of the
64kB data block returned does not match the expected data to be
returned. Using the options:

verify_fatal=1
verify_dump=1

and getting rid of the "unlink=1" option from the config file
confirms that reading the data using xfs_io -c "pread -v <off> 64k"
returns the bad data.

Unmounting the filesystem and mounting it again (or using direct IO
to bypass the page cache), and repeating the xfs_io read returns
64kB of data identical to the expected data dump except for 16 bytes
in the block header that have some minor differences. I'm not sure
this is expected or not, but we can ignore it to begin with because
it is clear that there's exactly 8 pages of bad data in the page
cache in this range.

So, add:

verify=pattern
verify_pattern=%o

to have the buffer stamped with file offset data rather than random
data, and it turns out that the bad half of the buffer has an
incorrect file offset, but the offset in the entire range on disk is
correct.

Ok, so now I have confirmed that the data is valid on disk, but
incorrect in cache. That means the buffered write did contain
correct data in the cache, and that it was written to disk
correctly. So some time between the writeback completing and the
data being read, we've ended up with stale data in the page
cache....

This corruption only appears to happen with io_uring based buffered
IO - syscall based buffered IO and buffered IO with AIO doesn't
trigger it at all. Hence I suspect there is bug somewhere in the
io_uring code or in a code path that only the io_uring code path
tickles.

I can't really make head or tail of the io_uring code and there's no
obvious way to debug exactly what the user application is asking the
filesystem to do or what the kernel it returning to the filesytsem
(e.g. strace doesn't work). Hence I suspect that this needs the
io_uring folk to look at it and isolate it down to the operation
that is corrupting the page cache. I'd love to know how we are
can triage issues like this in the field given the tools we
normally use to triage and debug data corruption issues seem to be
largely useless...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
