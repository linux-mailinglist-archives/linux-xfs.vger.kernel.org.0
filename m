Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EE0244FE9
	for <lists+linux-xfs@lfdr.de>; Sat, 15 Aug 2020 00:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgHNWlP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Aug 2020 18:41:15 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37129 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbgHNWlO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 18:41:14 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 94B706AC588;
        Sat, 15 Aug 2020 08:41:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k6iNo-0003qI-Rw; Sat, 15 Aug 2020 08:41:08 +1000
Date:   Sat, 15 Aug 2020 08:41:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 208907] New: [fstests generic/074 on xfs]: 5.7.10 fails
 with a hung task on
Message-ID: <20200814224108.GA13499@dread.disaster.area>
References: <bug-208907-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-208907-201763@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=bqOV6i347Ox7gBnLHPwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 14, 2020 at 06:43:18PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> Just ssh to kdevops-xfs and run:
> 
> cd /var/lib/xfstests/
> ./gendisks.sh -m
> ./check generic/074
> 
> Aug 14 18:27:34 kdevops-xfs-dev kernel: XFS (loop16): Mounting V5 Filesystem
> Aug 14 18:27:34 kdevops-xfs-dev kernel: XFS (loop16): Ending clean mount
> Aug 14 18:27:34 kdevops-xfs-dev kernel: xfs filesystem being mounted at
> /media/test supports timestamps until 2038 (0x7fffffff)
> Aug 14 18:28:16 kdevops-xfs-dev kernel: nvme nvme1: I/O 128 QID 2 timeout,
> aborting
> Aug 14 18:28:16 kdevops-xfs-dev kernel: nvme nvme1: Abort status: 0x4001
> Aug 14 18:28:47 kdevops-xfs-dev kernel: nvme nvme1: I/O 128 QID 2 timeout,
> reset controller

Hardware lost an IO. I'm guessing the error handling that reset the
controller failed to error out the bio the lost IO belonged to, so
XFS has hung waiting for it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
