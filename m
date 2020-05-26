Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E671C4943
	for <lists+linux-xfs@lfdr.de>; Mon,  4 May 2020 23:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgEDVxM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 May 2020 17:53:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57536 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727071AbgEDVxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 17:53:11 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B961358C05D;
        Tue,  5 May 2020 07:53:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jVj1P-0008Ju-BP; Tue, 05 May 2020 07:53:07 +1000
Date:   Tue, 5 May 2020 07:53:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 00/17] xfs: flush related error handling cleanups
Message-ID: <20200504215307.GL2040@dread.disaster.area>
References: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504141154.55887-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=7k71l0T3oZIsjjbRGVQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 10:11:37AM -0400, Brian Foster wrote:
> Hi all,
> 
> I think everything has been reviewed to this point. Only minor changes
> noted below in this release. A git repo is available here[1].
> 
> The only outstanding feedback that I'm aware of is Dave's comment on
> patch 7 of v3 [2] regarding the shutdown assert check. I'm not aware of
> any means to get through xfs_wait_buftarg() with a dirty buffer that
> hasn't undergone the permanant error sequence and thus shut down the fs.

# echo 0 > /sys/fs/xfs/<dev>/fail_at_unmount

And now any error with a "retry forever" config (the default) will
be collected by xfs_buftarg_wait() without a preceeding shutdown as
xfs_buf_iodone_callback_error() will not treat it as a permanent
error during unmount. i.e. this doesn't trigger:

        /* At unmount we may treat errors differently */
        if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
                goto permanent_error;

and so the error handling just marks it with a write error and lets
it go for a write retry in future. These are then collected in
xfs_buftarg_wait() as nothing is going to retry them once unmount
gets to this point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
