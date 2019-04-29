Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DF7DA5A
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Apr 2019 03:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfD2BsS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 28 Apr 2019 21:48:18 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51046 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726439AbfD2BsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Apr 2019 21:48:18 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D0160436D32;
        Mon, 29 Apr 2019 11:48:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hKvOv-0005D2-Qx; Mon, 29 Apr 2019 11:48:13 +1000
Date:   Mon, 29 Apr 2019 11:48:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfs: add online scrub for superblock counters
Message-ID: <20190429014813.GH29573@dread.disaster.area>
References: <20190428221006.GD5217@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428221006.GD5217@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=oexKYjalfGEA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=vgDM6veGKsp23-dlLtMA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 28, 2019 at 03:10:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach online scrub how to check the filesystem summary counters.  We use
> the incore delalloc block counter along with the incore AG headers to
> compute expected values for fdblocks, icount, and ifree, and then check
> that the percpu counter is within a certain threshold of the expected
> value.  This is done to avoid having to freeze or otherwise lock the
> filesystem, which means that we're only checking that the counters are
> fairly close, not that they're exactly correct.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks OK, the variance checking seems a lot better for both small
and large filesystems.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
